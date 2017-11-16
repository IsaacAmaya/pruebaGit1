<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="ve.com.proherco.web.comun.ConexionWeb"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" %>
<%
	JSONObject rPermisosDash = new JSONObject();
	Connection conexion;
	ConexionWeb conWeb = new ConexionWeb();
	conexion = conWeb.abrirConn();
	Statement st = conexion.createStatement();
	String idusuario = session.getAttribute("idusuario").toString().trim();
	String cade = "SELECT * FROM permisosdash where idusuario = "+session.getAttribute("idusuario");
	ResultSet rs = st.executeQuery(cade);
	while(rs.next()){
		rPermisosDash.put(rs.getString("grafica").trim(), rs.getBoolean("disponible"));
	}
	
	rs.close();
	st.close();
	conexion.close();


%>

<!DOCTYPE html>
<html>
<head>
        <meta charset="ISO-8859-1">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="Plataforma web Proherco">
        <meta name="author" content="Corporación Eureka CA">
        
        <script src="Archivos/js/jquery.js"></script>
       
        <script src="Archivos/js/jsmetro/metro.js"></script>
        <link href="Archivos/css/cssmetro/metro-icons.css" rel="stylesheet">
        
        <link rel="stylesheet" href="Archivos/css/jquery.mCustomScrollbar.css">
        
        <style type="text/css">
        	
        	@import "Archivos/css/bootstrap.min.css";
        	
        	@import "Archivos/css/variables.less";
			@import "Archivos/css/bootswatch.less";
			
        </style>
        <link href="Archivos/css/dataTables.bootstrap.css" rel="stylesheet">
        <link href="Archivos/css/jquery.dataTables.css" rel="stylesheet">
        <link href="Archivos/css/jquery-ui.css" rel="stylesheet">
        <link rel="shortcut icon" href="Archivos/imagenes/favicon.ico">
		
		
		
		<script src="Archivos/js/jquery.mCustomScrollbar.concat.min.js"></script>
		
		<script src="Archivos/js/charts/highcharts.js"></script>
		<script src="Archivos/js/charts/highcharts-more.js"></script>
		<script src="Archivos/js/charts/modules/solid-gauge.js"></script>
		
		
		<script src="Archivos/js/jsmetro/metro.js"></script>
        <script src="Archivos/js/bootstrap.min.js"></script>
        <script src="Archivos/js/jquery-ui.js"></script>
        <script src="Archivos/js/jquery.blockUI.js"></script>
        <script src="Archivos/js/jquery.numeric.js"></script>
        <script src="Archivos/js/jquery.dataTables.min.js"></script>
        <script src="Archivos/js/dataTables.bootstrap.js"></script>
        <script src="Archivos/js/variables.js"></script>
        <script src="Archivos/js/comun.js"></script>
        <script src="Archivos/js/md5.js"></script>
        
        <!-- <link href="Archivos/css/cssmyetro/metro.css" rel="stylesheet">-->
        
        
        
        
        <script src="Archivos/js/SweetAlert/dist/sweetalert.min.js"></script>
        <link rel="stylesheet" type="text/css" href="Archivos/js/SweetAlert/dist/sweetalert.css">
        <link rel="stylesheet" type="text/css" href="Archivos/js/SweetAlert/themes/google/google.css">
        <!-- <link rel="stylesheet" type="text/css" href="Archivos/js/SweetAlert/themes/facebook/facebook.css"> -->
        <!-- <link rel="stylesheet" type="text/css" href="Archivos/js/SweetAlert/themes/twitter/twitter.css"> -->
        
        
        <link rel="stylesheet" type="text/css" href="Archivos/css/estilos.css">
        
        <style type="text/css">
        	
        	.ajuste {
        	min-height: 700px;
        	max-height: auto;
        	width: 80%;
        	
        	
        	
        	}
        
        </style> 
    <!--          
<script>
		(function($){
			$(window).on("load",function(){
				$("#scrollbar").mCustomScrollbar({
					theme:"inset-3"
				});
			});
		})(jQuery);
	
		(function($){
			$(window).on("load",function(){
				$("#scrollbar2").mCustomScrollbar({
					theme:"inset-3"
				});
			});
		})(jQuery);
		
		(function($){
			$(window).on("load",function(){
				$("#scrollbar3").mCustomScrollbar({
					theme:"inset-3"
				});
			});
		})(jQuery);
	
