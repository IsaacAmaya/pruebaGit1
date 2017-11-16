<%@ taglib tagdir="/WEB-INF/tags" prefix="t" %>
      	<div>
      		<a href="./pago" class="tile-small text-shadow fg-white" style="background:#FA1100" data-role="tile">
               <div class="tile-content iconic mif-ani-hover-shuttle">
               	<img class="icon" src="Archivos/images/iconmenu/ASIGDEPAGO.png" ></img>
               </div>
            </a>
	      	<h3>Modulo de Pagos</h3>
	  		<p>Listado de Pagos realizados</p>
  		</div>
	<script>    
        $(document).ready(function() {        	
        	var tablaListado = $('#ListadoPago').DataTable( {
    			responsive: true,
                "language": {
                    "url": "Archivos/js/Spanish.lang"
                },
                "pagingType": "simple",
                "ajax": {
                	"url": "./Pago?operacion="+OPERACION_LISTADO+"&listadoPrincipal=1",
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
                		'<button class="btn btn-xs btn-danger" title="Eliminar" style="display:none"><span class="glyphicon glyphicon-trash" aria-hidden="true"></span></button>'
                	},
                	{
                       // "targets": [ 0 ],
                        "visible": false,
                        "searchable": false
                    }],
        	        "fnDrawCallback": function( oSettings ) {
        	        	validarBotones("pago",$("#idUsuario").val(),"1");
        	        }
             });
    		
    		   		
        	$("#ListadoPago tbody").on( 'click','button', function () {
        		  	if($(this).hasClass('btn-primary')){
        		  		var data = tablaListado.row( $(this).parents('tr') ).data();
        		  		var id = data[0];
        		  		var estatus = $(this).parents("tr").find("td").eq(5).text();
        		  		if(estatus=="Pagado"){
        		  			window.location.href = './addPago?id='+id;
        		  		}else{
        		  			window.location.href = './addPago?id='+id+'&formSecundario=1';
        		  		}
        		  	}else if($(this).hasClass('btn-danger')){
        		  		var data = tablaListado.row( $(this).parents('tr') ).data();
            	        eliminarPago(data[0]);
        		  	}
        	});
        	
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
    	  		maxDate: "0D"
    	    });
        	
        	$('#vModalFechas').on('show.bs.modal', function (e) {
        		traerCuadrilla();      			
    	  	});        	
        	
        });
        
        function eliminarPago(id){
        	swal({   
                title: "Desea eliminar el proyecto?",     
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
                	$.post("./Pago",
                			{
                				operacion :OPERACION_ELIMINAR,
                				idpago : id            			
                			},
                	        function FuncionRecepcion(respuesta) {
                				if(respuesta.valido){
                					swal("Eliminado!", respuesta.msj, "success");
                					window.location.href = './pago';
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
        
        
        
        function traerCuadrilla(){
        	var cont = 0;
        	$.post('./Cuadrilla',{
        		operacion: OPERACION_LISTADO,
        		desdePago: 1
        	},
        	function (json){
        		if(json.valido){
        			var valor = json.data;
        			var cadena = valor.toString();
        			var tabla = '<option value="0" selected>Seleccione</option>';
        			for(var i=0 ; i < valor.length ; i++){
        				cont++;
        				var separado = valor[i].toString().split(",");
        				tabla += '<option value="'+separado[0]+'" >CUADRILLA: '+separado[1]+', JEFE: '+separado[2]+'.</option>';
        			}
        			
        			if(cont>0){
        				$('#idCuadrilla').html(tabla);
        			}else{
        				$('#idCuadrilla').html('<option value="0">No hay resultados</option>');
        			}
                }
        	});
        }
        
        function cargarResultado(){
        	var fachaDesde = $("#txtFechadesde").val();
        	var fachaHasta= $("#txtFechahasta").val();
        	var idcuadrilla = $("#idCuadrilla").val();
        	if(fachaDesde!='' && fachaHasta!='' && idcuadrilla!='0'){
        		window.location.href = './addPago?fechaDesde='+fachaDesde+'&fechaHasta='+fachaHasta+'&idcuadrilla='+idcuadrilla;
        	}else{
        		swal("Error!", "No debe dejar campos vacios.", "error");
        	}
        }
	</script>
    <input type="hidden" value="<%=session.getAttribute("idusuario") %>" id="idUsuario">
	<t:panel titulo="Lista de Pagos">
       
       	<div style="margin-left: 20px; margin-right: 20px">
       		<button type="button" style="margin-top:5px; margin-bottom:15px;display:none;" class="btn btn-success" data-toggle="modal" data-target="#vModalFechas"><span class="glyphicon glyphicon-plus" aria-hidden="true" ></span> Nuevo Pago</button>
	       	<table id="ListadoPago" class="display"  width="100%">
	        <thead>
	            <tr>
	            	<th>Nro pago</th>
	                <th>Cuadrilla</th>
	                <th>Proyecto</th>
	                <th>Monto</th>
	                <th>Fecha</th>
	                <th>Estatus</th>
	                <th>Opciones</th>
	                
	            </tr>
	        </thead>
	        <tfoot>
	            <tr>
	            	<th>Nro pago</th>
	                <th>Cuadrilla</th>
	                <th>Proyecto</th>
	                <th>Monto</th>
	                <th>Fecha</th>
	                <th>Estatus</th>
	                <th>Opciones</th>
	            </tr>
	        </tfoot>
	        <tbody> 
	            
	        </tbody>
	    	</table>
    	</div>
    	
    	<div id="vModalFechas" class="modal fade" role="dialog">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal">&times;</button>
						<h4 class="modal-title">Seleccione el rango de fechas</h4>
					</div>
					<div class="modal-body">
						<div class="row">
							<div class="col-md-6">
								<label><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Desde:</label>
								<input type="text" class="form-control desde" id="txtFechadesde">
							</div>
							<div class="col-md-6">
								<label><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Hasta:</label>
								<input type="text" class="form-control hasta" id="txtFechahasta">
							</div>
						</div>
						<div class="row">
							<div class="col-md-12">
								<label><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Seleccione la cuadrilla:</label>
								<select class="form-control" id="idCuadrilla">
									<option value="0">Seleccione</option>
								</select>
							</div>
							
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-success" onclick="cargarResultado();">Aceptar</button>
					</div>
				</div>
			</div>
		</div>
	</t:panel>
