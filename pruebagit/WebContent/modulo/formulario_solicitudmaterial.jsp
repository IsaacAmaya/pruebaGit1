<%@ taglib tagdir="/WEB-INF/tags" prefix="t" %>
<%
	String id = request.getParameter("id")==null ? "":request.getParameter("id").toString().trim();
	
%>
<style>
	.error{
		color: red;
		font-weight: bold;
	}	
</style>
<link href="Archivos/css/select2.css" rel="stylesheet">
<script src="Archivos/js/select2.min.js"></script>
<script src="Archivos/js/modulo/formulario_solicitudmaterial.js"></script>

<script>
var tablaListadoObra;
var tablaListadoMaterial;
var tablaListadoTrabajador;
var tablaListadoProyecto;
  $( function() {
	  
    	$( ".fec" ).datepicker({
    		dateFormat: 'dd/mm/yy'
        });
    	
    	Date.prototype.toString = function() { return this.getDate()+"/"+(this.getMonth()+1)+"/"+this.getFullYear(); }
    	var miFecha = new Date();
    	$( "#txtFechasolicitud" ).val(miFecha);
    	
    	<% if(!id.equals("")) out.print("cargarSolicitudmaterial('"+id+"')");%>   	
    	
    	$('#vModalListadoMaterial').on('show.bs.modal', function (e) {
  			cargarListadoMaterial();
  			
	  	});
    	
	  	$('#vModalListadoTrabajador').on('show.bs.modal', function (e) {
	  		cargarListadoTrabajador();
	  	});
    	
    	$('#vModalListadoProyecto').on('show.bs.modal', function (e) {
    		cargarListadoProyecto();    		
	  	});
    	
    	$('#vModalListadoObra').on('show.bs.modal', function (e) {
    		cargarListadoObra();
	  	});
    	
    	$('#vModalListadoEtapa').on('show.bs.modal', function (e) {
    		cargarListadoEtapa();
	  	});
    	
    	$('#vModalListadoSubetapa').on('show.bs.modal', function (e) {
    		cargarListadoSubetapa();
	  	});
    	validarBotones("solicitudmaterial",$("#idUsuario").val(),"2");
  });
  
</script>
<input type="hidden" value="<%=session.getAttribute("idusuario") %>" id="idUsuario">
<div>
<a href="./solicitudmaterial" class="tile-small text-shadow fg-white" style="background:#CD7372" data-role="tile">
                    <div class="tile-content iconic mif-ani-hover-shuttle">
                        <img class="icon" src="Archivos/images/iconmenu/SOLICITUD1.png"></img>
                    </div>
                    
                </a>
