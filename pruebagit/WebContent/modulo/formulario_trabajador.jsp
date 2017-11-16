<%@page import="java.sql.ResultSet"%>
<%@page import="com.opensymphony.xwork2.Result"%>
<%@ taglib tagdir="/WEB-INF/tags" prefix="t" %> 
<%
	String id = request.getParameter("id")==null ? "":request.getParameter("id").toString().trim();
	
	

%>

<script src="Archivos/js/modulo/formulario_trabajador.js"></script>

<script>
	var tablaListadoPersona;
	$( function() {
		//alert($("#idcargoAux").val());
		$('.nav-tabs a[href="#trabajador"]').on('shown.bs.tab', function(event){
			cargarCargos('');
		});
		
		$("#agregarCargo").click(function(e){
    		if($("#btnCargo").val() == "0"){
    			$("#btnCargo").val("1");
    			$("#idcargo").hide(500);
        		$("#txtCargoAux").css("display","inline").focus();
        		$("#txtCargoAux").attr("required", true);
        		$("#idcargo").removeAttr("required");
        		$("#idcargoAux").val("");
    		}else{
    			agregarCargo();
    			$("#btnCargo").val("0");
    			$("#idcargo").show(500);
        		$("#txtCargoAux").css("display","none");
        		$("#idcargo").attr("required", true);
        		$("#txtCargoAux").removeAttr("required");
    		}
    	});
		
		$( ".fec" ).datepicker({
			dateFormat: 'dd/mm/yy',
			changeMonth: true,
			changeYear: true,
			yearRange: "c-40:c+2",
	      	showOtherMonths: true,
			selectOtherMonths: true,
	  		showAnim: "clip"
	   
	    });
    	
    	$('#vModalListadoPersona').modal({
			show: false
	   	});
	   	  
	   	$('#vModalListadoPersona').on('show.bs.modal', function (e) {
	   		cargarListadoPersona();
	   	});
	   		   	
    	<% if(!id.equals("")) out.print("cargarTrabajador('"+id+"')");%>	
	} );
</script>

