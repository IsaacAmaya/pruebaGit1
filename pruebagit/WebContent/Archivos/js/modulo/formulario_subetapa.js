function cargarSubetapa(id){

	bloquearContainer();
	$.post("./Subetapa",
			{
				operacion :OPERACION_CONSULTAR,
				idsubetapa: id            			
			},
	        function FuncionRecepcion(respuesta) {
				if(respuesta.valido){
					$('#idsubetapa').val(respuesta.idsubetapa);
					$('#txtNombre').val(respuesta.txtNombre);
					$('#txtDescripcion').val(respuesta.txtDescripcion);
					$('#txtPorcentaje').val(respuesta.txtPorcentaje);
					$('#txtTiempoestimado').val(respuesta.txtTiempoestimado);
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

function consultarSubetapa(value){
	bloquearContainer();
	$.post("./Subetapa",
			{
				operacion :OPERACION_CONSULTAR,
				nombre : value,
				consultarSubetapa: 1
			},
	        function FuncionRecepcion(respuesta) {
				if(respuesta.valido){
					$('#idsubetapa').val(respuesta.idsubetapa);
					$('#txtNombre').val(respuesta.txtNombre);
					$('#txtDescripcion').val(respuesta.txtDescripcion);
					$('#txtPorcentaje').val(respuesta.txtPorcentaje);
					$('#txtTiempoestimado').val(respuesta.txtTiempoestimado);
					$('#cmbEstatus').val(respuesta.cmbEstatus);					
				}
				desbloquearContainer();
	        }
	).fail(function(response) {
		desbloquearContainer();
		swal("Error!", "Error en el servidor, no hay respuesta valida.", "error");
	});
}

function guardarSubetapa(){
	var op = OPERACION_INCLUIR;
	if($("#idsubetapa").val()!=''){
		op = OPERACION_EDITAR;
	}
	if($("#formulario input").validarCampos() && $("#formulario select").validarCampos()){
		bloquearContainer();
		$.post("./Subetapa",
				{
					operacion : op,
					idsubetapa	:$('#idsubetapa').val(),
					txtNombre : $('#txtNombre').val(),
					txtDescripcion	:$('#txtDescripcion').val(),
					txtPorcentaje: $('#txtPorcentaje').val(),
					txtTiempoestimado: $('#txtTiempoestimado').val(),
					cmbEstatus	: $('#cmbEstatus').val()				
				},
		        function FuncionRecepcion(respuesta) {
					if(respuesta.valido){
						swal("Guardado!", respuesta.msj, "success");
						if(respuesta.msj == 'Registro incluido con exito!'){
							setTimeout(function(){
	    						window.location.href = './subetapa';
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




