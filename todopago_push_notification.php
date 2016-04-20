<?php

function pushNotification(){
    $orderId = $_POST['OperationId'];
    $requestKey = $_POST['RequestKey'];
    $eventType = $_POST['EventType'];
    $eventKey = $_POST['EventKey'];
    //Los siguientes 2 campos solo se recuperana a modo informativo.
    $eventDateTime = $_POST['EventDateTime'];
    $eventData = $_POST['EventData'];

    require('includes/application_top.php');
    require_once dirname(__FILE__).'/includes/modules/payment/todopagoplugin/includes/Logger/loggerFactory.php';
    //ini_set("date.timezone", "America/Buenos_Aires");
    //$logger = loggerFactory::createLogger();

    //$logger->debug("PushNotification: OperationId: $orderId, RequestKey: $requestKey, EventType: $eventType, EventKey: $eventKey, EventDateTime: $eventDateTime, EventData: $eventData");

    header("Content-Type: text/json", true);

    require_once 'includes/modules/payment/todopagoplugin/includes/TodopagoTransaccion.php';
    $transaction = new TodopagoTransaccion();

    if(($transaction->_getStep($orderId) == TodopagoTransaccion::TRANSACTION_FINISHED) && ($requestKey == $transaction->getRequestKey($orderId))){
        $newOrderStatus = getNewOrderStatus($eventType);
        updateOrder($orderId, $newOrderStatus, $comment = 'Actualizado por TodoPago - PushNotificationService', true);
        $statusCode = -1;
    }
    else{
        $statusCode = 1;
        //$logger->info("Fallo el update de la orden por push. OperationId: $orderId, RequestKey: $requestKey, EventKey: $eventKey");
    }

    $rta = json_encode(array('StatusCode' => $statusCode, 'EventKey' => $eventKey));
    //$logger->debug("Rta PushNotification: $rta");
    echo $rta;
}

function getNewOrderStatus($eventType){
    $statusByEvent = array(
        'aprobar' => 1,
        'cancelar'=> 2
    );

    return $statusByEvent[$eventType];
}

function updateOrder($orderId, $orderStatusId, $comment, $notify){
    $order_status_history_data_array = array('orders_id' => $orderId,
                              'orders_status_id' => $orderStatusId,
                              'comments' => $comment,
                              'customer_notified' => '0',
                              'date_added' => 'now()');

    tep_db_perform(TABLE_ORDERS_STATUS_HISTORY, $order_status_history_data_array);

    $order_data_array = array('orders_id' => $orderId,
                             'orders_status' => $orderStatusId);
    tep_db_perform(TABLE_ORDERS, array('orders_status' => $orderStatusId), 'update', "orders_id = $orderId");
}

pushNotification();
