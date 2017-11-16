<%@ taglib tagdir="/WEB-INF/tags" prefix="t" %>
<%
	String id = request.getParameter("id")==null ? "":request.getParameter("id").toString().trim();
	String idcuadrilla = request.getParameter("idcuadrilla")==null ? "":request.getParameter("idcuadrilla").toString().trim();
	String fechaDesde = request.getParameter("fechaDesde")==null ? "":request.getParameter("fechaDesde").toString().trim();
	String fechaHasta = request.getParameter("fechaHasta")==null ? "":request.getParameter("fechaHasta").toString().trim();
	String formSecundario = request.getParameter("formSecundario")==null ? "":request.getParameter("formSecundario").toString().trim();
%>
<style type="text/css">
	.error{
		color: red;
		font-weight: bold;
	}
	.labelForm{font-weight:bold;}
</style>
<script src="Archivos/js/modulo/formulario_pago.js"></script>
<script>
	
	var tablaListadoCuadrilla;
  	$( function() {
    	$( ".fec" ).datepicker({
    		dateFormat: 'dd/mm/yy'
        });
    	
    	Date.prototype.toString = function() { return this.getDate()+"/"+(this.getMonth()+1)+"/"+this.getFullYear(); }
    	var miFecha = new Date();
    	$("#txtFechaSistema").val(miFecha);
    	
    	<%
    		if(!id.equals("") && !formSecundario.equals("")) {
    			out.print("generarPago('"+id+"');");
    		}
    	
	    	if(!id.equals("") && formSecundario == "") {
				out.print("soloConsultar('"+id+"');");//LLAMAR LAS OTRAS DOS FUNCIONES
			}
    			
    		if(!idcuadrilla.equals("") && !fechaDesde.equals("") && !fechaHasta.equals("")){
    			out.print("cargarConsultaPorRango('"+idcuadrilla+"','"+fechaDesde+"','"+fechaHasta+"');");
    		}
    	%>   	
    	
    	$('#vModalListadoCuadrilla').on('show.bs.modal', function (e) {
    		cargarListadoCuadrilla();
	  	});
    	
    	$('#vModalPago').on('hide.bs.modal', function (e) {
    		$("#idtrabajadorcuadrilla").val("");
    		$("#txtTrabajador").val("");
    		$("#txtObservacion").val("").removeAttr("disabled");
    		$("#txtMontoCancelar").val("");
    		$("#txtNrocheque").val("");
    		$("#rowTransferencia").hide();
    		$("#rowCheque").hide();
    		$('select[id=txtModoPago]').val('0').removeAttr("disabled");
    		$("#btnGuardarPagoTrabajador").removeAttr("disabled");
    		$("#txtBancocheque").val("");
    		$("#txtCedulatitularcheque").val("");
    		$("#txtNombretitularcheque").val("");
    		$('#txtNroreferencia').removeAttr("disabled");
			$('#txtMontoCancelar').removeAttr("disabled");
			$('#txtNrocheque').removeAttr("disabled");
	  	});
    	
    	$("#seleccionarTodo").click(function(){
    		var cont = 0;
    		$('#ListadoInspeccionCheck input[type=checkbox]').each(function() {
    			cont++;
        		$(this).prop('checked', true);
        		var idTr = $(this).attr("id");
        		calcularPorcentaje($("#porcentaje"+cont).text(),cont);
    	    });
    	});   
    	validarBotones("pago",$("#idUsuario").val(),"2");
  	});
  	
