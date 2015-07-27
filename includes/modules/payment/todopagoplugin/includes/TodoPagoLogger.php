<?php

define('VERSION', '0.2.0');

class TodoPagoLogger{
    var $orderId;
    var $logDir;
    
    function __construct($orderId){
        $this->orderId = $orderId;
        $this->logDir = DIR_WS_INCLUDES.'work'.DIRECTORY_SEPARATOR.'todopago.log';
        $this->writeLog('Nro de orden', $this->orderId);
    }
    
    function writeLog($message, $params = false){
        $logText = date('d-m-Y H:i:s').' - todopago - orden '.$this->orderId.': '.$message;
        $logText .= $params? " - parametros: ".json_encode($params) : '';
        error_log($logText."\n", 3, $this->logDir);
    }
}