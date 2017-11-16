function cargarConsultaPorRango(idcuadrilla,fechaDesde,fechaHasta){
	var cont = 0;
	$("#panelPrincipal").removeAttr("hidden");
	
	$.post('./Pago',{
		operacion: OPERACION_LISTADO,
		cargarConsultaPorRango : 1,
		idcuadrilla: idcuadrilla,
		fechaDesde: fechaDesde,
		fechaHasta: fechaHasta
	},
	function (json){
		if(json.valido){
			$("#idcuadrilla").val(idcuadrilla);
			var valor = json.data;			
			var cadena = valor.toString();
			var tabla = '';
			var tablaTrabajadores = '';
			var nombrecuadrilla = '';
			var rangofechas = '';
			for(var i=0 ; i < valor.length ; i++){
				cont++;
				var separado = valor[i].toString().split(",");
				tabla += '<tr id="tr'+cont+'"><td hidden="hidden">'+separado[0]+'</td><td>'+separado[1]+'</td><td>'+separado[2]+'</td><td>'+separado[3]+'</td><td id="costo'+cont+'">'+traerCosto(separado[5],separado[6],separado[7],cont)+'</td><td id="porcentaje'+cont+'">'+separado[4]+'%</td><td><input type="text"  class="inputNumerico form-control" id="resul'+cont+'" disabled></td><td><input type="checkbox" id="check'+cont+'" onclick="calcularPorcentaje('+separado[4]+','+cont+')"></td></tr>';
				nombrecuadrilla = separado[8];
				rangofechas = separado[9];
			}
			
			var trabajadores = json.dataCuadrilla;
			for(var i=0 ; i < trabajadores.length ; i++){
				var separado = trabajadores[i].toString().split(",");
				tablaTrabajadores += '<tr><td>'+separado[0]+'</td></tr>';
			}
			
			if(cont>0){				
				$('#ListadoInspeccionCheck tbody').html(tabla);
				$('#ListadoTrabajadores tbody').html(tablaTrabajadores);
				
			}else{
				$('#ListadoInspeccionCheck tbody').html("<tr><td colspan='6'><center>No se encontraron resultados</center></td></tr>" );
			}
			inputNumerico();
			$("#txtNombrecuadrillaAlert").val(nombrecuadrilla);
			$("#txtRangofechas").val(rangofechas);
			
        }
		desbloquearContainer();
	}); 
}

function generarPago(id){
	var cont = 0;
	//$("#panelPrincipal").hide();
	$("#panelSecundario").removeAttr("hidden");
	$.post('./Pago',{
		operacion: OPERACION_CONSULTAR,
		idpago: id,
		condicion:2
	},
	function FuncionRecepcion(respuesta) {
		if(respuesta.valido){
			$('#idpago').val(respuesta.idpago);
			$('#txtProyecto').val(respuesta.txtProyecto);
			$('#txtNombrecuadrilla').val(respuesta.txtNombrecuadrilla);
			$('#montoReferencial').val(respuesta.txtMontototal);
			traaerDetallePago(respuesta.idpago);
			traaerTrabajadoresCuadrilla(respuesta.idcuadrilla,respuesta.jefecuadrilla);
			
		}else {
			swal("Error!", respuesta.msj, "error");
		}
		desbloquearContainer();
    }).fail(function(response) {
		desbloquearContainer();
		swal("Error!", "Error en el servidor, no hay respuesta valida.", "error");
	});	 
}



function traerCosto(proyecto,tipoobra,detalleetapa,idTr){
	$.post("./Pago",
	{
		operacion :OPERACION_CONSULTAR,
		proyecto : proyecto,
		tipoobra : tipoobra,
		detalleetapa : detalleetapa,
		condicion : 1
	},
    function FuncionRecepcion(respuesta) {
		if(respuesta.valido){
			var resultadoAux = respuesta.costo.toString().replace(/\./g, ',');
			var resultado = formatMoneda(resultadoAux,',','.',2);
			$("#costo"+idTr).text(resultado);			
		}
    });
}