</script>
<input type="hidden" value="<%=session.getAttribute("idusuario") %>" id="idUsuario">
	<div>
		<a href="./pago" class="tile-small text-shadow fg-white" style="background:#FA1100"  data-role="tile">
			<div class="tile-content iconic mif-ani-hover-shuttle">
				<img class="icon" src="Archivos/images/iconmenu/ASIGDEPAGO.png">
			</div>
		</a>
		<h3>Modulo de Pagos</h3>
	  	<p>Seccion Dedicada a la realizacion de pagos</p>
  	</div>
  
   <article id="formulario">
		<input id="idcuadrilla" type="hidden">
      <t:panel titulo="Formulario de Pagos">
      <input id="idpago" type="hidden">
		<div id="panelPrincipal" hidden="hidden">
           <ul class="nav nav-tabs">
           
                <li class="active"><a data-toggle="tab" href="#form_pago">Selección de Inspecciones</a></li>
                <li><a data-toggle="tab" href="#detalle_pago" onclick="cargarSeleccion();">Generar Pago</a></li>
           </ul><br>
                <div class="tab-content">
                	<input type="hidden" id="txtFechaSistema" class="fec">
                	
                	<div class="alert" style="background:#F2F2F2;">
		                <div class="row" >
						    <div class="col-md-6">
							    <label>Cuadrilla: </label>
							    <input id="txtNombrecuadrillaAlert" class="form-control" readonly>
						    </div>
						    <div class="col-md-6">
							    <label>Rango de fechas: </label>
							    <input type="text" id="txtRangofechas" class="form-control" readonly>
						    </div>					        		
					    </div>
				    </div>
                    <div id="form_pago" class="tab-pane fade in active" >
	                   <div class="row">
	                   		<div class="col-md-12">
	                   			<table class="table table-hover" id="ListadoInspeccionCheck">
	                   				<thead>
	                   					<tr>
	                   						<th>Obra</th><th>Etapa</th><th>Subetapa</th><th>Costo Total Subetapa</th><th>Porcentaje Inspección</th><th><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Monto a pagar</th><th><a id="seleccionarTodo" title="Seleccionar Todo">Seleccionar</a></th>
	                   					</tr>
	                   				</thead>
	                   				<tbody></tbody>
	                   			</table>
	                   		</div>
	                   </div>
	                   <div class="row">
	           				<div class="col-md-12">
	           					<center>
	           						<a href="./pago" class="btn btn-danger" style="text-decoration:none;color:#FFF;" role="button"> <span class="glyphicon glyphicon-remove"></span> CANCELAR</a>
	           					</center>
	           				</div>
	           			</div>
                    </div>                  
                    <div id="detalle_pago" class="tab-pane fade">
                    	<div class="row">
                    		<div class="col-md-12">
                    			<table class="table table-hover" id="ListadoInspeccionSeleccionados">
                    				<thead>
	                   					<tr>
	                   						<th>Obra</th><th>Etapa</th><th>Subetapa</th><th>Monto a pagar</th>
	                   					</tr>
	                   				</thead>
	                   				<tbody></tbody>
                    			</table>
                    			
                    			<table id="ListadoTrabajadores" hidden="hidden">
                    				<thead>
	                   					<tr>
	                   						<th>Trabajador</th>
	                   					</tr>
	                   				</thead>
	                   				<tbody></tbody>
                    			</table>
                    		</div>
                    	</div>
                    	<div class="row">
                    		<div class="col-md-6">
                    			<label>Monto Total a Pagar:</label>
                    			<u><span id="MontoTotal" style="font-size:16px;font-weight:bold;">0,00</span></u>
                    		</div>
                    	</div>
                    	<div class="row">
	           				<div class="col-md-12">
	           					<center>
	           						<button type="button" class="btn btn-success" onclick="guardarPagoGenerado();"><span class="glyphicon glyphicon-ok"></span> Generar Pago</button>
	           						<a href="./pago" class="btn btn-danger" style="text-decoration:none;color:#FFF;" role="button"> <span class="glyphicon glyphicon-remove"></span> CANCELAR</a>
	           					</center>
	           				</div>
	           			</div>
           			</div>
           			
      		 	</div>
      	</div>
      	
      	<div id="panelSecundario" hidden="hidden">
      		<div class="row">
      			<div class="col-md-7" >
      				<div class="row">
      					<div class="col-md-12">
      						<table class="table table-condensed" id="ListadoTrabajadorCuadrilla">
      							<thead>
      								<th>Trabajador</th><th>Monto Pago</th><th>Modo</th><th>Referencia</th><th>Opción</th>
      							</thead>
      							<tbody></tbody>
      						</table>
      					</div>      					
      				</div>
      				<br><br>
      				<div class="row">
      					<div class="col-md-6">
      						
      					</div>
      					<div class="col-md-6">
      						<div style="float:right;">
      							<div class="row">
      								<div class="col-md-6">
      									<label>Monto:</label>
      									<input type="text" class="form-control" disabled="disabled" id="montoAcumulativo">
      								</div>
      								<div class="col-md-6">
      									<label>Monto Total:</label>
      									<input type="text" class="form-control" disabled="disabled" id="montoReferencial">
      								</div>
      							</div>
      						</div>
      					</div>
      				</div>
      			</div>
      			<div class="col-md-5" style="border-left:3px solid #CCC;">
      				<div class="row">
      					<div class="col-md-12">
      						<label>Proyecto: </label>
      						<input type="text" class="form-control" id="txtProyecto" readonly>
      					</div>
      					<div class="col-md-12">
      						<label>Cuadrilla: </label>
      						<input type="text" class="form-control" id="txtNombrecuadrilla" readonly>
      					</div>
      					
      				</div>
      				<div class="row">
      					<div class="col-md-12">
      						<label>Detalle de Pago: </label>
      						<div style="max-height:250px;overflow:auto;">
      							<table class="table table-condensed" id="tablaDetallePago">
	      							<thead>
	      								<th>Obra</th><th>Etapa</th><th>Subetapa</th>
	      							</thead>
	      							<tbody></tbody>
	      						</table>
      						
      						</div>
      						
      					</div>
      				</div>
      				
      			</div>
      		</div>
      		<hr>
      		<div class="row">
		        <div class="col-md-12">
		        	<center>
		        		<button type="button" class="btn btn-success incluir" disabled="disabled" id="btnProcesarPago" onclick="procesarPago();"><span class="glyphicon glyphicon-ok" ></span> Procesar</button>
		        		<a href="./pago" class="btn btn-danger" style="text-decoration:none;color:#FFF;" role="button"> <span class="glyphicon glyphicon-remove"></span> CANCELAR</a>
			        </center>
		        </div>
	        </div>
      	</div>
      	<div id="panel3" hidden="hidden">
      		<div class="row">
				<div class="col-md-12">
					<h5>Datos del Pago</h5><hr>				
				</div>
				<div class="col-md-2">
					<label class="labelForm">Nro de pago:</label><br>
					<span id="spanNropago"></span>
					
				</div>
				<div class="col-md-2">
					<label class="labelForm">Fecha procesado:</label><br>
					<span id="spanFechaprocesado"></span>
					
				</div>
				<div class="col-md-4">
					<label class="labelForm">Proyecto:</label><br>
					<span id="spanProyecto"></span>
				</div>
				<div class="col-md-4">
					<label class="labelForm">Cuadrilla:</label><br>
					<span id="spanCuadrilla"></span>
				</div>
				<div class="col-md-4">
					<label class="labelForm">Jefe de Cuadrilla:</label><br>
					<span id="spanJefecuadrilla"></span>
				</div>
				<div class="col-md-2">
					<label class="labelForm">Monto total cancelado:</label><br>
					<span id="spanMonto" style="font-size:16px;font-weight:normal;"></span>					
				</div>
			</div>
			
			<div class="row">
				<div class="col-md-12">
					<h5>Listado de Inspecciones</h5><hr>				
				</div>
				<div class="col-md-12">
					<table class="table table-condensed" id="ListadoDetalleInspeccion">
						<thead>
							<tr>
								<th>Obra</th><th>Etapa</th><th>Subetapa</th><th>Porcentaje de la inspección</th><th>Monto cancelado</th>
							</tr>
						</thead>
						<tbody></tbody>
					</table>
					
				</div>
				
			</div>
			
			<div class="row">
				<div class="col-md-12">
					<h5>Listado de Trabajadores que conforman la cuadrilla</h5><hr>				
				</div>
				<div class="col-md-12">
					<table class="table table-condensed" id="ListadoDetalleCuadrilla">
						<thead>
							<tr>
								<th>Trabajador</th><th>Monto del pago</th><th>Modo de pago</th><th>Banco</th><th>Titular de la cuenta</th><th>Numero de referencia</th>
							</tr>
						</thead>
						<tbody></tbody>
					</table>
					
				</div>
				
			</div>
      		<div class="row">
		        <div class="col-md-12">
		        	<center>
		        		<a href="./pago" class="btn btn-danger" style="text-decoration:none;color:#FFF;" role="button"> <span class="glyphicon glyphicon-remove"></span> CANCELAR</a>
			        </center>
		        </div>
	        </div>
      	</div>
    	 
     </t:panel>
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
	<!-- MODAL PAGO -->
		<div class="modal fade" id="vModalPago" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
		  <div class="modal-dialog" role="document">
		    <div class="modal-content">
		      <div class="modal-header">
		        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
		        <h6 class="modal-title" id="myModalLabel">Pago por Trabajador</h6>
		      </div>
		      <div class="modal-body">
		        	<div class="row">
		        		<div class="col-md-6">
		        			<label><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Trabajador:</label>
		        			<input type="text" id="txtTrabajador" class="form-control" disabled="disabled">
		        			<input type="hidden" id="idtrabajadorcuadrilla">
		        		</div>
		        		<div class="col-md-3">
		        			<label><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Monto a Cancelar:</label>
		        			<input type="text" id="txtMontoCancelar" class="form-control inputNumerico">
		        		</div>
		        		<div class="col-md-3">
		        			<label><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Modo de Pago:</label>
		        			<select class="form-control" id="txtModoPago" onchange="seleccionarModoPago();">
		        				<option value="0">Seleccione</option>
		        				<option value="1">Efectivo</option>
		        				<option value="2">Transferencia</option>
		        				<option value="3">Cheque</option>
		        			</select>
		        		</div><br>
		        		<div class="col-md-12" >
		        			<label>Observación:</label>
		        			<textarea id="txtObservacion" class="form-control" rows="" cols=""></textarea>
		        		</div>
		        	</div>
		        	<br>
		        	<div style="border-bottom:3px solid #CCC;"></div>
		        	<br>
		        	<div class="row" id="rowTransferencia" hidden="hidden">
		        		
		        		<div class="col-md-6">
		        			<label>Banco:</label>
		        			<input type="text" id="txtBanco" class="form-control" disabled="disabled">
		        		</div>
		        		<div class="col-md-6">
		        			<label>Titular Cuenta:</label>
		        			<input type="text" id="txtTitularcuenta" class="form-control" disabled="disabled">
		        			<input type="hidden" id="txtNombreTitularAux">
		        			<input type="hidden" id="txtCedulaTitularAux">
		        		</div>
		        		<div class="col-md-6">
		        			<label>Numero de Cuenta:</label>
		        			<input type="text" id="txtNrocuenta" class="form-control" disabled="disabled">
		        		</div>		        		
		        		<div class="col-md-6">
		        			<label><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Numero de Referencia:</label>
		        			<input type="text" id="txtNroreferencia" class="form-control soloNumero">
		        		</div>
		        	</div>
		        	
		        	<div class="row" id="rowCheque" hidden="hidden">
		        		
		        		<div class="col-md-6">
		        			<label><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Banco:</label>
		        			<input type="text" id="txtBancocheque" class="form-control">
		        		</div>
		        		<div class="col-md-6">
		        			<label><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Cedula Titular:</label>
		        			<input type="text" id="txtCedulatitularcheque" class="form-control soloNumero">
		        		</div>
		        		<div class="col-md-6">
		        			<label><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Nombre Titular:</label>
		        			<input type="text" id="txtNombretitularcheque" class="form-control">
		        		</div>
		        				        		
		        		<div class="col-md-6">
		        			<label><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Numero de Cheque:</label>
		        			<input type="text" id="txtNrocheque" class="form-control soloNumero">
		        		</div>
		        	</div>
		      </div>
		      <div class="modal-footer">
		        	<button class="btn btn-success" onclick="guardarPagoTrabajador();" id="btnGuardarPagoTrabajador"><span class="glyphicon glyphicon-ok"></span> Procesar</button>
		        	<!-- <button class="btn btn-danger"><span class="glyphicon glyphicon-remove"></span> cancelar</button> -->
		      </div>
		    </div>
		  </div>
		</div>
	<!-- FIN MODAL PAGO -->
   </article>