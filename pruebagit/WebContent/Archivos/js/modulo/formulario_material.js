function cargarMaterial(id){
	bloquearContainer();
	
	$.post("./Material",
			{
				operacion :OPERACION_CONSULTAR,
				idmaterial : id            			
			},
	        function FuncionRecepcion(respuesta) {
				if(respuesta.valido){
					$('#idmaterial').val(respuesta.idmaterial);
					$('#txtNombre').val(respuesta.txtNombre);
					//$('#txtMarca').val(respuesta.txtMarca);
					$('#txtCategoria').val(respuesta.txtCategoria);
					$('#txtCategoriaAux').val(respuesta.txtCategoria);
					$('#txtDescripcion').val(respuesta.txtDescripcion);
					$('#cmbEstatus').val(respuesta.cmbEstatus);	
					$('#txtExistencia').val(respuesta.txtExistencia);
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

function consultarMaterial(nombreMaterial){
	if(!$("#idmaterial").val()){
		bloquearContainer();
		$.post("./Material",
				{
					operacion :OPERACION_CONSULTAR,
					nombreMaterial : MaysPrimera(nombreMaterial.toLowerCase()),
					condicion : 1
				},
				function FuncionRecepcion(respuesta) {
					if(respuesta.valido){
						$('#idmaterial').val(respuesta.idmaterial);
						$('#txtNombre').val(respuesta.txtNombre);
						//$('#txtMarca').val(respuesta.txtMarca);
						$('#txtCategoria').val(respuesta.txtCategoria);
						$('#txtCategoriaAux').val(respuesta.txtCategoria);
						$('#txtDescripcion').val(respuesta.txtDescripcion);
						$('#cmbEstatus').val(respuesta.cmbEstatus);					
					}
					desbloquearContainer();
		        }
		).fail(function(response) {
			desbloquearContainer();
			swal("Error!", "Error en el servidor, no hay respuesta valida.", "error");
		});
	}
	
}

function guardarMaterial(){
	var op = OPERACION_INCLUIR;
	if($("#idmaterial").val()!=''){
		op = OPERACION_EDITAR;
	}
	
	var materialCategoria =  $('#txtCategoria').val();
	if($("#txtCategoriaAux").val()!=""){
		materialCategoria = MaysPrimera($('#txtCategoriaAux').val().toLowerCase());
	}
	//alert(materialCategoria);
	if($("#formulario input").validarCampos() && $("#formulario select").validarCampos()){
		bloquearContainer();
		$.post("./Material",
				{
					operacion : op,
					idmaterial : $('#idmaterial').val(),
					txtNombre : MaysPrimera($('#txtNombre').val().toLowerCase()),
					//txtMarca : MaysPrimera($('#txtMarca').val().toLowerCase()),
					txtCategoria : materialCategoria,
					txtDescripcion :MaysPrimera($('#txtDescripcion').val().toLowerCase()),
					cmbEstatus :$ ('#cmbEstatus').val()
				},
		        function FuncionRecepcion(respuesta) {
					if(respuesta.valido){
						swal("Guardado!", respuesta.msj, "success");
						if(respuesta.msj == 'Registro incluido con exito!'){
							setTimeout(function(){
	    						window.location.href = './material';
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

function cargarEntradaMaterial(){
	var contTr = 0;
	contTr = $('#listadoCompraMaterial tr').length;
	bloquearContainer();
	$.post("./Compramaterial",{
		operacion : OPERACION_LISTADO,
		idmaterial : $("#idmaterial").val(),
		desdeMaterial : 1
	},
	function(json){
		if(json.valido){
			var valor = json.data;
			var tabla = "";
			for(var i=0 ; i < valor.length ; i++){
				var separado = valor[i].toString().split(",");
				tabla += '<tr><td>'+separado[0]+'</td><td>'+separado[1]+'</td><td><a title="Ir a" href="addCompra?id='+separado[3]+'"> '+separado[2]+'</a></td></tr>';
				contTr++;
			}
			
			if(contTr > $('#listadoCompraMaterial tr').length){
				$('#listadoCompraMaterial tbody').html(tabla);
			}else{
				$("#listadoCompraMaterial tbody").html("<tr><td colspan='3'><center><h4 style='color:#CCC;'>Sin existencia.</h4></center></td></tr>");
			}
		}
		desbloquearContainer();
	});
}

function cargarSalidaMaterial(){
	var contTr = 0;
	contTr = $('#listadoSalidaMaterial tr').length;
	bloquearContainer();
	$.post("./Solicitudmaterial",{
		operacion : OPERACION_LISTADO,
		idmaterial : $("#idmaterial").val(),
		desdeMaterial : 1
	},
	function(json){
		if(json.valido){
			var valor = json.data;
			var tabla = "";
			for(var i=0 ; i < valor.length ; i++){
				var separado = valor[i].toString().split(",");
				tabla += '<tr><td>'+separado[0]+'</td><td>'+separado[1]+'</td><td><a title="Ir a" href="addDespachomaterial?id='+separado[2]+'"> '+separado[2]+'</a></td></tr>';
				contTr++;
			}
			
			if(contTr > $('#listadoSalidaMaterial tr').length){
				$('#listadoSalidaMaterial tbody').html(tabla);
			}else{
				$("#listadoSalidaMaterial tbody").html("<tr><td colspan='3'><center><h4 style='color:#CCC;'>Sin existencia.</h4></center></td></tr>");
			}
		}
		desbloquearContainer();
	});
}

function MaysPrimera(string){
	  return string.charAt(0).toUpperCase() + string.slice(1);
}