function calcularPorcentaje(porcentaje,idTr){
	var porcentaje = porcentaje;
	var costo = $("#costo"+idTr).text();
	var valor1 = parseFloat(costo.replace(/\./g, '').replace(/\,/g, '.'))/100;
	var resultado = parseInt(porcentaje)*valor1;
	if($("#check"+idTr).is(":checked")){
		$("#resul"+idTr).removeAttr("disabled");
		$("#resul"+idTr).val(formatMoneda(resultado,',','.',2));
		if($("#resul"+idTr).val()==""){
			$("#resul"+idTr).val("0,00");
		}
	}else{
		$("#resul"+idTr).val("");
		$("#resul"+idTr).attr("disabled",true);
	}	
}

function cargarSeleccion(){
	var cont = 0;
	var tabla = "";
	var montoTotal = 0;
	$('#ListadoInspeccionCheck input[type=checkbox]').each(function () {
		if($(this).is(':checked')){
			cont++;
			Inspeccion = $(this).parents("tr").find("td").eq(0).text();
			Obra = $(this).parents("tr").find("td").eq(1).text();
			Etapa = $(this).parents("tr").find("td").eq(2).text();
			Subetapa = $(this).parents("tr").find("td").eq(3).text();
			MontoPagar = $(this).parents("tr").find("td").eq(6).find('input').val();
			tabla+='<tr><td hidden="hidden">'+Inspeccion+'</td><td>'+Obra+'</td><td>'+Etapa+'</td><td>'+Subetapa+'</td><td>'+MontoPagar+'</td></tr>';
			montoTotal += parseFloat(MontoPagar.replace(/\./g, '').replace(/\,/g, '.'));
		}		
	});
	if(cont>0){
		$("#ListadoInspeccionSeleccionados tbody").html(tabla);
		$("#MontoTotal").text(formatMoneda(montoTotal,',','.',2));
	}else{
		$("#ListadoInspeccionSeleccionados tbody").html('<tr><td colspan="4"><center>No ha seleccionado ninguna inspecci&oacute;n para realizar pagos</center></td></tr>');
	}
}

function guardarPagoGenerado(){
	var fechaSistema = $("#txtFechaSistema").val();
	var montoTotal = $("#MontoTotal").text();
	var cuadrilla = $("#idcuadrilla").val();
	var inspeccionArreglo = new Array();
	var montoinspeccionArreglo = new Array();
	var listadoTrabajadores = new Array();
	$("#ListadoInspeccionSeleccionados tbody tr").each(function(){
		inspeccionArreglo.push($(this).find('td').eq(0).text());
		var costototal = $(this).find('td').eq(4).text();
		montoinspeccionArreglo.push(costototal.replace(/\./g, '').replace(/\,/g, '.'));
	});
	
	$("#ListadoTrabajadores tbody tr").each(function(){
		listadoTrabajadores.push($(this).find('td').eq(0).text());
	});
	$.post("./Pago",{
		operacion : OPERACION_INCLUIR,
		condicion : 1,
		fechaSistema: fechaSistema,
		montoTotal: montoTotal,
		cuadrilla: cuadrilla,
		ListaInspeccion : inspeccionArreglo.toString(),
		ListaMontoinspeccion : montoinspeccionArreglo.toString(),
		ListaTrabajadores: listadoTrabajadores.toString()
	},
	function FuncionRecepcion(respuesta) {
		if(respuesta.valido){
			swal("Guardado!", respuesta.msj, "success");
			if(respuesta.msj == 'Registro incluido con exito!'){
				setTimeout(function(){
					window.location.href = './addPago?id='+respuesta.pagoGenerado+'&formSecundario=1';
				}, 2000);
			}
		}else {
			swal("Error!", respuesta.msj, "error");
		}
		desbloquearContainer();
    });
}


function traaerDetallePago(id){
	var cont = 0;
	$.post('./Pago',{
		operacion: OPERACION_LISTADO,
		idpago : id,
		listadoDetalle : 1
	},
	function (json){
		if(json.valido){
			var valor = json.data;
			var cadena = valor.toString();
			var tabla = '';
			for(var i=0 ; i < valor.length ; i++){
				cont++;
				var separado = valor[i].toString().split(",");
				tabla += '<tr><td>'+separado[0]+'</td><td>'+separado[1]+'</td><td>'+separado[2]+'</td></tr>';
			}
			if(cont>0){				
				$('#tablaDetallePago tbody').html(tabla);
			}else{
				$('#tablaDetallePago tbody').html("<tr><td colspan='3'><center>No se encontraron resultados</center></td></tr>" );
			}
        }
		desbloquearContainer();
	}); 
}

