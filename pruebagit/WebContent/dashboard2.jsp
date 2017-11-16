 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="ve.com.proherco.web.comun.ConexionWeb"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" %>


<%@page import="java.util.ArrayList"%>



<%
	JSONObject rPermisosDash = new JSONObject();
	Connection conexion;
	ConexionWeb conWeb = new ConexionWeb();
	conexion = conWeb.abrirConn();
	Statement st = conexion.createStatement();
	Statement st2 = conexion.createStatement();
	String idusuario = session.getAttribute("idusuario").toString().trim();
	String cade = "SELECT * FROM permisosdash where idusuario = "+session.getAttribute("idusuario");
	ResultSet rs = st.executeQuery(cade);
	ResultSet rs2 =null;
	while(rs.next()){
		rPermisosDash.put(rs.getString("grafica").trim(), rs.getBoolean("disponible"));
	}
	
	rs.close();
	st.close();
	
	
	session.setAttribute("idproyecto", request.getParameter("id"));
	session.setAttribute("nombreproyecto", request.getParameter("np"));
	//System.out.print(session.getAttribute("idproyecto"));
	//System.out.print(session.getAttribute("nombreproyecto"));
	
	
	
	ArrayList proyectos = new ArrayList();
	Integer cont=0;
	rs2 = st2.executeQuery("select * from proyecto where estatus=1");
	while (rs2.next()) {
		cont++;
		proyectos.add(rs2.getString("idproyecto") + "/" + rs2.getString("nombre"));
		
		//nombreproyecto +=(rs.getString("nombre"));
		
	}

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
        <link href="Archivos/css/fontello/css/fontello.css" rel="stylesheet">
        <!-- <link href="Archivos/css/cssmyetro/metro.css" rel="stylesheet">-->
        
        
        
        <link rel="shortcut icon" href="Archivos/images/favicon.ico">
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
        <title>PROHERCO</title>
 
<style>
	@font-face {
			   font-family: "crillee";
			   src: url("Archivos/fonts/crillee.ttf") format("truetype");
			   
			}
			#crillee {
			   font-family:"crillee";
			}

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
	margin-top:5px;
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
  //background: rgba(29,29,29,1);
  background: #750000;
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
.tile {
  width: 150px;
  height: 150px;
  display: block;
  float: left;
  margin: 5px;
  background-color: #eeeeee;
  box-shadow: inset 0 0 1px #FFFFCC;
  cursor: pointer;
  position: relative;
  overflow: hidden;
  -webkit-user-select: none;
     -moz-user-select: none;
      -ms-user-select: none;
          user-select: none;
}
.tile .tile-label {
  position: absolute;
  bottom: 0;
  left: .625rem;
  padding: .425rem .25rem;
  z-index: 999;
}
.tile-container {
  width: 100%;
  height: auto;
  display: block;
  margin: 0;
  padding: 0;
}
.tile-container:before,
.tile-container:after {
  display: table;
  content: "";
}
.tile-container:after {
  clear: both;
}

.tile-content {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: inherit;
  overflow: hidden;
  display: none;
}
.tile-content:first-child {
  display: block;
}

.tile-content.iconic .icon {
  position: absolute;
  width: 64px;
  height: 64px;
  font-size: 64px;
  top: 50%;
  margin-top: -40px;
  left: 50%;
  margin-left: -32px;
  text-align: center;
}
.tile-small .tile-content.iconic .icon {
  width: 32px;
  height: 32px;
  font-size: 32px;
  margin-left: -16px;
  margin-top: -16px;
}

.tile-small {
  width: 150px;
  height: 150px;
  display: block;
  float: left;
  margin: 5px;
  background-color: #eeeeee;
  box-shadow: inset 0 0 1px #FFFFCC;
  cursor: pointer;
  position: relative;
  overflow: hidden;
  -webkit-user-select: none;
     -moz-user-select: none;
      -ms-user-select: none;
          user-select: none;
  overflow: visible;
  width: 70px;
  height: 70px;
}

.text-light {
  font-weight: 300;
  font-style: normal;
}


