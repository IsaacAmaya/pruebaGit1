<%@ taglib tagdir="/WEB-INF/tags" prefix="t" %>
<%
	String Proyecto = request.getParameter("Proyecto")=="0" ? "0":request.getParameter("Proyecto").toString().trim();
	String Obra = request.getParameter("Obra")=="0" ? "0":request.getParameter("Obra").toString().trim();
	String Etapa = request.getParameter("Etapa")=="0" ? "0":request.getParameter("Etapa").toString().trim();

%>
      	<div><a href="./inspeccion?Proyecto=0&Obra=0&Etapa=0&filtradoInspeccion=1" class="tile-small text-shadow fg-white" style="background:#003399" data-role="tile">
                    <div class="tile-content iconic mif-ani-hover-shuttle">
                        <img class="icon" src="Archivos/images/iconmenu/INSPECCION1.png" ></img>
                    </div>
                </a>
      	<h3>Modulo de Inspecciones</h3>
  		<p>Listado de Inspecciones realizadas a cada una de las Obras</p></div>
<script>    
        $(document).ready(function() {
        	
    		var tabla = $('#ListadoInspeccion').DataTable( {
    			"order": [[ 4, "desc" ]],
    			responsive: true,
                "language": {
                    "url": "Archivos/js/Spanish.lang"
                },
                "ajax": {
                	"url": "./Inspeccion?operacion="+OPERACION_LISTADO+"&Proyecto="+$("#Proyecto").val()+"&Obra="+$("#Obra").val()+"&Etapa="+$("#Etapa").val()+"&filtradoInspeccion=1",
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
                		'<button class="btn btn-xs btn-primary" title="Consultar"><span class="glyphicon glyphicon-search" aria-hidden="true"></span></button>'
                	},
                	{
                        "targets": [ 0 ],
                        "visible": false,
                        "searchable": false
                    }
                ],
    	        "fnDrawCallback": function( oSettings ) {
    	        	validarBotones("inspeccion",$("#idUsuario").val(),"1");
    	        }
             });
    		
        	$("#ListadoInspeccion tbody").on( 'click','button', function () {
        		  	if($(this).hasClass('btn-primary')){
        		  		var data = tabla.row( $(this).parents('tr') ).data();
        		  		var id = data[0];
        		  		window.location.href = './addInspeccion?id='+id+"&Proyecto="+$("#Proyecto").val()+"&Obra="+$("#Obra").val()+"&Etapa="+$("#Etapa").val()+"&filtradoInspeccion=1";
        		  	}
        	});
        	
        	var cont=0;
        	$.post('./Proyecto',{
        		operacion: OPERACION_LISTADO,
        		condicion : 2
        	},
        	function (json){
        		if(json.valido){
        			var valor = json.data;
        			var cadena = valor.toString();
        			var tabla = '';
        			for(var i=0 ; i < valor.length ; i++){
        				cont++;
        				var separado = valor[i].toString().split(",");
        				tabla += '<option value="'+separado[0]+'" '+(separado[0] == $("#Proyecto").val() ? "selected":"")+'>'+separado[1]+'</option>';
        			}
        			if(cont>0){
        				$('#idProyecto').html(tabla);
        			}
        			traerObras($('select[id=idProyecto]').val());
                }
        	});
		});
        
        function traerObras(id){
        	var cont = 0;
        	var idProyecto = $("#idProyecto").val();
        	if(id!=""){
        		idProyecto = id;
        	}
        	
        	$.post('./Obra',{
        		operacion: OPERACION_LISTADO,
        		desdeSolicitud : 1,
        		idproyecto : idProyecto,
        		nombreobra : ""
        	},
        	function (json){
        		if(json.valido){
        			var valor = json.data;
        			var cadena = valor.toString();
        			var tabla = '<option value="0" selected>Seleccione</option>';
        			for(var i=0 ; i < valor.length ; i++){
        				cont++;
        				var separado = valor[i].toString().split(",");
        				tabla += '<option value="'+separado[0]+'" '+(separado[0] == $("#Obra").val() ? "selected":"")+'>'+separado[1]+'</option>';
        			}
        			
        			if(cont>0){
        				$('#idObra').html(tabla);
        			}else{
        				$('#idObra').html('<option value="0">No hay resultados</option>');
        				$('#idEtapa').html('<option value="0">No hay resultados</option>');
        			}
        			traerEtapas($('select[id=idObra]').val());
                }
        	});
        }
        
        function traerEtapas(id){
        	var cont = 0;
        	var idObra= $("#idObra").val();
        	if(id!=""){
        		idObra = id;
        	}
        	
        	$.post('./Etapa',{
        		operacion: OPERACION_LISTADO,
        		desdeInspeccion: 1,
        		idobra : idObra
        	},
        	function (json){
        		if(json.valido){
        			var valor = json.data;
        			var cadena = valor.toString();
        			var tabla = '<option value="0" selected>Seleccione</option>';
        			for(var i=0 ; i < valor.length ; i++){
        				cont++;
        				var separado = valor[i].toString().split(",");
        				tabla += '<option value="'+separado[0]+'" '+(separado[0] == $("#Etapa").val() ? "selected":"")+'>'+separado[1]+'</option>';
        			}
        			if(cont>0){
        				$('#idEtapa').html(tabla);
        			}else{
        				$('#idEtapa').html('<option value="0">No hay resultados</option>');
        			}
                }
        	});
        }
        
        function filtrarProyectos(e){
        	
        	if(e == "btnAgregar"){
        		window.location.href="./addInspeccion?Proyecto="+$("#Proyecto").val()+"&Obra="+$("#Obra").val()+"&Etapa="+$("#Etapa").val()+"&filtradoInspeccion=1";
        	}
        	
        	if(e == "btnBuscar"){
        		window.location.href="./inspeccion?Proyecto="+$("#idProyecto").val()+"&Obra="+$("#idObra").val()+"&Etapa="+$("#idEtapa").val()+"&filtradoInspeccion=1";
        	}
        }
        
