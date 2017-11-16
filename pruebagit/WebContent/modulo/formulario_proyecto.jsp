<%@ taglib tagdir="/WEB-INF/tags" prefix="t" %> 
<%
	String id = request.getParameter("id")==null ? "":request.getParameter("id").toString().trim();
%>
<script src="Archivos/js/modulo/formulario_proyecto.js"></script>
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
		<% if(!id.equals("")) out.print("cargarProyecto('"+id+"')");%>
		
	} );
</script>
<div>
<a href="./proyecto" class="tile-small text-shadow fg-white" style="background:#D1903A" data-role="tile">
                    <div class="tile-content iconic mif-ani-hover-shuttle">
                        <img class="icon" src="Archivos/images/iconmenu/PROYECTOS.png" ></img>
                    </div>
                </a>

<h3>Modulo de Proyecto</h3>
  <p>Seccion Dedicada al Registro de Proyectos</p>
   </div>	
   <article id="formulario">
      
      
      
      <t:panel titulo="Formulario de Registro Proyecto">
      	
         
         
            
            <div class="row">
                <div class="form-group">
                    
                    <div class="col-sm-6 col-md-4">
                    <label class="control-label"><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Nombre: </label>
                      <input type="text" class="form-control" id="txtNombre" required="required" onblur="consultarProyecto(this.value);" placeholder="Ingrese Nombre Del Proyecto">
                    </div>
                
                    
                    <div class="col-sm-12 col-md-8">
                    <label class="control-label"><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Dirección: </label>
                      <input type="text" class="form-control" id="txtDireccion" required="required" placeholder="Ingrese Dirección Del Proyecto">
                    </div>
                
                    
                    <div class="col-xs-12 col-sm-12 col-md-8">
                    <label class=" control-label"><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Descripción:</label>
                    <input type="text" class="form-control" id="txtDescripcion" required="required" placeholder="Ingrese Descripción Del Proyecto">
                    </div>
              
                    
                    <div class="col-xs-6 col-sm-6 col-md-4">
                    <label class="control-label">Coordenadas:</label>
                    <input type="text" class="form-control" id="txtCoordenadas" placeholder="Ingrese Coordenadas">
                    </div>
                </div>
                
                    
                    <div class="col-xs-6 col-sm-6 col-md-4">
                    <label class="control-label">Presupuesto:</label>
                    <input type="text" class="form-control inputNumerico" id="txtPresupuesto" placeholder="Ingrese Presupuesto Del Proyecto">
                    </div>
                
                
                    
                    <div class="col-sm-6 col-md-4">
                    <label class="control-label"><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Fecha Inicio:</label>
                    <input type="text" class="form-control fec"  id="txtFechainicio" placeholder="Seleccione Fecha de Inicio" required="required">
                    </div>
                    
                    
                    <div class="col-sm-6 col-md-4">
                    <label class="control-label">Fecha Fin Estimada:</label>
                    <input type="text" class="form-control fec" id="txtFechafinestimada" placeholder="Seleccione Fecha Fin Estimada">
                    </div>
               
               		<div class="col-sm-6 col-md-4">
                    <label class="control-label">Fecha Fin:</label>
                    <input type="text" class="form-control fec" id="txtFechafin" placeholder="Seleccione Fecha de Finalización del Proyecto">
                    </div>
               
                
					<div class="col-sm-6 col-md-4">
                    <label class="control-label">Estatus:</label>

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
						     	<t:btnBotonera accionguardar="guardarProyecto();" accioncancelar="window.location.href = './proyecto';" accionlimpiar="window.location.href = './addProyecto';"></t:btnBotonera>
		     
		        			</div>
                	</div>
                </div> 
              	<div class="row">
    		 		<input type="text" style="visibility: hidden;" id="idproyecto" >
    		 	</div>
               
      </div>
    
     </t:panel>  
    
   </article>