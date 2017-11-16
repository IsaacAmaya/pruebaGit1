<%@ taglib tagdir="/WEB-INF/tags" prefix="t" %>     
      <div>
      <a href="./persona" class="tile-small text-shadow  fg-white " style="background:#666633" data-role="tile">
                    <div class="tile-content iconic mif-ani-hover-bounce">
                         <img class="icon" src="Archivos/images/iconmenu/PERSONA.png"></img>
                    </div>
                </a>	
                <h3>Modulo de Personas</h3>
  		<p>Listado de Personas Actuales </p>
  		</div>
  		
<script>    
		
        $(document).ready(function() {
    		var tabla = $('#ListadoPersona').DataTable( {
    			responsive: true,
                "language": {
                    "url": "Archivos/js/Spanish.lang"
                },
                "pagingType": "simple",
                "ajax": {
                	"url": "./Persona?operacion="+OPERACION_LISTADO,
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
    	        	validarBotones("persona",$("#idUsuario").val(),"1");
    	        }
             });
    		
    		   		
        	$("#ListadoPersona tbody").on( 'click','button', function () {
        		  	if($(this).hasClass('btn-primary')){
        		  		var data = tabla.row( $(this).parents('tr') ).data();
        		  		var id = data[0];
        		  		window.location.href = './addPersona?id='+id;
        		  	}else if($(this).hasClass('btn-danger')){
        		  		var data = tabla.row( $(this).parents('tr') ).data();
            	        eliminarPersona(data[0]);
        		  	}        	        
        	}); 
        	 
		} );
        
        function eliminarPersona(id){
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
                	$.post("./Persona",
                			{
                				operacion :OPERACION_ELIMINAR,
                				idpersona : id            			
                			},
                	        function FuncionRecepcion(respuesta) {
                				if(respuesta.valido){
                					swal("Eliminado!", respuesta.msj, "success");
                					setTimeout(function(){
                						window.location.href = './persona';
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
	    <t:panel titulo="Lista de Personas">
            
            <div style="margin-left: 20px; margin-right: 20px">
            <a href="./addPersona" class="btn btn-success" style="margin-top: 5px; margin-bottom: 15px; color: #fff;display:none;"><span class="glyphicon glyphicon-plus" aria-hidden="true" ></span>Agregar</a>
            
      
       <table id="ListadoPersona" class="display"  width="100%">
        <thead>
            <tr>
            	<th>idpersona</th>
            	<th>Cédula</th>
                <th>Nombre</th>
                
                <th>Teléfonos</th>              
                <th>Opciones</th>
            </tr>
        </thead>
        <tfoot>
            <tr>
            	<th>idpersona</th>
            	<th>Cédula</th>
                <th>Nombre</th>
                
                <th>Teléfonos</th>              
                <th>Opciones</th>
            </tr>
        </tfoot>
        <tbody> 
            
        </tbody>
    </table>
    </div>
</t:panel>

	
	
	