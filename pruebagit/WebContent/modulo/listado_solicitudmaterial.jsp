<%@ taglib tagdir="/WEB-INF/tags" prefix="t" %>     
      	<div>
      	<a href="./solicitudmaterial" class="tile-small text-shadow fg-white" style="background:#CD7372" data-role="tile">
                    <div class="tile-content iconic mif-ani-hover-shuttle">
                        <img class="icon" src="Archivos/images/iconmenu/SOLICITUD1.png"></img>
                    </div>
                    
                </a>
      	
      	<h3>Modulo de Solicitud de materiales</h3>
  		<p>Lista de Solicitudes </p>
  		</div>
<script>    
		
        $(document).ready(function() {
    		var tabla = $('#ListadoSolicitudmaterial').DataTable( {
    			responsive: true,
                "language": {
                    "url": "Archivos/js/Spanish.lang"
                },
                "pagingType": "simple",
                "ajax": {
                	"url": "./Solicitudmaterial?operacion="+OPERACION_LISTADO,
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
                        /* "targets": [ 0 ], */
                        "visible": false,
                        "searchable": false
                    }],
        	        "fnDrawCallback": function( oSettings ) {
        	        	validarBotones("solicitudmaterial",$("#idUsuario").val(),"1");
        	        }
             });
    		 
    		   		
        	$("#ListadoSolicitudmaterial tbody").on( 'click','button', function () {
        		  	if($(this).hasClass('btn-primary')){
        		  		var data = tabla.row( $(this).parents('tr') ).data();
        		  		var id = data[0];
        		  		window.location.href = './addSolicitudmaterial?id='+id;
        		  	}else if($(this).hasClass('btn-danger')){
        		  		var data = tabla.row( $(this).parents('tr') ).data();
            	        eliminarSolicitudmaterial(data[0]);
        		  	}        	        
        	}); 
        	 
		} );
        
        function eliminarSolicitudmaterial(id){
        	swal({   
                title: "Desea eliminar la Solicitud?",     
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
                	$.post("./Solicitudmaterial",
                			{
                				operacion :OPERACION_ELIMINAR,
                				idsolicitudmaterial : id            			
                			},
                	        function FuncionRecepcion(respuesta) {
                				if(respuesta.valido){
                					swal("Eliminado!", respuesta.msj, "success");
                					setTimeout(function(){
                						window.location.href = './solicitudmaterial';
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
	    <t:panel titulo="Lista de Solicitudes">
            
            <div style="margin-left: 20px; margin-right: 20px">
            <a href="./addSolicitudmaterial" class="btn btn-success" style="margin-top: 5px; margin-bottom: 15px; color: #fff;display:none;"><span class="glyphicon glyphicon-plus" aria-hidden="true" ></span>Agregar</a>
            
      
       <table id="ListadoSolicitudmaterial" class="display"  width="100%">
        <thead>
            <tr>
            	<th>Nro</th>
                <th>Solicitante </th>
                <th>Obra</th>
                <th>Subetapa</th>
                <th>Estatus</th>
                <th>Opciones</th>
            </tr>
        </thead>
        <tfoot>
            <tr>
            	<th>Nro</th>
                <th>Solicitante </th>
                <th>Obra</th>
                <th>Subetapa</th>
                <th>Estatus</th>
                <th>Opciones</th>
            </tr>
        </tfoot>
        <tbody> 
            
        </tbody>
    </table>
    </div>
</t:panel>

	
	
	