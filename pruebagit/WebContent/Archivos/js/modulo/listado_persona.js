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
        					window.location.href = './persona';
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