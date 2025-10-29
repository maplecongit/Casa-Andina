<?php
class Modelo{
	private $Modelo;
	private $db;
	public function __construct(){
		$this->Modelo= array();
		$this->db =new PDO('mysql:host=localhost;dbname=dbempleados',"root","");
	}
	public function insertar($tabla,$data){
		$consulta="insert into ".$tabla." values(null,".$data.")";
		//echo $consulta;
		$resultado=$this->db->query($consulta);
		if($resultado){
		return true; }
		else {return false;}
	}
	public function mostrar($tabla,$condicion){
		$consulta="select * from ".$tabla." where ".$condicion.";";
		//echo $consulta;
		$resultado=$this->db->query($consulta);
		while($filas= $resultado->FETCHALL(PDO::FETCH_ASSOC)){
			$this->registros[]=$filas;
		}
		return $this->registros;
	}

	public function actualizar($tabla,$data,$condicion){
		$consulta="update ".$tabla." set ".$data." where ".$condicion.";";
		echo $consulta;
		$resultado=$this->db->query($consulta);
		if($resultado){
		return true; }
		else {return false;}
	}
	
	public function eliminar($tabla,$condicion){
		$consulta="delete from ".$tabla." where ".$condicion.";";
		//echo $consulta;
		$resultado=$this->db->query($consulta);
		if($resultado){
		return true; }
		else {return false;}
	}

}
?>