function traaerTrabajadoresCuadrilla(id,jefecuadrilla){
	var cont = 0;
	$.post('./Cuadrilla',{
		operacion: OPERACION_LISTADO,
		idcuadrilla : id,
		desdePago : 2,
		idpago : $("#idpago").val()
	},
	function (json){
		if(json.valido){
			var valor = json.data;
			var cadena = valor.toString();
			var tabla = '';
			
			for(var i=0 ; i < valor.length ; i++){
				cont++;
				var separado = valor[i].toString().split(",");
				var modoPago = "";
				var boton = '<button type="button" class="btn btn-xs btn-success incluir" title="Pagar" onclick="pagarTrabajador('+separado[0]+','+separado[2]+','+separado[6]+');"><span class="glyphicon glyphicon-ok" ></span></button>';
				var botonAnular = '';
				if(separado[4] == "1"){
					modoPago = "Efectivo";
				}else if(separado[4] == "2"){
					modoPago = "Transferencia";
				}else if(separado[4] == "3"){
					modoPago = "Cheque";
				}
				
				if(separado[2] != "0"){
					var m = separado[2].replace(/\./g, '').replace(/\,/g, '.');
					boton = '<button type="button" class="btn btn-xs btn-primary" title="Ver" onclick="pagarTrabajador('+separado[0]+','+m+','+separado[6]+');"><span class="glyphicon glyphicon-search" ></span></button>';
					botonAnular = '<button class="btn btn-xs btn-danger eliminar" title="Deshacer Pago" onclick="anularPago('+separado[6]+');"><span class="glyphicon glyphicon-ban-circle"></span></button>';
				}
				var icono = '';
				if(jefecuadrilla==separado[1]){
					icono = ' <span class="glyphicon glyphicon-tag" title="Jefe de cuadrilla"></span>';
				}
				tabla += '<tr><td hidden="hidden">'+separado[0]+'</td><td>'+separado[1]+icono+'</td><td>'+separado[2]+','+separado[3]+'</td><td>'+modoPago+'</td><td>'+separado[5]+'</td><td>'+boton+botonAnular+'</td></tr>';
				
			}
			if(cont>0){
				$('#ListadoTrabajadorCuadrilla tbody').html(tabla);
				validarBotones("pago",$("#idUsuario").val(),"2");				
				var resultado = 0;
				$('#ListadoTrabajadorCuadrilla tbody tr').each(function() {
					var data =  $(this).find('td').eq(2).text();
			  		resultado += parseFloat(data.replace(/\./g, '').replace(/\,/g, '.'));
			    });
				resultado = resultado.toString().replace(/\./g, ',');
				$("#montoAcumulativo").val(formatMoneda(resultado,',','.',2));
				
				var monto1 = parseFloat($("#montoAcumulativo").val().replace(/\./g, '').replace(/\,/g, '.'));
				var monto2 = parseFloat($("#montoReferencial").val().replace(/\./g, '').replace(/\,/g, '.'));
				
				if(monto1 < monto2){
		    		$("#btnProcesarPago").attr("disabled", true);
		    	}else if(monto1 > monto2){		    		
		    		$("#btnProcesarPago").attr("disabled", true);
		    		$("#montoAcumulativo").addClass("error");
		    	}else{
		    		$("#btnProcesarPago").removeAttr("disabled");
		    	}
				
			}else{
				$('#ListadoTrabajadorCuadrilla tbody').html("<tr><td colspan='3'><center>No se encontraron resultados</center></td></tr>" );
			}
			
			inputNumerico();
			soloNumero();
        }
		desbloquearContainer();
	}); 
}