<div>
      	<a href="./trabajador" class="tile-small text-shadow fg-white" style="background:#CE352C" data-role="tile">
                    <div class="tile-content iconic mif-ani-hover-bounce">
                        <img class="icon" src="Archivos/images/iconmenu/TRABAJADOR.png"></img>
                    </div>
                </a>
      	<h3>Modulo de Trabajadores</h3>
  		<p>Listado de Trabajadores Actuales </p>
  		
  		</div>
   
   <article id="formulario">
      
      
      <t:panel titulo="Formulario de Registro de Trabajador">
      	<input type="hidden" id="idtrabajador" >
        <input type="hidden" id="idpersona" >
        <input type="hidden" id="idcargoAux" >
        <input type="hidden" id="btnCargo" value="0">
			<ul class="nav nav-tabs">           
                <li class="active"><a data-toggle="tab" href="#form_persona">Datos personales</a></li>
                <li><a data-toggle="tab" href="#trabajador" onclick="pasarDatos()" >Trabajador</a></li>
                <li><a data-toggle="tab" href=".datos_banco">Datos Bancarios</a></li>
           	</ul>
           	<div class="tab-content">
           		<div id="form_persona" class="tab-pane fade in active" >
           			<div class="row">
           				<div class="col-sm-12 col-md-12">
		                	<button type="button" class="btn btn-primary" id="btnBuscar" data-toggle="modal" data-target="#vModalListadoPersona" style="margin: 5px 0 5px 0;" aria-hidden="true"><span class="glyphicon glyphicon-search"></span> Buscar</button>
		                </div>
           			</div>
           			<div class="row">           				
	                    <div class="col-sm-6 col-md-4">
		                    <label class=" control-label"><span style="color:red;font-weight:bold; " title="Campo requerido">*</span> Cedula:</label>
		                    <input type="text" class="form-control soloNumero" required="required" id="txtCedulaT" onblur="consutarDesdeCedula(this.value)" placeholder="Ingrese Numero de Cedula">
	                    </div>
	                    <div class="col-sm-6 col-md-4">
	                    	<label class="control-label"><span style="color:red;font-weight:bold; " title="Campo requerido">*</span> Nombre: </label>
	                      	<input type="text" class="form-control" maxlength="200" required="required" id="txtNombreT" placeholder="Ingrese Nombre">
	                    </div>
	                    <div class="col-sm-6 col-md-4">
		                    <label class="control-label"><span style="color:red;font-weight:bold; " title="Campo requerido">*</span> Apellido: </label>
		                    <input type="text" class="form-control" required="required" id="txtApellidoT" placeholder="Ingrese Apellido">
	                    </div>
	                	<div class="col-sm-6 col-md-4">
		                    <label class="control-label">Fecha Nacimiento</label>
		                    <input type="text" class="form-control fec "  id="txtFechanacimientoT" placeholder="Seleccione Fecha de Nacimiento">
	                    </div>
	                    <div class="col-sm-6 col-md-4">
	                    <label class="control-label"><span style="color:red;font-weight:bold; " title="Campo requerido">*</span> Género</label>
	                        <select id="cmbGeneroT" class="form-control" data-placeholder = "Seleccione el género">
	                            <option value=".">Seleccione</option>
	                            <option value="1">Masculino</option>
	                            <option value="2">Femenino</option>
	                              
	                        </select>
	                    </div>
	                    <div class="col-sm-6 col-md-4">
	                    <label class="control-label">Estado Civil</label>
	                        <select id="cmbEstadocivilT" class="form-control" data-placeholder="Seleccione el estado civil">
	                            <option value="0">Seleccione</option>
	                            <option value="1">Soltero</option>
	                            <option value="2">Casado</option>
	                            <option value="3">Divorciado</option>
	                            <option value="4">Viudo</option>	                              
	                        </select>
	                    </div>
	                    <div class="col-sm-6 col-md-4">
		                    <label class="control-label">Teléfono Móvil.</label>
		                    <input type="text" class="form-control soloNumero" id="txtTelefonomovilT" placeholder="Ingrese Teléfono Móvil">
	                    </div>
	                    <div class="col-sm-6 col-md-4">
		                    <label class="control-label">Teléfono Habitación:</label>
		                    <input type="text" class="form-control soloNumero" id="txtTelefonohabitacionT" placeholder="Ingrese Teléfono Habitación">
	                    </div>
	                	<div class="col-sm-6 col-md-4">
		                    <label class="control-label">Email:</label>
		                    <input type="text" class="form-control" id="txtEmailT" placeholder="Ingrese Correo Electronico">
	                    </div>
	                    <div class="col-sm-12 col-md-8">
		                    <label class="control-label"><span style="color:red;font-weight:bold; " title="Campo requerido">*</span> Dirección:</label>
		                    <input type="text" class="form-control" required="required" id="txtDireccionT" placeholder="Ingrese Direccion Actual">
	                    </div>                     
	                	<div class="col-sm-6 col-md-4">
	                    	<label class="control-label">Estado</label>
	                        <select id="cmbEstatusT" class="form-control" data-placeholder="null">
	                            <option value="1">Activo</option>
	                            <option value="0">Inactivo</option>	                              
	                        </select>
	                    </div>                
              		</div>
		    	</div>
	    		
		    	<div id="trabajador" class="tab-pane fade">
			    	<div class="row">
                
                		<div class="col-sm-6 col-md-4">
		                    <label class=" control-label">Cedula:</label>
		                    <input type="text" class="form-control" id="txtCedulaAuxiliar" readonly>
	                    </div>
	                    <div class="col-sm-6 col-md-4">
	                    	<label class="control-label">Nombre: </label>
	                      	<input type="text" class="form-control" maxlength="200" id="txtNombreAuxiliar" readonly>
	                    </div>
	                    <div class="col-sm-6 col-md-4">
		                    <label class="control-label">Apellido: </label>
		                    <input type="text" class="form-control" id="txtApellidoAuxiliar" readonly>
	                    </div>
	                    <hr>
	                    
	                	<div class="col-xs-6 col-sm-3 col-md-3">
		                    <label class=" control-label"><span style="color:red;font-weight:bold; " title="Campo requerido">*</span> Cargo:&nbsp;&nbsp; <button class="btn btn-default btn-xs" id="agregarCargo" title="Agregar nuevo cargo"><span class="glyphicon glyphicon-plus"></span></button> </label>
		                    <select class="form-control" id="idcargo" required="required" ></select>
		                    <input type="text" id="txtCargoAux" class="form-control" style="display:none;" >
	                    </div>
	                    
	                    <div class="col-xs-6 col-sm-3 col-md-3">
	                    	<label class=" control-label">Apodo: </label>
	                    	<input type="text" class="form-control" id="txtApodo" placeholder="Ingrese El Apodo">
	                    </div>
	                    
	                    
	                    <div class="col-xs-6 col-sm-3 col-md-3">
	                    	<label class="control-label">Pantalon: </label>
	                    	<input type="text" class="form-control" id="txtPantalon"  placeholder="Ingrese Talla Pantalon">
	                    </div>
	                
	                    
	                    <div class="col-xs-6 col-sm-3 col-md-3">
	                    	<label class="control-label">Camisa: </label>
	                    	<input type="text" class="form-control" id="txtCamisa" placeholder="Ingrese Talla Camisa">
	                    </div>
	                
	                	<div class="col-xs-6 col-sm-3 col-md-3">
	                    	<label class="control-label">Botas: </label>
	                    	<input type="text" class="form-control"  id="txtBotas" placeholder="Ingrese Talla de Botas">
	                    </div>
	                
	                    <div class="col-xs-6 col-sm-3 col-md-3">
	                    	<label class="control-label">Tipo de Sangre </label>
	                        <input type="text" class="form-control"  id="txtTiposangre" placeholder="Ingrese Tipo de Sangre">
	                    </div>
	                    <!-- 
	                    <div class="col-xs-6 col-sm-3 col-md-3">
	                   		<label class="control-label">Lumbosacra</label>
	                        <input type="text" class="form-control"  id="txtLumbosacra" required="required" placeholder="¿Lumbosacra?">
	                    </div>
	                           -->           
	                    <div class="col-xs-6 col-sm-3 col-md-3">
	                    	<label class="control-label"><span style="color:red;font-weight:bold; " title="Campo requerido">*</span> Fecha Ingreso.</label>
	                    	<input type="text" class="form-control fec" id="txtFechaingreso" required="required" placeholder="Seleccione Fecha de Ingreso">
	                    </div>
	                    
		                <div class="col-xs-6 col-sm-3 col-md-3">
		                	<label class="control-label">Hijos:</label>
		                	<input type="text" class="form-control" id="txtCantidadhijo" placeholder="Ingrese Cantidad de Hijos">
		                </div>
	                                      
		                <div class="col-xs-6 col-sm-3 col-md-3">
			                <label class="control-label">Estado</label>
			                <select id="cmbEstatus" class="form-control">
			                <option value="1">Activo</option>
			                <option value="0">Inactivo</option>                              
			                </select>
		                </div>
                
               		</div> 
	      		</div>
	      		
	      		<div id="trabajador" class="tab-pane fade datos_banco">
			    	<br>
			    	<div class="row">
                		
                		                    
	                	<div class="col-xs-6 col-sm-3 col-md-3">
		                    <label class=" control-label">Cedula Titular </label>
		                    <input type="text" class="form-control" id="txtCedulatitular"  placeholder="Ingrese Cedula del Titular">
	                    </div>
	                    
	                    <div class="col-xs-6 col-sm-3 col-md-3">
	                    	<label class=" control-label">Nombre Titular </label>
	                    	<input type="text" class="form-control" id="txtNombretitular"  placeholder="Ingrese El Nombre del Titular">
	                    </div>
	                    
	                    
	                    <div class="col-xs-6 col-sm-3 col-md-3">
	                    	<label class="control-label">Banco </label>
	                    	<input type="text" class="form-control" id="txtBanco"  placeholder="Ingrese El Nombre del Banco">
	                    </div>
	                
	                    
	                    <div class="col-xs-6 col-sm-3 col-md-3">
	                    	<label class="control-label">Tipo de Cuenta </label>
	                    	<input type="text" class="form-control" id="txtTipocuenta"  placeholder="Ingrese Tipo de Cuenta">
	                    </div>
	                
	                	<div class="col-xs-6 col-sm-3 col-md-3">
	                    	<label class="control-label">Numero de Cuenta </label>
	                    	<input type="text" class="form-control"  id="txtNumerocuenta"  placeholder="Ingrese El Numero de Cuenta">
	                    </div>
	                                         
               		</div> 
	      		</div>
	      		
      		</div>
            
            
           
			<div class="row">
				<div class="col-md-12">
					<div class="form-group" style="text-align: center; ">
						<div style="margin-top: 30px;">
							<t:btnBotonera accionguardar="guardarTrabajador();" accioncancelar="window.location.href = './trabajador';" accionlimpiar="window.location.href = './addTrabajador';"></t:btnBotonera>
						</div>
					</div>
				</div>
			</div>
     </t:panel>  
    
   </article>  
   
   <!-- Modal -->
<div class="modal fade" id="vModalListadoPersona" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">Seleccionar Persona</h4>
      </div>
      <div class="modal-body">
        	<table id="ListadoPersona" class="display tablamodal"  width="100%">
		        <thead>
		            <tr>
		            	<th>idpersona</th>
		                <th>Cedula</th>
		                <th>Nombre</th>
		                <th>Apellido</th>
		                <th>Teléfonos</th>
		            </tr>
		        </thead>
		        <tfoot>
		            <tr>
		            	<th>idpersona</th>
		                <th>Cedula</th>
		                <th>Nombre</th>
		                <th>Apellido</th>
		                <th>Teléfonos</th>
		            </tr>
		        </tfoot>
		        <tbody> 
		            
		        </tbody>
		    </table>
      </div>
    </div>
  </div>
</div>