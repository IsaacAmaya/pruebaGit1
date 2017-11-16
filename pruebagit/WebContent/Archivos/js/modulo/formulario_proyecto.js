function cargarProyecto(id){
	bloquearContainer();
	$.post("./Proyecto",
			{
				operacion :OPERACION_CONSULTAR,
				idproyecto : id
			},
	        function FuncionRecepcion(respuesta) {
				if(respuesta.valido){
					$('#idproyecto').val(respuesta.idproyecto);
					$('#txtNombre').val(respuesta.txtNombre);
					$('#txtDireccion').val(respuesta.txtDireccion);
					$('#txtDescripcion').val(respuesta.txtDescripcion);
					$('#txtCoordenadas').val(respuesta.txtCoordenadas);
					$('#txtPresupuesto').val(respuesta.txtPresupuesto);
					$('#txtFechainicio').val(respuesta.txtFechainicio);
					$('#txtFechafinestimada').val(respuesta.txtFechafinestimada);
					$('#txtFechafin').val(respuesta.txtFechafin);
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

function consultarProyecto(value){
	bloquearContainer();
	$.post("./Proyecto",
			{
				operacion :OPERACION_CONSULTAR,
				consultarProyecto : 1,
				nombre : value
			},
	        function FuncionRecepcion(respuesta) {
				if(respuesta.valido){
					$('#idproyecto').val(respuesta.idproyecto);
					$('#txtNombre').val(respuesta.txtNombre);
					$('#txtDireccion').val(respuesta.txtDireccion);
					$('#txtDescripcion').val(respuesta.txtDescripcion);
					$('#txtCoordenadas').val(respuesta.txtCoordenadas);
					$('#txtPresupuesto').val(respuesta.txtPresupuesto);
					$('#txtFechainicio').val(respuesta.txtFechainicio);
					$('#txtFechafinestimada').val(respuesta.txtFechafinestimada);
					$('#txtFechafin').val(respuesta.txtFechafin);
					$('#cmbEstatus').val(respuesta.cmbEstatus);
				}
				desbloquearContainer();
	        }
	).fail(function(response) {
		desbloquearContainer();
		swal("Error!", "Error en el servidor, no hay respuesta valida.", "error");
	});
}

function guardarProyecto(){
	var op = OPERACION_INCLUIR;
	if($("#idproyecto").val()!=''){
		op = OPERACION_EDITAR;
	}
	if($("#formulario input").validarCampos() && $("#formulario select").validarCampos()){
		bloquearContainer();
		$.post("./Proyecto",
				{
					operacion : op,
					idproyecto : $("#idproyecto").val(),
					txtNombre : $("#txtNombre").val(),
					txtDireccion : $('#txtDireccion').val(),
					txtDescripcion : $('#txtDescripcion').val(),
					txtCoordenadas : $('#txtCoordenadas').val(),
					txtPresupuesto : $('#txtPresupuesto').val(),
					txtFechainicio : $('#txtFechainicio').val(),
					txtFechafinestimada : $('#txtFechafinestimada').val(),
					cmbEstatus :$('#cmbEstatus').val(),
					txtFechafin : $('#txtFechafin').val()
				},
		        function FuncionRecepcion(respuesta) {
					if(respuesta.valido){
						swal("Guardado!", respuesta.msj, "success");
						if(respuesta.msj == 'Registro incluido con exito!'){
							setTimeout(function(){
	    						window.location.href = './proyecto';
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