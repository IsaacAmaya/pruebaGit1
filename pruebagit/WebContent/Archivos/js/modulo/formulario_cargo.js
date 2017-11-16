function cargarCargo(id){
	bloquearContainer();
	$.post("./Cargo",
			{
				operacion :OPERACION_CONSULTAR,
				idcargo: id            			
			},
	        function FuncionRecepcion(respuesta) {
				if(respuesta.valido){
					$('#idcargo').val(respuesta.idcargo);
					$('#txtNombre').val(respuesta.txtNombre);
					$('#txtDescripcion').val(respuesta.txtDescripcion);
					$('#txtSueldo').val(respuesta.txtSueldo);
					$('#cmbEstatus').val(respuesta.cmbEstatus);					
				}else {
					swal("Error!", respuesta.msj, "error");					
				}
				desbloquearContainer();
	        }
	).fail(function(response) {
		desbloquearContainer();
		swal("Error!", "Error en el servidor, no hay respuesta valida.", "error");
	});
}

function consultarCargo(value){
	bloquearContainer();
	$.post("./Cargo",
			{
				operacion :OPERACION_CONSULTAR,
				consultarCargo : 1,
				nombre: value
			},
	        function FuncionRecepcion(respuesta) {
				if(respuesta.valido){
					$('#idcargo').val(respuesta.idcargo);
					$('#txtNombre').val(respuesta.txtNombre);
					$('#txtDescripcion').val(respuesta.txtDescripcion);
					$('#txtSueldo').val(respuesta.txtSueldo);
					$('#cmbEstatus').val(respuesta.cmbEstatus);					
				}
				desbloquearContainer();
	        }
	).fail(function(response) {
		desbloquearContainer();
		swal("Error!", "Error en el servidor, no hay respuesta valida.", "error");
	});
}

function guardarCargo(){
	var op = OPERACION_INCLUIR;
	if($("#idcargo").val()!=''){
		op = OPERACION_EDITAR;
	}
	if($("#formulario input").validarCampos() && $("#formulario select").validarCampos()){
		bloquearContainer();
		$.post("./Cargo",
				{
					operacion : op,
					idcargo	:$('#idcargo').val(),
					txtNombre : $('#txtNombre').val(),
					txtDescripcion	:$('#txtDescripcion').val(),
					txtSueldo : $('#txtSueldo').val(),
					cmbEstatus	: $('#cmbEstatus').val()				
				},
		        function FuncionRecepcion(respuesta) {
					if(respuesta.valido){
						swal("Guardado!", respuesta.msj, "success");
						if(respuesta.msj == 'Registro incluido con exito!'){
							setTimeout(function(){
	    						window.location.href = './cargo';
	    					}, 2000);
						}						
					}else {
						swal("Error!", respuesta.msj, "error");					
					}
					desbloquearContainer();
		        }
		).fail(function(response) {
			desbloquearContainer();
			swal("Error!", "Error en el servidor, no hay respuesta valida.", "error");
		});
	}
}