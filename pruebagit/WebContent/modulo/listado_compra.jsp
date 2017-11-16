<%@ taglib tagdir="/WEB-INF/tags" prefix="t" %>
      	<div>
      	<a href="./compra" class="tile-small text-shadow fg-white" style="background:#00A0E3" data-role="tile">
                     <div class="tile-content iconic mif-ani-hover-bounce">
                        <img class="icon" src="Archivos/images/iconmenu/COMPRAMATERIAL.png"></img>
                    </div>
                 </a>
      	
      	<h3>Modulo de Compras</h3>
  		<p>Lista de Compras </p>
  		</div>
<script>    
		
        $(document).ready(function() {
        	
    		var tabla = $('#ListadoCompra').DataTable({
    			responsive: true,
                "language": {
                    "url": "Archivos/js/Spanish.lang"
                },
                "pagingType": "simple",
                "ajax": {
                	"url": "./Compra?operacion="+OPERACION_LISTADO,
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
                    "defaultContent":
                		'<button class="btn btn-xs btn-primary" title="Consultar" style="display:none"><span class="glyphicon glyphicon-search" aria-hidden="true"></span></button>'+
                		'<button class="btn btn-xs btn-danger" title="Eliminar" style="display:none"><span class="glyphicon glyphicon-trash" aria-hidden="true"></span></button>'+
                		'<button class="btn btn-xs btn-default" title="Imprimir Compra"><span class="glyphicon glyphicon-print" aria-hidden="true"></span></button>'
                	},
                	{
                        "targets": [ 0 ],
                        "visible": false,
                        "searchable": false
                    }],
        	        "fnDrawCallback": function( oSettings ) {
        	        	validarBotones("compra",$("#idUsuario").val(),"1");
        	        }
             });
    		
    		   		
        	$("#ListadoCompra tbody").on( 'click','button', function () {
        		  	if($(this).hasClass('btn-primary')){
        		  		var data = tabla.row( $(this).parents('tr') ).data();
        		  		var id = data[0];
        		  		window.location.href = './addCompra?id='+id;
        		  	}else if($(this).hasClass('btn-danger')){
        		  		var data = tabla.row( $(this).parents('tr') ).data();
            	        eliminarCompra(data[0]);
        		  	}if($(this).hasClass('btn-default')){
        		  		var data = tabla.row( $(this).parents('tr') ).data();
        		  		window.open('./reportes/reporteCompras.jsp?idcompra='+data[0], '_blank');
        		  	}       	        
        	}); 
        	
        	$("#aceptar").click(function(){
        		window.open('./reportes/reporteCompras.jsp?in='+$("#txtFechadesde").val()+"&fn="+$("#txtFechahasta").val()+'&p='+$("#RepProveedor").val()+'&tr='+$('input:radio[name=btnRadio]:checked').val()+'&c='+$("#RepCategoria").val()+'&m='+$("#RepMaterial").val(), '_blank');
        		$("#txtFechadesde").val("");
        		$("#mGenerarReporte").modal("hide");
        	});
        	
        	$('#mGenerarReporte').on('show.bs.modal', function (e) {
        		traerProveedores();
        		traerMaterialesPorCategoria('');
        		traerMateriales('');
        		$( ".desde" ).datepicker({
        			dateFormat: 'dd/mm/yy',
        	  		showAnim: "clip",
        	  		showWeek: true,
        	  		maxDate: "0D"
        	    });
            	
            	$( ".hasta" ).datepicker({
        			dateFormat: 'dd/mm/yy',
        	  		showAnim: "clip",
        	  		showWeek: true,
        	  		maxDate: "0D",
        	  		firstDay: 1
        	    }).datepicker("setDate", new Date());
            	
            	$("#listado").prop('checked', true);
            	$("#RepCategoria").attr("disabled", true);
    			$("#RepMaterial").attr("disabled", true);
        		
    	  	});
        	
        	$("#RepProveedor").change(function(){
        		traerMaterialesPorCategoria(this.value);
        		traerMateriales('');
        	});
        	
        	$("#RepCategoria").change(function(){
        		traerMateriales(this.value);
        	});
        	
        	 $('input:radio[name=btnRadio]').click(function(){
        		if(this.id == 'detalle'){
        			$("#RepCategoria").removeAttr("disabled");
        			$("#RepMaterial").removeAttr("disabled");
        		}else{
        			$("#RepCategoria").attr("disabled", true);
        			$("#RepMaterial").attr("disabled", true);
        			traerMaterialesPorCategoria('');
            		traerMateriales('');
        		}
        	});
        	 
		} );
        
        function eliminarCompra(id){
        	swal({   
                title: "Desea eliminar la Compra?",     
                type: "warning",   
                showCancelButton: true,   
                confirmButtonColor: "#DD6B55",   
                confirmButtonText: "Si, eliminar",   
                cancelButtonText: "No, cancelar",   
                closeOnConfirm: false,   
                closeOnCancel: true,
                showLoaderOnConfirm: true
            }, function(isConfirm){   
                if (isConfirm) { 
                	//llamar al servidor y eliminar
                	$.post("./Compra",
                			{
                				operacion :OPERACION_ELIMINAR,
                				idcompra : id            			
                			},
                	        function FuncionRecepcion(respuesta) {
                				if(respuesta.valido){
                					swal("Eliminado!", respuesta.msj, "success");
                					setTimeout(function(){
                						window.location.href = './compra';
                					}, 2000);                					
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
        
        function traerProveedores(){
        	var cont = 0;
        	$.post('./Proveedor',{
        		operacion: OPERACION_LISTADO,
        		desdeListadoCompra: 1
        	},
        	function (json){
        		if(json.valido){
        			var valor = json.data;
        			var cadena = valor.toString();
        			var tabla = '<option value="" selected>Todos</option>';
        			for(var i=0 ; i < valor.length ; i++){
        				cont++;
        				var separado = valor[i].toString().split(",");
        				//alert(separado.length);
        				if(separado.length>3){
        					tabla += '<option value="'+separado[0]+'" >'+separado[1]+' '+separado[2]+', '+separado[3]+'</option>';
        				}else{
        					tabla += '<option value="'+separado[0]+'" >'+separado[1]+' '+separado[2]+'</option>';
        				}
        			}
        			
        			if(cont>0){
        				$('#RepProveedor').html(tabla);
        			}else{
        				$('#RepProveedor').html('<option value="0">No hay resultados</option>');
        			}
                }
        	});
        }
        
        function traerMaterialesPorCategoria(idproveedor){
        	//alert(idproveedor);
        	var cont = 0;
        	$.post('./Material',{
        		operacion: OPERACION_LISTADO,
        		desdeListadoCompra: 1,
        		proveedor : idproveedor
        	},
        	function (json){
        		if(json.valido){
        			var valor = json.data;
        			var cadena = valor.toString();
        			var tabla = '<option value="" selected>Todos</option>';
        			for(var i=0 ; i < valor.length ; i++){
        				cont++;
        				var separado = valor[i].toString().split(",");
        				tabla += '<option value="'+separado[0]+'" >'+separado[0]+'</option>';
        			}
        			if(cont>0){
        				$('#RepCategoria').html(tabla);
        			}
                }
        	});
        }
        
        function traerMateriales(categoria){
        	//alert(idproveedor);
        	var cont = 0;
        	$.post('./Material',{
        		operacion: OPERACION_LISTADO,
        		desdeListadoCompra: 2,
        		categoria : categoria
        	},
        	function (json){
        		if(json.valido){
        			var valor = json.data;
        			var cadena = valor.toString();
        			var tabla = '<option value="" selected>Todos</option>';
        			for(var i=0 ; i < valor.length ; i++){
        				cont++;
        				var separado = valor[i].toString().split(",");
        				tabla += '<option value="'+separado[0]+'" >'+separado[1]+'</option>';
        			}
        			if(cont>0){
        				$('#RepMaterial').html(tabla);
        			}
                }
        	});
        }
        
</script>
<input type="hidden" value="<%=session.getAttribute("idusuario") %>" id="idUsuario">
<t:panel titulo="Lista de Compras">
            
	<div style="margin-left: 20px; margin-right: 20px">
		<a href="./addCompra" class="btn btn-success" style="margin-bottom: 15px; color: #fff;display:none;"><span class="glyphicon glyphicon-plus" aria-hidden="true" ></span> Agregar</a>
		<button class="btn btn-default" style="margin-bottom: 15px;" data-toggle="modal" data-target="#mGenerarReporte"><span class="glyphicon glyphicon-list-alt" aria-hidden="true" ></span> Reporte</button>
		<table id="ListadoCompra" class="display"  width="100%">
			<thead>
				<tr>
					<th>idcompra</th>
					<th>Proveedor </th>
					<th>Factura</th>
					<th>Fecha</th>
					<th>Monto</th>
					<th>Opciones</th>
				</tr>
			</thead>
			<tfoot>
				<tr>
					<th>idcompra</th>
					<th>Proveedor</th>
					<th>Factura</th>
					<th>Fecha</th>
					<th>Monto</th>
					<th>Opciones</th>
				</tr>
			</tfoot>
			<tbody>
			</tbody>
		</table>
	</div>
	<div id="mGenerarReporte" class="modal fade" role="dialog">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">Seleccionar los datos para generar el reporte.</h4>
				</div>
				<div class="modal-body">
					<div class="row">
						<div class="col-md-12">
							<label class="radio-inline">
						      	<input type="radio" name="btnRadio" id="listado" value="1">Listado
						    </label>
						    <label class="radio-inline">
						      	<input type="radio" name="btnRadio" id="detalle" value="2">Detalle
						    </label>
						</div>
					</div>
					<hr>
					<div class="row">
						<div class="col-md-6">
							<label>Desde:</label>
							<input type="text" class="form-control desde" id="txtFechadesde" readonly>
						</div>
						<div class="col-md-6">
							<label>Hasta:</label>
							<input type="text" class="form-control hasta" id="txtFechahasta" readonly>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12">
							<label>Proveedor:</label>
							<select class="form-control" id="RepProveedor"></select>
						</div>						
					</div>
					<div class="row">
						<div class="col-md-6">
							<label>Categoria Material:</label>
							<select class="form-control" id="RepCategoria" disabled="disabled"></select>
						</div>
						<div class="col-md-6">
							<label>Material:</label>
							<select class="form-control" id="RepMaterial" disabled="disabled"></select>
						</div>
					</div>
				</div>
				<div class="modal-footer" style="border-top:3px solid #ccc;padding:10px 10px;">
					<button type="button" class="btn btn-success" id="aceptar" style="">Aceptar</button>
				</div>
			</div>
		</div>
	</div>
</t:panel>

	
	
	