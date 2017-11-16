<%@ taglib tagdir="/WEB-INF/tags" prefix="t"%>
<%
	String id = request.getParameter("id") == null ? "" : request.getParameter("id").toString().trim();
%>
<style>
.cantidadExeciva {
	color: red;
}
</style>
<script src="Archivos/js/modulo/formulario_compra.js"></script>
<script>
	var tablaListadoProveedor;
	var tablaListadoMaterial;
	$(function() {
		
		$(".fec").datepicker({
			dateFormat : 'dd/mm/yy',
			changeMonth : true,
			changeYear : true,
			yearRange : "c-40:c+2",
			showOtherMonths : true,
			selectOtherMonths : true,
			showAnim : "clip"

		});
		<%
			if (!id.equals(""))
				out.print("cargarCompra('" + id + "')");
		%>
	
		
	
		
		$('#vModalListadoProveedor').modal({
			show : false
		});

		$('#vModalListadoProveedor').on('show.bs.modal', function(e) {
			cargarListadoProveedor();
		});

		$('#vModalListadoMaterial').on('show.bs.modal', function(e) {
			cargarListadoMaterial();
		});

		$('#vModalNuevoMaterial').on('hide.bs.modal', function(e) {
			$("#txtNombrematerial").val("");
			$("#txtDescripcionmaterial").val("");
			$("#txtCategoria").val("");
			$("#txtCategoriaAux").val("");
			$("#btnCategoria").val("0");
		});

		$("#txtIva").keyup(function() {
			montoTotal();
			calcularMonto();
		});

		$("#agregarNuevoMaterial")
				.click(
						function() {
							$('#vModalListadoMaterial').modal("hide");
							$("#vModalNuevoMaterial").modal("show");

							var cont = 0;
							$
									.post(
											"./Material",
											{
												operacion : OPERACION_LISTADO,
												listadoCategoria : 1
											},
											function(json) {
												if (json.valido) {
													var valor = json.data;
													var tabla = "<option value='N/A' >Seleccionar</option>";
													for (var i = 0; i < valor.length; i++) {
														var separado = valor[i]
																.toString()
																.split(",");
														tabla += '<option value="'
																+ separado[0]
																+ '" '
																+ ($(
																		"#txtCategoriaAux")
																		.val() == separado[0] ? 'selected'
																		: '')
																+ '>'
																+ separado[0]
																+ '</option>';
														cont++;
													}

													if (cont > 0) {
														$('#txtCategoria')
																.html(tabla);
														cont = 0;
													} else {
														$("#txtCategoria")
																.html(
																		"<option value=''>No hay resultados</option>");
													}
												}
												desbloquearContainer();
											});
						});

		$("#agregarNuevoProveedor").click(function() {
			$('#vModalListadoProveedor').modal("hide");
			$("#vModalNuevoProveedor").modal("show");
		});

		$("#agregarCategoria").click(
				function(e) {
					if ($("#btnCategoria").val() == "0") {
						$("#btnCategoria").val("1");
						$("#txtCategoria").hide(500);
						$("#txtCategoriaAux").css("display", "inline").focus();
						$("#txtCategoriaAux").attr("required", true);
						$("#txtCategoria").removeAttr("required");
					} else {
						var repetido = false;
						$("#txtCategoria option").each(
								function() {
									if ($("#txtCategoriaAux").val() == $(this)
											.attr('value')) {
										repetido = true;
									}
								});
						if (!repetido) {
							$("#txtCategoria").append(
									"<option value='"
											+ $("#txtCategoriaAux").val()
											+ "' selected>"
											+ $("#txtCategoriaAux").val()
											+ "</option>");
						}
						$("#btnCategoria").val("0");
						$("#txtCategoria").show(500);
						$("#txtCategoriaAux").css("display", "none");
						$("#txtCategoria").attr("required", true);
						$("#txtCategoriaAux").removeAttr("required");
					}
				});

		$("#txtCategoria").change(function() {
			$("#txtCategoriaAux").val("");
		});
		validarBotones("compra",$("#idUsuario").val(),"2");
	});
</script>
<input type="hidden" value="<%=session.getAttribute("idusuario") %>" id="idUsuario">
<div>
	<a href="./compra" class="tile-small text-shadow fg-white"
		style="background: #00A0E3" data-role="tile">
		<div class="tile-content iconic mif-ani-hover-shuttle">
			<img class="icon" src="Archivos/images/iconmenu/COMPRAMATERIAL.png"></img>
		</div>
	</a>
	<h3>Modulo de Compras Material</h3>
	<p>Seccion Dedicada al Registro de Compra de Materiales</p>
</div>