function pagarTrabajador(idtrabajadorcuadrilla,monto,iddetallepagotrabajador){
	
	if(monto==0){
		var idcuadrilla = $("#idcuadrilla").val();
		var monto = $("#montoReferencial").val();
		monto = parseFloat(monto.replace(/\./g, '').replace(/\,/g, '.'));
		
		var nroTrabajadores = $("#ListadoTrabajadorCuadrilla tr").length -1;
		var montoPagar = monto/nroTrabajadores;
		montoPagar = montoPagar.toString().replace(/\./g, ',');
		$.post("./Trabajador",{
				operacion: OPERACION_CONSULTAR,
				idtrabajadorcuadrilla: idtrabajadorcuadrilla,
				desdePago : 1
			},
			function FuncionRecepcion(respuesta) {
				if(respuesta.valido){
					$('#txtBanco').val(respuesta.banco);
					$('#txtTitularcuenta').val(respuesta.titular);
					$('#txtNrocuenta').val(respuesta.numerocuenta);
					$('#idtrabajadorcuadrilla').val(respuesta.idtrabajadorcuadrilla);
					
					$('#txtNombreTitularAux').val(respuesta.titularNombreAux);
					$('#txtCedulaTitularAux').val(respuesta.titularCedulaAux);
				}else {
					swal("Error!", respuesta.msj, "error");
				}
				desbloquearContainer();
		    }).fail(function(response) {
				desbloquearContainer();
				swal("Error!", "Error en el servidor, no hay respuesta valida.", "error");
		});
		
		//alert(formatMoneda(montoPagar,',','.',2));
		$("#ListadoTrabajadorCuadrilla tbody").on( 'click','button', function () {
		  	if($(this).hasClass('btn-success')){
		  		$("#txtTrabajador").val($(this).parents("tr").find("td").eq(1).text());
		  		$("#txtMontoCancelar").val(formatMoneda(montoPagar,',','.',2));
		  		$("#vModalPago").modal("show");
		  	}
		});
	}else{
		$.post("./Pago",{
			operacion: OPERACION_CONSULTAR,
			iddetallepagotrabajador: iddetallepagotrabajador,
			condicion : 3
		},
		function FuncionRecepcion(respuesta) {
			if(respuesta.valido){
				$("#vModalPago").modal("show");
				$('#txtBanco').val(respuesta.banco);
				$('#txtTitularcuenta').val(respuesta.titular);
				$('#txtNrocuenta').val(respuesta.nrocuenta);
				$('#idtrabajadorcuadrilla').val(respuesta.idtrabajadorcuadrilla);
				$('#txtNroreferencia').val(respuesta.referencia).attr("disabled", true);
				$('#txtMontoCancelar').val(respuesta.txtMontototal).attr("disabled", true);
				$('#txtTrabajador').val(respuesta.nombretrabajador);
				
				$('#txtNrocheque').val(respuesta.referencia).attr("disabled", true);
				
				////////////////////////////////////////////////////////////////////////////
				$("#txtCedulatitularcheque").val(respuesta.cedulacheque).attr("disabled", true);
				$("#txtNombretitularcheque").val(respuesta.nombrecheque).attr("disabled", true);
				$("#txtNrocheque").val(respuesta.referencia).attr("disabled", true);
				$('#txtBancocheque').val(respuesta.banco).attr("disabled", true);
				$('#txtObservacion').val(respuesta.observacion).attr("disabled", true);
				////////////////////////////////////////////////////////////////////////////
				$("#btnGuardarPagoTrabajador").attr("disabled", true);
				if(respuesta.modopago=="2"){
					$('select[id=txtModoPago]').val('2').attr("disabled", true);
					$("#rowTransferencia").show();
					$("#rowCheque").hide();		
					$("#txtNroreferencia").focus();
				}				
				
				if(respuesta.modopago == "3"){
					$('select[id=txtModoPago]').val('3').attr("disabled", true);
					$("#rowCheque").show();
					$("#rowTransferencia").hide();
				}
				
				if(respuesta.modopago != "2" && respuesta.modopago != "3"){
					$('select[id=txtModoPago]').val('1').attr("disabled", true);
					$("#rowTransferencia").hide();
					$("#rowCheque").hide();
				}
			}else {
				swal("Error!", respuesta.msj, "error");
			}
			desbloquearContainer();
	    }).fail(function(response) {
			desbloquearContainer();
			swal("Error!", "Error en el servidor, no hay respuesta valida.", "error");
	    });
	}
	
}



function seleccionarModoPago(){
	var valorSelect = $('select[id=txtModoPago]').val();
	//alert(valorSelect);
	if(valorSelect == "2"){
		$("#rowTransferencia").show();
		$("#rowCheque").hide();	
		$("#txtNroreferencia").val("");
		$("#txtNroreferencia").focus();
	}
	
	if(valorSelect == "3"){
		$("#rowCheque").show();
		$("#rowTransferencia").hide();
	}
	
	if(valorSelect != "2" && valorSelect != "3"){
		$("#rowTransferencia").hide();
		$("#rowCheque").hide();
	}
}

