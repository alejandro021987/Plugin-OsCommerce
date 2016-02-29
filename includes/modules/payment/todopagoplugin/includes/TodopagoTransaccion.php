<?php
class TodopagoTransaccion {
    
    const NEW_ORDER = 0;
    const FIRST_STEP = 1;
    const SECOND_STEP = 2;
    const TRANSACTION_FINISHED = 3;
    
    public function getTransaction($orderId) {
        $query = tep_db_query("SELECT * FROM todopago_transaccion WHERE id_orden = ".$orderId);
        $query_result_array = tep_db_fetch_array($query);
        return $query_result_array;
    }

    private function getField($orderId, $fieldName){
        $transaction = $this->getTransaction($orderId);
        return $transaction[$fieldName];
    }
    
    public function _getStep($orderId){
        $transaction = $this->getTransaction($orderId);
        if ($transaction == null){
            $step = self::NEW_ORDER;
        }
        else if ($transaction['first_step'] == null){
            $step = self::FIRST_STEP;
        }
        else if ($transaction['second_step'] == null){
            $step = self::SECOND_STEP;
        }
        else{
            $step = self::TRANSACTION_FINISHED;
        }
        
        return $step;
    }

    public function getRequestKey($orderId){
        return $this->getField($orderId, 'request_key');
    }
    
    public function getCouponUrl($orderId){
        return $this->getField($orderId, 'url_cupon');
    }

    public function createRegister($orderId){
        if ($this->_getStep($orderId) == self::NEW_ORDER){
            tep_db_query("INSERT INTO todopago_transaccion (id_orden) VALUES (".$orderId.")");
            return 1;
        }
        else {
            return 0;
        }
    }
    
    public function recordFirstStep($orderId, $paramsSAR, $responseSAR){
        $datetime = new DateTime('NOW');
        if ($this->_getStep($orderId) == self::FIRST_STEP){
            $requestKey = $responseSAR['RequestKey'];
            $publicRequestKey = $responseSAR['PublicRequestKey'];
            
            $query = "UPDATE todopago_transaccion SET first_step = '".$datetime->format('Y-m-d H:i:s')."', params_SAR = '".tep_db_input(tep_db_prepare_input(json_encode($paramsSAR)))."', response_SAR = '".tep_db_input(tep_db_prepare_input(json_encode($responseSAR)))."', request_key = '".tep_db_input(tep_db_prepare_input($requestKey))."', public_request_key = '".tep_db_input(tep_db_prepare_input($publicRequestKey))."' WHERE id_orden = ".$orderId;
            tep_db_query($query);
            return $query;
        }
        else{
            return 0;
        }
    }
    
    public function recordSecondStep($orderId, $paramsGAA, $responseGAA){
        $datetime = new DateTime('NOW');
        if ($this->_getStep($orderId) == self::SECOND_STEP){
            $answerKey = $paramsGAA['AnswerKey'];
            $url_cupon = ($responseGAA['Payload']['Answer']['ASSOCIATEDDOCUMENTATION']) ? "'".$responseGAA['Payload']['Answer']['ASSOCIATEDDOCUMENTATION']."'" : 'NULL';
            $query = "UPDATE todopago_transaccion SET second_step = '".$datetime->format('Y-m-d H:i:s')."', params_GAA = '".json_encode($paramsGAA)."', response_GAA = '".json_encode($responseGAA)."', answer_key = '".$answerKey."', url_cupon = $url_cupon WHERE id_orden = ".$orderId;
            tep_db_query($query);
            return $query;
        }
        else{
            return 0;
        }
    }
}