function cargarProveedor(id){

	bloquearContainer();
	$.post("./Proveedor",
			{
				operacion :OPERACION_CONSULTAR,
				idproveedor : id            			
			},
	        function FuncionRecepcion(respuesta) {
				if(respuesta.valido){
					$('#idproveedor').val(respuesta.idproveedor);
					$('#txtNombre').val(respuesta.txtNombre);
					$('#txtRif').val(respuesta.txtRif);
					$('#txtDireccion').val(respuesta.txtDireccion);
					$('#txtDescripcion').val(respuesta.txtDescripcion);
					$('#cmbEstatus').val(respuesta.cmbEstatus);
					$('#txtTelefono').val(respuesta.txtTelefono);					
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

function consultarRif(value){
	bloquearContainer();
	$.post("./Proveedor",
			{
				operacion :OPERACION_CONSULTAR,
				consultarRif : 1,
				rif : value				       			
			},
	        function FuncionRecepcion(respuesta) {
				if(respuesta.valido){
					$('#idproveedor').val(respuesta.idproveedor);
					$('#txtNombre').val(respuesta.txtNombre);
					$('#txtRif').val(respuesta.txtRif);
					$('#txtDireccion').val(respuesta.txtDireccion);
					$('#txtDescripcion').val(respuesta.txtDescripcion);
					$('#cmbEstatus').val(respuesta.cmbEstatus);
					$('#txtTelefono').val(respuesta.txtTelefono);					
				}
				desbloquearContainer();
	        }
	).fail(function(response) {
		desbloquearContainer();
		swal("Error!", "Error en el servidor, no hay respuesta valida.", "error");
	});
}

function guardarProveedor(){
	var op = OPERACION_INCLUIR;
	if($("#idproveedor").val()!=''){
		op = OPERACION_EDITAR;
	}
	if($("#formulario input").validarCampos() && $("#formulario select").validarCampos()){
		bloquearContainer();
		$.post("./Proveedor",
				{
					operacion : op,
					idproveedor : $('#idproveedor').val(),
					txtNombre : $('#txtNombre').val(),
					txtRif : $('#txtRif').val(),
					txtDireccion : $('#txtDireccion').val(),
					txtDescripcion : $('#txtDescripcion').val(),
					cmbEstatus : $('#cmbEstatus').val(),
					txtTelefono : $('#txtTelefono').val()
					
				},
		        function FuncionRecepcion(respuesta) {
					if(respuesta.valido){
						swal("Guardado!", respuesta.msj, "success");
						if(respuesta.msj == 'Registro incluido con exito!'){
							setTimeout(function(){
	    						window.location.href = './proveedor';
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

