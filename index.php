<?php
require_once("config.php");
require_once("controlador/index.php");
if (isset($_GET['m'])):
	$metodo= $_GET['m'];
	if (method_exists("modeloController",$metodo)):
		modeloController::{$metodo}();
	endif;
else:
	modeloController::index();
endif;
?>