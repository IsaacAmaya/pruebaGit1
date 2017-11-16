function cargarCompra(id){

	bloquearContainer();
	$.post("./Compra",
			{
				operacion :OPERACION_CONSULTAR,
				idcompra : id
			},
	        function FuncionRecepcion(respuesta){
				if(respuesta.valido){
					$('#idcompra').val(respuesta.idcompra);
					$('#idproveedor').val(respuesta.idproveedor);
					$('#txtFactura').val(respuesta.txtFactura);
					$('#txtFechacompra').val(respuesta.txtFechacompra);
					$('#txtMontofactura').val(respuesta.txtMontofactura);
					$('#txtDescripcion').val(respuesta.txtDescripcion);
					$('#cmbEstatus').val(respuesta.cmbEstatus);					
					$("#txtRif").val(respuesta.txtRif);
					$("#txtNombre").val(respuesta.txtNombre);
					$("#txtDireccion").val(respuesta.txtDireccion);
					$("#txtIva").val(respuesta.iva);
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

function guardarCompra(){
	var valor1 = $("#txtMontoTotalFactura").val();
	valor1 = parseFloat(valor1.replace(/\./g, '').replace(/\,/g, '.'));
	var valor2 = $("#txtMontofacturaAux").val();
	valor2 = parseFloat(valor2.replace(/\./g, '').replace(/\,/g, '.'));
	//alert(valor1+" ->"+valor2);
	if(valor1 == valor2){
	
		var op = OPERACION_INCLUIR;
		if($("#idcompra").val()!=''){
			op = OPERACION_EDITAR;
		}
		
		var materialArreglo = new Array();
		var costounitarioArreglo = new Array();
		var cantidadArreglo = new Array();
		var costototalArreglo = new Array();
		var costoUSDArreglo = new Array();
		var tasacambio;
		if(op == OPERACION_INCLUIR){
			tasacambio = $("#preciodolar").html();
			$("#listadoMaterialActivos tbody tr").each(function(){
				materialArreglo.push($(this).find('td').eq(0).find('input').attr("id"));
				var costo = $(this).find('td').eq(1).find('input').val();
				costounitarioArreglo.push(costo.replace(/\./g, '').replace(/\,/g, '.'));
				cantidadArreglo.push($(this).find('td').eq(3).find('input').val());			
				var costototal = $(this).find('td').eq(4).text();
				costototalArreglo.push(costototal.replace(/\./g, '').replace(/\,/g, '.'));
				//ENVIAMOS EL COSTO DOLAR
				var costoUSD = $(this).find('td').eq(2).text();
				costoUSDArreglo.push(costoUSD.replace(/\./g, '').replace(/\,/g, '.'));
			});
		}else {
			tasacambio = $("#txtTasaCambio").val();
		}
		
		if($("#formulario input").validarCampos() && $("#formulario select").validarCampos()){
			if(!$("#txtMontoTotalFactura").hasClass("cantidadExeciva")){
				bloquearContainer();
				$.post("./Compra",
						{
							operacion : op,
							idcompra : $("#idcompra").val(),
							idproveedor : $("#idproveedor").val(),
							txtFactura : $("#txtFactura").val(),
							txttasacambio: tasacambio,
							txtFechacompra : $("#txtFechacompra").val(),
							txtMontofactura : $("#txtMontofactura").val(),
							txtDescripcion : $("#txtDescripcion").val(),
							cmbEstatus : "1",
							iva : $("#txtIva").val(),
							totaliva : $("#txtTotaliva").val(),
							listaMaterial: materialArreglo.toString(),
							listaCostounitario: costounitarioArreglo.toString(),
							listaCantidad: cantidadArreglo.toString(),
							listaCostototal: costototalArreglo.toString(),
							listacostoUSD : costoUSDArreglo.toString()
						},
				        function FuncionRecepcion(respuesta) {
							if(respuesta.valido){
								swal("Guardado!", respuesta.msj, "success");
								if(respuesta.msj == 'Registro incluido con exito!'){
									setTimeout(function(){
			    						window.location.href = './compra';
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
				swal("Error!", "No se puede procesar la compra, ya que excede el monto de la factura.", "error");
			}
		}
	}else{
		swal("Error!", "El subtotal debe ser igual al monto de la factura.", "error");
	}
}

function cargarListadoProveedor(){
	
	if(!tablaListadoProveedor){ //verifica que la tabla sea nula
		//se inicializa la tabla
		tablaListadoProveedor = $('#ListadoProveedor').DataTable({
			responsive: true,
	        "language": {
	            "url": "Archivos/js/Spanish.lang"
	        },
	        "pagingType": "simple",
	        "lengthMenu": [[5], [5]],
	        "ajax": {
	        	"url": "./Proveedor?operacion="+OPERACION_LISTADO,
	        	"dataSrc": function ( json ){
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
		
		$('#ListadoProveedor tbody').on('click', 'tr', function () {
	        var data = tablaListadoProveedor.row( this ).data();
	        //alert( 'You clicked on '+data[0]+'\'s row' );
	        $('#idproveedor').val(data[0]);
	        $('#txtRif').val(data[2]);
	        $('#txtNombre').val(data[1]);
	        $('#txtDireccion').val(data[3]);
	        $('#vModalListadoProveedor').modal('hide');
	    } );
	}
}

function consultarRif(rif){
	var rif = rif;
	if(rif!=""){
		bloquearContainer();
		$.post("./Proveedor",{
			operacion : OPERACION_CONSULTAR,
			consultarRif : 1,
			rif : rif
		},
		function FuncionRecepcion(respuesta){
			if(respuesta.valido){
				$("#idproveedor").val(respuesta.idproveedor);
				$("#txtRif").val(respuesta.txtRif);
				$("#txtNombre").val(respuesta.txtNombre);
				$("#txtDireccion").val(respuesta.txtDireccion);
			}else{
				swal("Error!", "No existe un proveedor con este rif: "+rif+".", "error");
				$('#txtRif').val("").focus();
				$("#txtNombre").val("");
				$("#txtDireccion").val("");
				$("#idproveedor").val("");
			}
			desbloquearContainer();
		});
	}	
}

function cargarDetalleCompra(){
	//validarBotones("compra",$("#idUsuario").val());
	var contTr = 0;	
	$("#txtMontofacturaAux").val($("#txtMontofactura").val());
	contTr = $('#listadoMaterialActivos tr').length;
	var precioDolar = 0;
	calcularMonto();
	var idCompra = $("#idcompra").val();
	if(idCompra!=""){
		bloquearContainer();
		$.post("./Compramaterial",{
			operacion : OPERACION_LISTADO,
			idcompra : idCompra
		},
		function(json){
			if(json.valido){
				var valor = json.data;
				var tabla = "";
				for(var i=0 ; i < valor.length ; i++){
					var separado = valor[i].toString().split(",");
					var m = separado[5].toString().replace(/\./g, ',');
					m = formatMoneda(m,',','.',2);//costo unitario
					var m2 = separado[4].toString().replace(/\./g, ',');
					m2 = formatMoneda(m2,',','.',2);//costo total
					tabla += '<tr id="'+contTr+'"><td><input type="hidden" id="'+separado[1]+'" />'+separado[2]+'</td><td><input type="hidden" class="inputNumerico form-control" value="'+separado[5]+'" onkeyup="calculoCostoTotalEditar('+contTr+');" id="costounitario'+contTr+'" />'+m+'</td><td>'+separado[7]+'</td><td><input type="hidden" id="cantidad'+contTr+'" class="form-control soloNumero" value="'+separado[3]+'" onkeyup="calculoCostoTotalEditar('+contTr+');" />'+separado[3]+'</td><td>'+m2+'</td><td><button class="btn btn-xs btn-success" onclick="EditarMaterialCompra('+separado[1]+','+contTr+');" title="Editar" style="display:none;"><span class="glyphicon glyphicon-pencil" aria-hidden="true"></span></button><button class="btn btn-xs btn-danger eliminar" onclick="EliminarFila('+contTr+','+separado[1]+');" title="Eliminar"><span class="glyphicon glyphicon-remove"></span></button></td></tr>';
					$("#txtTasaCambio").val(separado[6]);
					//alert(separado[6]);
					contTr++;
				}
				
				if(contTr > $('#listadoMaterialActivos tr').length){
					$('#listadoMaterialActivos tbody').html(tabla);
					validarBotones("compra",$("#idUsuario").val(),"2");
				}else{
					$("#listadoMaterialActivos tbody").html("<tr id='mensaje'><td colspan='6'><center><h4 style='color:#CCC;'>Sin materiales asignados.</h4></center></td></tr>");
				}
				montoTotal();
				calcularMonto();
				inputNumerico();
				soloNumero();
			}
			desbloquearContainer();
		});
	}
	
}

function cargarListadoMaterial(){
	if(!tablaListadoMaterial){
		tablaListadoMaterial = $('#ListadoMaterial').DataTable({
			responsive: true,
	        "language": {
	            "url": "Archivos/js/Spanish.lang"
	        },
	        "pagingType": "simple",
	        "lengthMenu": [[5], [5]],
	        "ajax": {
	        	"url": "./Material?operacion="+OPERACION_LISTADO,
	        	"dataSrc": function ( json ) {
	                if(json.valido){
	                	return json.data;
	                	$("#txtCostoAux").focus();
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
	        $('#vModalListadoMaterial').modal('hide');
	    });
	}
	
}

function guardarMaterialCompra(){
	if($("#mostrarModalMateriales").val()!="" && $("#txtCostoAux").val()!="" && $("#txtCantidadAux").val()!=""){
		$('#listadoMaterialActivos tbody tr').each(function (){ //VERIFICAMOS SI ESTA EL MENSAJE DE "SIN MATERIALES" PARA ELIMINARLO
			if($(this).attr("id") == "mensaje"){
				$(this).remove();
			}
		});
		
		var contTr = 0;
		var contInput = 0;
		var existe = false;
		var valorDolar = 0;
		if($("#txtTasaCambio").val()!=""){
			valorDolar = $("#txtTasaCambio").val();
		}else{
			valorDolar = $("#preciodolar").html();
		}
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
			if(!$("#txtMontoTotalFactura").hasClass("cantidadExeciva")){
				if($("#idcompra").val()!=""){
					bloquearContainer();
					$.post("./Compramaterial",
							{
								operacion : OPERACION_INCLUIR,
								idcompra : $("#idcompra").val(),
								costounitario: $("#txtCostoAux").val(),
								idmaterial : $("#idmaterial").val(),
								cantidad : $("#txtCantidadAux").val(),
								costototal : calculoCostoTotal($("#txtCostoAux").val(),$("#txtCantidadAux").val()),
								preciodolar : valorDolar,
								costounitarioSD : calcularPrecioUSD($("#txtCostoAux").val())
							},
					        function (respuesta){
								if(respuesta.valido){
									$('#listadoMaterialActivos  > tbody:last-child').append('<tr id="'+contTr+'"><td><input type="hidden" id="'+$("#idmaterial").val()+'" />'+$("#mostrarModalMateriales").val()+'</td><td><input type="hidden" class="inputNumerico form-control" value="'+$("#txtCostoAux").val()+'" onkeyup="calculoCostoTotalEditar('+contTr+')" />'+$("#txtCostoAux").val()+'</td><td>'+(calcularPrecioUSD($("#txtCostoAux").val()))+'</td><td><input type="hidden" id="cantidad'+contTr+'" class="form-control soloNumero" value="'+$("#txtCantidadAux").val()+'" onkeyup="calculoCostoTotalEditar('+contTr+');" />'+$("#txtCantidadAux").val()+'</td><td>'+calculoCostoTotal($("#txtCostoAux").val(),$("#txtCantidadAux").val())+'</td><td><button class="btn btn-xs btn-success" onclick="EditarMaterialCompra('+$("#idmaterial").val()+','+contTr+')" title="Editar" style="display:none;"><span class="glyphicon glyphicon-pencil" aria-hidden="true"></span></button><button class="btn btn-xs btn-danger" onclick="EliminarFila('+contTr+','+$("#idmaterial").val()+')" title="Eliminar"><span class="glyphicon glyphicon-remove"></span></button></td></tr>');
									$("#mostrarModalMateriales").val("");
									$("#txtCantidadAux").val("");
									$("#txtCostoAux").val("");
									montoTotal();
									calcularMonto();
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
					$('#listadoMaterialActivos  > tbody:last-child').append('<tr id="'+contTr+'"><td><input type="hidden" id="'+$("#idmaterial").val()+'" />'+$("#mostrarModalMateriales").val()+'</td><td><input type="hidden" class="inputNumerico form-control" value="'+$("#txtCostoAux").val()+'" onkeyup="calculoCostoTotalEditar('+contTr+')" />'+$("#txtCostoAux").val()+'</td><td>'+(calcularPrecioUSD($("#txtCostoAux").val()))+'</td><td><input type="hidden" id="cantidad'+contTr+'" class="form-control soloNumero" value="'+$("#txtCantidadAux").val()+'" onkeyup="calculoCostoTotalEditar('+contTr+');" />'+$("#txtCantidadAux").val()+'</td><td>'+calculoCostoTotal($("#txtCostoAux").val(),$("#txtCantidadAux").val())+'</td><td><button class="btn btn-xs btn-danger" onclick="EliminarFila('+contTr+','+$("#idmaterial").val()+')" title="Eliminar"><span class="glyphicon glyphicon-remove"></span></button></td></tr>');
					$("#mostrarModalMateriales").val("");
					$("#txtCantidadAux").val("");
					$("#txtCostoAux").val("");
					montoTotal();
					calcularMonto();
				}
			}else{
				swal("Error!", "Ya se excedio el monto de la factura.", "error");
			}			
		}else{
			swal("Error!", "Ya este material se encuentra en la lista.", "error");
		}
	}
}

function calcularPrecioUSD(punitario){
	var pu = parseFloat(punitario.replace(/\./g, '').replace(/\,/g, '.'));
	var tc = parseFloat($("#preciodolar").html());
	
	if($("#txtTasaCambio").val()!=""){
		tc = parseFloat($("#txtTasaCambio").val());
	}
	
	var valor = pu/tc;
	
	valor = valor.toString().replace(/\./g, ',');
	var resultado = formatMoneda(valor,',','.',2);
	return resultado;
}

function calculoCostoTotal(cantidad1,cantidad2){
	var num1 = cantidad1.replace(/\./g, '').replace(/\,/g, '.');
	var num2 = parseInt(cantidad2);
	//alert(num1+" x "+num2);
	var resultadoAux = num1*num2;
	//alert(resultadoAux);
	resultadoAux = resultadoAux.toString().replace(/\./g, ',');
	
	resultadoAux = formatMoneda(resultadoAux,',','.',2);
	//alert(resultadoAux);
	return resultadoAux;
}

function calculoCostoTotalEditar(id){
	var costoUnitario = $("#"+id).find('td').eq(1).find('input').val();
	costoUnitario = parseFloat(costoUnitario.replace(/\./g, '').replace(/\,/g, '.'));
	
	var tc = parseFloat($("#preciodolar").html());
	if($("#txtTasaCambio").val()!=""){
		tc = $("#txtTasaCambio").val();
	}
	var valorUSD = costoUnitario/tc;
	valorUSD = valorUSD.toString().replace(/\./g, ',');
	$("#"+id+" td:eq(2)").text(formatMoneda(valorUSD,',','.',2));
	
	
	var CantidadMateriales = $("#"+id).find('td').eq(3).find('input').val();
	CantidadMateriales = parseInt(CantidadMateriales);
	
	var costoTotal =  costoUnitario * CantidadMateriales;
	costoTotal = costoTotal.toString().replace(/\./g, ',');
	$("#"+id+" td:eq(4)").text(formatMoneda(costoTotal,',','.',2));
	montoTotal();
	calcularMonto();
}

function EliminarFila(index,idmaterial) {
    if($("#idcompra").val()!=""){
    	bloquearContainer();
    	$.post("./Compramaterial",{
        	operacion : OPERACION_ELIMINAR,
        	idmaterial : idmaterial,
        	idcompra : $("#idcompra").val()
        	}, function FuncionRecepcion(respuesta){
    			if(respuesta.valido){
    				swal("Eliminado!", respuesta.msj, "success");
    				 $("#"+index).remove();
    		    	 montoTotal();
    		    	 calcularMonto();
    			}else {
    				swal("Error!", respuesta.msj, "error");
    			}
				desbloquearContainer();
            });
    }else{
    	 $("#"+index).remove();
    	 montoTotal();
    	 calcularMonto();
    }
}

function montoTotal(){
	var resultado = 0;
	var iva = $("#txtIva").val();
	var subtotal = 0;
	$('#listadoMaterialActivos tbody tr').each(function() {
		var data =  $(this).find('td').eq(4).text();
  		resultado += parseFloat(data.replace(/\./g, '').replace(/\,/g, '.'));
    });
	
	if(iva!="" && iva!="0"){
		iva = parseFloat(iva/100);
		subtotal = resultado*iva;
		resultado += subtotal;
		//alert(iva+" * "+subtotal+" = "+resultado);
	}
	resultado = resultado.toString().replace(/\./g, ',');
	subtotal = subtotal.toString().replace(/\./g, ',');
	$("#txtTotaliva").val(formatMoneda(subtotal,',','.',2));
	$("#txtMontoTotalFactura").val(formatMoneda(resultado,',','.',2));
}

function calcularMonto(){
	var valor1 = $("#txtMontoTotalFactura").val();
	valor1 = parseFloat(valor1.replace(/\./g, '').replace(/\,/g, '.'));
	var valor2 = $("#txtMontofacturaAux").val();
	valor2 = parseFloat(valor2.replace(/\./g, '').replace(/\,/g, '.'));
	if(valor1 > valor2){
		$("#txtMontoTotalFactura").addClass("cantidadExeciva");
	}else{
		$("#txtMontoTotalFactura").removeClass("cantidadExeciva");
	}
}

function EditarMaterialCompra(idmaterial,idTr){
	var idcompra = $("#idcompra").val();
	var idmaterial = idmaterial;
	var costounitario = $("#costounitario"+idTr).val();
	var cantidad = $("#cantidad"+idTr).val();
	var costototal = $("#"+idTr+" td:eq(4)").text();
	bloquearContainer();
	$.post("./Compramaterial",{
	    	operacion : OPERACION_EDITAR,
	    	idmaterial : idmaterial,
	    	idcompra : idcompra,
	    	cantidad : cantidad,
	    	txttasacambio: $("#txtTasaCambio").val(),
	    	costounitario : costounitario,
	    	costototal : costototal
	    	}, 
	    	function FuncionRecepcion(respuesta) {
				if(respuesta.valido){
					swal("Editado!", respuesta.msj, "success");
				}else {
					swal("Error!", respuesta.msj, "error");
				}
				desbloquearContainer();
	        });
}

function consultarMaterial(nombreMaterial){
	
	//bloquearContainer();
	$.post("./Material",
			{
				operacion :OPERACION_CONSULTAR,
				nombreMaterial : MaysPrimera(nombreMaterial.toLowerCase()),
				condicion : 1
			},
			function FuncionRecepcion(respuesta) {
				if(respuesta.valido){
					$('#idmaterial').val("");
					$('#txtNombrematerial').val("");
					swal("Error!", "El material que intenta ingresar ya se encuentra registrado.", "error");
				}
				//desbloquearContainer();
			}).fail(function(response) {
			//desbloquearContainer();
			swal("Error!", "Error en el servidor, no hay respuesta valida.", "error");
	});	
	
}

function consultarRif2(value){
	//bloquearContainer();
	$.post("./Proveedor",
			{
				operacion :OPERACION_CONSULTAR,
				consultarRif : 1,
				rif : value
			},
	        function FuncionRecepcion(respuesta) {
				if(respuesta.valido){
					$('#idproveedor').val("");
					$('#txtNombreproveedor').val("");
					$('#txtRifproveedor').val("");
					$('#txtDireccionproveedor').val("");
					$('#txtDescripcionproveedor').val("");
					$('#txtTelefonoproveedor').val("");
					swal("Error!", "El proveedor que intenta ingresar ya se encuentra registrado.", "error");
				}
				//desbloquearContainer();
	        }
	).fail(function(response) {
		//desbloquearContainer();
		swal("Error!", "Error en el servidor, no hay respuesta valida.", "error");
	});
}

function guardarMaterial(){
	if($("#txtNombrematerial").val()!="" && $("#txtDescripcionmaterial").val()!="" && $('select[id=txtCategoria]').val()!=""){
		var materialCategoria = $('#txtCategoria').val();
		if($("#txtCategoriaAux").val()!=""){
			materialCategoria = MaysPrimera($('#txtCategoriaAux').val().toLowerCase());
		}
		//if($("#formulario input").validarCampos() && $("#formulario select").validarCampos()){
			bloquearContainer();
			$.post("./Material",
					{
						operacion : OPERACION_INCLUIR,
						txtNombre : MaysPrimera($('#txtNombrematerial').val().toLowerCase()),
						txtCategoria : materialCategoria,
						txtDescripcion :MaysPrimera($('#txtDescripcionmaterial').val().toLowerCase()),
						cmbEstatus : 1
					},
			        function FuncionRecepcion(respuesta) {
						if(respuesta.valido){
							$("#mostrarModalMateriales").val(respuesta.nombrematerial);
							$("#idmaterial").val(respuesta.idmaterial);
							$("#vModalNuevoMaterial").modal("hide");
						}else {
							swal("Error!", respuesta.msj, "error");					
						}
						desbloquearContainer();
			        }
			).fail(function(response) {
				desbloquearContainer();
				swal("Error!", "Error en el servidor, no hay respuesta valida.", "error");
			});
		//}
	}else{
		swal("Error!", "No debe dejar campos vacios.", "error");
	}
	
}

function guardarProveedor(){
	
	if($('#txtNombreproveedor').val()!="" && $('#txtRifproveedor').val()!="" && $('#txtDireccionproveedor').val()!="" && $('#txtDescripcionproveedor').val()!="" && $('#txtTelefonoproveedor').val()!="" ){
		bloquearContainer();
		$.post("./Proveedor",
				{
					operacion : OPERACION_INCLUIR,
					txtNombre : $('#txtNombreproveedor').val(),
					txtRif : $('#txtRifproveedor').val(),
					txtDireccion : $('#txtDireccionproveedor').val(),
					txtDescripcion : $('#txtDescripcionproveedor').val(),
					cmbEstatus : 1,
					txtTelefono : $('#txtTelefonoproveedor').val()					
				},
		        function FuncionRecepcion(respuesta) { //FALTA T5RAER LA RESPUESTA
					if(respuesta.valido){
						$("#idproveedor").val(respuesta.idproveedor);
						$("#txtRif").val(respuesta.rif);
						$("#txtNombre").val(respuesta.nombre);
						$("#txtDireccion").val(respuesta.direccion);
						$("#vModalNuevoProveedor").modal("hide");						
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
		swal("Error!", "No debe dejar campos vacios.", "error");
	}
}

function MaysPrimera(string){
	  return string.charAt(0).toUpperCase() + string.slice(1);
}
