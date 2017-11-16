function cargarSolicitudmaterial(id){
	bloquearContainer();
	$.post("./Solicitudmaterial",
			{
				operacion :OPERACION_CONSULTAR,
				idsolicitudmaterial : id
			},
	        function FuncionRecepcion(respuesta) {
				if(respuesta.valido){
					$("#numeroSolicitud").removeAttr("hidden");
					$('#idsolicitudmaterial').val(respuesta.idsolicitudmaterial);
					$('#idSolicitudAux').html(respuesta.idsolicitudmaterial);
					$('#idtrabajador').val(respuesta.idtrabajador);
					$('#idobra').val(respuesta.idobra);
					$('#idtipoobra').val(respuesta.idtipoobra);
					$('#idproyecto').val(respuesta.idproyecto);
					$('#idsubetapa').val(respuesta.idsubetapa);
					$('#iddetalleetapa').val(respuesta.iddetalleetapa);
					$('#idetapa').val(respuesta.idetapa);
					$('#txtCedula').val(respuesta.txtCedula);
					$('#txtFechasolicitud').val(respuesta.txtFechasolicitud);
					$('#txtDatospersonales').val(respuesta.txtDatospersonales);
					$('#txtProyecto').val(respuesta.txtProyecto);
					$('#txtObra').val(respuesta.txtObra);
					$('#txtEtapa').val(respuesta.txtEtapa);
					$('#txtSubetapa').val(respuesta.txtSubetapa);
					$('#txtCuadrilla').val(respuesta.txtCuadrilla);
					$('#txtCargo').val(respuesta.txtCargo);
					if(respuesta.txtObservacion){
						$('#txtObservacion').text(respuesta.txtObservacion);
						$("#observacionDiv").removeAttr("hidden");
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

function guardarSolicitudmaterial(){
	var op = OPERACION_INCLUIR;
	if($("#idsolicitudmaterial").val()!=''){
		op = OPERACION_EDITAR;
	}
	
	var materialArreglo = new Array();
	var cantidadArreglo = new Array();
	
	if(op == OPERACION_INCLUIR){
		$("#listadoMaterialActivos tbody tr").each(function(){
			materialArreglo.push($(this).find('td').eq(0).find('input').attr("id"));
			cantidadArreglo.push($(this).find('td').eq(1).find('input').val());		
		});
	}
	if(!$("#verificarError").hasClass("error")){
		if($("#formulario input").validarCampos() && $("#formulario select").validarCampos()){
			bloquearContainer();
			$.post("./Solicitudmaterial",
					{
						operacion : op,
						condicion : 2,
						idsolicitudmaterial : $("#idsolicitudmaterial").val(),
						idtrabajador : $('#idtrabajador').val(),
						idobra : $('#idobra').val(),
						idsubetapa : $('#idsubetapa').val(),
						txtFechasolicitud : $('#txtFechasolicitud').val(),
						txtEstatus: 0,
						
						listaMaterial: materialArreglo.toString(),
						listaCantidad: cantidadArreglo.toString()
					},
			        function FuncionRecepcion(respuesta) {
						if(respuesta.valido){
							swal("Guardado!", respuesta.msj, "success");
							if(respuesta.msj == 'Registro incluido con exito!'){
								setTimeout(function(){
		    						window.location.href = './solicitudmaterial';
		    					}, 2000);
							}
							
							if(respuesta.msj == 'Registro editado con exito!'){
								if($("#observacionDiv").is(":visible")){
									$("#observacionDiv").hide();
								}
							}
						}else {
							swal("Error!", respuesta.msj, "error");					
						}
						desbloquearContainer();
			        }
			).fail(function(response) {
				bloquearContainer();
				swal("Error!", "Error en el servidor, no hay respuesta valida.", "error");
			});
		}
	}else{
		swal("Error!", "Hay cantidades que superan la existencia de algunos materiales, por favor verificar.", "error");	    			
	}
}

function cargarDetalleSolicitudmaterial(){
	var contTr = 0;
	contTr = $('#listadoMaterialActivos tr').length;
	var idSolicitudmaterial = $("#idsolicitudmaterial").val();
	if(idSolicitudmaterial!=""){
		bloquearContainer();
		$.post("./Detallesolicitud",{
			operacion : OPERACION_LISTADO,
			idsolicitudmaterial : idSolicitudmaterial
		},
		function(json){
			if(json.valido){
				var valor = json.data;
				var tabla = "";
				for(var i=0 ; i < valor.length ; i++){
					var separado = valor[i].toString().split(",");
					tabla += '<tr id="'+contTr+'"><td><input type="hidden" id="'+separado[1]+'" />'+separado[2]+'</td><td><input type="hidden" id="cantidad'+contTr+'" class="form-control soloNumero" value="'+separado[3]+'" onkeyup="compararExistencia('+contTr+')" />'+separado[3]+'</td><td>'+consultarExistencia(separado[1],contTr)+'</td><td><button style="display:none;" class="btn btn-xs btn-success" onclick="EditarMaterialSolicitud('+separado[1]+','+contTr+')" title="Editar"><span class="glyphicon glyphicon-pencil" aria-hidden="true"></span></button><button class="btn btn-xs btn-danger eliminar" onclick="EliminarFila('+contTr+','+separado[1]+')" title="Eliminar"><span class="glyphicon glyphicon-remove"></span></button></td></tr>';
					contTr++;
				}
				
				if(contTr > $('#listadoMaterialActivos tr').length){
					$('#listadoMaterialActivos tbody').html(tabla);
					validarBotones("solicitudmaterial",$("#idUsuario").val(),"2");
				}else{
					$("#listadoMaterialActivos tbody").html("<tr id='mensaje'><td colspan='3'><center><h4 style='color:#CCC;'>Sin materiales asignados.</h4></center></td></tr>");
				}
				inputNumerico();
				soloNumero();
			}
			desbloquearContainer();
		});
	}
}

function cargarListadoTrabajador(){
	if(!tablaListadoTrabajador){
		tablaListadoTrabajador = $('#ListadoTrabajador').DataTable( {
			responsive: true,
	        "language": {
	            "url": "Archivos/js/Spanish.lang"
	        },
	        "pagingType": "simple",
	        "ajax": {
	        	"url": "./Trabajador?operacion="+OPERACION_LISTADO+"&desdeSolicitud=1",
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
		
		$('#ListadoTrabajador tbody').on('click', 'tr', function () {
	        var data = tablaListadoTrabajador.row( this ).data();
	        $('#idtrabajador').val(data[0]);
	        $('#txtCargo').val(data[2]);
	        $('#txtCuadrilla').val(data[3]);
	        $('#txtCedula').val(data[5]);
	        $('#txtDatospersonales').val(data[1]);
	        $('#vModalListadoTrabajador').modal('hide');
	    } );
	}	
}

function cargarListadoProyecto(){
	var cont = 0;
	bloquearContainer();
	$.post('./Proyecto',{
		operacion: OPERACION_LISTADO,
		nombreproyecto : $("#txtProyectoAux").val(),
		desdeSolicitud : 1
	},
	function (json){
		if(json.valido){
			var valor = json.data;
			var cadena = valor.toString();
			var tabla = '';
			for(var i=0 ; i < valor.length ; i++){
				cont++;
				var separado = valor[i].toString().split(",");
				tabla += '<tr><td hidden="hidden">'+separado[0]+'</td><td>'+separado[1]+'</td><td>'+separado[2]+'</td></tr>';
			}
			if(cont>0){
				$('#ListadoProyecto tbody').html(tabla);
				$('#ListadoProyecto tbody').on('click', 'tr', function () {
			       var id = $(this).find('td').eq(0).text();
			       var nombre = $(this).find('td').eq(1).text();
			       if(nombre != $('#txtProyecto').val()){
			    	   	$("#txtObra").val("");
			       		$("#txtEtapa").val("");
			       		$("#txtSubetapa").val("");
			       }
			       $("#txtProyectoAux").val("");
			       $('#idproyecto').val(id);
			       $('#txtProyecto').val(nombre);    
			       $('#vModalListadoProyecto').modal("hide");
				});
			}else{
				$('#ListadoProyecto tbody').html("<tr><td colspan='2'><center>No se encontraron resultados</center></td></tr>");
			}
        }
		desbloquearContainer();
	});
}

function cargarListadoObra(){
	var cont = 0;
	bloquearContainer();
	$.post('./Obra',{
		operacion: OPERACION_LISTADO,
		idproyecto : $("#idproyecto").val(),
		nombreobra: $("#txtObraAux").val(),
		desdeSolicitud : 1
	},
	function (json){
		if(json.valido){
			var valor = json.data;
			var cadena = valor.toString();
			var tabla = '';
			for(var i=0 ; i < valor.length ; i++){
				cont++;
				var separado = valor[i].toString().split(",");
				tabla += '<tr><td hidden="hidden">'+separado[0]+'</td><td>'+separado[1]+'</td><td>'+separado[2]+'</td><td hidden="hidden">'+separado[3]+'</td></tr>';
			}
			if(cont>0){
				
				$('#ListadoObra tbody').html(tabla);
				$('#ListadoObra tbody').on('click', 'tr', function () {
					var id = $(this).find('td').eq(0).text();					
				    var nombre = $(this).find('td').eq(1).text();
				    var idTipoobra = $(this).find('td').eq(3).text();
				    if(nombre != $('#txtObra').val()){
			       		$("#txtEtapa").val("");
			       		$("#txtSubetapa").val("");
			       }
					$('#idobra').val(id);
				    $('#txtObra').val(nombre);
				    $('#idtipoobra').val(idTipoobra);    
				    $('#vModalListadoObra').modal("hide");
					
				});
			}else{
				$('#ListadoObra tbody').html("<tr><td colspan='2'><center>No se encontraron resultados</center></td></tr>");
			}
        }
		desbloquearContainer();
	});
}

function cargarListadoEtapa(){
	var cont = 0;
	bloquearContainer();
	$.post('./Etapa',{
		operacion: OPERACION_LISTADO,
		idtipoobra : $("#idtipoobra").val(),
		nombreetapa: $("#txtEtapaAux").val(),
		desdeSolicitud : 1
	},
	function (json){
		if(json.valido){
			var valor = json.data;
			var cadena = valor.toString();
			var tabla = '';
			for(var i=0 ; i < valor.length ; i++){
				cont++;
				var separado = valor[i].toString().split(",");
				tabla += '<tr><td hidden="hidden">'+separado[0]+'</td><td>'+separado[1]+'</td><td>'+separado[2]+'</td></tr>';
			}
			if(cont>0){
				$('#ListadoEtapa tbody').html(tabla);
				$('#ListadoEtapa tbody').on('click', 'tr', function () {
					var id = $(this).find('td').eq(0).text();					
					var nombre = $(this).find('td').eq(1).text();
					if(nombre != $('#txtEtapa').val()){
				       	$("#txtSubetapa").val("");
				    }
					$('#idetapa').val(id);
					$('#txtEtapa').val(nombre);   
					$('#vModalListadoEtapa').modal("hide");
					
				});
			}else{
				$('#ListadoEtapa tbody').html("<tr><td colspan='2'><center>No se encontraron resultados</center></td></tr>");
			}
        }
		desbloquearContainer();
	});
}

function cargarListadoSubetapa(){
	bloquearContainer();
	var cont = 0;
	$.post('./Detalleetapa',{
		operacion: OPERACION_LISTADO,
		idetapa : $("#idetapa").val(),
		nombresubetapa: $("#txtSubetapaAux").val(),
		desdeSolicitud : 1
	},
	function (json){
		if(json.valido){
			var valor = json.data;
			var cadena = valor.toString();
			var tabla = '';
			for(var i=0 ; i < valor.length ; i++){
				cont++;
				var separado = valor[i].toString().split(",");
				tabla += '<tr><td hidden="hidden">'+separado[0]+'</td><td>'+separado[1]+'</td><td>'+separado[2]+'</td><td hidden="hidden">'+separado[3]+'</td></tr>';
			}
			if(cont>0){
				$('#ListadoSubetapa tbody').html(tabla);
				$('#ListadoSubetapa tbody').on('click', 'tr', function () {
					var id = $(this).find('td').eq(0).text();					
					var nombre = $(this).find('td').eq(1).text();
					var idDetalleetapa= $(this).find('td').eq(3).text();
					$('#idsubetapa').val(id);
					$('#txtSubetapa').val(nombre);  
					$('#iddetalleetapa').val(idDetalleetapa);
					$('#vModalListadoSubetapa').modal("hide");
					
				});
			}else{
				$('#ListadoSubetapa tbody').html("<tr><td colspan='2'><center>No se encontraron resultados</center></td></tr>");
			}
        }
		desbloquearContainer();
	});
}

function cargarListadoMaterial(){
	var cont = 0;
	bloquearContainer();
	$.post('./Material',{
		operacion: OPERACION_LISTADO,
		iddetalleetapa : $("#iddetalleetapa").val(),
		desdeSolicitud : 1,
		nombrematerial : $("#txtMaterialAux").val(),
		idtipoobra : $("#idtipoobra").val()
	},
	function (json){
		if(json.valido){
			var valor = json.data;
			var cadena = valor.toString();
			var tabla = '';
			for(var i=0 ; i < valor.length ; i++){
				cont++;
				var separado = valor[i].toString().split(",");
				tabla += '<tr><td hidden="hidden">'+separado[0]+'</td><td>'+separado[1]+'</td><td>'+separado[2]+'</td></tr>';
			}
			if(cont>0){
				$('#ListadoMaterial tbody').html(tabla);
				$('#ListadoMaterial tbody').on('click', 'tr', function () {
					var id = $(this).find('td').eq(0).text();
					var nombre = $(this).find('td').eq(1).text();
					var cantidad= $(this).find('td').eq(2).text();
					$('#idmaterial').val(id);
					$('#mostrarModalMateriales').val(nombre);
					$('#txtDisponible').val(cantidad);
					$('#txtMaterialAux').val("");
					$('#vModalListadoMaterial').modal("hide");
					
				});
			}else{
				$('#ListadoMaterial tbody').html("<tr><td colspan='3'><center>No se encontraron resultados</center></td></tr>");
			}
        }
		desbloquearContainer();
	});
}

function cargarListadoMaterial_____(){
	if(!tablaListadoMaterial && $("#iddetalleetapa").val()!=""){
		tablaListadoMaterial = $('#ListadoMaterial').DataTable({
			responsive: true,
	        "language": {
	            "url": "Archivos/js/Spanish.lang"
	        },
	        "ajax": {
	        	"url": "./Material?operacion="+OPERACION_LISTADO+"&desdeSolicitud=1&iddetalleetapa="+$("#iddetalleetapa").val(),
	        	"dataSrc": function ( json ) {
	                if(json.valido){
	                	return json.data;
	                }else {
						alert(json.msj);
	                }
	            }
	        },
	        "columnDefs": [{
	                "targets": [ 0 ],
	                "visible": false,
	                "searchable": false
	            }]
	     });
		$('#ListadoMaterial tbody').on('click', 'tr', function (){
	        var data = tablaListadoMaterial.row( this ).data();
	        $('#idmaterial').val(data[0]);
	        $('#mostrarModalMateriales').val(data[1]);
	        $('#txtDisponible').val(data[3]);
	        $('#vModalListadoMaterial').modal('hide');
	        $("#txtCantidad").focus();
	    });
	}
}

function guardarMaterialSolicitud(){
	if($("#mostrarModalMateriales").val()!="" && $("#txtCantidadAux").val()!=""){
		$('#listadoMaterialActivos tbody tr').each(function (){ //VERIFICAMOS SI ESTA EL MENSAJE DE "SIN MATERIALES" PARA ELIMINARLO
			if($(this).attr("id") == "mensaje"){
				$(this).remove();
			}
		});
		
		var contTr = 0;
		var contInput = 0;
		var existe = false;
		$('#listadoMaterialActivos tbody tr').each(function (){
			contTr = $(this).attr("id");
		});
		
		$('#listadoMaterialActivos tbody input').each(function (){
			contInput = $(this).attr("id");
			if($("#idmaterial").val() == contInput){
				existe = true;
			}
		});
		contTr++;
		
		if(!existe){
			if(!$("#txtCantidadAux").hasClass("error")){
				if($("#idsolicitudmaterial").val()!=""){
					bloquearContainer();
					$.post("./Detallesolicitud",
							{
								operacion : OPERACION_INCLUIR,
								idsolicitudmaterial : $("#idsolicitudmaterial").val(),
								idmaterial : $("#idmaterial").val(),
								cantidad : $("#txtCantidadAux").val()
							},
					        function (respuesta){
								if(respuesta.valido){
									$('#listadoMaterialActivos  > tbody:last-child').append('<tr id="'+contTr+'"><td><input type="hidden" id="'+$("#idmaterial").val()+'" />'+$("#mostrarModalMateriales").val()+'</td><td><input type="hidden" id="cantidad'+contTr+'" class="form-control soloNumero" value="'+$("#txtCantidadAux").val()+'" onkeyup="compararExistencia('+contTr+')" />'+$("#txtCantidadAux").val()+'</td><td>'+consultarExistencia($("#idmaterial").val(),contTr)+'</td><td><button style="display:none;" class="btn btn-xs btn-success" onclick="EditarMaterialSolicitud('+$("#idmaterial").val()+','+contTr+')" title="Editar"><span class="glyphicon glyphicon-pencil" aria-hidden="true"></span></button><button class="btn btn-xs btn-danger" onclick="EliminarFila('+contTr+','+$("#idmaterial").val()+')" title="Eliminar"><span class="glyphicon glyphicon-remove"></span></button></td></tr>');
									$("#mostrarModalMateriales").val("");
									$("#txtCantidadAux").val("");
									$("#txtDisponible").val("");
									swal("Guardado!", respuesta.msj, "success");
									inputNumerico();
									soloNumero();
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
					$('#listadoMaterialActivos  > tbody:last-child').append('<tr id="'+contTr+'"><td><input type="hidden" id="'+$("#idmaterial").val()+'" />'+$("#mostrarModalMateriales").val()+'</td><td><input type="hidden" min="1" id="cantidad'+contTr+'" class="form-control soloNumero" value="'+$("#txtCantidadAux").val()+'" onkeyup="compararExistencia('+contTr+')" />'+$("#txtCantidadAux").val()+'</td><td>'+consultarExistencia($("#idmaterial").val(),contTr)+'</td><td><button class="btn btn-xs btn-danger" onclick="EliminarFila('+contTr+','+$("#idmaterial").val()+')" title="Eliminar"><span class="glyphicon glyphicon-remove"></span></button></td></tr>');
					$("#mostrarModalMateriales").val("");
					$("#txtCantidadAux").val("");
					$("#txtDisponible").val("");
				}
			}else{
				$("#txtCantidadAux").focus();
				swal("Error!", "La cantidad que solicita supera la disponibilidad de este material.", "error");
				
			}
			
		}else{
			swal("Error!", "Ya este material se encuentra en la lista.", "error");
		}
	}
}

function consultarCedula(cedula){
	var cedula = cedula;
	if(cedula!=""){
		bloquearContainer();
		$.post("./Trabajador",{
			operacion : OPERACION_CONSULTAR,
			cedula : cedula
		},
		function FuncionRecepcion(respuesta){
			if(respuesta.valido){
				$('#idtrabajador').val(respuesta.idtrabajador);
		        $('#txtCuadrilla').val(respuesta.txtNombrecuadrilla);
		        $('#txtCedula').val(respuesta.txtCedula);
		        $('#txtDatospersonales').val(respuesta.txtNombre+" "+respuesta.txtApellido);
		        $('#txtCargo').val(respuesta.txtCargo);
			}else{
				swal("Error!", "No existe trabajador con esta cedula "+cedula+".", "error");
				$('#idtrabajador').val("");
		        $('#txtCuadrilla').val("");
		        $('#txtDatospersonales').val("");
		        $('#txtCargo').val("");
		        $('#txtCedula').val("").focus();
			}
			desbloquearContainer();
		});
	}
}

function EliminarFila(index,idmaterial) {
    if($("#idsolicitudmaterial").val()!=""){
    	bloquearContainer();
    	$.post("./Detallesolicitud",{
        	operacion : OPERACION_ELIMINAR,
        	idmaterial : idmaterial,
        	idsolicitudmaterial : $("#idsolicitudmaterial").val()
        	}, function FuncionRecepcion(respuesta){
    			if(respuesta.valido){
    				swal("Eliminado!", respuesta.msj, "success");
    				 $("#"+index).remove();
    			}else {
    				swal("Error!", respuesta.msj, "error");
    			}
				desbloquearContainer();
            });
    }else{
    	 $("#"+index).remove();
    }
}

function EditarMaterialSolicitud(idmaterial,idTr){
	var idsolicitudmaterial = $("#idsolicitudmaterial").val();
	var idmaterial = idmaterial;
	var costounitario = $("#costounitario"+idTr).val();
	var cantidad = $("#cantidad"+idTr).val();
	if(!$("#cantidad"+idTr).hasClass("error")){
		bloquearContainer();
		$.post("./Detallesolicitud",{
	    	operacion : OPERACION_EDITAR,
	    	idmaterial : idmaterial,
	    	idsolicitudmaterial : idsolicitudmaterial,
	    	cantidad : cantidad
	    	}, 
	    	function FuncionRecepcion(respuesta) {
				if(respuesta.valido){
					swal("Editado!", respuesta.msj, "success");
				}else {
					swal("Error!", respuesta.msj, "error");
				}
				desbloquearContainer();
	        });
	}else{
		$("#cantidad"+idTr).focus();
		swal("Error!", "La cantidad que solicita supera la disponibilidad de este material.", "error");
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
	var cantidad = parseInt($("#cantidad"+tr).val());
	var existencia = parseInt($("#"+tr).find('td').eq(2).text());
	if(cantidad > existencia){
		$("#cantidad"+tr).addClass("error");
		$("#verificarError").addClass("error");
	}else{
		$("#cantidad"+tr).removeClass("error");
		$("#verificarError").removeClass("error");
	}
}

function validarCantidad(){
	var cantidad = parseInt($("#txtCantidadAux").val());
	var existencia = parseInt($("#txtDisponible").val());
	if(cantidad > existencia){
		$("#txtCantidadAux").addClass("error");
	}else{
		$("#txtCantidadAux").removeClass("error");
	}	
}

function traerDatos(cadena){
	
	var recibo = cadena.rel;
	var dato = recibo.split(",");
	var idAuxiliar = dato[6];
	if(idAuxiliar!=""){
		$('#'+dato[6]).val(dato[2]);
	}
    if(dato[0] != $('#'+dato[3]).val()){
    	if(dato[4]=="txtProyecto"){
    		$("#txtObra").val("");
    		$("#txtEtapa").val("");
    		$("#txtSubetapa").val("");
    	}
    	
    	if(dato[4]=="txtObra"){
    		$("#txtEtapa").val("");
    		$("#txtSubetapa").val("");
    	}
    	
    	if(dato[4]=="txtEtapa"){
    		$("#txtSubetapa").val("");
    	}
    }    
    $('#'+dato[3]).val(dato[0]);
    $('#'+dato[4]).val(dato[1]);    
    $('#'+dato[5]).modal("hide");
    
    $("#txtProyectoAux").val("");
    $("#txtObraAux").val("");
    $("#txtEtapaAux").val("");
    $("#txtSubetapaAux").val("");
}

