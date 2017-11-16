<%@ taglib tagdir="/WEB-INF/tags" prefix="t" %> 
<%
	String id = request.getParameter("id")==null ? "":request.getParameter("id").toString().trim();
%>
<script src="Archivos/js/modulo/formulario_usuario.js"></script>
<script>
  
  var tablaListadoPersona;
  $( function() {
	  
	  $('#vModalListadoPersona').modal({
		  show: false
	  });
	  
	  $('#vModalListadoPersona').on('show.bs.modal', function (e) {
		  cargarListadoPersona();
	  });
	  
	 
	  <% if(!id.equals("")) out.print("cargarUsuario('"+id+"');");%>
	  
	  $(".tblPermisoModulo").each(function(){
		  $(this).find("th").css({"text-align":"center","font-size":"1.1em"});
		  $(this).find("tbody th").css("cursor", "pointer");
		  $(this).find("tbody th").attr("title", "Click para seleccionar todos");
			$($(this).find("tbody th")).hover(function(){
				$($(this).parents("tr")).css("background-color", "#F2F2F2");
			}, function(){
				$($(this).parents("tr")).css("background-color", "#FFF");
			});
		});
	  
	  $(".tblPermisoModulo").on('click','tr th',function(event){
		  $(this).parents("tr").find("td").find('input').each(function() {
	            $(this).prop("checked", true);
	      });
	  });
	  
	  /* $(".tblPermisoModulo").on('click','tr td',function(event){
		  	if($(this).find('input').is(":checked")){
			  	$(this).find('input').prop("checked", false);
		  	}else{
		  		$(this).find('input').prop("checked", true);
		  	}
	  }); */
	  
  } );
</script>

<div>
	<a href="./usuario" class="tile-small text-shadow fg-white" style="background:#666" data-role="tile">
                    <div class="tile-content iconic mif-ani-hover-bounce">
                        <span class="icon mif-user"></span>
                    </div>
                </a>

	<h3>Modulo de Usuarios</h3>
  <p>Seccion Dedicada al Registro de Nuevos Usuarios y Asignacion de Permisos Correspondientes </p>