function guardarPagoTrabajador(){
	var valorSelect = $('select[id=txtModoPago]').val();
	var correcto = true;
	if(valorSelect!="0"){
		
		var cedulatitular = $("#txtCedulaTitularAux").val();
		var nombretitular = $("#txtNombreTitularAux").val();
		var referencia = $("#txtNroreferencia").val();
		var banco = $("#txtBanco").val();
		
		if(valorSelect=="3"){
			cedulatitular = $("#txtCedulatitularcheque").val();
			nombretitular = $("#txtNombretitularcheque").val();
			referencia = $("#txtNrocheque").val();
			banco = $("#txtBancocheque").val();
			
			if(cedulatitular == ''){
				correcto = false;
			}
			
			if(nombretitular == ''){
				correcto = false;
			}
			
			if(referencia == ''){
				correcto = false;
			}
			
			if(banco == ''){
				correcto = false;
			}
		}
		
		if(valorSelect=="2"){			
			if(referencia == ''){
				correcto = false;
			}
		}
		
		if(valorSelect=="1"){
			cedulatitular = "N/A";
			nombretitular = "N/A";
			referencia = "N/A";
			banco = "N/A";
		}
		
		if(!correcto){
			swal("Error!", "Ninguno de los compos debe quedar en blanco.", "error");
		}else{
			$.post("./Pago",{
				operacion : OPERACION_EDITAR,
				condicion : 1,
				fechaSistema: $("#txtFechaSistema").val(),
				idpago : $("#idpago").val(),
				idtrabajadorcuadrilla: $("#idtrabajadorcuadrilla").val(),
				monto: $("#txtMontoCancelar").val(),
				banco: banco,
				referencia: referencia,
				nrocuenta: $("#txtNrocuenta").val(),
				modopago : $("#txtModoPago").val(),
				cedulatitular : cedulatitular,
				nombretitular : nombretitular,
				observacion : $("#txtObservacion").val()
			},
			function FuncionRecepcion(respuesta) {
				if(respuesta.valido){
					swal("Guardado!", respuesta.msj, "success");
					if(respuesta.msj == 'Registro editado con exito!'){
						setTimeout(function(){
							window.location.href = './addPago?id='+$("#idpago").val()+'&formSecundario=1';
						}, 2000);
					}
				}else {
					swal("Error!", respuesta.msj, "error");
				}
					desbloquearContainer();
		    	});	
		}
	}else{
		swal("Error!", "Debe seleccionar un modo de pago.", "error");
	}
	
	
	
}

function anularPago(iddetallepagotrabajador){
	swal({
        title: "Desea deshacer el pago?",
        type: "warning",   
        showCancelButton: true,   
        confirmButtonColor: "#DD6B55",   
        confirmButtonText: "Si, deshacer",   
        cancelButtonText: "No, cancelar",   
        closeOnConfirm: false,   
        closeOnCancel: true,
        showLoaderOnConfirm: true
    }, function(isConfirm){   
        if (isConfirm) { 
        	//llamar al servidor y eliminar
        	$.post("./Pago",
        			{
        				operacion :OPERACION_EDITAR,
        				anular : 1,
        				iddetallepagotrabajador : iddetallepagotrabajador,
        				idpago : $("#idpago").val()
        				
        			},
        	        function FuncionRecepcion(respuesta) {
        				if(respuesta.valido){
        					swal("Anulado!", respuesta.msj, "success");
        					window.location.href = './addPago?id='+$("#idpago").val()+'&formSecundario=1';
        				}else {
        					swal("Error!", respuesta.msj, "error");
        				}
        	        }
        	).fail(function(response) {
        		swal("Error!", "Error en el servidor, no hay respuesta valida.", "error");
        	});
        } 
    });
}

function procesarPago(){
	swal({
        title: "Desea procesar el pago?",
        type: "warning",   
        showCancelButton: true,   
        confirmButtonColor: "#DD6B55",   
        confirmButtonText: "Si, procesar",   
        cancelButtonText: "No, cancelar",   
        closeOnConfirm: false,   
        closeOnCancel: true,
        showLoaderOnConfirm: true
    }, function(isConfirm){   
        if (isConfirm) { 
        	//llamar al servidor y eliminar
        	$.post("./Pago",
        			{
        				operacion :OPERACION_EDITAR,
        				idpago : $("#idpago").val(),
        				fechasistema : $("#txtFechaSistema").val()
        			},
        	        function FuncionRecepcion(respuesta) {
        				if(respuesta.valido){
        					swal("Anulado!", respuesta.msj, "success");
        					window.location.href = './addPago?id='+$("#idpago").val();
        				}else {
        					swal("Error!", respuesta.msj, "error");
        				}
        	        }
        	).fail(function(response) {
        		swal("Error!", "Error en el servidor, no hay respuesta valida.", "error");
        	});
        } 
    });
}

