<%@ taglib tagdir="/WEB-INF/tags" prefix="t" %> 

<%
	String id = request.getParameter("id")==null ? "":request.getParameter("id").toString().trim();
%>
<style>
	.error{color:red;font-weight:bold;}
</style>
<script src="Archivos/js/modulo/formulario_etapa.js"></script>
<script>
	var tablaListadoSubetapa;
  $( function() {
	  $( ".fec" ).datepicker({
  		dateFormat: 'dd/mm/yy'
      });
    <% 
    	if(!id.equals("")){
    		out.print("cargarEtapa('"+id+"')");
    	}
    		
    %>
     $('#vModalListadoSubEtapa').modal({
  		  show: false
  	  });
  	  
  	 /*  $('#vModalListadoSubEtapa').on('show.bs.modal', function (e) {
  			cargarListadoSubEtapa();
  	  }); */
     validarBotones("etapa",$("#idUsuario").val(),"2");
  });
  
</script>
<input type="hidden" value="<%=session.getAttribute("idusuario") %>" id="idUsuario">
<div>
<a href="./etapa" class="tile-small text-shadow fg-white" style="background:#008A00" data-role="tile">
                    <div class="tile-content iconic mif-ani-hover-shuttle">
                        <img class="icon" src="Archivos/images/iconmenu/ETAPAS.png" ></img>
                    </div>
                 </a>
