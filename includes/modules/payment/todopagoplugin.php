<?php
/*
osCommerce, Open Source E-Commerce Solutions
http://www.oscommerce.com
Copyright (c) 2003 osCommerce
Released under the GNU General Public License
*/

set_include_path(get_include_path() . PATH_SEPARATOR . realpath(dirname(__FILE__)));
require_once dirname(__FILE__).'/todopagoplugin/includes/TodoPago/lib/Sdk.php';
include_once dirname(__FILE__).'/todopagoplugin/includes/phone.php';
define('TABLE_TP_ATRIBUTOS' , 'todo_pago_atributos');
define('TABLE_TP_CONFIGURACION' , 'todo_pago_configuracion');
define('TABLE_TP_TRANSACCION', 'todopago_transaccion');

include_once(dirname(__FILE__).DIRECTORY_SEPARATOR.'todopagoplugin'.DIRECTORY_SEPARATOR.'includes'.DIRECTORY_SEPARATOR.'TodopagoTransaccion.php');

class todopagoplugin {

    var $code, $title, $description, $enabled, $logo, $tp_states, $i = 0;

    function todopagoplugin() {

        global $order;

        $this->todopagoTransaccion = new TodopagoTransaccion();

        $this->code = 'todopagoplugin';

        $this->title = "TodoPago";

        $this->description = "TodoPago Plugin de pago.";

        $this->api_version = "1.0.0";

        $this->sort_order = MODULE_PAYMENT_TODOPAGOPLUGIN_SORT_ORDER;

        $this->enabled = ((MODULE_PAYMENT_TODOPAGOPLUGIN_STATUS == 'True') ? true : false);

        if ((int)MODULE_PAYMENT_TODOPAGOPLUGIN_ORDER_STATUS_ID > 0) {

            $this->order_status = MODULE_PAYMENT_TODOPAGOPLUGIN_ORDER_STATUS_ID;
        }

        if (is_object($order)) $this->update_status();

        $this->logo = '/includes/modules/payment/todopagoplugin/includes/todopago.jpg';
    }


    function update_status() {

        return false;
    }


    function javascript_validation() {

        return false;
    }



    function selection() {

        return array('id' => $this->code,

                     'module' => '<img src="'.DIR_WS_CATALOG.$this->logo.'" />',
                     'icon' => '<img src="'.DIR_WS_CATALOG.$this->logo.'" />');

    }



    function pre_confirmation_check() {

        return false;
    }



    function confirmation() {

        $states = $this->_get_tp_states();

        echo "<div style='color:red;font-weight:bold'>Por favor eleg&iacute; tu provincia para continuar</div>";
        echo "<select name='tp_states'>";

        $firstState = true;
        $stateCode = "";
        foreach($states as $city => $code){
            if ($firstState){
                echo '<option value="'.$code.'" selected>'.$city.'</option>';
                $stateCode = $code;
				$firstState = false;
            }
            else {
                echo '<option value="'.$code.'">'.$city.'</option>';
            }
        }


        echo "</select>";
        
        return false;
    }



