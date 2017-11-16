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
<script src="Archivos/js/modulo/formulario_precio.js"></script>
<script>
	var tablaListadoProyecto;
	$(function(){
		$('#vModalListadoProyecto').on('show.bs.modal', function (e) {
   			cargarListadoProyecto();
   		});
		
		<% if(!id.equals("")) out.print("cargarPrecio('"+id+"')");%>
	});

</script>
<input type="hidden" value="<%=session.getAttribute("idusuario") %>" id="idUsuario">
<div>
	<a href="./precio" class="tile-small text-shadow fg-white" style="background:#669933" data-role="tile">
		<div class="tile-content iconic mif-ani-hover-shuttle">
			<img class="icon" src="Archivos/images/iconmenu/PRECIO.png" ></img>
		</div>
	</a>

	<h3>Modulo de Precios</h3>
  	<p>Seccion Dedicada al Registro de Precios</p>
</div>	
<article id="formulario">
      
      <t:panel titulo="Formulario de Precios">       
            <input type="hidden" id="idprecio" >
            <input type="hidden" id="idproyecto" >
            <input type="hidden" id="idtipoobra" >
            <input type="hidden" id="idetapa" >
            <input type="hidden" id="idLista" >
            <div class="row">
            	<div class="col-sm-6 col-md-6">
            		<label>Proyecto: </label><br>
            		<span id="txtProyecto" style="font-size:16px; font-weight:normal; color:#000;"></span>
            		<!-- <input type="text" class="form-control"  placeholder="Seleccione el proyecto" data-toggle="modal" data-target="#vModalListadoProyecto" readonly>
            	 --></div>
            	<div class="col-sm-6 col-md-6">
            		<label>Sub-Etapas (Actividades): </label>
            	</div>
            </div>
            <div class="row">
            	<div class="col-sm-6 col-md-6" style="border-right:2px solid #ccc;">
            		<label>Listado de tipos de obras: </label>
            		<div class="panel-group" id="acordionTipoobra"></div>
            	</div>
            	
            	<div class="col-sm-6 col-md-6" style="height:300px;overflow: auto;">
            		
            		<table class="table table-condensed" id="listadoSubetapasActivos" >
            			<thead>
            				<tr>
            					<th>Subetapa</th><th><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Costo</th><th>Opción</th>
            				</tr>
            			</thead>
            			<tbody></tbody>
            		</table>
            	</div>
            </div>
            
             <div class="row">
             	<div class="col-md-12">
	             	<div class="form-group" style="text-align: center; ">
						<div style="margin-top: 30px;">
							<t:btnBotonera accionguardar="guardarPrecio();" accioncancelar="window.location.href = './precio';" accionlimpiar="window.location.href = './addPrecio';"></t:btnBotonera>
				    	</div>
	            	</div>
            	</div>
			</div>
    
     </t:panel>
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
    </div>
  </div>
</div>
</article>