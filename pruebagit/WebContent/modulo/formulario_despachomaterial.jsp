<%@ taglib tagdir="/WEB-INF/tags" prefix="t" %>
<%
	String id = request.getParameter("id")==null ? "":request.getParameter("id").toString().trim();
	
%>
	<style>
		.error{color: red;font-weight:bold;}
		.labelForm{font-weight:bold;}
		#editar,#guardar{display:none;}
	</style>
	<script src="Archivos/js/modulo/formulario_despachomaterial.js"></script>
	<script>
	
	  $( function() {
		  
	    	$(".fec").datepicker({
	    		dateFormat: 'dd/mm/yy'
	        });
	    	
	    	Date.prototype.toString = function() { return this.getDate()+"/"+(this.getMonth()+1)+"/"+this.getFullYear(); }
	    	var miFecha = new Date();
	    	$( "#txtFechadespacho" ).val(miFecha);
	    	
	    	<% if(!id.equals("")) out.print("cargarDespachomaterial('"+id+"')");%>
	    	
	    	$("#btnEditar").click(function(){
	    		$("#editar").show();
	    	});
	    	
	    	$("#btnDespachar").click(function(){
	    		if(!$("#verificarError").hasClass("error")){
	    			$("#guardar").show();
		    		$(".bd-example-modal-lg").modal("show");
	    		}else{
	    			swal("Error!", "Hay cantidades que superan la existencia de algunos materiales, por favor verificar.", "error");	    			
	    		}
	    	});
	    	validarBotones("despachomaterial",$("#idUsuario").val(),"2");
	    	
	  } );
	</script>
	<input type="hidden" value="<%=session.getAttribute("idusuario") %>" id="idUsuario">
	<div>
		 <a href="./despachomaterial" class="tile-small text-shadow fg-white" style="background:#FA6800" data-role="tile">
                    <div class="tile-content iconic mif-ani-hover-shuttle">
                        <img class="icon" src="Archivos/images/iconmenu/DESPACHO1.png"></img>
                    </div>
                    
                </a>
		<h3>Modulo de Despacho de Materiales</h3>
	  	<p>Seccion Dedicada al Despacho de Materiales</p>
  	</div>
  
   
   <article id="formulario">
      
      
	<t:panel titulo="Formulario de Despacho de Materiales">
		<input type="hidden" id="idsolicitudmaterial"/>
		<input type="hidden" id="txtFechadespacho" class="fec" /><!--FECHA QUE SE GUARDA AL HACER EL DESPACHO-->
		<input type="hidden" id="validarPlaca"/>
		<input type="hidden" id="verificarError"/>
		<div class="row">
			<div class="col-md-12">
				<h5>Datos de la solicitud</h5><hr>				
			</div>
			<div class="col-md-4">
				<label class="labelForm">Nro de la solicitud:</label>
				<span id="idSolicitudAux"></span>
				
			</div>
			<div class="col-md-4">
				<label class="labelForm">Fecha de solicitud:</label>
				<span id="txtFechasolicitud"></span>
			</div>
		</div>
		<div class="row">
			<div class="col-md-4">
				<label class="labelForm">Solicitante:</label>
				<span id="txtCedula"></span>&nbsp;<span id="txtDatospersonales"></span>
			</div>
			<div class="col-md-4">
				<label class="labelForm">Cargo:</label>
				<span id="txtCargo"></span>
			</div>
			<div class="col-md-4">
				<label class="labelForm">Cuadrilla:</label>
				<span id="txtCuadrilla"></span>
			</div>
			<div class="col-md-4">
				<label class="labelForm">Proyecto:</label>
				<span id="txtProyecto"></span>
			</div>
			<div class="col-md-4">
				<label class="labelForm">Obra:</label>
				<span id="txtObra"></span>
			</div>
			<div class="col-md-4">
				<label class="labelForm">Etapa:</label>
				<span id="txtEtapa"></span>
			</div>
			<div class="col-md-4">
				<label class="labelForm">Subetapa:</label>
				<span id="txtSubetapa"></span>
			</div>			
		</div>
		<div id="datosEnvio">
			
			<div class="row">
				<div class="col-md-12">
					<h5>Datos de Despacho</h5><hr>
				</div>						
				<div class="col-md-3">
					<label class="labelForm">Placa del Vehiculo:</label>
					<span id="txtPlacaAux"></span>&nbsp;<span id="txtDatospersonales"></span>
				</div>
				<div class="col-md-3">
					<label class="labelForm">Marca:</label>
					<span id="txtMarcaAux"></span>
				</div>
				<div class="col-md-3">
					<label class="labelForm">Modelo:</label>
					<span id="txtModeloAux"></span>
				</div>
				<div class="col-md-3">
					<label class="labelForm">Fecha Del Despacho:</label>
					<span id="txtFechadespachoAux"></span>
				</div>
				
			</div>
			<div class="row">
				<div class="col-md-3">
					<label class="labelForm">Chofer:</label>
					<span id="txtChoferAux"></span>
				</div>
			</div>
			<div class="row">
				<div class="col-md-6">
					<label class="labelForm">Retirado por:</label>
					<span id="txtResponsableAux"></span>&nbsp;<span id="txtDatospersonales"></span>
				</div>
				
			</div>
		</div>
        
		<div class="row" style="margin-top:5px;" id="listadoMateriales">
	        <div class="col-md-12">
				<table class="table table-condensed" id="listadoMaterialActivos" class="display"  width="100%" >
					<thead>
						<tr><h4>Materiales Solicitados</h4></tr>
						<tr>
							<th>Nombre del material</th>
							<th width="200px">Cantidad</th>
							<th width="200px">Disponible</th>
						</tr>
					</thead>
					<tbody style="font-size:16px;"></tbody>
				</table>
				<hr>
	        </div>		               		
		</div >
		<div class="row" style="margin-top:5px;" id="listadoMaterialesAux">
	        <div class="col-md-12">
				<table class="table table-condensed" id="listadoMaterialActivosAux" class="display"  width="100%" >
					<thead>
						<tr><h4>Materiales Despachados</h4></tr>
						<tr>
							<th>Nombre del material</th>
							<th width="200px">Cantidad</th>
						</tr>
					</thead>
					<tbody style="font-size:16px;"></tbody>
				</table>
				<hr>
	        </div>		               		
		</div >
		<div class="row" >
		    <div class="col-md-12">
			    <div class="form-group" style="text-align: center; ">
					<div style="margin-top: 30px;">
						<button class="btn btn-primary" id="btnEditar" data-toggle="modal" data-target=".bd-example-modal-lg" ><span class="glyphicon glyphicon-pencil"></span> Editar</button>
						<button class="btn btn-success modificar" id="btnDespachar" ><span class="glyphicon glyphicon-check"></span> Despachar</button>
						<button class="btn btn-danger" onclick="window.location.href = './despachomaterial';"><span class="glyphicon glyphicon-remove"></span> Cancelar</button>
						<button class="btn btn-info modificar" id="btnRechazar" data-toggle="modal" data-target="#vModalRechazar"><span class="glyphicon glyphicon-ban-circle"></span> Rechazar</button>
					</div>
			    </div>
		    </div>                 
        </div>
     </t:panel>
