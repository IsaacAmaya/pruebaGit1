<%@ taglib tagdir="/WEB-INF/tags" prefix="t" %> 
<%
	String id = request.getParameter("id")==null ? "":request.getParameter("id").toString().trim();
	
%>
<style>
	.lista ul {
	    list-style-type: none;
	    margin: 0;
	    padding: 0;
	    width: 200px;
	    background-color: #f1f1f1;
	}
	.lista li {
		list-style:none;
	}
	.lista li a {
	    display: block;
	    color: #000;
	    padding: 8px 0 8px 16px;
	    text-decoration: none;
	}
	
	/* Change the link color on hover */
	.lista li a:hover {
	    background-color: #E0F8F7;
		cursor: pointer;
	}
	.activado {
	    background-color: #E0F8F7;
	    color: white;
	}
</style>
<script>
	var tablaListadoEtapa;
	var tablaListadoMaterial;
	$(function(){
		$('#vModalListadoEtapa').modal({
	  		show: false
	  	});
		
		$('#vModalListadoMaterial').modal({
	  		show: false
	  	});
	  	  
	  	$('#vModalListadoEtapa').on('show.bs.modal', function (e) {
	  		cargarListadoEtapa();
	  	});
	  	
	  	$("#mostrarModalMateriales").click(function(){
	  		if($("#iddetalleetapa").val()!=""){
	  			$('#vModalListadoMaterial').on('show.bs.modal', function (e) {
	  		  		cargarListadoMaterial();
	  		  	});
	  			$('#vModalListadoMaterial').modal('show');
	  		}
	  	});
	  	
	  $('#pestanaMateriales').click(function() {
			if($("#idtipoobra").val()==""){
				guardarTipoobra();
			}
		});
	  	validarBotones("tipoobra",$("#idUsuario").val(),"2");
	});
	
</script>
<script src="Archivos/js/modulo/formulario_tipoobra.js"></script>
<script>   	
    <% if(!id.equals("")) out.print("cargarTipoobra('"+id+"')");%>
</script>
<input type="hidden" value="<%=session.getAttribute("idusuario") %>" id="idUsuario">
<div>
	<a href="./tipoobra" class="tile-small text-shadow fg-white" style="background:#CE352C" data-role="tile">
                    <div class="tile-content iconic mif-ani-hover-shuttle">
                        <img class="icon" src="Archivos/images/iconmenu/TIPOSDEOBRA.png"></img>
                    </div>
                </a>
	<h3>Modulo de Tipos de Obra</h3>
	<p>Seccion Dedicada al Registro de Tipos de Obras</p>
