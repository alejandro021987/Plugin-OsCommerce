<?php
/*
  $Id$
  osCommerce, Open Source E-Commerce Solutions
  http://www.oscommerce.com
  Copyright (c) 2014 osCommerce
  Released under the GNU General Public License
*/

    //include_once("includes/modules/payment/todopagoplugin/includes/TodoPagoLogger.php");
require_once("includes/modules/payment/todopagoplugin/includes/todopago_ctes.php");
require_once("includes/modules/payment/todopagoplugin/includes/Logger/loggerFactory.php");
require('includes/application_top.php');
require_once('includes/modules/payment/todopagoplugin/includes/TodoPago/lib/Sdk.php');
require_once('includes/modules'.DIRECTORY_SEPARATOR.'payment'.DIRECTORY_SEPARATOR.'todopagoplugin'.DIRECTORY_SEPARATOR.'includes'.DIRECTORY_SEPARATOR.'TodopagoTransaccion.php');
require_once('includes/languages/'.$language.'/'.FILENAME_CHECKOUT_SUCCESS);
require_once('includes/template_top.php');

function second_step_todopago() {
    global $todopagoTransaccion;

    $order_id = (isset($_GET['Order']) && is_numeric($_GET['Order'])) ? $_GET['Order'] : null;
    $todopagoTransaccion = new TodopagoTransaccion();
    
    $response = callGAA($order_id);
    if($response) {
        take_action($response, $order_id);
    }
}

function _unregisterSessionVars(){
// unregister session variables used during checkout
  tep_session_unregister('sendto');
  tep_session_unregister('billto');
  tep_session_unregister('shipping');
  tep_session_unregister('payment');
  tep_session_unregister('comments');
}
  
function _recollect_data($order_id) {
    global $customer_id, $todopagoTransaccion, $todoPagoConfig;

    $todoPagoConfig = tep_db_query('SELECT * FROM todo_pago_configuracion');
    $todoPagoConfig = tep_db_fetch_array($todoPagoConfig);
    
    if ($todoPagoConfig['ambiente'] == "test") {
        $mode = "test";
        $security =  $todoPagoConfig['test_security'];
        $merchant = $todoPagoConfig['test_merchant'];
    } else {
        $mode = "prod";
        $security =  $todoPagoConfig['production_security'];
        $merchant = $todoPagoConfig['production_merchant'];
    }
    $logger = loggerFactory::createLogger(true, $mode, $customer_id, $order_id);
    $logger->debug('todoPagoConfig: '.json_encode($todoPagoConfig));
    if ($order_id !== null && $todopagoTransaccion->_getStep($order_id) == TodopagoTransaccion::SECOND_STEP) {

        $logger->info("second step");

        $auth = json_decode($todoPagoConfig['authorization'], 1);

        $http_header = array('Authorization'=>  $auth['Authorization'],
                                'user_agent' => 'PHPSoapClient');


        $transaction = $todopagoTransaccion->getTransaction($order_id);
        $requestKey = $transaction['request_key'];
        $answerKey = $_GET['Answer'];

        $optionsGAA = array (
            'Security'   => $security,
            'Merchant'   => $merchant,
            'RequestKey' => $requestKey,
            'AnswerKey'  => $answerKey
        );
        return array('authorization'=> $auth, 'mode'=> $mode, 'params'=> $optionsGAA, 'logger'=> $logger);
    }

    $logger->warn("No se puede entrar al second step porque ya se ha registrado una entrada exitosa en la tabla todopago_transaccion o el Order id no ha llegado correctamente");
    tep_redirect(tep_href_link(FILENAME_SHOPPING_CART));
    return false;
}
                 
function callGAA($order_id) {
    $dataGAA = _recollect_data($order_id);

    if($dataGAA) {
        $logger = $dataGAA['logger'];

        $connector = new TodoPago\Sdk($dataGAA['authorization'], $dataGAA['mode']);

        $logger->info("params GAA: ".json_encode($dataGAA['params']));
        $rta2 = $connector->getAuthorizeAnswer($dataGAA['params']);
        $logger->info("response GAA: ".json_encode($rta2));
        return array('rta' => $rta2, 'logger' => $logger, 'optionsGAA' => $dataGAA['params']);
    }

    return false;
}
    
