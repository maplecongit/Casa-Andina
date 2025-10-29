<?php require_once("layout/header.php")?>
<h1 class="text-center">EDITAR</h1>
<hr>
<form action="" method="get">
 <?php
 foreach($dato as $key => $value):
	foreach($value as $v):
	?>
	<label for="">NOMBRE</label> <br>
	<input type="text" value="<?php echo $v['first_name']?>" name="nombre"> <br>
	<label for="">APELLIDO</label> <br>
	<input type="text" value="<?php echo $v['last_name']?>" name="apellido"> <br>
	<label for="">CORREO</label> <br>
	<input type="text" value="<?php echo $v['email']?>" name="correo"> <br>
	<label for="">CELULAR</label> <br>
	<input type="text" value="<?php echo $v['phone_number']?>" name="celular"> <br>
	<label for="">HIRE DATE</label> <br>
	<input type="text" value="<?php echo $v['hire_date']?>" name="hiredate"> <br>
	<label for="">JOB_ID</label> <br>
	<input type="text" value="<?php echo $v['job_id']?>" name="jobid"> <br>
	<label for="">SALARIO</label> <br>
	<input type="text" value="<?php echo $v['salary']?>" name="salario"> <br>
	<label for="">MANAGER_ID</label> <br>
	<input type="text" value="<?php echo $v['manager_id']?>" name="managerid"> <br>
	<label for="">DEPARTMENT_ID</label> <br>
	<input type="text" value="<?php echo $v['department_id']?>" name="departmentid"> <br>
	<input type="hidden" value="<?php echo $v['employee_id']?>" name="id"> <br>
	<input type="submit" class="btn" name="btn" value="ACTUALIZAR"> 
	<input type="hidden" name="m" value="actualizar">
	<?php
	  endforeach;
	endforeach;
	?>
</form>
<?php require_once("layout/footer.php")?>