<h3>Modulo de Solicitud de Materiales</h3>
  <p>Seccion Dedicada a la Solicitud de Materiales</p>
  </div>
  
   
   <article id="formulario">
      
      <t:panel titulo="Formulario de Solicitud Materiales">  

           <ul class="nav nav-tabs">
           
                <li class="active"><a data-toggle="tab" href="#form_solicitud">Solicitud</a></li>
                <li><a data-toggle="tab" href="#detalle_solicitud" onclick="cargarDetalleSolicitudmaterial();">Detalle de Solicitud</a></li>
           </ul>
                <div class="tab-content">
                	<input type="hidden" id="idsolicitudmaterial" >
                	<input type="hidden" id="idtrabajador" >
                	<input type="hidden" id="txtFechasolicitud" class="fec">
                	<input type="hidden" id="verificarError"/>
                	
                    <div id="form_solicitud" class="tab-pane fade in active" >
	                   
	                    <div class="row">
		                    <div class="col-md-12">
		                    	<button type="button" data-toggle="modal" data-target="#vModalListadoTrabajador" class="btn btn-primary" style="margin-top: 5px;" aria-hidden="true"><span class="glyphicon glyphicon-search"></span> Buscar</button>
			                </div>                                      
		                    <div class="col-md-2">
		                    	<label class="control-label"><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Solicitante: </label>
		                    	<input type="text" class="form-control" id="txtCedula" placeholder="Cedula" onblur="consultarCedula(this.value);" >
		                    </div>                    
		                    <div class="col-md-4">
		                    	<label class="control-label">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
		                    	<input type="text" class="form-control" id="txtDatospersonales" placeholder="Nombres y Apellidos" readonly>
		                    </div>
		                    <div class="col-md-3">
		                    	<label class="control-label"><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Cargo: </label>
		                    	<input type="text" class="form-control" id="txtCargo" placeholder="Cargo" readonly>
		                    </div>
		                    <div class="col-md-3">
		                    	<label class="control-label"><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Cuadrilla: </label>
		                    	<input type="text" class="form-control" id="txtCuadrilla" placeholder="Cuadrilla" readonly>
		                    </div>                         
	                    	
	                    </div>	                   
	                    <br>
	                   	<div class="row">
	                   		<div class="col-md-6">
		                    	<label class="control-label"><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Seleccione el proyecto: </label>
		                    	<input type="text" id="txtProyecto" data-toggle="modal" data-target="#vModalListadoProyecto" class="form-control" placeholder="Click para seleccionar" readonly>
		                    	<input type="hidden" id="idproyecto">
		                    </div>
		                   
	                   		<div class="col-md-6">
		                    	<label class="control-label"><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Seleccione la obra: </label>
		                    	<input type="text" class="form-control" id="txtObra" data-toggle="modal" data-target="#vModalListadoObra" placeholder="Click para seleccionar" readonly>
		                    	<input type="hidden" id="idobra" >
		                    	<input type="hidden" id="idtipoobra" >
		                    </div>
		                
              	 		</div>             	 		
              	 		
              	 		<div class="row">
	                   		<div class="col-md-6">
		                    	<label class="control-label"><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Seleccione la etapa: </label>
		                    	<input type="text" class="form-control" id="txtEtapa" data-toggle="modal" data-target="#vModalListadoEtapa" placeholder="Click para seleccionar" readonly>
		                    	<input type="hidden" id="idetapa" >
		                    </div>
		                    <div class="col-md-6">
		                    	<label class="control-label"><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Seleccione la subetapa: </label>
		                    	<input type="text" class="form-control" id="txtSubetapa" data-toggle="modal" data-target="#vModalListadoSubetapa" placeholder="Click para seleccionar" readonly>
		                    	<input type="hidden" id="idsubetapa" >
		                    	<input type="hidden" id="iddetalleetapa" >
		                    </div>
              	 		</div>
              	 		<br>
              	 		
                    </div>                  
                    <div id="detalle_solicitud" class="tab-pane fade">
                    	<div class="row">
	               			<div class="col-md-6">
	               				<label class="control-label"><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Material: </label>
	               				<input type="text" id="mostrarModalMateriales" data-toggle="modal" data-target="#vModalListadoMaterial" aria-hidden="true" class="form-control" readonly placeholder="Click para seleccionar material" style="cursor:pointer;" />
	               				<input id="idmaterial" type="hidden">
	               			</div>
	               			
	               			<div class="col-md-2">
	               				<label class="control-label" for="txtCantidad"><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Cantidad: </label>
	               				<input type="text" class="form-control soloNumero" id="txtCantidadAux" onkeyup="validarCantidad();" />
	               			</div>
	               			<div class="col-md-2">
	               				<label class="control-label" for="txtDisponible"><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Disponible: </label>
	               				<input type="text" class="form-control" id="txtDisponible" style="color:#585858;" disabled="disabled" />
	               			</div>
	               			<div class="col-md-2">
	               				<button class="btn btn-sm btn-primary incluir" style="margin-top:28px;" onclick="guardarMaterialSolicitud();"><span class='glyphicon glyphicon-plus'></span></button>
	               			</div>
	               		</div>
                    	<div class="row" style="margin-top:5px;">
                    		<div class="col-md-12">
			               		<table class="table table-condensed" id="listadoMaterialActivos" class="display"  width="100%" >
			      					<thead>
			      						<tr>
											<th>Nombre del material</th>
											<th width="200px"><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Cantidad</th>
											<th width="200px">Disponible</th>
											<th>Opción</th>
										</tr>
									</thead>
									<tbody style="font-size:16px;">
										<tr id='mensaje'><td colspan='4'><center><h4 style='color:#CCC;'>Sin materiales asignados.</h4></center></td></tr>
									</tbody>
			      				</table>
                    		</div>		               		
		               	</div >
           			</div>
           			<div class="row" id="numeroSolicitud" hidden="hidden">
		                    <div class="col-md-3">
		                    	<label class="control-label">Nro de Solicitud: </label>
		                    	<span id="idSolicitudAux" style="font-weight:bold;font-size:16px;" ></span>
		                    </div>            
              	 		</div>
           			<br>
           			<div class="row" id="observacionDiv" hidden="hidden">
	                	<div class="col-md-12">
	                		<label class="control-label" >Observación: </label>
	                		<h5><span class="label" style="font-weight:normal;background:#FA8258;"> <span  class="glyphicon glyphicon-warning-sign" ></span> <span id="txtObservacion" ></span></span></h5>
	                		
	                	</div>
               		</div>
             		<div class="row">
	                	<div class="col-md-12">
	                		<div class="form-group" style="text-align: center; ">
								<div style="margin-top: 30px;">
									<t:btnBotonera accionguardar="guardarSolicitudmaterial();" accioncancelar="window.location.href = './solicitudmaterial';" accionlimpiar="window.location.href = './addSolicitudmaterial';"></t:btnBotonera>		     
				        		</div>
	                		</div>
	                	</div>                 
               		</div>
               
      		 </div>
    	 
     </t:panel>