    function process_button() {

        global $order, $currencies, $currency, $insert_id;

        $my_currency = $currency;

        $partialTotal = $order->info['total'];

        $shippingCost = $order->info['shipping_cost'];

        $myCurrencyValue = $currencies->get_value($my_currency);

        $myCurrencyDecimalPlaces = $currencies->get_decimal_places($my_currency);

        $total = $partialTotal * $myCurrencyValue;

        $precio = number_format($total, 2, '.', '');

        $productos = "";


        for ($i=0, $n=sizeof($order->products); $i<$n; $i++) {

            $productos .= "- " . $order->products[$i]['name'] . " ";

        }

        $productos = substr($productos,0,70) . '...';



        if ($my_currency == 'USD'){ 

            $TipoMoneda = 'DOL';}else{

            $TipoMoneda = 'ARG';}



        $process_button_string = tep_draw_hidden_field('name', $productos) .

            tep_draw_hidden_field('currency', $TipoMoneda) .

            tep_draw_hidden_field('price', $precio) .

            tep_draw_hidden_field('url_cancel', tep_href_link(FILENAME_CHECKOUT_PAYMENT, '', 'SSL')) .

            tep_draw_hidden_field('item_id', MODULE_PAYMENT_TODOPAGOPLUGIN_ID) .

            tep_draw_hidden_field('acc_id', MODULE_PAYMENT_TODOPAGOPLUGIN_ID) .

            tep_draw_hidden_field('shipping_cost', '' ) .

            tep_draw_hidden_field('url_process', '') .

            tep_draw_hidden_field('url_succesfull', tep_href_link(FILENAME_CHECKOUT_PROCESS, '', 'SSL')) . 

            tep_draw_hidden_field('enc', MODULE_PAYMENT_TODOPAGOPLUGIN_CODE);
        

    }


    function before_process() {

        
    }

    function checkout_initialization_method() {

        $string = '';
        return $string;
    }

    function after_process() {
        $dir = DIR_WS_INCLUDES.'work'.DIRECTORY_SEPARATOR.'todopago.log';
        error_log('returnFalse'.json_encode($_POST).'i'.json_encode($i), 3, $dir);
        
        $this->first_step_todopago();
        
        $i++;
        

        
        return false;
    }



    function check() {

        if (!isset($this->_check)) {

            $check_query = tep_db_query("select configuration_value from " . TABLE_CONFIGURATION . " where configuration_key = 'MODULE_PAYMENT_TODOPAGOPLUGIN_STATUS'");

            $this->_check = tep_db_num_rows($check_query);

        }

        return $this->_check;
    }



    function install() {

        tep_db_query("insert into " . TABLE_CONFIGURATION . " (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) values ('Habilitar módulo TodoPago', 'MODULE_PAYMENT_TODOPAGOPLUGIN_STATUS', 'True', 'Desea aceptar pagos a traves de TodoPago?', '6', '3', 'tep_cfg_select_option(array(\'True\', \'False\'), ', now())");


        tep_db_query("insert into " . TABLE_CONFIGURATION . " (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) values ('Sort order of display.', 'MODULE_PAYMENT_TODOPAGOPLUGIN_SORT_ORDER', '0', 'Order de despliegue. El mas bajo se despliega primero.', '6', '0', now())");


        tep_db_query("CREATE TABLE IF NOT EXISTS `".TABLE_TP_ATRIBUTOS."` ( `product_id` BIGINT NOT NULL , `CSITPRODUCTCODE` VARCHAR(150) NOT NULL COMMENT 'Codigo del producto' , `CSMDD33` VARCHAR(150) NOT NULL COMMENT 'Dias para el evento' , `CSMDD34` VARCHAR(150) NOT NULL COMMENT 'Tipo de envio' , `CSMDD28` VARCHAR(150) NOT NULL COMMENT 'Tipo de servicio' , `CSMDD31` VARCHAR(150) NOT NULL COMMENT 'Tipo de delivery' ) ENGINE = MyISAM;");

        tep_db_query("CREATE TABLE IF NOT EXISTS `".TABLE_TP_CONFIGURACION."` ( `idConf` INT NOT NULL PRIMARY KEY, `authorization` VARCHAR(100) NOT NULL , `segmento` VARCHAR(100) NOT NULL , `canal` VARCHAR(100) NOT NULL , `ambiente` VARCHAR(100) NOT NULL , `deadline` VARCHAR(100) NOT NULL , `test_endpoint` TEXT NOT NULL , `test_wsdl` TEXT NOT NULL , `test_merchant` VARCHAR(100) NOT NULL , `test_security` VARCHAR(100) NOT NULL , `production_endpoint` TEXT NOT NULL , `production_wsdl` TEXT NOT NULL , `production_merchant` VARCHAR(100) NOT NULL , `production_security` VARCHAR(100) NOT NULL , `estado_inicio` VARCHAR(100) NOT NULL , `estado_aprobada` VARCHAR(100) NOT NULL , `estado_rechazada` VARCHAR(100) NOT NULL , `estado_offline` VARCHAR(100) NOT NULL ) ENGINE = MyISAM;");

        tep_db_query("DELETE FROM `".TABLE_TP_CONFIGURACION."`");

        tep_db_query("INSERT INTO `".TABLE_TP_CONFIGURACION."` (`idConf`, `authorization`, `segmento`, `canal`, `ambiente`, `deadline`, `test_endpoint`, `test_wsdl`, `test_merchant`, `test_security`, `production_endpoint`, `production_wsdl`, `production_merchant`, `production_security`, `estado_inicio`, `estado_aprobada`, `estado_rechazada`, `estado_offline`) VALUES ('1', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '')");

        tep_db_query("CREATE TABLE IF NOT  EXISTS `".TABLE_TP_TRANSACCION."` (
                                                               `id` INT NOT NULL AUTO_INCREMENT,
                                                               `id_orden` INT NULL,
                                                               `first_step` TIMESTAMP NULL,
                                                               `params_SAR` TEXT NULL,
                                                               `response_SAR` TEXT NULL,
                                                               `second_step` TIMESTAMP NULL,
                                                               `params_GAA` TEXT NULL,
                                                               `response_GAA` TEXT NULL,
                                                               `request_key` TEXT NULL,
                                                               `public_request_key` TEXT NULL,
                                                               `answer_key` TEXT NULL,
                                                               PRIMARY KEY (`id`)
                                               )");
    }

