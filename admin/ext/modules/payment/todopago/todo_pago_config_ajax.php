<?php
    chdir('../../../../');
    
    require('includes/application_top.php');
    
    $sql = "delete  from todo_pago_atributos where product_id =".$_POST["product_id"];
    
    tep_db_query($sql);
    
    $sql = "";
    
    foreach($_POST as $key=>$value){
    
      $sql .=" ".$key. "='".$value."',";   
    }
    
    $sql = trim($sql,",");
    
    $sql = "insert into todo_pago_atributos set".$sql;
    
    echo tep_db_query($sql);
?>