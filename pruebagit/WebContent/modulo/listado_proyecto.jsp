<%@ taglib tagdir="/WEB-INF/tags" prefix="t" %>     
      	<div><a href="./proyecto" class="tile-small text-shadow fg-white" style="background:#D1903A" data-role="tile">
                    <div class="tile-content iconic mif-ani-hover-shuttle">
                        <img class="icon" src="Archivos/images/iconmenu/PROYECTOS.png" ></img>
                    </div>
                </a>
      	<h3>Modulo de Proyectos</h3>
  		<p>Listado de Proyectos Actuales, Reflejando los datos Basicos </p></div>
<script>    
		
        $(document).ready(function() {
    		var tabla = $('#ListadoProyecto').DataTable( {
    			responsive: true,
                "language": {
                    "url": "Archivos/js/Spanish.lang"
                },
                "pagingType": "simple",
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
                		'<button class="btn btn-xs btn-primary" title="Consultar" style="display:none"><span class="glyphicon glyphicon-search" aria-hidden="true"></span></button>'+
                		'<button class="btn btn-xs btn-danger" title="Eliminar" style="display:none"><span class="glyphicon glyphicon-trash" aria-hidden="true"></span></button>'
                	},
                	{
                        "targets": [ 0 ],
                        "visible": false,
                        "searchable": false
                    }                
                ],
    	        "fnDrawCallback": function( oSettings ) {
    	        	validarBotones("proyecto",$("#idUsuario").val(),"1");
    	        }
             });
    		
    		   		
        	$("#ListadoProyecto tbody").on( 'click','button', function () {
        		  	if($(this).hasClass('btn-primary')){
        		  		var data = tabla.row( $(this).parents('tr') ).data();
        		  		var id = data[0];
        		  		window.location.href = './addProyecto?id='+id;
        		  	}else if($(this).hasClass('btn-danger')){
        		  		var data = tabla.row( $(this).parents('tr') ).data();
            	        eliminarProyecto(data[0]);
        		  	}        	        
        	});
        	 
		} );
        
        function eliminarProyecto(id){
        	swal({   
                title: "Desea eliminar el proyecto?",     
                type: "warning",   
                showCancelButton: true,   
                confirmButtonColor: "#DD6B55",   
                confirmButtonText: "Si, eliminar",   
                cancelButtonText: "No, cancelar",   
                closeOnConfirm: false,   
                closeOnCancel: true,
                showLoaderOnConfirm: true
            }, function(isConfirm){   
                if (isConfirm) { 
                	//llamar al servidor y eliminar
                	$.post("./Proyecto",
                			{
                				operacion :OPERACION_ELIMINAR,
                				idproyecto : id            			
                			},
                	        function FuncionRecepcion(respuesta) {
                				if(respuesta.valido){
                					swal("Eliminado!", respuesta.msj, "success");
                					window.location.href = './proyecto';
                				}else {
                					swal("Error!", respuesta.msj, "error");
                				}
                	        }
                	).fail(function(response) {
                		swal("Error!", "Error en el servidor, no hay respuesta valida.", "error");
                	});
                } 
            });		
        }
        
</script>
		<input type="hidden" value="<%=session.getAttribute("idusuario") %>" id="idUsuario">
	    <t:panel titulo="Lista de Proyectos">
            
            <div style="margin-left: 20px; margin-right: 20px">
            <a href="./addProyecto" class="btn btn-success" style="margin-top: 5px; margin-bottom: 15px; color: #fff;display:none;"><span class="glyphicon glyphicon-plus" aria-hidden="true" ></span>Agregar</a>
            
      
       <table id="ListadoProyecto" class="display"  width="100%">
        <thead>
            <tr>
            	<th>idproyecto</th>
                <th>Nombre</th>
                <th>Descripción</th>
                <th>Fecha De Inicio</th>
                <th>Opciones</th>
                
            </tr>
        </thead>
        <tfoot>
            <tr>
            	<th>idproyecto</th>
                <th>Nombre</th>
                <th>Descripción</th>
                <th>Fecha De Inicio</th>
                <th>Opciones</th>
                
            </tr>
        </tfoot>
        <tbody> 
            
        </tbody>
    </table>
    </div>
</t:panel>
