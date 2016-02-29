<a name="inicio"></a>
Oscommerce-plugin
============
Plug in para la integración con gateway de pago <strong>Todo Pago</strong>
- [Consideraciones Generales](#consideracionesgenerales)
- [Instalación](#instalacion)
- [Configuración plugin](#confplugin)
- [Devoluciones] (#devoluciones)
- [Datos adiccionales para prevención de fraude](#cybersource) 
- [Tablas de referencia](#tablas)

Instalacion Plugin TodoPago Oscommerce

<a name="consideracionesgenerales"></a>
## Consideraciones Generales
El plug in de pagos de Todo Pago, provee a las tiendas Oscommerce de un nuevo m&eacute;todo de pago, integrando la tienda al gateway de pago.
La versión de este plug in esta testeada en PHP 5.3-5.4-5.6, Oscommerce 2.3.4

<a name="instalacion"></a>
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

<a name="confplugin"></a>
##Configuración
####Configuración plug in
Para llegar al menu de configuración ir a:  Tools -> TodoPago Configuración 
En esta pantalla existen 3 tabs:

a. Configuración: Se dan de alta los valores para el funcionamiento de TodoPago.

        Authorization HTTP: Codigo de autorización otorgado por Todo Pago. Ejemplo: PRISMA 912EC803B2CE49E4A541068D12345678
        Security Code: Código provisto por Todo Pago<br>
        ID Site Todo Pago: Nombre de comercio provisto por Todo Pago<br>
        End Point: Provisto por Todo Pago (es una url)<br>
        WSDL: WSDLs en formato JSON. Ejemplo: {"Authorize":"https://developers.todopago.com.ar/services/Authorize?wsdl","PaymentMethods":"https://developers.todopago.com.ar/services/PaymentMethods?wsdl","Operations":"https://developers.todopago.com.ar/services/Operations?wsdl"}                    
    
![imagen de configuracion](https://raw.githubusercontent.com/TodoPago/imagenes/master/oscommerce/conf1.png)

<sub>Estados de ordenes</sub>

![imagen de configuracion](https://github.com/TodoPago/imagenes/blob/8244bd91d750bf50b192354b5c5bf85eb06cc213/oscommerce/conf4.png)

b. Ordenes: Aquí estarán las órdenes y el botón para Ver Status para ver las actualizaciones de estado

![imagen de configuracion](https://raw.githubusercontent.com/TodoPago/imagenes/master/oscommerce/conf3.png)

c. Para las devoluciones se debe agregar los estados "Refund" y "Partial Refund", desde la seccion, Admin -> Localization -> Order Status.

<a name="devoluciones"></a>
##Devoluciones
TodoPago permite realizar la devolucion total o parcial de dinero de una orden de compra.<br> 
Para ello dirigirse en el menú a Tools->TodoPago configuracion->Ordenes, en esta pagina se encuentra las ordenes de compra realizadas con Todopago.<br> 
En cada orden se encuentra la opcion "Devolver" que mostrara un modal con la opcion de devolucion total y devolucion parcial junto con el campo para ingresar el monto.<br><br>
![imagen de configuracion](https://raw.githubusercontent.com/TodoPago/imagenes/master/oscommerce/devoluciones-modal.png)

<a name="cybersource"></a>
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

<a name="tablas"></a>
## Tablas de Referencia
######[Provincias](#p)

<a name="p"></a>
<p>Provincias</p>
<table>
<tr><th>Provincia</th><th>Código</th></tr>
<tr><td>CABA</td><td>C</td></tr>
<tr><td>Buenos Aires</td><td>B</td></tr>
<tr><td>Catamarca</td><td>K</td></tr>
<tr><td>Chaco</td><td>H</td></tr>
<tr><td>Chubut</td><td>U</td></tr>
<tr><td>Córdoba</td><td>X</td></tr>
<tr><td>Corrientes</td><td>W</td></tr>
<tr><td>Entre Ríos</td><td>R</td></tr>
<tr><td>Formosa</td><td>P</td></tr>
<tr><td>Jujuy</td><td>Y</td></tr>
<tr><td>La Pampa</td><td>L</td></tr>
<tr><td>La Rioja</td><td>F</td></tr>
<tr><td>Mendoza</td><td>M</td></tr>
<tr><td>Misiones</td><td>N</td></tr>
<tr><td>Neuquén</td><td>Q</td></tr>
<tr><td>Río Negro</td><td>R</td></tr>
<tr><td>Salta</td><td>A</td></tr>
<tr><td>San Juan</td><td>J</td></tr>
<tr><td>San Luis</td><td>D</td></tr>
<tr><td>Santa Cruz</td><td>Z</td></tr>
<tr><td>Santa Fe</td><td>S</td></tr>
<tr><td>Santiago del Estero</td><td>G</td></tr>
<tr><td>Tierra del Fuego</td><td>V</td></tr>
<tr><td>Tucumán</td><td>T</td></tr>
</table>

####Muy Importante
Provincias: Al ser un campo MANDATORIO para enviar y propio del plugin este campo se completa por parte del usuario al momento del check out.
