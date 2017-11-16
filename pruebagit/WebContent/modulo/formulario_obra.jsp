<%@ taglib tagdir="/WEB-INF/tags" prefix="t" %> 
<%
	String id = request.getParameter("id")==null ? "":request.getParameter("id").toString().trim();
	
%>

<script src="Archivos/js/modulo/formulario_obra.js"></script>
<script>
var tablaListadoProyecto; //PROYECTO
var tablaListadoTipoobra;  //TIPO DE OBRA

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
    	<% if(!id.equals("")) out.print("cargarObra('"+id+"')");%>
    	
    	
    	$('#vModalListadoProyecto').modal({
     		  show: false
     	});
    
     	$('#vModalListadoProyecto').on('show.bs.modal', function (e) {
     		  cargarListadoProyecto();
     	});
     	
     	$('#vModalListadoTipoobra').modal({
   		  show: false
   	});
  
   	$('#vModalListadoTipoobra').on('show.bs.modal', function (e) {
   		  cargarListadoTipoobra();
   	});
     	
     	
     	
     	
     	
  } );
</script>
<div>
<a href="./obra" class="tile-small text-shadow fg-white" style="background:#647687" data-role="tile">
                    <div class="tile-content iconic mif-ani-hover-shuttle">
                        <img class="icon" src="Archivos/images/iconmenu/OBRA3.png"></img>
                    </div>
                </a>
<h3>Modulo de Obra</h3>
  <p>Seccion Dedicada al Registro de Obras</p>
   </div>
   <article id="formulario">
      
      
      <t:panel titulo="Formulario de Registro Obra">
      	<input type="hidden" id="idproyecto" >
      	<input type="hidden" id="idtipoobra" >
  			 <div class="row">
                 <div class="col-sm-6 col-md-4">
                    <label class="control-label"><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Proyecto</label>
                     <input type="text" class="form-control" id="txtDatosProyecto" data-toggle="modal" data-target="#vModalListadoProyecto" required="required" placeholder="Seleccione el Proyecto">   
                    </div>
                    
                    <div class="col-sm-6 col-md-4">
                    <label class="control-label"><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Tipo de Obra</label>
                      <input type="text" class="form-control" id="txtDatosTipoobra" data-toggle="modal" data-target="#vModalListadoTipoobra" required="required" placeholder="Seleccione el tipo de obra">
                    </div>
                    
                    <div class="col-sm-6 col-md-4">
                    <label class="control-label">Lote</label>
                      <input type="text" class="form-control" id="txtLote" placeholder="Ingrese a un Lote">
                    </div>

                    <div class="col-sm-6 col-md-4">
                    <label class="control-label"><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Nombre</label>
                      <input type="text" class="form-control" id="txtNombre" onblur="consultarObra(this.value);" required="required" placeholder="Ingrese Nombre De la Obra">
                    </div>
                
                    
                    <div class="col-sm-12 col-md-8">
                    <label class="control-label"><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Descripcion: </label>
                      <input type="text" class="form-control" id="txtDescripcion" required="required" placeholder="Ingrese Una Descripcion de la Obra">
                    </div>
                
                    <!-- <div class="col-sm-6 col-md-4">
                    <label class="control-label"><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Porcentaje: </label>
                      <input type="text" class="form-control" id="txtPorcentaje" required="required" placeholder="Ingrese el Porcentaje">
                    </div> -->
                    
                    
                    <div class="col-sm-6 col-md-4">
                    <label class="control-label"><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Fecha Inicio:</label>
                    <input type="text" class="form-control fec"  id="txtFechainicio" required="required" placeholder="Seleccione Fecha de Inicio">
                    </div>
                    
                    
                    <div class="col-sm-6 col-md-4">
                    <label class="control-label">Fecha Fin Estimada:</label>
                    <input type="text" class="form-control fec" id="txtFechafinestimada"  placeholder="Seleccione Fecha Fin Estimada">
                    </div>
               
               
               		<div class="col-sm-6 col-md-4">
                    <label class="control-label">Fecha Fin:</label>
                    <input type="text" class="form-control fec" id="txtFechafin" placeholder="Seleccione Fecha de Fin">
                    </div>
               
                
					<div class="col-sm-6 col-md-4">
                    <label class="control-label">Estatus:</label>
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
						     
		     			<t:btnBotonera accionguardar="guardarObra();" accioncancelar="window.location.href = './obra';" accionlimpiar="window.location.href = './addObra';"></t:btnBotonera>
		        		</div>
                	</div>
                </div> 
                
               </div>
               <div class="row">
    		 		<input type="text" style="visibility: hidden;" id="idobra" >
    		 </div>
    
     </t:panel>  
    
   </article>
   
   <!-- MODAL PARA LISTAR LOS PROYECTOS Y SELECCIONAR EL NOMBRE -->
<div class="modal fade" id="vModalListadoProyecto" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h6 class="modal-title" id="myModalLabel">Seleccionar Proyecto</h6>
      </div>
      <div class="modal-body">
        	<table id="ListadoProyecto" class="display"  width="100%">
		        <thead>
		            <tr>
		            	<th>idproyecto</th>
		            	<th>Nombre</th>
		                <th>Descripcion</th>	                
		            </tr>
		        </thead>
		        <tfoot>
		            <tr>
		            	<th>idproyecto</th>
		            	<th>Nombre</th>
		                <th>Descripcion</th>	                  
		            </tr>
		        </tfoot>
		        <tbody> 
		            
		        </tbody>
		    </table> 
      </div>
      <!--  <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
      </div>-->
    </div>
  </div>
</div>
<!-- FIN MODAL PARA LISTAR LOS PROYECTOS  Y SELECCIONAR EL NOMBRE -->
   
    <!-- MODAL PARA LISTAR LOS PROYECTOS Y SELECCIONAR EL NOMBRE -->
<div class="modal fade" id="vModalListadoTipoobra" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h6 class="modal-title" id="myModalLabel">Seleccionar Tipo de Obra</h6>
      </div>
      <div class="modal-body">
        	<table id="ListadoTipoobra" class="display"  width="100%">
		        <thead>
		            <tr>
		            	<th>idtipoobra</th>
		            	<th>Nombre</th>
		                <th>Descripcion</th>	                
		            </tr>
		        </thead>
		        <tfoot>
		            <tr>
		            	<th>idtipoobra</th>
		            	<th>Nombre</th>
		                <th>Descripcion</th>	                  
		            </tr>
		        </tfoot>
		        <tbody> 
		            
		        </tbody>
		    </table> 
      </div>
      <!--  <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
      </div>-->
    </div>
  </div>
</div>
<!-- FIN MODAL PARA LISTAR LOS PROYECTOS  Y SELECCIONAR EL NOMBRE -->
   
   
   
   