    function remove() {

        tep_db_query("delete from " . TABLE_CONFIGURATION . " where configuration_key in ('" . implode("', '", $this->keys()) . "')");
        tep_db_query("DELETE FROM todo_pago_configuracion");
    }


    function keys() {

        return array('MODULE_PAYMENT_TODOPAGOPLUGIN_STATUS', 'MODULE_PAYMENT_TODOPAGOPLUGIN_ID', 'MODULE_PAYMENT_TODOPAGOPLUGIN_SORT_ORDER');

    }

    private function _get_tp_configuracion(){

        $todoPagoConfig = tep_db_query('SELECT * FROM todo_pago_configuracion');
        $todoPagoConfig = tep_db_fetch_array($todoPagoConfig);

        return $todoPagoConfig;
    }

    private function _create_tp_connector(){

        $todoPagoConfig = $this->_get_tp_configuracion();

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
            $header = json_decode(html_entity_decode($todoPagoConfig['authorization']),TRUE);
        

        $connector = new TodoPago\Sdk($header, $mode);

        $return = array('connector'=>$connector, 'merchant'=>$merchant, 'security'=>$security, 'config' => $todoPagoConfig);


        return $return;
    }

    private function _get_common_fields($cart){

        global $customer_id;
        
        $logger = new TodoPagoLogger($cart->id);

        $CSITPRODUCTDESCRIPTION = array();
        $CSITPRODUCTNAME = array();
        $CSITPRODUCTSKU = array();
        $CSITTOTALAMOUNT = array();
        $CSITQUANTITY = array();
        $CSITUNITPRICE = array();
        $CSITPRODUCTCODE = array();

        foreach($cart->products as $prod){
            $descriptonQuery = tep_db_query("SELECT products_description as description FROM products_description WHERE products_id = ".$this->_cleanId($prod['id']));
            $prod = array_merge($prod, tep_db_fetch_array($descriptonQuery));
            $string = htmlspecialchars_decode($prod['description']);

                //SANITIZE
                $re = "/\\[(.*?)\\]|<(.*?)\\>/i";
                $subst = "";
                $string = preg_replace($re, $subst, $string);

                $replace = array("!","'","\'","\"","  ","$","#","\\","\n","\r",
                    '\n','\r','\t',"\t","\n\r",'\n\r','&nbsp;','&ntilde;',".,",",.");
                $string = str_replace($replace, '', $string);

                $cods = array('\u00c1','\u00e1','\u00c9','\u00e9','\u00cd','\u00ed','\u00d3','\u00f3','\u00da','\u00fa','\u00dc','\u00fc','\u00d1','\u00f1');
                $susts = array('Á','á','É','é','Í','í','Ó','ó','Ú','ú','Ü','ü','Ṅ','ñ');
                $string = str_replace($cods, $susts, $string);
			
            $CSITPRODUCTDESCRIPTION[] = substr($string,0,17);
            $CSITPRODUCTNAME[] =  str_replace('#', '', trim(urlencode(htmlentities(strip_tags($prod['name'])))));
            $CSITPRODUCTSKU[] = str_replace('#', '', $prod['model']);
            $CSITTOTALAMOUNT[] = number_format(($prod['qty'] * $prod['final_price']),'2','.','');
            $CSITQUANTITY[] = $prod['qty'];
            $CSITUNITPRICE[] = number_format($prod['final_price'],'2','.','');

            $customfields = array();
            $customfields = $this->_get_tp_custom_values($prod['id']);

            if (is_array($customfields)){
                $haveProductCode = false;
                foreach($customfields as $customIndex => $customValue){

                    if ($customIndex == 'CSITPRODUCTCODE'){
                        $CSITPRODUCTCODE[] = trim(urlencode(htmlentities(strip_tags($customValue))));
                    }
                }
                if (!$haveProductCode){
                    $CSITPRODUCTCODE[] = 'default';
                }
            }
            else{
                $CSITPRODUCTCODE[] = 'default';
            }
        }


        $fields = array(		                        
            'CSBTCITY' => $cart->billing['state'], 	
            'CSBTCOUNTRY' => $cart->billing['country']['iso_code_2'], 	
            'CSBTCUSTOMERID' => $customer_id, 
            'CSBTIPADDRESS' => $this->_get_todo_pago_client_ip(), 	
            'CSBTEMAIL' => $cart->customer['email_address'], 		
            'CSBTFIRSTNAME'=> $cart->customer['firstname'], 
            'CSBTLASTNAME'=> $cart->customer['lastname'], 
            'CSBTPHONENUMBER'=> phone::clean($cart->customer['telephone'], $logger), 
            'CSBTPOSTALCODE'=> $cart->customer['postcode'], 	
            'CSBTSTATE' => $this->tp_states, 
            'CSBTSTREET1' => $cart->customer['street_address'] ,				
            'CSPTCURRENCY'=> $cart->info['currency'],	
            'CSPTGRANDTOTALAMOUNT' => number_format($cart->info['total'],'2','.',''),
            'CSMDD7' => $this->_get_days_qty($cart->aditional_info['date_creation']),
            'CSMDD8' => 'S',
            'CSMDD9' => $cart->customer_aditional_info['password'],
            'CSMDD10' => $cart->customer_aditional_info['orders_qty'],
            'CSMDD11' => phone::clean($cart->customer['telephone'], $logger),
            'CSITPRODUCTCODE'=>implode('#',$CSITPRODUCTCODE), 
            'CSITPRODUCTDESCRIPTION'=> implode('#',$CSITPRODUCTDESCRIPTION), 
            'CSITPRODUCTNAME'=>implode('#',$CSITPRODUCTNAME),		
            'CSITPRODUCTSKU'=>implode('#',$CSITPRODUCTSKU), 		
            'CSITTOTALAMOUNT'=> implode('#',$CSITTOTALAMOUNT), 
            'CSITQUANTITY'=>implode('#',$CSITQUANTITY), 		
            'CSITUNITPRICE'=>implode('#',$CSITUNITPRICE),
            'AMOUNT' => number_format($cart->info['total'],'2','.',''),
            'EMAILCLIENTE' => $cart->customer['email_address'], 		
        );
            
            $logger = new TodoPagoLogger($cart->id);
            $logger->writeLog('CSBTSTATE', $fields['CSBTSTATE']);

        return $fields;

    }