<h3>Modulo de Etapa</h3>
  <p>Seccion Dedicada al Registro de Etapas</p>
   </div>
   <article id="formulario">
      
      
      <t:panel titulo="Formulario de Registro de Etapas">
      	
            <ul class="nav nav-tabs">           
                <li class="active"><a data-toggle="tab" href="#form_etapa">Etapas</a></li>
                <li><a data-toggle="tab" href="#subetapas" onclick="cargarDetalleEtapa()">Sub-Etapas</a></li>
           </ul>
           <div class="tab-content">
           		<div id="form_etapa" class="tab-pane fade in active" >
           			<input type="hidden" id="idetapa" >           			
           					<div class="row">
				                <div class="form-group">				                    
				                    <div class="col-sm-6 col-md-4">
				                    	<label class="control-label"><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Nombre: </label>		                      
				                      	<input type="text" class="form-control" required="required" onblur="consultarEtapa(this.value);" id="txtNombre" placeholder="Ingrese Nombre De la Etapa">
				                    </div>
				                
				                    <div class="col-sm-12 col-md-4">
					                    <label class=" control-label"><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Descripción:</label>
					                    <input type="text" class="form-control" id="txtDescripcion" required="required" placeholder="Ingrese Descripción De la Etapa">
				                    </div>
				                    
				                    <div class="col-sm-12 col-md-4">
				                   	 	<label class="control-label"><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Porcentaje: </label>
				                      	<input type="text" class="form-control" id="txtPorcentaje" required="required" placeholder="Ingrese Porcentaje">
				                    </div>
				                
				                    <div class="col-sm-6 col-md-4">
					                    <label class="control-label">Tiempo estimado (dias):</label>
					                    <input type="text" class="form-control"  id="txtTiempoestimado" placeholder="Ingrese tiempo estimado">
				                    </div>
				                                
									<div class="col-sm-6 col-md-4">
				                    	<label class="control-label">Estatus:</label>
				
				                        <select id="cmbEstatus" class="form-control">
				                            <option value="1">Activo</option>
				                            <option value="0">Inactivo</option>
				                        </select>
				                    </div>
				                </div>
				                
        
           					</div>
		    		 </div>
	    		
		    		 <div id="subetapas" class="tab-pane fade"><br>
			    		 <div class="row">
			    		 	<div class="col-md-12">
			    		 		<div class="alert" style="background:#F2F2F2;">
					                <div class="row" >
									    <div class="col-md-6">
										    <label>Nombre etapa: </label>
										    <input id="txtNombreetapaAux" class="form-control" disabled="disabled">
									    </div>
									    <div class="col-md-6">
										    <label>Descripción: </label>
										    <input type="text" id="txtDescripcionAux" class="form-control" disabled="disabled">
									    </div>					        		
								    </div>
							    </div>
			    		 	
			    		 	</div>    				
			    		 </div>
			    		 <button type="button" class="btn btn-success incluir" style="margin-top: 5px; margin-bottom: 15px" onclick="cargarListadoSubEtapa();"><span class="glyphicon glyphicon-plus" aria-hidden="true" ></span> Agregar Sub-Etapa</button>
			    		 <div class="row" ><!-- LISTADO DEL DETALLE ETAPA -->
		      					<div class="col-md-12" >
		      						<div style="height:300px;max-height:300px;overflow:auto;">
			      						<table class="table table-striped" id="listadoSubEtapaActivos" class="display"  width="100%">
				      						<thead>								           							                
												<th>Nombre</th>
												<th>Descripción</th>
												<th><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Porcentaje</th>
												<th>Opción</th>
										    </thead>
										    <tbody></tbody>
				      					</table>
			      					</div>
		      					</div>	      					
		      			</div><br>
		      			<div class="row">
		      				<div class="col-md-12">
		      					<div style="float:right;">
		      						<label>Total de Procentaje:</label>
		      						<input type="text" class="form-control" id="sumaPorcentaje" disabled="disabled">
		      						<input type="hidden" id="validarListado">
		      					</div>
		      				</div>
		      			</div>
	      			</div>
      			</div>
      			
      			<div class="row">
     				<div class="col-md-12 col-xs-12">
     					<div class="form-group" style="text-align: center; ">
								<div style="margin-top: 30px;">
								     <t:btnBotonera accionguardar="guardarEtapa();" accioncancelar="window.location.href = './etapa';" accionlimpiar="window.location.href = './addEtapa';"></t:btnBotonera>
				     
				        		</div>
		                	</div>
     				</div>
      			</div>
    
     </t:panel>  
    <!-- VENTANA MODAL LISTADO DE LAS SUB-ETAPAS -->
    <div id="vModalListadoSubEtapa" class="modal fade" role="dialog">
		  <div class="modal-dialog modal-lg">		
		    <!-- Modal content-->
		    <div class="modal-content">
		      <div class="modal-header">
		        	<button type="button" class="close" data-dismiss="modal">&times;</button>
		        	<h6 class="modal-title">SUB-ETAPAS</h6>
		         	<input type="text"  id="txtEtapaAux" class="form-control" placeholder="Buscar" style="width:30%;float:right;" onkeyup="cargarListadoSubEtapa();" >
		      </div>
		      <div class="modal-body">
		        	<table id="ListadoSubetapa" class="table table-hover display"  width="100%">
						<thead>
							<tr>					                
								<th>Nombre</th>
								<th>Descripciòn</th>								
							</tr>
						</thead>
						<tbody>
						            
						</tbody>
					</table>
		      </div>
		      <!-- <div class="modal-footer">
		        <button type="button" onclick="incluirSeleccionadosSubEtapa();" class="btn btn-sm btn-default" data-dismiss="modal">Aceptar</button>
		      </div> -->
		    </div>		
		  </div>
	</div>
	<!--FIN VENTANA MODAL LISTADO DE LAS SUB-ETAPAS -->
	<!-- ************************************************************************* -->
	<!-- MODAL PARA INCLUIR SUBETAPAS -->
	<div id="vModalAgregarSubetapa" class="modal fade" role="dialog">
		  <div class="modal-dialog">		
		    <!-- Modal content-->
		    <div class="modal-content">
		      <div class="modal-header">
		        <button type="button" class="close" data-dismiss="modal">&times;</button>
		        <h6 class="modal-title">REGISTRO DE SUB-ETAPA</h6>
		       </div>
		      <div class="modal-body">
		        	<div class="row">
		                <div class="form-group">
		                    
		                    <div class="col-sm-4 col-md-4">
		                    <label class="control-label">Nombre: </label>
		                      <input type="text" class="form-control" id="txtNombreS" placeholder="Ingrese Nombre De la Sub-Etapa">
		                    </div>
		                
		                    <div class="col-sm-8 col-md-8">
		                    <label class=" control-label">Descripción: </label>
		                    <input type="text" class="form-control" id="txtDescripcionS" placeholder="Ingrese Descripción De la Sub-Etapa">
		                    </div>
		                    
		                    <div class="col-sm-6 col-md-4">
		                    	<label class="control-label">Porcentaje: </label>
		                      	<input type="text" class="form-control" id="txtPorcentajeS" placeholder="Ingrese Porcentaje">
		                    </div>
		                    
		                    <div class="col-sm-6 col-md-4">
		                    	<label class="control-label">Tiempo Estimado: </label>
		                      	<input type="text" class="form-control" id="txtTiempoestimadoS" placeholder="Ingrese el Tiempo estimado">
		                    </div>
		                
							<div class="col-sm-6 col-md-4">
		                    	<label class="control-label">Estatus:</label>
		                    	<select id="cmbEstatusS" class="form-control">
		                            <option value="1">Activo</option>
		                            <option value="0">Inactivo</option>
		                        </select>
		                    </div>
		                </div>
             		</div>  
		      </div>
		      <div class="modal-footer">
		        <button type="button" class="btn btn-sm btn-default" onclick="guardarSubetapaDesdeEtapa()">Aceptar</button>
		      </div>
		    </div>		
		  </div>
	</div>
	<!-- FIN MODAL PARA INCLUIR SUBETAPAS -->
   </article>