<!--MODAL DATOS DE DESPACHO  -->
     <div class="modal fade bd-example-modal-lg" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" id="vModalEnvio">
	  <div class="modal-dialog modal-lg">
	    <div class="modal-content">
	     	<div class="modal-header">
	     		<h6 class="modal-title" id="myModalLabel">Ingrese los datos de despacho</h6>
	        	<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        	
	      	</div>
	     	<div class="modal-body">
	      		<div class="row">	        		
					<div class="col-md-4">
						<label class="label-control">Placa:</label>
						<input type="text" id="txtPlaca" class="form-control" required>
					</div>
					<div class="col-md-4">
						<label class="label-control">Marca:</label>
						<input type="text" id="txtMarca" class="form-control" required>
					</div>
					<div class="col-md-4">
						<label class="label-control">Modelo:</label>
						<input type="text" id="txtModelo" class="form-control" required>
					</div>
					<div class="col-md-6">
						<label class="label-control">Chofer:</label>
						<input type="text" id="txtChofer" class="form-control" placeholder="Ingrese cedula, nombre y apellido" required>
					</div>
					<div class="col-md-6">
						<label class="label-control">Responsable:</label>
						<input type="text" id="txtResponsable" class="form-control" placeholder="Ingrese cedula, nombre y apellido" required>
					</div>
	        	</div>
	        	
	      	</div>
	      	<div class="modal-footer">
	      		<button type="button" id="guardar" class="btn btn-success" onclick="guardarDespachomaterial();" ><span class="glyphicon glyphicon-ok" ></span> Aceptar</button>
	      		<button type="button" id="editar" class="btn btn-success" onclick="editarDespachomaterial();" ><span class="glyphicon glyphicon-ok" ></span> Aceptar</button>
	      	</div>
	    </div>
	  </div>
	</div>
<!--FIN MODAL DATOS DE DESPACHO  -->
<!--#####################################################################################################################  -->

	<div class="modal fade" id="vModalRechazar" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h6 class="modal-title" id="exampleModalLabel">Indique el motivo del rechazo</h6>
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	          <span aria-hidden="true">&times;</span>
	        </button>
	      </div>
	      <div class="modal-body">
	      	<textarea rows="5" class="form-control" id="txtObservacion"></textarea>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-success" onclick="rechazarSolicitud();"><span class="glyphicon glyphicon-ok" ></span> Aceptar</button>
	      </div>
	    </div>
	  </div>
	</div>
   </article>