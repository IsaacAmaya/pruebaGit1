<%@ taglib tagdir="/WEB-INF/tags" prefix="t" %>     
      	<div><a href="./precio" class="tile-small text-shadow fg-white" style="background:#669933" data-role="tile">
                    <div class="tile-content iconic mif-ani-hover-shuttle">
                        <img class="icon" src="Archivos/images/iconmenu/PRECIO.png" ></img>
                    </div>
                </a>
      	<h3>Modulo de Precios</h3>
  		<p>Listado de Precios por Actividades (subetapas) en cada uno de los Proyectos </p></div>
<script>    
		
        $(document).ready(function() {
    		var tabla = $('#ListadoProyecto').DataTable( {
    			responsive: true,
                "language": {
                    "url": "Archivos/js/Spanish.lang"
                },
                "ajax": {
                	"url": "./Proyecto?operacion="+OPERACION_LISTADO,
                	"dataSrc": function ( json ) {
                        if(json.valido){
                        	return json.data;
                        }else {
							alert(json.msj);
                        }
                    }
                },
                "columnDefs": [{
                    "targets": -1,
                    "data": null,
                    "defaultContent":
                		'<button class="btn btn-xs btn-primary" title="Consultar" style="display:none"><span class="glyphicon glyphicon-search" aria-hidden="true"></span></button>'
                	},
                	{
                        "targets": [ 0 ],
                        "visible": false,
                        "searchable": false
                    }
                ],
    	        "fnDrawCallback": function( oSettings ) {
    	        	validarBotones("precio",$("#idUsuario").val(),"1");
    	        }
             });
    		
    		   		
        	$("#ListadoProyecto tbody").on( 'click','button', function () {
        		  	if($(this).hasClass('btn-primary')){
        		  		var data = tabla.row( $(this).parents('tr') ).data();
        		  		var id = data[0];
        		  		window.location.href = './addPrecio?id='+id;
        		  	}      	        
        	});
        	 
		} );
        
</script>
	<input type="hidden" value="<%=session.getAttribute("idusuario") %>" id="idUsuario">
	<t:panel titulo="Lista de Proyectos">
            
       <div style="margin-left: 20px; margin-right: 20px">
			<table id="ListadoProyecto" class="display"  width="100%">
	        <thead>
	            <tr>
	            	<th>idproyecto</th>
	                <th>Nombre</th>
	                <th>Descripción</th>
	                <th>Opciones</th>
	                
	            </tr>
	        </thead>
	        <tfoot>
	            <tr>
	            	<th>idproyecto</th>
	                <th>Nombre</th>
	                <th>Descripción</th>
	                <th>Opciones</th>
	            </tr>
	        </tfoot>
	        <tbody> 
	            
	        </tbody>
	    </table>
    </div>
</t:panel>
