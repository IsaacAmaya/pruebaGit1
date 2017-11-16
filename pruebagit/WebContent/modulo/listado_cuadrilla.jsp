<%@ taglib tagdir="/WEB-INF/tags" prefix="t" %>     
      	<div>
      	 <a href="./cuadrilla" class="tile-small text-shadow fg-white" style="background:#ECB54E" data-role="tile">
                    <div class="tile-content iconic mif-ani-hover-bounce">
                        <img class="icon" src="Archivos/images/iconmenu/CUADRILLAS.png"></img>
                    </div>
                </a>
      	<h3>Modulo de Cuadrilla</h3>
  		<p>Listado de Cuadrillas Actuales </p>
  		</div>
<script>    
		
        $(document).ready(function() {
    		var tabla = $('#ListadoCuadrilla').DataTable( {
    			responsive: true,
                "language": {
                    "url": "Archivos/js/Spanish.lang"
                },
                "pagingType": "simple",
                "ajax": {
                	"url": "./Cuadrilla?operacion="+OPERACION_LISTADO,
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
    	        	validarBotones("cuadrilla",$("#idUsuario").val(),"1");
    	        }
             });
    		
    		   		
        	$("#ListadoCuadrilla tbody").on( 'click','button', function () {
        		  	if($(this).hasClass('btn-primary')){
        		  		var data = tabla.row( $(this).parents('tr') ).data();
        		  		var id = data[0];
        		  		window.location.href = './addCuadrilla?id='+id;
        		  	}else if($(this).hasClass('btn-danger')){
        		  		var data = tabla.row( $(this).parents('tr') ).data();
            	        eliminarCuadrilla(data[0]);
        		  	}        	        
        	}); 
        	 
		} );
        
        function eliminarCuadrilla(id){
        	swal({   
                title: "Desea eliminar la persona?",     
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
                	$.post("./Cuadrilla",
                			{
                				operacion :OPERACION_ELIMINAR,
                				idcuadrilla : id            			
                			},
                	        function FuncionRecepcion(respuesta) {
                				if(respuesta.valido){
                					swal("Eliminado!", respuesta.msj, "success");
                					setTimeout(function(){
                						window.location.href = './cuadrilla';
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
	    <t:panel titulo="Lista de Cuadrillas">
            
            <div style="margin-left: 20px; margin-right: 20px">
            <a href="./addCuadrilla" class="btn btn-success" style="margin-top: 5px; margin-bottom: 15px; color: #fff;display:none;"><span class="glyphicon glyphicon-plus" aria-hidden="true" ></span>Agregar</a>
            
      
       <table id="ListadoCuadrilla" class="display"  width="100%">
        <thead>
            <tr>
            	<th>idcuadrilla</th>
                <th>Nombre</th>
                <th>Jefe Cuadrilla</th>
                <th>Apodo</th>
                <th>Descripcion</th>
                               
                <th>Opciones</th>
            </tr>
        </thead>
        <tfoot>
            <tr>
            	<th>idcuadrilla</th>
                <th>Nombre</th>
                <th>Jefe Cuadrilla</th>
                <th>Apodo</th>
                <th>Descripcion</th>
                               
                <th>Opciones</th>
            </tr>
        </tfoot>
        <tbody> 
            
        </tbody>
    </table>
    </div>
</t:panel>

	
	
	