function soloConsultar(id){
	//$("#panelPrincipal").hide();
	$("#panelSecundario").hide();
	$("#panel3").removeAttr("hidden");
	
	$.post("./Pago",{
		operacion : OPERACION_CONSULTAR,
		idpago : id,
		condicion : 2
	},
	function FuncionRecepcion(respuesta) {
		if(respuesta.valido){
			$("#spanNropago").text(respuesta.idpago);
			$("#spanProyecto").text(respuesta.txtProyecto);
			$("#spanCuadrilla").text(respuesta.txtNombrecuadrilla);
			$("#spanMonto").text(respuesta.txtMontototal);
			$("#spanFechaprocesado").text(respuesta.fechapago);
			$("#spanJefecuadrilla").text(respuesta.jefecuadrilla);	
			traaerDetallePagoPanel3(id);
			traaerDetallePagoCuadrillaPanel3(id,respuesta.jefecuadrilla);
		}else {
			swal("Error!", respuesta.msj, "error");
		}
		desbloquearContainer();
    }).fail(function(response) {
		desbloquearContainer();
		swal("Error!", "Error en el servidor, no hay respuesta valida.", "error");
    });
}

function traaerDetallePagoPanel3(id){
	var cont = 0;
	$.post('./Pago',{
		operacion: OPERACION_LISTADO,
		idpago : id,
		listadoDetalle : 1
	},
	function (json){
		if(json.valido){
			var valor = json.data;
			var cadena = valor.toString();
			var tabla = '';
			for(var i=0 ; i < valor.length ; i++){
				cont++;
				var separado = valor[i].toString().split(",");
				tabla += '<tr><td>'+separado[0]+'</td><td>'+separado[1]+'</td><td>'+separado[2]+'</td><td>'+separado[3]+'%</td><td>'+separado[4]+'</td></tr>';
			}
			if(cont>0){				
				$('#ListadoDetalleInspeccion tbody').html(tabla);
			}else{
				$('#ListadoDetalleInspeccion tbody').html("<tr><td colspan='5'><center>No se encontraron resultados</center></td></tr>" );
			}
        }
		desbloquearContainer();
	});
}

function traaerDetallePagoCuadrillaPanel3(id,jefecuadrilla){
	var cont = 0;
	$.post('./Pago',{
		operacion: OPERACION_LISTADO,
		idpago : id,
		listadoDetalle : 2
	},
	function (json){
		if(json.valido){
			var valor = json.data;
			var cadena = valor.toString();
			var tabla = '';
			for(var i=0 ; i < valor.length ; i++){
				cont++;
				var separado = valor[i].toString().split(",");
				if(separado[3]=="1"){
					separado[3] = 'Efectivo';
				}else if(separado[3]=="2"){
					separado[3] = 'Transferencia';
				}else if(separado[3]=="3"){
					separado[3] = 'Cheque';
				}
				var referencia = separado[5].split(" ");
				if(referencia[0] == "N/A" ){
					separado[5] = "N/A";
				}
				if(referencia[0] == "null" ){
					separado[5] = "";
				}
				var icono = '';
				if(jefecuadrilla==separado[0]){
					icono = ' <span class="glyphicon glyphicon-tag" title="Jefe de cuadrilla"></span>';
				}
				tabla += '<tr><td>'+separado[0]+icono+'</td><td>'+separado[1]+','+separado[2]+'</td><td>'+separado[3]+'</td><td>'+separado[4]+'</td><td>'+separado[5]+'</td><td>'+separado[6]+'</td></tr>';
			}
			if(cont>0){				
				$('#ListadoDetalleCuadrilla tbody').html(tabla);
			}else{
				$('#ListadoDetalleCuadrilla tbody').html("<tr><td colspan='5'><center>No se encontraron resultados</center></td></tr>" );
			}
        }
		desbloquearContainer();
	}); 
}











