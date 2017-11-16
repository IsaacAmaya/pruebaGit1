function cargarObra(id){

	bloquearContainer();
	$.post("./Obra",
			{
				operacion :OPERACION_CONSULTAR,
				idobra : id            			
			},
	        function FuncionRecepcion(respuesta) {
				if(respuesta.valido){
					$('#idobra').val(respuesta.idobra);
					$('#idproyecto').val(respuesta.idproyecto);
					$('#idtipoobra').val(respuesta.idtipoobra);
					$('#txtNombre').val(respuesta.txtNombre);
					$('#txtLote').val(respuesta.txtLote);
					$('#txtDescripcion').val(respuesta.txtDescripcion);
					//$('#txtPorcentaje').val(respuesta.txtPorcentaje);
					$('#txtFechainicio').val(respuesta.txtFechainicio);
					$('#txtFechafinestimada').val(respuesta.txtFechafinestimada);
					$('#txtFechafin').val(respuesta.txtFechafin);
					$('#cmbEstatus').val(respuesta.cmbEstatus);
					$('#txtDatosProyecto').val(respuesta.txtDatosProyecto);
					$('#txtDatosTipoobra').val(respuesta.txtDatosTipoobra);
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

function consultarObra(value){
	if($('#idobra').val()==""){
		bloquearContainer();
		$.post("./Obra",
				{
					operacion :OPERACION_CONSULTAR,
					consultarObra : 1,
					idproyecto : $("#idproyecto").val(),
					idtipoobra : $("#idtipoobra").val(),
					lote : $("#txtLote").val(),
					nombre : value
				},
		        function FuncionRecepcion(respuesta) {
					if(respuesta.valido){
						$('#idobra').val(respuesta.idobra);
						$('#idproyecto').val(respuesta.idproyecto);
						$('#idtipoobra').val(respuesta.idtipoobra);
						$('#txtNombre').val(respuesta.txtNombre);
						$('#txtLote').val(respuesta.txtLote);
						$('#txtDescripcion').val(respuesta.txtDescripcion);
						//$('#txtPorcentaje').val(respuesta.txtPorcentaje);
						$('#txtFechainicio').val(respuesta.txtFechainicio);
						$('#txtFechafinestimada').val(respuesta.txtFechafinestimada);
						$('#txtFechafin').val(respuesta.txtFechafin);
						$('#cmbEstatus').val(respuesta.cmbEstatus);
						$('#txtDatosProyecto').val(respuesta.txtDatosProyecto);
						$('#txtDatosTipoobra').val(respuesta.txtDatosTipoobra);
					}else{
						$('#idobra').val(respuesta.idobra);
					}
					desbloquearContainer();
		        }
		).fail(function(response) {
			desbloquearContainer();
			swal("Error!", "Error en el servidor, no hay respuesta valida.", "error");
		});
	}	
}

function guardarObra(){
	var op = OPERACION_INCLUIR;
	if($("#idobra").val()!=''){
		op = OPERACION_EDITAR;
	}
	if($("#formulario input").validarCampos() && $("#formulario select").validarCampos()){
		bloquearContainer();
		$.post("./Obra",
				{
					operacion : op,
					idobra : $("#idobra").val(),
					idproyecto : $("#idproyecto").val(),
					idtipoobra : $("#idtipoobra").val(),
					txtNombre : $("#txtNombre").val(),
					txtLote : $("#txtLote").val(),
					txtDescripcion : $("#txtDescripcion").val(),
					//txtPorcentaje : $("#txtPorcentaje").val(),
					txtFechainicio : $("#txtFechainicio").val(),
					txtFechafinestimada : $("#txtFechafinestimada").val(),
					txtFechafin : $("#txtFechafin").val(),
					cmbEstatus : $("#cmbEstatus").val()
					
				},
		        function FuncionRecepcion(respuesta) {
					if(respuesta.valido){
						swal("Guardado!", respuesta.msj, "success");
						if(respuesta.msj == 'Registro incluido con exito!'){
							setTimeout(function(){
	    						window.location.href = './obra';
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



function cargarListadoProyecto(){
	
	if(!tablaListadoProyecto){ //verifica que la tabla sea nula
		//se inicializa la tabla
		tablaListadoProyecto = $('#ListadoProyecto').DataTable( {
			responsive: true,
	        "language": {
	            "url": "Archivos/js/Spanish.lang"
	        },
	        "pagingType": "simple",
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
	        //alert( 'You clicked on '+data[0]+'\'s row' );
	        $('#idproyecto').val(data[0]);
	        $('#txtDatosProyecto').val(data[1]);
	        $('#vModalListadoProyecto').modal('hide');
	    } );
	}
	
}

function cargarListadoTipoobra(){
	
	if(!tablaListadoTipoobra){ //verifica que la tabla sea nula
		//se inicializa la tabla
		tablaListadoTipoobra = $('#ListadoTipoobra').DataTable( {
			responsive: true,
	        "language": {
	            "url": "Archivos/js/Spanish.lang"
	        },
	        "pagingType": "simple",
	        "ajax": {
	        	"url": "./Tipoobra?operacion="+OPERACION_LISTADO,
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
		
		$('#ListadoTipoobra tbody').on('click', 'tr', function () {
	        var data = tablaListadoTipoobra.row( this ).data();
	        //alert( 'You clicked on '+data[0]+'\'s row' );
	        $('#idtipoobra').val(data[0]);
	        $('#txtDatosTipoobra').val(data[1]);
	        $('#vModalListadoTipoobra').modal('hide');
	    } );
	}
	
}




function limpiarObra(){


}