</script>
 -->
        <title>PROHERCO</title>
 
<style>
	body {
	background: #ccc;
	
	}
	
	 .ajuste{
	
	width:88%;
	margin:auto;
	padding: 0;
	}
	ul.panel-opcion {
	  float: right;
	  padding: 0px;
	  margin: 0px;
	  list-style: none;
	  position: relative;
	}
	ul.panel-opcion > li {
  	  float: left;
	}
	ul.panel-opcion > li > a {
	  display: block;
	  float: left;
	  width: 30px;
	  height: 30px;
	  text-align: center;
	  line-height: 28px;
	  color: #22262e;
	  border: 1px solid #BBB;
	  -moz-border-radius: 20%;
	  -webkit-border-radius: 20%;
	  border-radius: 20%;
	  margin-left: 3px;
	  -webkit-transition: all 200ms ease;
	  -moz-transition: all 200ms ease;
	  -ms-transition: all 200ms ease;
	  -o-transition: all 200ms ease;
	  transition: all 200ms ease;
	}
	
	.tab > tbody > tr > td{ 
		
	padding:0px; 
	
	
	}
	.tab > thead > tr > th{ 
		
	text-align:center; 
	
	
	}
	
	
.panel-toggled .panel-body,
.panel-toggled .panel-footer {
  display: none;
}
/* PANEL REFRESHING */


.chart-holder {
	width:430px; 
	height:260px;

}

.panel-full {
	width: 100%;
	height:100%;

}



.orden {
	float:left;
	margin:0px 20px 0px 0px;
	
}

.menuinicio {
            	padding: 3px;
                cursor: pointer;
                color: white;
                
                background-color: #750000;
                margin-top: 5px;
            	margin-left:0px;
            	
            
            }
            .menuinicio:hover{
                text-shadow: 0px 1px 10px #FFFFFF;
                
                
            }
            .exit {
            	font-size:20px;
            	color:#fff;
                cursor: pointer;
              
              
               
            	
            
            }
            .exit:hover{
                text-shadow: 0px 1px 10px #FFFFFF;
                color:white;
                text-decoration:none;
                
            }
            
            .usuario {
            	float:right;
            	margin-top:10px;
            	margin-right:10px;
            	min-width:10px;
            	color:#fff; 
            	height:32px;
            	font-size:16px; 
            	padding-left:10px; 
            	            	
            }
            
            .dolar{
            font-size:20px;
            	color:#fff;
            }
</style>

<!-- ESTILO PARA LA BARRA LATERAL -->
<style> 
  
       
    .charm {
  display: block;
  position: fixed;
  z-index: 1060;
  background: rgba(29,29,29,1);
  color: #ccc;
  padding: .625rem;
  -webkit-transform: translateZ(0);
  transform: translateZ(0);
}
.charm .charm-closer {
  position: absolute;
  display: block;
  padding: .5rem;
  text-align: center;
  vertical-align: middle;
  font-size: 2rem;
  font-weight: normal;
  z-index: 3;
  outline: none;
  cursor: pointer;
  color: #777777;
  top: .25rem;
  right: 1rem;
}
.charm .charm-closer:after {
  content: '\D7';
  position: absolute;
  left: 50%;
  top: 50%;
  margin-top: -0.65rem;
  margin-left: -0.35rem;
}
.charm .charm-closer:hover {
  color: #ffffff;
}

.table-hover tbody > tr > td {
	

}

.table-hover tbody > tr > td:hover {
	color:#000;

}

</style>

<!-- ESTILO PARA EL CHECKBOX -->

   <style>
    
    .switch,
