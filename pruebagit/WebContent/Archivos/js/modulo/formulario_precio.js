function cargarPrecio(id){
	$.post("./Precio",{
		idproyecto:id,
		operacion:OPERACION_LISTADO
		},
		function(json){
			if(json.valido){
				var valor = json.data;
				var lista = '';
				var nombreproyecto = '';
				for(var i=0 ; i < valor.length ; i++){
					var separado = valor[i].toString().split(",");
					nombreproyecto = separado[2];
					lista +=
				  		'<input type="hidden" id="'+separado[0]+'" /><div class="panel panel-default"><div class="panel-heading"><a class="btn-block" data-toggle="collapse" data-parent="#acordionTipoobra" onclick="traerEtapas('+i+','+separado[0]+')" href="#tipoobra'+i+'"><h4 class="panel-title">'+separado[1]+'</h4></a></div>'+
				  		'<div id="tipoobra'+i+'"  class="panel-collapse collapse"></div></div>';
				}
				$("#acordionTipoobra").html(lista);
				$("#txtProyecto").html(nombreproyecto);
				$("#idproyecto").val(id);
				soloNumero();
			}
	});
}

function cargarListadoProyecto(){
	
	if(!tablaListadoProyecto){ //verifica que la tabla sea nula
		//se inicializa la tabla
		tablaListadoProyecto = $('#ListadoProyecto').DataTable( {
			responsive: true,
	        "language": {
	            "url": "Archivos/js/Spanish.lang"
	        },
	        "ajax": {
	        	"url": "./Proyecto?operacion="+OPERACION_LISTADO,
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
		
		$('#ListadoProyecto tbody').on('click', 'tr', function () {
	        var data = tablaListadoProyecto.row( this ).data();
	        $('#idproyecto').val(data[0]);
	        $('#txtProyecto').val(data[1]);
	        traerTipoobra(data[0]);
	        $('#vModalListadoProyecto').modal('hide');
	    });
	}
	
}

function traerTipoobra(e){
	var idproyecto = e;
	$.post("./Obra",{
		idproyecto:idproyecto,
		operacion:OPERACION_LISTADO,
		desdePrecio:1
		},
		function(json){
			if(json.valido){
				var valor = json.data;
				var lista = '';
				for(var i=0 ; i < valor.length ; i++){
					var separado = valor[i].toString().split(",");
					lista +=
				  		'<input type="hidden" id="'+separado[0]+'" /><div class="panel panel-default"><div class="panel-heading"><a class="btn-block" data-toggle="collapse" data-parent="#acordionTipoobra" onclick="traerEtapas('+i+','+separado[0]+')" href="#tipoobra'+i+'"><h4 class="panel-title">'+separado[1]+'</h4></a></div>'+
				  		'<div id="tipoobra'+i+'"  class="panel-collapse collapse"></div></div>';
				}
				$("#acordionTipoobra").html(lista);
				soloNumero();
			}
	});
}

var cont=+1;

function traerEtapas(idDiv,idtipoobra){
	$("#listadoSubetapasActivos tbody").html("");
	$("#idtipoobra").val(idtipoobra);
	$.post('./Materialporobra',{
		operacion:OPERACION_LISTADO,
		idtipoobra:idtipoobra,
		desdePrecio : 1
	},
	function(json){
		if(json.valido){
			var valor = json.data;
			var listado ='';
			for(var j=0 ; j < valor.length ; j++){
				cont++;
				var separado = valor[j].toString().split(",");
				listado += '<ul class="list-group lista"><li><a onclick="addclase(this.id,'+separado[0]+')"  id="'+j+cont+'"><span class="glyphicon glyphicon-edit" aria-hidden="true"></span>  '+separado[1]+'</a></li></ul>';
				
			}
			$("#tipoobra"+idDiv).html(listado);
		}
	});
}

function addclase(idA,idetapa){
	var valor=idA;
	var contTr = 0;
	var idetapa = idetapa;
	var idproyecto = $("#idproyecto").val();
	var idtipoobra = $("#idtipoobra").val();
	$("#listadoSubetapasActivos tbody").html("");//QUITAR SI PRESENTA BORRADO DE MATERIALES YA AGREGADO A MATERIALPOROBRA
	contTr = $('#listadoSubetapasActivos tr').length;
	$("#idetapa").val(idetapa);
	$("#idLista").val(valor);
	
	//alert($("#idetapa").val());
	$(".lista a").each(function(){
		$(this).removeClass("activado");
	});	
	$("#"+valor).addClass("activado");
	
	$.post("./Detalleetapa",{
			operacion: OPERACION_LISTADO,
			idetapa: idetapa,
			desdePrecio : 1,
			idproyecto : idproyecto,
			idtipoobra : idtipoobra
		},
		function(json){
			if(json.valido){
				var valor = json.data;
				//var valor2 = json.data2;
				var tabla = "";
				for(var i=0 ; i < valor.length ; i++){
					var separado = valor[i].toString().split(",");
					//alert(separado[3]);
					var condicion = 'Guardar';
					if(separado[3] !=0){
						condicion = 'Editar';
					}
					var precioSubetapa = formatMoneda(separado[2],',','.',2);
					tabla += '<tr><td>'+separado[1]+'</td><td><input type="text" class="form-control inputNumerico incluir" id="precio'+contTr+'" value="'+precioSubetapa+'" /></td><td><button class="btn btn-xs btn-success incluir" onclick="GuardarPrecioSubetapa('+contTr+','+separado[0]+','+"'"+condicion+"'"+')" title="Editar"><span class="glyphicon glyphicon-pencil" aria-hidden="true"></span></button></td></tr>';
					contTr++;
				}
				
				/*for(var i=0 ; i < valor2.length ; i++){
					var separado = valor2[i].toString().split(",");
					tabla += '<tr><td>'+separado[1]+'</td><td><input type="text" class="form-control inputNumerico" id="precio'+contTr+'" value="'+separado[2]+'" /></td><td><button class="btn btn-xs btn-success" onclick="GuardarPrecioSubetapa('+contTr+','+separado[0]+','+"'Guardar'"+')" title="Editar"><span class="glyphicon glyphicon-pencil" aria-hidden="true"></span></button></td></tr>';
					contTr++;
				}*/
				
				if(contTr > $('#listadoSubetapasActivos tr').length){
					$('#listadoSubetapasActivos tbody').html(tabla);
					validarBotones("precio",$("#idUsuario").val(),"2");
				}
				inputNumerico();
			}
	});
}

function GuardarPrecioSubetapa(idTr,iddetalleetapa,funcion){
	
	var tr = idTr;
	var op = OPERACION_INCLUIR;
	var iddetalleetapa = iddetalleetapa;
	if(funcion == "Editar"){
		op = OPERACION_EDITAR;
	}
	$.post("./Precio",
			{
				operacion : op,
				idtipoobra : $("#idtipoobra").val(),
				iddetalleetapa: iddetalleetapa,
				idproyecto : $("#idproyecto").val(),
				precio : $("#precio"+idTr).val()
			},
	        function (respuesta){
				if(respuesta.valido){
					swal("Guardado!", respuesta.msj, "success");
					addclase($("#idLista").val(),$("#idetapa").val());
				}else {
					swal("Error!", respuesta.msj, "error");
				}
	        }
	).fail(function(response) {
		swal("Error!", "Error en el servidor, no hay respuesta valida.", "error");
	});
}

function consultarPrecio(id,idproyecto,idtipoobra,iddetalleetapa){
	$.post("./Precio",
			{
				operacion :OPERACION_CONSULTAR,
				idtipoobra : idtipoobra,
				idproyecto : idproyecto,
				iddetalleetapa : iddetalleetapa
			},
	        function (respuesta) {
				if(respuesta.valido){
					$("#precio"+id).val(respuesta.costo);
				}else{
					$("#precio"+id).val("0.00");
				}
	        });
}





