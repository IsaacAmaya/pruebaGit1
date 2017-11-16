<%@ taglib tagdir="/WEB-INF/tags" prefix="t" %> 
<%
	String id = request.getParameter("id")==null ? "":request.getParameter("id").toString().trim();
	
%>
<script src="Archivos/js/modulo/formulario_cuadrilla.js"></script>
<script>
	var tablaListadoTrabajador; //JEFE DE CUADRILLA
	var tablaListadoTrabajadores; //INTEGRANTES DE CUADRILLA
  $( function() {
    	
    	<% if(!id.equals("")) out.print("cargarCuadrilla('"+id+"')");%>
    	
    $('#vModalListadoTrabajador').modal({
   		  show: false
   	});
    
    $('#vModalListadoTrabajadores').modal({
 		  show: false
 	});
   	  
   	$('#vModalListadoTrabajador').on('show.bs.modal', function (e) {
   		  cargarListadoTrabajador();
   	});
   	
   	$('#vModalListadoTrabajadores').on('show.bs.modal', function (e) {
 		  cargarListadoTrabajadores();
 	});
   	validarBotones("cuadrilla",$("#idUsuario").val(),"2");
  });
</script>
<input type="hidden" value="<%=session.getAttribute("idusuario") %>" id="idUsuario">
<div>
      	 <a href="./cuadrilla" class="tile-small text-shadow fg-white" style="background:#ECB54E" data-role="tile">
                    <div class="tile-content iconic mif-ani-hover-bounce">
                       <img class="icon" src="Archivos/images/iconmenu/CUADRILLAS.png"></img>
                    </div>
                </a>
      	<h3>Modulo de Cuadrilla</h3>
  		<p>Listado de Cuadrillas Actuales </p>
  		</div>
   
   <article id="formulario">
      
      
      <t:panel titulo="Formulario de Registro de Cuadrillas">
		<ul class="nav nav-tabs">           
               <li class="active"><a data-toggle="tab" href="#formCuadrilla">Cuadrilla</a></li>
               <li><a data-toggle="tab" href="#intregrantesCuadrilla" onclick="cargarDetalleCuadrilla();">Integrantes de la Cuadrilla</a></li>
        </ul>
		<div class="tab-content">
		<div id="formCuadrilla" class="tab-pane fade in active" >
            <input type="hidden" id="idtrabajador">
            <input type="hidden" id="idcuadrilla" >
            <div class="row">                
                    
                    <div class="col-sm-6 col-md-4">
	                    <label class=" control-label"><span style="color:red;font-weight:bold; " title="Campo requerido">*</span> Nombre:</label>
	                    <input type="text" class="form-control" id="txtNombre" required="required" onblur="consultarCuadrilla(this.value);" placeholder="Ingrese El Nombre de la Cuadrilla">
                    </div>
                    
                   <!--  <div class="col-sm-6 col-md-4">
                    <label class=" control-label">Jefe de Cuadrilla:</label>
                    <input type="text" class="form-control" id="txtDatosTrabajador" data-toggle="modal" data-target="#vModalListadoTrabajador" required="required" placeholder="Jefe de Cuadrilla">
                    </div>  -->
                    
                    <div class="col-sm-6 col-md-4">
                    <label class="control-label">Apodo Cuadrilla: </label>
                    <input type="text" class="form-control"  id="txtApodo" required="required" placeholder="Ingrese el Apodo de la Cuadrilla">
                    </div>
                    
                    <div class="col-sm-6 col-md-8">
                    <label class="control-label"><span style="color:red;font-weight:bold; " title="Campo requerido">*</span> Descripción: </label>
                      <input type="text" class="form-control" id="txtDescripcion"  required="required" placeholder="Ingrese la Descripción de la Cuadrilla">
                    </div>
                                       
                    <div class="col-sm-6 col-md-4">
                    <label class="control-label">Estado</label>
                        <select id="cmbEstatus" class="form-control">
                            <option value="1">Activo</option>
                            <option value="0">Inactivo</option>
                              
                        </select>
                    </div>
                
               </div> 
           
            </div>
           <div id="intregrantesCuadrilla" class="tab-pane fade"><br>
           		<div class="alert" style="background:#F2F2F2;">
		                <div class="row" >
						    <div class="col-md-6">
							    <label>Nombre cuadrilla: </label>
							    <input id="txtNombrecuadrillaAlert" class="form-control" disabled="disabled">
						    </div>
						    <div class="col-md-6">
							    <label>Apodo cuadrilla: </label>
							    <input type="text" id="txtApodocuadrillaAlert" class="form-control" disabled="disabled">
						    </div>					        		
					    </div>
				    </div>
			   <div >			
		            <button type="button" class="btn btn-success incluir" style="margin-top: 5px; margin-bottom: 15px" data-toggle="modal" data-target="#vModalListadoTrabajadores"><span class="glyphicon glyphicon-plus" aria-hidden="true" ></span> Agregar Integrante</button>
		      		<div>
		      			<table class="table table-striped" id="listadoIntegrantesCuadrillaActivos">
		      				<thead>
		      					<th>Cedula</th>							           							                
								<th>Nombre</th>	
								<th>Cargo</th>
								<th><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Jefe Cuadrilla</th>
								<th>Opción</th>							                
							</thead>
							<tbody></tbody>
		      			</table>	      							      					
		      		</div>					       	
			   </div>               
	      	</div>
             
    	</div>
    	<div class="row">
                	<div class="col-md-12 col-xs-12">
                		 <div class="form-group" style="text-align: center; ">
						    <div style="margin-top: 30px;">
						    <t:btnBotonera accionguardar="guardarCuadrilla();" accioncancelar="window.location.href = './cuadrilla';" accionlimpiar="window.location.href = './addCuadrilla';"></t:btnBotonera>
		        		</div>
                		</div>
                	</div>                 
               
      		 </div>
     </t:panel>  
    
   </article>
