
function cargarTrabajador(id){
	bloquearContainer();
	$.post("./Trabajador",
			{
				operacion :OPERACION_CONSULTAR,
				idtrabajador : id,
				desdeTrabajador : 1
			},
	        function FuncionRecepcion(respuesta) {
				if(respuesta.valido){
					//DATOS TRABAJADOR
					
					$('#idtrabajador').val(respuesta.idtrabajador);
					$('#idpersona').val(respuesta.idpersona);
					$('#idcargo').val(respuesta.idcargo);
					$('#idcargoAux').val(respuesta.idcargo);
					$('#txtApodo').val(respuesta.txtApodo);
					$('#txtPantalon').val(respuesta.txtPantalon);
					$('#txtCamisa').val(respuesta.txtCamisa);
					$('#txtBotas').val(respuesta.txtBotas);
					$('#txtTiposangre').val(respuesta.txtTiposangre);
					//$('#txtLumbosacra').val(respuesta.txtLumbosacra);
					$('#txtFechaingreso').val(respuesta.txtFechaingreso);
					$('#txtCantidadhijo').val(respuesta.txtCantidadhijo);
					$('#cmbEstatus').val(respuesta.cmbEstatus);
					//DATOS PERSONALES
					$('#txtCedulaT').val(respuesta.txtCedula);
					$('#txtNombreT').val(respuesta.txtNombre);
					$('#txtApellidoT').val(respuesta.txtApellido);
					$('#txtFechanacimientoT').val(respuesta.txtFechanacimiento);
					$('#cmbGeneroT').val(respuesta.cmbGenero);
					$('#cmbEstadocivilT').val(respuesta.cmbEstadocivil);
					$('#txtTelefonomovilT').val(respuesta.txtTelefonomovil);
					$('#txtTelefonohabitacionT').val(respuesta.txtTelefonohabitacion);
					$('#txtEmailT').val(respuesta.txtEmail);
					$('#txtDireccionT').val(respuesta.txtDireccion);
					$('#cmbEstatusT').val(respuesta.cmbEstatusPersona);					
					$('#txtCedulaAuxiliar').val(respuesta.txtCedula);
					$('#txtNombreAuxiliar').val(respuesta.txtNombre);
					$('#txtApellidoAuxiliar').val(respuesta.txtApellido);
					$('#btnBuscar').attr('disabled', 'disabled');
					//DATOS BANCARIOS
					$('#txtCedulatitular').val(respuesta.txtCedulatitular);
					$('#txtNombretitular').val(respuesta.txtNombretitular);
					$('#txtBanco').val(respuesta.txtBanco);
					$('#txtTipocuenta').val(respuesta.txtTipocuenta);
					$('#txtNumerocuenta').val(respuesta.txtNumerocuenta);
					
					
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

function agregarCargo(){
	if($("#txtCargoAux").val()!=""){
		$.post("./Cargo",
				{
					operacion : OPERACION_INCLUIR,
					txtNombre : $("#txtCargoAux").val(),
					desdeTrabajador : 1
				},
		        function FuncionRecepcion(respuesta) {
					desbloquearContainer();
					if(respuesta.valido){
						cargarCargos(respuesta.idcargo);
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

function cargarCargos(id){
	//alert($("#idcargoAux").val());
	if($("#idcargoAux").val()!=''){
		id = $("#idcargoAux").val();
	}
	
	$.post("./Cargo",{
		operacion:OPERACION_LISTADO
	},		
	function(json){
		if(json.valido){
			var valor = json.data;
			var cadena = valor.toString();			
			var opciones = "";			
			for(var i=0 ; i < valor.length ; i++){				
				var separado = valor[i].toString().split(",");
				opciones += '<option value="'+separado[0]+'" '+(id == separado[0] ? 'selected' : '')+'>'+separado[1]+'</option>';
			}
			$("#idcargo").html("<option>Seleccione</option>"+opciones);
		}
	});
}

function guardarTrabajador(){
	var op = OPERACION_INCLUIR;
	if($("#idtrabajador").val()!=''){
		op = OPERACION_EDITAR;
	}
	if($("#formulario input").validarCampos() && $("#formulario select").validarCampos()){
		bloquearContainer();
		$.post("./Trabajador",
				{
					operacion : op,
					idtrabajador : $("#idtrabajador").val(),
					idpersona : $("#idpersona").val(),
					idcargo : $("#idcargo").val(),
					idcargoAux : $('#idcargoAux').val(),
					txtApodo : $("#txtApodo").val(),
					txtPantalon : $("#txtPantalon").val(),
					txtCamisa : $("#txtCamisa").val(),
					txtBotas : $("#txtBotas").val(),
					txtTiposangre : $("#txtTiposangre").val(),
					//txtLumbosacra : $("#txtLumbosacra").val(),
					txtFechaingreso : $("#txtFechaingreso").val(),
					txtCantidadhijo : $("#txtCantidadhijo").val(),
					cmbEstatus : $("#cmbEstatus").val(),
					
					txtCedulatitular : $("#txtCedulatitular").val(),
					txtNombretitular : $("#txtNombretitular").val(),
					txtBanco : $("#txtBanco").val(),
					txtTipocuenta : $("#txtTipocuenta").val(),
					txtNumerocuenta : $("#txtNumerocuenta").val(),
					
					txtCedula : $("#txtCedulaT").val(),
					txtNombre : $("#txtNombreT").val(),
					txtApellido : $("#txtApellidoT").val(),
					txtFechanacimiento : $("#txtFechanacimientoT").val(),
					cmbGenero : $("#cmbGeneroT").val(),
					cmbEstadocivil : $("#cmbEstadocivilT").val(),
					txtTelefonomovil : $("#txtTelefonomovilT").val(),
					txtTelefonohabitacion : $("#txtTelefonohabitacionT").val(),
					txtEmail : $("#txtEmailT").val(),
					txtDireccion : $("#txtDireccionT").val(),
					cmbEstatus : $("#cmbEstatusT").val()					
				},
		        function FuncionRecepcion(respuesta) {
					desbloquearContainer();
					if(respuesta.valido){
						swal("Guardado!", respuesta.msj, "success");
						if(respuesta.msj == 'Registro incluido con exito!'){
							setTimeout(function(){
	    						window.location.href = './trabajador';
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

function cargarListadoPersona(){
	if(!tablaListadoPersona){ //verifica que la tabla sea nula
		//se inicializa la tabla
		tablaListadoPersona = $('#ListadoPersona').DataTable( {
			responsive: true,
	        "language": {
	            "url": "Archivos/js/Spanish.lang"
	        },
	        "pagingType": "simple",

	        "ajax": {
	        	"url": "./Persona?operacion="+OPERACION_LISTADO_SOLO_PERSONAS,
	        	"dataSrc": function ( json ) {
	                if(json.valido){
	                	return json.data;
	                }else {
						alert(json.msj);
	                }
	            }
	        },
	        "columnDefs": [
	        	{
	                "targets": [ 0 ],
	                "visible": false,
	                "searchable": false
	            }                
	        ]
	     });
		
		$('#ListadoPersona tbody').on('click', 'tr', function () {
	        var data = tablaListadoPersona.row( this ).data();
	        //alert( 'You clicked on '+data[0]+'\'s row' );
	        bloquearContainer();
	        $.post("./Persona",{
	        	operacion:OPERACION_CONSULTAR, 
	        	idpersona:data[0]
	        },function(respuesta){
	        	if(respuesta.valido){
	        		$('#idpersona').val(respuesta.idpersona);
					$('#txtCedulaT').val(respuesta.txtCedula).attr("disabled", true);
					$('#txtNombreT').val(respuesta.txtNombre).attr("disabled", true);
					$('#txtApellidoT').val(respuesta.txtApellido).attr("disabled", true);
					$('#txtFechanacimientoT').val(respuesta.txtFechanacimiento).attr("disabled", true);
					$('#cmbGeneroT').val(respuesta.cmbGenero).attr("disabled", true);
					$('#cmbEstadocivilT').val(respuesta.cmbEstadocivil).attr("disabled", true);
					$('#txtTelefonomovilT').val(respuesta.txtTelefonomovil).attr("disabled", true);
					$('#txtTelefonohabitacionT').val(respuesta.txtTelefonohabitacion).attr("disabled", true);
					$('#txtEmailT').val(respuesta.txtEmail).attr("disabled", true);
					$('#txtDireccionT').val(respuesta.txtDireccion).attr("disabled", true);
					$('#cmbEstatusT').val(respuesta.cmbEstatus).attr("disabled", true);
					
					$('#txtCedulaAuxiliar').val(respuesta.txtCedula);
					$('#txtNombreAuxiliar').val(respuesta.txtNombre);
					$('#txtApellidoAuxiliar').val(respuesta.txtApellido);
					
	        	}
	        	desbloquearContainer();
	        }).fail(function(response) {
				swal("Error!", "Error en el servidor, no hay respuesta valida.", "error");
				desbloquearContainer();
			});
	        $('#vModalListadoPersona').modal('hide');
	    });
	}
	
}

function consutarDesdeCedula(cedula){
	if($("#idtrabajador").val()==""){
		bloquearContainer();
		$.post("./Persona",{operacion:OPERACION_CONSULTAR_CEDULA, cedula:cedula},function(respuesta){
	    	if(respuesta.valido){
	    		$('#idpersona').val(respuesta.idpersona);
				$('#txtCedulaT').val(respuesta.txtCedula).attr("disabled", true);
				$('#txtNombreT').val(respuesta.txtNombre).attr("disabled", true);
				$('#txtApellidoT').val(respuesta.txtApellido).attr("disabled", true);
				$('#txtFechanacimientoT').val(respuesta.txtFechanacimiento).attr("disabled", true);
				$('#cmbGeneroT').val(respuesta.cmbGenero).attr("disabled", true);
				$('#cmbEstadocivilT').val(respuesta.cmbEstadocivil).attr("disabled", true);
				$('#txtTelefonomovilT').val(respuesta.txtTelefonomovil).attr("disabled", true);
				$('#txtTelefonohabitacionT').val(respuesta.txtTelefonohabitacion).attr("disabled", true);
				$('#txtEmailT').val(respuesta.txtEmail).attr("disabled", true);
				$('#txtDireccionT').val(respuesta.txtDireccion).attr("disabled", true);
				$('#cmbEstatusT').val(respuesta.cmbEstatusPersona).attr("disabled", true);
				
				$('#txtCedulaAuxiliar').val(respuesta.txtCedula);
				$('#txtNombreAuxiliar').val(respuesta.txtNombre);
				$('#txtApellidoAuxiliar').val(respuesta.txtApellido);
				
				if(respuesta.idtrabajador){
					
					
					$('#idtrabajador').val(respuesta.idtrabajador);
					$('#idcargo').val(respuesta.idcargo);
					$('#txtApodo').val(respuesta.txtApodo);
					$('#txtPantalon').val(respuesta.txtPantalon);
					$('#txtCamisa').val(respuesta.txtCamisa);
					$('#txtBotas').val(respuesta.txtBotas);
					$('#txtTiposangre').val(respuesta.txtTiposangre);
					//$('#txtLumbosacra').val(respuesta.txtLumbosacra);
					$('#txtFechaingreso').val(respuesta.txtFechaingreso);
					$('#txtCantidadhijo').val(respuesta.txtCantidadhijo);
					$('#cmbEstatus').val(respuesta.cmbEstatus);					
					//DATOS BANCARIOS
					$('#txtCedulatitular').val(respuesta.txtCedulatitular);
					$('#txtNombretitular').val(respuesta.txtNombretitular);
					$('#txtBanco').val(respuesta.txtBanco);
					$('#txtTipocuenta').val(respuesta.txtTipocuenta);
					$('#txtNumerocuenta').val(respuesta.txtNumerocuenta);
					swal("Ya existe!", respuesta.msj, "success");
				}
				
	    	}
	    	desbloquearContainer();
	    }).fail(function(response) {
			swal("Error!", "Error en el servidor, no hay respuesta valida.", "error");
			desbloquearContainer();
		});
	}	
}

function pasarDatos(){
	$('#txtCedulaAuxiliar').val($('#txtCedulaT').val());
	$('#txtNombreAuxiliar').val($('#txtNombreT').val());
	$('#txtApellidoAuxiliar').val($('#txtApellidoT').val());
}





