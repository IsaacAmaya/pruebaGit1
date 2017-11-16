<%@ taglib tagdir="/WEB-INF/tags" prefix="t" %>     
      	<div>
      	<a href="./trabajador" class="tile-small text-shadow fg-white" style="background:#CE352C" data-role="tile">
                    <div class="tile-content iconic mif-ani-hover-bounce">
                        <img class="icon" src="Archivos/images/iconmenu/TRABAJADOR.png"></img>
                    </div>
                </a>
      	<h3>Modulo de Trabajadores</h3>
  		<p>Listado de Trabajadores Actuales </p>
  		
  		</div>
  		
<script>    
		
        $(document).ready(function() {
    		var tabla = $('#ListadoTrabajador').DataTable( {
    			responsive: true,
                "language": {
                    "url": "Archivos/js/Spanish.lang"
                },
                
    	        "pagingType": "simple",
                "ajax": {
                	"url": "./Trabajador?operacion="+OPERACION_LISTADO,
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
    	        	validarBotones("trabajador",$("#idUsuario").val(),"1");
    	        }
             });
    		
    		   		
        	$("#ListadoTrabajador tbody").on( 'click','button', function () {
        		  	if($(this).hasClass('btn-primary')){
        		  		var data = tabla.row( $(this).parents('tr') ).data();
        		  		var id = data[0];
        		  		window.location.href = './addTrabajador?id='+id;
        		  	}else if($(this).hasClass('btn-danger')){
        		  		var data = tabla.row( $(this).parents('tr') ).data();
            	        eliminarTrabajador(data[0]);
        		  	}        	        
        	}); 
        	 
		} );
        
        function eliminarTrabajador(id){
        	swal({   
                title: "Desea eliminar el Trabajador?",     
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
                	$.post("./Trabajador",
                			{
                				operacion :OPERACION_ELIMINAR,
                				idtrabajador : id            			
                			},
                	        function FuncionRecepcion(respuesta) {
                				if(respuesta.valido){
                					swal("Eliminado!", respuesta.msj, "success");
                					setTimeout(function(){
                						window.location.href = './trabajador';
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
	    <t:panel titulo="Lista de Trabajadores">
            
            <div style="margin-left: 20px; margin-right: 20px">
            <a href="./addTrabajador" class="btn btn-success" style="margin-top: 5px; margin-bottom: 15px; color: #fff;display:none;"><span class="glyphicon glyphicon-plus" aria-hidden="true" ></span>Agregar</a>
            
      
       <table id="ListadoTrabajador" class="display"  width="100%">
        <thead>
            <tr>
            	<th>idtrabajador</th>
            	<th>Cedula</th>
            	<th>Nombre</th>
                <th>Cargo</th>
                <th>Apodo</th>
                <th>Fecha de Ingreso</th>
                <th>Opciones</th>
            </tr>
        </thead>
        <tfoot>
            <tr>
            	<th>idtrabajador</th>
            	<th>Cedula</th>
            	<th>Nombre</th>
                <th>Cargo</th>
                <th>Apodo</th>
                <th>Fecha de Ingreso</th>
                <th>Opciones</th>
            </tr>
        </tfoot>
        <tbody> 
            
        </tbody>
    </table>
    </div>
</t:panel>

	
	
	