</script>

	<input type="hidden" id="Proyecto" value="<%=Proyecto %>">
    <input type="hidden" id="Obra" value="<%=Obra %>">
    <input type="hidden" id="Etapa" value="<%=Etapa %>">
    <input type="hidden" value="<%=session.getAttribute("idusuario") %>" id="idUsuario">
	<t:panel titulo="Lista de Inspecciones">
       
       <div style="margin-left: 20px; margin-right: 20px">
			<a class="btn btn-success" onclick="filtrarProyectos('btnAgregar');" style="margin-top:5px; margin-bottom:15px; color:#FFF;display:none;"><span class="glyphicon glyphicon-plus" aria-hidden="true" ></span>Agregar</a>
	       	<div class="alert" style="background:#F2F2F2;">
	       		<div class="row">
	       			<div class="col-md-4">
	       				<label>Proyecto:</label>
	       				<select class="form-control" id="idProyecto" onchange="traerObras('');">
	       					<option value="0">Proyecto</option>
	       				</select>
	       			</div>
	       			<div class="col-md-3">
	       				<label>Obra:</label>
	       				<select class="form-control" id="idObra" onchange="traerEtapas('');">
	       					<option value="0">Seleccione</option>
	       				</select>
	       			</div>
	       			<div class="col-md-3">
	       				<label>Etapa:</label>
	       				<select class="form-control" id="idEtapa">
	       					<option value="0">Seleccione</option>
	       				</select>
	       			</div>
	       			<div class="col-md-2">
	       				<a onclick="filtrarProyectos('btnBuscar');" role="button" class="btn btn-sm btn-primary" style="float:right;color:#FFF;">Buscar</a>
	       			</div>
	       		</div>
	       	</div>
	       	<table id="ListadoInspeccion" class="display"  width="100%">
	        <thead>
	            <tr>
	            	<th>idproyecto</th>
	                <th>Obra</th>
	                <th>Etapa</th>
	                <th>Subetapa</th>
	                <th>Fecha</th>
	                <th>Porcentaje</th>
	                <th>Opciones</th>
	                
	            </tr>
	        </thead>
	        <tfoot>
	            <tr>
	            	<th>idproyecto</th>
	                <th>Obra</th>
	                <th>Etapa</th>
	                <th>Subetapa</th>
	                <th>Fecha</th>
	                <th>Porcentaje</th>
	                <th>Opciones</th>
	            </tr>
	        </tfoot>
	        <tbody> 
	            
	        </tbody>
	    	</table>
    </div>
</t:panel>
