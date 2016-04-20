[1mdiff --git a/README.md b/README.md[m
[1mindex f55729f..4ca2dd5 100644[m
[1m--- a/README.md[m
[1m+++ b/README.md[m
[36m@@ -5,6 +5,7 @@[m [mPlug in para la integración con gateway de pago <strong>Todo Pago</strong>[m
 - [Consideraciones Generales](#consideracionesgenerales)[m
 - [Instalación](#instalacion)[m
 - [Configuración plugin](#confplugin)[m
[32m+[m[32m- [Obtener credenciales](#obtenercredenciales)[m
 - [Devoluciones] (#devoluciones)[m
 - [Datos adiccionales para prevención de fraude](#cybersource) [m
 - [Tablas de referencia](#tablas)[m
[36m@@ -64,10 +65,20 @@[m [ma. Configuración: Se dan de alta los valores para el funcionamiento de TodoPago[m
 [m
 b. Ordenes: Aquí estarán las órdenes y el botón para Ver Status para ver las actualizaciones de estado[m
 [m
[31m-![imagen de configuracion](https://raw.githubusercontent.com/TodoPago/imagenes/master/oscommerce/conf3.png)[m
[32m+[m[32m![imagen de configuracion](https://raw.githubusercontent.com/TodoPago/imagenes/master/oscommerce/conf-orders.png)[m
 [m
 c. Para las devoluciones se debe agregar los estados "Refund" y "Partial Refund", desde la seccion, Admin -> Localization -> Order Status.[m
 [m
[32m+[m[32m<a name="obtenercredenciales"></a>[m
[32m+[m[32m#Obtener crendenciales[m
[32m+[m[32mSe puede obtener los datos de configuracion del plugin con solo loguearte con tus credenciales de Todopago. </br>[m
[32m+[m[32ma. Ir a la opcion Obtener credenciales[m
[32m+[m[32m![imagen de configuracion](https://raw.githubusercontent.com/TodoPago/imagenes/master/oscommerce/obtenercredenciales_1.png)[m
[32m+[m[32mb. En el popup loguearse con el mail y password de Todopago.[m
[32m+[m[32m![imagen de configuracion](https://raw.githubusercontent.com/TodoPago/imagenes/master/oscommerce/obtenercredenciales_2.png)[m
[32m+[m[32mc. Los datos se cargaran automaticamente en los campos Merchant ID y Security code en el ambiente correspondiente (Desarrollo o produccion ) y solo hay que hacer click en el boton guardar datos y listo.[m
[32m+[m[32m![imagen de configuracion](https://raw.githubusercontent.com/TodoPago/imagenes/master/oscommerce/obtenercredenciales_3.png)[m
[32m+[m
 <a name="devoluciones"></a>[m
 ##Devoluciones[m
 TodoPago permite realizar la devolucion total o parcial de dinero de una orden de compra.<br> [m
[36m@@ -84,17 +95,17 @@[m [mLos campos se crean automáticamente y se asignan en Tools -> TodoPago Configura[m
 El plug in, toma valores estándar del framework para validar los datos del comprador.[m
 Para acceder a los datos del vendedor, productos y carrito se usa el  objeto $order que llega como parámetro en los métodos en los que se necesita. [m
 Este es un ejemplo de la mayoría de los campos que se necesitan para comenzar la operación <br />[m
[31m-'CSBTCITY' => $cart->billing['state'], 	[m
[31m-'CSBTCOUNTRY' => $cart->billing['country']['iso_code_2'], 	[m
[32m+[m[32m'CSBTCITY' => $cart->billing['state'],[m[41m  [m
[32m+[m[32m'CSBTCOUNTRY' => $cart->billing['country']['iso_code_2'],[m[41m   [m
 'CSBTCUSTOMERID' => $customer_id, [m
[31m-'CSBTIPADDRESS' => $this->get_todo_pago_client_ip(), 	[m
[31m-'CSBTEMAIL' => $cart->customer['email_address'], 		[m
[32m+[m[32m'CSBTIPADDRESS' => $this->get_todo_pago_client_ip(),[m[41m    [m
[32m+[m[32m'CSBTEMAIL' => $cart->customer['email_address'],[m[41m        [m
 'CSBTFIRSTNAME'=> $cart->customer['firstname'], [m
 'CSBTLASTNAME'=> $cart->customer['lastname'], [m
 'CSBTPHONENUMBER'=> $cart->customer['telephone'], [m
[31m-'CSBTPOSTALCODE'=> $cart->customer['postcode'], 	[m
[32m+[m[32m'CSBTPOSTALCODE'=> $cart->customer['postcode'],[m[41m     [m
 'CSBTSTATE' => $this->tp_states, [m
[31m-'CSBTSTREET1' => $cart->customer['street_address'] ,	[m
[32m+[m[32m'CSBTSTREET1' => $cart->customer['street_address'] ,[m[41m    [m
 [m
 <a name="tablas"></a>[m
 ## Tablas de Referencia[m
[1mdiff --git a/admin/ext/modules/payment/todopago/todo_pago_devoluciones_ajax.php b/admin/ext/modules/payment/todopago/todo_pago_devoluciones_ajax.php[m
[1mindex 35ffa89..2edeb7f 100644[m
[1m--- a/admin/ext/modules/payment/todopago/todo_pago_devoluciones_ajax.php[m
[1m+++ b/admin/ext/modules/payment/todopago/todo_pago_devoluciones_ajax.php[m
[36m@@ -82,7 +82,7 @@[m
 [m
                 $response = "La devolucion se realizo satisfactoriamente";[m
             }else{[m
[31m-                $response = "Ocurrio un error en la devolucion, vuelva a intentarlo en unos minutos, codigo de error: ".$refundResponse['StatusCode'];[m
[32m+[m[32m                $response = "<h4>Ocurrio un error en la devolucion: " . $refundResponse['StatusMessage'] . '</h4>';[m
             }[m
         }    [m
         [m
[1mdiff --git a/admin/ext/modules/payment/todopago/todo_pago_status_ajax.php b/admin/ext/modules/payment/todopago/todo_pago_status_ajax.php[m
[1mindex a336076..f546f7e 100644[m
[1m--- a/admin/ext/modules/payment/todopago/todo_pago_status_ajax.php[m
[1m+++ b/admin/ext/modules/payment/todopago/todo_pago_status_ajax.php[m
[36m@@ -33,28 +33,54 @@[m
 [m
         $logger->info("params getStatus: ".json_encode($optionsGS));[m
 [m
[31m-        $rta4 = $connector->getStatus($optionsGS);   [m
[32m+[m[32m        $status = $connector->getStatus($optionsGS);[m
[32m+[m[41m    [m
[32m+[m[32m        $rta = '';[m
[32m+[m[32m        $refunds = $status['Operations']['REFUNDS'];[m
[32m+[m[32m        $refounds = $status['Operations']['refounds'];[m
 [m
[31m-        $logger->info("rta get Status: ".json_encode($rta4));[m
[31m-    [m
[31m-        if (isset($rta4["Operations"])){[m
[31m-    [m
[31m-            $rta4 = $rta4["Operations"];[m
[31m-            $tabla = "<table>";[m
[31m-        [m
[31m-            foreach($rta4 as $key => $value){[m
[31m-        [m
[31m-                $tabla .="<tr><td>".$key."</td><td>".$value."</td></tr>";[m
[32m+[m[32m        $auxArray = array([m
[32m+[m[32m             "refound" => $refounds,[m[41m [m
[32m+[m[32m             "REFUND" => $refunds[m
[32m+[m[32m             );[m
[32m+[m
[32m+[m[32m        if($refunds != null){[m[41m  [m
[32m+[m[32m            $aux = 'REFUND';[m[41m [m
[32m+[m[32m            $auxColection = 'REFUNDS';[m[41m [m
[32m+[m[32m        }else{[m[41m [m
[32m+[m[32m            $aux = 'refound';[m
[32m+[m[32m            $auxColection = 'refounds';[m[41m [m
[32m+[m[32m        }[m
[32m+[m
[32m+[m[32m        if (isset($status['Operations']) && is_array($status['Operations']) ) {[m
[32m+[m[32m            foreach ($status['Operations'] as $key => $value) {[m
[32m+[m[41m           [m
[32m+[m[32m                 if(is_array($value) && $key == $auxColection){[m
[32m+[m[41m                   [m
[32m+[m[32m                    $rta .= " $key: \n";[m
[32m+[m[32m                    foreach ($auxArray[$aux] as $key2 => $value2) {[m[41m              [m
[32m+[m[32m                        $rta .= "  $aux: \n";[m[41m                [m
[32m+[m[32m                        if(is_array($value2)){[m[41m                    [m
[32m+[m[32m                            foreach ($value2 as $key3 => $value3) {[m
[32m+[m[32m                                if(is_array($value3)){[m[41m                    [m
[32m+[m[32m                                    foreach ($value3 as $key4 => $value4) {[m
[32m+[m[32m                                        $rta .= "   - $key4: $value4 </br>";[m
[32m+[m[32m                                    }[m
[32m+[m[32m                                 }[m
[32m+[m[32m                            }[m
[32m+[m[32m                        }[m
[32m+[m[32m                    }[m[41m            [m
[32m+[m[32m                 }else{[m[41m             [m
[32m+[m[32m                     if(is_array($value)){[m
[32m+[m[32m                         $rta .= "$key: </br>";[m
[32m+[m[32m                     }else{[m
[32m+[m[32m                         $rta .= "$key: $value </br>";[m
[32m+[m[32m                     }[m
[32m+[m[32m                 }[m[41m [m
             }[m
[31m-        [m
[31m-            echo "</table>";[m
[31m-        }[m
[31m-        else{[m
[31m-    [m
[31m-            $tabla = "No hay operaciones para consultar";[m
[31m-        }[m
[31m-        [m
[31m-    echo $tabla;[m
[32m+[m[32m        }else{ $rta = 'No hay operaciones para esta orden.'; }[m[41m  [m
[32m+[m
[32m+[m[32m        echo($rta);[m
     [m
     }[m
 ?>[m
[1mdiff --git a/admin/todopago_config.php b/admin/todopago_config.php[m
[1mindex 301831e..f8e1b24 100644[m
[1m--- a/admin/todopago_config.php[m
[1m+++ b/admin/todopago_config.php[m
[36m@@ -6,47 +6,34 @@[m
   Copyright (c) 2013 osCommerce[m
   Released under the GNU General Public License[m
 */[m
[31m-[m
[31m-    require('includes/application_top.php');[m
[31m-    require_once dirname(__FILE__).'/../includes/modules/payment/todopagoplugin/includes/TodoPago/lib/Sdk.php';[m
[31m-    require_once dirname(__FILE__).'/../includes/modules/payment/todopagoplugin/includes/todopago_ctes.php';[m
[31m-    [m
[31m-    require(DIR_WS_INCLUDES . 'template_top.php');[m
[31m-    $mensaje ="";[m
[31m-    [m
[31m-    if (isset($_POST["authorization"])){[m
[31m-        [m
[31m-        $autorization_post = str_replace('\"', '"', $_POST["authorization"]);[m
[31m-        [m
[31m-        if(json_decode($autorization_post) == NULL) {[m
[31m-            //armo json de autorization        [m
[31m-            $autorizationId = new stdClass();[m
[31m-            $autorizationId->Authorization = $_POST["authorization"];[m
[31m-            $_POST["authorization"] = json_encode($autorizationId);[m
[31m-        }[m
[31m-        [m
[31m-	    unset($_POST["submit"]);[m
[31m-        $query = "update todo_pago_configuracion set ";[m
[31m-        [m
[31m-        foreach($_POST as $key=>$value){[m
[31m-[m
[31m-            $query .= $key. "='".$value."',";[m
[31m-        [m
[31m-        }[m
[31m-        [m
[31m-        $query = trim($query,",");[m
[31m-        [m
[31m-        $res = tep_db_query($query);[m
[31m-        [m
[31m-        $mensaje = "La configuracion se guardo correctamente";[m
[32m+[m[32mrequire('includes/application_top.php');[m
[32m+[m[32mrequire_once dirname(__FILE__).'/../includes/modules/payment/todopagoplugin/includes/TodoPago/lib/Sdk.php';[m
[32m+[m[32mrequire_once dirname(__FILE__).'/../includes/modules/payment/todopagoplugin/includes/todopago_ctes.php';[m
[32m+[m[32mrequire(DIR_WS_INCLUDES . 'template_top.php');[m
[32m+[m[32m$mensaje ="";[m
[32m+[m[32m//valida y guarda codigo de autorizacion[m
[32m+[m[32mif (isset($_POST["authorization"]) && isset($_POST["submit"])){[m
[32m+[m[32m    $autorization_post = str_replace('\"', '"', $_POST["authorization"]);[m[41m     [m
[32m+[m[32m    if(json_decode($autorization_post) == NULL) {[m
[32m+[m[32m        //armo json de autorization[m[41m        [m
[32m+[m[32m        $autorizationId = new stdClass();[m
[32m+[m[32m        $autorizationId->Authorization = $_POST["authorization"];[m
[32m+[m[32m        $_POST["authorization"] = json_encode($autorizationId);[m
[32m+[m[32m    }[m[41m [m
[32m+[m[32m    unset($_POST["submit"]);[m
[32m+[m[32m    $query = "update todo_pago_configuracion set ";[m[41m        [m
[32m+[m[32m    foreach($_POST as $key=>$value){[m
[32m+[m[32m        $query .= $key. "='".$value."',";[m
     }[m
[31m-    //obtengo elementos del formulario[m
[31m-    $sql = "select * from todo_pago_configuracion";[m
[31m-    $res = tep_db_query($sql);[m
[31m-    $row = tep_db_fetch_array($res);[m
[31m-    $autorization = json_decode($row['authorization']);[m
[31m-    $medios_pago = json_decode($row['medios_pago'], 1);[m
[31m-[m
[32m+[m[32m    $query = trim($query,",");[m
[32m+[m[32m    $res = tep_db_query($query);[m
[32m+[m[32m    $mensaje = "La configuracion se guardo correctamente";[m
[32m+[m[32m}[m
[32m+[m[32m//obtengo elementos del formulario[m
[32m+[m[32m$sql = "select * from todo_pago_configuracion";[m
[32m+[m[32m$res = tep_db_query($sql);[m
[32m+[m[32m$row = tep_db_fetch_array($res);[m
[32m+[m[32m$autorization = json_decode($row['authorization']);[m
    [m
 ?>[m
 <link rel="stylesheet" type="text/css" href="../includes/modules/payment/todopagoplugin/todopago.css"/>[m
[36m@@ -59,561 +46,551 @@[m
 <script type="text/javascript" charset="utf8" src="ext/modules/payment/todopago/javascripts/jquery.dataTables.min.js"></script>[m
 <script type="text/javascript" charset="utf8" src="ext/modules/payment/todopago/javascripts/dataTables.tableTools.min.js"></script>[m
 [m
[31m-    <table border="0" width="100%" cellspacing="0" cellpadding="2">[m
[31m-      <tr>[m
[31m-        <td><table border="0" width="100%" cellspacing="0" cellpadding="2" height="40">[m
[31m-          <tr>[m
[31m-            <td class="pageHeading">TodoPago (v. <?php echo TP_VERSION; ?>) | Configuraci&oacute;n </td>[m
[31m-            <td align="right"></td>[m
[31m-            <td class="smallText" align="right"></td>[m
[31m-          </tr>[m
[31m-          <tr>[m
[31m-          <td colspan="3">[m
[31m-          <img src="http://www.todopago.com.ar/sites/todopago.com.ar/files/pluginstarjeta.jpg" />[m
[31m-          </td>[m
[31m-          </tr>[m
[31m-        </table></td>[m
[31m-      </tr>[m
[31m-      <tr>[m
[31m-      <td>  <?php echo $mensaje;?></td></tr>[m
[31m-      <tr>[m
[31m-        <td>[m
[31m-        [m
[31m-<div id="todopago">[m
[31m-  <ul class="secciones-todopago-config">[m
[31m-    <li><a class="tabs-todopago" todopago="#config">Configuracion</a></li>[m
[31m-    <li><a class="tabs-todopago" todopago="#prod">Productos</a></li>[m
[31m-    <!--li><a class="tabs-todopago" todopago="#mediosdepago">Medios de Pago</a></li-->[m
[31m-    <li><a class="tabs-todopago" todopago="#orden">Ordenes</a></li>[m
[31m-  </ul>[m
[31m-  <div id="config">  [m
[31m-        <form id="form" action="" method="post">[m
[31m-        <div class="input-todopago">[m
[31m-        <label>Authorization HTTP (c&oacute;digo de autorizacion)</label>[m
[31m-<input type="text" value='<?php echo  (isset($autorization->Authorization)? $autorization->Authorization:"")?>' placeholder="Authorization HTTP" name="authorization"/>           [m
[31m-        </div>[m
[31m-[m
[31m-<?php[m
[31m-$segmento = (isset($row["segmento"])?$row["segmento"]:"");[m
[31m-?>[m
[31m-<div class="input-todopago">[m
[31m- <label>Segmento del Comercio</label>[m
[31m-<select name="segmento">[m
[31m-<option value="">Seleccione</option>[m
[31m-<option value="retail" <?php echo ($segmento=="retail"?"selected":"")?>>Retail</option>[m
[31m-<!--<option value="ticketing" <?php echo ($segmento=="ticketing"?"selected":"")?>>Ticketing</option>[m
[31m-<option value="services" <?php echo ($segmento=="services"?"selected":"")?>>Services</option>[m
[31m-<option value="digital" <?php echo ($segmento=="digital"?"selected":"")?>>Digital Goods</option>-->[m
[31m-</select>[m
[31m-</div>[m
[31m-<?php[m
[31m-$canal = (isset($row["canal"])?$row["canal"]:"");[m
[31m-?>[m
[31m-[m
[31m-<!--<div class="input-todopago">[m
[31m- <label>Canal de Ingreso del Pedido</label>[m
[31m-<select name="canal">[m
[31m-<option value="">Seleccione</option>[m
[31m-<option value="web" <?php echo ($canal=="web"?"selected":"")?>>Web</option>[m
[31m-<option value="mobile" <?php echo ($canal=="mobile"?"selected":"")?>>Mobile</option>[m
[31m-<option value="telefonica" <?php echo ($canal=="telefonica"?"selected":"")?>>Telefonica</option>[m
[31m-</select>[m
[31m-</div>-->[m
[31m-<?php[m
[31m-$ambiente = (isset($row["ambiente"])?$row["ambiente"]:"");[m
[31m-?>[m
[31m-[m
[31m-<div class="input-todopago">[m
[31m-<label>Modo Desarrollo o Producci&oacute;n</label>[m
[31m-<select name="ambiente">[m
[31m-<option value="">Seleccione</option>[m
[31m-<option value="test" <?php echo ($ambiente=="test"?"selected":"")?>>Desarrollo</option>[m
[31m-<option value="production" <?php echo ($ambiente=="production"?"selected":"")?>>Producci&oacute;n</option>[m
[31m-</select>[m
[31m-</div>[m
[31m-[m
[31m-[m
[31m-<div class="input-todopago">[m
[31m-<label>Dead Line</label>[m
[31m-<input type="text" value="<?php echo  (isset($row["deadline"])?$row["deadline"]:"")?>" placeholder="Dead Line" name="deadline"/>[m
[31m-</div>[m
[31m-[m
[31m-<div class="subtitulo-todopago">AMBIENTE DESARROLLO</div>[m
[31m-[m
[31m-<div class="input-todopago">[m
[31m-<label>ID Site Todo Pago (Merchant ID)</label>[m
[31m-<input type="text" value="<?php echo  (isset($row["test_merchant"])?$row["test_merchant"]:"")?>" placeholder="ID Site Todo Pago" name="test_merchant"/>[m
[31m-</div>[m
[31m-[m
[31m-<div class="input-todopago">[m
[31m-<label>Security Code (Key sin PRISMA/TOD.. ni espacio)</label>[m
[31m-<input type="text" value="<?php echo  (isset($row["test_security"])?$row["test_security"]:"")?>" placeholder="Security Code" name="test_security"/>[m
[31m-</div>[m
[31m-<div class="subtitulo-todopago">AMBIENTE PRODUCCION</div>[m
[31m-[m
[31m-<div class="input-todopago">[m
[31m-<label>ID Site Todo Pago (Merchant ID)</label>[m
[31m-<input type="text" value="<?php echo  (isset($row["production_merchant"])?$row["production_merchant"]:"")?>" placeholder="ID Site Todo Pago" name="production_merchant"/>[m
[31m-</div>[m
[31m-[m
[31m-<div class="input-todopago">[m
[31m-<label>Security Code (Key sin PRISMA/TOD.. ni espacio)</label>[m
[31m-<input type="text" value="<?php echo  (isset($row["production_security"])?$row["production_security"]:"")?>" placeholder="Security Code" name="production_security"/>[m
[31m-</div> [m
[31m-<div class="subtitulo-todopago">ESTADOS DE LA ORDEN</div>[m
[31m-<div class="input-todopago">[m
[31m-<?php[m
[31m-[m
[31m-$sql = "select  orders_status_id,orders_status_name from ".TABLE_ORDERS_STATUS. " where language_id = 1";[m
[31m-[m
[31m-$res = tep_db_query($sql);[m
[31m- [m
[31m-while ($row1 = tep_db_fetch_array($res)){ [m
[31m-  //[m
[31m-    $opciones[$row1["orders_status_id"]] = $row1["orders_status_name"];[m
[31m-}[m
[31m-[m
[31m-?>[m
[31m-<label>Estado cuando la transaccion ha sido iniciada</label>[m
[31m-<select name="estado_inicio">[m
[31m-<?php[m
[31m-foreach($opciones as $key=>$value){[m
[31m-    $selected = "";[m
[31m-    if ($key == $row["estado_inicio"]) $selected ="selected"[m
[31m-?>[m
[31m-    [m
[31m-    <option <?php echo $selected?> value="<?php echo $key?>"><?php echo $value?></option>    [m
[31m-<?php[m
[31m-}[m
[31m-?>[m
[31m-[m
[31m-</select>[m
[31m-</div>[m
[31m-[m
[31m-<div class="input-todopago">[m
[31m-<label>Estado cuando la transaccion ha sido aprobada</label>[m
[31m-<select name="estado_aprobada">[m
[31m-<?php[m
[31m-foreach($opciones as $key=>$value){[m
[31m-     $selected = "";[m
[31m-    if ($key == $row["estado_aprobada"]) $selected ="selected"[m
[31m-    [m
[31m-?>[m
[31m-[m
[31m-    <option <?php echo $selected?> value="<?php echo $key?>"><?php echo $value?></option>    [m
[31m-<?php[m
[31m-}[m
[31m-?>[m
[31m-[m
[31m-</select>[m
[31m-[m
[31m-</div>[m
[31m-[m
[31m-<div class="input-todopago">[m
[31m-<label>Estado cuando la transaccion ha sido rechazada</label>[m
[31m-<select name="estado_rechazada">[m
[31m-<?php[m
[31m-foreach($opciones as $key=>$value){[m
[31m-     $selected = "";[m
[31m-    if ($key == $row["estado_rechazada"]) $selected ="selected"[m
[31m-?>[m
[31m-    <option <?php echo $selected?> value="<?php echo $key?>"><?php echo $value?></option>    [m
[31m-<?php[m
[31m-}[m
[31m-?>[m
[31m-[m
[31m-</select>[m
[31m-</div>[m
[31m-[m
[31m-<div class="input-todopago">[m
[31m-<label>Estado cuando la transaccion ha sido offline</label>[m
[31m-<select name="estado_offline">[m
[31m-<?php[m
[31m-foreach($opciones as $key=>$value){[m
[31m-     $selected = "";[m
[31m-    if ($key == $row["estado_offline"]) $selected ="selected"[m
[31m-?>[m
[31m-    <option <?php echo $selected?> value="<?php echo $key?>"><?php echo $value?></option>    [m
[31m-<?php[m
[31m-}[m
[31m-?>[m
[31m-[m
[31m-</select>[m
[31m-</div>[m
[31m-[m
[31m-<!--div class="subtitulo-todopago">FORMULARIO DE PAGO</div>[m
[31m-[m
[31m-<div class="input-todopago">[m
[31m-    <label style="float:left;">Seleccion el tipo de formulario de pago</label>[m
[31m-    <div style="float:left;">[m
[31m-        <div style="margin-bottom:8px;"><input type="radio" name="tipo_formulario" value="0" <?php echo ($row['tipo_formulario'] == 0)?'checked="checked"' :'' ?> >Formulario externo<br></div>[m
[31m-        <div><input type="radio" name="tipo_formulario" value="1" <?php echo ($row['tipo_formulario'] == 1)?'checked="checked"' :'' ?> >Formulario integrado al e-commerce</div>[m
[31m-    </div>  [m
[31m-    <div style="clear:both;"></div>  [m
[31m-</div>[m
[31m-<br><br-->[m
[31m-[m
[31m-<input  type="submit" name="submit" value="Guardar Datos"/>[m
[31m-</form>[m
[31m-</div>[m
[31m-<div id="prod">[m
[31m-<form action="" method="POST">[m
[31m-[m
[31m-[m
[31m-[m
[31m-<table id="data-table"  style="width:100%">[m
[31m-[m
[31m-<thead>[m
[31m-[m
[31m-<tr>[m
[31m-[m
[31m-<td>ID</td><td>Nombre</td><td>Codigo de Producto</td><td>Fecha Evento</td><td>Tipo de Envio</td><td>Tipo de Servicio</td><td>Tipo de Delivery</td><td>Editar</td>[m
[31m-[m
[31m-</tr> [m
[31m-[m
[31m-</thead>[m
[31m-[m
[31m-<tbody>[m
[31m-<?php[m
[31m-[m
[31m-$sql = "select p.products_id,pd.products_name,p.products_model from ". TABLE_PRODUCTS. " as p inner join ".TABLE_PRODUCTS_DESCRIPTION." as pd on p.products_id = pd.products_id where language_id=1";[m
[31m-$res = tep_db_query($sql);[m
[31m-// echo $sql;[m
[31m-$i =0;[m
[31m-while ($row = tep_db_fetch_array($res)){ [m
[31m-    $sql = "select * from todo_pago_atributos where product_id=".$row["products_id"];[m
[31m-    $res2 = tep_db_query($sql);[m
[31m-    $tipoDelivery = "";[m
[31m-    $tipoEnvio = "";[m
[31m-    $tipoServicio = "";[m
[31m-    $codigoProducto = "";[m
[31m-    $diasEvento = "";[m
[31m-    if ($row2 = tep_db_fetch_array($res2)){[m
[31m-        if ($row2["CSITPRODUCTCODE"] != "") $codigoProducto = $row2["CSITPRODUCTCODE"];[m
[31m-        if ($row2["CSMDD33"] != "") $diasEvento = $row2["CSMDD33"];[m
[31m-        if ($row2["CSMDD34"] != "") $tipoEnvio = $row2["CSMDD34"];[m
[31m-        if ($row2["CSMDD28"] != "") $tipoServicio = $row2["CSMDD28"];[m
[31m-        if ($row2["CSMDD31"] != "") $tipoDelivery = $row2["CSMDD31"];       [m
[31m-    }[m
[31m-    $i=$row["products_id"];[m
[31m- echo "<tr><td>".$row["products_id"]."</td><td id='nombre".$i."'>".$row["products_name"]."</td><td id='codigo".$i."'>".$codigoProducto."</td><td id='evento".$i."'>".$diasEvento."</td><td id='envio".$i."'>".$tipoEnvio."</td><td id='servicio".$i."'>".$tipoServicio."</td><td id='delivery".$i."'>".$tipoDelivery."</td><td class='editar' id='".$i."'>Editar</td></tr>";[m
[31m-}[m
[31m-    [m
[31m-?>[m
[31m-</tbody>[m
[31m-</table> [m
[31m-<div id="config-producto-todopago">[m
[31m-<div class="close-todopago">x</div>[m
[31m-    <table>[m
[31m-    <tr>[m
[31m-        <td align="center" id="titulo">Titulo del producto</td>[m
[31m-    </tr>[m
[32m+[m[32m<table border="0" width="100%" cellspacing="0" cellpadding="2">[m
     <tr>[m
         <td>[m
[31m-        <table>[m
[31m-       <tr>[m
[31m-    <td>Codigo de Producto</td>[m
[31m-    <td>[m
[31m-        <select id="codigo_producto">[m
[31m-            <option value="">- None -</option>[m
[31m-            <option value="adult_content">adult_content</option>[m
[31m-            <option value="coupon">coupon</option>[m
[31m-            <option value="default">default</option>[m
[31m-            <option value="electronic_good" selected="selected">electronic_good</option>[m
[31m-            <option value="electronic_software">electronic_software</option>[m
[31m-            <option value="gift_certificate">gift_certificate</option>[m
[31m-            <option value="handling_only">handling_only</option>[m
[31m-            <option value="service">service</option>[m
[31m-            <option value="shipping_and_handling">shipping_and_handling</option>[m
[31m-            <option value="shipping_only">shipping_only</option>[m
[31m-            <option value="subscription">subscription</option>[m
[31m-        </select>[m
[31m-    </td>[m
[31m-</tr>[m
[31m-<?php if($segmento=="ticketing"){ ?>[m
[31m-<tr>[m
[31m-    <td>Dias para el Evento</td>[m
[31m-    <td>[m
[31m-        <input id="dias_evento" type="text" value="" />[m
[31m-    </td>[m
[31m-</tr>[m
[31m-<tr>[m
[31m-    <td>Tipo de Envio</td>[m
[31m-    <td>[m
[31m-        <select id="envio_producto">[m
[31m-            <option value="">- None -</option>[m
[31m-            <option value="Pickup">Pickup</option>[m
[31m-            <option value="Email">Email</option>[m
[31m-            <option value="Smartphone">Smartphone</option>[m
[31m-            <option value="Other">Other</option>[m
[31m-        </select>[m
[31m-    </td>[m
[31m-</tr>[m
[31m-<?php } ?>[m
[31m-<?php if($segmento=="services"){ ?>[m
[31m-<tr>[m
[31m-    <td>Tipo de Delivery</td>[m
[31m-    <td>[m
[31m-        <select id="delivery_producto">[m
[31m-            <option value="">- None -</option>[m
[31m-            <option value="WEB Session">WEB Session</option>[m
[31m-            <option value="Email">Email</option>[m
[31m-            <option value="SmartPhone">SmartPhone</option>[m
[31m-        </select>[m
[31m-    </td>[m
[31m-</tr>[m
[31m-<tr>[m
[31m-    <td>Tipo de Servicio</td>[m
[31m-    <td>[m
[31m-        <select id="servicio_producto">[m
[31m-            <option value="">- None -</option>[m
[31m-            <option value="Luz">Luz</option>[m
[31m-            <option value="Gas">Gas</option>[m
[31m-            <option value="Agua">Agua</option>[m
[31m-            <option value="TV">TV</option>[m
[31m-            <option value="Cable">Cable</option>[m
[31m-            <option value="Internet">Internet</option>[m
[31m-            <option value="Impuestos">Impuestos</option>[m
[31m-        </select>[m
[31m-    </td>[m
[31m-</tr>[m
[31m-<?php } ?>[m
[31m-<tr>[m
[31m-    <td colspan="2">[m
[31m-        <input type="hidden" value="" id="id_producto" />[m
[31m-        <input id="guardar" type="button" value="Guardar" />[m
[31m-    </td>[m
[31m-</tr>[m
[31m-        </table>[m
[31m-        </td>[m
[31m-    </tr>[m
[31m-    </table>[m
[31m-</div>[m
[31m-<script type="text/javascript">[m
[31m-$(document).ready(function(){[m
[31m-    [m
[31m-    $('.close-todopago').click(function(){[m
[31m-        $('#config-producto-todopago').hide();[m
[31m-    });[m
[31m-    [m
[31m-    $("#guardar").click(function(){[m
[31m-        [m
[31m-        $('#config-producto-todopago').hide();[m
[31m-        $.post( "ext/modules/payment/todopago/todo_pago_config_ajax.php", [m
[31m-            { CSITPRODUCTCODE:$("#codigo_producto").val(), [m
[31m-              CSMDD33: $("#dias_evento").val(),  [m
[31m-              CSMDD34: $("#envio_producto").val() ,[m
[31m-              CSMDD28: $("#servicio_producto").val() ,[m
[31m-              CSMDD31: $("#delivery_producto").val() ,[m
[31m-              product_id: $("#id_producto").val()[m
[31m-            }, function(){[m
[31m-              [m
[31m-                $("#codigo"+$("#id_producto").val()).html($("#codigo_producto").val());[m
[31m-                $("#evento"+$("#id_producto").val()).html($("#dias_evento").val());[m
[31m-                $("#envio"+$("#id_producto").val()).html($("#envio_producto").val());[m
[31m-                $("#delivery"+$("#id_producto").val()).html($("#delivery_producto").val());[m
[31m-                $("#servicio"+$("#id_producto").val()).html($("#servicio_producto").val());            [m
[31m-            }[m
[31m-      ); [m
[31m-        [m
[31m-    });[m
[31m-    [m
[31m-    [m
[31m-    $(".editar").click(function(){[m
[31m-        [m
[31m-        $('#config-producto-todopago').hide();[m
[31m-        $('#config-producto-todopago').show();[m
[31m-        $("#id_producto").val($(this).attr("id"));[m
[31m-        $("#titulo").html($("#nombre"+$(this).attr("id")).html());[m
[31m-        $("#codigo_producto").val($("#codigo"+$(this).attr("id")).html());[m
[31m-        $("#dias_evento").val($("#evento"+$(this).attr("id")).html());[m
[31m-        $("#envio_producto").val($("#envio"+$(this).attr("id")).html());[m
[31m-        $("#delivery_producto").val($("#delivery"+$(this).attr("id")).html());[m
[31m-        $("#servicio_producto").val($("#servicio"+$(this).attr("id")).html());[m
[31m-[m
[31m-});[m
[31m-[m
[31m-$('#data-table').dataTable([m
[31m-                {bFilter: true, [m
[31m-                bInfo: true,[m
[31m-                bPaginate :true,[m
[31m-                [m
[31m-                });[m
[31m-  })  [m
[31m-[m
[31m-</script>[m
[31m-[m
[31m-[m
[31m-</form>[m
[31m-[m
[31m-</div>[m
[31m-<div id="orden">[m
[31m-<table id="orders-table"  style="width:100%">[m
[31m-[m
[31m-<thead>[m
[31m-[m
[31m-<tr>[m
[31m-[m
[31m-                                            <td>ID</td>[m
[31m-                                            <td>Nombre</td>[m
[31m-                                            <td>Telefono</td>[m
[31m-                                            <td>Email</td>[m
[31m-                                            <td>Fecha</td>[m
[31m-                                            <td>Status</td>[m
[31m-                                            <td>Devoluci&oacute;n</td>[m
[31m-                                            <td>GetStatus</td>[m
[31m-[m
[31m-</tr> [m
[31m-[m
[31m-</thead>[m
[31m-[m
[31m-<tbody>[m
[31m-<?php[m
[31m-[m
[31m-$sql = "select orders_id,customers_name,customers_telephone,customers_email_address,date_purchased,orders_status_name from ". TABLE_ORDERS. " as o inner join ". TABLE_ORDERS_STATUS. " as os on os.orders_status_id = o.orders_status order by date_purchased desc";[m
[31m-//echo $sql;[m
[31m-$res = tep_db_query($sql);[m
[31m-// echo $sql;[m
[31m-$i =0;[m
[31m-while ($row = tep_db_fetch_array($res)){ [m
[31m-    [m
[31m- echo "<tr><td>".$row["orders_id"]."</td><td>".$row["customers_name"]."</td><td>".$row["customers_telephone"]."</td><td>".$row["customers_email_address"]."</td><td>".$row["date_purchased"]."</td><td>".$row["orders_status_name"]."</td><td class='refund-td' data-order_id='".$row["orders_id"]."' style='cursor:pointer'>Devolver</td><td class='status' id='".$row["orders_id"]."' style='cursor:pointer'>Ver Status</td></tr>";[m
[31m-}[m
[31m-    [m
[31m-[m
[31m-?>[m
[31m-                                </tbody>[m
[31m-                                </table>[m
[31m-                                <div id="status-orders" class="order-action-popup">[m
[31m-                                    <div class="close-status-todopago close-todopago">x</div>[m
[31m-                                    <div id="status">[m
[31m-[m
[31m-                                    </div>[m
[31m-                                </div>[m
[31m-[m
[31m-                                <div id="refund-dialog" class="order-action-popup" hidden="hidden" style="display:block;">[m
[31m-                                    <div id="refund-form">[m
[31m-                                        <div class="close-refund-todopago close-todopago">x</div>[m
[31m-                                        <input type="hidden" id="order-id-hidden" />[m
[31m-                                        <label for="refund-type-select">Elija el tipo de devolucion: </label>[m
[31m-                                        <select id="refund-type-select" name="refund-type">[m
[31m-                                            <option value="total" selected="selected">Total</option>[m
[31m-                                            <option value="parcial">Parcial</option>[m
[31m-                                        </select>[m
[31m-                                        <p id="amount-div" hidden="hidden">[m
[31m-                                            <label for="amount-input">Monto: $</label>[m
[31m-                                            <input type="number" id="amount-input" name="amount" min=0.01 step=0.01 />[m
[31m-                                            <span id="invalid-amount-message" style="color: red;"><br />Ingrese un monto</span>[m
[31m-                                        </p>[m
[31m-                                        <p style="text-align: right;">[m
[31m-                                            <button id="refund-button">Devolver</button>[m
[31m-                                        </p>[m
[31m-                                    </div>[m
[31m-                                    <div id="refund-result"></div>[m
[31m-                                </div>[m
[31m-[m
[31m-</div>[m
[31m-</div>[m
[31m-[m
[31m-<script>[m
[31m-$(document).ready(function(){[m
[31m-[m
[31m-                                $('.close-status-todopago').click(function() {[m
[31m-                                    $('#status-orders').hide();[m
[31m-                                });[m
[31m-[m
[31m-                                $(".status").click(function() {[m
[31m-                                    $('.order-action-popup').hide();[m
[31m-                                    $.post( "ext/modules/payment/todopago/todo_pago_status_ajax.php",[m
[31m-                                           { order_id:$(this).attr("id"),[m
[31m-[m
[31m-                                                         }, function( data ) {[m
[31m-[m
[31m-                                                $("#status").html(data);[m
[31m-                                            $('#status-orders').show();[m
[31m-                                        });[m
[31m-                                });[m
[31m-[m
[31m-                                //Devoluciones[m
[31m-                                $(".close-refund-todopago").click(function() {[m
[31m-                                    $('#refund-dialog').hide();[m
[31m-                                    $('#refund-result').hide();[m
[31m-                                })[m
[31m-                                $("#orders-table").on("click", ".refund-td", function refundTd_click() {[m
[31m-                                    $('.order-action-popup').hide();[m
[31m-                                    $('#order-id-hidden').val($(this).attr("data-order_id"));[m
[31m-                                    $("#refund-result").hide();[m
[31m-                                    $("#invalid-amount-message").hide();[m
[31m-                                    $("#amount-input").val("");[m
[31m-                                    $('#refund-form').show();[m
[31m-                                    $('#refund-dialog').show();[m
[31m-                                });[m
[31m-[m
[31m-                                $("#refund-type-select").change(function refundTypeSelect_change() {[m
[31m-                                    if ($(this).val() == 'parcial') {[m
[31m-                                        $("#amount-div").show();[m
[31m-                                    } else {[m
[31m-                                        $("#amount-div").hide();[m
[31m-                                    }[m
[31m-                                });[m
[31m-[m
[31m-                                $("#refund-button").click(function refundButton_click() {[m
[31m-                                    if (isValidAmount()) {[m
[31m-                                        $.post("ext/modules/payment/todopago/todo_pago_devoluciones_ajax.php", {[m
[31m-                                            order_id: $("#order-id-hidden").val(),[m
[31m-                                            refund_type: $("#refund-type-select").val(),[m
[31m-                                            amount: $("#amount-input").val()[m
[31m-                                        }, function(response) {[m
[31m-                                            $("#refund-form").hide();[m
[31m-                                            $("#refund-result").html(response);[m
[31m-                                            $("#refund-result").show();[m
[31m-                                        })[m
[31m-                                    }[m
[31m-                                    else {[m
[31m-                                        $("#invalid-amount-message").show();[m
[31m-                                    }[m
[31m-                                });[m
[31m-                            });[m
[31m-[m
[31m-[m
[31m-[m
[31m-                            $('#orders-table').dataTable({[m
[31m-                            bFilter: true,[m
[31m-                            bInfo: true,[m
[31m-                            bPaginate: true,[m
[31m-                            });[m
[31m-                        </script>[m
[31m-                    </td>[m
[32m+[m[32m            <table border="0" width="100%" cellspacing="0" cellpadding="2" height="40">[m
[32m+[m[32m                <tr>[m
[32m+[m[32m                <td class="pageHeading">TodoPago (v. <?php echo TP_VERSION; ?>) | Configuraci&oacute;n </td>[m
[32m+[m[32m                <td align="right"></td>[m
[32m+[m[32m                <td class="smallText" align="right"></td>[m
[32m+[m[32m                </tr>[m
[32m+[m[32m                <tr>[m
[32m+[m[32m                <td colspan="3">[m
[32m+[m[32m                <img src="http://www.todopago.com.ar/sites/todopago.com.ar/files/pluginstarjeta.jpg" />[m
[32m+[m[32m                </td>[m
                 </tr>[m
             </table>[m
[31m-            <!--</td>[m
[31m-            </tr>[m
[31m-            </table>-->[m
[32m+[m[32m        </td>[m
[32m+[m[32m    </tr>[m
[32m+[m[32m    <tr>[m
[32m+[m[32m        <td><?php echo $mensaje;?></td>[m
[32m+[m[32m    </tr>[m
[32m+[m[32m    <tr>[m
[32m+[m[32m        <td>[m
[32m+[m[32m            <div id="todopago">[m
[32m+[m[32m                <ul class="secciones-todopago-config" >[m
[32m+[m[32m                    <li><a class="tabs-todopago" todopago="#config">Configuracion</a></li>[m
[32m+[m[32m                    <li><a class="tabs-todopago" todopago="#prod">Productos</a></li>[m
[32m+[m[32m                    <li><a class="tabs-todopago" todopago="#orden">Ordenes</a></li>[m
[32m+[m[32m                </ul>[m
[32m+[m[32m                <div id="config">[m
[32m+[m[32m                    <button id="btn-credentials" class="btn-config-credentials" >Obtener credenciales</button>[m
[32m+[m[32m                    <div id="credentials-login" class="order-action-popup" style="display:none;">[m
[32m+[m[32m                        <img src="http://www.todopago.com.ar/sites/todopago.com.ar/files/logo.png">[m
[32m+[m[32m                        <p>Ingresa con tus credenciales para Obtener los datos de configuración</p>[m[41m    [m
[32m+[m[41m                        [m
[32m+[m[32m                            <label class="control-label">E-mail</label>[m
[32m+[m[32m                            <input id="mail" class="form-control" name="mail" type="email" value="" placeholder="E-mail"/>[m
[32m+[m[32m                            <label class="control-label">Contrase&ntilde;a</label>[m
[32m+[m[32m                            <input id="pass" class="form-control" name="pass" type="password" value="" placeholder="Contrase&ntilde;a"/>[m
[32m+[m[32m                            <button id="btn-form-credentials" style="margin:20%;" class="btn-config-credentials" >Acceder</button>[m
[32m+[m[41m                        [m
[32m+[m[32m                    </div>[m
[32m+[m[32m                    <style>[m
[32m+[m[41m                     [m
[32m+[m[32m                    </style>[m
[32m+[m[41m                     [m
[32m+[m[32m                    <script type="text/javascript">[m
[32m+[m[32m                        $("#btn-credentials").click(function(){[m[41m   [m
[32m+[m[32m                            $( "#credentials-login" ).dialog();[m
[32m+[m[32m                        });[m
[32m+[m[32m                        $("#btn-form-credentials").click(function(){[m[41m [m
[32m+[m[32m                            console.log('obtengo credenciales por ajax.');[m
[32m+[m[32m                            $.post( "todopago_credentials.php",[m[41m [m
[32m+[m[32m                                    { mail: $("#mail").val(),[m[41m [m
[32m+[m[32m                                      pass: $("#pass").val()[m
[32m+[m[32m                                    }, function(data){[m[41m [m
[32m+[m[32m                                        var obj = jQuery.parseJSON( data );[m
[32m+[m[32m                                        if (obj.error_message != '0'){[m
[32m+[m[32m                                            console.log(obj.error_message);[m
[32m+[m[32m                                            alert(obj.error_message);[m
[32m+[m[32m                                        }else{[m[41m                        [m
[32m+[m[32m                                            $('input:text[name=authorization]').val(obj.Authorization);[m
[32m+[m[32m                                            if (obj.ambiente == 'test'){[m[41m [m
[32m+[m[32m                                                $('input:text[name=test_merchant]').val(obj.merchantId);[m
[32m+[m[32m                                                $('input:text[name=test_security]').val(obj.apiKey);[m
[32m+[m[32m                                            }else{[m
[32m+[m[32m                                                $('input:text[name=production_merchant]').val(obj.merchantId);[m
[32m+[m[32m                                                $('input:text[name=production_security]').val(obj.apiKey);[m
[32m+[m[32m                                            }[m
[32m+[m[32m                                        }[m[41m    [m
[32m+[m[32m                                    }[m
[32m+[m[32m                            );[m
[32m+[m[32m                            $("#credentials-login").dialog('close');[m
[32m+[m[32m                        });[m
[32m+[m[32m                    </script>[m
[32m+[m
[32m+[m
[32m+[m[32m                    <form id="form" action="" method="post">[m
[32m+[m[32m                        <div class="input-todopago">[m
[32m+[m[32m                            <label>Authorization HTTP (c&oacute;digo de autorizacion)</label>[m
[32m+[m[32m                            <input type="text" value='<?php echo  (isset($autorization->Authorization)? $autorization->Authorization:"")?>' placeholder="Authorization HTTP" name="authorization"/>[m[41m           [m
[32m+[m[32m                        </div>[m
[32m+[m[32m                        <?php[m
[32m+[m[32m                        $segmento = (isset($row["segmento"])?$row["segmento"]:"");[m
[32m+[m[32m                        ?>[m
[32m+[m[32m                        <div class="input-todopago">[m
[32m+[m[32m                            <label>Segmento del Comercio</label>[m
[32m+[m[32m                            <select name="segmento">[m
[32m+[m[32m                                <option value="">Seleccione</option>[m
[32m+[m[32m                                <option value="retail" <?php echo ($segmento=="retail"?"selected":"")?>>Retail</option>[m
[32m+[m[32m                                <!--<option value="ticketing" <?php echo ($segmento=="ticketing"?"selected":"")?>>Ticketing</option>[m
[32m+[m[32m                                <option value="services" <?php echo ($segmento=="services"?"selected":"")?>>Services</option>[m
[32m+[m[32m                                <option value="digital" <?php echo ($segmento=="digital"?"selected":"")?>>Digital Goods</option>-->[m
[32m+[m[32m                            </select>[m
[32m+[m[32m                        </div>[m
[32m+[m[32m                        <?php[m
[32m+[m[32m                        $canal = (isset($row["canal"])?$row["canal"]:"");[m
[32m+[m[32m                        ?>[m
[32m+[m
[32m+[m[32m                        <!--<div class="input-todopago">[m
[32m+[m[32m                         <label>Canal de Ingreso del Pedido</label>[m
[32m+[m[32m                        <select name="canal">[m
[32m+[m[32m                        <option value="">Seleccione</option>[m
[32m+[m[32m                        <option value="web" <?php echo ($canal=="web"?"selected":"")?>>Web</option>[m
[32m+[m[32m                        <option value="mobile" <?php echo ($canal=="mobile"?"selected":"")?>>Mobile</option>[m
[32m+[m[32m                        <option value="telefonica" <?php echo ($canal=="telefonica"?"selected":"")?>>Telefonica</option>[m
[32m+[m[32m                        </select>[m
[32m+[m[32m                        </div>-->[m
[32m+[m[32m                        <?php[m
[32m+[m[32m                        $ambiente = (isset($row["ambiente"])?$row["ambiente"]:"");[m
[32m+[m[32m                        ?>[m
[32m+[m[32m                        <div class="input-todopago">[m
[32m+[m[32m                            <label>Modo Desarrollo o Producci&oacute;n</label>[m
[32m+[m[32m                            <select name="ambiente">[m
[32m+[m[32m                            <option value="">Seleccione</option>[m
[32m+[m[32m                            <option value="test" <?php echo ($ambiente=="test"?"selected":"")?>>Desarrollo</option>[m
[32m+[m[32m                            <option value="production" <?php echo ($ambiente=="production"?"selected":"")?>>Producci&oacute;n</option>[m
[32m+[m[32m                            </select>[m
[32m+[m[32m                        </div>[m
[32m+[m[32m                        <div class="input-todopago">[m
[32m+[m[32m                            <label>Dead Line</label>[m
[32m+[m[32m                            <input type="text" value="<?php echo  (isset($row["deadline"])?$row["deadline"]:"")?>" placeholder="Dead Line" name="deadline"/>[m
[32m+[m[32m                        </div>[m
[32m+[m
[32m+[m[32m                        <div class="subtitulo-todopago">AMBIENTE DESARROLLO</div>[m
[32m+[m[32m                        <div class="input-todopago">[m
[32m+[m[32m                            <label>ID Site Todo Pago (Merchant ID)</label>[m
[32m+[m[32m                            <input type="text" value="<?php echo  (isset($row["test_merchant"])?$row["test_merchant"]:"")?>" placeholder="ID Site Todo Pago" name="test_merchant"/>[m
[32m+[m[32m                        </div>[m
[32m+[m[32m                        <div class="input-todopago">[m
[32m+[m[32m                            <label>Security Code (Key sin PRISMA/TOD.. ni espacio)</label>[m
[32m+[m[32m                            <input type="text" value="<?php echo  (isset($row["test_security"])?$row["test_security"]:"")?>" placeholder="Security Code" name="test_security"/>[m
[32m+[m[32m                        </div>[m
[32m+[m
[32m+[m[32m                        <div class="subtitulo-todopago">AMBIENTE PRODUCCION</div>[m
[32m+[m[32m                        <div class="input-todopago">[m
[32m+[m[32m                            <label>ID Site Todo Pago (Merchant ID)</label>[m
[32m+[m[32m                            <input type="text" value="<?php echo  (isset($row["production_merchant"])?$row["production_merchant"]:"")?>" placeholder="ID Site Todo Pago" name="production_merchant"/>[m
[32m+[m[32m                        </div>[m
[32m+[m[32m                        <div class="input-todopago">[m
[32m+[m[32m                            <label>Security Code (Key sin PRISMA/TOD.. ni espacio)</label>[m
[32m+[m[32m                            <input type="text" value="<?php echo  (isset($row["production_security"])?$row["production_security"]:"")?>" placeholder="Security Code" name="production_security"/>[m
[32m+[m[32m                        </div>[m[41m [m
[32m+[m
[32m+[m[32m                        <div class="subtitulo-todopago">ESTADOS DE LA ORDEN</div>[m
[32m+[m[32m                        <div class="input-todopago">[m
[32m+[m[32m                            <?php[m
[32m+[m[32m                            $sql = "select  orders_status_id,orders_status_name from ".TABLE_ORDERS_STATUS. " where language_id = 1";[m
[32m+[m[32m                            $res = tep_db_query($sql);[m
[32m+[m[32m                            while ($row1 = tep_db_fetch_array($res)){[m[41m [m
[32m+[m[32m                                $opciones[$row1["orders_status_id"]] = $row1["orders_status_name"];[m
[32m+[m[32m                            }[m
[32m+[m[32m                            ?>[m
[32m+[m[32m                            <label>Estado cuando la transaccion ha sido iniciada</label>[m
[32m+[m[32m                            <select name="estado_inicio">[m
[32m+[m[32m                                <?php[m
[32m+[m[32m                                foreach($opciones as $key=>$value){[m
[32m+[m[32m                                    $selected = "";[m
[32m+[m[32m                                    if ($key == $row["estado_inicio"]) $selected ="selected"[m
[32m+[m[32m                                ?>[m[41m                [m
[32m+[m[32m                                    <option <?php echo $selected?> value="<?php echo $key?>"><?php echo $value?></option>[m[41m    [m
[32m+[m[32m                                <?php[m
[32m+[m[32m                                }[m
[32m+[m[32m                                ?>[m
[32m+[m[32m                            </select>[m
[32m+[m[32m                        </div>[m
[32m+[m
[32m+[m[32m                        <div class="input-todopago">[m
[32m+[m[32m                            <label>Estado cuando la transaccion ha sido aprobada</label>[m
[32m+[m[32m                            <select name="estado_aprobada">[m
[32m+[m[32m                                <?php[m
[32m+[m[32m                                foreach($opciones as $key=>$value){[m
[32m+[m[32m                                     $selected = "";[m
[32m+[m[32m                                    if ($key == $row["estado_aprobada"]) $selected ="selected"[m[41m                   [m
[32m+[m[32m                                ?>[m
[32m+[m[32m                                    <option <?php echo $selected?> value="<?php echo $key?>"><?php echo $value?></option>[m[41m    [m
[32m+[m[32m                                <?php[m
[32m+[m[32m                                }[m
[32m+[m[32m                                ?>[m
[32m+[m[32m                            </select>[m
[32m+[m[32m                        </div>[m
[32m+[m
[32m+[m[32m                        <div class="input-todopago">[m
[32m+[m[32m                            <label>Estado cuando la transaccion ha sido rechazada</label>[m
[32m+[m[32m                            <select name="estado_rechazada">[m
[32m+[m[32m                                <?php[m
[32m+[m[32m                                foreach($opciones as $key=>$value){[m
[32m+[m[32m                                     $selected = "";[m
[32m+[m[32m                                    if ($key == $row["estado_rechazada"]) $selected ="selected"[m
[32m+[m[32m                                ?>[m
[32m+[m[32m                                    <option <?php echo $selected?> value="<?php echo $key?>"><?php echo $value?></option>[m[41m    [m
[32m+[m[32m                                <?php[m
[32m+[m[32m                                }[m
[32m+[m[32m                                ?>[m
[32m+[m[32m                            </select>[m
[32m+[m[32m                        </div>[m
[32m+[m
[32m+[m[32m                        <div class="input-todopago">[m
[32m+[m[32m                            <label>Estado cuando la transaccion ha sido offline</label>[m
[32m+[m[32m                            <select name="estado_offline">[m
[32m+[m[32m                                <?php[m
[32m+[m[32m                                foreach($opciones as $key=>$value){[m
[32m+[m[32m                                     $selected = "";[m
[32m+[m[32m                                    if ($key == $row["estado_offline"]) $selected ="selected"[m
[32m+[m[32m                                ?>[m
[32m+[m[32m                                    <option <?php echo $selected?> value="<?php echo $key?>"><?php echo $value?></option>[m[41m    [m
[32m+[m[32m                                <?php[m
[32m+[m[32m                                }[m
[32m+[m[32m                                ?>[m
[32m+[m[32m                            </select>[m
[32m+[m[32m                        </div>[m
[32m+[m
[32m+[m[32m                        <div class="subtitulo-todopago">FORMULARIO DE PAGO</div>[m
[32m+[m[32m                        <div class="input-todopago">[m
[32m+[m[32m                            <label style="float:left;">Seleccion el tipo de formulario de pago</label>[m
[32m+[m[32m                            <div style="float:left;">[m
[32m+[m[32m                                <div style="margin-bottom:8px;"><input type="radio" name="tipo_formulario" value="0" <?php echo ($row['tipo_formulario'] == 0)?'checked="checked"' :'' ?> >Formulario externo<br></div>[m
[32m+[m[32m                                <div><input type="radio" name="tipo_formulario" value="1" <?php echo ($row['tipo_formulario'] == 1)?'checked="checked"' :'' ?> >Formulario integrado al e-commerce</div>[m
[32m+[m[32m                            </div>[m[41m  [m
[32m+[m[32m                            <div style="clear:both;"></div>[m[41m  [m
[32m+[m[32m                        </div>[m
[32m+[m[32m                        <br><br>[m
[32m+[m[32m                        <input  type="submit" name="submit" value="Guardar Datos"/>[m
[32m+[m[32m                    </form>[m
[32m+[m[32m                </div>[m
[32m+[m[32m                <div id="prod">[m
[32m+[m[32m                    <form action="" method="POST">[m
[32m+[m[32m                        <table id="data-table"  style="width:100%">[m
[32m+[m[32m                            <thead>[m
[32m+[m[32m                                <tr>[m
[32m+[m[32m                                    <td>ID</td>[m
[32m+[m[32m                                    <td>Nombre</td>[m
[32m+[m[32m                                    <td>Codigo de Producto</td>[m
[32m+[m[32m                                    <td>Fecha Evento</td>[m
[32m+[m[32m                                    <td>Tipo de Envio</td>[m
[32m+[m[32m                                    <td>Tipo de Servicio</td>[m
[32m+[m[32m                                    <td>Tipo de Delivery</td>[m
[32m+[m[32m                                    <td>Editar</td>[m
[32m+[m[32m                                </tr>[m
[32m+[m[32m                            </thead>[m
[32m+[m[32m                            <tbody>[m
[32m+[m[32m                                <?php[m
[32m+[m[32m                                $sql = "select p.products_id,pd.products_name,p.products_model from ". TABLE_PRODUCTS. " as p inner join ".TABLE_PRODUCTS_DESCRIPTION." as pd on p.products_id = pd.products_id where language_id=1";[m
[32m+[m[32m                                $res = tep_db_query($sql);[m
[32m+[m[32m                                // echo $sql;[m
[32m+[m[32m                                $i =0;[m
[32m+[m[32m                                while ($row = tep_db_fetch_array($res)){[m[41m [m
[32m+[m[32m                                    $sql = "select * from todo_pago_atributos where product_id=".$row["products_id"];[m
[32m+[m[32m                                    $res2 = tep_db_query($sql);[m
[32m+[m[32m                                    $tipoDelivery = "";[m
[32m+[m[32m                                    $tipoEnvio = "";[m
[32m+[m[32m                                    $tipoServicio = "";[m
[32m+[m[32m                                    $codigoProducto = "";[m
[32m+[m[32m                                    $diasEvento = "";[m
[32m+[m[32m                                    if ($row2 = tep_db_fetch_array($res2)){[m
[32m+[m[32m                                        if ($row2["CSITPRODUCTCODE"] != "") $codigoProducto = $row2["CSITPRODUCTCODE"];[m
[32m+[m[32m                                        if ($row2["CSMDD33"] != "") $diasEvento = $row2["CSMDD33"];[m
[32m+[m[32m                                        if ($row2["CSMDD34"] != "") $tipoEnvio = $row2["CSMDD34"];[m
[32m+[m[32m                                        if ($row2["CSMDD28"] != "") $tipoServicio = $row2["CSMDD28"];[m
[32m+[m[32m                                        if ($row2["CSMDD31"] != "") $tipoDelivery = $row2["CSMDD31"];[m[41m       [m
[32m+[m[32m                                    }[m
[32m+[m[32m                                    $i=$row["products_id"];[m
[32m+[m[32m                                    echo "<tr><td>".$row["products_id"]."</td><td id='nombre".$i."'>".$row["products_name"]."</td><td id='codigo".$i."'>".$codigoProducto."</td><td id='evento".$i."'>".$diasEvento."</td><td id='envio".$i."'>".$tipoEnvio."</td><td id='servicio".$i."'>".$tipoServicio."</td><td id='delivery".$i."'>".$tipoDelivery."</td><td class='editar' id='".$i."'>Editar</td></tr>";[m
[32m+[m[32m                                }[m
[32m+[m[41m                                    [m
[32m+[m[32m                                ?>[m
[32m+[m[32m                            </tbody>[m
[32m+[m[32m                        </table>[m[41m [m
[32m+[m[32m                        <div id="config-producto-todopago">[m
[32m+[m[32m                            <div class="close-todopago">x</div>[m
[32m+[m[32m                            <table>[m
[32m+[m[32m                                <tr>[m
[32m+[m[32m                                    <td align="center" id="titulo">Titulo del producto</td>[m
[32m+[m[32m                                </tr>[m
[32m+[m[32m                                <tr>[m
[32m+[m[32m                                    <td>[m
[32m+[m[32m                                        <table>[m
[32m+[m[32m                                            <tr>[m
[32m+[m[32m                                                <td>Codigo de Producto</td>[m
[32m+[m[32m                                                <td>[m
[32m+[m[32m                                                    <select id="codigo_producto">[m
[32m+[m[32m                                                        <option value="">- None -</option>[m
[32m+[m[32m                                                        <option value="adult_content">adult_content</option>[m
[32m+[m[32m                                                        <option value="coupon">coupon</option>[m
[32m+[m[32m                                                        <option value="default">default</option>[m
[32m+[m[32m                                                        <option value="electronic_good" selected="selected">electronic_good</option>[m
[32m+[m[32m                                                        <option value="electronic_software">electronic_software</option>[m
[32m+[m[32m                                                        <option value="gift_certificate">gift_certificate</option>[m
[32m+[m[32m                                                        <option value="handling_only">handling_only</option>[m
[32m+[m[32m                                                        <option value="service">service</option>[m
[32m+[m[32m                                                        <option value="shipping_and_handling">shipping_and_handling</option>[m
[32m+[m[32m                                                        <option value="shipping_only">shipping_only</option>[m
[32m+[m[32m                                                        <option value="subscription">subscription</option>[m
[32m+[m[32m                                                    </select>[m
[32m+[m[32m                                                </td>[m
[32m+[m[32m                                            </tr>[m
[32m+[m[32m                                            <?php if($segmento=="ticketing"){ ?>[m
[32m+[m[32m                                            <tr>[m
[32m+[m[32m                                                <td>Dias para el Evento</td>[m
[32m+[m[32m                                                <td>[m
[32m+[m[32m                                                    <input id="dias_evento" type="text" value="" />[m
[32m+[m[32m                                                </td>[m
[32m+[m[32m                                            </tr>[m
[32m+[m[32m                                            <tr>[m
[32m+[m[32m                                                <td>Tipo de Envio</td>[m
[32m+[m[32m                                                <td>[m
[32m+[m[32m                                                    <select id="envio_producto">[m
[32m+[m[32m                                                        <option value="">- None -</option>[m
[32m+[m[32m                                                        <option value="Pickup">Pickup</option>[m
[32m+[m[32m                                                        <option value="Email">Email</option>[m
[32m+[m[32m                                                        <option value="Smartphone">Smartphone</option>[m
[32m+[m[32m                                                        <option value="Other">Other</option>[m
[32m+[m[32m                                                    </select>[m
[32m+[m[32m                                                </td>[m
[32m+[m[32m                                            </tr>[m
[32m+[m[32m                                            <?php } ?>[m
[32m+[m[32m                                            <?php if($segmento=="services"){ ?>[m
[32m+[m[32m                                            <tr>[m
[32m+[m[32m                                                <td>Tipo de Delivery</td>[m
[32m+[m[32m                                                <td>[m
[32m+[m[32m                                                    <select id="delivery_producto">[m
[32m+[m[32m                                                        <option value="">- None -</option>[m
[32m+[m[32m                                                        <option value="WEB Session">WEB Session</option>[m
[32m+[m[32m                                                        <option value="Email">Email</option>[m
[32m+[m[32m                                                        <option value="SmartPhone">SmartPhone</option>[m
[32m+[m[32m                                                    </select>[m
[32m+[m[32m                                                </td>[m
[32m+[m[32m                                            </tr>[m
[32m+[m[32m                                            <tr>[m
[32m+[m[32m                                                <td>Tipo de Servicio</td>[m
[32m+[m[32m                                                <td>[m
[32m+[m[32m                                                    <select id="servicio_producto">[m
[32m+[m[32m                                                        <option value="">- None -</option>[m
[32m+[m[32m                                                        <option value="Luz">Luz</option>[m
[32m+[m[32m                                                        <option value="Gas">Gas</option>[m
[32m+[m[32m                                                        <option value="Agua">Agua</option>[m
[32m+[m[32m                                                        <option value="TV">TV</option>[m
[32m+[m[32m                                                        <option value="Cable">Cable</option>[m
[32m+[m[32m                                                        <option value="Internet">Internet</option>[m
[32m+[m[32m                                                        <option value="Impuestos">Impuestos</option>[m
[32m+[m[32m                                                    </select>[m
[32m+[m[32m                                                </td>[m
[32m+[m[32m                                            </tr>[m
[32m+[m[32m                                            <?php } ?>[m
[32m+[m[32m                                            <tr>[m
[32m+[m[32m                                                <td colspan="2">[m
[32m+[m[32m                                                    <input type="hidden" value="" id="id_producto" />[m
[32m+[m[32m                                                    <input id="guardar" type="button" value="Guardar" />[m
[32m+[m[32m                                                </td>[m
[32m+[m[32m                                            </tr>[m
[32m+[m[32m                                        </table>[m
[32m+[m[32m                                    </td>[m
[32m+[m[32m                                </tr>[m
[32m+[m[32m                            </table>[m
[32m+[m[32m                        </div>[m
[32m+[m[32m                        <script type="text/javascript">[m
[32m+[m[32m                            $(document).ready(function(){[m
[32m+[m[41m                                [m
[32m+[m[32m                                $('.close-todopago').click(function(){[m
[32m+[m[32m                                    $('#config-producto-todopago').hide();[m
[32m+[m[32m                                });[m
[32m+[m[41m                                [m
[32m+[m[32m                                $("#guardar").click(function(){[m
[32m+[m[41m                                    [m
[32m+[m[32m                                    $('#config-producto-todopago').hide();[m
[32m+[m[32m                                    $.post( "ext/modules/payment/todopago/todo_pago_config_ajax.php",[m[41m [m
[32m+[m[32m                                        { CSITPRODUCTCODE:$("#codigo_producto").val(),[m[41m [m
[32m+[m[32m                                          CSMDD33: $("#dias_evento").val(),[m[41m  [m
[32m+[m[32m                                          CSMDD34: $("#envio_producto").val() ,[m
[32m+[m[32m                                          CSMDD28: $("#servicio_producto").val() ,[m
[32m+[m[32m                                          CSMDD31: $("#delivery_producto").val() ,[m
[32m+[m[32m                                          product_id: $("#id_producto").val()[m
[32m+[m[32m                                        }, function(){[m
[32m+[m[41m                                          [m
[32m+[m[32m                                            $("#codigo"+$("#id_producto").val()).html($("#codigo_producto").val());[m
[32m+[m[32m                                            $("#evento"+$("#id_producto").val()).html($("#dias_evento").val());[m
[32m+[m[32m                                            $("#envio"+$("#id_producto").val()).html($("#envio_producto").val());[m
[32m+[m[32m                                            $("#delivery"+$("#id_producto").val()).html($("#delivery_producto").val());[m
[32m+[m[32m                                            $("#servicio"+$("#id_producto").val()).html($("#servicio_producto").val());[m[41m            [m
[32m+[m[32m                                        }[m
[32m+[m[32m                                  );[m[41m [m
[32m+[m[41m                                    [m
[32m+[m[32m                                });[m
[32m+[m[41m                                [m
[32m+[m[41m                                [m
[32m+[m[32m                                $(".editar").click(function(){[m
[32m+[m[41m                                    [m
[32m+[m[32m                                    $('#config-producto-todopago').hide();[m
[32m+[m[32m                                    $('#config-producto-todopago').show();[m
[32m+[m[32m                                    $("#id_producto").val($(this).attr("id"));[m
[32m+[m[32m                                    $("#titulo").html($("#nombre"+$(this).attr("id")).html());[m
[32m+[m[32m                                    $("#codigo_producto").val($("#codigo"+$(this).attr("id")).html());[m
[32m+[m[32m                                    $("#dias_evento").val($("#evento"+$(this).attr("id")).html());[m
[32m+[m[32m                                    $("#envio_producto").val($("#envio"+$(this).attr("id")).html());[m
[32m+[m[32m                                    $("#delivery_producto").val($("#delivery"+$(this).attr("id")).html());[m
[32m+[m[32m                                    $("#servicio_producto").val($("#servicio"+$(this).attr("id")).html());[m
[32m+[m[32m                            });[m
[32m+[m[32m                            $('#data-table').dataTable([m
[32m+[m[32m                                            {bFilter: true,[m[41m [m
[32m+[m[32m                                            bInfo: true,[m
[32m+[m[32m                                            bPaginate :true,[m
[32m+[m[41m                                            [m
[32m+[m[32m                                            });[m
[32m+[m[32m                              })[m[41m  [m
[32m+[m[32m                        </script>[m
[32m+[m[32m                    </form>[m
[32m+[m[32m                </div>[m
[32m+[m[32m                <div id="orden">[m
[32m+[m[32m                    <table id="orders-table"  style="width:100%">[m
[32m+[m[32m                        <thead>[m
[32m+[m[32m                            <tr>[m
[32m+[m[32m                                <td>ID</td>[m
[32m+[m[32m                                <td>Nombre</td>[m
[32m+[m[32m                                <td>Telefono</td>[m
[32m+[m[32m                                <td>Email</td>[m
[32m+[m[32m                                <td>Fecha</td>[m
[32m+[m[32m                                <td>Status</td>[m
[32m+[m[32m                                <td>Devoluci&oacute;n</td>[m
[32m+[m[32m                                <td>GetStatus</td>[m
[32m+[m[32m                            </tr>[m
[32m+[m[32m                        </thead>[m
[32m+[m[32m                        <tbody>[m
[32m+[m[32m                            <?php[m
[32m+[m[32m                            $sql = "select orders_id,customers_name,customers_telephone,customers_email_address,date_purchased,orders_status_name from ". TABLE_ORDERS. " as o inner join ". TABLE_ORDERS_STATUS. " as os on os.orders_status_id = o.orders_status order by date_purchased desc";[m
[32m+[m[32m                            //echo $sql;[m
[32m+[m[32m                            $res = tep_db_query($sql);[m
[32m+[m[32m                            // echo $sql;[m
[32m+[m[32m                            $i =0;[m
[32m+[m[32m                            while ($row = tep_db_fetch_array($res)){[m[41m [m
[32m+[m[41m                                [m
[32m+[m[32m                             echo "<tr><td>".$row["orders_id"]."</td><td>".$row["customers_name"]."</td><td>".$row["customers_telephone"]."</td><td>".$row["customers_email_address"]."</td><td>".$row["date_purchased"]."</td><td>".$row["orders_status_name"]."</td><td class='refund-td' data-order_id='".$row["orders_id"]."' style='cursor:pointer'>Devolver</td><td class='status' id='".$row["orders_id"]."' style='cursor:pointer'>Ver Status</td></tr>";[m
[32m+[m[32m                            }[m
[32m+[m[41m                                [m
[32m+[m[32m                            ?>[m
[32m+[m[32m                        </tbody>[m
[32m+[m[32m                    </table>[m
[32m+[m[32m                    <div id="status-orders" class="order-action-popup">[m
[32m+[m[32m                        <div class="close-status-todopago close-todopago">x</div>[m
[32m+[m[32m                        <div id="status">[m
[32m+[m[32m                        </div>[m
[32m+[m[32m                    </div>[m
[32m+[m[32m                    <div id="refund-dialog" class="order-action-popup" hidden="hidden" style="display:block;">[m
[32m+[m[32m                        <div id="refund-form">[m
[32m+[m[32m                            <div class="close-refund-todopago close-todopago">x</div>[m
[32m+[m[32m                            <input type="hidden" id="order-id-hidden" />[m
[32m+[m[32m                            <label for="refund-type-select">Elija el tipo de devolucion: </label>[m
[32m+[m[32m                            <select id="refund-type-select" name="refund-type">[m
[32m+[m[32m                                <option value="total" selected="selected">Total</option>[m
[32m+[m[32m                                <option value="parcial">Parcial</option>[m
[32m+[m[32m                            </select>[m
[32m+[m[32m                            <p id="amount-div" hidden="hidden">[m
[32m+[m[32m                                <label for="amount-input">Monto: $</label>[m
[32m+[m[32m                                <input type="number" id="amount-input" name="amount" min=0.01 step=0.01 />[m
[32m+[m[32m                                <span id="invalid-amount-message" style="color: red;"><br />Ingrese un monto</span>[m
[32m+[m[32m                            </p>[m
[32m+[m[32m                            <p style="text-align: right;">[m
[32m+[m[32m                                <button id="refund-button">Devolver</button>[m
[32m+[m[32m                            </p>[m
[32m+[m[32m                        </div>[m
[32m+[m[32m                        <div id="refund-result"></div>[m
[32m+[m[32m                    </div>[m
[32m+[m[32m                </div>[m
[32m+[m[32m            </div>[m
             <script>[m
[31m-                $(document).ready(function() {[m
[31m-[m
[31m-                    $("#prod").hide();[m
[31m-                    $("#orden").hide();[m
[31m-[m
[31m-                    $(".tabs-todopago").each(function() {[m
[31m-                        $(this).css("cursor", "pointer");[m
[31m-[m
[32m+[m[32m                $(document).ready(function(){[m
[32m+[m[32m                    $('.close-status-todopago').click(function() {[m
[32m+[m[32m                        $('#status-orders').hide();[m
[32m+[m[32m                    });[m
[32m+[m[32m                    $("#orders-table").on("click", ".status", function status() {[m
[32m+[m[32m                        $('.order-action-popup').hide();[m
[32m+[m[32m                        $.post( "ext/modules/payment/todopago/todo_pago_status_ajax.php",[m
[32m+[m[32m                               { order_id:$(this).attr("id"),[m
[32m+[m[32m                                             }, function( data ) {[m
[32m+[m[32m                                    $("#status").html(data);[m
[32m+[m[32m                                $('#status-orders').show();[m
[32m+[m[32m                            });[m
[32m+[m[32m                    });[m
[32m+[m[32m                    //Devoluciones[m
[32m+[m[32m                    $(".close-refund-todopago").click(function() {[m
[32m+[m[32m                        $('#refund-dialog').hide();[m
[32m+[m[32m                        $('#refund-result').hide();[m
                     })[m
[31m-                    $(".tabs-todopago").click(function() {[m
[31m-                        $("#config").hide();[m
[31m-                        $("#prod").hide();[m
[31m-                        $("#orden").hide();[m
[31m-[m
[31m-                        $("" + $(this).attr("todopago") + "").show();[m
[31m-                    })[m
[31m-[m
[32m+[m[32m                    $("#orders-table").on("click", ".refund-td", function refundTd_click() {[m
[32m+[m[32m                        $('.order-action-popup').hide();[m
[32m+[m[32m                        $('#order-id-hidden').val($(this).attr("data-order_id"));[m
[32m+[m[32m                        $("#refund-result").hide();[m
[32m+[m[32m                        $("#invalid-amount-message").hide();[m
[32m+[m[32m                        $("#amount-input").val("");[m
[32m+[m[32m                        $('#refund-form').show();[m
[32m+[m[32m                        $('#refund-dialog').show();[m
[32m+[m[32m                    });[m
[32m+[m[32m                    $("#refund-type-select").change(function refundTypeSelect_change() {[m
[32m+[m[32m                        if ($(this).val() == 'parcial') {[m
[32m+[m[32m                            $("#amount-div").show();[m
[32m+[m[32m                        } else {[m
[32m+[m[32m                            $("#amount-div").hide();[m
[32m+[m[32m                        }[m
[32m+[m[32m                    });[m
[32m+[m[32m                    $("#refund-button").click(function refundButton_click() {[m
[32m+[m[32m                        if (isValidAmount()) {[m
[32m+[m[32m                            $.post("ext/modules/payment/todopago/todo_pago_devoluciones_ajax.php", {[m
[32m+[m[32m                                order_id: $("#order-id-hidden").val(),[m
[32m+[m[32m                                refund_type: $("#refund-type-select").val(),[m
[32m+[m[32m                                amount: $("#amount-input").val()[m
[32m+[m[32m                            }, function(response) {[m
[32m+[m[32m                                $("#refund-form").hide();[m
[32m+[m[32m                                $("#refund-result").html(response);[m
[32m+[m[32m                                $("#refund-result").show();[m
[32m+[m[32m                            })[m
[32m+[m[32m                        }[m
[32m+[m[32m                        else {[m
[32m+[m[32m                            $("#invalid-amount-message").show();[m
[32m+[m[32m                        }[m
[32m+[m[32m                    });[m
[32m+[m[32m                });[m
[32m+[m[32m                $('#orders-table').dataTable({[m
[32m+[m[32m                bFilter: true,[m
[32m+[m[32m                bInfo: true,[m
[32m+[m[32m                bPaginate: true,[m
                 });[m
[31m-[m
[31m-                function isValidAmount() {[m
[31m-                    return (($("#refund-type-select").val() == 'parcial' && !isNaN($("#amount-input").val()) && isFinite($("#amount-input").val()) && $("#amount-input").val() != "") || $("#refund-type-select").val() == 'total');[m
[31m-                }[m
             </script>[m
[31m-    </body>[m
[31m-    <?php[m
[32m+[m[32m        </td>[m
[32m+[m[32m    </tr>[m
[32m+[m[32m</table>[m
[32m+[m[32m<!--</td>[m
[32m+[m[32m</tr>[m
[32m+[m[32m</table>-->[m
[32m+[m[32m<script>[m
[32m+[m[32m    $(document).ready(function() {[m
[32m+[m[32m        $("#prod").hide();[m
[32m+[m[32m        $("#orden").hide();[m
[32m+[m[32m        $(".tabs-todopago").each(function() {[m
[32m+[m[32m            $(this).css("cursor", "pointer");[m
[32m+[m[32m        })[m
[32m+[m[32m        $(".tabs-todopago").click(function() {[m
[32m+[m[32m            $("#config").hide();[m
[32m+[m[32m            $("#prod").hide();[m
[32m+[m[32m            $("#orden").hide();[m
[32m+[m[32m            $("" + $(this).attr("todopago") + "").show();[m
[32m+[m[32m        })[m
[32m+[m[32m    });[m
[32m+[m[32m    function isValidAmount() {[m
[32m+[m[32m        return (($("#refund-type-select").val() == 'parcial' && !isNaN($("#amount-input").val()) && isFinite($("#amount-input").val()) && $("#amount-input").val() != "") || $("#refund-type-select").val() == 'total');[m
[32m+[m[32m    }[m
[32m+[m[32m</script>[m
[32m+[m[32m</body>[m
[32m+[m[32m<?php[m
   require(DIR_WS_INCLUDES . 'application_bottom.php');[m
[31m-?>[m
[32m+[m[32m?>[m
\ No newline at end of file[m
[1mdiff --git a/includes/modules/payment/todopagoplugin.php b/includes/modules/payment/todopagoplugin.php[m
[1mindex 638971c..e178638 100644[m
[1m--- a/includes/modules/payment/todopagoplugin.php[m
[1m+++ b/includes/modules/payment/todopagoplugin.php[m
[36m@@ -45,7 +45,7 @@[m [mclass todopagoplugin {[m
 [m
         if (is_object($order)) $this->update_status();[m
 [m
[31m-        $this->logo = '/includes/modules/payment/todopagoplugin/includes/todopago.jpg';[m
[32m+[m[32m        $this->logo = 'http://www.todopago.com.ar/sites/todopago.com.ar/files/pluginstarjeta.jpg';[m
     }[m
 [m
 [m
[36m@@ -66,7 +66,7 @@[m [mclass todopagoplugin {[m
 [m
         return array('id' => $this->code,[m
 [m
[31m-                     'module' => '<img src="'.DIR_WS_CATALOG.$this->logo.'" />',[m
[32m+[m[32m                     'module' => '<img src="'.$this->logo.'" />',[m
                      'icon' => '<img src="'.DIR_WS_CATALOG.$this->logo.'" />');[m
 [m
     }[m
[36m@@ -166,7 +166,6 @@[m [mclass todopagoplugin {[m
             tep_draw_hidden_field('url_succesfull', tep_href_link(FILENAME_CHECKOUT_PROCESS, '', 'SSL')) . [m
 [m
             tep_draw_hidden_field('enc', MODULE_PAYMENT_TODOPAGOPLUGIN_CODE);[m
[31m-        [m
 [m
     }[m
 [m
[36m@@ -182,6 +181,7 @@[m [mclass todopagoplugin {[m
         return $string;[m
     }[m
 [m
[32m+[m
     function after_process() {[m
         $dir = DIR_WS_INCLUDES.'work'.DIRECTORY_SEPARATOR.'todopago.log';[m
         [m
[36m@@ -205,23 +205,33 @@[m [mclass todopagoplugin {[m
         return $this->_check;[m
     }[m
 [m
[31m-[m
[31m-[m
     function install() {[m
 [m
[31m-        tep_db_query("insert into " . TABLE_CONFIGURATION . " (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) values ('Habilitar módulo TodoPago', 'MODULE_PAYMENT_TODOPAGOPLUGIN_STATUS', 'True', 'Desea aceptar pagos a traves de TodoPago?', '6', '3', 'tep_cfg_select_option(array(\'True\', \'False\'), ', now())");[m
[32m+[m[32m        ?>[m
[32m+[m[32m<script>[m
[32m+[m[32m        $('#pop-up-message').html("\[m
[32m+[m[32m            <p>Se le informa que se realizar&aacute;n los siguientes cambios:</p>   \[m
[32m+[m[32m            <ul>    \[m
[32m+[m[32m                <li>Se agregar&acute;n campos en la tabla de configuraci&oacute;n propios del m&oacute;dulo</li>    \[m
[32m+[m[32m                <li>Se agregar&acute; una tabla <em><?php echo TABLE_TP_CONFIGURACION ?></em> para parametros de configuración adicionales</li>    \[m
[32m+[m[32m                <li>Se agregar&aacute; una tabla <em>todopago_transaccion</em> a su base de datos la cu&aacute;l guardar&aacute; informaci&oacute;n sobre las transacciones realizadas por el medio de pago.</li>   \[m
[32m+[m[32m            </ul>   \[m
[32m+[m[32m        ");[m
[32m+[m[32m        $('#pop-up').show();[m
[32m+[m[32m</script>[m
 [m
[32m+[m[32m        <?php[m
[32m+[m[32m        tep_db_query("insert into " . TABLE_CONFIGURATION . " (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, set_function, date_added) values ('Habilitar módulo TodoPago', 'MODULE_PAYMENT_TODOPAGOPLUGIN_STATUS', 'True', 'Desea aceptar pagos a traves de TodoPago?', '6', '3', 'tep_cfg_select_option(array(\'True\', \'False\'), ', now())");[m
 [m
         tep_db_query("insert into " . TABLE_CONFIGURATION . " (configuration_title, configuration_key, configuration_value, configuration_description, configuration_group_id, sort_order, date_added) values ('Sort order of display.', 'MODULE_PAYMENT_TODOPAGOPLUGIN_SORT_ORDER', '0', 'Order de despliegue. El mas bajo se despliega primero.', '6', '0', now())");[m
 [m
[31m-[m
         tep_db_query("CREATE TABLE IF NOT EXISTS `".TABLE_TP_ATRIBUTOS."` ( `product_id` BIGINT NOT NULL , `CSITPRODUCTCODE` VARCHAR(150) NOT NULL COMMENT 'Codigo del producto' , `CSMDD33` VARCHAR(150) NOT NULL COMMENT 'Dias para el evento' , `CSMDD34` VARCHAR(150) NOT NULL COMMENT 'Tipo de envio' , `CSMDD28` VARCHAR(150) NOT NULL COMMENT 'Tipo de servicio' , `CSMDD31` VARCHAR(150) NOT NULL COMMENT 'Tipo de delivery' ) ENGINE = MyISAM;");[m
 [m
[31m-        tep_db_query("CREATE TABLE IF NOT EXISTS `".TABLE_TP_CONFIGURACION."` ( `idConf` INT NOT NULL PRIMARY KEY, `authorization` VARCHAR(100) NOT NULL , `segmento` VARCHAR(100) NOT NULL , `canal` VARCHAR(100) NOT NULL , `ambiente` VARCHAR(100) NOT NULL , `deadline` VARCHAR(100) NOT NULL , `test_endpoint` TEXT NOT NULL , `test_wsdl` TEXT NOT NULL , `test_merchant` VARCHAR(100) NOT NULL , `test_security` VARCHAR(100) NOT NULL , `production_endpoint` TEXT NOT NULL , `production_wsdl` TEXT NOT NULL , `production_merchant` VARCHAR(100) NOT NULL , `production_security` VARCHAR(100) NOT NULL , `estado_inicio` VARCHAR(100) NOT NULL , `estado_aprobada` VARCHAR(100) NOT NULL , `estado_rechazada` VARCHAR(100) NOT NULL , `tipo_formulario` TINYINT UNSIGNED DEFAULT 0, `estado_offline` VARCHAR(100) NOT NULL ) ENGINE = MyISAM;");[m
[32m+[m[32m        tep_db_query("CREATE TABLE IF NOT EXISTS `".TABLE_TP_CONFIGURACION."` ( `idConf` INT NOT NULL PRIMARY KEY, `authorization` VARCHAR(100) NOT NULL , `segmento` VARCHAR(100) NOT NULL , `canal` VARCHAR(100) NOT NULL , `ambiente` VARCHAR(100) NOT NULL , `deadline` VARCHAR(100) NOT NULL , `test_endpoint` TEXT NOT NULL , `test_wsdl` TEXT NOT NULL , `test_merchant` VARCHAR(100) NOT NULL , `test_security` VARCHAR(100) NOT NULL , `production_endpoint` TEXT NOT NULL , `production_wsdl` TEXT NOT NULL , `production_merchant` VARCHAR(100) NOT NULL , `production_security` VARCHAR(100) NOT NULL , `estado_inicio` VARCHAR(100) NOT NULL , `estado_aprobada` VARCHAR(100) NOT NULL , `estado_rechazada` VARCHAR(100) NOT NULL , `tipo_formulario` TINYINT UNSIGNED DEFAULT 0,`estado_offline` VARCHAR(100) NOT NULL, `medios_pago` TEXT NOT NULL ) ENGINE = MyISAM;");[m
 [m
         tep_db_query("DELETE FROM `".TABLE_TP_CONFIGURACION."`");[m
 [m
[31m-        tep_db_query("INSERT INTO `".TABLE_TP_CONFIGURACION."` (`idConf`, `authorization`, `segmento`, `canal`, `ambiente`, `deadline`, `test_endpoint`, `test_wsdl`, `test_merchant`, `test_security`, `production_endpoint`, `production_wsdl`, `production_merchant`, `production_security`, `estado_inicio`, `estado_aprobada`, `estado_rechazada`, `tipo_formulario`, `estado_offline`) VALUES ('1', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '')");[m
[32m+[m[32m        tep_db_query("INSERT INTO `".TABLE_TP_CONFIGURACION."` (`idConf`, `authorization`, `segmento`, `canal`, `ambiente`, `deadline`, `test_endpoint`, `test_wsdl`, `test_merchant`, `test_security`, `production_endpoint`, `production_wsdl`, `production_merchant`, `production_security`, `estado_inicio`, `estado_aprobada`, `estado_rechazada`, `estado_offline`, `medios_pago`) VALUES ('1', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '')");[m
 [m
         tep_db_query("CREATE TABLE IF NOT  EXISTS `".TABLE_TP_TRANSACCION."` ([m
                                                                `id` INT NOT NULL AUTO_INCREMENT,[m
[36m@@ -235,14 +245,36 @@[m [mclass todopagoplugin {[m
                                                                `request_key` TEXT NULL,[m
                                                                `public_request_key` TEXT NULL,[m
                                                                `answer_key` TEXT NULL,[m
[32m+[m[32m                                                               `url_cupon` TEXT NULL,[m
                                                                PRIMARY KEY (`id`)[m
                                                )");[m
[32m+[m
[32m+[m[32m        $queryResult = tep_db_query("SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='".TABLE_TP_TRANSACCION."' AND column_name='url_cupon'");[m
[32m+[m[32m        $queryResultArray = tep_db_fetch_array($queryResult);[m
[32m+[m
[32m+[m[32m        if (empty($queryResultArray)){[m
[32m+[m[32m            tep_db_query("ALTER TABLE `".TABLE_TP_TRANSACCION."` ADD COLUMN `url_cupon` TEXT NULL AFTER `answer_key`;");[m
[32m+[m[32m        }[m
     }[m
 [m
     function remove() {[m
 [m
[32m+[m[32m        /*?>[m
[32m+[m[32m        $('#pop-up-message').html("\[m
[32m+[m[32m            <p>Se le informa que se realizar&aacute;n los siguientes cambios:</p>   \[m
[32m+[m[32m            <ul>    \[m
[32m+[m[32m                <li>Se agregar&acute;n campos en la tabla de configuraci&oacute;n propios del m&oacute;dulo</li>    \[m
[32m+[m[32m                <li>Se agregar&acute; una tabla <em><?php echo TABLE_TP_CONFIGURACION ?></em> para parametros de configuración adicionales</li>    \[m
[32m+[m[32m                <li>Se agregar&aacute; una tabla <em>todopago_transaccion</em> a su base de datos la cu&aacute;l guardar&aacute; informaci&oacute;n sobre las transacciones realizadas por el medio de pago.</li>   \[m
[32m+[m[32m            </ul>   \[m
[32m+[m[32m        ");[m
[32m+[m[32m        $('#pop-up').show();[m
[32m+[m
[32m+[m[32m        <?php*/[m
[32m+[m
         tep_db_query("delete from " . TABLE_CONFIGURATION . " where configuration_key in ('" . implode("', '", $this->keys()) . "')");[m
[31m-        tep_db_query("DELETE FROM todo_pago_configuracion");[m
[32m+[m[32m        tep_db_query("DROP TABLE todo_pago_configuracion");[m
[32m+[m[32m        //tep_db_query("DROP TABLE todopago_transaccion");[m
     }[m
 [m
 [m
[36m@@ -277,13 +309,13 @@[m [mclass todopagoplugin {[m
                 'deadline' => $todoPagoConfig['deadline'],[m
                 'security' => $security,[m
                 'merchant' => $merchant,[m
[31m-                'tipo_formulario' => $todoPagoConfig['tipo_formulario'],[m
                 'estados' => array([m
                     'inicio' => $todoPagoConfig['estado_inicio'],[m
                     'aprobada' => $todoPagoConfig['estado_aprobada'],[m
[31m-                    'rechazada' =>$todoPagoConfig['estado_rechazada'],[m
[31m-                    'offline' =>$todoPagoConfig['estado_offline'][m
[31m-                    )[m
[32m+[m[32m                    'rechazada' => $todoPagoConfig['estado_rechazada'],[m
[32m+[m[32m                    'offline' => $todoPagoConfig['estado_offline'][m
[32m+[m[32m                    ),[m
[32m+[m[32m                'medios_pago' => $todoPagoConfig['medios_pago'][m
                  );[m
     }[m
 [m
[36m@@ -469,7 +501,6 @@[m [mclass todopagoplugin {[m
         global $order, $insert_id, $customer_id;[m
 [m
         $order->id = $insert_id;[m
[31m-[m
         $this->todoPagoConfig = $this->_get_tp_configuracion();[m
 [m
         $this->logger = loggerFactory::createLogger(true, $this->todoPagoConfig['mode'], $customer_id, $order->id);[m
[36m@@ -515,14 +546,23 @@[m [mclass todopagoplugin {[m
             $rta = $connector->sendAuthorizeRequest($optionsSAR[0], $optionsSAR[1]);[m
         }[m
         $this->logger->info("response SAR: ".json_encode($rta));[m
[31m-[m
         if ($rta['StatusCode'] == TP_STATUS_OK) {[m
             $query = $this->todopagoTransaccion->recordFirstStep($order->id, $optionsSAR, $rta);[m
             $this->logger->info("query recordFirstStep: ".$query);[m
[31m-            [m
[31m-            header('Location: '.$rta['URL_Request']);[m
[32m+[m
[32m+[m[32m            //select payment form[m
[32m+[m[32m            $todoPagoConfig = tep_db_query('SELECT * FROM todo_pago_configuracion');[m
[32m+[m[32m            $todoPagoConfig = tep_db_fetch_array($todoPagoConfig);[m
[32m+[m[32m            $formType = $todoPagoConfig['tipo_formulario'];[m
[32m+[m
[32m+[m[32m            //choose form payment type[m
[32m+[m[32m            if($formType == 0){[m
[32m+[m[32m                header('Location: '.$rta['URL_Request']);[m
[32m+[m[32m            }elseif($formType == 1){[m
[32m+[m[32m                header('Location: '.tep_href_link('todopago_form_pago.php', 'id='.$insert_id, 'SSL'));[m
[32m+[m[32m            }[m
             die();[m
[31m-            [m
[32m+[m
         } else {[m
             header('Location: '.tep_href_link('checkout_shipping_retry.php', '', 'SSL'));[m
             die();[m
[36m@@ -562,7 +602,11 @@[m [mclass todopagoplugin {[m
             'URL_ERROR' => tep_href_link('second_step_todopago.php?Order='.$order->id, '', 'SSL'),[m
             'Merchant' => $merchant,[m
             'Security' => $security_code,[m
[31m-            'EncodingMethod' => 'XML'[m
[32m+[m[32m            'EncodingMethod' => 'XML',[m
[32m+[m[32m            //'AVAILABLEPAYMENTMETHODSIDS' => $this->getAvailablePaymentMethods(),[m
[32m+[m[32m            'PUSHNOTIFYMETHOD' => 'application/x-www-form-urlencoded',[m
[32m+[m[32m            'PUSHNOTIFYENDPOINT' => HTTP_SERVER.DIR_WS_CATALOG.'todopago_push_notification.php',[m
[32m+[m[32m            'PUSHNOTIFYSTATES' => 'CouponCharged'[m
         );[m
         return $optionsSAR_comercio;[m
     }[m
[36m@@ -584,11 +628,10 @@[m [mclass todopagoplugin {[m
         $optionsSAR_operacion['CURRENCYCODE'] = '032';[m
         $optionsSAR_operacion['OPERATIONID'] = $order->id;[m
         $optionsSAR_operacion['AMOUNT'] = $order->info['total'];[m
[31m-//        [m
[32m+[m[32m//[m
         //$this->logger = new TodoPagoLogger($order->id);[m
         $this->logger->debug("optionsSAR_operacion: ".json_encode($optionsSAR_operacion));[m
         [m
         return $optionsSAR_operacion;[m
     }[m
 }[m
[31m-[m
[1mdiff --git a/includes/modules/payment/todopagoplugin/includes/ControlFraude/ControlFraude.php b/includes/modules/payment/todopagoplugin/includes/ControlFraude/ControlFraude.php[m
[1mindex 7820dad..c7d1cd5 100644[m
[1m--- a/includes/modules/payment/todopagoplugin/includes/ControlFraude/ControlFraude.php[m
[1m+++ b/includes/modules/payment/todopagoplugin/includes/ControlFraude/ControlFraude.php[m
[36m@@ -138,9 +138,14 @@[m [mabstract class ControlFraude{[m
             $descriptonQuery = tep_db_query("SELECT products_description as description FROM products_description WHERE products_id = ".$item['id'].";");[m
 			$queryResult = tep_db_fetch_array($descriptonQuery);[m
 			$_description = $queryResult['description'];[m
[31m-			$_description = trim($_description);[m
[31m-			$_description = substr($_description, 0,15);[m
[31m-			$description_array [] = str_replace("#","",$_description);[m
[32m+[m
[32m+[m			[32mif($_description != null || $_description != ""){[m
[32m+[m				[32m$_description = trim($_description);[m
[32m+[m				[32m$_description = substr($_description, 0,40);[m
[32m+[m			[32m}else{[m
[32m+[m				[32m$_description = $item['name'];[m
[32m+[m			[32m}[m[41m			[m
[32m+[m			[32m$description_array [] = utf8_encode(str_replace("#","",$_description));[m
 [m
 			$product_name = $item['name'];[m
 			$name_array [] = $product_name;[m
[36m@@ -202,7 +207,8 @@[m [mabstract class ControlFraude{[m
         else[m
             $ipaddress = 'UNKNOWN';[m
 [m
[31m-        return $ipaddress;[m
[32m+[m[32m       // return $ipaddress;[m
[32m+[m[32m        return ($ipaddress == '::1') ? '192.168.0.1' : $ipaddress;[m
     }[m
 [m
 	private function _getProductCode($productId) {[m
[1mdiff --git a/includes/modules/payment/todopagoplugin/includes/TodoPago/lib/Client.php b/includes/modules/payment/todopagoplugin/includes/TodoPago/lib/Client.php[m
[1mindex bc102be..ff13b01 100644[m
[1m--- a/includes/modules/payment/todopagoplugin/includes/TodoPago/lib/Client.php[m
[1m+++ b/includes/modules/payment/todopagoplugin/includes/TodoPago/lib/Client.php[m
[36m@@ -28,7 +28,6 @@[m [mclass Client extends \SoapClient[m
 [m
         $options = array([m
             CURLOPT_RETURNTRANSFER => true,[m
[31m-            CURLOPT_FOLLOWLOCATION => true,[m
             CURLOPT_SSL_VERIFYHOST => false,[m
             CURLOPT_SSL_VERIFYPEER => false,[m
 [m
[1mdiff --git a/includes/modules/payment/todopagoplugin/includes/TodoPago/lib/Sdk.php b/includes/modules/payment/todopagoplugin/includes/TodoPago/lib/Sdk.php[m
[1mindex be9fdbe..72778f1 100644[m
[1m--- a/includes/modules/payment/todopagoplugin/includes/TodoPago/lib/Sdk.php[m
[1m+++ b/includes/modules/payment/todopagoplugin/includes/TodoPago/lib/Sdk.php[m
[36m@@ -3,7 +3,7 @@[m [mnamespace TodoPago;[m
 [m
 require_once(dirname(__FILE__)."/Client.php");[m
 [m
[31m-define('TODOPAGO_VERSION','1.3.1');[m
[32m+[m[32mdefine('TODOPAGO_VERSION','1.4.0');[m
 define('TODOPAGO_ENDPOINT_TEST','https://developers.todopago.com.ar/');[m
 define('TODOPAGO_ENDPOINT_PROD','https://apis.todopago.com.ar/');[m
 define('TODOPAGO_ENDPOINT_TENATN', 't/1.1/');[m
[36m@@ -40,10 +40,12 @@[m [mclass Sdk[m
 [m
 	private function getHeaderHttp($header_http_array){[m
 		$header = "";[m
[31m-		foreach($header_http_array as $key=>$value){[m
[31m-			$header .= "$key: $value\r\n";[m
[31m-		}[m
[31m-		[m
[32m+[m		[32mif(is_array($header_http_array)) {[m
[32m+[m			[32mforeach($header_http_array as $key=>$value){[m
[32m+[m				[32m$header .= "$key: $value\r\n";[m
[32m+[m			[32m}[m
[32m+[m
[32m+[m		[32m}[m[41m		[m
 		return $header;[m
 	}[m
 	/*[m
[36m@@ -67,21 +69,21 @@[m [mclass Sdk[m
 	* ejemplo:[m
 	* $todopago->setConnectionTimeout(1000);[m
 	*/[m
[31m-    public function setConnectionTimeout($connection_timeout){[m
[31m-        $this->connection_timeout = $connection_timeout;[m
[31m-    }[m
[31m-[m
[31m-    /**[m
[32m+[m	[32mpublic function setConnectionTimeout($connection_timeout){[m
[32m+[m		[32m$this->connection_timeout = $connection_timeout;[m
[32m+[m	[32m}[m
[32m+[m[41m	[m
[32m+[m	[32m/**[m
 	* Setea ruta del certificado .pem (deaulft=NULL)[m
 	* ejemplo:[m
 	* $todopago->setLocalCert('c:/miscertificados/decidir.pem');[m
 	*/	[m
[31m-    public function setLocalCert($local_cert){[m
[31m-        $this->local_cert= file_get_contents($local_cert);[m
[31m-    }[m
[32m+[m	[32mpublic function setLocalCert($local_cert){[m
[32m+[m		[32m$this->local_cert= file_get_contents($local_cert);[m
[32m+[m	[32m}[m
[32m+[m[41m	[m
 [m
[31m-[m
[31m-    /*[m
[32m+[m	[32m/*[m
 	* GET_PAYMENT_VALUES[m
 	*/[m
 [m
[36m@@ -180,10 +182,11 @@[m [mclass Sdk[m
  		unset($optionsAuthorize['SDK']);[m
  		unset($optionsAuthorize['SDKVERSION']);[m
  		unset($optionsAuthorize['LENGUAGEVERSION']);[m
[31m- 		$optionsAuthorize['SDK'] = "PHP";[m
[31m- 		$optionsAuthorize['SDKVERSION'] = TODOPAGO_VERSION;[m
[31m- 		$optionsAuthorize['LENGUAGEVERSION'] = PHP_VERSION;[m
[31m-		[m
[32m+[m		[32munset($optionsAuthorize['PLUGINVERSION']);[m
[32m+[m		[32munset($optionsAuthorize['ECOMMERCENAME']);[m
[32m+[m		[32munset($optionsAuthorize['ECOMMERCEVERSION']);[m
[32m+[m		[32munset($optionsAuthorize['CMSVERSION']);[m
[32m+[m
 		foreach($optionsAuthorize as $key => $value){[m
 			if(strpos($value,"#") === false) {[m
 				$value = substr($value, 0, 254);[m
[36m@@ -288,9 +291,9 @@[m [mclass Sdk[m
 		$returnRequestResponseValues = json_decode(json_encode($returnRequestResponse), true);[m
 [m
 		return $returnRequestResponseValues;[m
[31m-[m
 	}[m
 	[m
[32m+[m[41m	[m
 	//REST[m
 	public function getStatus($arr_datos_status){[m
 		$url = $this->end_point.TODOPAGO_ENDPOINT_TENATN.'api/Operations/GetByOperationId/MERCHANT/'. $arr_datos_status["MERCHANT"] . '/OPERATIONID/'. $arr_datos_status["OPERATIONID"];[m
[36m@@ -308,22 +311,53 @@[m [mclass Sdk[m
 		return $this->doRest($url);[m
 	}[m
 	[m
[31m-	private function doRest($url){[m
[32m+[m	[32mpublic function getCredentials(Data\User $user) {[m
[32m+[m		[32m$url = $this->end_point.'api/Credentials';[m
[32m+[m		[32m$data = $user->getData();[m
[32m+[m
[32m+[m		[32m$response = $this->doRest($url, $data, "POST", array("Content-Type: application/json"));[m
[32m+[m
[32m+[m		[32mif($response == null) {[m
[32m+[m			[32mthrow new Exception\ConnectionException("Error de conexion");[m
[32m+[m		[32m}[m
[32m+[m		[32mif($response["Credentials"]["resultado"]["codigoResultado"] != 0) {[m
[32m+[m			[32mthrow new Exception\ResponseException($response["Credentials"]["resultado"]["mensajeResultado"]);[m
[32m+[m		[32m}[m
[32m+[m
[32m+[m		[32m$user->setMerchant($response["Credentials"]["merchantId"]);[m
[32m+[m		[32m$user->setApikey($response["Credentials"]["APIKey"]);[m
[32m+[m[41m		[m
[32m+[m		[32mreturn $user;[m
[32m+[m	[32m}[m
[32m+[m[41m	[m
[32m+[m	[32mprivate function doRest($url, $data = array(), $method = "GET", $headers = array()){[m
 		$curl = curl_init($url);[m
 		curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);[m
[31m-		curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);	[m
[31m-		curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, false);	[m
[32m+[m		[32mcurl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);[m
[32m+[m		[32mcurl_setopt($curl, CURLOPT_SSL_VERIFYHOST, false);[m
[32m+[m[41m		[m
[32m+[m		[32m$conn_headers = array_filter(explode("\r\n",$this->header_http));[m
[32m+[m		[32mcurl_setopt($curl, CURLOPT_HTTPHEADER, array_merge($conn_headers,$headers));[m
[32m+[m[41m		[m
[32m+[m		[32mif($method == "POST") {[m
[32m+[m			[32mcurl_setopt($curl, CURLOPT_POST, 1);[m
[32m+[m			[32mcurl_setopt($curl, CURLOPT_POSTFIELDS,json_encode($data));[m
[32m+[m		[32m}[m
[32m+[m
 		if($this->host != null)[m
 			curl_setopt($curl, CURLOPT_PROXY, $this->host);[m
 		if($this->port != null)[m
 			curl_setopt($curl, CURLOPT_PROXYPORT, $this->port);[m
[32m+[m[41m		[m
 		$result = curl_exec($curl);[m
 		$http_status = curl_getinfo($curl, CURLINFO_HTTP_CODE);[m
 		curl_close($curl);[m
 		if($http_status != 200) {[m
 			$result = "<Colections/>";[m
 		}[m
[31m-[m
[32m+[m		[32mif( json_decode($result) != null ) {[m
[32m+[m			[32mreturn json_decode($result,true);[m
[32m+[m		[32m}[m[41m [m
 		return json_decode(json_encode(simplexml_load_string($result)), true);[m
 	}[m
 }[m
[1mdiff --git a/includes/modules/payment/todopagoplugin/includes/TodopagoTransaccion.php b/includes/modules/payment/todopagoplugin/includes/TodopagoTransaccion.php[m
[1mindex e4b4dba..b7c4954 100644[m
[1m--- a/includes/modules/payment/todopagoplugin/includes/TodopagoTransaccion.php[m
[1m+++ b/includes/modules/payment/todopagoplugin/includes/TodopagoTransaccion.php[m
[36m@@ -73,7 +73,9 @@[m [mclass TodopagoTransaccion {[m
         if ($this->_getStep($orderId) == self::SECOND_STEP){[m
             $answerKey = $paramsGAA['AnswerKey'];[m
             $url_cupon = ($responseGAA['Payload']['Answer']['ASSOCIATEDDOCUMENTATION']) ? "'".$responseGAA['Payload']['Answer']['ASSOCIATEDDOCUMENTATION']."'" : 'NULL';[m
[31m-            $query = "UPDATE todopago_transaccion SET second_step = '".$datetime->format('Y-m-d H:i:s')."', params_GAA = '".json_encode($paramsGAA)."', response_GAA = '".json_encode($responseGAA)."', answer_key = '".$answerKey."', url_cupon = $url_cupon WHERE id_orden = ".$orderId;[m
[32m+[m
[32m+[m
[32m+[m[32m            $query = "UPDATE todopago_transaccion SET second_step = '".$datetime->format('Y-m-d H:i:s')."', params_GAA = '".json_encode($paramsGAA)."', response_GAA = '".json_encode($responseGAA)."', answer_key = '".$answerKey."' WHERE id_orden = ".$orderId;[m
             tep_db_query($query);[m
             return $query;[m
         }[m
[36m@@ -81,4 +83,4 @@[m [mclass TodopagoTransaccion {[m
             return 0;[m
         }[m
     }[m
[31m-}[m
\ No newline at end of file[m
[32m+[m[32m}[m
[1mdiff --git a/includes/modules/payment/todopagoplugin/includes/todopago_ctes.php b/includes/modules/payment/todopagoplugin/includes/todopago_ctes.php[m
[1mindex b1d0850..a83cbdf 100644[m
[1m--- a/includes/modules/payment/todopagoplugin/includes/todopago_ctes.php[m
[1m+++ b/includes/modules/payment/todopagoplugin/includes/todopago_ctes.php[m
[36m@@ -1,5 +1,5 @@[m
 <?php[m
[31m-define('TP_VERSION', '1.5.1');[m
[32m+[m[32mdefine('TP_VERSION', '1.5.2');[m
 define('TP_LOGDIR', dirname(__FILE__).'/../../../../work/todopago.log');[m
 define('TP_LOGLEVEL', 'debug');[m
 define('TP_STATUS_OK', -1);[m
[1mdiff --git a/includes/modules/payment/todopagoplugin/todopago.css b/includes/modules/payment/todopagoplugin/todopago.css[m
[1mindex 51cdaa0..bf03a42 100644[m
[1m--- a/includes/modules/payment/todopagoplugin/todopago.css[m
[1m+++ b/includes/modules/payment/todopagoplugin/todopago.css[m
[36m@@ -1,7 +1,9 @@[m
 .secciones-todopago-config{[m
     list-style:none;[m
     display:table;[m
[31m-    margin-bottom: 50px;[m
[32m+[m[32m    margin-bottom: 1px;[m
[32m+[m[32m    border-bottom:1px solid #d3d3d3;[m[41m [m
[32m+[m[32m    margin-bottom: 22px;[m
 }[m
 .secciones-todopago-config li{[m
     float:left;[m
[36m@@ -154,3 +156,48 @@[m
     cursor: pointer;[m
     font-size: 12px;[m
 }[m
[32m+[m
[32m+[m[32m.btn-config-credentials{[m
[32m+[m[32m    font-size: 13px;[m
[32m+[m[32m    vertical-align: top;[m
[32m+[m[32m    line-height: 25px;[m
[32m+[m[32m    display: inline-block;[m
[32m+[m[32m    margin-bottom: 22px;[m
[32m+[m[32m    font-weight: 400;[m
[32m+[m[32m    text-align: center;[m
[32m+[m[32m    cursor: pointer;[m
[32m+[m[32m    color: rgb(255, 255, 255);[m[41m [m
[32m+[m[32m    background-color:rgb(230, 0, 126);[m[41m [m
[32m+[m[32m    width:170px;[m
[32m+[m[32m    border-radius: 4px;[m
[32m+[m[32m}[m
[32m+[m[32m.ui-dialog-titlebar {[m
[32m+[m[32m    background: rgb(230, 0, 126);[m
[32m+[m[32m    border-color: #E6E6E6;[m
[32m+[m[32m}[m
[32m+[m[32m.ui-icon{ background color: rgb(230, 0, 126); }[m
[32m+[m[32m.ui-dialog {[m[41m  [m
[32m+[m[32m    min-width: 351px;[m
[32m+[m[32m    border-color: #D8D8D8;[m
[32m+[m[32m    border-radius: 4px;[m
[32m+[m[32m    background-color: rgba(255,255,255,.9);[m
[32m+[m[32m}[m
[32m+[m[32m.control-label {[m
[32m+[m[32m    font-size: 16px;[m
[32m+[m[32m}[m
[32m+[m[32m.form-control {[m
[32m+[m[32m    display: block;[m
[32m+[m[32m    width: 270px;[m
[32m+[m[32m    height: 12px;[m
[32m+[m[32m    padding: 6px 12px;[m
[32m+[m[32m    font-size: 14px;[m
[32m+[m[32m    line-height: 1.42857143;[m
[32m+[m[32m    color: #555;[m
[32m+[m[32m    background-color: #fff;[m
[32m+[m[32m    background-image: none;[m
[32m+[m[32m    border: 1px solid #ccc;[m
[32m+[m[32m    border-radius: 4px;[m
[32m+[m[32m    box-shadow: inset 0 1px 1px rgba(0,0,0,.075);[m
[32m+[m[32m    -webkit-transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;[m
[32m+[m[32m    transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;[m
[32m+[m[32m}[m
\ No newline at end of file[m
[1mdiff --git a/second_step_todopago.php b/second_step_todopago.php[m
[1mindex 6d5e46f..7ddacf7 100644[m
[1m--- a/second_step_todopago.php[m
[1m+++ b/second_step_todopago.php[m
[36m@@ -128,7 +128,7 @@[m [mfunction take_action($data, $order_id) {[m
 [m
 ?>[m
 [m
[31m-<h1><?php echo $offline? "�Cup&oacute;n de pago generado!" : HEADING_TITLE; ?></h1>[m
[32m+[m[32m<h1><?php echo $offline? "¡Cup&oacute;n de pago generado!" : HEADING_TITLE; ?></h1>[m
 [m
 <?php echo tep_draw_form('order', tep_href_link(FILENAME_CHECKOUT_SUCCESS, 'action=update', 'SSL')); ?>[m
 [m
