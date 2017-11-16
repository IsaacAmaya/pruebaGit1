<%@ taglib tagdir="/WEB-INF/tags" prefix="t" %> 
<%
	String id = request.getParameter("id")==null ? "":request.getParameter("id").toString().trim();
%>

<script src="Archivos/js/modulo/formulario_cargo.js"></script>
<script>
  $( function() {
    	
    	<% if(!id.equals("")) out.print("cargarCargo('"+id+"');");%>
  } );
</script>

<div>
      	<a href="./cargo" class="tile-small text-shadow fg-white" style="background:#105284" data-role="tile">
                    <div class="tile-content iconic mif-ani-hover-bounce">
                        <span class="icon mif-profile"></span>
                    </div>
                </a>
      	
      	<h3>Modulo de Cargos</h3>
  		<p>Listado de Cargos Actuales </p>
  		</div>
   
   <article id="formulario">
      
      
      <t:panel titulo="Formulario de Cargo">

            
            <div class="row">
                
                    
                    <div class="col-sm-6 col-md-4">
                    <label class=" control-label"><span style="color:red;font-weight:bold; " title="Campo requerido">*</span> Nombre:</label>
                    <input type="text" class="form-control" required="required" id="txtNombre" onblur="consultarCargo(this.value);" placeholder="Ingrese Nombre del Cargo"  >
                    </div>
                    
                    
                    <div class="col-sm-12 col-md-8">
                    <label class="control-label"><span style="color:red;font-weight:bold; " title="Campo requerido">*</span> Descripción: </label>
                      <input type="text" class="form-control" required="required" id="txtDescripcion" placeholder="Ingrese Funciones del Cargo">
                    </div>
                
                    
                    <div class="col-sm-6 col-md-4">
                    <label class="control-label">Sueldo: </label>
                      <input type="text" class="form-control inputNumerico" id="txtSueldo" placeholder="Ingrese Sueldo Para Este Cargo" value="0,00">
                    </div>
                
                	 <div class="col-sm-6 col-md-4">
                    <label class="control-label">Estado</label>
                        <select id="cmbEstatus" class="form-control" >
                            <option value="1">Activo</option>
                            <option value="0">Inactivo</option>
                              
                        </select>
                    </div>
                
               </div> 
           
             <div class="row">
                	<div class="col-md-12">
                		 <div class="form-group" style="text-align: center; ">
						    <div style="margin-top: 30px;">
						      <t:btnBotonera accionguardar="guardarCargo();" accioncancelar="window.location.href = './cargo';" accionlimpiar="window.location.href = './addCargo';"></t:btnBotonera>
		     
		        		</div>
                	</div>
                </div> 
                
               
      </div>
      <div class="row">
    		 		<input type="text" style="visibility: hidden;" id="idcargo" >
    		 </div>
    
     </t:panel>  
    
   </article>  