<!-- MODAL PARA LISTAR LOS TRABAJADORES Y SELECCIONAR EL JEFE DE CUADRILLA -->
<div class="modal fade" id="vModalListadoTrabajador" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h6 class="modal-title" id="myModalLabel">Seleccionar Persona</h6>
      </div>
      <div class="modal-body">
        	<table id="ListadoTrabajador" class="display"  width="100%">
		        <thead>
		            <tr>
		            	<th>idtrabajador</th>
		            	<th>Cedula</th>
		            	<th>Nombre</th>
		                <th>Cargo</th>	                
		            </tr>
		        </thead>
		        <tfoot>
		            <tr>
		            	<th>idtrabajador</th>
		            	<th>Cedula</th>
		            	<th>Nombre</th>
		                <th>Cargo</th>	                
		            </tr>
		        </tfoot>
		        <tbody> 
		            
		        </tbody>
		    </table> 
      </div>
      <!--  <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
      </div>-->
    </div>
  </div>
</div>
<!-- FIN MODAL PARA LISTAR LOS TRABAJADORES Y SELECCIONAR EL JEFE DE CUADRILLA -->
<!-- ************************************************************************************************************* -->
<!-- MODAL PARA LISTAR LOS TRABAJADORES Y SELECCIONAR LOS INTEGRANTES DE LA CUADRILLA -->
<div class="modal fade" id="vModalListadoTrabajadores" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h6 class="modal-title" id="myModalLabel">Seleccionar Trabajador</h6>
      	<input type="text"  id="txtTrabajadorAux" class="form-control" placeholder="Buscar" style="width:30%;float:right;" onkeyup="cargarListadoTrabajadores();" >
	    <!-- NUEVO LISTADO -->
      </div>
      <div class="modal-body">
        	<table id="ListadoTrabajadores" class="table table-hover"  width="100%">
		        <thead>
		            <tr>
		            	<th>Cedula</th>
		            	<th>Nombre</th>
		                <th>Cargo</th>
		            </tr>
		        </thead>
		        <tbody> 
		            
		        </tbody>
		    </table> 
      </div>
    </div>
  </div>
</div>
<!-- FIN MODAL PARA LISTAR LOS TRABAJADORES Y SELECCIONAR LOS INTEGRANTES DE LA CUADRILLA -->
    