</div>


  
   <article id="formulario">
   <t:panel titulo="Formulario para el registro de Usuarios">
  
  <div class="">
           <ul class="nav nav-tabs">
           
                <li class="active"><a data-toggle="tab" href="#form_usuario">Usuario</a></li>
                <li><a data-toggle="tab" href="#permisos_usuarios">Permisos de Modulos</a></li>
                <li><a data-toggle="tab" href="#permisos_dashboard">Permisos de Dashboard</a></li>
                <li><a data-toggle="tab" href="#permisos_app">Permisos de Aplicación</a></li>
           </ul>
                <div class="tab-content">
                
                    <div id="form_usuario" class="tab-pane fade in active" >
	                    <button id="btnBuscarPersona" type="button"  data-toggle="modal" data-target="#vModalListadoPersona" class="btn btn-primary" style="margin-top: 10px;" aria-hidden="true"><span class="glyphicon glyphicon-search"></span> Buscar</button>
	                    <input type="text" style="visibility: hidden;" id="idpersona"><input type="text" style="visibility: hidden;" id="idusuario">
	                    <div class="" style="margin-top: 10px;">
	                                         
	                         <div class="col-sm-12 col-md-4">
	                          <input type="text" class="form-control" id="txtCedula" placeholder="Cedula" readonly>
	                         </div>
	                         
	                    
	                         <div class="col-sm-12 col-md-8">
	                         <input type="text" class="form-control" id="txtNombre" placeholder="Nombre" readonly>
	                         </div>
	                          
	                         
	                         <!-- <div class="col-sm-12 col-md-4">
	                        
	                         <input type="text" class="form-control" id="txtApellido" placeholder="Apellido" readonly>
	                         </div> -->
	                          
	                         
	                    </div> 
	                    <br><br><br>
	                   <div class="form-group">
	                        <div class="form-group ">                  
	                         <div class="col-sm-6">
	                         <input type="text" class="form-control" id="txtUsuario" placeholder="Usuario">
	                         </div>
	                         
	                    
	                         <div class="col-sm-6">
	                          <input type="password" onkeypress="cambiarClave();" class="form-control" id="txtContrasena" placeholder="Contraseña">
	                         </div>
	                          </div>
	                            
	                                             
	                    </div>
                    </div>
                                    
                    
                    
               <div id="permisos_usuarios" class="tab-pane fade">
               		<label><h4>Modulos:</h4></label>
               		
					<div class="panel-group" id="accordion">
						<div class="panel panel-default">
							<div class="panel-heading">
								
									<a data-toggle="collapse" data-parent="#accordion" href="#collapse1"><h4 class="panel-title">PERSONAL</h4></a>
								
							</div>
							<div id="collapse1" class="panel-collapse collapse">
								<div class="panel-body">
									<table id="" class="table table-bordered tblPermisoModulo" style="text-align: center; width: 100%">
					                    <thead >
					                      <tr>
					                        <th style="text-align: center;background:#F2F2F2;" >Modulos</th>
					                        <th style="text-align: center;" >Consultar</th>
					                        <th style="text-align: center;">Incluir</th>
					                        <th style="text-align: center;">Modificar</th>
					                        <th style="text-align: center;">Eliminar</th>
					                      </tr>
					                    </thead>
					                    <tbody class="" style="width: 100%">
					                      <tr>
					                        <th>Persona</th>
					                        <td><label class="custom-control custom-checkbox"><input id="PersonaChkConsultar" name="PersonaChkConsultar" type="checkbox" class="custom-control-input"></label></td>
					                        <td><label class="custom-control custom-checkbox"><input id="PersonaChkIncluir" name="PersonaChkIncluir" type="checkbox" class="custom-control-input"></label></td>
					                        <td><label class="custom-control custom-checkbox"><input id="PersonaChkModificar" name="PersonaChkModificar" type="checkbox" class="custom-control-input"></label></td>
					                        <td><label class="custom-control custom-checkbox"><input id="PersonaChkEliminar" name="PersonaChkEliminar" type="checkbox" class="custom-control-input"></label></td>
					                      </tr>
					                      <tr>
					                        <th>Cargo</th>
					                        <td><label class="custom-control custom-checkbox"><input id="CargoChkConsultar" name="CargoChkConsultar" type="checkbox" class="custom-control-input"></label></td>
					                        <td><label class="custom-control custom-checkbox"><input id="CargoChkIncluir" name="CargoChkIncluir" type="checkbox" class="custom-control-input"></label></td>
					                        <td><label class="custom-control custom-checkbox"><input id="CargoChkModificar" name="CargoChkModificar" type="checkbox" class="custom-control-input"></label></td>
					                        <td><label class="custom-control custom-checkbox"><input id="CargoChkEliminar" name="CargoChkEliminar" type="checkbox" class="custom-control-input"></label></td>
					                      </tr>
					                      <tr>
					                        <th>Trabajador</th>
					                        <td><label class="custom-control custom-checkbox"><input id="TrabajadorChkConsultar" name="TrabajadorChkConsultar" type="checkbox" class="custom-control-input"></label></td>
					                        <td><label class="custom-control custom-checkbox"><input id="TrabajadorChkIncluir" name="TrabajadorChkIncluir" type="checkbox" class="custom-control-input"></label></td>
					                        <td><label class="custom-control custom-checkbox"><input id="TrabajadorChkModificar" name="TrabajadorChkModificar" type="checkbox" class="custom-control-input"></label></td>
					                        <td><label class="custom-control custom-checkbox"><input id="TrabajadorChkEliminar" name="TrabajadorChkEliminar" type="checkbox" class="custom-control-input"></label></td>
					                      </tr>
					                      <tr>
					                        <th>Cuadrilla</th>
					                        <td><label class="custom-control custom-checkbox"><input id="CuadrillaChkConsultar" name="CuadrillaChkConsultar" type="checkbox" class="custom-control-input"></label></td>
					                        <td><label class="custom-control custom-checkbox"><input id="CuadrillaChkIncluir" name="CuadrillaChkIncluir" type="checkbox" class="custom-control-input"></label></td>
					                        <td><label class="custom-control custom-checkbox"><input id="CuadrillaChkModificar" name="CuadrillaChkModificar" type="checkbox" class="custom-control-input"></label></td>
					                        <td><label class="custom-control custom-checkbox"><input id="CuadrillaChkEliminar" name="CuadrillaChkEliminar" type="checkbox" class="custom-control-input"></label></td>
					                      </tr>			                      
					                    </tbody>					                   
					                 </table>
								</div>
							</div>
						</div>
					
						<div class="panel panel-default">
							<div class="panel-heading">
								
									<a data-toggle="collapse" data-parent="#accordion" href="#collapse2"><h4 class="panel-title">COMPRAS</h4></a>
								
							</div>
							<div id="collapse2" class="panel-collapse collapse">
								<div class="panel-body">
									<table id="" class="table table-bordered tblPermisoModulo" style="text-align: center; width: 100%">
					                    <thead >
					                      <tr>
					                        <th style="text-align: center;background:#F2F2F2;" >Modulos</th>
					                        <th style="text-align: center;" >Consultar</th>
					                        <th style="text-align: center;">Incluir</th>
					                        <th style="text-align: center;">Modificar</th>
					                        <th style="text-align: center;">Eliminar</th>
					                      </tr>
					                    </thead>
					                    <tbody class="" style="width: 100%">
					                      <tr>
					                        <th>Material</th>
					                        <td><label class="custom-control custom-checkbox"><input id="MaterialChkConsultar" name="MaterialChkConsultar" type="checkbox" class="custom-control-input"></label></td>
					                        <td><label class="custom-control custom-checkbox"><input id="MaterialChkIncluir" name="MaterialChkIncluir" type="checkbox" class="custom-control-input"></label></td>
					                        <td><label class="custom-control custom-checkbox"><input id="MaterialChkModificar" name="MaterialChkModificar" type="checkbox" class="custom-control-input"></label></td>
					                        <td><label class="custom-control custom-checkbox"><input id="MaterialChkEliminar" name="MaterialChkEliminar" type="checkbox" class="custom-control-input"></label></td>
					                      </tr>
					                      <tr>
					                        <th>Proveedor</th>
					                        <td><label class="custom-control custom-checkbox"><input id="ProveedorChkConsultar" name="ProveedorChkConsultar" type="checkbox" class="custom-control-input"></label></td>
					                        <td><label class="custom-control custom-checkbox"><input id="ProveedorChkIncluir" name="ProveedorChkIncluir" type="checkbox" class="custom-control-input"></label></td>
					                        <td><label class="custom-control custom-checkbox"><input id="ProveedorChkModificar" name="ProveedorChkModificar" type="checkbox" class="custom-control-input"></label></td>
					                        <td><label class="custom-control custom-checkbox"><input id="ProveedorChkEliminar" name="ProveedorChkEliminar" type="checkbox" class="custom-control-input"></label></td>
					                      </tr>
					                      <tr>
					                        <th>Compra de Material</th>
					                        <td><label class="custom-control custom-checkbox"><input id="CompraChkConsultar" name="CompraChkConsultar" type="checkbox" class="custom-control-input"></label></td>
					                        <td><label class="custom-control custom-checkbox"><input id="CompraChkIncluir" name="CompraChkIncluir" type="checkbox" class="custom-control-input"></label></td>
					                        <td><label class="custom-control custom-checkbox"><input id="CompraChkModificar" name="CompraChkModificar" type="checkbox" class="custom-control-input"></label></td>
					                        <td><label class="custom-control custom-checkbox"><input id="CompraChkEliminar" name="CompraChkEliminar" type="checkbox" class="custom-control-input"></label></td>
					                      </tr>
					                    </tbody>
					                   
					                  </table>
								</div>
							</div>
						</div>
					
						<div class="panel panel-default">
							<div class="panel-heading">
								
									<a data-toggle="collapse" data-parent="#accordion" href="#collapse3"><h4 class="panel-title">PROYECTOS</h4></a>
								
							</div>
							<div id="collapse3" class="panel-collapse collapse">
								<div class="panel-body">
									<table id="" class="table table-bordered tblPermisoModulo" style="text-align: center; width: 100%">
					                    <thead >
					                      <tr>
					                        <th style="text-align: center;background:#F2F2F2;" >Modulos</th>
					                        <th style="text-align: center;" >Consultar</th>
					                        <th style="text-align: center;">Incluir</th>
					                        <th style="text-align: center;">Modificar</th>
					                        <th style="text-align: center;">Eliminar</th>
					                      </tr>
					                    </thead>
					                     
					                    <tbody class="" style="width: 100%">
					                      <tr>
					                        <th>Proyecto</th>
					                        <td><label class="custom-control custom-checkbox"><input id="ProyectoChkConsultar" name="ProyectoChkConsultar" type="checkbox" class="custom-control-input"></label></td>
					                        <td><label class="custom-control custom-checkbox"><input id="ProyectoChkIncluir" name="ProyectoChkIncluir" type="checkbox" class="custom-control-input"></label></td>
					                        <td><label class="custom-control custom-checkbox"><input id="ProyectoChkModificar" name="ProyectoChkModificar" type="checkbox" class="custom-control-input"></label></td>
					                        <td><label class="custom-control custom-checkbox"><input id="ProyectoChkEliminar" name="ProyectoChkEliminar" type="checkbox" class="custom-control-input"></label></td>
					                      </tr>
					                      <tr>
					                        <th>Etapa</th>
					                        <td><label class="custom-control custom-checkbox"><input id="EtapaChkConsultar" name="EtapaChkConsultar" type="checkbox" class="custom-control-input"></label></td>
					                        <td><label class="custom-control custom-checkbox"><input id="EtapaChkIncluir" name="EtapaChkIncluir" type="checkbox" class="custom-control-input"></label></td>
					                        <td><label class="custom-control custom-checkbox"><input id="EtapaChkModificar" name="EtapaChkModificar" type="checkbox" class="custom-control-input"></label></td>
					                        <td><label class="custom-control custom-checkbox"><input id="EtapaChkEliminar" name="EtapaChkEliminar" type="checkbox" class="custom-control-input"></label></td>
					                      </tr>
					                      <tr>
						                        <th>SubEtapa</th>
						                        <td><label class="custom-control custom-checkbox"><input id="SubEtapaChkConsultar" name="SubEtapaChkConsultar" type="checkbox" class="custom-control-input"></label></td>
						                        <td><label class="custom-control custom-checkbox"><input id="SubEtapaChkIncluir" name="SubEtapaChkIncluir" type="checkbox" class="custom-control-input"></label></td>
						                        <td><label class="custom-control custom-checkbox"><input id="SubEtapaChkModificar" name="SubEtapaChkModificar" type="checkbox" class="custom-control-input"></label></td>
						                        <td><label class="custom-control custom-checkbox"><input id="SubEtapaChkEliminar" name="SubEtapaChkEliminar" type="checkbox" class="custom-control-input"></label></td>
						                      </tr>
						                      <tr>
						                        <th>Obras</th>
						                        <td><label class="custom-control custom-checkbox"><input id="ObrasChkConsultar" name="ObrasChkConsultar" type="checkbox" class="custom-control-input"></label></td>
						                        <td><label class="custom-control custom-checkbox"><input id="ObrasChkIncluir" name="ObrasChkIncluir" type="checkbox" class="custom-control-input"></label></td>
						                        <td><label class="custom-control custom-checkbox"><input id="ObrasChkModificar" name="ObrasChkModificar" type="checkbox" class="custom-control-input"></label></td>
						                        <td><label class="custom-control custom-checkbox"><input id="ObrasChkEliminar" name="ObrasChkEliminar" type="checkbox" class="custom-control-input"></label></td>
						                      </tr>
						                      <tr>
						                        <th>Tipo de Obras</th>
						                        <td><label class="custom-control custom-checkbox"><input id="TipoOChkConsultar" name="TipoOChkConsultar" type="checkbox" class="custom-control-input"></label></td>
						                        <td><label class="custom-control custom-checkbox"><input id="TipoOChkIncluir" name="TipoOChkIncluir" type="checkbox" class="custom-control-input"></label></td>
						                        <td><label class="custom-control custom-checkbox"><input id="TipoOChkModificar" name="TipoOChkModificar" type="checkbox" class="custom-control-input"></label></td>
						                        <td><label class="custom-control custom-checkbox"><input id="TipoOChkEliminar" name="TipoOChkEliminar" type="checkbox" class="custom-control-input"></label></td>
						                      </tr>
					                    </tbody>
					                   
					                  </table>
								</div>
							</div>
						</div>
					
						<div class="panel panel-default">
							<div class="panel-heading">
								
									<a data-toggle="collapse" data-parent="#accordion" href="#collapse4"><h4 class="panel-title">ASIGNACION</h4></a>
								
							</div>
							<div id="collapse4" class="panel-collapse collapse">
								<div class="panel-body">
									<table id="" class="table table-bordered tblPermisoModulo" style="text-align: center; width: 100%">
					                    <thead >
					                      <tr>
					                        <th style="text-align: center;background:#F2F2F2;">Modulos</th>
					                        <th style="text-align: center;">Consultar</th>
					                        <th style="text-align: center;">Incluir</th>
					                        <th style="text-align: center;">Modificar</th>
					                        <th style="text-align: center;">Eliminar</th>
					                      </tr>
					                    </thead>
					                    <tbody class="" style="width: 100%">
					                      <tr>
					                        <th>Solicitud de Material</th>
					                        <td><label class="custom-control custom-checkbox"><input id="SolicitudMChkConsultar" name="SolicitudMChkConsultar" type="checkbox" class="custom-control-input"></label></td>
					                        <td><label class="custom-control custom-checkbox"><input id="SolicitudMChkIncluir" name="SolicitudMChkIncluir" type="checkbox" class="custom-control-input"></label></td>
					                        <td><label class="custom-control custom-checkbox"><input id="SolicitudMChkModificar" name="SolicitudMChkModificar" type="checkbox" class="custom-control-input"></label></td>
					                        <td><label class="custom-control custom-checkbox"><input id="SolicitudMChkEliminar" name="SolicitudMChkEliminar" type="checkbox" class="custom-control-input"></label></td>
					                      </tr>
					                       <tr>
					                        <th>Despacho</th>
					                        <td><label class="custom-control custom-checkbox"><input id="DespachoChkConsultar" name="DespachoChkConsultar" type="checkbox" class="custom-control-input"></label></td>
					                        <td><label class="custom-control custom-checkbox"><input id="DespachoChkIncluir" name="DespachoChkIncluir" type="checkbox" class="custom-control-input"></label></td>
					                        <td><label class="custom-control custom-checkbox"><input id="DespachoChkModificar" name="DespachoChkModificar" type="checkbox" class="custom-control-input"></label></td>
					                        <td><label class="custom-control custom-checkbox"><input id="DespachoChkEliminar" name="DespachoChkEliminar" type="checkbox" class="custom-control-input"></label></td>
					                      </tr>
					                      <tr>
					                        <th>Inspecci&oacute;n</th>
					                        <td><label class="custom-control custom-checkbox"><input id="InspecciChkConsultar" name="InspecciChkConsultar" type="checkbox" class="custom-control-input"></label></td>
					                        <td><label class="custom-control custom-checkbox"><input id="InspecciChkIncluir" name="InspecciChkIncluir" type="checkbox" class="custom-control-input"></label></td>
					                        <td><label class="custom-control custom-checkbox"><input id="InspecciChkModificar" name="InspecciChkModificar" type="checkbox" class="custom-control-input"></label></td>
					                        <td><label class="custom-control custom-checkbox"><input id="InspecciChkEliminar" name="InspecciChkEliminar" type="checkbox" class="custom-control-input"></label></td>
					                      </tr>
					                      <tr>
					                        <th>Asignaci&oacute;n de Pagos</th>
					                        <td><label class="custom-control custom-checkbox"><input id="AsignaciPChkConsultar" name="AsignaciPChkConsultar" type="checkbox" class="custom-control-input"></label></td>
					                        <td><label class="custom-control custom-checkbox"><input id="AsignaciPChkIncluir" name="AsignaciPChkIncluir" type="checkbox" class="custom-control-input"></label></td>
					                        <td><label class="custom-control custom-checkbox"><input id="AsignaciPChkModificar" name="AsignaciPChkModificar" type="checkbox" class="custom-control-input"></label></td>
					                        <td><label class="custom-control custom-checkbox"><input id="AsignaciPChkEliminar" name="AsignaciPChkEliminar" type="checkbox" class="custom-control-input"></label></td>
					                      </tr>
					                       <tr>
					                        <th>Precios</th>
					                        <td><label class="custom-control custom-checkbox"><input id="PrecioChkConsultar" name="PrecioChkConsultar" type="checkbox" class="custom-control-input"></label></td>
					                        <td><label class="custom-control custom-checkbox"><input id="PrecioChkIncluir" name="PrecioChkIncluir" type="checkbox" class="custom-control-input"></label></td>
					                        <td><label class="custom-control custom-checkbox"><input id="PrecioChkModificar" name="PrecioChkModificar" type="checkbox" class="custom-control-input"></label></td>
					                        <td><label class="custom-control custom-checkbox"><input id="PrecioChkEliminar" name="PrecioChkEliminar" type="checkbox" class="custom-control-input"></label></td>
					                      </tr>
					                    </tbody>
				                  </table>
								</div>
							</div>
						</div>
					
						<div class="panel panel-default">
							<div class="panel-heading">
								<a data-toggle="collapse" data-parent="#accordion" href="#collapse5"><h4 class="panel-title">CONFIGURACION</h4></a>
							</div>
							<div id="collapse5" class="panel-collapse collapse">
								<div class="panel-body">
									<table id="" class="table table-bordered tblPermisoModulo" style="text-align: center; width: 100%">
					                    <thead >
					                      <tr>
					                        <th style="text-align: center;background:#F2F2F2;">Modulos</th>
					                        <th style="text-align: center;">Consultar</th>
					                        <th style="text-align: center;">Incluir</th>
					                        <th style="text-align: center;">Modificar</th>
					                        <th style="text-align: center;">Eliminar</th>
					                      </tr>
					                    </thead>
					                    <tbody class="" style="width: 100%">
					                      <tr>
					                        <th title="Click para seleccionar todos">Usuarios</th>
					                        <td><label class="custom-control custom-checkbox"><input id="UsuariosChkConsultar" name="UsuariosChkConsultar" type="checkbox" class="custom-control-input"></label></td>
					                        <td><label class="custom-control custom-checkbox"><input id="UsuariosChkIncluir" name="UsuariosChkIncluir" type="checkbox" class="custom-control-input"></label></td>
					                        <td><label class="custom-control custom-checkbox"><input id="UsuariosChkModificar" name="UsuariosChkModificar" type="checkbox" class="custom-control-input"></label></td>
					                        <td><label class="custom-control custom-checkbox"><input id="UsuariosChkEliminar" name="UsuariosChkEliminar" type="checkbox" class="custom-control-input"></label></td>
					                      </tr>
					                    </tbody>
				                  </table>
								</div>
							</div>
						</div>
					</div>
                  
                    </div> 
                    <div id="permisos_dashboard" class="tab-pane fade" >
                    	<div class="">
                        <table class="table table-bordered tblPermisoModulo" style="text-align: center; width: 100%">
		                    <thead >
		                      <tr>
		                        <th style="text-align: center;">Graficas</th>
		                        <th style="text-align: center;">Disponible</th>
		                      </tr>
		                    </thead>		                     
		                    <tbody class="" style="width: 100%">
		                    	<tr>
			                        <th>INVERSIÓN GENERAL</th>
			                        <td><label class="custom-control custom-checkbox"><input id="GInversionG" name="GInversionG" type="checkbox" class="custom-control-input"></label></td>
			                        
		                      	</tr>
		                      	<tr>
			                        <th>AVANCE DEL PROYECTO</th>
			                        <td><label class="custom-control custom-checkbox"><input id="GAvancePro" name="GAvancePro" type="checkbox" class="custom-control-input"></label></td>
			                        
		                      	</tr>
		                      	<tr>
			                        <th>ESTADO DE OBRAS</th>
			                        <td><label class="custom-control custom-checkbox"><input id="GEstadoObra" name="GEstadoObra" type="checkbox" class="custom-control-input"></label></td>
			                        
		                      	</tr>
		                      	<tr>
			                        <th>ESTADO DE OBRAS Y ETAPAS</th>
			                        <td><label class="custom-control custom-checkbox"><input id="GEstadoObraEtapa" name="GEstadoObraEtapa" type="checkbox" class="custom-control-input"></label></td>
			                        
		                      	</tr>
		                      	<tr hidden="hidden">
			                        <th>MATERIAL ENTREGADO </th>
			                        <td><label class="custom-control custom-checkbox"><input id="GMaterialE" name="GMaterialE" type="checkbox" class="custom-control-input"></label></td>
			                        
		                      	</tr>
		                      	<tr>
			                        <th>MATERIAL DISPONIBLE </th>
			                        <td><label class="custom-control custom-checkbox"><input id="GMaterialD" name="GMaterialD" type="checkbox" class="custom-control-input"></label></td>
			                        
		                      	</tr>
		                      	<tr hidden="hidden">
			                        <th>PAGOS DE OBRAS </th>
			                        <td><label class="custom-control custom-checkbox"><input id="GPagoObra" name="GPagoObra" type="checkbox" class="custom-control-input"></label></td>
			                        
		                      	</tr>
		                      	<tr hidden="hidden">
			                        <th>PAGOS DE CUADRILLAS </th>
			                        <td><label class="custom-control custom-checkbox"><input id="GPagoCuadrilla" name="GPagoCuadrilla" type="checkbox" class="custom-control-input"></label></td>
			                        
		                      	</tr>
		                      	<tr >
			                        <th>PRECIOS MATERIALES </th>
			                        <td><label class="custom-control custom-checkbox"><input id="GPrecioMaterial" name="GPrecioMaterial" type="checkbox" class="custom-control-input"></label></td>
			                        
		                      	</tr>
		                      	
		                    </tbody>
		                </table>
		                </div>
                    </div>
                    <div id="permisos_app" class="tab-pane fade" >
                    	<div class="">
                    	<div style="padding-left: 20px"><label class="custom-control custom-checkbox"><input id="app_acceso" name="app_acceso" type="checkbox" class="custom-control-input">Acceso Aplicación</label></div>
                        <table class="table table-bordered tblPermisoModulo" style="text-align: center; width: 100%">
		                    <thead>
		                      <tr>
		                        <th style="text-align: center;">Opción</th>
		                        <th style="text-align: center;">Disponible</th>
		                      </tr>
		                    </thead>		                     
		                    <tbody class="" style="width: 100%">
		                    	<tr>
			                        <th>Full Dashboard</th>
			                        <td><label class="custom-control custom-checkbox"><input id="app_fullDash" name="app_fullDash" type="checkbox" class="custom-control-input"></label></td>
			                        
		                      	</tr>
		                      	<tr>
			                        <th>Inspecciones</th>
			                        <td><label class="custom-control custom-checkbox"><input id="app_Inspecciones" name="app_Inspecciones" type="checkbox" class="custom-control-input"></label></td>
			                        
		                      	</tr>
		                      	<tr>
			                        <th>Materiales</th>
			                        <td><label class="custom-control custom-checkbox"><input id="app_Materiales" name="app_Materialess" type="checkbox" class="custom-control-input"></label></td>
			                        
		                      	</tr>
		                    </tbody>
		                </table>
		                </div>
                    </div>
               </div>
           	</div>
           	<br><br><br>
          	<div class="form-group" style="text-align: center; ">
	    	<div style="margin-top: 30px;">
	     		<t:btnBotonera accionguardar="guardarUsuario();" accioncancelar="window.location.href = './usuario';" accionlimpiar="window.location.href = './addUsuario';"></t:btnBotonera>     
	        </div>
      	</div>
          
          
           </t:panel>
    
   
</article> 


<!-- Modal -->
<div class="modal fade" id="vModalListadoPersona" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h5 class="modal-title" id="myModalLabel">Seleccionar Persona</h5>
      </div>
      <div class="modal-body">
        	<table id="ListadoPersona" class="display tablamodal"  width="100%">
		        <thead>
		            <tr>
		            	<th>idpersona</th>
		                <th>Cédula</th>
		                <th>Apellido y Nombre</th>		                
		                <th>Teléfono</th>
		            </tr>
		        </thead>
		        <tfoot>
		            <tr>
		            	<th>idpersona</th>
		                <th>Cédula</th>
		                <th>Apellido y Nombre</th>                
		                <th>Teléfono</th>
		            </tr>
		        </tfoot>
		        <tbody> 
		            
		        </tbody>
		    </table>
      </div>
      <!-- <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
      </div> -->
    </div>
  </div>
</div>

	