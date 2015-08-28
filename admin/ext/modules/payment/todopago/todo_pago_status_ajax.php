<?php
    chdir('../../../../');
    require('includes/application_top.php');
    
    require_once(DIR_FS_CATALOG."/includes/modules/payment/todopagoplugin/includes/TodoPago/lib/Sdk.php");
    require_once DIR_FS_CATALOG.'/includes/modules/payment/todopagoplugin/includes/Logger/loggerFactory.php';

    $orderId = $_REQUEST["order_id"];

    $sql = "select * from todo_pago_configuracion";

    $res = tep_db_query($sql);

    if ($row = tep_db_fetch_array($res)){    
    
        $modo = $row["ambiente"]."_";

        $logger = loggerFactory::createLogger(true, substr($modo, 0 , 4), 0, $orderId);

        $logger->info("get Status");

        $wsdl = json_decode($row[$modo."wsdl"],1);
        
        $http_header = json_decode($row["authorization"],1);
        
        $http_header["user_agent"] = 'PHPSoapClient';
        
        define('END_POINT', $row[$modo."endpoint"]);

        $connector = new TodoPago\Sdk($http_header, substr($modo, 0, 4));
    
        $optionsGS = array('MERCHANT'=>$row[$modo."merchant"], 'OPERATIONID'=>$orderId); 

        $logger->info("params getStatus: ".json_encode($optionsGS));

        $rta4 = $connector->getStatus($optionsGS);   

        $logger->info("rta get Status: ".json_encode($rta4));
    
        if (isset($rta4["Operations"])){
    
            $rta4 = $rta4["Operations"];
            $tabla = "<table>";
        
            foreach($rta4 as $key => $value){
        
                $tabla .="<tr><td>".$key."</td><td>".$value."</td></tr>";
            }
        
            echo "</table>";
        }
        else{
    
            $tabla = "No hay operaciones para consultar";
        }
        
    echo $tabla;
    
    }
?>