    private function _get_retail_fields($cart){
        
        $logger = new TodoPagoLogger($cart->id);

        $fields = array(		
            'CSSTCITY'=> $cart->delivery['city'], 	
            'CSSTEMAIL'=> $cart->customer['email_address'], 
			'CSSTCOUNTRY' => $cart->delivery['country']['iso_code_2'], 	
			'CSSTSTATE' => $this->tp_states, 
            'CSSTFIRSTNAME'=> $cart->customer['firstname'], 		
            'CSSTLASTNAME'=> $cart->customer['lastname'], 		
            'CSSTPHONENUMBER'=>phone::clean($cart->customer['telephone'], $logger),		
            'CSSTPOSTALCODE'=> $cart->customer['postcode'],		
            'CSSTSTREET1'=> $cart->customer['street_address'], 	
        );
        
        $logger = new TodoPagoLogger($cart->id);
        $logger->writeLog("fields['CSSTATE']", $fields['CSSTATE']);

        return $fields;    
    }

    private function _get_digital_goods_fields(){

        $CSMDD31 = array();

        foreach($data->products as $prod){

            $customfields = array();
            $customfields = $this->_get_tp_custom_values($prod['id']);

            if (is_array($customfields)){

                foreach($customfields as $customIndex => $customValue){

                    if ($customIndex == 'CSMDD31'){
                        $CSMDD31[] = trim(urlencode(htmlentities(strip_tags($customValue))));
                    }
                }
            }
        }

        $fields = array(		
            'CSMDD31'=>implode('#',$CSMDD31)
        );

        return $fields;	    
    }

