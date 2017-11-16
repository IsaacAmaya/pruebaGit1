function cargarDespachomaterial(id){
	bloquearContainer();
	$.post("./Solicitudmaterial",
			{
				operacion :OPERACION_CONSULTAR,
				idsolicitudmaterial : id
			},
	        function FuncionRecepcion(respuesta) {
				if(respuesta.valido){					
					$('#idsolicitudmaterial').val(respuesta.idsolicitudmaterial);
					$('#txtCedula').text(respuesta.txtCedula);
					$('#txtFechasolicitud').text(respuesta.txtFechasolicitud);
					$('#txtDatospersonales').text(respuesta.txtDatospersonales);
					$('#txtProyecto').text(respuesta.txtProyecto);
					$('#txtObra').text(respuesta.txtObra);
					$('#txtEtapa').text(respuesta.txtEtapa);
					$('#txtSubetapa').text(respuesta.txtSubetapa);
					$('#txtCuadrilla').text(respuesta.txtCuadrilla);
					$('#txtCargo').text(respuesta.txtCargo);
					cargarDetalleDespachomaterial(respuesta.idsolicitudmaterial);
					
					if(respuesta.txtEstatus == 1){
						$("#btnDespachar").hide();
						$("#btnRechazar").hide();
						$("#btnEditar").show();
						$("#listadoMateriales").hide();
					}else{
						$("#datosEnvio").hide();
						$("#btnEditar").hide();
						$("#listadoMaterialesAux").hide();
					}
					
					$('#txtPlacaAux').text(respuesta.txtPlaca);
					$('#txtMarcaAux').text(respuesta.txtMarca);
					$('#txtModeloAux').text(respuesta.txtModelo);
					$('#txtChoferAux').text(respuesta.txtChofer);
					$('#txtResponsableAux').text(respuesta.txtResponsable);
					$('#txtFechadespachoAux').text(respuesta.txtFechadespacho);
					
					$("#idSolicitudAux").text(respuesta.idsolicitudmaterial);
					
					$('#txtPlaca').val(respuesta.txtPlaca);
					$('#txtMarca').val(respuesta.txtMarca);
					$('#txtModelo').val(respuesta.txtModelo);
					$('#txtChofer').val(respuesta.txtChofer);
					$('#txtResponsable').val(respuesta.txtResponsable);
					
					if(respuesta.txtFechadespacho){
						$('#txtFechadespacho').val(respuesta.txtFechadespacho);
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

function cargarDetalleDespachomaterial(id){
	var contTr = 0;
	contTr = $('#listadoMaterialActivos tr').length;

		bloquearContainer();
		$.post("./Detallesolicitud",{
			operacion : OPERACION_LISTADO,
			idsolicitudmaterial : id
		},
		function(json){
			if(json.valido){
				var valor = json.data;
				var tabla = "";
				var tablaAux = "";
				for(var i=0 ; i < valor.length ; i++){
					var separado = valor[i].toString().split(",");
					tabla += '<tr id="'+contTr+'"><td><input type="hidden" id="'+separado[1]+'" />'+separado[2]+'</td><td>'+separado[3]+'</td><td>'+consultarExistencia(separado[1],contTr)+'</td></tr>';
					tablaAux += '<tr><td>'+separado[2]+'</td><td>'+separado[3]+'</td></tr>';
					contTr++;
				}
				
				if(contTr > $('#listadoMaterialActivos tr').length){
					$('#listadoMaterialActivos tbody').html(tabla);
					$('#listadoMaterialActivosAux tbody').html(tablaAux);
				}else{
					$("#listadoMaterialActivos tbody").html("<tr id='mensaje'><td colspan='3'><center><h4 style='color:#CCC;'>Sin materiales asignados.</h4></center></td></tr>");
				}
			}
			desbloquearContainer();
		});
}

function guardarDespachomaterial(){
	var materialArreglo = new Array();
	var cantidadArreglo = new Array();
	$("#guardar").show();
	$("#listadoMaterialActivos tbody tr").each(function(){
		materialArreglo.push($(this).find('td').eq(0).find('input').attr("id"));
		cantidadArreglo.push($(this).find('td').eq(1).text());
	});
		if($("#formulario input").validarCampos() && $("#formulario select").validarCampos()){
			bloquearContainer();
			$.post("./Solicitudmaterial",
					{
						operacion : OPERACION_EDITAR,
						condicion : 1,
						idsolicitudmaterial : $("#idsolicitudmaterial").val(),
						txtPlaca : $('#txtPlaca').val(),
						txtMarca : $('#txtMarca').val(),
						txtModelo : $('#txtModelo').val(),
						txtChofer : $('#txtChofer').val(),
						txtResponsable : $('#txtResponsable').val(),
						txtFechadespacho : $('#txtFechadespacho').val(),
						txtEstatus: 1,
						listaMaterial: materialArreglo.toString(),
						listaCantidad: cantidadArreglo.toString()
					},
			        function FuncionRecepcion(respuesta) {
						if(respuesta.valido){
							$("#vModalEnvio").modal("hide");
							swal("Guardado!", respuesta.msj, "success");
							if(respuesta.msj == 'Registro editado con exito!'){
								setTimeout(function(){
									window.location.href="addDespachomaterial?id="+$("#idsolicitudmaterial").val();
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

function editarDespachomaterial (){
	
	if($("#formulario input").validarCampos() && $("#formulario select").validarCampos()){
		bloquearContainer();
		$.post("./Solicitudmaterial",
				{
					operacion : OPERACION_EDITAR,
					condicion : 4,
					idsolicitudmaterial : $("#idsolicitudmaterial").val(),
					txtPlaca : $('#txtPlaca').val(),
					txtMarca : $('#txtMarca').val(),
					txtModelo : $('#txtModelo').val(),
					txtChofer : $('#txtChofer').val(),
					txtResponsable : $('#txtResponsable').val(),
					txtEstatus: 1
				},
		        function FuncionRecepcion(respuesta) {
					if(respuesta.valido){
						$("#vModalEnvio").modal("hide");
						swal("Guardado!", respuesta.msj, "success");						
						if(respuesta.msj == 'Registro editado con exito!'){
							setTimeout(function(){
								window.location.href="addDespachomaterial?id="+$("#idsolicitudmaterial").val();
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

function consultarExistencia(id,tr){
	bloquearContainer();
	$.post("./Material",{
		operacion : OPERACION_CONSULTAR,
		idmaterial : id,
		desdeSolicitud : 1
	},
	function FuncionRecepcion(respuesta){
		if(respuesta.valido){
			$("#"+tr+" td:eq(2)").text(respuesta.txtDisponible);
			compararExistencia(tr);
		}
		desbloquearContainer();
	});
}

function compararExistencia(tr){
	var cantidad = parseInt($("#"+tr).find('td').eq(1).text());
	var existencia = parseInt($("#"+tr).find('td').eq(2).text());
	if(cantidad > existencia){
		$("#"+tr).find('td').eq(1).addClass("error");
		$("#verificarError").addClass("error");
	}
}

function rechazarSolicitud(){
	if($('#txtObservacion').val()!=""){
		bloquearContainer();
		$.post("./Solicitudmaterial",
				{
					operacion : OPERACION_EDITAR,
					condicion : 3,
					idsolicitudmaterial : $("#idsolicitudmaterial").val(),
					txtObservacion : $('#txtObservacion').val(),
					txtEstatus: 2
				},
		        function FuncionRecepcion(respuesta) {
					if(respuesta.valido){
						$("#vModalRechazar").modal("hide");
						swal("Guardado!", respuesta.msj, "success");					
						if(respuesta.msj == 'Registro editado con exito!'){
							setTimeout(function(){
	    						window.location.href = './despachomaterial';
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
	}else{
		swal("Error!", "Disculpe, debe indicar el motivo.", "error");
	}
	
}