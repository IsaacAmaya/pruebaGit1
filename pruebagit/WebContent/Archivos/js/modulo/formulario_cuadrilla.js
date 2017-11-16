function cargarCuadrilla(id){
	bloquearContainer();
	$.post("./Cuadrilla",
			{
				operacion :OPERACION_CONSULTAR,
				idcuadrilla : id            			
			},
	        function FuncionRecepcion(respuesta) {
				if(respuesta.valido){
					$('#idcuadrilla').val(respuesta.idcuadrilla);
					$('#txtNombre').val(respuesta.txtNombre);
					$('#idtrabajador').val(respuesta.idtrabajador);
					$('#txtApodo').val(respuesta.txtApodo);
					$('#txtDescripcion').val(respuesta.txtDescripcion);
					$('#cmbEstatus').val(respuesta.cmbEstatus);
					
					$('#txtDatosTrabajador').val(respuesta.txtDatosTrabajador);
										
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

function consultarCuadrilla(value){
	bloquearContainer();
	$.post("./Cuadrilla",
			{
				operacion :OPERACION_CONSULTAR,
				consultarCuadrilla : 1,
				nombre : value
			},
	        function FuncionRecepcion(respuesta) {
				if(respuesta.valido){
					$('#idcuadrilla').val(respuesta.idcuadrilla);
					$('#txtNombre').val(respuesta.txtNombre);
					$('#idtrabajador').val(respuesta.idtrabajador);
					$('#txtApodo').val(respuesta.txtApodo);
					$('#txtDescripcion').val(respuesta.txtDescripcion);
					$('#cmbEstatus').val(respuesta.cmbEstatus);
					
					$('#txtDatosTrabajador').val(respuesta.txtDatosTrabajador);
										
				}
				desbloquearContainer();
	        }
	).fail(function(response) {
		desbloquearContainer();
		swal("Error!", "Error en el servidor, no hay respuesta valida.", "error");
	});	
}

function cargarListadoTrabajadores(){//CARGA EL LISTADO DE LOS TRABAJADORES PARA INCLUIR EN LAS CUADRILLAS
	var cont = 0;	
	$.post('./Trabajador',{
		operacion: OPERACION_LISTADO,
		desdeCuadrilla : 2,
		nombretrabajador : $("#txtTrabajadorAux").val()
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
				$("#listadoIntegrantesCuadrillaActivos tbody tr").each(function(){
	        		var idTmp  = $(this).attr("id");
	        		if(idTmp == separado[0]){
        	  			si = 1;
        	  		}	        		
	        	});
				
				if(si == 0){
					tabla += '<tr onclick="incluir('+separado[0]+','+separado[1]+','+"'"+separado[2]+"'"+','+"'"+separado[3]+"'"+');"><td hidden="hidden">'+separado[0]+'</td><td>'+separado[1]+'</td><td>'+separado[2]+'</td><td>'+separado[3]+'</td></tr>';
				}
			}
			if(cont>0){
				$('#ListadoTrabajadores tbody').html(tabla);
			}else{
				$('#ListadoTrabajadores tbody').html("<tr><td colspan='3'><center>No se encontraron resultados</center></td></tr>");
			}
        }
	});
}

function incluir(id,cedula,nombres,cargo){
	var idcuadrilla = $("#idcuadrilla").val();
	var celda = "";
	celda = "<tr id='"+id+"' ><td>"+cedula+"</td><td>"+nombres+"</td><td>"+cargo+"</td><td><input type='radio' name='opradio' value='"+id+"'></td><td><button class='btn btn-xs btn-danger' onclick='EliminarFila("+id+")' title='Eliminar'><span class='glyphicon glyphicon-remove'></span></button></td></tr>";
	if(idcuadrilla != ""){
		bloquearContainer();
	       $.post("./Trabajadorcuadrilla",
	    		   {
					operacion : OPERACION_INCLUIR,
					idcuadrilla : idcuadrilla,
					idtrabajador : id
	    		   },
	        function FuncionRecepcion(respuesta) {
				if(respuesta.valido){
					$('#listadoIntegrantesCuadrillaActivos tbody').append(celda);
				}else {
					swal("Error!", respuesta.msj, "error");
				}
				desbloquearContainer();
	        }).fail(function(response){
				desbloquearContainer();
				swal("Error!", "Error en el servidor, no hay respuesta valida.", "error");
			});		       
	      
	}else{
		$('#listadoIntegrantesCuadrillaActivos tbody').append(celda);
	}
	$('#vModalListadoTrabajadores').modal("hide");
}

function guardarCuadrilla(){
	var op = OPERACION_INCLUIR;
	if($("#idcuadrilla").val()!=''){
		op = OPERACION_EDITAR;
	}
	var correcto = true;
	var listaAEnviar = new Array();
	var idJefe = $("#idtrabajador").val();
	$("#listadoIntegrantesCuadrillaActivos tbody tr").each(function() {
		listaAEnviar.push($(this).attr('id'));
		idJefe = $('input[name=opradio]:checked').attr('value');
	});
	if(!idJefe){
		swal("Advertencia!", "Debe asignar un jefe de cuadrilla.", "error");
	}else{		
		if($("#formulario input").validarCampos() && $("#formulario select").validarCampos()){
			bloquearContainer();
			$.post("./Cuadrilla",
					{
						operacion : op,
						idcuadrilla : $("#idcuadrilla").val(),
						txtNombre : $("#txtNombre").val(),
						idtrabajador : idJefe,
						txtApodo : $("#txtApodo").val(),
						txtDescripcion : $("#txtDescripcion").val(),
						cmbEstatus : $("#cmbEstatus").val(),
						listaIntegrantesCuadrilla: listaAEnviar.toString()
						
						
					},
			        function FuncionRecepcion(respuesta) {
						if(respuesta.valido){
							swal("Guardado!", respuesta.msj, "success");
							if(respuesta.msj == 'Registro incluido con exito!'){
								setTimeout(function(){
		    						window.location.href = './cuadrilla';
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

function EliminarFila(index) {
	if(index!=$("#idtrabajador").val()){
		if($("#idcuadrilla").val()!=""){
			bloquearContainer();
			$.post("./Trabajadorcuadrilla",
					{
						operacion : OPERACION_ELIMINAR,
						idcuadrilla : $("#idcuadrilla").val(),
						idtrabajador : index
					},
			        function FuncionRecepcion(respuesta) {
						if(respuesta.valido){
							swal("Eliminado!", respuesta.msj, "success");
							$('#'+index).remove();
						    //tablaListadoTrabajadores.ajax.reload();
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
			$('#'+index).remove();
			desbloquearContainer();
		   // tablaListadoTrabajadores.ajax.reload();
		}
	}else{
		swal("Error!", "Debe asignar un nuevo jefe de cuadrilla antes de eliminar el actual.", "error");
	}
}

function cargarDetalleCuadrilla(){
	$("#txtNombrecuadrillaAlert").val($("#txtNombre").val());
	$("#txtApodocuadrillaAlert").val($("#txtApodo").val());
	var id = $("#idcuadrilla").val();
	var idJefe = $("#idtrabajador").val();
	bloquearContainer();
	$.post("./Trabajadorcuadrilla",{
		idcuadrilla:id,
		operacion:OPERACION_LISTADO
	},
	function(json){
		if(json.valido){
			var valor = json.data;
			var cadena = valor.toString();
			var tabla = "";			
			for(var i=0 ; i < valor.length ; i++){
				var separado = valor[i].toString().split(",");
				if(!separado[0]){
					separado[0] == "no";
				}
				tabla += '<tr id="'+separado[0]+'"><td>'+separado[1]+'</td><td>'+separado[2]+'</td><td>'+separado[3]+'</td><td><input class="modificar" type="radio" name="opradio"  value="'+separado[0]+'" '+(separado[0]==idJefe ? 'checked' : '')+' onclick="pasarId(this.value);" ></td><td><button class="btn btn-xs btn-danger eliminar" onclick="EliminarFila('+separado[0]+')" title="Eliminar"><span class="glyphicon glyphicon-remove"></span></button></td></tr>';
			}
			$('#listadoIntegrantesCuadrillaActivos tbody').html(tabla);
			validarBotones("cuadrilla",$("#idUsuario").val(),"2");
		}
		desbloquearContainer();
	});
	//tablaListadoTrabajadores.ajax.reload();
}

function pasarId(idtrabajador){
	if($("#idcuadrilla").val()!=""){
		bloquearContainer();
		$.post("./Cuadrilla",
				{
					operacion : OPERACION_EDITAR,
					idcuadrilla : $("#idcuadrilla").val(),
					idtrabajador : idtrabajador,
					cambiarJefe : 1
				},
		        function FuncionRecepcion(respuesta) {
					if(respuesta.valido){
						swal("Guardado!", respuesta.msj, "success");
						
					}else {
						swal("Error!", respuesta.msj, "error");					
					}
					desbloquearContainer();
		        }
		).fail(function(response) {
			desbloquearContainer();
			swal("Error!", "Error en el servidor, no hay respuesta valida.", "error");
		});
		$("#idtrabajador").val(idtrabajador);
	}else{
		$("#idtrabajador").val(idtrabajador);
	}	
}

