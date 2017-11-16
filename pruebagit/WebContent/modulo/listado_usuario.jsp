<%@ taglib tagdir="/WEB-INF/tags" prefix="t" %>     
      	<div>
      	<a href="./usuario" class="tile-small text-shadow fg-white" style="background:#666" data-role="tile">
                    <div class="tile-content iconic mif-ani-hover-bounce">
                        <span class="icon mif-user"></span>
                    </div>
                </a>
      	
      	<h3>Modulo de Usuarios</h3>
  		<p>Listado de Usuarios Actuales </p>
  		</div>
  		
<script>    
		
        $(document).ready(function() {
    		var tabla = $('#ListadoUsuario').DataTable( {
    			responsive: true,
                "language": {
                    "url": "Archivos/js/Spanish.lang"
                },
                "pagingType": "simple",
                "ajax": {
                	"url": "./Usuario?operacion="+OPERACION_LISTADO,
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
    	        	validarBotones("usuario",$("#idUsuario").val(),"1");
    	        }
             });
    		
    		   		
        	$("#ListadoUsuario tbody").on( 'click','button', function () {
        		  	if($(this).hasClass('btn-primary')){
        		  		var data = tabla.row( $(this).parents('tr') ).data();
        		  		var id = data[0];
        		  		window.location.href = './addUsuario?id='+id;
        		  	}else if($(this).hasClass('btn-danger')){
        		  		var data = tabla.row( $(this).parents('tr') ).data();
            	        eliminarUsuario(data[0]);
        		  	}        	        
        	}); 
        	 
		} );
        
        function eliminarUsuario(id){
        	swal({   
                title: "Desea eliminar el Usuario?",     
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
                	$.post("./Usuario",
                			{
                				operacion :OPERACION_ELIMINAR,
                				idcargo: id            			
                			},
                	        function FuncionRecepcion(respuesta) {
                				if(respuesta.valido){
                					swal("Eliminado!", respuesta.msj, "success");
                					setTimeout(function(){
                						window.location.href = './usuario';
                					}, 2000);                					
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
	    <t:panel titulo="Lista de Usuarios">
            
            <div style="margin-left: 20px; margin-right: 20px">
            <a href="./addUsuario" class="btn btn-success" style="margin-top: 5px; margin-bottom: 15px;color: #fff;display:none;"><span class="glyphicon glyphicon-plus" aria-hidden="true" ></span>Agregar</a>
            
      
       <table id="ListadoUsuario" class="display"  width="100%">
        <thead>
            <tr>
            	<th>idusuario</th>
                <th>Usuario</th>
                <th>Nombre</th>
                <th>Estatus</th>
                <th>Opciones</th>
            </tr>
        </thead>
        <tfoot>
            <tr>
            	<th>idusuario</th>
                <th>Usuario</th>
                <th>Nombre</th>
                <th>Estatus</th>
                <th>Opciones</th>
            </tr>
        </tfoot>
        <tbody> 
            
        </tbody>
    </table>
    </div>
</t:panel>

	
	
	