<article id="formulario">


	<t:panel titulo="Formulario de Registro de Compra de Materiales">

		<ul class="nav nav-tabs">

			<li class="active"><a data-toggle="tab" href="#form_compra">Compra</a></li>
			<li><a data-toggle="tab" href="#detalle_compra"
				onclick="cargarDetalleCompra();">Detalle de Materiales</a></li>
		</ul>
		<div class="tab-content">
			<input type="hidden" id="idproveedor"> <input type="hidden"
				id="idcompra">
			<div id="form_compra" class="tab-pane fade in active">
				<div class="row">
					<div class="col-md-12">
						<button type="button" data-toggle="modal"
							data-target="#vModalListadoProveedor" class="btn btn-primary"
							style="margin-top: 10px;" aria-hidden="true">
							<span class="glyphicon glyphicon-search"></span> Buscar
						</button>
					</div>
					<div class="col-md-2">
						<label class="control-label"><span
							style="color: red; font-weight: bold; cursor: pointer;"
							title="Campo requerido">*</span> Rif: </label> <input type="text"
							class="form-control" id="txtRif" placeholder="Rif"
							onblur="consultarRif(this.value);">
					</div>
					<div class="col-md-4">
						<label class="control-label"><span
							style="color: red; font-weight: bold; cursor: pointer;"
							title="Campo requerido">*</span> Nombre: </label> <input type="text"
							class="form-control" id="txtNombre" placeholder="Nombre"
							disabled="disabled">
					</div>
					<div class="col-md-6">
						<label class="control-label"><span
							style="color: red; font-weight: bold; cursor: pointer;"
							title="Campo requerido">*</span> Dirección: </label> <input type="text"
							class="form-control" id="txtDireccion" placeholder="Dirección"
							disabled="disabled">
					</div>

				</div>
				<br>

				<div class="row">

					<div class="col-sm-6 col-md-2">
						<label class="control-label"><span
							style="color: red; font-weight: bold; cursor: pointer;"
							title="Campo requerido">*</span> Numero de Factura: </label> <input
							type="text" class="form-control" id="txtFactura"
							required="required" placeholder="Ingrese El Nro. Factura">
					</div>

					<div class="col-sm-6 col-md-2">
						<label class="control-label"><span
							style="color: red; font-weight: bold; cursor: pointer;"
							title="Campo requerido">*</span> Fecha de la Factura: </label> <input
							type="text" class="form-control fec" id="txtFechacompra"
							required="required" placeholder="Seleccione Fecha de Compra">
					</div>

					<div class="col-sm-12 col-md-3">
						<label class="control-label"><span
							style="color: red; font-weight: bold; cursor: pointer;"
							title="Campo requerido">*</span> Monto de la Factura: </label> <input
							type="text" class="form-control inputNumerico"
							id="txtMontofactura" required="required"
							placeholder="Ingrese Monto Factura">
					</div>

					<div class="col-sm-12 col-md-5">
						<label class="control-label">Detalle: </label>
						<textarea rows="" class="form-control" id="txtDescripcion"
							placeholder="Ingrese una Descripción de la Compra" cols=""></textarea>
					</div>

					<!-- <div class="col-sm-6 col-md-3">
						<label class="control-label">Estado: </label> <select
							id="cmbEstatus" class="form-control">
							<option value="1">Activo</option>
							<option value="0">Inactivo</option>
						</select>
					</div> -->
				</div>
			</div>
			<div id="detalle_compra" class="tab-pane fade">
				<div class="row">
					<div class="col-md-6">
						<label class="control-label"><span
							style="color: red; font-weight: bold; cursor: pointer;"
							title="Campo requerido">*</span> Material: </label> <input type="text"
							id="mostrarModalMateriales" data-toggle="modal"
							data-target="#vModalListadoMaterial" aria-hidden="true"
							class="form-control" readonly
							placeholder="Click para seleccionar material"
							style="cursor: pointer;" /> <input id="idmaterial" type="hidden">
					</div>
					<div class="col-md-2">
						<label class="control-label" for="txtCostoAux"><span
							style="color: red; font-weight: bold; cursor: pointer;"
							title="Campo requerido">*</span> Costo: </label> <input type="text"
							class="form-control inputNumerico" id="txtCostoAux" />
					</div>
					<div class="col-md-2">
						<label class="control-label" for="txtCantidad"><span
							style="color: red; font-weight: bold; cursor: pointer;"
							title="Campo requerido">*</span> Cantidad: </label> <input type="text"
							class="form-control soloNumero" id="txtCantidadAux" />
					</div>
					<div class="col-md-2">
						<button class="btn btn-sm btn-primary incluir" style="margin-top: 28px;"
							onclick="guardarMaterialCompra();">
							<span class='glyphicon glyphicon-plus'></span>
						</button>
					</div>
				</div>
				<div class="row" style="margin-top: 5px;">
					<div class="col-md-12">
						<table class="table table-condensed" id="listadoMaterialActivos"
							class="display" width="100%">
							<thead>
								<tr>
									<th>Nombre del material</th>
									<th width="150px">Costo Unitario(Bs)</th>
									<th width="150px">Costo Unitario($)</th>
									<th width="100px">Cantidad</th>
									<th width="150px">Costo total</th>
									<th width="100px">Opción</th>
								</tr>
							</thead>
							<tbody style="font-size: 16px;">
								<tr id='mensaje'>
									<td colspan='6'><center>
											<h4 style='color: #CCC;'>Sin materiales asignados.</h4>
										</center></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<div class="row">
					<!--  CONTENEDOR DE LOS MONTOS-->
					<div class="col-md-12">
						<div class="row" style="float: right">
							<div class="col-md-2">
								<label class="control-label">IVA: </label> <input type="text"
									class="soloNumero form-control" id="txtIva" value="0">
							</div>
							<div class="col-md-4">
								<label class="control-label">Monto IVA: </label> <input
									type="text" class="form-control" id="txtTotaliva"
									disabled="disabled" value="0,00">
							</div>
							<div class="col-md-6">
								<label class="control-label">Monto Sub-total: </label> <input
									type="text" class="form-control" id="txtMontoTotalFactura"
									disabled="disabled">
							</div>
						</div>
					</div>
					<div class="col-md-12">
						<div class="row" style="float: right">
							<div class="col-md-2">
								<input type="text" style="visibility: collapse;"
									class="form-control">
							</div>
							<div class="col-md-4">
								<input type="text" style="visibility: collapse;"
									class="form-control" disabled="disabled">
							</div>
							<div class="col-md-6">
								<label class="control-label">Monto de la Factura: </label> <input
									type="text" style="color: #585858;" class="form-control"
									id="txtMontofacturaAux" disabled="disabled">
							</div>
						</div>
					</div>
				</div>
				<input type="hidden" id="txtTasaCambio">
			</div>
			<div class="row">
				<div class="col-md-12">
					<div class="form-group" style="text-align: center;">
						<div style="margin-top: 30px;">
							<t:btnBotonera accionguardar="guardarCompra();"
								accioncancelar="window.location.href = './compra';"
								accionlimpiar="window.location.href = './addCompra';"></t:btnBotonera>
						</div>
					</div>
				</div>
			</div>

		</div>

	</t:panel>
	<!-- MODAL LISTADO PROVEEDORES -->
	<div class="modal fade" id="vModalListadoProveedor" tabindex="-1"
		role="dialog" aria-labelledby="myModalLabel">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<div class="row">
						<div class="col-md-3">
							<h6 class="modal-title">PROVEEDORES</h6>
						</div>
						<div class="col-md-7">
							<button class="btn btn-primary btn-xs btn-block"
								id="agregarNuevoProveedor">
								<span class='glyphicon glyphicon-plus'></span> Agregar Nuevo
								proveedor
							</button>

						</div>
						<div class="col-md-2">
							<button type="button" class="close" data-dismiss="modal">&times;</button>
						</div>
					</div>

				</div>
				<div class="modal-body">
					<table id="ListadoProveedor" class="display tablamodal"
						width="100%">
						<thead>
							<tr>
								<th>idproveedor</th>
								<th>Rif</th>
								<th>Nombre</th>
								<th>Direccion</th>
							</tr>
						</thead>
						<tfoot>
							<tr>
								<th>idproveedor</th>
								<th>Rif</th>
								<th>Nombre</th>
								<th>Direccion</th>
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
	<!-- FIN MODAL LISTADO PROVEEDORES -->
	<!-- ########################################################################################################### -->
	<!-- MODAL LISTADO MATERIALES -->
	<div id="vModalListadoMaterial" class="modal fade" role="dialog">
		<div class="modal-dialog">
			<!-- Modal content-->
			<div class="modal-content">
				<div class="modal-header">

					<div class="row">
						<div class="col-md-3">
							<h6 class="modal-title">MATERIALES</h6>
						</div>
						<div class="col-md-7">
							<button class="btn btn-primary btn-xs btn-block"
								id="agregarNuevoMaterial">
								<span class='glyphicon glyphicon-plus'></span> Agregar Nuevo
								material
							</button>

						</div>
						<div class="col-md-2">
							<button type="button" class="close" data-dismiss="modal">&times;</button>
						</div>
					</div>

				</div>
				<div class="modal-body">
					<table id="ListadoMaterial" class="display tablamodal" width="100%">
						<thead>
							<tr>
								<th>idmaterial</th>
								<th>Nombre</th>
								<th>Descripcion</th>
							</tr>
						</thead>
						<tbody>

						</tbody>
					</table>
				</div>
				<!-- <div class="modal-footer">
		      	<button type="button"  class="btn btn-sm btn-default" data-dismiss="modal">Aceptar</button>
		      </div> -->
			</div>
		</div>
	</div>
	<!--FIN VENTANA MODAL LISTADO DE LAS SUB-ETAPAS -->
	<!-- MODAL AGREGAR MATERIAL -->
	<div id="vModalNuevoMaterial" class="modal fade" role="dialog">
		<div class="modal-dialog modal-lg">
			<!-- Modal content-->
			<div class="modal-content">
				<div class="modal-header">

					<div class="row">
						<div class="col-md-8">
							<h6 class="modal-title">Incluir Material</h6>
						</div>

						<div class="col-md-4">
							<button type="button" class="close" data-dismiss="modal">&times;</button>
						</div>
					</div>

				</div>
				<div class="modal-body">
					<input type="hidden" id="btnCategoria" value="0">
					<div class="row">
						<div class="col-sm-6 col-md-6">
							<label class=" control-label"><span
								style="color: red; font-weight: bold; cursor: pointer;"
								title="Campo requerido">*</span> Nombre:</label> <input type="text"
								class="form-control" id="txtNombrematerial"
								placeholder="Ingrese El Nombre del Material"
								onblur="consultarMaterial(this.value);">
						</div>

						<div class="col-sm-6 col-md-6">
							<label class="control-label"><span
								style="color: red; font-weight: bold; cursor: pointer;"
								title="Campo requerido">*</span> Catégoria&nbsp;&nbsp;
								<button class="btn btn-default btn-xs" id="agregarCategoria"
									title="Agregar nueva categoria">
									<span class="glyphicon glyphicon-plus"></span>
								</button></label> <select class="form-control" id="txtCategoria">
								<option value="">Seleccionar</option>
							</select> <input type="text" id="txtCategoriaAux" class="form-control"
								style="display: none;">
						</div>
						<div class="col-sm-12 col-md-12">
							<label class="control-label"><span
								style="color: red; font-weight: bold; cursor: pointer;"
								title="Campo requerido">*</span> Descripción</label> <input type="text"
								class="form-control" id="txtDescripcionmaterial"
								placeholder="Ingrese una Descripción del Material">
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-sm btn-success"
						onclick="guardarMaterial();">Guardar</button>
				</div>

			</div>
		</div>
	</div>
	<!--FIN VENTANA MODAL AGREGAR MATERIAL -->
	<!-- MODAL AGREGAR PROVEEDOR -->
	<div id="vModalNuevoProveedor" class="modal fade" role="dialog">
		<div class="modal-dialog modal-lg">
			<!-- Modal content-->
			<div class="modal-content">
				<div class="modal-header">

					<div class="row">
						<div class="col-md-8">
							<h6 class="modal-title">Incluir Proveedor</h6>
						</div>

						<div class="col-md-4">
							<button type="button" class="close" data-dismiss="modal">&times;</button>
						</div>
					</div>

				</div>
				<div class="modal-body">
					<div class="row">
						<div class=" col-sm-6 col-md-3">
							<label class="control-label"><span
								style="color: red; font-weight: bold; cursor: pointer;"
								title="Campo requerido">*</span> RIF: </label> <input type="text"
								class="form-control" id="txtRifproveedor"
								placeholder="Ingrese El RIF" onblur="consultarRif2(this.value);">
						</div>
						<div class=" col-sm-6 col-md-9">
							<label class=" control-label"><span
								style="color: red; font-weight: bold; cursor: pointer;"
								title="Campo requerido">*</span> Nombre:</label> <input type="text"
								class="form-control" id="txtNombreproveedor"
								placeholder="Ingrese El Nombre del Proveedor">
						</div>
						<div class="col-sm-12 col-md-12">
							<label class="control-label"><span
								style="color: red; font-weight: bold; cursor: pointer;"
								title="Campo requerido">*</span> Dirección: </label> <input type="text"
								class="form-control" id="txtDireccionproveedor"
								placeholder="Ingrese la Dirección Fiscal del Proveedor">
						</div>
						<div class="col-xs-6 col-sm-6 col-md-3">
							<label class="control-label"><span
								style="color: red; font-weight: bold; cursor: pointer;"
								title="Campo requerido">*</span> Teléfono: </label> <input type="text"
								class="form-control soloNumero" id="txtTelefonoproveedor"
								placeholder="Ingrese el Telefono del proveedor">
						</div>
						<div class="col-sm-12 col-md-9">
							<label class="control-label"><span
								style="color: red; font-weight: bold; cursor: pointer;"
								title="Campo requerido">*</span> Descripción</label> <input type="text"
								class="form-control" id="txtDescripcionproveedor"
								placeholder="Ingrese una Descripción del Proveedor">
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-sm btn-success"
						onclick="guardarProveedor();">Guardar</button>
				</div>

			</div>
		</div>
	</div>
	<!--FIN VENTANA MODAL AGREGAR PROVEEDOR -->
</article>