.switch-original {
  display: inline-block;
  margin: 0 .625rem 0 0;
  -webkit-user-select: none;
     -moz-user-select: none;
      -ms-user-select: none;
          user-select: none;
}
.switch input,
.switch-original input {
  position: absolute;
  opacity: 0;
  width: 0.0625rem;
  height: 0.0625rem;
}
.switch .check,
.switch-original .check,
.switch .caption,
.switch-original .caption {
  display: inline-block;
  vertical-align: middle;
  line-height: 18px;
}
.switch .check {
  width: 36px;
  height: 16px;
  background-color: #929292;
  border-radius: 8px;
  overflow: visible;
  position: relative;
  cursor:pointer;
}
.switch .check:before {
  position: absolute;
  display: block;
  content: "";
  width: 22px;
  height: 22px;
  z-index: 2;
  margin-top: -4px;
  margin-left: -3px;
  border-radius: 50%;
  background-color: #ffffff;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.35);
}
.switch input:checked ~ .check {
  background-color: #008287;
}
.switch input:not(:checked) ~ .check:before {
  background-color: #ffffff;
  transition: all 0.2s linear;
}
.switch input:checked ~ .check {
  background-color: #008287;
}
.switch input:checked ~ .check:before {
  -webkit-transform: translateX(22px);
          transform: translateX(22px);
  transition: all 0.2s linear;
}
.switch input:disabled ~ .check {
  background-color: #D5D5D5;
}
.switch input:disabled ~ .check:before {
  background-color: #BDBDBD;
}
.switch-original .caption {
  margin: 0 5px;
}
.switch-original .check {
  position: relative;
  height: 1.125rem;
  width: 2.8125rem;
  outline: 2px #a6a6a6 solid;
  border: 1px #fff solid;
  cursor: pointer;
  background: #A6A6A6;
  z-index: 1;
  display: inline-block;
  vertical-align: middle;
}
.switch-original .check:after {
  position: absolute;
  left: -1px;
  top: -1px;
  display: block;
  content: "";
  height: 1rem;
  width: .5625rem;
  outline: 2px #333 solid;
  border: 1px #333 solid;
  cursor: pointer;
  background: #333;
  z-index: 2;
  transition: all 0.2s linear;
}
.switch-original input[type="checkbox"]:focus ~ .check {
  outline: 1px #999999 dotted;
}
.switch-original input[type="checkbox"]:checked ~ .check {
  background: #008287;
}
.switch-original input[type="checkbox"]:checked ~ .check:after {
  left: auto;
  -webkit-transform: translateX(2rem);
          transform: translateX(2rem);
  transition: all 0.2s linear;
}
.switch-original input[type="checkbox"]:disabled ~ .check {
  background-color: #e6e6e6;
  border-color: #ffffff;
}
.switch-original input[type="checkbox"]:disabled ~ .check:after {
  background-color: #8a8a8a;
  outline-color: #8a8a8a;
  border-color: #8a8a8a;
}
    
    </style>

</head>
<body>

<script>


$.getJSON("https://s3.amazonaws.com/dolartoday/data.json", function(dolartoday) {   
    time = dolartoday._timestamp.fecha_corta;
    a = dolartoday._labels.a;
    a1 = dolartoday._labels.a1;
    b = dolartoday._labels.b;
    c = dolartoday._labels.c;
    d = dolartoday._labels.d;
    
	dolart = dolartoday.USD.dolartoday;
	efectivo = dolartoday.USD.efectivo;
	cucuta = dolartoday.USD.efectivo_cucuta;
	dicom = dolartoday.USD.sicad2;
	bitcoin = dolartoday.USD.bitcoin_ref;
	
	
    //console.log(transferencia);
    //alert(transferencia);
    $("#fecha").text(time);
    $("#labela").text(a);
    $("#labela1").text(a1);
    $("#labelb").text(b);
    $("#labelc").text(c);
    $("#labeld").text(d);
    
    
    $("#aa").text(dolart);
    $("#preciodolar").text(dolart);
    $("#precioimplicito").text(efectivo);
    $("#preciocucuta").text(cucuta);
    $("#preciodicom").text(dicom);
    $("#preciobitcoin").text(bitcoin);
    
    
    
    
});  

$(document).ready(function(){
	
	
	$(".dfsgdfsg").click(function(){
		hideMetroCharm('#listagraficos');
		
		
	});
	
	});
</script>

			<div style="height:50px;width:100%; background-color:#750000;">
        	<a href="./menu" class="icon mif-4x mif-apps menuinicio" style="color:white;"></a>
        	<img class="icon" src="Archivos/images/iconmenu/LOGO.png" style="width:200px; height:30px; margin-top:0px"></img>
        
        	
        	
        
        	
          
            <span class="usuario" style="">
            <%=session.getAttribute("nombre") %><span class="mif-cog exit icon" style="padding:0px; margin-left:10px;"></span>
            
            <span class="mif-dollar2 icon exit" style="padding:6px; color:#fff; margin-left:0px;" data-toggle="modal" data-target=".modal_dolar"></span>
            <a href="./dashboard" class="mif-meter icon exit" style="padding:6px; color:#fff; margin-left:0px;"></a>
            <a href="./logout" class="mif-exit icon exit" style="padding:6px; color:#fff; margin-left:0px;"></a>
            </span>
            
        
        
        </div>

