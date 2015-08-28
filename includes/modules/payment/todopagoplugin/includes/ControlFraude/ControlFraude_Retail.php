<?php
class ControlFraude_Retail extends ControlFraude{

    protected function completeCFVertical(){
        $payDataOperacion = array();
        $shippingAdress = $this->order->delivery;
        $this->config = $this->_get_tp_configuracion();
        
        $this->logger->info("Parámetros para retail");

        $this->logger->debug("CSSTCITY - Ciudad de env&iacute;o de la orden");
        $payDataOperacion ['CSSTCITY'] = $this->getField($shippingAdress['city']);
                                                         
        $this->logger->debug("CSSTCOUNTRY Pa&iacute;s de env&iacute;o de la orden");
        $payDataOperacion ['CSSTCOUNTRY'] = $this->getField($shippingAdress['country']['iso_code_2']);
                                                         
        $this->logger->debug("CSSTEMAIL Mail del destinatario");
        $payDataOperacion ['CSSTEMAIL'] = $this->getField($this->customer['email_address']);
                                                         
        $this->logger->debug("CSSTFIRSTNAME Nombre del destinatario");
        $payDataOperacion ['CSSTFIRSTNAME'] = $this->getField($shippingAdress['firstname']);
                                                         
        $this->logger->debug("CSSTLASTNAME Apellido del destinatario");
        $payDataOperacion ['CSSTLASTNAME'] = $this->getField($shippingAdress['lastname']);
                                                         
        $this->logger->debug("CSSTPHONENUMBER N&uacute;mero de tel&eacute;fono del destinatario");
        $payDataOperacion ['CSSTPHONENUMBER'] = phone::clean($this->getField($this->customer['telephone']), $this->logger);
                                                         
        $this->logger->debug("CSSTPOSTALCODE C&oacute;digo postal del domicilio de env&iacute;o");
        $payDataOperacion ['CSSTPOSTALCODE'] = $this->getField($shippingAdress['postcode']);
                                                         
        $this->logger->debug("CSSTSTATE Provincia de envacute;o");
        $payDataOperacion ['CSSTSTATE'] = $shippingAdress['tp_state'];
                                                         
        $this->logger->debug("CSSTSTREET1 Domicilio de env&iacute;o");
        $payDataOperacion ['CSSTSTREET1'] =$this->getField($shippingAdress['street_address']);
                                                         
        $this->logger->debug("CSMDD12 Shipping DeadLine (Num Dias)");
        $payDataOperacion ['CSMDD12'] = $this->config['deadline'];
                                                         
        $this->logger->debug("CSMDD13 M&eacute;todo de Despacho");
        $payDataOperacion ['CSMDD13'] = $this->getField($this->order->info['shipping_method']);
                                                         
       // $this->logger->debug("CSMDD14 Customer requires Tax Bill ? (Y/N) No");
                //$payData ['CSMDD14'] = "";
        //$this->logger->debug("CSMDD15 Customer Loyality Number No");
                //$payData ['CSMDD15'] = "";
                                                         
        //$this->logger->debug("CSMDD16 Promotional / Coupon Code");
       // $payDataOperacion ['CSMDD16'] = $this->getField($this->order->getCuponCode());
        //OsCommerce no trae la posibilidad de usar cupones nativamente, solo se puede hacer adicionando  plugins
                                                         
        $payDataOperacion = array_merge($this->getMultipleProductsInfo(), $payDataOperacion);
        return $payDataOperacion;
    }


    private function _get_tp_configuracion(){
        $todoPagoConfig = tep_db_query('SELECT * FROM todo_pago_configuracion');
        $todoPagoConfig = tep_db_fetch_array($todoPagoConfig);

        return $todoPagoConfig;
    }
}
