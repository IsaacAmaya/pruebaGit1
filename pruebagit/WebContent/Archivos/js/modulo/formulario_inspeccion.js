function cargarInspeccion(id){
	$("#panelPrincipal").css("display","none");
	$("#panelSecundario").removeAttr("hidden");
	$.post("./Inspeccion",
			{
				operacion :OPERACION_CONSULTAR,
				idinspeccion: id
			},
	        function FuncionRecepcion(respuesta){
				if(respuesta.valido){
					$('#txtNombreproyecto').val(respuesta.nombreproyecto);
					$('#txtNombreobra').val(respuesta.nombreobra);
					$('#txtNombreetapa').val(respuesta.nombreetapa);
					$('#txtNombresubetapa').val(respuesta.nombresubetapa);
					$('#txtFechainspeccionS').val(respuesta.fechainspeccion);
					$('#txtPorcentaje').val(respuesta.porcentaje);
					$('#txtObservacionS').val(respuesta.observacion);
					
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

function guardarInspeccion(){
	var idproyecto =  $("#idproyecto").val();
	var idobra = $("#idobra").val();
	var iddetalleetapa = $("#iddetalleetapa").val();
	var fecha = $("#txtFechainspeccion").val();
	var idcuadrilla = $("#idcuadrilla").val();
	var op = OPERACION_INCLUIR;
	$.post("./Inspeccion",
			{
				operacion : op,
				idobra : idobra,
				iddetalleetapa: iddetalleetapa,
				idproyecto : idproyecto,
				idcuadrilla : idcuadrilla,
				fecha : fecha,
				observacion : $("#txtObservacion").val(),
				progreso : $("#txtProgreso").val()
			},
	        function (respuesta){
				if(respuesta.valido){
					swal("Guardado!", respuesta.msj, "success");
					if(respuesta.msj == 'Registro incluido con exito!'){
						setTimeout(function(){
    						window.location.href = "./inspeccion?Proyecto="+$("#Proyecto").val()+"&Obra="+$("#Obra").val()+"&Etapa="+$("#Etapa").val()+"&filtradoInspeccion=1";
    					}, 2000);
					}
				}else {
					swal("Error!", respuesta.msj, "error");
				}
	        }
	).fail(function(response) {
		swal("Error!", "Error en el servidor, no hay respuesta valida.", "error");
	});
	
}

function cargarDetalleInspeccion(){
	$('#txtProyectoAux2').val($('#txtProyecto').val());
	$('#txtObraAux2').val($('#txtObra').val());
	$('#txtEtapaAux2').val($('#txtEtapa').val());
	$('#txtSubetapaAux2').val($('#txtSubetapa').val());
	var restante = 100;
	$.post('./Inspeccion',{
		operacion: OPERACION_LISTADO,
		idproyecto : $("#idproyecto").val(),
		idtipoobra : $("#idtipoobra").val(),
		idobra : $("#idobra").val(),
		iddetalleetapa : $("#iddetalleetapa").val(),
		desdeInspeccion : 1
	},
	function (json){
		if(json.valido){
			var valor = json.data;
			var tabla = '';
			var cont = 0;
			var valorPorcentaje = 0;
			for(var i=0 ; i < valor.length ; i++){
				cont++;
				var separado = valor[i].toString().split(",");				
				tabla += '<tr><td>'+separado[0]+'</td><td>'+separado[1]+'%</td><td>'+separado[2]+'</td></tr>';
				valorPorcentaje = separado[4];
			}
			if(valorPorcentaje == 100){
				$( "#slider" ).slider( "option", "disabled", true );
			}else{
				$( "#slider" ).slider( "option", "disabled", false );
			}
			var pb = $("#pb1").data('progress');
			$("#porcentajeMostrar").text(valorPorcentaje+"%");
		    pb.set(valorPorcentaje);
		    restante = restante - valorPorcentaje;
		    $( "#slider" ).slider( "option", "value", 0 );
			$( "#slider" ).slider( "option", "max", restante );
			$( "#txtProgreso" ).val(0);
			
			if(cont>0){
				$('#listadoSubetapas tbody').html(tabla);
			}else{
				$('#listadoSubetapas tbody').html("<tr><td colspan='3'><center>No hay inspecciones realizadas</center></td></tr>");
			}
        }
	});
}

function abrirModalInspeccion(id){
	$("#iddetalleetapaAux").val(id);
	$("#vModalAgregarInspeccion").modal("show");
	
	$.post('./Inspeccion',{
		operacion: OPERACION_CONSULTAR,
		idproyecto : $("#idproyecto").val(),
		idobra : $("#idobra").val(),
		iddetalleetapa : id,
		idproyecto : $("#idproyecto").val(),
		condicion : 1
	},
	 function FuncionRecepcion(respuesta) {
			if(respuesta.valido){
				$('#txtProgreso').val(respuesta.porcentaje);									
			}else {
				$('#txtProgreso').val("0");
			}
			desbloquearContainer();			
		});
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

function cargarListadoCuadrilla(){
	if(!tablaListadoCuadrilla){ //verifica que la tabla sea nula
		//se inicializa la tabla
		tablaListadoCuadrilla = $('#ListadoCuadrilla').DataTable( {
			responsive: true,
	        "language": {
	            "url": "Archivos/js/Spanish.lang"
	        },
	        "pagingType": "simple",

	        "ajax": {
	        	"url": "./Cuadrilla?operacion="+OPERACION_LISTADO,
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
		
		$('#ListadoCuadrilla tbody').on('click', 'tr', function () {
	        var data = tablaListadoCuadrilla.row( this ).data();
	        $('#idcuadrilla').val(data[0]);
	        $('#txtCuadrilla').val(data[1]);
	        $('#vModalListadoCuadrilla').modal('hide');
	    } );
	}
}
