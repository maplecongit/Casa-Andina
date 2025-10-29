<?php
require_once("modelo/index.php");
class modeloController{
 private $model;
 function __construct(){
	$this->model = new Modelo();
 }
 static function index(){
	$obj = new Modelo();
	$dato= $obj->mostrar("employees","1");
	require_once("vista/index.php");
 }
 
 //insertar registro
 static function nuevo(){
	$obj = new Modelo();
	$dato= $obj->mostrar("employees","1");
	$obj2 = new Modelo();
	$dato2= $obj2->mostrar("jobs","1");
	//var_dump($dato2);
	$obj3 = new Modelo();
	$dato3= $obj3->mostrar("departments","1");
	require_once("vista/nuevo.php");
 }
  
 static function guardar(){
	$nombre = $_REQUEST['nombre'];
	$apellido =$_REQUEST['apellido'];
	$correo = $_REQUEST['correo'];
	$celular = $_REQUEST['celular'];
	$hiredate= $_REQUEST['hiredate'];
	$jobid = $_REQUEST['jobid'];
	$salario= $_REQUEST['salario'];
	$managerid= $_REQUEST['managerid'];
	$departmentid= $_REQUEST['departmentid'];
	$data = "'".$nombre."','".$apellido."','".$correo."','".$celular."','".$hiredate."',".$jobid.",".$salario.",".$managerid.",".$departmentid;
	$empleado= new Modelo();
	$dato= $empleado->insertar("employees",$data);
	header("location:".urlsite);
 }
 // editar registro
 static function editar(){
	$id= $_REQUEST['id']; 
	$empleado = new Modelo();
	$dato = $empleado->mostrar("employees","employee_id=".$id);
	//var_dump($dato);
	require_once("vista/editar.php");
 }
 
 static function actualizar(){
	$id= $_REQUEST['id']; 
	$nombre = empty($_REQUEST['nombre'])? 'null': $_REQUEST['nombre'];
	$apellido =empty($_REQUEST['apellido'])? 'null': $_REQUEST['apellido'];
	$correo = empty($_REQUEST['correo'])? 'null':$_REQUEST['correo'];
	$celular = empty($_REQUEST['celular'])? 'null':$_REQUEST['celular'];
	$hiredate= empty($_REQUEST['hiredate'])? 'null':$_REQUEST['hiredate'];
	$jobid = $_REQUEST['jobid'];
	$salario= empty($_REQUEST['salario'])? 'null': $_REQUEST['salario'];
	$managerid= empty($_REQUEST['managerid'])? 'null':$_REQUEST['managerid'];
	$departmentid= $_REQUEST['departmentid'];
	$data = "first_name='".$nombre."',last_name='".$apellido."',email='".$correo."',phone_number='".$celular."',hire_date='".$hiredate."',job_id=".$jobid.",salary=".$salario.",manager_id=".$managerid.",department_id=".$departmentid;
	//echo $data;
	$empleado= new Modelo();
	$dato= $empleado->actualizar("employees",$data,"employee_id=".$id);
	header("location:".urlsite);
 
 
 }
  //elimina registro
 static function eliminar(){
	$id = $_REQUEST['id'];
	$condicion= "employee_id=".$id;
	$empleado = new Modelo();
	$dato = $empleado->eliminar("employees",$condicion);
	header("location:".urlsite);
 }

}


?>
