
Instalacion Plugin TodoPago Oscommerce

## Consideraciones Generales
El plug in de pagos de Todo Pago, provee a las tiendas Oscommerce de un nuevo m&eacute;todo de pago, integrando la tienda al gateway de pago.
La versión de este plug in esta testeada en PHP 5.3-5.4-5.6, Oscommerce 2.3.4

## Instalación
1.  Subir los archivos a la raíz del sitio
2.  Modules -> Payment -> Install Module -> TodoPago -> Install

![imagen de instalacion](https://raw.githubusercontent.com/TodoPago/imagenes/master/oscommerce/install1.png)

![imagen de instalacion](https://raw.githubusercontent.com/TodoPago/imagenes/master/oscommerce/install2.png)


3 . Modificar los siguientes archivos:
*admin/includes/filenames.php agregar la siguiente linea
define('FILENAME_TODOPAGO_CONFIG', 'todopago_config.php');

*admin/includes/languages/english.php agregar la siguiente linea
define('BOX_TOOLS_TODOPAGO_CONFIG', 'TodoPago Configuraci&amp;oacute;n');

 *admin/includes/boxes/tools.php agregar la siguiente valor de array
array(
        'code' => FILENAME_TODOPAGO_CONFIG,
        'title' => BOX_TOOLS_TODOPAGO_CONFIG,
        'link' => tep_href_link(FILENAME_TODOPAGO_CONFIG)
      )

Observación: Descomentar <strong>extension=php_soap.dll</strong> y <strong>extension=php_openssl.dll</strong> del php.ini, ya que para la conexión al gateway se utiliza la clase SoapClient del API de PHP.


##Configuración
####Configuración plug in
Para llegar al menu de configuración ir a:  Tools -> TodoPago Configuración 
En esta pantalla existen 3 tabs
1. Configuración: Se dan de alta los valores para el funcionamiento de TodoPago.

    **Nota:** El AuthorizationHTTP y los WSDL deben ingresarse en formato JSON. Ejemplo:
    * Authorization: { "Authorization":"PRISMA 912EC803B2CE49E4A541068D495AB570"}
    * WSDL’s: { "Operations": "https://developers.todopago.com.ar/services/Operations?wsdl", "Authorize": "https://developers.todopago.com.ar/services/Authorize?wsdl", "PaymentMethods": "https://developers.todopago.com.ar/services/PaymentMethods?wsdl"}
![imagen de configuracion](https://raw.githubusercontent.com/TodoPago/imagenes/master/oscommerce/conf1.png)
<!--2. Productos: En esta tab se le asignan los campos a los productos para Prevención de Fraude. Los campos nuevos se agregan automáticamente. Sólo hay que asignar los valores correspondientes a cada producto
![imagen de configuracion](https://raw.githubusercontent.com/TodoPago/imagenes/master/oscommerce/conf2.png)
-->
2. Ordenes: Aquí estarán las órdenes y el botón para Ver Status para ver las actualizaciones de estado
![imagen de configuracion](https://raw.githubusercontent.com/TodoPago/imagenes/master/oscommerce/conf3.png)

## Prevención de Fraude
Los campos se crean automáticamente y se asignan en Tools -> TodoPago Configuración -> Productos

####Consideraciones Generales (para todas las verticales, por defecto RETAIL)
El plug in, toma valores estándar del framework para validar los datos del comprador.
Para acceder a los datos del vendedor, productos y carrito se usa el  objeto $order que llega como parámetro en los métodos en los que se necesita. 
Este es un ejemplo de la mayoría de los campos que se necesitan para comenzar la operación <br />
'CSBTCITY' => $cart->billing['state'], 	
'CSBTCOUNTRY' => $cart->billing['country']['iso_code_2'], 	
'CSBTCUSTOMERID' => $customer_id, 
'CSBTIPADDRESS' => $this->get_todo_pago_client_ip(), 	
'CSBTEMAIL' => $cart->customer['email_address'], 		
'CSBTFIRSTNAME'=> $cart->customer['firstname'], 
'CSBTLASTNAME'=> $cart->customer['lastname'], 
'CSBTPHONENUMBER'=> $cart->customer['telephone'], 
'CSBTPOSTALCODE'=> $cart->customer['postcode'], 	
'CSBTSTATE' => $this->tp_states, 
'CSBTSTREET1' => $cart->customer['street_address'] ,	

####Muy Importante
Provincias: Al ser un campo MANDATORIO para enviar y propio del plugin este campo se completa por parte del usuario al momento del check out.