</div>
   <article id="formulario">
      
      
      <t:panel titulo="Formulario de Registro de Tipos de Obra">
			<input type="hidden" id="idtipoobra" >
			<input type="hidden" id="iddetalleetapa" >
			<input type="hidden" id="idEtapaAux" >
			
            <ul class="nav nav-tabs">           
                <li class="active"><a data-toggle="tab" href="#form_tipoobra">Tipo De Obra</a></li>
                <li><a data-toggle="tab" href="#materialporobra" id="pestanaMateriales" onclick="cargarDetalleTipoobra()">Material por Obra </a></li>
           </ul>
           <!-- ##########################################################################################-->           
           <div class="tab-content"> <!-- INICIO DE ETIQUETA DE CONTENEDOR DE LAS DIVISIONES -->
           
           		<!-- COMIENZO DE LA PRIMERA DIVISION DE LA VISTA -->
           		<div id="form_tipoobra" class="tab-pane fade in active" >
           			<input type="hidden" id="idetapa" >           			
           					
           					
           			<div class="row">
	                    <div class="col-sm-3 col-md-3">
		                    <label class=" control-label"><span style="color:red; " title="Campo requerido">*</span> Nombre:</label>
		                    <input type="text" class="form-control" id="txtNombre" required="required" onblur="consultarTipoobra(this.value);" placeholder="Ingrese El Nombre del Tipo de Obra">
	                    </div>
	                              
	                	<div class="col-sm-9 col-md-9">
		                    <label class="control-label"><span style="color:red; " title="Campo requerido">*</span> Descripción: </label>
		                    <input type="text" class="form-control"  id="txtDescripcion" required="required" placeholder="Ingrese una Descripción del Tipo de Obra">
	                    </div>
	                    
	                    <!-- <div class=" col-sm-3 col-md-3">
	                    	<label class="control-label">Monto de Obra: </label>
	                      	<input type="text" class="form-control inputNumerico" id="txtMontoobra" required="required" placeholder="Ingrese el monto a invertir en la Obra">
	                    </div>
	                    
	                    <div class="col-sm-3 col-md-3">
	                    	<label class="control-label">Monto Mano de Obra: </label>
	                      	<input type="text" class="form-control inputNumerico" id="txtMontomanoobra" required="required" placeholder="Ingrese el Monto a invertir en Mano de Obra">
	                    </div> -->
	                   
	                    <div class="col-sm-6 col-md-3">
	                    <label class="control-label">Estado</label>
	                        <select id="cmbEstatus" class="form-control">
	                            <option value="1">Activo</option>
	                            <option value="0">Inactivo</option>	                              
	                        </select>
	                    </div>	                
	              	</div>		
		    	</div>
		    		 <!-- FIN DE LA PRIMERA DIVISION DE LA VISTA -->
	    		 <!-- ##########################################################################################-->
           				<!-- COMIENZO DE LA SEGUNDA DIVISION DE LA VISTA -->
		    <div id="materialporobra" class="tab-pane fade" >
			    <div class="row" >
                   	<div class="col-md-5" style="border-right:2px solid #ccc;">                   
	                    <button type="button" data-toggle="modal" data-target="#vModalListadoEtapa" class="btn btn-primary incluir" style="margin-top: 10px;" aria-hidden="true"><span class="glyphicon glyphicon-search"></span> Buscar Etapa</button>
		                <div class="panel-group" id="acordion" style="margin-top:15px;"></div><!-- CONTENEDOR DE LAS ETAPAS Y SUBETAPAS -->
                	</div>               		
               		
	               	<div class=" col-md-7" >
	               		<div class="row">
	               			<div class="col-md-8">
	               				<label class="control-label"><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Material: </label>
	               				<input type="text" id="mostrarModalMateriales" aria-hidden="true" class="form-control" readonly placeholder="Click para seleccionar material" style="cursor:pointer;" />
	               				<input id="idmaterial" type="hidden">
	               			</div>
	               			<div class="col-md-2">
	               				<label class="control-label" for="txtCantidad"><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Cantidad: </label>
	               				<input type="text" class="form-control soloNumero" id="txtCantidad" />
	               			</div>
	               			<div class="col-md-2">
	               				<button class="btn btn-sm btn-primary incluir" style="margin-top:28px;" onclick="guardarMaterialporobra();"><span class='glyphicon glyphicon-plus'></span></button>
	               			</div>
	               		</div>
		               	<div class="row" style="margin-top:5px;">
		               		<div style="padding:14px;"><!-- CONTENEDOR PARA LOS MATERIALES -->
		               			<table class="table table-condensed" id="listadoMaterialActivos" class="display"  width="100%" >
		      						<thead>
		      							<tr>
											<th>Nombre del material</th>
											<th>Cantidad</th>
											<th>Opción</th>
										</tr>
								    </thead>
								   	<tbody style="font-size:16px;"></tbody>
		      					</table>
		               		</div>
		               	</div >	               		
	               	</div>
               </div>	                
	      	</div>
	      			     			
      		</div>
             <div class="row">
                <div class="col-md-12">
	                <div class="form-group" style="text-align: center; ">
						<div style="margin-top: 30px;">
				    		<t:btnBotonera accionguardar="guardarTipoobra();" accioncancelar="window.location.href = './tipoobra';" accionlimpiar="window.location.href = './addTipoobra';"></t:btnBotonera>		     
				        </div>
	                </div>
                </div>                
      		 </div>
     </t:panel>    
     
    <!-- VENTANA MODAL LISTADO DE LAS SUB-ETAPAS -->
    <div id="vModalListadoEtapa" class="modal fade" role="dialog">
		  <div class="modal-dialog">
		    <!-- Modal content-->
		    <div class="modal-content">
		      <div class="modal-header">
		        <button type="button" class="close" data-dismiss="modal">&times;</button>
		        <h6 class="modal-title">ETAPAS</h6>
		       </div>
		      <div class="modal-body">
		        	<table id="ListadoEtapa" class="display"  width="100%">
						<thead>
							<tr>
						    	<th>idetapa</th>						                
						        <th>Nombre</th>
						        <th>Descripción</th>						                            
						        <th>Seleccionar</th>
						    </tr>
						</thead>
					</table>
		      </div>
		      <div class="modal-footer">
		      	<button type="button" onclick="incluirSeleccionadosEtapa();" class="btn btn-sm btn-default" data-dismiss="modal">Aceptar</button>
		      </div>
		    </div>		
		  </div>
	</div>
	<!-- ############################################################################################################## -->
	<!-- MODAL LISTADO MATERIALES -->
	<div id="vModalListadoMaterial" class="modal fade" role="dialog">
		  <div class="modal-dialog">
		    <!-- Modal content-->
		    <div class="modal-content">
		      <div class="modal-header">
		        <button type="button" class="close" data-dismiss="modal">&times;</button>
		        <h6 class="modal-title">MATERIALES</h6>
		       </div>
		      <div class="modal-body">
		        	<table id="ListadoMaterial" class="display tablamodal"  width="100%">
						<thead>
							<tr>
						    	<th>idmaterial</th>
						        <th>Nombre</th>
						        <th>Descripción</th>
						    </tr>
						</thead>
						 <tbody> 
		            
		        		</tbody>
					</table>
		     </div>
		     <div class="modal-footer">
		      	<button type="button"  class="btn btn-sm btn-default" data-dismiss="modal">Aceptar</button>
		      </div>
		    </div>		
		  </div>
	</div>
	<!--FIN VENTANA MODAL LISTADO DE LAS SUB-ETAPAS -->
   </article>  
   
   