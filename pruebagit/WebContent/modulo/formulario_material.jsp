<%@ taglib tagdir="/WEB-INF/tags" prefix="t" %> 
<%
	String id = request.getParameter("id")==null ? "":request.getParameter("id").toString().trim();
%>

<script src="Archivos/js/modulo/formulario_material.js"></script>
<script>
  $( function() {
    	<% if(!id.equals("")) out.print("cargarMaterial('"+id+"')");%>
    	
    	var cont = 0;
    	$.post("./Material",{
    		operacion : OPERACION_LISTADO,
    		listadoCategoria : 1
    	},
    	function(json){
    		if(json.valido){
    			var valor = json.data;
    			var tabla = "<option value='N/A' >Seleccionar</option>";
    			for(var i=0 ; i < valor.length ; i++){
    				var separado = valor[i].toString().split(",");
    				tabla += '<option value="'+separado[0]+'" '+($("#txtCategoriaAux").val()==separado[0] ? 'selected' : '')+'>'+separado[0]+'</option>';
    				cont++;
    			}
    			
    			if(cont > 0){
    				$('#txtCategoria').html(tabla);
    				cont = 0;
    			}else{
    				$("#txtCategoria").html("<option value=''>No hay resultados</option>");
    			}
    		}
    		desbloquearContainer();
    	});
    	
    	$("#agregarCategoria").click(function(e){
    		if($("#btnCategoria").val() == "0"){
    			$("#btnCategoria").val("1");
    			$("#txtCategoria").hide(500);
        		$("#txtCategoriaAux").css("display","inline").focus();
        		$("#txtCategoriaAux").attr("required", true);
        		$("#txtCategoria").removeAttr("required");
    		}else{
    			var repetido = false;
    			$("#txtCategoria option").each(function(){    				
    				if($("#txtCategoriaAux").val()==$(this).attr('value')){
    					repetido = true;
    				}
    			});    			
    			if(!repetido){
					$("#txtCategoria").append("<option value='"+$("#txtCategoriaAux").val()+"' selected>"+$("#txtCategoriaAux").val()+"</option>");
				}
    			$("#btnCategoria").val("0");
    			$("#txtCategoria").show(500);
        		$("#txtCategoriaAux").css("display","none");
        		$("#txtCategoria").attr("required", true);
        		$("#txtCategoriaAux").removeAttr("required");
    		}
    	});
    	
    	$("#txtCategoria").change(function(){
    		$("#txtCategoriaAux").val("");
    	});
  } );
  
 
</script>

<div>
<a href="./material" class="tile-small text-shadow fg-white" style="background:#A35612" data-role="tile">
                    <div class="tile-content iconic mif-ani-hover-shuttle">
                        <img class="icon" src="Archivos/images/iconmenu/MATERIAL.png"></img>
                    </div>
                    
                </a>
<h3>Modulo de Material</h3>
  <p>Seccion Dedicada al Registro de Materiales</p>
 </div>  
   <article id="formulario">
      
      
      <t:panel titulo="Formulario de Registro de Materiales">
			<input type="hidden" id="idmaterial" >
			<input type="hidden" id="btnCategoria" value="0">
           <ul class="nav nav-tabs">           
                <li class="active"><a data-toggle="tab" href="#form_material">Material</a></li>
                <li><a data-toggle="tab" href="#movimiento" onclick="cargarEntradaMaterial();cargarSalidaMaterial();">Movimiento</a></li>
           </ul>
           <div class="tab-content" >
				<div id="form_material" class="tab-pane fade in active" style="">
	            	<div class="row">
	                    
	                    <div class="col-sm-6 col-md-4">
		                    <label class=" control-label"><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Nombre:</label>
		                    <input type="text" class="form-control" id="txtNombre" required="required" placeholder="Ingrese El Nombre del Material" onblur="consultarMaterial(this.value);">
	                    </div>                   
	                     <!-- <div class="col-sm-6 col-md-4">
	                    	<label class="control-label"><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Marca: </label>
	                      	<input type="text" class="form-control" id="txtMarca" required="required" placeholder="Ingrese la Marca del Material">
	                    </div> -->
	                    
	                    <div class="col-sm-6 col-md-4">
	                    	<label class="control-label"><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Catégoria&nbsp;&nbsp; <button class="btn btn-default btn-xs" id="agregarCategoria" title="Agregar nueva categoria"><span class="glyphicon glyphicon-plus"></span></button></label>
	                    	<select class="form-control" id="txtCategoria" required="required" >
	                    		<option value="">Seleccionar</option>
	                    	</select>
	                    	<input type="text" id="txtCategoriaAux" class="form-control" style="display:none;" >
	                    	
	                    </div>
	                    
	                    <div class="col-sm-12 col-md-8">
		                    <label class="control-label"><span style="color:red;font-weight:bold;cursor:pointer; " title="Campo requerido">*</span> Descripción</label>
		                    <input type="text" class="form-control"  id="txtDescripcion" placeholder="Ingrese una Descripción del Material" required="required" >
	                    </div>
	                    
	                    <div class="col-sm-6 col-md-4">
		                    <label class="control-label">Existencia</label>
		                    <input type="text" class="form-control"  id="txtExistencia" disabled="disabled" >
	                    </div>
	                    
	                    <div class="col-sm-6 col-md-4">
	                    <label class="control-label">Estado</label>
	                        <select id="cmbEstatus" class="form-control">
	                           <option value="1">Activo</option>
	                           <option value="0">Inactivo</option>
	                        </select>
	                    </div>                
	               </div> 
	               	
	        	</div>
	        	<div id="movimiento" class="tab-pane fade">
	        		<div class="row" >
	        			<div class="col-md-6" >
	        				<table class="table" id="listadoCompraMaterial">
	        					<thead>
	        						<tr><th colspan="3"><h6>Entradas</h6></th></tr>
	        						<tr><th>Fecha de entrada</th><th>Cantidad</th><th>Compra</th></tr>
	        					</thead>
	        					<tbody>
	        						
	        					</tbody>
	        				</table>
	        			
	        			</div>
	        			
	        			<div class="col-md-6">
	        				<table class="table" id="listadoSalidaMaterial">
	        					<thead>
	        						<tr><th colspan="3"><h6>Salidas</h6></th></tr>
	        						<tr><th>Fecha de salida</th><th>Cantidad</th><th>Solicitud</th></tr>
	        					</thead>
	        					<tbody>
	        						
	        					</tbody>
	        				</table>
	        			
	        			</div>
	        		</div>
	        	
	        	</div>
           	</div><br>
           	<div class="row">
		        <div class="col-md-12">
			        <div class="form-group" style="text-align: center; ">
						<div style="margin-top: 30px;">
							<t:btnBotonera accionguardar="guardarMaterial();" accioncancelar="window.location.href = './material';" accionlimpiar="window.location.href = './addMaterial';"></t:btnBotonera>
						</div>
			        </div>
		        </div>               
      		</div>
     </t:panel>  
    
   </article>  