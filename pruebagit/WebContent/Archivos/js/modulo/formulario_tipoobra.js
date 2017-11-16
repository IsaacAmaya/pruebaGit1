function cargarTipoobra(id){
	bloquearContainer();
	
	$.post("./Tipoobra",
			{
				operacion :OPERACION_CONSULTAR,
				idtipoobra : id            			
			},
	        function FuncionRecepcion(respuesta) {
				if(respuesta.valido){
					$('#idtipoobra').val(respuesta.idtipoobra);
					$('#txtNombre').val(respuesta.txtNombre);
					$('#txtDescripcion').val(respuesta.txtDescripcion);
					$('#txtMontoobra').val(respuesta.txtMontoobra);
					$('#txtMontomanoobra').val(respuesta.txtMontomanoobra);
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

function consultarTipoobra(value){
	bloquearContainer();	
	$.post("./Tipoobra",
			{
				operacion :OPERACION_CONSULTAR,
				consultarTipoobra : 1,
				nombre : value
			},
	        function FuncionRecepcion(respuesta) {
				if(respuesta.valido){
					$('#idtipoobra').val(respuesta.idtipoobra);
					$('#txtNombre').val(respuesta.txtNombre);
					$('#txtDescripcion').val(respuesta.txtDescripcion);
					$('#txtMontoobra').val(respuesta.txtMontoobra);
					$('#txtMontomanoobra').val(respuesta.txtMontomanoobra);
					$('#cmbEstatus').val(respuesta.cmbEstatus);					
				}
				desbloquearContainer();
	        }
	).fail(function(response){
		desbloquearContainer();
		swal("Error!", "Error en el servidor, no hay respuesta valida.", "error");
	});
}

function guardarTipoobra(){
	var op = OPERACION_INCLUIR;
	if($("#idtipoobra").val()!=''){
		op = OPERACION_EDITAR;
	}
	
	var listaAEnviar = new Array();
	
	$("#listadoMaterialActivos tbody tr").each(function() {
			listaAEnviar.push($(this).attr('id'));
	});
	if($("#formulario input").validarCampos() && $("#formulario select").validarCampos()){
		bloquearContainer();
		$.post("./Tipoobra",
				{
					operacion : op,
					idtipoobra : $("#idtipoobra").val(),
					iddetalleetapa: $("#iddetalleetapa").val(),
					txtNombre : $("#txtNombre").val(),
					txtDescripcion : $("#txtDescripcion").val(),
					txtMontoobra : $("#txtMontoobra").val(),
					txtMontomanoobra : $("#txtMontomanoobra").val(),
					cmbEstatus : $("#cmbEstatus").val(),
					listaMaterial: listaAEnviar.toString()
					
				},
		        function FuncionRecepcion(respuesta) {
					if(respuesta.valido){
						$("#idtipoobra").val(respuesta.idTipoobra);
						swal("Guardado!", respuesta.msj, "success");
						/*if(respuesta.msj == 'Registro incluido con exito!'){
							setTimeout(function(){
	    						window.location.href = './tipoobra';
	    					}, 2000);
						}*/
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

function cargarListadoEtapa(){
	if(!tablaListadoEtapa){
		tablaListadoEtapa = $('#ListadoEtapa').DataTable( {
			responsive: true,
	        "language": {
	            "url": "Archivos/js/Spanish.lang"
	        },
	        "lengthMenu": [[5], [5]],
	        "pagingType": "simple",
	        "ajax": {
	        	"url": "./Etapa?operacion="+OPERACION_LISTADO,
	        	"dataSrc": function ( json ) {
	                if(json.valido){
	                	return json.data;
	                }else {
						alert(json.msj);
	                }
	            }
	        },
	        "columnDefs": [{
	            "targets": -1,
	            "data": null,
	            "defaultContent": ''+
	        	'<label class="custom-control custom-checkbox"><input type="checkbox" class="custom-control-input"></label>'+	        	
	        	''
	        	},
	        	{
	                "targets": [ 0 ],
	                "visible": false,
	                "searchable": false
	            }
	        ],
	        "fnDrawCallback": function( oSettings ) {
	        	$("#acordion input").each(function(index){
	        		var idTmp  = $(this).attr("id");	
	        		$('#ListadoEtapa tbody input').each(function() {
	        			var data = tablaListadoEtapa.row( $(this).parents('tr') ).data();
	        	  		var id = data[0];
	        	  		if(idTmp==id){	        	  			
	        	  			$(this).attr('checked', true);
	        	  		}
	        	    });	        		
	        	}); 
	        }
	     });
	}
}

function EliminarFila(index,id) {//ELIMINA DIRECTAMENTE DE LA BASE DE DATOS

	bloquearContainer();
    $.post("./Materialporobra",{
    	operacion : OPERACION_ELIMINAR,
    	idmaterial : id,
    	iddetalleetapa : $("#iddetalleetapa").val()
    	}, function FuncionRecepcion(respuesta) {
			if(respuesta.valido){
				swal("Eliminado!", respuesta.msj, "success");
				$('#'+index).remove();
			}else {
				swal("Error!", respuesta.msj, "error");
			}
			desbloquearContainer();
        });
    
    var contTr = 0;
	contTr = $('#listadoMaterialActivos tr').length;
	if(contTr == 2){
		bloquearContainer();
		$.post("./Materialporobra",{
	    	operacion : OPERACION_LISTADO_MATERIALPOROBRA,
	    	idtipoobra : $("#idtipoobra").val(),
	    	idetapa : $("#idEtapaAux").val()
	    	},
	    	 function FuncionRecepcion(respuesta) {
				if(respuesta.valido){
					if(respuesta.contador <= 1){
						cargarDetalleTipoobra();
					}else{
						$("#listadoMaterialActivos tbody").html("<tr id='mensaje'><td colspan='3'><center><h4 style='color:#CCC;'>Sin materiales asignados.</h4></center></td></tr>");
					}
				}else {
					swal("Error!", respuesta.msj, "error");					
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
	        "lengthMenu": [[5], [5]],
	        "pagingType": "simple",
	        "ajax": {
	        	"url": "./Material?operacion="+OPERACION_LISTADO/*+"&desdetipoobra=1&iddetalleetapa="+$("#iddetalleetapa").val()*/,
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
	        $('#vModalListadoMaterial').modal('hide');
	        $("#txtCantidad").focus();	        
	    });
	}
}

function guardarMaterialporobra(){
	if($("#mostrarModalMateriales").val()!=""){
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
			bloquearContainer();
			$.post("./Materialporobra",
					{
						operacion : OPERACION_INCLUIR,
						idtipoobra : $("#idtipoobra").val(),
						iddetalleetapa: $("#iddetalleetapa").val(),
						idmaterial : $("#idmaterial").val(),
						cantidadestimada : $("#txtCantidad").val()
					},
			        function (respuesta){
						if(respuesta.valido){
							
							$('#listadoMaterialActivos  > tbody:last-child').append('<tr id="'+contTr+'"><input type="hidden" id="'+$("#idmaterial").val()+'" /><td>'+$("#mostrarModalMateriales").val()+'</td><td><input type="hidden" id="cantidad'+contTr+'" class="form-control soloNumero" style="width:120px" value='+$("#txtCantidad").val()+' />'+$("#txtCantidad").val()+'</td><td><button style="display:none;" class="btn btn-xs btn-success" onclick="EditarCantidadMaterial('+$("#iddetalleetapa").val()+','+$("#idmaterial").val()+','+contTr+')" title="Editar"><span class="glyphicon glyphicon-pencil" aria-hidden="true"></span></button><button class="btn btn-xs btn-danger eliminar" onclick="EliminarFila('+contTr+','+$("#idmaterial").val()+')" title="Eliminar"><span class="glyphicon glyphicon-remove"></span></button></td></tr>');
							$("#mostrarModalMateriales").val("");
							$("#txtCantidad").val("");
							swal("Guardado!", respuesta.msj, "success");
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
			swal("Error!", "Ya este material se encuentra en la lista.", "error");
		}
	}
	
	
}

var cont=+1;
var cont2=+1000;

function incluirSeleccionadosEtapa(){//INCLUIMOS LAS ETAPAS SELECCIONADAS
	var lista = "";
	$("#listadoMaterialActivos tbody").html("");
	$("#iddetalleetapa").val("");
	$('#ListadoEtapa tbody input').each(function() {
		if($(this).is(':checked')){
			var data = tablaListadoEtapa.row( $(this).parents('tr') ).data();
	  		var id = data[0];
	  		var nombre = data[1];
	  		var descripcion = data[2];
	  		
	  		lista += 
	  		'<input type="hidden" id="'+id+'"/><div class="panel panel-default" ><div class="panel-heading"><a class="btn-block" data-toggle="collapse" data-parent="#acordion" href="#etapa'+id+'" onclick="traerSubetapas(0,'+id+',0)"><h4 class="panel-title">'+nombre+'</h4></a></div>'+
	  		'<div id="etapa'+id+'" class="panel-collapse collapse"><ul id="lista'+id+'" class="list-group lista"></ul></div></div>';

	  		bloquearContainer();
	  		$.post('./Detalleetapa',{
				operacion:OPERACION_LISTADO,
				idetapa:id
			},
			function(json){
				if(json.valido){
					var valor = json.data;
					var listado ='';
					for(var i=0 ; i < valor.length ; i++){
						cont++;
						var separado = valor[i].toString().split(",");
						listado += '<li><a onclick="addclase(this.id,'+separado[3]+')"  id="'+i+cont+'"><span class="glyphicon glyphicon-edit" aria-hidden="true"></span>  '+separado[1]+'</a></li>';
					}
					$("#lista"+id).append(listado);
				}
				desbloquearContainer();
			});
	 	}
    });
	$("#acordion").html(lista);
}

function addclase(e,f){
	var valor=e;
	var contTr = 0;
	
	$("#mostrarModalMateriales").val("");
	$("#txtCantidad").val("");
	$("#listadoMaterialActivos tbody").html("");//QUITAR SI PRESENTA BORRADO DE MATERIALES YA AGREGADO A MATERIALPOROBRA
	contTr = $('#listadoMaterialActivos tr').length;
	var id = $("#idtipoobra").val();
	$("#iddetalleetapa").val(f);
	var iddetalle = $("#iddetalleetapa").val();
	
	$(".lista a").each(function(){
		$(this).removeClass("activado");
	});	
	$("#"+valor).addClass("activado");

	bloquearContainer();
	$.post("./Materialporobra",{
			operacion: OPERACION_LISTADO,
			idtipoobra: id,
			iddetalleetapa: iddetalle
		},
		function(json){
			if(json.valido){
				var valor = json.data;			
				var tabla = "";
				for(var i=0 ; i < valor.length ; i++){
					var separado = valor[i].toString().split(",");
					tabla += '<tr id="'+contTr+'"><input type="hidden" id="'+separado[5]+'"><td>'+separado[1]+'</td><td><input type="hidden" class="form-control soloNumero" id="cantidad'+contTr+'" style="width:120px" value="'+separado[2]+'"/>'+separado[2]+'</td><td><button style="display:none;" class="btn btn-xs btn-success" onclick="EditarCantidadMaterial('+iddetalle+','+separado[5]+','+contTr+')" title="Editar"><span class="glyphicon glyphicon-pencil" aria-hidden="true"></span></button><button class="btn btn-xs btn-danger eliminar" onclick="EliminarFila('+contTr+','+separado[5]+')" title="Eliminar"><span class="glyphicon glyphicon-remove"></span></button></td></tr>';
					contTr++;
				}
				
				if(contTr > $('#listadoMaterialActivos tr').length){
					$('#listadoMaterialActivos tbody').html(tabla);
					validarBotones("tipoobra",$("#idUsuario").val(),"2");
				}else{
					$("#listadoMaterialActivos tbody").html("<tr id='mensaje'><td colspan='3'><center><h4 style='color:#CCC;'>Sin materiales asignados.</h4></center></td></tr>");
				}
				soloNumero();
			}
			desbloquearContainer();
	});
	
}

function cargarDetalleTipoobra(){
	var id = $("#idtipoobra").val();
	$("#listadoMaterialActivos tbody").html("");
	$("#iddetalleetapa").val("");
	bloquearContainer();
	$.post("./Materialporobra",{idtipoobra:id,operacion:OPERACION_CONSULTAR},function(json){
		if(json.valido){
			var valor = json.data;
			var lista = '';
			for(var i=0 ; i < valor.length ; i++){
				var separado = valor[i].toString().split(",");
				lista +=
			  		'<input type="hidden" id="'+separado[0]+'" /><div class="panel panel-default"><div class="panel-heading"><a class="btn-block" data-toggle="collapse" data-parent="#acordion" onclick="traerSubetapas('+i+','+separado[0]+','+separado[2]+')" href="#etapa'+i+'"><h4 class="panel-title">'+separado[1]+'</h4></a></div>'+
			  		'<div id="etapa'+i+'"  class="panel-collapse collapse"></div></div>';
			}
			$("#acordion").html(lista);
			soloNumero();			
		}
		desbloquearContainer();
	});
}

function traerSubetapas(idDiv,idetapa,idtipoobra){
	$("#listadoMaterialActivos tbody").html("");
	$("#iddetalleetapa").val("");
	$("#mostrarModalMateriales").val("");
	$("#txtCantidad").val("");
	$("#idEtapaAux").val(idetapa);
	/*$.post('./Materialporobra',{
		operacion:OPERACION_LISTADO_MATERIALPOROBRA,
		idtipoobra:idtipoobra,
		idetapa:idetapa
	},*/
	bloquearContainer();
	$.post('./Detalleetapa',{
		operacion:OPERACION_LISTADO,
		idetapa:idetapa
	},
	function(json){
		if(json.valido){
			var valor = json.data;
			var listado ='';
			for(var j=0 ; j < valor.length ; j++){
				cont2++;
				var separado = valor[j].toString().split(",");
				listado += '<ul class="list-group lista"><li><a onclick="addclase(this.id,'+separado[3]+')"  id="'+j+cont2+'"><span class="glyphicon glyphicon-edit" aria-hidden="true"></span>  '+separado[1]+'</a></li></ul>';
				
			}
			$("#etapa"+idDiv).html(listado);
		}
		desbloquearContainer();
	});
}

function EditarCantidadMaterial(iddetalle, idmaterial, idTr){
	var iddetalleetapa = iddetalle;
	var idmaterial = idmaterial;

	bloquearContainer();
	$.post("./Materialporobra",{
	    	operacion : OPERACION_EDITAR,
	    	idmaterial : idmaterial,
	    	iddetalleetapa : iddetalleetapa,
	    	cantidad : $("#cantidad"+idTr).val()
	    	}, 
	    	function FuncionRecepcion(respuesta) {
				if(respuesta.valido){
					swal("Editado!", respuesta.msj, "success");
					//$('#'+index).remove();
				}else {
					swal("Error!", respuesta.msj, "error");					
				}
				desbloquearContainer();
	        });
}

