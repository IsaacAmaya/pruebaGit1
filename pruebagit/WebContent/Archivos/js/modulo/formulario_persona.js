function cargarPersona(id){
	bloquearContainer();
	$.post("./Persona",
			{
				operacion :OPERACION_CONSULTAR,
				idpersona : id            			
			},
	        function FuncionRecepcion(respuesta) {
				if(respuesta.valido){
					$('#idpersona').val(respuesta.idpersona);
					$('#txtCedula').val(respuesta.txtCedula);
					$('#txtNombre').val(respuesta.txtNombre);
					$('#txtApellido').val(respuesta.txtApellido);
					$('#txtFechanacimiento').val(respuesta.txtFechanacimiento);
					$('#cmbGenero').val(respuesta.cmbGenero);
					$('#cmbEstadocivil').val(respuesta.cmbEstadocivil);
					$('#txtTelefonomovil').val(respuesta.txtTelefonomovil);
					$('#txtTelefonohabitacion').val(respuesta.txtTelefonohabitacion);
					$('#txtEmail').val(respuesta.txtEmail);
					$('#txtDireccion').val(respuesta.txtDireccion);
					$('#cmbEstatus').val(respuesta.cmbEstatus);
					
				}else {
					swal("Error!", respuesta.msj, "error");					
				}
				desbloquearContainer();
	        }
	).fail(function(response) {
		swal("Error!", "Error en el servidor, no hay respuesta valida.", "error");
		desbloquearContainer();
	});		
}

function consultarCedula(value){
	bloquearContainer();
	$.post("./Persona",
			{
				operacion :OPERACION_CONSULTAR,
				consultarCedula : 1,
				cedula : value				
			},
	        function FuncionRecepcion(respuesta) {
				if(respuesta.valido){
					$('#idpersona').val(respuesta.idpersona);
					$('#txtCedula').val(respuesta.txtCedula);
					$('#txtNombre').val(respuesta.txtNombre);
					$('#txtApellido').val(respuesta.txtApellido);
					$('#txtFechanacimiento').val(respuesta.txtFechanacimiento);
					$('#cmbGenero').val(respuesta.cmbGenero);
					$('#cmbEstadocivil').val(respuesta.cmbEstadocivil);
					$('#txtTelefonomovil').val(respuesta.txtTelefonomovil);
					$('#txtTelefonohabitacion').val(respuesta.txtTelefonohabitacion);
					$('#txtEmail').val(respuesta.txtEmail);
					$('#txtDireccion').val(respuesta.txtDireccion);
					$('#cmbEstatus').val(respuesta.cmbEstatus);
					
				}
				desbloquearContainer();
	        }
	).fail(function(response) {
		swal("Error!", "Error en el servidor, no hay respuesta valida.", "error");
		desbloquearContainer();
	});
}

function guardarPersona(){
	var op = OPERACION_INCLUIR;
	if($("#idpersona").val()!=''){
		op = OPERACION_EDITAR;
	}
	if($("#formulario input").validarCampos() && $("#formulario select").validarCampos()){
		bloquearContainer();
		$.post("./Persona",
				{
					operacion : op,
					idpersona : $("#idpersona").val(),
					txtCedula : $("#txtCedula").val(),
					txtNombre : $("#txtNombre").val(),
					txtApellido : $("#txtApellido").val(),
					txtFechanacimiento : $("#txtFechanacimiento").val(),
					cmbGenero : $("#cmbGenero").val(),
					cmbEstadocivil : $("#cmbEstadocivil").val(),
					txtTelefonomovil : $("#txtTelefonomovil").val(),
					txtTelefonohabitacion : $("#txtTelefonohabitacion").val(),
					txtEmail : $("#txtEmail").val(),
					txtDireccion : $("#txtDireccion").val(),
					cmbEstatus : $("#cmbEstatus").val()
					
				},
		        function FuncionRecepcion(respuesta) {
					desbloquearContainer();
					if(respuesta.valido){
						swal("Guardado!", respuesta.msj, "success");
						if(respuesta.msj == 'Registro incluido con exito!'){
							setTimeout(function(){
	    						window.location.href = './persona';
	    					}, 2000);
						}
					}else {
						swal("Error!", respuesta.msj, "error");					
					}
		        }
		).fail(function(response) {
			swal("Error!", "Error en el servidor, no hay respuesta valida.", "error");
			desbloquearContainer();
		});
	}
}