    private function _get_services_fields(){

        $CSMDD28 = array();

        foreach($data->products as $prod){

            $customfields = array();
            $customfields = $this->_get_tp_custom_values($prod['id']);

            if (is_array($customfields)){

                foreach($customfields as $customIndex => $customValue){

                    if ($customIndex == 'CSMDD28'){
                        $CSMDD28[] = trim(urlencode(htmlentities(strip_tags($customValue))));
                    }
                }
            }
        }

        $fields = array(		
            'CSMDD28'=>implode('#',$CSMDD28)
        );

        return $fields;	    
    }

    private function _get_ticketing_fields(){

        $CSMDD33 = array();
        $CSMDD34 = array();

        foreach($data->products as $prod){

            $customfields = array();
            $customfields = $this->_get_tp_custom_values($prod['id']);

            if (is_array($customfields)){

                foreach($customfields as $customIndex => $customValue){

                    if ($customIndex == 'CSMDD33'){
                        $CSMDD33[] = trim(urlencode(htmlentities(strip_tags($customValue))));
                    }
                    if ($customIndex == 'CSMDD34'){
                        $CSMDD34[] = trim(urlencode(htmlentities(strip_tags($customValue))));
                    }
                }
            }
        }

        $fields = array(		
            'CSMDD33'=>implode('#',$CSMDD33),
            'CSMDD34'=>implode('#',$CSMDD34)
        );

        return $fields;	  

    }

    private function _get_todo_pago_client_ip() {

        $ipaddress = '';
        if ($_SERVER['HTTP_CLIENT_IP'])
            $ipaddress = $_SERVER['HTTP_CLIENT_IP'];
        else if($_SERVER['HTTP_X_FORWARDED_FOR'])
            $ipaddress = $_SERVER['HTTP_X_FORWARDED_FOR'];
        else if($_SERVER['HTTP_X_FORWARDED'])
            $ipaddress = $_SERVER['HTTP_X_FORWARDED'];
        else if($_SERVER['HTTP_FORWARDED_FOR'])
            $ipaddress = $_SERVER['HTTP_FORWARDED_FOR'];
        else if($_SERVER['HTTP_FORWARDED'])
            $ipaddress = $_SERVER['HTTP_FORWARDED'];
        else if($_SERVER['REMOTE_ADDR'])
            $ipaddress = $_SERVER['REMOTE_ADDR'];
        else
            $ipaddress = 'UNKNOWN';

        return $ipaddress;
    }