<!-- ########################################################################################################### -->
<!-- MODAL LISTADO MATERIALES -->
	<div id="vModalListadoMaterial" class="modal fade" role="dialog">
		  <div class="modal-dialog">
		    <!-- Modal content-->
		    <div class="modal-content">
		      <div class="modal-header">
		        <button type="button" class="close" data-dismiss="modal">&times;</button>
		        <h6 class="modal-title">MATERIALES</h6>
		        <input type="text"  id="txtMaterialAux" class="form-control" placeholder="Buscar" style="width:30%;float:right;" onkeyup="cargarListadoMaterial();" >
	    
		       </div>
		      <div class="modal-body">
		        	<table id="ListadoMaterial" class="table table-hover"  width="100%">
						<thead>
							<tr>
						        <th>Nombre</th>
						       
						        <th>Disponible</th>
						    </tr>
						</thead>
						<tfoot>
				            <tr>
						        <th>Nombre</th>
						       
						        <th>Disponible</th>
				            </tr>
				        </tfoot>
						 <tbody>
		            
		        		</tbody>
					</table>
		     </div>
		    </div>		
		  </div>
	</div>
<!--FIN MODAL LISTADO MATERIALES -->
<!--############################################################################################################-->
<!-- MODAL TRABAJADORES -->
<div class="modal fade" id="vModalListadoTrabajador" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h6 class="modal-title" id="myModalLabel">Seleccionar Trabajador</h6>
      </div>
      <div class="modal-body">
        	<table id="ListadoTrabajador" class="display"  width="100%">
		        <thead>
		            <tr>
		            	<th>idtrabajador</th>
		            	<th>Nombre</th>
		                <th>Cargo</th>
		                <th>Cuadrilla</th>                
		            </tr>
		        </thead>
		        <tfoot>
		            <tr>
		            	<th>idtrabajador</th>
		            	<th>Nombre</th>
		                <th>Cargo</th>
		                <th>Cuadrilla</th>	                
		            </tr>
		        </tfoot>
		        <tbody> 
		            
		        </tbody>
		    </table> 
      </div>
    </div>
  </div>