function take_action($data, $order_id) {
    global $todopagoTransaccion, $todoPagoConfig, $cart, $oscTemplate, $breadcrumb;

    if ($data['rta']['StatusCode'] == TP_STATUS_OK) {
    
        $todopagoTransaccion->recordSecondStep($order_id, $data['optionsGAA'], $data['rta']);
        $data['logger']->debug("todoPagoConfig en take_action: ".json_encode($todoPagoConfig));
        if ($data['rta']['Payload']['Answer']['PAYMENTMETHODNAME'] == 'PAGOFACIL' || $data['rta']['Payload']['Answer']['PAYMENTMETHODNAME']== 'RAPIPAGO' ){
             tep_db_query('UPDATE '.TABLE_ORDERS.' SET orders_status = '.$todoPagoConfig['estado_offline'].' WHERE orders_id = '.$order_id);
        }
        else {
    
             tep_db_query('UPDATE '.TABLE_ORDERS.' SET orders_status = '.$todoPagoConfig['estado_aprobada'].' WHERE orders_id = '.$order_id);
        }
  
  $cart->reset(true);
  
  
  $page_content = $oscTemplate->getContent('checkout_success');

  if ( isset($HTTP_GET_VARS['action']) && ($HTTP_GET_VARS['action'] == 'update') ) {
    tep_redirect(tep_href_link(FILENAME_DEFAULT));
  }


  $breadcrumb->add(NAVBAR_TITLE_1);
  $breadcrumb->add(NAVBAR_TITLE_2);

?>

<h1><?php echo HEADING_TITLE; ?></h1>

<?php echo tep_draw_form('order', tep_href_link(FILENAME_CHECKOUT_SUCCESS, 'action=update', 'SSL')); ?>

<div class="contentContainer">
  <?php echo $page_content; ?>
</div>

<div class="contentContainer">
  <div class="buttonSet">
  
    <span class="buttonAction"><?php echo tep_draw_button(IMAGE_BUTTON_CONTINUE, 'triangle-1-e', null, 'primary'); ?></span>
    <div>
    <?php
    
    $params = "";
    // Codigo para el barcode.. cambiar.
    /*$optionsGS = array('MERCHANT'=> $merchant, 'OPERATIONID'=>$order_id);
    $status = $connector->getStatus($optionsGS);
    if (!isset($status['Operations']['CARDNUMBER'])){
        $params = _prepareBarcode($status, $order_id);
    }*/
    $logo = HTTP_SERVER.DIR_WS_CATALOG.'includes/modules/payment/todopagoplugin/includes/todopago.jpg';


    echo " <div><img src='".$logo."' title='todo pago'  /></div>"  ; 
    if ($params != ""){
    ?>
        <a target="_blank" href="<?php echo HTTP_SERVER.DIR_WS_CATALOG.'/ext/modules/payment/todopago/print_cupon.php?params='.base64_encode($params)?>">
       Para descargar el cup&oacute;n de pago haga click aqu&iacute;
        </a>
    <?php } ?>
    </div>
  </div>
</div>
</form>
<?php
  require(DIR_WS_INCLUDES . 'template_bottom.php');
  require(DIR_WS_INCLUDES . 'application_bottom.php');
        
    } 
        else{
            tep_redirect(tep_href_link('checkout_shipping_retry.php'));
        }
}
                                           
/*function _prepareBarcode($status, $order_id) {
    //TODO: cambiar $status por $rta2 y buscar los datos como correspone a la esructura de ducha rta
    $params = "";
    if (isset($rta2['Payload']['Answer']['BARCODE'])){
    
            $barcode = $rta2['Payload']['Answer']['BARCODE'];
            //$barcode = 123456;
            if($barcode != ""){
                
                if (isset($status['Operations']['AMOUNT'])){
                    $amount =    $status['Operations']['AMOUNT'];
                }
                if (isset($status['Operations']['OPERATIONID'])){
                    $operationid =    $status['Operations']['OPERATIONID'];
                }
                
                $bartype = $rta2['Payload']['Answer']['BARCODETYPE'];
                $name =  $customer['customers_firstname'] . ' ' . $customer['customers_lastname'];
                
                
                $params = 'name='.$name.'&orden='.$order_id.'&amount='.$amount.'&logo='.$logo.'&filetype=PNG&dpi=72&scale=2&rotation=0&font_family=Arial.ttf&font_size=8&text='.$barcode.'&thickness=30&checksum=&code='.$bartype.'';
            }
        }
    return $params;
}*/
    
        _unregisterSessionVars(); //Necesario para el framework
        second_step_todopago();
