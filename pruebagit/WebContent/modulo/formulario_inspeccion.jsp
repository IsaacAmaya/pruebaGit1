<%@ taglib tagdir="/WEB-INF/tags" prefix="t" %>
<%
	String id = request.getParameter("id")==null ? "":request.getParameter("id").toString().trim();

	String Proyecto = request.getParameter("Proyecto")=="0" ? "0":request.getParameter("Proyecto").toString().trim();
	String Obra = request.getParameter("Obra")=="0" ? "0":request.getParameter("Obra").toString().trim();
	String Etapa = request.getParameter("Etapa")=="0" ? "0":request.getParameter("Etapa").toString().trim();


%>
<style type="text/css">
	.error{
		color: red;
		font-weight: bold;
	}
</style>

<link rel="stylesheet" href="Archivos/css/jquery-ui.css">
<script src="Archivos/js/modulo/formulario_inspeccion.js"></script>
<script src="Archivos/js/jquery-ui.js"></script>
<script>
	var tablaListadoObra;
	var tablaListadoMaterial;
	var tablaListadoTrabajador;
	var tablaListadoProyecto;
	var tablaListadoCuadrilla;
  	$( function() {
	  
    	$( ".fec" ).datepicker({
    		dateFormat: 'dd/mm/yy'
        });
    	
    	Date.prototype.toString = function() { return this.getDate()+"/"+(this.getMonth()+1)+"/"+this.getFullYear(); }
    	var miFecha = new Date();
    	$( "#txtFechainspeccion" ).val(miFecha);
    	
    	<% if(!id.equals("")) out.print("cargarInspeccion('"+id+"')");%>
    	
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
    	
    	$('#vModalListadoCuadrilla').on('show.bs.modal', function (e) {
    		cargarListadoCuadrilla();
	  	});
    	
    	var handle = $( "#txtProgreso" );
	    $( "#slider" ).slider({
	          create: function() {
	        	  handle.val( $( this ).slider( "value" ) );
	            
	          },
	          slide: function( event, ui ) {
	        	  handle.val( ui.value );
	            
	          },
	          max: 100
        });
  	});
  	
  	function filtrarProyectos(e){
    	
    	if(e == "btnAgregar"){
    		window.location.href="./addInspeccion?Proyecto="+$("#Proyecto").val()+"&Obra="+$("#Obra").val()+"&Etapa="+$("#Etapa").val()+"&filtradoInspeccion=1";
    	}
    	
    	if(e == "btnCancelar"){
    		window.location.href="./inspeccion?Proyecto="+$("#Proyecto").val()+"&Obra="+$("#Obra").val()+"&Etapa="+$("#Etapa").val()+"&filtradoInspeccion=1";
    	}
    }
  
</script>

		<input type="hidden" id="Proyecto" value="<%=Proyecto %>">
	    <input type="hidden" id="Obra" value="<%=Obra %>">
	    <input type="hidden" id="Etapa" value="<%=Etapa %>">
<div>
<a href="./inspeccion?Proyecto=0&Obra=0&Etapa=0&filtradoInspeccion=1" class="tile-small text-shadow fg-white" style="background:#003399" data-role="tile">
	<div class="tile-content iconic mif-ani-hover-shuttle">
		<img class="icon" src="Archivos/images/iconmenu/INSPECCION1.png">
	</div>
