<?php require_once("layout/header.php")?>
<a href="index.php?m=nuevo" class="btn"> NUEVO </a>
<table >
    <tr >
      <td >Id</td>
      <td >First_name</td>
      <td >Last_name</td>
	  <td >Accion</td>
    </tr> 
   <tbody>	
   <?php
    if (!empty($dato)):
	foreach ($dato as $key =>$value):
		foreach($value as $va):?>
			<tr>
			<td><?php echo $va['employee_id']?></td>
			<td><?php echo $va['first_name']?></td>
			<td><?php echo $va['last_name']?></td>
			<td><a class="btn" href='index.php?m=editar&id=<?php echo $va['employee_id']?>'>ACTUALIZAR</a> 
			<a class="btn" href='index.php?m=eliminar&id=<?php echo $va['employee_id']?>'>ELIMINAR</a> </td>
			</tr>
	  <?php
	  endforeach;
	endforeach;?>
	<?php else: ?>
			<tr> 
				<td colspan="3">NO HAY REGISTROS</td> 
			</tr>
	
	<?php endif ?>
	</tbody>
</table>	
<?php require_once("layout/footer.php")?>