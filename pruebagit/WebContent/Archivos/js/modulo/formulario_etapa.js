function cargarEtapa(id){
	bloquearContainer();
	$.post("./Etapa",
			{
				operacion :OPERACION_CONSULTAR,
				idetapa: id            			
			},
	        function FuncionRecepcion(respuesta) {
				if(respuesta.valido){
					$('#idetapa').val(respuesta.idetapa);
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

function consultarEtapa(value){
	bloquearContainer();
	$.post("./Etapa",
			{
				operacion :OPERACION_CONSULTAR,
				consultarEtapa: 1,
				nombre : value
			},
	        function FuncionRecepcion(respuesta) {
				if(respuesta.valido){
					$('#idetapa').val(respuesta.idetapa);
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
function guardarEtapa(){
	var op = OPERACION_INCLUIR;
	if($("#idetapa").val()!=''){
		op = OPERACION_EDITAR;
	}
	
	var listaSubetapas= new Array();
	var listaSubetapasPorcentaje= new Array();
	
	$("#listadoSubEtapaActivos tbody tr").each(function() {
		listaSubetapas.push($(this).attr('id'));
		listaSubetapasPorcentaje.push($(this).find("td").eq(2).find("input").val());
	});
	if($("#sumaPorcentaje").hasClass("error")){
		swal("Error!", "El porcentaje  no debe superar el 100%.", "error");
	}else{
		if($("#formulario input").validarCampos() && $("#formulario select").validarCampos()){
			
			if($("#validarListado").hasClass("error")){
				swal("Error!", "Verificar las subetapas. El porcentaje debe ser mayor a 0.", "error");
				
			}else{
				bloquearContainer();
				$.post("./Etapa",
						{
							operacion : op,
							idetapa : $('#idetapa').val(),
							txtNombre : $('#txtNombre').val(),
							txtDescripcion : $('#txtDescripcion').val(),
							txtPorcentaje : $('#txtPorcentaje').val(),
							txtTiempoestimado : $('#txtTiempoestimado').val(),
							cmbEstatus : $('#cmbEstatus').val(),
							listaSubEtapa: listaSubetapas.toString(),
							listaPorcentaje : listaSubetapasPorcentaje.toString()
						},
				        function FuncionRecepcion(respuesta) {
							if(respuesta.valido){
								swal("Guardado!", respuesta.msj, "success");
								if(respuesta.msj == 'Registro incluido con exito!'){
									setTimeout(function(){
			    						window.location.href = './etapa';
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
	}
	
}

function cargarListadoSubEtapa(){//CARGA EL LISTADO DE LOS TRABAJADORES PARA INCLUIR EN LAS CUADRILLAS
	var cont = 0;
	var valor = $("#sumaPorcentaje").val();
	if(valor == ""){
		valor = '0';
	}
	var porcentaje = parseInt(valor);
	//alert(porcentaje);
	if(porcentaje < 100){
		$('#vModalListadoSubEtapa').modal("show");
		$.post('./Subetapa',{
			operacion: OPERACION_LISTADO,
			nombreEtapa : $("#txtEtapaAux").val()
		},
		function (json){
			if(json.valido){
				var valor = json.data;
				var cadena = valor.toString();
				var tabla = '';
				for(var i=0 ; i < valor.length ; i++){
					cont++;
					var separado = valor[i].toString().split(",");
					var si = 0;
					$("#listadoSubEtapaActivos tbody tr").each(function(){
		        		var idTmp  = $(this).attr("id");
		        		if(idTmp == separado[0]){
	        	  			si = 1;
		        		}
		        	});
					
					if(si == 0){
						tabla += '<tr onclick="agregarCelda('+separado[0]+','+"'"+separado[1]+"'"+','+"'"+separado[2]+"'"+');"><td hidden="hidden">'+separado[0]+'</td><td>'+separado[1]+'</td><td>'+separado[2]+'</td></tr>';
					}
				}
				if(cont>0){
					$('#ListadoSubetapa tbody').html(tabla);
				}else{
					$('#ListadoSubetapa tbody').html("<tr><td colspan='2'><center>No se encontraron resultados</center></td></tr>");
				}
	        }
		});
	}else{		
		swal("Error!", "No puede agregar otra subetapa, ya que el procentaje es igual o supera el 100%.", "error");
		//$('#vModalListadoSubEtapa').modal("hide");
	}
	
}

function agregarCelda(id,nombre,descripcion){
	var idetapa = $("#idetapa").val();
	var celda = "<tr id='"+id+"' ><td>"+nombre+"</td><td>"+descripcion+"</td><td><input type='text' class='soloNumero form-control' onkeyup='calcularPorcentaje();' ></td><td><button class='btn btn-xs btn-danger' onclick='EliminarFila("+id+","+''+")' title='Eliminar'><span class='glyphicon glyphicon-remove'></span></button></td></tr>";
	if(idetapa != ""){
		bloquearContainer();
	       $.post("./Detalleetapa",
	    	{
					operacion : OPERACION_INCLUIR,
					idetapa : idetapa,
					idsubetapa : id
	    	},
	        function FuncionRecepcion(respuesta) {
				if(respuesta.valido){
					$('#listadoSubEtapaActivos tbody').append(celda);
					soloNumero();
					cargarDetalleEtapa();
					$('#vModalListadoSubEtapa').modal("hide");
				}else {
					swal("Error!", respuesta.msj, "error");
				}
				desbloquearContainer();
	        }).fail(function(response){
				desbloquearContainer();
				swal("Error!", "Error en el servidor, no hay respuesta valida.", "error");
			});
	      
	}else{
		$('#listadoSubEtapaActivos tbody').append(celda);
		soloNumero();
		calcularPorcentaje();
		$('#vModalListadoSubEtapa').modal("hide");
	}
	
}

function cargarDetalleEtapa(){
	$("#txtNombreetapaAux").val($("#txtNombre").val());
	$("#txtDescripcionAux").val($("#txtDescripcion").val());	
	var id = $("#idetapa").val();
	$.post("./Detalleetapa",{idetapa:id,operacion:OPERACION_LISTADO},function(json){
		if(json.valido){
			var sumaPorcentaje = 0;
			var valor = json.data;
			var cadena = valor.toString();
			var tabla = "";
			for(var i=0 ; i < valor.length ; i++){
				var separado = valor[i].toString().split(",");
				tabla += '<tr id="'+separado[0]+'"><td>'+separado[1]+'</td><td>'+separado[2]+'</td><td><input type="text" class="form-control soloNumero modificar" onkeyup="calcularPorcentaje();" value="'+separado[5]+'" ></td><td><button class="btn btn-xs btn-danger eliminar" onclick="EliminarFila('+separado[0]+','+separado[3]+')" title="Eliminar"><span class="glyphicon glyphicon-remove"></span></button></td><td hidden="hidden">'+separado[3]+'</td></tr>';
			}
			$('#listadoSubEtapaActivos tbody').html(tabla);
			soloNumero();
			calcularPorcentaje();
			validarBotones("etapa",$("#idUsuario").val(),"2");
		}
	});
}

function calcularPorcentaje(){
	var sumaPorcentaje = 0;
	var valido = true;
	$("#listadoSubEtapaActivos tbody tr").each(function(){
		var porcentaje = $(this).find("td").eq(2).find("input").val();
		if(porcentaje == ''){
			porcentaje = '0';
		}
		if(parseInt(porcentaje) == 0){
			valido = false;
		}
		sumaPorcentaje = sumaPorcentaje + parseInt(porcentaje);
	});
	if(sumaPorcentaje > 100){
		$("#sumaPorcentaje").addClass('error');
	}else{
		$("#sumaPorcentaje").removeClass('error');
	}
	if(!valido){
		$("#validarListado").addClass('error');
	}else{
		$("#validarListado").removeClass('error');
	}
	$("#sumaPorcentaje").val(sumaPorcentaje);
}


function EliminarFila(index,iddetalleetapa) {
	if(iddetalleetapa!=""){
		$.post("./Detalleetapa",{
			operacion : OPERACION_ELIMINAR,
			iddetalleetapa : iddetalleetapa
		}, function FuncionRecepcion(respuesta) {
			if(respuesta.valido){
				swal("Eliminado!", respuesta.msj, "success");
			}else {
				swal("Error!", respuesta.msj, "error");					
			}
			desbloquearContainer();
	    }).fail(function(response){
			desbloquearContainer();
			swal("Error!", "Error en el servidor, no hay respuesta valida.", "error");
		});
	}
	$('#'+index).remove();
    calcularPorcentaje();
    //tablaListadoSubetapa.ajax.reload();
}