</div>
<!-- FIN MODAL TRABAJADORES -->
<!--############################################################################################################-->
<!-- MODAL PROYECTO -->
<div class="modal fade" id="vModalListadoProyecto" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h6 class="modal-title" id="myModalLabel">Seleccionar Proyecto</h6>
      	<input type="text"  id="txtProyectoAux" class="form-control" placeholder="Buscar" style="width:30%;float:right;" onkeyup="cargarListadoProyecto();" >
	      
      </div>
      <div class="modal-body">
        	<table id="ListadoProyecto" class="table table-hover"  width="100%">
		        <thead>
		            <tr>
		            	<th>Nombre</th>
		                <th>Descripción</th>
		            </tr>
		        </thead>
		        <tfoot>
		            <tr>
		            	<th>Nombre</th>
		                <th>Descripción</th>
		            </tr>
		        </tfoot>
		        <tbody> 
		            
		        </tbody>
		    </table> 
      </div>
    </div>
  </div>
</div>
<!-- FIN MODAL PROYECTO -->
<!--############################################################################################################-->
<!-- MODAL OBRAS -->
<div class="modal fade" id="vModalListadoObra" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h6 class="modal-title" id="myModalLabel">Seleccionar Obra</h6>
        <input type="text"  id="txtObraAux" class="form-control" placeholder="Buscar" style="width:30%;float:right;" onkeyup="cargarListadoObra();" >
	     
      </div>
      <div class="modal-body">
        	<table id="ListadoObra" class="table table-hover"  width="100%">
		        <thead>
		            <tr>
		            	<th>Nombre</th>
		                <th>Descripción</th>
		            </tr>
		        </thead>
		        <tfoot>
		            <tr>
		            	<th>Nombre</th>
		                <th>Descripción</th>
		            </tr>
		        </tfoot>
		        <tbody> 
		            
		        </tbody>
		    </table> 
      </div>
    </div>
  </div>
</div>
<!-- FIN MODAL OBRAS -->
<!--############################################################################################################-->
<!-- MODAL ETAPAS -->
<div class="modal fade" id="vModalListadoEtapa" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h6 class="modal-title" id="myModalLabel">Seleccionar Etapa</h6>
        <input type="text"  id="txtEtapaAux" class="form-control" placeholder="Buscar" style="width:30%;float:right;" onkeyup="cargarListadoEtapa();" >
	   
      </div>
      <div class="modal-body">
        	<table id="ListadoEtapa" class="table table-hover"  width="100%">
		        <thead>
		            <tr>
		            	<th>Nombre</th>
		                <th>Descripción</th>
		            </tr>
		        </thead>
		        <tfoot>
		            <tr>
		            	<th>Nombre</th>
		                <th>Descripción</th>
		            </tr>
		        </tfoot>
		        <tbody> 
		            
		        </tbody>
		    </table> 
      </div>
    </div>
  </div>
</div>
<!-- FIN MODAL ETAPAS -->
<!--############################################################################################################-->
<!-- MODAL SUBETAPAS -->
<div class="modal fade" id="vModalListadoSubetapa" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h6 class="modal-title" id="myModalLabel">Seleccionar Subetapa</h6>
      	<input type="text"  id="txtSubetapaAux" class="form-control" placeholder="Buscar" style="width:30%;float:right;" onkeyup="cargarListadoSubetapa();" >
      </div>
      <div class="modal-body">
        	<table id="ListadoSubetapa" class="table table-hover"  width="100%">
		        <thead>
		            <tr>
		            	<th>Nombre</th>
		                <th>Descripción</th>
		            </tr>
		        </thead>
		        <tfoot>
		            <tr>
		            	<th>Nombre</th>
		                <th>Descripción</th>
		            </tr>
		        </tfoot>
		        <tbody> 
		            
		        </tbody>
		    </table> 
      </div>
    </div>
  </div>
</div>

<!-- FIN MODAL ETAPAS -->
<!--############################################################################################################-->
   </article>