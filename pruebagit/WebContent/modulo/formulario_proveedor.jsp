<%@ taglib tagdir="/WEB-INF/tags" prefix="t" %> 
<%
	String id = request.getParameter("id")==null ? "":request.getParameter("id").toString().trim();
%>
<script src="Archivos/js/modulo/formulario_proveedor.js"></script>
<script>
  $( function() {
    	<% if(!id.equals("")) out.print("cargarProveedor('"+id+"')");%>
  } );
</script>
<div>
<a href="./proveedor" class="tile-small text-shadow fg-white" style="background:#29286A" data-role="tile">
                    <div class="tile-content iconic mif-ani-hover-shuttle">
                        <img class="icon" src="Archivos/images/iconmenu/PROVEEDOR.png"></img>
                    </div>
                    
                </a>
<h3>Modulo de Proveedor</h3>
  <p>Seccion Dedicada al Registro de Proveedores</p>
   </div>
   
   <article id="formulario">
      
      
      <t:panel titulo="Formulario de Registro de Proveedores">

            
            <div class="row">
                
                   
                    <div class=" col-sm-6 col-md-6">
                    <label class="control-label"><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> RIF: </label>
                      <input type="text" class="form-control" id="txtRif" placeholder="Ingrese El RIF" onblur="consultarRif(this.value);" required="required">
                    </div>
                    
                    <div class=" col-sm-6 col-md-6">
                    <label class=" control-label"><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Nombre:</label>
                    <input type="text" class="form-control" id="txtNombre" required="required" placeholder="Ingrese El Nombre del Proveedor">
                    </div>
                
                    
                    <div class="col-sm-12 col-md-6">
                    <label class="control-label"><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Dirección: </label>
                      <input type="text" class="form-control" id="txtDireccion" required="required" placeholder="Ingrese la Dirección Fiscal del Proveedor">
                    </div>
                
                	<div class="col-sm-12 col-md-6">
                    <label class="control-label"><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Descripción</label>
                    <input type="text" class="form-control"  id="txtDescripcion" placeholder="Ingrese una Descripción del Proveedor" required="required">
                    </div>
                
                    <div class="col-xs-6 col-sm-6 col-md-6">
                    <label class="control-label"><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Teléfono: </label>
                    <input type="text" class="form-control soloNumero"  id="txtTelefono" placeholder="Ingrese el Telefono del proveedor" required="required">
                    </div>
                                              
                <div class="col-xs-6 col-sm-6 col-md-6">
                    <label class="control-label">Estado: </label>
                        <select id="cmbEstatus" class="form-control">
                            <option value="1">Activo</option>
                            <option value="0">Inactivo</option>
                              
                        </select>
                    </div>
                
               </div> 
           
             <div class="row">
                	<div class="col-md-12">
                		 <div class="form-group" style="text-align: center; ">
						    <div style="margin-top: 30px;">
						     <t:btnBotonera accionguardar="guardarProveedor();" accioncancelar="window.location.href = './proveedor';" accionlimpiar="window.location.href = './addProveedor';"></t:btnBotonera>
		     
		        		</div>
                		</div>
                	</div>                 
               
      		 </div>
    		 <div class="row">
    		 		<input type="text" style="visibility: hidden;" id="idproveedor" >
    		 </div>
     </t:panel>  
    
   </article>  