<%@ taglib tagdir="/WEB-INF/tags" prefix="t" %> 

<%
	String id = request.getParameter("id")==null ? "":request.getParameter("id").toString().trim();
%>
<script src="Archivos/js/modulo/formulario_subetapa.js"></script>
<script>
  $( function() {
    	<% if(!id.equals("")) out.print("cargarSubetapa('"+id+"')");%>
  } );
</script>
<div>
<a href="./subetapa" class="tile-small text-shadow fg-white" style="background:#61A184" data-role="tile">
                    <div class="tile-content iconic mif-ani-hover-shuttle">
                        <img class="icon" src="Archivos/images/iconmenu/SUBETAPAS.png"></img>
                    </div>
                </a>
<h3>Modulo de Sub-Etapas</h3>
  <p>Seccion Dedicada al Registro de Sub-Etapas</p>
   </div>
   <article id="formulario">
      
      
      <t:panel titulo="Formulario de Registro de Sub-Etapas">
      	
            
            <div class="row">
                <div class="form-group">
                    
                    <div class="col-sm-4 col-md-4">
                    <label class="control-label"><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Nombre: </label>
                      <input type="text" class="form-control" id="txtNombre" onblur="consultarSubetapa(this.value);" placeholder="Ingrese Nombre De la Sub-Etapa" required="required">
                    </div>
                
                    <div class="col-sm-8 col-md-8">
                    <label class=" control-label"><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Descripción: </label>
                    <input type="text" class="form-control" id="txtDescripcion" placeholder="Ingrese Descripción De la Sub-Etapa" required="required">
                    </div>
                    
                    <!-- <div class="col-sm-6 col-md-4">
                    <label class="control-label">Porcentaje: </label>
                      <input type="text" class="form-control" id="txtPorcentaje" placeholder="Ingrese Porcentaje">
                    </div> -->
                    
                    <div class="col-sm-6 col-md-4">
                    <label class="control-label">Tiempo Estimado: </label>
                      <input type="text" class="form-control" id="txtTiempoestimado" placeholder="Ingrese el Tiempo estimado">
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
             <div class="row">
                	<div class="col-md-12">
                		 <div class="form-group" style="text-align: center; ">
						    <div style="margin-top: 30px;">
						     <t:btnBotonera accionguardar="guardarSubetapa();" accioncancelar="window.location.href = './subetapa';" accionlimpiar="window.location.href = './addSubetapa';"></t:btnBotonera>
		     
		        		</div>
                	</div>
                </div> 
               <div class="row">
    		 		<input type="text" style="visibility: hidden;" id="idsubetapa" >
    		 </div>
               
      </div>
    
     </t:panel>  
    
   </article>