<!-- MODAL PARA EL DOLAR -->


<div class="modal fade modal_dolar" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      
      <div class="modal-header" style="">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h5 class="modal-title " id="myModalLabel" style="text-align:center"><img src="Archivos/images/dolartoday.png" style=""></img> <span id="fecha"></span></h5>
      </div>
      <div class="modal-body" id="grad1" style="">
     	<div class="row" style="">
     	<style>
		#grad1 {
    		
    		background: #088A29; /* For browsers that do not support gradients */
    		background: -webkit-linear-gradient(#088A29, #000 ); /* For Safari 5.1 to 6.0 */
   			background: -o-linear-gradient(#088A29, #000); /* For Opera 11.1 to 12.0 */
   			background: -moz-linear-gradient(#088A29, #000); /* For Firefox 3.6 to 15 */
    		background: linear-gradient(#088A29, #000); /* Standard syntax (must be last) */
				}
		</style>
     	
     	<table style="color:white;"  class="col-md-offset-3 col-md-6">
     	
     	<thead >
              <tr >
                
                <th style="width:50%"></th>
                <th style="width:50% "></th>
               
              </tr>
            </thead>
     	 <tbody>
     	<tr>
     	<td style="text-align:right;font-size:18px;"><span id="labela"></span>: </td>
     	<td style="font-size:24px;text-align:center;text-shadow:0px 0px 10px rgb(255,255,255)"> <span id="preciodolar"></span> Bs</td>
     	</tr>
     	<tr>
     	<td style="text-align:right;font-size:18px;"><span id="labela1"></span>: </td>
     	<td style="font-size:20px;text-align:center;text-shadow:0px 0px 10px rgb(255,255,255)"> <span id="preciocucuta"></span> Bs </td>
     	</tr>
     	<tr>
     	<td style="text-align:right;font-size:18px;"> <span id="labelb"></span>: </td>
     	<td style="font-size:20px;text-align:center;text-shadow:0px 0px 10px rgb(255,255,255);"> <span id="precioimplicito"></span> Bs </td>
     	</tr>
     	<tr>
     	<td style="text-align:right;font-size:18px;"> <span id="labelc"></span>: </td>
     	<td style="font-size:20px;text-align:center;text-shadow:0px 0px 10px rgb(255,255,255)"> <span id="preciodicom"></span> Bs </td>
     	</tr>
     	<tr>
     	<td style="text-align:right;font-size:18px;"><span id="labeld"></span>: </td>
     	<td style="font-size:20px;text-align:center;text-shadow:0px 0px 10px rgb(255,255,255)"> <span id="preciobitcoin"></span> Bs </td>
     	</tr>
     	
     	
     	
     	 </tbody>
     	</table>
     	
     
            
        
       
        </div>
      </div>
      
      
      
    </div>
  </div>
</div>

<button class="icon mif-4x mif-chart-pie" onclick="showMetroCharm('#listagraficos')" style="float:right;"></button>
  
  <div data-role="charm" data-position="right" id="listagraficos"><h4 style="color:#ffffff;">Lista Graficos</h4>
  
  	
  <table class="table table-hover" style="box-sizing: border-box; width:100%;" >
          
            <thead >
              <tr >
                
                <th style="width:70%"> </th>
                <th style="width:30% "> </th>
               
              </tr>
            </thead>
            <tbody id="charts">
            
            <% if(Boolean.valueOf(rPermisosDash.get("GInversionG")==null ? "false":rPermisosDash.get("GInversionG").toString())){ %>
              <tr><td>INVERSIÓN GENERAL        </td><td><label class="switch"><input type="checkbox" checked id="checkbox1" onclick="aparecer(this.id)"><span class="check"></span></label></td></tr>
            <%}%>
            <% if(Boolean.valueOf(rPermisosDash.get("GAvancePro")==null ? "false":rPermisosDash.get("GAvancePro").toString())){ %>
              <tr><td>AVANCE DEL PROYECTO      </td><td><label class="switch"><input type="checkbox" checked id="checkbox2" onclick="aparecer(this.id)"><span class="check"></span></label></td></tr>
            <%}%>
            <% if(Boolean.valueOf(rPermisosDash.get("GEstadoObra")==null ? "false":rPermisosDash.get("GEstadoObra").toString())){ %>
              <tr><td>ESTADO DE OBRAS          </td><td><label class="switch"><input type="checkbox" checked id="checkbox3" onclick="aparecer(this.id)"><span class="check"></span></label></td></tr>
            <%}%> 
            <% if(Boolean.valueOf(rPermisosDash.get("GEstadoObraEtapa")==null ? "false":rPermisosDash.get("GEstadoObraEtapa").toString())){ %>
              <tr><td>ESTADO DE OBRAS Y ETAPAS </td><td><label class="switch"><input type="checkbox" checked id="checkbox4" onclick="aparecer(this.id)"><span class="check"></span></label></td></tr>
            <%}%> 
            <% if(Boolean.valueOf(rPermisosDash.get("GMaterialE")==null ? "false":rPermisosDash.get("GMaterialE").toString())){ %> 
              <tr><td>MATERIAL ENTREGADO       </td><td><label class="switch"><input type="checkbox" checked id="checkbox5" onclick="aparecer(this.id)"><span class="check"></span></label></td></tr>
            <%}%> 
            <% if(Boolean.valueOf(rPermisosDash.get("GMaterialD")==null ? "false":rPermisosDash.get("GMaterialD").toString())){ %>   
              <tr><td>MATERIAL DISPONIBLE      </td><td><label class="switch"><input type="checkbox"  checked id="checkbox6" onclick="aparecer(this.id)"><span class="check"></span></label></td></tr>
  			<%}%> 
            <% if(Boolean.valueOf(rPermisosDash.get("GPrecioMaterial")==null ? "false":rPermisosDash.get("GPrecioMaterial").toString())){ %>  
  			  <tr><td>PRECIOS MATERIALES      </td><td><label class="switch"><input type="checkbox" checked id="checkbox7" onclick="aparecer(this.id)"><span class="check"></span></label></td></tr>
  			<%}%>
            <% if(Boolean.valueOf(rPermisosDash.get("GPagoObra")==null ? "false":rPermisosDash.get("GPagoObra").toString())){ %>  
  			  <tr><td>PAGOS DE OBRAS           </td><td><label class="switch"><input type="checkbox" id="checkbox8" onclick="aparecer(this.id)"><span class="check"></span></label></td></tr>
  			<%}%> 
            <% if(Boolean.valueOf(rPermisosDash.get("GPagoCuadrilla")==null ? "false":rPermisosDash.get("GPagoCuadrilla").toString())){ %>  
  			  <tr><td>PAGOS DE CUADRILLAS      </td><td><label class="switch"><input type="checkbox" id="checkbox9" onclick="aparecer(this.id)"><span class="check"></span></label></td></tr>
  			<%}%> 
  </tbody>
  </table>
  </div>
      
      
      <div id="contenedor" class="dfsgdfsg" style="margin-top:10px;">
      
      
      
    <div class="container ajuste row">
      
    <span id="div1"></span>
    <span id="div2"></span>
    <span id="div3"></span>
    <span id="div4"></span>
    <span id="div5"></span>
    <span id="div6"></span>
    <span id="div7"></span>
    <span id="div8"></span>
    <span id="div9"></span>
    <span id="div10"></span>
    <span id="div11"></span>
    <span id="div12"></span>
    
       
    </div>
      </div>
   
   <!-- ####  INICIO DE FUNCIONES PARA CARGAR GRAFICOS DESDE OTRO ARCHIVO  #### -->
   <script>    
$(document).ready(function(){ 
    var o = 0;
   $('#charts input').each(function(){
       o++;
       if(this.checked){
           $("#div"+o).load("modulo/charts/chart_grafico"+o+".jsp");
       }
       
   });
    
     
    }); 
function aparecer(id){
        var arre = id.split("x");
        
        if ($("#checkbox"+arre[1]).prop("checked")){
            $("#div"+arre[1]).load("modulo/charts/chart_grafico"+arre[1]+".jsp");
        }else{
            $("#div"+arre[1]).empty();
        }
    }
   
</script>
   <!-- ####  FIN DE FUNCIONES PARA CARGAR GRAFICOS DESDE OTRO ARCHIVO  #### -->
    
     
 
   
</body>
</html>