</a>
<h3>Modulo de Inspección de Obras</h3>
  <p>Seccion Dedicada a la Inspección de Obras</p>
  </div>
  
   
   <article id="formulario">
   
      
	    
      <t:panel titulo="Formulario de Inspeccion de Obras">
		<div id="panelPrincipal">
           <ul class="nav nav-tabs">
           
                <li class="active"><a data-toggle="tab" href="#form_inspeccion">Inspección</a></li>
                <li><a data-toggle="tab" href="#detalle_inspeccion" onclick="cargarDetalleInspeccion();">Detalle de la Inspección</a></li>
           </ul><br>
                <div class="tab-content">
                	<input type="hidden" id="idinspeccion" >
                	<input type="hidden" id="idproyecto" >
                	<input type="hidden" id="idobra" >
                	<input type="hidden" id="iddetalleetapa" >
                	<input type="hidden" id="txtFechainspeccion" class="fec">
                	
                    <div id="form_inspeccion" class="tab-pane fade in active" >
	                   
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
		                    
	                   		<div class="col-md-6">
		                    	<label class="control-label"><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Seleccione la etapa: </label>
		                    	<input type="text" class="form-control" id="txtEtapa" data-toggle="modal" data-target="#vModalListadoEtapa" placeholder="Click para seleccionar" readonly>
		                    	<input type="hidden" id="idetapa" >
		                    </div>
		                    <div class="col-md-6">
		                    	<label class="control-label"><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Seleccione la subetapa: </label>
		                    	<input type="text" class="form-control" id="txtSubetapa" data-toggle="modal" data-target="#vModalListadoSubetapa" placeholder="Click para seleccionar" readonly>
		                    	<input type="hidden" id="idsubetapa" >
		                    </div>
		                    <div class="col-md-6">
		                    	<label class="control-label"><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Seleccione la cuadrilla: </label>
		                    	<input type="text" class="form-control" id="txtCuadrilla" data-toggle="modal" data-target="#vModalListadoCuadrilla" placeholder="Click para seleccionar" readonly>
		                    	<input type="hidden" id="idcuadrilla" >
		                    </div>
              	 		</div>
              	 		<br>
              	 		 <div class="row">
							<div class="col-md-12">
								<div class="form-group" style="text-align: center; ">
									<div style="margin-top: 30px;">
										<a onclick="filtrarProyectos('btnAgregar');" class="btn btn-default" style="text-decoration:none;color:#333;" role="button"> <span class="glyphicon glyphicon-repeat"></span> LIMPIAR</a>
										<a onclick="filtrarProyectos('btnCancelar');" class="btn btn-danger" style="text-decoration:none;color:#FFF;" role="button"> <span class="glyphicon glyphicon-remove"></span> CANCELAR</a>
									</div>
								</div>
							</div>
						</div>
                    </div>                  
                    <div id="detalle_inspeccion" class="tab-pane fade">
                    	<input type="hidden" id="iddetalleetapaAux" >
                    	<div class="alert" style="background:#F2F2F2;">
	                    	<div class="row" >
				        		<div class="col-md-3">
				        			<label>Proyecto: </label>
				        			<input type="text" id="txtProyectoAux2" class="form-control" readonly> 
				        		</div>
				        		<div class="col-md-3">
				        			<label>Obra: </label>
				        			<input type="text" id="txtObraAux2" class="form-control" readonly>
				        		</div>
				        		<div class="col-md-3">
				        			<label>Etapa: </label>
				        			<input type="text" id="txtEtapaAux2" class="form-control" readonly> 
				        		</div>
				        		<div class="col-md-3">
				        			<label>Subetapa: </label>
				        			<input type="text" id="txtSubetapaAux2" class="form-control" readonly>
				        		</div>
				        		
				        	</div>
				        </div><br>
			        	<div class="row" >
			        		<div class="col-md-3">
			        			<label><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Progreso: <span id="porcentajeMostrar" style="font-weight:bold;"></span></label>
			        			<div class="row">
			        				
			        				<div class="col-md-12">
				        				<div id="pb1" class="progress large" data-role="progress"></div>
			        				</div>
			        				<div class="col-md-12">
				        				<div id="slider"></div>
			        				</div>
			        				
			        			</div>	        			
			        		</div >
			        		<div class="col-md-2">
			        			<label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
			        			<input type="text" id="txtProgreso" class="form-control" readonly>
			        		</div>
			        		
			        		<div class="col-md-7">
			        			<label><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Observación: </label>
			        			<input type="text" id="txtObservacion" class="form-control" required="required">
			        		</div>
			        		
			        	</div><br>
			        	<div class="row">
			        		<div class="col-md-12">
			        			<button type="button" class="btn btn-default">Agregar Imagenes</button>
			        		</div>
			        	</div><br>
			        	
                    	<div class="row" style="margin-top:5px;">
                    		<div class="col-md-12">
			               		<table class="table table-striped" id="listadoSubetapas">
			               			<thead><tr><th>Fecha de la inspección</th><th>Porcentaje Inspeccionado</th><th>Observación</th></tr></thead>
			               			<tbody></tbody>
			               		</table>
			               		
                    		</div>		               		
		               	</div>
		               	 <div class="row">
							<div class="col-md-12">
								<div class="form-group" style="text-align: center; ">
									<div style="margin-top: 30px;">
										<button type="button" class="btn btn-success" onclick="guardarInspeccion();"><span class="glyphicon glyphicon-ok"></span> Guardar</button>
										<a onclick="filtrarProyectos('btnAgregar');" class="btn btn-default" style="text-decoration:none;color:#333;" role="button"> <span class="glyphicon glyphicon-repeat"></span> LIMPIAR</a>
										<a onclick="filtrarProyectos('btnCancelar');" class="btn btn-danger" style="text-decoration:none;color:#FFF;" role="button"> <span class="glyphicon glyphicon-remove"></span> CANCELAR</a>
									</div>
								</div>
							</div>
						</div>
           			</div>
           			
      		 </div>
      	</div>
      	<div id="panelSecundario" hidden="hidden">
      		<div class="row">
     			<div class="col-md-4">
     				<label>Proyecto:</label>
     				<input type="text" id="txtNombreproyecto" class="form-control" disabled="disabled">
     			</div>
     			<div class="col-md-4">
     				<label>Obra:</label>
     				<input type="text" id="txtNombreobra" class="form-control" disabled="disabled">
     			</div>
     			<div class="col-md-4">
     				<label>Etapa:</label>
     				<input type="text" id="txtNombreetapa" class="form-control" disabled="disabled">
     			</div>
     			<div class="col-md-4">
     				<label>Subetapa:</label>
     				<input type="text" id="txtNombresubetapa" class="form-control" disabled="disabled">
     			</div>
     			<div class="col-md-4">
     				<label>Fecha:</label>
     				<input type="text" id="txtFechainspeccionS" class="form-control" disabled="disabled">
     			</div>
     			<div class="col-md-4">
     				<label>Porcentaje:</label>
     				<input type="text" id="txtPorcentaje" class="form-control" disabled="disabled">
     			</div> 
     			<div class="col-md-12">
     				<label>Observación: </label>
     				<input type="text" id="txtObservacionS" class="form-control" disabled="disabled">
     			</div>       			
     		</div> <br>
     		<div class="row">
     			<div class="col-md-4">
     				<label>Imágenes:</label>     				
     			</div>
     		</div><br>
     		<div class="row">
				<div class="col-md-12">
					<div class="form-group" style="text-align: center; ">
						<div style="margin-top: 30px;">
							<a onclick="filtrarProyectos('btnAgregar');" class="btn btn-default" style="text-decoration:none;color:#333;" role="button"> <span class="glyphicon glyphicon-repeat"></span> LIMPIAR</a>
							<a onclick="filtrarProyectos('btnCancelar');" class="btn btn-danger" style="text-decoration:none;color:#FFF;" role="button"> <span class="glyphicon glyphicon-remove"></span> CANCELAR</a>
						</div>
					</div>
				</div>
			</div>     		
      	</div>
    	 
     </t:panel>
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
<!--############################################################################################################################################################# -->
<!-- MODAL CUADRILLA -->
<div class="modal fade" id="vModalListadoCuadrilla" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h6 class="modal-title" id="myModalLabel">Seleccionar Cuadrilla</h6>
      </div>
      <div class="modal-body">
        	<table id="ListadoCuadrilla" class="table table-hover"  width="100%">
		        <thead>
		            <tr>
		            	<th>idcuadrilla</th>
		            	<th>Nombre</th>
		                <th>Jefe de Cuadrilla</th>
		            </tr>
		        </thead>
		        <tfoot>
		            <tr>
		            	<th>idcuadrilla</th>
		            	<th>Nombre</th>
		                <th>Jefe de Cuadrilla</th>
		            </tr>
		        </tfoot>
		        <tbody>
		            
		        </tbody>
		    </table> 
      </div>
    </div>
  </div>
</div>
<!-- FIN MODAL CUADRILLA -->
<!-- ################################################################################################################################################################### -->
<!-- MODAL INSPECCION -->
<div class="modal fade" id="vModalAgregarInspeccion" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h6 class="modal-title" id="myModalLabel">Ingrese los datos de la inspección</h6>
	      
      </div>
      <div class="modal-body">
      		
      </div>
      <div class="modal-footer">
      		
      </div>
    </div>
  </div>
</div>

<!-- FIN MODAL PROYECTO -->
<!--############################################################################################################-->
   </article>