    private function _set_tp_order_status($order_id, $status_id){

        tep_db_query('UPDATE '.TABLE_ORDERS.' SET orders_status = '.$status_id.' WHERE orders_id = '.$order_id);
    }

    private function _get_tp_custom_values($product_id){

        $product_id = explode('{', $product_id);

        $todoPagoConfig = tep_db_query('SELECT * FROM '.TABLE_TP_ATRIBUTOS.' WHERE product_id = '.$product_id[0]);
        $todoPagoConfig = tep_db_fetch_array($todoPagoConfig);

        return $todoPagoConfig; 
    }

    private function _get_tp_states(){

        $states = array('CABA' => 'C',

                        'Buenos Aires'  => 'B',

                        'Catamarca'  => 'K',

                        'Chaco'  => 'H' ,

                        'Chubut'  => 'U',

                        'C&oacute;rdoba'  => 'X',

                        'Corrientes'  => 'W',

                        'Entre R&iacute;os'  => 'R',

                        'Formosa'  => 'P',

                        'Jujuy'  => 'Y',

                        'La Pampa'  => 'L',

                        'La Rioja' =>  'F',

                        'Mendoza' => 'M',

                        'Misiones'  => 'N',

                        'Neuqu&eacute;n'  => 'Q',

                        'R&iacute;o Negro'  => 'R',

                        'Salta'  => 'A',

                        'San Juan'  => 'J',

                        'San Luis'  => 'D',

                        'Santa Cruz'  => 'Z',

                        'Santa F&eacute;' =>  	'S',

                        'Santiago del Estero'  => 'G',

                        'Tierra del Fuego'  => 'V',

                        'Tucum&aacute;n'  => 'T');

        return $states;    
    }

    private function _cleanId($id){
        return substr($id, 0,  strpos($id.'{', '{'));
    }
    
    private function _get_customer_aditional_info($customer_id){
        $query = tep_db_query("SELECT c.customers_password as 'password', ci.customers_info_date_account_created as 'date_creation', COUNT(*) AS 'orders_qty' FROM customers c INNER JOIN customers_info ci ON c.customers_id = ci.customers_info_id INNER JOIN orders o ON ci.customers_info_id = o.customers_id WHERE c.customers_id = ".$customer_id);
        return tep_db_fetch_array($query);
    }
    
    private function _get_days_qty($date){
        $date = new DateTime($date);
        $now = new DateTime();
        
        $diff = $date->diff($now);
        return $diff->days;
    }

