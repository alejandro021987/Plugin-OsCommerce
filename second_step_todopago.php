<?php
/*
  $Id$
  osCommerce, Open Source E-Commerce Solutions
  http://www.oscommerce.com
  Copyright (c) 2014 osCommerce
  Released under the GNU General Public License
*/

  require('includes/application_top.php');

    $order_id = $_GET['Order'];

// if the customer is not logged on, redirect them to the shopping cart page
 /* if (!tep_session_is_registered('customer_id')) {
    tep_redirect(tep_href_link(FILENAME_SHOPPING_CART));
  }

  $orders_query = tep_db_query("select orders_id from " . TABLE_ORDERS . " where customers_id = '" . (int)$customer_id . "' order by date_purchased desc limit 1");

  $orders = tep_db_fetch_array($orders_query);
  $order_id = $orders['orders_id'];*/

  require_once('includes/modules/payment/todopagoplugin/includes/TodoPago/lib/Sdk.php'); include_once(DIR_WS_INCLUDES.'modules'.DIRECTORY_SEPARATOR.'payment'.DIRECTORY_SEPARATOR.'todopagoplugin'.DIRECTORY_SEPARATOR.'includes'.DIRECTORY_SEPARATOR.'TodopagoTransaccion.php');
        $todopagoTransaccion = new TodopagoTransaccion();
    include_once("includes/modules/payment/todopagoplugin/includes/TodoPagoLogger.php");
    $logger = new TodoPagoLogger($order_id);
    
    if($todopagoTransaccion->_getStep($order_id) == TodopagoTransaccion::SECOND_STEP){
    $logger->writeLog("second step");

// redirect to shopping cart page if no orders exist
//  if ( !tep_db_num_rows($orders_query) ) {
//    tep_redirect(tep_href_link(FILENAME_SHOPPING_CART));
//  }

//  $orders = tep_db_fetch_array($orders_query);
//  $order_id = $orders['orders_id'];

// unregister session variables used during checkout
  tep_session_unregister('sendto');
  tep_session_unregister('billto');
  tep_session_unregister('shipping');
  tep_session_unregister('payment');
  tep_session_unregister('comments');
  
  $todoPagoConfig = tep_db_query('SELECT * FROM todo_pago_configuracion');
  $todoPagoConfig = tep_db_fetch_array($todoPagoConfig);
    
    if ($todoPagoConfig['ambiente'] == "test"){
        $mode = "test";
        $security =  $todoPagoConfig['test_security'];
        $merchant = $todoPagoConfig['test_merchant'];
    }
    else{
        $mode = "prod";
        $security =  $todoPagoConfig['production_security'];
        $merchant = $todoPagoConfig['production_merchant'];
    }

    
//    $customer = tep_db_query('SELECT * FROM '.TABLE_CUSTOMERS.' WHERE customers_id ='.$customer_id);
//    $customer = tep_db_fetch_array($customer);
    
    $auth = json_decode($todoPagoConfig['authorization'], 1);
    $todoPagoParams = json_decode($todoPagoParams, 1);

    $http_header = array('Authorization'=>  $auth['Authorization'],
                            'user_agent' => 'PHPSoapClient');
    
    
    $requestKey = $_COOKIE['RequestKey'];
    $answerKey = $_GET['Answer'];
    
    $optionsGAA = array (     
    
        'Security'   => $security,      
        'Merchant'   => $merchant,     
        'RequestKey' => $requestKey,       
        'AnswerKey'  => $answerKey    
    );
    
    $connector = new TodoPago\Sdk($auth, $mode);
    
$logger->writeLog("params GAA", $optionsGAA);
    $rta2 = $connector->getAuthorizeAnswer($optionsGAA);
$logger->writeLog("response GAA", $rta2);
    
    if ($rta2['StatusCode']== -1){
    
    $todopagoTransaccion->recordSecondStep($order_id, $optionsGAA, $rta2);
        if ($rta2['Payload']['Answer']['PAYMENTMETHODNAME'] == 'PAGOFACIL' || $rta2['Payload']['Answer']['PAYMENTMETHODNAME']== 'RAPIPAGO' ){
    
             tep_db_query('UPDATE '.TABLE_ORDERS.' SET orders_status = '.$todoPagoConfig['estado_offline'].' WHERE orders_id = '.$order_id);
        }
        else{
    
             tep_db_query('UPDATE '.TABLE_ORDERS.' SET orders_status = '.$todoPagoConfig['estado_aprobada'].' WHERE orders_id = '.$order_id);
        }
  
  $cart->reset(true);
  
  
  $page_content = $oscTemplate->getContent('checkout_success');

  if ( isset($HTTP_GET_VARS['action']) && ($HTTP_GET_VARS['action'] == 'update') ) {
    tep_redirect(tep_href_link(FILENAME_DEFAULT));
  }

  require(DIR_WS_LANGUAGES . $language . '/' . FILENAME_CHECKOUT_SUCCESS);

  $breadcrumb->add(NAVBAR_TITLE_1);
  $breadcrumb->add(NAVBAR_TITLE_2);

  require(DIR_WS_INCLUDES . 'template_top.php');
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
    $optionsGS = array('MERCHANT'=> $merchant, 'OPERATIONID'=>$order_id); 

    $status = $connector->getStatus($optionsGS);   
    $logo = HTTP_SERVER.DIR_WS_CATALOG.'includes/modules/payment/todopagoplugin/includes/todopago.jpg';
    
    if (!isset($status['Operations']['CARDNUMBER'])){

        if (isset($status['Operations']['BARCODE'])){
    
            $barcode = $status['Operations']['BARCODE'];
            $barcode = 123456;
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
    }
    
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
else{
    $logger->writeLog("No se puede entrar al second step porque ya se ha registrado una entrada exitosa en la tabla todopago_transaccion");
     tep_redirect(tep_href_link(FILENAME_SHOPPING_CART));
}
?>