.table-hover.tared tbody > tr:hover {
	color:#666;
	font-weight:bold;
	background: #ccc;
	cursor:pointer;

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



.navbar{
	background-color: #750000;
}

.textColor{
	color : #FFF;
}

.textColor:hover{
    text-shadow: 0px 1px 10px #FFFFFF;                
                
}
    .opcionesabout{
           		color:#666666;
           		weight:bold;
           		border:solid 1px gray;
           		margin-bottom:2px;
           		
           
           }
           
            .boton1{
            	background:#ff9800;
            	color:white;
            }
            .boton2{
            	background:#2196f3;
            	color:white;
            }
            .boton3{
            	background:#4caf50;
            	color:white;
            }
          	          	
            .eurk:hover {
            	background:#2cae11;
            	font-color:white;
            	text-shadow:0px 0px 5px #2cae11;	
            }
            .social {
            	border:solid 0px #000;
            	font-size:30px;
            	cursor:pointer;
            	border-radius:5px;
            	margin-left:15px;
            	
            }
            .face:hover {
            	background:#3b5998;
            	color:white;
            	text-shadow:0px 0px 10px #3b5998;	
            }
            .twi:hover {
            	color:white;
            	background:#1da1f2;
            	text-shadow:0px 0px 10px #1da1f2;	
            }
            .inst:hover {
            	color:white;
            	background:linear-gradient( #400080, transparent),linear-gradient( 200deg, #d047d1, #ff0000,#ffff00);
            }
            .whats:hover {
            	color:white;
            	background:#3BBF26;
            	
            }
            .clasewhats{
            	color:white;
            	background:#3BBF26;
            }
            .claseerk{
            	color:white;
            	background:#2cae11;
            }
            a.links {
            	color:#666666;
            	text-decoration:none;
            }
            
            .colorerk {
            	color:#2cae11;
            }
            
            .colorerkhover {
            	color:white;
            	
            }
             .colorerkn {
            	color:#666666;
            }
    </style>

</head>
<body>


<script>
	
$.getJSON("https://s3.amazonaws.com/dolartoday/data.json", function(dolartoday) {   
    var time = dolartoday._timestamp.fecha_corta;
    var a = dolartoday._labels.a;
    var a1 = dolartoday._labels.a1;
    var b = dolartoday._labels.b;
    var c = dolartoday._labels.c;
    var d = dolartoday._labels.d;
    
	var dolart = dolartoday.USD.dolartoday;
	var efectivo = dolartoday.USD.efectivo;
	var cucuta = dolartoday.USD.efectivo_cucuta;
	var dicom = dolartoday.USD.sicad2;
	var bitcoin = dolartoday.USD.bitcoin_ref;
	
	
    //console.log(transferencia);
    //alert(transferencia);
    $("#fecha").text(time);
    $("#labela").text(a);
    $("#labela1").text(a1);
    $("#labelb").text(b);
    $("#labelc").text(c);
    $("#labeld").text(d);
    
    $("#aa").text(dolart);
    
    dolart = dolart.toString().replace(/\./g, ',');
    dolart = formatMoneda(dolart,',','.',2);
    
    efectivo = efectivo.toString().replace(/\./g, ',');
    efectivo = formatMoneda(efectivo,',','.',2);
    
    cucuta = cucuta.toString().replace(/\./g, ',');
    cucuta = formatMoneda(cucuta,',','.',2);
    
    dicom = dicom.toString().replace(/\./g, ',');
    dicom = formatMoneda(dicom,',','.',2);
    
    bitcoin = bitcoin.toString().replace(/\./g, ',');
    bitcoin = formatMoneda(bitcoin,',','.',2);
    
    $("#preciodolar").text(dolart);
    $("#precioimplicito").text(efectivo);
    $("#preciocucuta").text(cucuta);
    $("#preciodicom").text(dicom);
    $("#preciobitcoin").text(bitcoin);
    
    
    //var precio1 = $("#preciodolar").text();
	   //var fecha = $("#fecha").text();
	   //alert(dolart+" aa "+time);
	   
	   $.post('./Dashboard',{
			//VARIALES ENVIADAS PARA GENERAR LA CONSULTA
			operacion: OPERACION_INCLUIR,
			precios : dolart,
			fecha : time
			
		});
    
    
    
});  

(function($){
	$(window).on("load",function(){
		
		
		$("#left-charm").mCustomScrollbar({
			axis:"y",
			scrollButtons:{enable:false},
			theme:"light-thin",
			autoExpandScrollbar:true,
			scrollbarPosition:"auto"
		});
		
		
		
	});
})(jQuery);


$(document).ready(function(){
	
	$(".dfsgdfsg").click(function(){
		hideMetroCharm('#listagraficos');
		hideMetroCharm('#left-charm');
		
	});
	
	/*////////////////////////////*/
	var mPersonal = ['persona','cargo','trabajador','cuadrilla'];
	var mCompras = ['material','proveedor','compra'];
	var mProyectos = ['proyecto','etapa','subetapa','obras','tipoobra'];
	var mAsignacion = ['solicitudmaterial','despachomaterial','inspeccion','pago','precio'];
	var mConfiguracion = 'usuario';
    //var modulosActivos = new Array();
    
	$.post("./Cargo",{
		operacion : OPERACION_LISTADO,
		menuInicio : 1,
		idusuario : $("#idUsuario").val()
	},
	function (json){
		if(json.valido){
			var valor = json.data;
			var contPer = 0;
			var contCom = 0;
			var contPro = 0;
			var contAsi = 0;
			
			for(var i=0 ; i < valor.length ; i++){
				var separado = valor[i].toString().split(",");
				for(var x=0; x < mPersonal.length; x++){
	        		if(separado[0] == mPersonal[x]){
	        			contPer++;
	        			//alert(separado[0]);
	        			$("#"+separado[0]).css("display", "inline-block");
	        			$("#contPersonal").removeAttr("hidden");
	        		}
	        	}
				
				for(var x=0; x < mCompras.length; x++){
	        		if(separado[0] == mCompras[x]){
	        			contCom++;
	        			$("#"+separado[0]).css("display", "inline-block");
	        			$("#contCompras").removeAttr("hidden");
	        		}
	        	}
				
				for(var x=0; x < mProyectos.length; x++){
	        		if(separado[0] == mProyectos[x]){
	        			contPro++;
	        			$("#"+separado[0]).css("display", "inline-block");
	        			$("#contProyectos").removeAttr("hidden");
	        		}
	        	}
				
				for(var x=0; x < mAsignacion.length; x++){
	        		if(separado[0] == mAsignacion[x]){
	        			contAsi++;
	        			$("#"+separado[0]).css("display", "inline-block");
	        			$("#contAsignacion").removeAttr("hidden");
	        		}
	        	}
				
				if(separado[0] == mConfiguracion){
					$("#"+separado[0]).css("display", "inline-block");
        			$("#contConfiguracion").removeAttr("hidden");
        			$("#contConfiguracion").css("width","auto");
        		}
			}
			
			if(contPer == 1){
				$("#contPersonal").css("width","auto");
			}
			
			if(contCom == 1){
				$("#contCompras").css("width","auto");
			}
			
			if(contPro == 1){
				$("#contProyectos").css("width","auto");
			}
			
			if(contAsi == 1){
				$("#contAsignacion").css("width","auto");
			}
			//alert('Modulos en la vista= '+modulosMenu.length+' Modulos en la BD= '+valor.length+' Modulos que coinciden= '+cont);
        }
	});
	
	//INICIO DE FUNCION PARA EL LOGO DE EUREKA ANIMADO
	
	 $("#eventoeureka").hover(function(){
		$('#eventoeureka span').removeClass('colorerk');
		$('#eventoeureka span').addClass('colorerkhover');
		$('#eventoeureka').css("background","#2cae11");
		//$('.partesuperior').css("background","#2cae11");
		$('.partesuperior').show(1000);
		$('.parteinferior').fadeIn(1000);
		
		
		//$('.partesuperior').attr("background","#2cae11");
		
		
	    },
	    function(){
	    $('#eventoeureka span').removeClass('colorerkhover');
	    $('#eventoeureka span').addClass('colorerk');
	    $('.partesuperior').hide(1000);
   	$('.parteinferior').fadeOut(1000);
   	$('#eventoeureka').css("background","white");
   	//$('.partesuperior').css("background","white");
	        
	    }); 
	
	
	//FIN DE FUNCION PARA EL LOGO DE EUREKA ANIMADO
	
	
});
	

function cambioClave(){
	var claveactual = $("#txtClaveActual").val();
	var clavenueva = $("#txtNuevaClave").val();
	var clavenueva2 = $("#txtNuevaClave2").val();
	if(clavenueva!=clavenueva2){
		swal("Error!", "Las claves no coinciden.!", "error");
	}else{
		var usuario = $("#idUsuario").val();
		$.post("./Persona",
				{
					operacion :OPERACION_CONSULTAR,
					desdeUsuario : 2,
					usuario : usuario,
					clave : hex_md5(clavenueva2)
				},
		        function FuncionRecepcion(respuesta) {
					if(respuesta.valido){
						swal("Guardado!", "Cambio de clave exitoso. Debera iniciar sesion nuevamente.", "success");
						setTimeout(function(){
    						window.location.href = './logout';
    					}, 3000);
					}
					//desbloquearContainer();
		        }
		).fail(function(response) {
			//desbloquearContainer();
			swal("Error!", "Error en el servidor, no hay respuesta valida.", "error");
		});
	}
	
}

function consultarClaveActual(clave){
	//alert(clave+" -> "+hex_md5(clave));
	var usuario = $("#idUsuario").val();
	$.post("./Persona",
			{
				operacion :OPERACION_CONSULTAR,
				desdeUsuario : 1,
				usuario : usuario,
				clave : hex_md5(clave)
			},
	        function FuncionRecepcion(respuesta) {
				if(!respuesta.valido){
					swal("Error!", "La clave no es correcta.!", "error");
					$("#txtClaveActual").val("");
					
				}else{
					$("#txtClaveActual").prop("disabled",true);
					$("#txtNuevaClave").removeAttr("disabled");
					$("#txtNuevaClave2").removeAttr("disabled");
				}
				//desbloquearContainer();
	        }
	).fail(function(response) {
		//desbloquearContainer();
		swal("Error!", "Error en el servidor, no hay respuesta valida.", "error");
	});
}


function verAbout(){
	 $('#titleabout').text('Seleccione una Opcion');
	 $('#googlemaps').hide();
	 $('#ContentAbout1').hide();
	 $('#ContentAbout2').hide();
	 $('#ContentAbout3').hide();
	 
}
function verAboutopcion1(){
	 $('#titleabout').text('Documentación y Ayuda ');
	 $('#ContentAbout1').show();
	 $('#ContentAbout2').hide();
	 $('#ContentAbout3').hide();
	 $('#googlemaps').hide();
	 $('#boton1').addClass('boton1');
	 $('#boton2').removeClass('boton2');
	 $('#boton3').removeClass('boton3');
	 $('.partesuperior').hide();
    $('.parteinferior').hide();
}
function verAboutopcion2(){
	 $('#titleabout').text('PROHERCO - Gestion de Proyectos y Obras');
	 $('#ContentAbout1').hide();
	 $('#ContentAbout2').show();
	 $('#ContentAbout3').hide();
	 $('#googlemaps').hide();
	 $('#boton1').removeClass('boton1');
	 $('#boton2').addClass('boton2');
	 $('#boton3').removeClass('boton3');
}
function verAboutopcion3(){
	 $('#comentario1').fadeIn(500);
	 $('#titleabout').text('Bienvenidos a la Seccion Desarrollado por ');
	 $('#ContentAbout1').hide();
	 $('#ContentAbout2').hide();
	 $('#ContentAbout3').fadeIn(800);
	 $('#googlemaps').hide();
	 $('#titulopregunta').hide();
	 $('#respuestapregunta').hide();
	 $('#boton1').removeClass('boton1');
	 $('#boton2').removeClass('boton2');
	 $('#boton3').addClass('boton3');
	 
	
	 
	 
}
function verrespuesta1(){
	 
	 $('#comentario1').hide();
	 $('#titulopregunta').hide();
	 $('#titulopregunta').show(500);
	 $('#titulopregunta').text('¿Quien es Corporación Eureka!?');
	 
	 $('#respuestapregunta').hide();
	 $('#respuestapregunta').fadeIn(800);
	 $('#respuestapregunta').html('<p style="margin-left:30px;">Corporación Eureka! es una compañía proveedora ' +
				'de servicios informáticos y soluciones tecnológicas para todo tipo de empresas e instituciones.</p>' +
			'<p style="margin-left:30px;">Contamos con un equipo de profesionales expertos en informática, redes, ' +
			'sistemas de seguridad, diseño y programadores capaces de llevar a cabo cualquier tipo de proyecto de TI por muy ambicioso que parezca.</p>');
	 $('#respuestapregunta').fadeIn(800);
	 
}
function verrespuesta2(){
	 
	 
	 $('#comentario1').hide();
	 $('#titulopregunta').hide();
	 $('#titulopregunta').show(500);
	 $('#titulopregunta').text('¿Que realiza Corporación Eureka!?');
	 
	 $('#respuestapregunta').hide();
	 $('#respuestapregunta').fadeIn(800);
	 $('#respuestapregunta').html('<p style="margin-left:30px;">Diseñamos e implementamos soluciones que permiten cubrir integralmente las necesidades de TI de una organización.'+ 
			 'Considerando las necesidades particulares, nos enfocamos hasta en los más mínimos detalles.</p>' +
			'<p style="margin-left:30px;">Los proyectos que desarrollamos pueden llegar a ser de gran complejidad o tamaño, requerir de vastos conocimientos y recursos, así como experiencia en múltiples geografías e industrias,'+
			' todas ellas, capacidades que Corporación Eureka! está en condiciones de aportar a sus clientes.</p>');
	 $('#respuestapregunta').fadeIn(800);
	 
}
	function verrespuesta3(){
	 
	 
	 $('#comentario1').hide();
	 $('#titulopregunta').hide();
	 $('#titulopregunta').show(500);
	 $('#titulopregunta').text('Por Supuesto que SI te Interesa saber de Corporación Eureka!');
	 
	 $('#respuestapregunta').hide();
	 $('#respuestapregunta').fadeIn(800);
	 $('#respuestapregunta').html('<p style="margin-left:30px">En que nos basamos para afirmarlo, pues si actualmente te identificas con alguno de los siguientes casos, entonces te interesara saber de nosotros:</p>' +
			'<p style="margin-left:50px;margin-bottom:0px;"> <span style="font-weight:bold;font-size:14px;"class="glyphicon glyphicon-hand-right"></span> Si Posees una PYME y consideras que quieres mejorar tu infraestructura y seguridad, puedes contar con nosotros, pues somos los mejores.</p>'+
			'<p style="margin-left:50px;margin-bottom:0px;"> <span style="font-weight:bold;font-size:14px;"class="glyphicon glyphicon-hand-right"></span> Si Tienes un proyecto de TI en mente  que consideras que nadie lo puede realizar, te podemos asegurar que podemos realizarlo con los mas altos estándares de calidad.</p>'+
			'<p style="margin-left:50px;"> <span style="font-weight:bold;font-size:14px;"class="glyphicon glyphicon-hand-right"></span> Si por el contrario consideras que posees talento en la rama de informática, y quieres ser parte de nuestro Equipo, con mayor razón te interesara conocernos.</p>'+
			'<p style="margin-left:30px;">Solo te queda una ultima pregunta ¿Como los puedo contactar?</p>');
	 $('#respuestapregunta').fadeIn(800);
	 
}
	
	function verrespuesta4(){
		
		 
		 $('#comentario1').hide();
		 $('#titulopregunta').hide();
		 $('#titulopregunta').show(500);
		 $('#titulopregunta').text('Puedes Contactarnos a través de');
		 
		 $('#respuestapregunta').hide();
		 $('#respuestapregunta').fadeIn(800);
		 $('#respuestapregunta').html('<p style="margin-left:30px;margin-bottom:0px;font-size:14px;">Redes Sociales <span style="font-weight:bold;">@corpoeureka</span></p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a class="icon-facebook social face links" title="Contactanos en Facebook" href="https://www.facebook.com/corpoeureka/" target=”_blank”></a>'+
				 '<a class="icon-twitter social twi links" title="Contactanos en Twitter" href="https://twitter.com/corpoeureka" target=”_blank”></a>'+
	     			'<a class="icon-instagram social inst links" title="Contactanos en Instagram" href="https://www.instagram.com/corpoeureka/" target=”_blank”></a>'+
	     			'<span class="icon-whatsapp social whats links" title="Contactanos por WhatsApp" onclick="vertelefono();"></span><span id="comentario2"><span class="glyphicon glyphicon-hand-left" style="font-weight:bold;font-size:14px;"></span> Click para Obtener el Contacto</span> <span style="margin-top:-20px;">  <span id="numerotelefono" style="font-size:16px;font-weight:bold;margin-top:50px;"> (+58) 412 3024924 </span></span>'+
		 			'<p style="margin-left:30px;margin-bottom:-10px;font-size:14px;">Información de Contacto</p>'+
		 			
		 			
		 			//'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a title="Visita Nuestra Web" href="http://www.corporacioneureka.com/web/" target=”_blank” class="social eurk links" style="padding:0px 8px;"><span id="crillee" style="font-size:28px;font-weight:bold;">E</span><span id="crillee" style="font-size:35px;font-weight:bold;">!</span></a>'+
		 			
		 			'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a id="eventoeureka" onmouseout="desplegarlogo();" onmouseleave="ocultarlogo();" title="Visita Nuestra Web" href="http://www.corporacioneureka.com/web/" target=”_blank” class="social links" style="padding-top:5px;padding-left:5px;padding-right:5px;border:solid 0px #000;">'+
    				'<span id="crillee" class="colorerkn" style="font-size:30px;font-weight:bold;">E</span>'+
    				'<span id="crillee" class="colorerkn partesuperior" style="font-size:9px;padding:0px;border:solid 0px blue;position:relative; top:-17px;left:4px;letter-spacing:0.5px;">CORPORACION</span>'+
    				'<span id="crillee" class="colorerkn parteinferior" style="font-size:21px;padding:0px;margin-left:-67px;margin-right:3px;border:solid 0px #000;letter-spacing:1.2px;">ureka</span>'+
    				'<span id="crillee" class="colorerkn" style="font-size:37px;font-weight:bold;margin-left:-1px;">!</span>'+
					'</a>'+
		 			
		 			'<span class="icon-mail social whats links" title="Contactanos vía Email" onclick="vercorreo();"></span><span id="comentario3"><span class="glyphicon glyphicon-hand-left" style="font-weight:bold;font-size:14px;"></span> Click para Obtener el Contacto</span> <span style="margin-top:-20px;">  <span id="correoeureka" style="font-size:16px;font-weight:bold;margin-top:50px;">info@corporacioneureka.com</span></span>'+
		 			'<p style="margin-top:-15px;margin-bottom:0px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="icon-phone social whats links" title="Contactanos Vía Telefonica" onclick="vertelefonoserk();"></span><span id="comentario4"><span class="glyphicon glyphicon-hand-left" style="font-weight:bold;font-size:14px;"></span> Click para Obtener el Contacto</span> <span style="margin-top:-20px;">  <span id="telefonoseureka" style="font-size:16px;font-weight:bold;margin-top:50px;">(+58) 255 6236905 / (+58) 255 7113130 / (+58) 255 7113131</span></span></p>');
		 
		 $('#respuestapregunta').fadeIn(800);
		 $('#numerotelefono').hide();
		 $('#correoeureka').hide();
		 $('#telefonoseureka').hide();
		 $('#googlemaps').fadeIn(800);
		 $('.partesuperior').hide();
        $('.parteinferior').hide();
	 }

	function vertelefono(){
		$('#comentario2').hide();
		$('#numerotelefono').fadeIn(800);
		$('.icon-whatsapp').addClass('clasewhats');
	}
	function vercorreo(){
		$('#comentario3').hide();
		$('#correoeureka').fadeIn(800);
		$('.icon-mail').addClass('claseerk');
	}
	function vertelefonoserk(){
		$('#comentario4').hide();
		$('#telefonoseureka').fadeIn(800);
		$('.icon-phone').addClass('claseerk');
	}
	
	function desplegarlogo(){
		$('#eventoeureka span').removeClass('colorerkn');
		$('#eventoeureka span').addClass('colorerkhover');
		$('#eventoeureka').css("background","#2cae11");
		//$('.partesuperior').css("background","#2cae11");
		$('.partesuperior').show(800);
		$('.parteinferior').fadeIn(800);
		
		
	}
	function ocultarlogo(){
		$('#eventoeureka span').removeClass('colorerkhover');
	    $('#eventoeureka span').addClass('colorerkn');
	    $('.partesuperior').hide(800);
   	$('.parteinferior').fadeOut(800);
   	$('#eventoeureka').css("background","white");
		
		
	}




</script>

<nav class="navbar navbar-default" role="navigation" style="margin-bottom:0px;border-radius:0px;">
  <!-- El logotipo y el icono que despliega el menú se agrupan
       para mostrarlos mejor en los dispositivos móviles -->
  <div class="navbar-header" style="border:solid 0px #fff; height:50px">
    <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-ex1-collapse" style="border:solid 0px #fff;margin-top:10px;padding:8px;">
     <span class="glyphicon glyphicon-menu-hamburger exit" style="font-size:24px;color:white;"></span>
   </button>
    <a class="exit " onclick="showMetroCharm('#left-charm')" style="color:#FFF;cursor:pointer;padding-left:10px;"><span class="mif-apps mif-4x" style="padding-top:10px;"></span></a>
    <a class="exit" href="./menu" style="padding-left:10px;"><img class="icon" src="Archivos/images/iconmenu/LOGO.png" style="width:200px; height:30px; margin-top:7px" ></img></a>
  </div>
 
  <!-- Agrupar los enlaces de navegación, los formularios y cualquier
       otro elemento que se pueda ocultar al minimizar la barra -->
  <div class="collapse navbar-collapse navbar-ex1-collapse" style="border:solid 0px blue;">
 
    <ul class="nav navbar-nav navbar-right" style="border:solid 0px #fff; margin-top:-2px;padding:0px;">
    	  	<span class="usuario" style="border:solid 0px red;margin-right:20px;"> 
	    	  	<span style="font-size:18px;" id="nombreUsuario"><%=session.getAttribute("nombre") %></span>
	    	  	<input type="hidden" id="idUsuario" value="<%=session.getAttribute("idusuario") %>">
	            <span style="border:solid 0px white;">
		            <span class="mif-cog exit icon" style="padding-bottom:12px; margin-left:10px;border:solid 0px #fff;" data-toggle="modal" data-target=".modal_clave" title="Configuración"></span>
		            <span> <a class="mif-dollar2 icon exit" style=" color:#fff;padding-bottom:12px;padding-left:7px; margin-left:0px;border:solid 0px #fff;" data-toggle="modal" data-target=".modal_dolar" title="DolarToday"></a></span>
		            <span> <a href="#" class="mif-meter icon exit" style="padding-bottom:12px;padding-left:7px; color:#fff; margin-left:0px;border:solid 0px #fff;" data-toggle="modal" data-target=".modalproyecto" title="Dashboard"></a></span>
		            <span> <a href="#"class="exit icon" style="font-size:28px;font-weight:bold;padding-bottom:0px;padding-left:7px; color:#fff; margin-left:0px;border:solid 0px #fff;" data-toggle="modal" data-target=".modal_about" title="Ayuda" onclick="verAboutopcion1();">?</a></span>
		            <span> <a href="./logout" class="mif-exit icon exit" style="border:solid 0px #fff;padding-bottom:12px;padding-left:7px; color:#fff; margin-left:0px;margin-right:0px;" title="Cerrar Sesión"></a></span>
            	</span>
            </span> 
      	     
    </ul>
  </div>
</nav>

<!-- INICIO DE MODAL ABOUT-->     
<div class="modal fade modal_about" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel">
  <div class="modal-dialog modal-lg" role="document" style="">
    <div class="modal-content">
      
      <div class="modal-header" style="min-height:50px;border:solid 0px blue;background-color:#750000">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close" style="color:white;border:solid 0px white;margin-top:-10px;"><span aria-hidden="true">&times;</span></button>
        <h5 class="modal-title " id="titleabout" style="text-align:center;border:solid 0px #000;color:#ffffff;margin-top:-10px;">Seleccione una Opcion</h5>
      </div>
      <div class="modal-body " id="" style="">
     	<div class="row" style="">
     		<div class="col-md-12" style="border:solid 0px #000">
     			<div class="col-md-3" id="BotonesAbout" style="border:solid 0px green;padding:0px;">
     				<ul class="list-group">
     				<li id="boton1" class="list-group-item btn-warning opcionesabout" style="cursor:pointer;font-size:14px;font-weight:bold;width:100%;" onclick="verAboutopcion1();" title="Contiene el Manual de usuario y Tips para su uso">DOCUMENTACIÓN</li>
     				<li id="boton2" class="list-group-item btn-primary opcionesabout" style="cursor:pointer;font-size:14px;font-weight:bold;width:100%;" onclick="verAboutopcion2();" title="Contiene la informacion de que es proherco">PROHERCO-GPO</li>
     				<li id="boton3" class="list-group-item btn-success opcionesabout" style="cursor:pointer;font-size:14px;font-weight:bold;width:100%;" onclick="verAboutopcion3();">DESARROLLADO POR</li>
     				</ul>
     				
     				<!-- LOGO EUREKA ANIMADO
     				<a id="eventoeureka" title="Visita Nuestra Web" href="http://www.corporacioneureka.com/web/" target=”_blank” class="social links" style="padding-top:13px;padding-left:5px;padding-right:5px;border:solid 0px #000;">
	     				<span id="crillee" class="colorerk" style="font-size:42px;font-weight:bold;">E</span>
	     				<span id="crillee" class="colorerk partesuperior" style="font-size:11px;padding:0px;border:solid 0px blue;position:relative; top:-24px;left:-4px;letter-spacing:0.5px;">CORPORACION</span>
	     				<span id="crillee" class="colorerk parteinferior" style="font-size:28px;padding:0px;margin-left:-97px;margin-right:3px;border:solid 0px #000;letter-spacing:0.4px;">ureka</span>
	     				<span id="crillee" class="colorerk" style="font-size:51px;font-weight:bold;margin-left:-9px;">!</span>
     				</a>
     			
     				<!-- LOGO EUREKA ANIMADO-->
     				
     				
     				
     				
     			</div>
     			
     			
     			<div class="col-md-9" id="ContentAbout1" style="border:solid 0px blue;height:auto;float:right;"><br>Bienvenidos a la Seccion de Documentación,<br>
     			en estos momentos estamos realizando el manual de Usuario el cual sera publicado en esta Sección<br><br>
     			Lamentamos las Molestias Causadas
     			<br><br><br><br><br><br><br><br><br><br><br>
     		     			
     			</div>
     			<div class="col-md-9" id="ContentAbout2" style="border:solid 0px blue;height:auto;float:right;padding:0px;">
     			<br>
     				<div class="col-md-12" style="border:solid 0px green;padding:0px;">
     					<div class="col-md-4 col-xs-12" style="border:solid 0px blue;padding:0px;text-align:center;">
     					<span style="font-size:14px;font-weight:bold;color:#750000"><u>Nombre del Software:</u></span>
     					</div>
     					
     					<div class="col-md-8 col-xs-12" style="border:solid 0px red;padding:0px;padding-left:8px;text-align:left;">
     					<span style="font-size:14px;font-weight:bold;">PROHERCO-GPO</span>
     					</div>
     					
     					
     					
     					<div class="col-md-4 col-xs-12" style="border:solid 0px blue;padding:0px;text-align:center;">
     					<span style="font-size:14px;font-weight:bold;color:#750000"><u>Versión del Software:</u></span>
     					</div>
     					
     					<div class="col-md-8 col-xs-12" style="border:solid 0px red;padding:0px;padding-left:8px;text-align:left;">
     					<span style="font-size:14px;font-weight:bold;">V1.0</span>
     					</div>
     					
     					<div class="col-md-4 col-xs-12" style="border:solid 0px blue;padding:0px;text-align:center;">
     					<span style="font-size:14px;font-weight:bold;color:#750000"><u>Modulos según Versión:</u></span>
     					</div>
     					
     					<div class="col-md-8 col-xs-12" style="border:solid 0px red;padding:0px;padding-left:8px;text-align:left;">
     					
     					<span class="col-md-12" style="padding:0px;">
	     					<span style="font-size:14px;font-weight:bold;color:#000;border:solid 0px #000;padding:0px;" class="col-md-3 col-xs-12"><u>PERSONAL:</u> </span>
	     					<span style="font-size:13px;font-weight:bold;color:#666666;border:solid 0px #000;padding:0px;"class="col-md-9 col-xs-12">Persona, Cargo, Cuadrilla, Trabajador.</span>
     					</span>
     					
     					<span class="col-md-12" style="padding:0px;">
	     					<span style="font-size:14px;font-weight:bold;color:#000;border:solid 0px #000;padding:0px;" class="col-md-3 col-xs-12"><u>COMPRAS:</u> </span>
	     					<span style="font-size:13px;font-weight:bold;color:#666666;border:solid 0px #000;padding:0px;"class="col-md-9 col-xs-12">Material, Proveedor, Compras.</span>
     					</span>
     					
     					<span class="col-md-12" style="padding:0px;">
	     					<span style="font-size:14px;font-weight:bold;color:#000;border:solid 0px #000;padding:0px;" class="col-md-3 col-xs-12"><u>PROYECTOS: </u></span>
	     					<span style="font-size:13px;font-weight:bold;color:#666666;border:solid 0px #000;padding:0px;"class="col-md-9 col-xs-12">Proyectos, Obras, Etapas, Subetpas, Tipo de Obras</span>
     					</span>
     					
     					<span class="col-md-12" style="padding:0px;">
	     					<span style="font-size:14px;font-weight:bold;color:#000;border:solid 0px #000;padding:0px;" class="col-md-3 col-xs-12"><u>ASIGNACIÓN:</u> </span>
	     					<span style="font-size:13px;font-weight:bold;color:#666666;border:solid 0px #000;padding:0px;"class="col-md-9 col-xs-12">Solicitud Material, Despachos, Inspección, Pagos, Asignación de Precios</span>
     					</span>
     					     					
     					</div>
     					
     					
     					<div class="col-md-4 col-xs-12" style="border:solid 0px blue;padding:0px;text-align:center;">
     					<span style="font-size:14px;font-weight:bold;color:#750000"><u>Objetivo del Software:</u></span>
     					</div>
     					
     					<div class="col-md-8 col-xs-12" style="border:solid 0px red;padding:0px;padding-left:8px;text-align:justify;">
     					<span style="font-size:14px;font-weight:bold;">&nbsp;&nbsp;&nbsp;Gestionar el estado actual de las obras que conforman un proyecto. 
     					Debemos tener en cuenta que una Obra posee etapas y estas a su vez poseen subetapas. Dichas SubEtapas poseen computos metricos,
     					los cuales nos permiten controlar los materiales que son solicitados en una determinada subetapa.
     					</span>
     					</div>
     					
     				</div>
     				
     				 
     				     			
     			</div>
     			
     			
     			<div class="col-md-9 col-xs-12" id="ContentAbout3" style="border:solid 0px red;height:auto;float:right;margin-bottom:25px;">
     				<br><p>&nbsp;&nbsp;&nbsp;&nbsp;Como ya debes Saber <span class="label label-danger" style="color:white;background:#750000;font-size:13px;font-weight:bold;cursor:pointer;" title="Click para Conocer PROHERCO-GPO" onclick="verAboutopcion2();">PROHERCO-GPO</span>
     				 fue desarrollado por <a href="http://www.corporacioneureka.com/web/" target=”_blank” class="label" style="background:#2cae11;color:white;font-size:13px;font-weight:bold;cursor:pointer;" title="Click para Visitar Nuestra Web">CORPORACIÓN EUREKA</a>
     				 , así que ahora te estaras haciendo estas preguntas:<br><br> 
     				 <span id="pregunta1" class="btn-sm btn-primary col-md-2 col-xs-12" style="cursor:pointer;margin-right:10px;margin-bottom:2px;" onclick="verrespuesta1();" title="Click para ver respuesta"> ¿Quienes son? </span> 
     				 <span id="pregunta2" class="btn-sm btn-primary col-md-2 col-xs-12" style="cursor:pointer;margin-right:10px;margin-bottom:2px;" onclick="verrespuesta2();" title="Click para ver respuesta"> ¿Que Hacen? </span> 
     				 <span id="pregunta3" class="btn-sm btn-primary col-md-3 col-xs-12" style="cursor:pointer;margin-right:10px;margin-bottom:2px;" onclick="verrespuesta3();" title="Click para ver respuesta"> ¿Me interesa Saberlo? </span>
     				 <span id="pregunta3" class="btn-sm btn-primary col-md-3 col-xs-12" style="cursor:pointer;margin-right:10px;margin-bottom:2px;" onclick="verrespuesta4();" title="Click para ver respuesta"> ¿Como Contactarlos? </span>
     				</p>
     				<br>
     				<span id="comentario1"><span style="font-size:18px;" class="glyphicon glyphicon-hand-up"></span> Haz Click para obtener la respuesta
     					
     					<br><br>
     					<!-- INICIO DE SECCION DE PROGRAMADORES -->
     					<div style="border:solid 0px #000;float:right;">
	     					<!-- <span style="font-size:150px;padding:0px;border:solid 0px #000;line-height:180px;float:left;margin-top:-19px;font-weight:50;">[</span> -->
	     					<p style="float:left">
	     					
	     					
	     					<span style="color:#2196f3;font-weight:bold;font-size:14px;">function</span> 
	     					<span class="label label-danger" style="color:white;background:#750000;opacity:0.9;font-size:14px;font-weight:bold;">Desarrolladores()</span> <span style="color:#666666;font-weight:bold;font-size:16px;">{</span><br>
	     					
	     					&nbsp;&nbsp;&nbsp;<span style="color:#2196f3;font-weight:bold;font-size:14px;">var</span>
	     					  <span style="font-weight:bold;font-size:13px;">Lider </span> = 
	     					  <span style="color:#750000;font-weight:bold;">'Ing. Jose Luis Vizcaya' </span><span style="color:#666666;font-weight:bold;font-size:16px;"> ;</span> <br>
	     					&nbsp;&nbsp;&nbsp;<span style="color:#2196f3;font-weight:bold;opacity:0.9;font-size:14px;">var</span>
	     					  <span style="font-weight:bold;font-size:13px;">Programador1 </span>= 
	     					  <span style="color:#750000;font-weight:bold;">'Ing. Anderson Rodriguez' </span> <span style="color:#666666;font-weight:bold;font-size:16px;"> ;</span><br>
	     					&nbsp;&nbsp;&nbsp;<span style="color:#2196f3;font-weight:bold;font-size:14px;">var</span>
	     					  <span style="font-weight:bold;font-size:13px;">programador2 </span>= 
	     					  <span style="color:#750000;font-weight:bold;">'Ing. Isaac Amaya' </span> <span style="color:#666666;font-weight:bold;font-size:16px;"> ;</span> <br>
	     					
	     					<span style="color:#666666;font-weight:bold;font-size:16px;">};</span>
	     					
	     					</p>
	     					<!-- <span style="font-size:150px;padding:0px;border:solid 0px #000;line-height:180px;float:left;margin-top:-19px;font-weight:50;">]</span> -->
     					</div>
     					<!-- FIN DE SECCION DE PROGRAMADORES -->
     				
     				</span>
						
     					<div id="titulopregunta" class="col-md-12 col-xs-12" style="border:solid 0px blue;font-size:16px;font-weight:bold;">Titulo = pregunta</div>
     					<div id="respuestapregunta" class="col-md-12 col-xs-12" style="border:solid 0px red;float:right;">
     					
     					</div>
     				
     			</div>
     				
     				<div class="col-md-3" id="BotonesAbout" style="border:solid 0px #000;padding:0px;">
     				<span class="col-md-12 col-md-offset-0 col-xs-offset-3 col-xs-6" style="padding:0px;">
     						<img class="icon" src="Archivos/images/iconmenu/logoeurekacircular.png" style="width:100%;text-align:center;"></img>
     					</span>
     				<!-- LOGO EUREKA ANIMADO 
     				<a id="eventoeureka" title="Visita Nuestra Web" href="http://www.corporacioneureka.com/web/" target=”_blank” class="social links" style="padding-top:13px;padding-left:5px;padding-right:5px;border:solid 0px #000;">
	     				<span id="crillee" class="colorerk" style="font-size:42px;font-weight:bold;">E</span>
	     				<span id="crillee" class="colorerk partesuperior" style="font-size:11px;padding:0px;border:solid 0px blue;position:relative; top:-24px;left:-4px;letter-spacing:0.5px;">CORPORACION</span>
	     				<span id="crillee" class="colorerk parteinferior" style="font-size:28px;padding:0px;margin-left:-97px;margin-right:3px;border:solid 0px #000;letter-spacing:0.4px;">ureka</span>
	     				<span id="crillee" class="colorerk" style="font-size:51px;font-weight:bold;margin-left:-9px;">!</span>
     				</a>
     			
     				<!-- LOGO EUREKA ANIMADO-->
     				
     				</div>
     				
     			 <div class="col-md-12 col-xs-12" id="googlemaps" style="padding:0px;">
	      			        	<iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d11127.809100211585!2d-69.21736371378003!3d9.57157769263843!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x8e7dc1983ee4a429%3A0x11cac4b47067b12a!2sCorporaci%C3%B3n+Eureka%2C+C.A.!5e0!3m2!1ses!2sve!4v1510002920959" width="100%" height="200" frameborder="0" style="border:0" allowfullscreen></iframe>
				     		</div>
     		
     		</div>
     	
     	</div>
     	
      </div>
      
    </div>
  </div>
</div>

<!-- FIN DEL MODAL PARA ABOUT -->



<!-- INICIO DE MODAL PARA LAS CLAVES-->     
<div class="modal fade modal_clave" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel">
  <div class="modal-dialog" role="document" style="width:520px;">
    <div class="modal-content">
      
      <div class="modal-header" style="height:50px;border:solid 0px blue;background-color:#750000">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close" style="color:white;border:solid 0px white;margin-top:-10px;"><span aria-hidden="true">&times;</span></button>
        <h5 class="modal-title " id="myModalLabel" style="text-align:center;border:solid 0px #000;color:#ffffff;margin-top:-10px;">Cambiar Contraseña</h5>
      </div>
      <div class="modal-body" id="" style="">
     	<div id="form_cambio" class="row" style="border:solid 0px #000">
     	     			
     	     			<div class="form-group " >
		                    <div class=" col-xs-offset-1 col-xs-10" style="padding-bottom: 15px; z-index: 100;" >
		                        <input class="form-control" id="txtClaveActual" type="password"  placeholder="Ingrese Contraseña Actual" onblur="consultarClaveActual(this.value);">
		                    </div>
		                </div>
		
		                <div class="form-group">
		                    <div class="col-xs-offset-1 col-xs-10" style="padding-bottom: 15px; z-index: 100;" >
		                        <input class="form-control" id="txtNuevaClave" type="password" placeholder="Ingrese Nueva Contraseña" disabled="disabled">
		                    </div>
		                </div>
		                
		                 <div class="form-group">
		                    <div class="col-xs-offset-1 col-xs-10" style="padding-bottom: 20px; z-index: 100;" >
		                        <input class="form-control" id="txtNuevaClave2" type="password" placeholder="Repita Nueva Contraseña" disabled="disabled">
		                    </div>
		                </div>
		                
		                    
		                <button id="" class="col-md-offset-1 col-md-10 btn btn-primary" style="text-transform: none;" onclick="cambioClave();"> 
		                <span class="glyphicon glyphicon-ok" aria-hidden="true"> </span> GUARDAR</button>
		            
     	</div>
      </div>
      
    </div>
  </div>
</div>

<!-- FIN DEL MODAL PARA LAS CLAVES -->


  <!-- MODAL PARA SELECCIONAR PROYECTO -->
 <%   		if (cont==0) {
   			//System.out.print("es menor");

   			%>
   			<div class="modal fade modalproyecto" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel">
  			<div class="modal-dialog" role="document">
    <div class="modal-content">
        <div class="modal-body" style="text-align:center;background:#750000;">
       <button type="button" class="close" data-dismiss="modal" aria-label="Close" ><span aria-hidden="true" style="color:white;">&times;</span></button>
		
		
		
		<h5 style="color:white;">El Dashboard no se encuentra disponible</h5>
		<h5 style="color:white;">hasta tanto no agregue un Proyecto</h5>
		<span class="mif-warning  mif-ani-heartbeat mif-ani-slow" style="font-size:78px;border:solid 0px #000; text-shadow:0px 0px 10px #FFFFFF;color:white;"></span>
		<br><br>
		<a href="./proyecto" style="text-decoration:none;color:white;">Haz clic para Agregar Proyecto</a>
		</div></div></div></div>
		<%
   			}else {
   				//System.out.print("es mayor");
   			
       %>
       
       <div class="modal fade modalproyecto" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
    <div class="modal-header" style="height:50px;border:solid 0px blue;background-color:#750000">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close" style="color:white;border:solid 0px white;margin-top:-10px;"><span aria-hidden="true">&times;</span></button>
        <h5 class="modal-title " id="myModalLabel" style="text-align:center;border:solid 0px #000;color:#ffffff;margin-top:-10px;">Seleccione El Proyecto</h5>
      </div>
       <div class="modal-body">
       <span style="color:#666666">Debe Seleccionar un Proyecto para Generar el Dashboard Correspondiente</span> <br><br>
       <div class="row"  style="border:solid 0px blue;margin:auto; width:100%;margin-bottom:10px;">
       
       <%
   		String[] separproyectos;   		
   		
       for (int i = 0; i < proyectos.size(); i++) 
    	   {
    	   //System.out.print(String.valueOf(obras.get(i)));
			String nombres = String.valueOf(proyectos.get(i));
			separproyectos = nombres.split("/");
			
			
			//System.out.print(i);
       %>
       	<div class="col-md-6" style="border:solid 0px red;margin-bottom:30px;">
      				
					<a href="./dashboard?id=<%=separproyectos[0]%>&np=<%=separproyectos[1]%>" class="tile text-shadow col-md-12 fg-white"
						style="background: #D1903A;width:100%;margin:0px;text-align:center;text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.4)" data-role="tile">
						<div class="tile-content iconic  mif-ani-hover-shuttle">
						<img class="icon" src="Archivos/images/iconmenu/PROYECTOS.png" style="margin-top:-50px;text-align:center"></img>
						</div> <span class="tile-label"style="font-size:18px;color:white;"><%=separproyectos[1]%></span>
					</a>
			
	       		
      	</div>
       <% } }
       
       %>
       
       </div>
       
      </div>
       
    </div>
  </div>
</div>
   <!-- FIN DEL MODAL PARA SELECCIONAR PROYECTO -->
   
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
<div class="row" style="margin:0px;">
<div class="col-md-12">
<button class="icon mif-4x mif-chart-pie" onclick="showMetroCharm('#listagraficos')" style="float:right;margin-right:-15px;"></button>
  </div></div>
  <div data-role="charm" data-position="right" id="listagraficos">
  
  <h3 class="text-light"style="color:#ffffff;">Lista Graficos</h3>
  
  	
  <table class="table table-hover tared" style="box-sizing: border-box; width:100%;" >
          
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
              <tr><td>AVANCE DEL PROYECTO      </td><td><label class="switch"><input type="checkbox"  checked id="checkbox2" onclick="aparecer(this.id)"><span class="check"></span></label></td></tr>
            <%}%>
            <% if(Boolean.valueOf(rPermisosDash.get("GEstadoObra")==null ? "false":rPermisosDash.get("GEstadoObra").toString())){ %>
              <tr><td>ESTADO DE OBRAS          </td><td><label class="switch"><input type="checkbox" checked id="checkbox3" onclick="aparecer(this.id)"><span class="check"></span></label></td></tr>
            <%}%> 
            <% if(Boolean.valueOf(rPermisosDash.get("GEstadoObraEtapa")==null ? "false":rPermisosDash.get("GEstadoObraEtapa").toString())){ %>
              <tr><td>ESTADO DE OBRAS Y ETAPAS </td><td><label class="switch"><input type="checkbox"  checked id="checkbox4" onclick="aparecer(this.id)"><span class="check"></span></label></td></tr>
            <%}%> 
            <%-- <% if(Boolean.valueOf(rPermisosDash.get("GMaterialE")==null ? "false":rPermisosDash.get("GMaterialE").toString())){ %> 
              <tr><td>MATERIAL ENTREGADO       </td><td><label class="switch"><input type="checkbox" checked id="checkbox5" onclick="aparecer(this.id)"><span class="check"></span></label></td></tr>
            <%}%>  --%>
            <% if(Boolean.valueOf(rPermisosDash.get("GMaterialD")==null ? "false":rPermisosDash.get("GMaterialD").toString())){ %>   
              <tr><td>MATERIAL DISPONIBLE      </td><td><label class="switch"><input type="checkbox"  checked id="checkbox5" onclick="aparecer(this.id)"><span class="check"></span></label></td></tr>
  			<%}%> 
            <% if(Boolean.valueOf(rPermisosDash.get("GPrecioMaterial")==null ? "false":rPermisosDash.get("GPrecioMaterial").toString())){ %>  
  			  <tr><td>PRECIOS MATERIALES      </td><td><label class="switch"><input type="checkbox"  checked id="checkbox6" onclick="aparecer(this.id)"><span class="check"></span></label></td></tr>
  			<%}%>
            <%--<% if(Boolean.valueOf(rPermisosDash.get("GPagoObra")==null ? "false":rPermisosDash.get("GPagoObra").toString())){ %>  
  			  <tr><td>PAGOS DE OBRAS           </td><td><label class="switch"><input type="checkbox" id="checkbox7" onclick="aparecer(this.id)"><span class="check"></span></label></td></tr>
  			<%}%> 
            <% if(Boolean.valueOf(rPermisosDash.get("GPagoCuadrilla")==null ? "false":rPermisosDash.get("GPagoCuadrilla").toString())){ %>  
  			  <tr><td>PAGOS DE CUADRILLAS      </td><td><label class="switch"><input type="checkbox" id="checkbox8" onclick="aparecer(this.id)"><span class="check"></span></label></td></tr>
  			<%}%> --%>
  </tbody>
  </table>
  </div>
      
      
      <div id="contenedor" class="dfsgdfsg" style="margin-top:10px;margin-bottom:0px;border:solid 0px #000">
      
      
      
    <div class="container ajuste" style="border:solid 0px #000">     	        
    	        
    <div class="row">	       
      
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
      </div>
   
   
   
   
   
   <!-- INICIO DEL MENU-LEFT  -->

		
        <div data-role="charm" data-position="left" id="left-charm"  >
        <h3 class="text-light" style="color:white">Modulos</h3>
        
        
        <div class="scroll">  
        <!-- ##### INICIO DEL PRIMER CONTENEDOR DE LOS MODULOS -->
        <div class="triple" style="width: 280px" id="contPersonal" hidden="hidden">
            <h4 class="text-light "style="color:white" > Personal</h4>

            <div class="tile-container" >

                <a href="./persona" class="tile-small text-shadow " style="background:#666633; color:white;display:none" data-role="tile" title="Persona" id="persona" >
                    <div class="tile-content iconic mif-ani-hover-shuttle">
                        <img class="icon" src="Archivos/images/iconmenu/PERSONA.png"></img>
                    </div>
                </a>
                 <a href="./cargo" class="tile-small text-shadow  fg-white" style="background:#105284; color:white;display:none" data-role="tile" title="Cargo" id="cargo" >
                    <div class="tile-content iconic mif-ani-hover-shuttle">
                        <span class="icon mif-profile"></span>
                    </div>
                </a>
                
                 <a href="./trabajador" class="tile-small text-shadow  fg-white" style="background:#CE352C; color:white;display:none" data-role="tile" title="Trabajador" id="trabajador" >
                    <div class="tile-content iconic mif-ani-hover-shuttle">
                        <img class="icon" src="Archivos/images/iconmenu/TRABAJADOR.png"></img>
                    </div>
                </a>
                
                <a href="./cuadrilla" class="tile-small text-shadow fg-white" style="background:#ECB54E; color:white;display:none" data-role="tile" title="Cuadrilla" id="cuadrilla">
                    <div class="tile-content iconic mif-ani-hover-shuttle">
                        <img class="icon" src="Archivos/images/iconmenu/CUADRILLAS.png"></img>
                    </div>
                </a>
                
            </div>
        </div>
        <!-- ##### FIN DEL PRIMER CONTENEDOR DE LOS MODULOS -->
       

        <!-- ##### INICIO DEL SEGUNDO CONTENEDOR DE LOS MODULOS -->
        <div class="triple" style="width: 280px" id="contCompras" hidden="hidden">
            <h4 class="text-light "style="color:white">Compras</h4>

            <div class="tile-container">

                <a href="./material" class="tile-small text-shadow fg-white" style="background:#A35612; color:white;display:none" data-role="tile" title="Material" id="material">
                    <div class="tile-content iconic mif-ani-hover-shuttle">
                        <img class="icon" src="Archivos/images/iconmenu/MATERIAL.png"></img>
                    </div>
                    
                </a>
                 <a href="./proveedor" class="tile-small text-shadow fg-white" style="background:#29286A; color:white;display:none" data-role="tile" title="Proveedor" id="proveedor">
                    <div class="tile-content iconic mif-ani-hover-shuttle">
                        <img class="icon" src="Archivos/images/iconmenu/PROVEEDOR.png"></img>
                    </div>
                    
                </a>
                
                 <a href="./compra" class="tile-small text-shadow fg-white" style="background:#00A0E3; color:white;display:none" data-role="tile" title="Compra de Material" id="compra">
                     <div class="tile-content iconic mif-ani-hover-shuttle">
                         <img class="icon" src="Archivos/images/iconmenu/COMPRAMATERIAL.png"></img>
                    </div>
                 </a>
                            
            </div>
        </div>
        <!-- ##### FIN DEL SEGUNDO CONTENEDOR DE LOS MODULOS -->
        
        <!-- ##### INICIO DEL TERCER CONTENEDOR DE LOS MODULOS -->
        <div class="triple" style="width: 280px" id="contProyectos" hidden="hidden">
            <h4 class="text-light "style="color:white">Proyectos</h4>
            <div class="tile-container">

                <a href="./proyecto" class="tile-small text-shadow fg-white" style="background:#D1903A; color:white;display:none" data-role="tile" title="Proyectos" id="proyecto">
                    <div class="tile-content iconic mif-ani-hover-shuttle">
                        <img class="icon" src="Archivos/images/iconmenu/PROYECTOS.png" ></img>
                    </div>
                </a>
                 <a href="./etapa" class="tile-small text-shadow fg-white" style="background:#008A00; color:white;display:none" data-role="tile" title="Etapas" id="etapa">
                    <div class="tile-content iconic mif-ani-hover-shuttle">
                        <img class="icon" src="Archivos/images/iconmenu/ETAPAS.png" ></img>
                    </div>
                 </a>
                
                 <a href="./subetapa" class="tile-small text-shadow fg-white" style="background:#61A184; color:white;display:none" data-role="tile" title="Sub-Etapas" id="subetapa">
                    <div class="tile-content iconic mif-ani-hover-shuttle">
                        <img class="icon" src="Archivos/images/iconmenu/SUBETAPAS.png"></img>
                    </div>
                </a>
                <a href="./obra" class="tile-small text-shadow fg-white" style="background:#647687; color:white;display:none" data-role="tile" title="Obras" id="obras">
                    <div class="tile-content iconic mif-ani-hover-shuttle">
                        <img class="icon" src="Archivos/images/iconmenu/OBRA3.png"></img>
                    </div>
                </a>
                <a href="./tipoobra" class="tile-small text-shadow fg-white" style="background:#CE352C; color:white;display:none" data-role="tile" title="Tipos de Obra" id="tipoobra">
                    <div class="tile-content iconic mif-ani-hover-shuttle">
                        <img class="icon" src="Archivos/images/iconmenu/TIPOSDEOBRA.png"></img>
                    </div>
                </a>
            </div>
        </div>
        
        
        <!-- ##### FIN DEL TERCER CONTENEDOR DE LOS MODULOS -->
        <!-- ##### INICIO DEL CUARTO CONTENEDOR DE LOS MODULOS -->
           <div class="triple" style="width: 280px" id="contAsignacion" hidden="hidden">
            <h4 class="text-light "style="color:white">Asignacion</h4>

            <div class="tile-container">

                <a href="./solicitudmaterial" class="tile-small text-shadow fg-white" style="background:#CD7372; color:white;display:none" data-role="tile" title="Solicitud de Material" id="solicitudmaterial">
                    <div class="tile-content iconic mif-ani-hover-shuttle">
                        <img class="icon" src="Archivos/images/iconmenu/SOLICITUD1.png"></img>
                    </div>
                    
                </a>
                 <a href="./despachomaterial" class="tile-small text-shadow fg-white" style="background:#FA6800; color:white;display:none" data-role="tile" title="Despacho de Material" id="despachomaterial">
                    <div class="tile-content iconic mif-ani-hover-shuttle">
                        <img class="icon" src="Archivos/images/iconmenu/DESPACHO1.png"></img>
                    </div>
                    
                </a>
                
                
                 
                
                 <a href="./inspeccion?Proyecto=0&Obra=0&Etapa=0&filtradoInspeccion=1" class="tile-small text-shadow fg-white"  style="background:#003399; color:white;display:none" data-role="tile" title="Inspección" id="inspeccion">
                    <div class="tile-content iconic mif-ani-hover-shuttle">
                        <img class="icon" src="Archivos/images/iconmenu/INSPECCION1.png"></img>
                    </div>
                   
                </a>
                <a href="./pago" class="tile-small text-shadow fg-white" style="background:#FA1100; color:white;display:none" data-role="tile" title="Pagos" id="pago">
                    <div class="tile-content iconic mif-ani-hover-shuttle">
                        <img class="icon" src="Archivos/images/iconmenu/ASIGDEPAGO.png"></img>
                    </div>
                   
                </a>
                <a href="./precio" class="tile-small text-shadow fg-white" style="background:#669933; color:white;display:none" data-role="tile" title="Precios" id="precio">
                    <div class="tile-content iconic mif-ani-hover-shuttle">
                        <img class="icon" src="Archivos/images/iconmenu/PRECIO.png"></img>
                    </div>
                   
                </a>
                
                
            </div>
        </div>
	<!-- ##### FIN DEL CUARTO CONTENEDOR DE LOS MODULOS -->

</div>
</div>

<!-- FIN DEL MENU-LEFT -->
  
   <!-- ####  INICIO DE FUNCIONES PARA CARGAR GRAFICOS DESDE OTRO ARCHIVO  #### -->
   <script>    
$(document).ready(function(){ 
    var o = 0;
   $('#charts input').each(function(){
       o++;
       if(this.checked){
    	   var nom = this.id;
    	   nom = nom.split("checkbox");
    	   //alert(nom[1]);
           $("#div"+nom[1]).load("modulo/charts/chart_grafico"+nom[1]+".jsp");
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
    
    
    
      <style>
	footer {
		  border:solid 0px red;
		  bottom:0px;
		  width: 100%;
		  height:40px;
		  color: white;
		}
	</style>
	
<!--     <footer style="text-align:center;margin-top:-10px;">
	<span class="footer" > <img src="Archivos/images/iconmenu/logoeureka.png" style="width:120px;"></span>
	</footer> -->
 
   
</body>
</html>

<%
if(rs!=null) rs.close();
st.close();

conexion.close(); %> 