    function first_step_todopago(){
        global $customer_id, $order, $sendto, $ppe_token, $ppe_payerid, $ppe_secret, $ppe_order_total_check, $HTTP_POST_VARS, $comments, $response_array, $currencies, $insert_id;

        $order->id = $insert_id;
        $this->todopagoTransaccion->createRegister($insert_id);

        include_once("todopagoplugin/includes/TodoPagoLogger.php");
        $logger = new TodoPagoLogger($order->id);

        if($this->todopagoTransaccion->_getStep($order->id) == TodopagoTransaccion::FIRST_STEP){

            $logger->writeLog("first step");
            
            $post = $_POST;
            
            
            $logger->writeLog("_POST", $post);
            
            $logger->writeLog("_POST['tp_states']", $_POST['tp_states']);

            $this->tp_states = $post['tp_states'];
            
            $logger->writeLog("this->tp_states", $this->tp_states);

            //if(!isset($_GET['Answer'])){

                $connector_data = $this->_create_tp_connector();

                if(!$connector_data){
                    echo "El medio de pago TodoPago no está disponible en este momento";
                    $logger->writeLog("El medio de pago no ha sido configurado");
                }

                $connector = $connector_data['connector'];

                $optionsSAR_comercio = $this->getOptionsSARComercio($order, $connector_data);
                $optionsSAR_operacion = $this->getOptionsSAROperacion($order, $connector_data);

                $optionsSAR = array($optionsSAR_comercio, $optionsSAR_operacion);
                $logger->writeLog("params SAR", $optionsSAR);
                $rta = $connector->sendAuthorizeRequest($optionsSAR_comercio, $optionsSAR_operacion);
                $logger->writeLog("response SAR", $rta);
                if($rta['StatusCode'] == -1){
                $query = $this->todopagoTransaccion->recordFirstStep($order->id, $optionsSAR, $rta);
                //$logger->writeLog("query", $query);

                setcookie('RequestKey',$rta["RequestKey"],  time() + (86400 * 30), "/");        
                header('Location: '.$rta['URL_Request']);
                die();
                    
                }
//            }
            else{
                
                header('Location: '.tep_href_link('checkout_shipping_retry.php', '', 'SSL'));
                die(); 
            }
        }
        else{
            $logger->writeLog("No se pudo efectuar el first step, ya se encuentra un first step exitoso reginstrado en la tabla todopago_transaccion");
            header('Location: '.tep_href_link('index.php', '', 'SSL'));
            die();
        }
        return false;
    }

    function getOptionsSARComercio($order, $connector_data){
        $security_code = $connector_data['security'];
        $merchant = $connector_data['merchant'];

        $optionsSAR_comercio = array (
            'URL_OK' => tep_href_link('second_step_todopago.php?Order='.$order->id, '', 'SSL'),
            'URL_ERROR' => tep_href_link('second_step_todopago.php?Order='.$order->id, '', 'SSL'),
            'Merchant' => $merchant,
            'Security' => $security_code,
            'EncodingMethod' => 'XML'
        );
        return $optionsSAR_comercio;
    }

    function getOptionsSAROperacion($order, $connector_data){

        global $customer_id;
        
        $merchant = $connector_data['merchant']; 
        $config_tp = $connector_data['config'];
        
        $order->customer_aditional_info = $this->_get_customer_aditional_info($customer_id);

        $optionsSAR_operacion = $this->_get_common_fields($order);          

        switch($config_tp['segmento']){

            case 'retail':  
            $extra_fields = $this->_get_retail_fields($order);
            break;

            case 'ticketing':
            $extra_fields = $this->_get_ticketing_fields($order);
            break;

            case 'services':
            $extra_fields = $this->_get_services_fields($order);
            break;

            case 'digital':
            $extra_fields = $this->_get_digital_goods_fields($order);
            break;

            default:
            $extra_fields = $this->_get_retail_fields($order);
            break;
        }

        $optionsSAR_operacion = array_merge($optionsSAR_operacion, $extra_fields);   

        $optionsSAR_operacion['MERCHANT'] = $merchant;
        $optionsSAR_operacion['CURRENCYCODE'] = '032';
        $optionsSAR_operacion['CSPTCURRENCY'] =  'ARS';
        $optionsSAR_operacion['OPERATIONID'] = $order->id;
        $optionsSAR_operacion['CSBTCOUNTRY'] = $order->customer['country']['iso_code_2'];

        $optionsSAR_operacion['CSSTSTATE'] = 	$this->tp_states;
        $optionsSAR_operacion['CSSTCOUNTRY'] = $order->customer['country']['iso_code_2'];
        $optionsSAR_operacion['AMOUNT'] = $order->info['total'];
        
        $logger = new TodoPagoLogger($order->id);
        $logger->writeLog("optionSAR_operacion['CSSTATE']", $optionSAR_operacion['CSSTATE']);

        return $optionsSAR_operacion;
    }
}