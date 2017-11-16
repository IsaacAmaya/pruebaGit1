<%@ taglib tagdir="/WEB-INF/tags" prefix="t" %> 
<%
	String id = request.getParameter("id")==null ? "":request.getParameter("id").toString().trim();
	
%>

<script src="Archivos/js/modulo/formulario_persona.js"></script>
<script>
$( function() {
	  $( ".fec" ).datepicker({
		dateFormat: 'dd/mm/yy',
		changeMonth: true,
		changeYear: true,
		yearRange: "c-40:c+2",
      	showOtherMonths: true,
		selectOtherMonths: true,
  		showAnim: "clip"
   
    });
    	<% if(!id.equals("")) out.print("cargarPersona('"+id+"')");%>
  } );
  
  
</script>

	             
<div>



      <a href="./persona" class="tile-small text-shadow  fg-white " style="background:#666633" data-role="tile">
                    <div class="tile-content iconic mif-ani-hover-bounce">
                         <img class="icon" src="Archivos/images/iconmenu/PERSONA.png"></img>
                    </div>
                </a>	
                  
                <h3 id="pruebaover">Modulo de Personas</h3>
  		<p>Listado de Personas Actuales </p>
  	
  		</div>
   
   <article id="formulario">
      
      
      <t:panel titulo="Formulario de Registro Persona">
			<input type="hidden" id="idpersona" >
    		
             <div class="row">
                      
                    <div class="col-sm-6 col-md-4">
                    <label class=" control-label"><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Cedula:</label>
                    <input type="text" class="form-control soloNumero" required="required" id="txtCedula" onblur="consultarCedula(this.value);" placeholder="Ingrese Numero de Cedula">
                    </div>
                    
                    
                    <div class="col-sm-6 col-md-4">
                    <label class="control-label"><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Nombre: </label>
                      <input type="text" class="form-control" maxlength="200" required="required" id="txtNombre" placeholder="Ingrese Nombre">
                    </div>
                
                    
                    <div class="col-sm-6 col-md-4">
                    <label class="control-label"><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Apellido: </label>
                      <input type="text" class="form-control" required="required" id="txtApellido" placeholder="Ingrese Apellido">
                    </div>
                
                	<div class="col-sm-6 col-md-4">
                    <label class="control-label"><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Fecha Nacimiento</label>
                    <input type="text" class="form-control fec " required="required" readonly="readonly"  id="txtFechanacimiento" placeholder="Seleccione Fecha de Nacimiento">
                    </div>
                
                    <div class="col-sm-6 col-md-4">
                    <label class="control-label"><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Género</label>
                        <select id="cmbGenero" class="form-control" data-placeholder = "Seleccione el género">
                            <option value=".">Seleccione</option>
                            <option value="1">Masculino</option>
                            <option value="2">Femenino</option>
                              
                        </select>
                    </div>
                    <div class="col-sm-6 col-md-4">
                    <label class="control-label">Estado Civil</label>
                        <select id="cmbEstadocivil" class="form-control" data-placeholder = "Seleccione el estado civil">
                            <option value=".">Seleccione</option>
                            <option value="1">Soltero</option>
                            <option value="2">Casado</option>
                            <option value="3">Divorciado</option>
                            <option value="4">Viudo</option>
                              
                        </select>
                    </div>
                    
                                      
                    <div class="col-sm-6 col-md-4">
                    <label class="control-label">Teléfono Móvil.</label>
                    <input type="text" class="form-control soloNumero" id="txtTelefonomovil" placeholder="Ingrese Teléfono Móvil">
                    </div>
                    
                    <div class="col-sm-6 col-md-4">
                    <label class="control-label">Teléfono Habitación:</label>
                    <input type="text" class="form-control soloNumero" id="txtTelefonohabitacion" placeholder="Ingrese Teléfono Habitación">
                    </div>
               
                <div class="col-sm-6 col-md-4">
                    <label class="control-label">Email:</label>
                    <input type="email" class="form-control " id="txtEmail" placeholder="Ingrese Correo Electronico">
                    </div>
					
					
                    <div class="col-sm-12 col-md-8">
                    <label class="control-label"><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Dirección:</label>
                    <input type="text" class="form-control" required="required" id="txtDireccion" placeholder="Ingrese Direccion Actual">
                    </div>
               
                                                
                <div class="col-sm-6 col-md-4">
                    <label class="control-label">Estado</label>
                        <select id="cmbEstatus" class="form-control" data-placeholder="null">
                           <option value="1">Activo</option>
	                       <option value="0">Inactivo</option>
                              
                        </select>
                    </div>
                
               </div> 
           
             <div class="row">
                	<div class="col-md-12">
                		 <div class="form-group" style="text-align: center; ">
						    <div style="margin-top: 30px;">
						     <t:btnBotonera accionguardar="guardarPersona();" accioncancelar="window.location.href = './persona';" accionlimpiar="window.location.href = './addPersona';"></t:btnBotonera>
		     
		        		</div>
                		</div>
                	</div>                 
               
      		 </div>
    		 
     </t:panel>  
    
   </article>  