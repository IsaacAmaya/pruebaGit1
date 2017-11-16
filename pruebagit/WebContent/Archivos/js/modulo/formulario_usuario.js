var cambiarC = false;

function cambiarClave(){
	cambiarC = true;
}


function cargarUsuario(id){
	bloquearContainer();
	$.post("./Usuario",
			{
				operacion :OPERACION_CONSULTAR,
				idusuario: id            			
			},
	        function FuncionRecepcion(respuesta) {
				if(respuesta.valido){
					$('#idusuario').val(respuesta.idusuario);
					$('#idpersona').val(respuesta.idpersona);
					$('#txtUsuario').val(respuesta.txtUsuario);
					$('#txtCedula').prop('disabled', true);
					$('#txtCedula').val(respuesta.txtCedula);
					$('#txtNombre').prop('disabled', true);
					$('#txtNombre').val(respuesta.txtNombre);
					$('#txtApellido').prop('disabled', true);
					$('#txtApellido').val(respuesta.txtApellido);
					
					$('#btnBuscarPersona').prop('disabled', true);
					
					//permisos app
					$('#app_acceso').prop('checked', respuesta.app_acceso);
					$('#app_fullDash').prop('checked', respuesta.app_fullDash);
					$('#app_Inspecciones').prop('checked', respuesta.app_Inspecciones);
					$('#app_Materiales').prop('checked', respuesta.app_Materiales);
					
					//permisos modulo
					$('#PersonaChkConsultar').prop('checked', respuesta.PersonaChkConsultar);
					$('#PersonaChkIncluir').prop('checked', respuesta.PersonaChkIncluir);
					$('#PersonaChkModificar').prop('checked', respuesta.PersonaChkModificar);
					$('#PersonaChkEliminar').prop('checked', respuesta.PersonaChkEliminar);
					
					$('#CargoChkConsultar').prop('checked', respuesta.CargoChkConsultar);
					$('#CargoChkIncluir').prop('checked', respuesta.CargoChkIncluir);
					$('#CargoChkModificar').prop('checked', respuesta.CargoChkModificar);
					$('#CargoChkEliminar').prop('checked', respuesta.CargoChkEliminar);
					
					$('#TrabajadorChkConsultar').prop('checked', respuesta.TrabajadorChkConsultar);
					$('#TrabajadorChkIncluir').prop('checked', respuesta.TrabajadorChkIncluir);
					$('#TrabajadorChkModificar').prop('checked', respuesta.TrabajadorChkModificar);
					$('#TrabajadorChkEliminar').prop('checked', respuesta.TrabajadorChkEliminar);
					
					$('#CuadrillaChkConsultar').prop('checked', respuesta.CuadrillaChkConsultar);
					$('#CuadrillaChkIncluir').prop('checked', respuesta.CuadrillaChkIncluir);
					$('#CuadrillaChkModificar').prop('checked', respuesta.CuadrillaChkModificar);
					$('#CuadrillaChkEliminar').prop('checked', respuesta.CuadrillaChkEliminar);
					
					$('#MaterialChkConsultar').prop('checked', respuesta.MaterialChkConsultar);
					$('#MaterialChkIncluir').prop('checked', respuesta.MaterialChkIncluir);
					$('#MaterialChkModificar').prop('checked', respuesta.MaterialChkModificar);
					$('#MaterialChkEliminar').prop('checked', respuesta.MaterialChkEliminar);
					
					$('#ProveedorChkConsultar').prop('checked', respuesta.ProveedorChkConsultar);
					$('#ProveedorChkIncluir').prop('checked', respuesta.ProveedorChkIncluir);
					$('#ProveedorChkModificar').prop('checked', respuesta.ProveedorChkModificar);
					$('#ProveedorChkEliminar').prop('checked', respuesta.ProveedorChkEliminar);
					
					$('#CompraChkConsultar').prop('checked', respuesta.CompraChkConsultar);
					$('#CompraChkIncluir').prop('checked', respuesta.CompraChkIncluir);
					$('#CompraChkModificar').prop('checked', respuesta.CompraChkModificar);
					$('#CompraChkEliminar').prop('checked', respuesta.CompraChkEliminar);
					
					$('#ProyectoChkConsultar').prop('checked', respuesta.ProyectoChkConsultar);
					$('#ProyectoChkIncluir').prop('checked', respuesta.ProyectoChkIncluir);
					$('#ProyectoChkModificar').prop('checked', respuesta.ProyectoChkModificar);
					$('#ProyectoChkEliminar').prop('checked', respuesta.ProyectoChkEliminar);
					
					$('#EtapaChkConsultar').prop('checked', respuesta.EtapaChkConsultar);
					$('#EtapaChkIncluir').prop('checked', respuesta.EtapaChkIncluir);
					$('#EtapaChkModificar').prop('checked', respuesta.EtapaChkModificar);
					$('#EtapaChkEliminar').prop('checked', respuesta.EtapaChkEliminar);
					
					$('#SubEtapaChkConsultar').prop('checked', respuesta.SubEtapaChkConsultar);
					$('#SubEtapaChkIncluir').prop('checked', respuesta.SubEtapaChkIncluir);
					$('#SubEtapaChkModificar').prop('checked', respuesta.SubEtapaChkModificar);
					$('#SubEtapaChkEliminar').prop('checked', respuesta.SubEtapaChkEliminar);
					
					$('#ObrasChkConsultar').prop('checked', respuesta.ObrasChkConsultar);
					$('#ObrasChkIncluir').prop('checked', respuesta.ObrasChkIncluir);
					$('#ObrasChkModificar').prop('checked', respuesta.ObrasChkModificar);
					$('#ObrasChkEliminar').prop('checked', respuesta.ObrasChkEliminar);
					
					$('#TipoOChkConsultar').prop('checked', respuesta.TipoOChkConsultar);
					$('#TipoOChkIncluir').prop('checked', respuesta.TipoOChkIncluir);
					$('#TipoOChkModificar').prop('checked', respuesta.TipoOChkModificar);
					$('#TipoOChkEliminar').prop('checked', respuesta.TipoOChkEliminar);
					
					$('#SolicitudMChkConsultar').prop('checked', respuesta.SolicitudMChkConsultar);
					$('#SolicitudMChkIncluir').prop('checked', respuesta.SolicitudMChkIncluir);
					$('#SolicitudMChkModificar').prop('checked', respuesta.SolicitudMChkModificar);
					$('#SolicitudMChkEliminar').prop('checked', respuesta.SolicitudMChkEliminar);
					
					$('#DespachoChkConsultar').prop('checked', respuesta.DespachoChkConsultar);
					$('#DespachoChkIncluir').prop('checked', respuesta.DespachoChkIncluir);
					$('#DespachoChkModificar').prop('checked', respuesta.DespachoChkModificar);
					$('#DespachoChkEliminar').prop('checked', respuesta.DespachoChkEliminar);
					
					$('#InspecciChkConsultar').prop('checked', respuesta.InspecciChkConsultar);
					$('#InspecciChkIncluir').prop('checked', respuesta.InspecciChkIncluir);
					$('#InspecciChkModificar').prop('checked', respuesta.InspecciChkModificar);
					$('#InspecciChkEliminar').prop('checked', respuesta.InspecciChkEliminar);
					
					$('#AsignaciPChkConsultar').prop('checked', respuesta.AsignaciPChkConsultar);
					$('#AsignaciPChkIncluir').prop('checked', respuesta.AsignaciPChkIncluir);
					$('#AsignaciPChkModificar').prop('checked', respuesta.AsignaciPChkModificar);
					$('#AsignaciPChkEliminar').prop('checked', respuesta.AsignaciPChkEliminar);
					
					$('#UsuariosChkConsultar').prop('checked', respuesta.UsuariosChkConsultar);
					$('#UsuariosChkIncluir').prop('checked', respuesta.UsuariosChkIncluir);
					$('#UsuariosChkModificar').prop('checked', respuesta.UsuariosChkModificar);
					$('#UsuariosChkEliminar').prop('checked', respuesta.UsuariosChkEliminar);
					
					$('#PrecioChkConsultar').prop('checked', respuesta.PrecioChkConsultar);
					$('#PrecioChkIncluir').prop('checked', respuesta.PrecioChkIncluir);
					$('#PrecioChkModificar').prop('checked', respuesta.PrecioChkModificar);
					$('#PrecioChkEliminar').prop('checked', respuesta.PrecioChkEliminar);
					
					//permisos Dash
					$('#GInversionG').prop('checked', respuesta.GInversionG);
					$('#GAvancePro').prop('checked', respuesta.GAvancePro);
					$('#GEstadoObra').prop('checked', respuesta.GEstadoObra);
					$('#GEstadoObraEtapa').prop('checked', respuesta.GEstadoObraEtapa);
					$('#GMaterialE').prop('checked', respuesta.GMaterialE);
					$('#GMaterialD').prop('checked', respuesta.GMaterialD);
					$('#GPagoObra').prop('checked', respuesta.GPagoObra);
					$('#GPagoCuadrilla').prop('checked', respuesta.GPagoCuadrilla);
					$('#GPrecioMaterial').prop('checked', respuesta.GPrecioMaterial);
					
					
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


function cargarListadoPersona(){
	
	if(!tablaListadoPersona){ //verifica que la tabla sea nula
		//se inicializa la tabla
		tablaListadoPersona = $('#ListadoPersona').DataTable( {
			responsive: true,
	        "language": {
	            "url": "Archivos/js/Spanish.lang"
	        },
	        "lengthMenu": [[5], [5]],
	        "ajax": {
	        	"url": "./Persona?operacion="+OPERACION_LISTADO,
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
		
		$('#ListadoPersona tbody').on('click', 'tr', function () {
	        var data = tablaListadoPersona.row( this ).data();
	        //alert( 'You clicked on '+data[0]+'\'s row' );
	        $('#idpersona').val(data[0]);
	        $('#txtCedula').val(data[1]);
	        $('#txtNombre').val(data[2]);
	        $('#vModalListadoPersona').modal('hide');
	    } );
	}
	
}

function guardarUsuario(){
	//alert($("#permisos_usuarios input").serialize());
	var op = OPERACION_INCLUIR;
	if($("#idusuario").val()!=''){
		op = OPERACION_EDITAR;
	}
	if($("#form_usuario input").validarCampos() && $("#form_usuario select").validarCampos()){
		bloquearContainer();
		$.post("./Usuario",
				{
					operacion : op,
					idusuario	:$('#idusuario').val(),
					idpersona : $('#idpersona').val(),
					txtUsuario	:$('#txtUsuario').val(),
					txtClave : hex_md5($('#txtContrasena').val()),
					cambiarClave : cambiarC,
					permisosmodulo : $("#permisos_usuarios input").serialize(),
					permisodash : $("#permisos_dashboard input").serialize(),
					app_acceso : $('#app_acceso').is(":checked"),
					app_fullDash : $('#app_fullDash').is(":checked"),
					app_Inspecciones : 	$('#app_Inspecciones').is(":checked"),
					app_Materiales : 	$('#app_Materiales').is(":checked")
				},
		        function FuncionRecepcion(respuesta) {
					if(respuesta.valido){
						swal("Guardado!", "Los cambios surgirán efectos cuando el usuario inicie sesión nuevamente.", "success");
						setTimeout(function(){
    						window.location.href = './usuario';
    					}, 4000);						
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
