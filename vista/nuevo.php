
<?php require_once("layout/header.php")?>
<h1 class="text-center">NUEVO</h1>
<hr>
<form action="" method="get">
	<label for="">NOMBRE</label> <br>
	<input type="text" name="nombre"> <br>
	<label for="">APELLIDO</label> <br>
	<input type="text" name="apellido"> <br>
	<label for="">CORREO</label> <br>
	<input type="text" name="correo"> <br>
	<label for="">CELULAR</label> <br>
	<input type="text" name="celular"> <br>
	<label for="">HIRE DATE ("year-month-day")</label> <br>
	<input type="text" name="hiredate"> <br>
	<label for="">JOB_ID</label> <br>
	<select name="jobid"> 
		<?php foreach ($dato2 as $opc): 
			  foreach ($opc as $va):
		?>
		    	<option value="<?php echo $va['job_id']?>"> <?php echo $va['job_id']?></option>
		<?php endforeach;
			endforeach;?> 
	</select> <br>
	<label for="">SALARIO</label> <br>
	<input type="text" name="salario"> <br>
	<label for="">MANAGER_ID</label> <br>
	<select name="managerid"> 
		<?php foreach ($dato as $opc): 
			  foreach ($opc as $va):
		?>
		    	<option value="<?php echo $va['employee_id']?>"> <?php echo $va['employee_id']?></option>
		<?php endforeach;
			endforeach;?> 
	</select> <br>
	
	<label for="">DEPARTMENT_ID</label> <br>
	<select name="departmentid"> 
		<?php foreach ($dato3 as $opc): 
			  foreach ($opc as $va):
		?>
		    	<option value="<?php echo $va['department_id']?>"> <?php echo $va['department_id']?></option>
		<?php endforeach;
			endforeach;?> 
	</select> <br><br>
	
	<input type="submit" class="btn" name="btn" value="GUARDAR"> 
	<input type="hidden" name="m" value="guardar">
</form>
<?php require_once("layout/footer.php")?>