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
<link href="Archivos/css/cssmetro/metro.css" rel="stylesheet">
<link href="Archivos/css/cssmetro/metro-icons.css" rel="stylesheet">
<script src="Archivos/js/jsmetro/jquery.js"></script>
<script src="Archivos/js/jsmetro/metro.js"></script>

<style type="text/css">
@import "Archivos/css/bootstrap.min.css";

@import "Archivos/css/variables.less";

@import "Archivos/css/bootswatch.less";
</style>


<link rel="stylesheet" href="Archivos/css/jquery.mCustomScrollbar.css">
<link href="Archivos/css/fontello/css/fontello.css" rel="stylesheet">

<link href="Archivos/css/dataTables.bootstrap.css" rel="stylesheet">
<link href="Archivos/css/jquery.dataTables.css" rel="stylesheet">
<link href="Archivos/css/jquery-ui.css" rel="stylesheet">
<link rel="shortcut icon" href="Archivos/images/favicon.ico">


<script src="Archivos/js/jquery.mCustomScrollbar.concat.min.js"></script>


<script src="Archivos/js/bootstrap.min.js"></script>
<script src="Archivos/js/jquery-ui.js"></script>
<script src="Archivos/js/jquery.blockUI.js"></script>
<script src="Archivos/js/jquery.numeric.js"></script>
<script src="Archivos/js/jquery.dataTables.min.js"></script>
<script src="Archivos/js/dataTables.bootstrap.js"></script>
<script src="Archivos/js/variables.js"></script>
<script src="Archivos/js/comun.js"></script>
<script src="Archivos/js/md5.js"></script>

<script src="Archivos/js/SweetAlert/dist/sweetalert.min.js"></script>
<link rel="stylesheet" type="text/css"
	href="Archivos/js/SweetAlert/dist/sweetalert.css">
<link rel="stylesheet" type="text/css"
	href="Archivos/js/SweetAlert/themes/google/google.css">
<!--<link rel="stylesheet" type="text/css" href="Archivos/js/SweetAlert/themes/facebook/facebook.css"> -->
<!-- <link rel="stylesheet" type="text/css" href="Archivos/js/SweetAlert/themes/twitter/twitter.css">-->

<style>
@font-face {
			   font-family: "crillee";
			   src: url("Archivos/fonts/crillee.ttf") format("truetype");
			   
			}
			#crillee {
			   font-family:"crillee";
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
			


.tile, .tile-small, .tile-sqaure, .tile-wide, .tile-large, .tile-big,
	.tile-super {
	opacity: 0.5;
	-webkit-transform: scale(.5);
	transform: scale(.5);
}

.tile-area-controls {
	
	
}

.tile-group {
	left: 40px;
}

.titulo {
	position: absolute;
	left: 60px;
	top: 45px;
}

.exit {
	cursor: pointer;
}

.exit:hover {
	text-shadow: 0px 1px 10px #FFFFFF;
	color: white;
	text-decoration: none;
}
.bor {
	border:solid 1px white;
}
</style>





<script>

$(document).ready(function(){
		
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



        (function($){
			$(window).on("load",function(){
				
				$("#hscroll").mCustomScrollbar({
					axis:"yx",
					//axis:"x",
					scrollButtons:{enable:false},
					theme:"light-thin",
					autoExpandScrollbar:true,
					scrollbarPosition:"auto"
				});
								
			});
		})(jQuery);
        
        
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

<link rel="stylesheet" type="text/css" href="Archivos/css/estilos.css">

<title>PROHERCO</title>
</head>
<body id="hscroll" style="background: #750000;border:solid 0px white;">
	<script>
        (function($) {
            $.StartScreen = function(){
                var plugin = this;
                var width = (window.innerWidth > 0) ? window.innerWidth : screen.width;

                plugin.init = function(){
                    setTilesAreaSize();
                    if (width > 640) addMouseWheel();
                };

                var setTilesAreaSize = function(){
                    var groups = $(".tile-group");
                    var tileAreaWidth = 60;
                    $.each(groups, function(i, t){
                        if (width <= 640) {
                            tileAreaWidth = width;
                        } else {
                            tileAreaWidth += $(t).outerWidth() + 60;
                        }
                    });
                    $(".tile-area").css({
                        width: tileAreaWidth
                    });
                };

                var addMouseWheel = function (){
                    $("body").mousewheel(function(event, delta, deltaX, deltaY){
                        var page = $(document);
                        var scroll_value = delta * 50;
                        page.scrollLeft(page.scrollLeft() - scroll_value);
                        return false;
                    });
                };

                plugin.init();
            }
        })(jQuery);
        
        $(function(){
            $.StartScreen();

            var tiles = $(".tile, .tile-small, .tile-sqaure, .tile-wide, .tile-large, .tile-big, .tile-super");

            $.each(tiles, function(){
                var tile = $(this);
                setTimeout(function(){
                    tile.css({
                        opacity: 1,
                        "-webkit-transform": "scale(1)",
                        "transform": "scale(1)",
                        "-webkit-transition": ".2s",
                        "transition": ".2s"
                    });
                }, Math.floor(Math.random()*250));
            });

            $(".tile-group").animate({
                left: 0
            });
            
            //var modulosMenu = ['cargo','compra','cuadrilla','despachomaterial','etapa','inspeccion','material','pago','persona','precio','proveedor','proyecto','obras','solicitudmaterial','subetapa','tipoobra','trabajador','usuario'];
        	
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
    		        			$("#"+separado[0]).removeAttr("hidden");
    		        			$("#contPersonal").removeAttr("hidden");
    		        		}
    		        	}
    					
    					for(var x=0; x < mCompras.length; x++){
    		        		if(separado[0] == mCompras[x]){
    		        			contCom++;
    		        			$("#"+separado[0]).removeAttr("hidden");
    		        			$("#contCompras").removeAttr("hidden");
    		        		}
    		        	}
    					
    					for(var x=0; x < mProyectos.length; x++){
    		        		if(separado[0] == mProyectos[x]){
    		        			contPro++;
    		        			$("#"+separado[0]).removeAttr("hidden");
    		        			$("#contProyectos").removeAttr("hidden");
    		        		}
    		        	}
    					
    					for(var x=0; x < mAsignacion.length; x++){
    		        		if(separado[0] == mAsignacion[x]){
    		        			contAsi++;
    		        			$("#"+separado[0]).removeAttr("hidden");
    		        			$("#contAsignacion").removeAttr("hidden");
    		        		}
    		        	}
    					
    					if(separado[0] == mConfiguracion){
		        			$("#"+separado[0]).removeAttr("hidden");
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
        	 
        });
        
        
        
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
            
            
            
            
        });  
        
        
        
        
        
        </script>

	<div class="tile-area fg-white" style="padding-right:10px;">


	<div class="">
		
		<div class="col-md-12 col-xs-12" style="margin-top:-85px;margin-bottom:30px;padding-right:0px;">
		<div class="col-md-6 col-xs-12">
			<a href="http://app.proherco.com.ve" style="padding-left:25px;"> <img
				src="Archivos/images/iconmenu/LOGO2.png" style="width:280px;margin-top: 0px; border:solid 0px white;"></img></a>
		
		</div>
		
		<div class="col-md-6 col-xs-12">
		
			<div class="tile-area-controls " style="padding-left:20px;float:left;padding-top:8px;">
	
				<div class="bg-dark" style="min-width: 10px; height:32px; font-size: 16px; padding-left: 10px;line-height:32px">
					<span style="border:solid 0px white;top:-5px;position:relative;"><%=session.getAttribute("nombre") %></span>
					<input type="hidden" id="idUsuario" value="<%=session.getAttribute("idusuario") %>">
            
            
						<a href="#" class="mif-cog bg-gray icon exit" style="font-size: 20px; color: #fff; padding: 6px; margin-left: 10px;margin-top:-11px;" data-toggle="modal" data-target=".modal_clave"></a>
						
						
		            	<a href="#" class="mif-dollar2 icon exit" style="font-size: 20px; color: #fff; padding: 0px; margin-left: 0px;margin-top:-11px;"data-toggle="modal" data-target=".modal_dolar" title="DolarToday"></a>
						
						<a href="#" class="mif-meter icon exit" style="font-size: 20px; color: #fff; padding: 6px; margin-left: 0px;margin-top:-11px;"data-toggle="modal" data-target=".modalproyecto"></a>
						
						
		
						
						<a href="#"class="exit icon" style="font-size:28px;font-weight:bold; color:#fff;border:solid 0px #fff;" data-toggle="modal" data-target=".modal_about" title="Ayuda" onclick="verAboutopcion1();">?</a>
						<a href="./logout" class="mif-exit icon exit" style="font-size: 20px; color: #fff; padding: 0px; margin-left: 5px;margin-top:-11px;"></a>
					
				
				</div>
	
			</div>
			</div>
		</div>
		
	</div>

<!-- INICIO DE MODAL PARA EL DOLAR -->     
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

<!-- FIN DEL MODAL PARA EL DOLAR -->




<!-- INICIO DE MODAL ABOUT-->     
<div class="modal fade modal_about" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel">
  <div class="modal-dialog modal-lg" role="document" style="">
    <div class="modal-content">
      
      <div class="modal-header" style="min-height:50px;border:solid 0px blue;background-color:#750000">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close" style="color:white;border:solid 0px white;margin-top:-10px;"><span aria-hidden="true">&times;</span></button>
        <h5 class="modal-title " id="titleabout" style="text-align:center;border:solid 0px #000;color:#ffffff;margin-top:-10px;">Seleccione una Opcion</h5>
      </div>
      <div class="modal-body " id="" style="color:#666666">
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
     			
     			
     			<div class="col-md-9" id="ContentAbout1" style="border:solid 0px blue;height:auto;float:right;">Bienvenidos a la Seccion de Documentación,<br>
     			en estos momentos estamos realizando el manual de Usuario el cual sera publicado en esta Sección<br><br>
     			Lamentamos las Molestias Causadas
     			<br><br><br><br><br>
     		     			
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
						style="background: #D1903A;width:100%;margin:0px;text-align:center" data-role="tile">
						<div class="tile-content iconic  mif-ani-hover-shuttle">
						<img class="icon" src="Archivos/images/iconmenu/PROYECTOS.png" style="margin-top:-50px;text-align:center"></img>
						</div> <span class="tile-label"style="font-size:18px;"><%=separproyectos[1]%></span>
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





		<!-- ##### INICIO DEL PRIMER CONTENEDOR DE LOS MODULOS -->
		<div class="tile-group double" id="contPersonal" hidden="hidden" >
			<span class="tile-group-title "> Personal</span>

			<div class="tile-container">
				<div class="row">
					<div class="col-md-11 col-sm-11 col-xs-11">
						<div class="row">
							<div class="col-md-12" id="persona" hidden="hidden">
								<a href="./persona" class="tile-wide text-shadow fg-white "	style="background: #666633" data-role="tile">
									<div class="tile-content iconic  mif-ani-hover-shuttle">
										<img class="icon" src="Archivos/images/iconmenu/PERSONA.png"></img>
									</div> <span class="tile-label ">Persona</span>
								</a>
							
							</div>
							<div class="col-md-6 col-xs-6" id="cargo" hidden="hidden">
								<a href="./cargo" class="tile  fg-white" style="background: #105284" data-role="tile">
									<div class="tile-content iconic  mif-ani-hover-shuttle">
										<!--  <img class="icon" src="Archivos/images/iconmenu/CARGO.png"></img>-->
										<span class="icon mif-profile"></span>
									</div> <span class="tile-label">Cargo</span>
								</a>
							</div>
							
							<div class="col-md-6 col-xs-6" id="trabajador" hidden="hidden">
								<a href="./trabajador" class="tile text-shadow fg-white" style="background: #CE352C" data-role="tile">
									<div class="tile-content iconic  mif-ani-hover-shuttle">
										<img class="icon" src="Archivos/images/iconmenu/TRABAJADOR.png"></img>
									</div> <span class="tile-label">Trabajador</span>
								</a>
							</div>
							<div class="col-md-6 col-xs-12" id="cuadrilla" hidden="hidden">
								<a href="./cuadrilla" class="tile text-shadow fg-white" style="background: #ECB54E" data-role="tile">
									<div class="tile-content iconic  mif-ani-hover-shuttle">
										<img class="icon" src="Archivos/images/iconmenu/CUADRILLAS.png"></img>
									</div> <span class="tile-label">Cuadrilla</span>
								</a>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- ##### FIN DEL PRIMER CONTENEDOR DE LOS MODULOS -->

		<!-- ##### INICIO DEL SEGUNDO CONTENEDOR DE LOS MODULOS -->
		<div class="tile-group double" id="contCompras" hidden="hidden">
			<span class="tile-group-title">Compras</span>

			<div class="tile-container">
			<div class="row">
				<div class="col-md-11 col-sm-11 col-xs-11">
					<div class="row">
						<div class="col-md-6 col-xs-6" id="material" hidden="hidden">
							
							<a href="./material" class="tile text-shadow  fg-white"	style="background: #A35612" data-role="tile">
								<div class="tile-content iconic  mif-ani-hover-shuttle">
									<img class="icon" src="Archivos/images/iconmenu/MATERIAL.png"></img>
								</div> <span class="tile-label">Material</span>
							</a>
						</div>
						
						<div class="col-md-6 col-xs-6" id="proveedor" hidden="hidden">
							<a href="./proveedor" class="tile text-shadow fg-white" style="background: #29286A" data-role="tile">
								<div class="tile-content iconic  mif-ani-hover-shuttle">
									<img class="icon" src="Archivos/images/iconmenu/PROVEEDOR.png"></img>
								</div> <span class="tile-label">Proveedor</span>
							</a>
						
						</div>
						<div class="col-md-12" id="compra" hidden="hidden">
							 <a href="./compra" class="tile-wide text-shadow  fg-white"	style="background: #00A0E3" data-role="tile">

								<div class="tile-content iconic  mif-ani-hover-shuttle">
									<img class="icon" src="Archivos/images/iconmenu/COMPRAMATERIAL.png"></img>
								</div> <span class="tile-label ">Compra de Material</span>
							</a>
						
						</div>
					</div>
				</div>
			
			</div>

				 

			</div>
		</div>
		<!-- ##### FIN DEL SEGUNDO CONTENEDOR DE LOS MODULOS -->

		<!-- ##### INICIO DEL TERCER CONTENEDOR DE LOS MODULOS -->
		<div class="tile-group double " id="contProyectos" hidden="hidden">
			<span class="tile-group-title">Proyectos</span>

			<div class="tile-container">
				<div class="row">
					<div class="col-md-11 col-sm-11 col-xs-11">
						<div class="row">
							<div class="col-md-6 col-xs-6" id="proyecto" hidden="hidden">
								<a href="./proyecto" class="tile text-shadow  fg-white"	style="background: #D1903A" data-role="tile">
									<div class="tile-content iconic  mif-ani-hover-shuttle">
										<img class="icon" src="Archivos/images/iconmenu/PROYECTOS.png"></img>
									</div> <span class="tile-label">Proyectos</span>
								</a>
							</div>
							<div class="col-md-6 col-xs-6" id="etapa" hidden="hidden">
								<a href="./etapa" class="tile text-shadow fg-white" style="background: #008A00" data-role="tile">
									<div class="tile-content iconic  mif-ani-hover-shuttle">
										<img class="icon" src="Archivos/images/iconmenu/ETAPAS.png"></img>
									</div> <span class="tile-label">Etapas</span>
								</a>
							</div>
							<div class="col-md-6 col-xs-6" id="subetapa" hidden="hidden">
								<a href="./subetapa" class="tile text-shadow  fg-white" style="background: #61A184" data-role="tile">
									<div class="tile-content iconic  mif-ani-hover-shuttle">
										<img class="icon" src="Archivos/images/iconmenu/SUBETAPAS.png"></img>
									</div> <span class="tile-label">SubEtapas</span>
								</a>
							
							</div>
							<div class="col-md-6 col-xs-6" id="obras" hidden="hidden">
								<a href="./obra" class="tile text-shadow  fg-white" style="background: #647687" data-role="tile">
									<div class="tile-content iconic  mif-ani-hover-shuttle">
										<img class="icon" src="Archivos/images/iconmenu/OBRA3.png"></img>
									</div> <span class="tile-label">Obras</span>
								</a>
							</div>
							<div class="col-md-6 col-xs-6" id="tipoobra" hidden="hidden">
								<a href="./tipoobra" class="tile text-shadow  fg-white" style="background: #CE352C" data-role="tile">
									<div class="tile-content iconic  mif-ani-hover-shuttle">
										<img class="icon" src="Archivos/images/iconmenu/TIPOSDEOBRA.png"></img>
									</div> <span class="tile-label">Tipo de Obras</span>
								</a>
							</div>
						
						</div>
					</div>
				</div>
				    



			</div>
		</div>
		<!-- ##### FIN DEL TERCER CONTENEDOR DE LOS MODULOS -->

		<!-- ##### INICIO DEL CUARTO CONTENEDOR DE LOS MODULOS -->

		<div class="tile-group double" id="contAsignacion" hidden="hidden">
			<span class="tile-group-title">Asignacion</span>

			<div class="tile-container">
				<div class="row">				
					<div class="col-md-11 col-sm-11 col-xs-11">
						<div class="row">
							<div class="col-md-6 col-xs-6" id="solicitudmaterial" hidden="hidden">
								<a href="./solicitudmaterial" class="tile text-shadow  fg-white" style="background: #CD7372" data-role="tile">
									<div class="tile-content iconic  mif-ani-hover-shuttle">
										<img class="icon" src="Archivos/images/iconmenu/SOLICITUD1.png"></img>
									</div> <span class="tile-label">Solicitud de Material</span>
								</a>
							</div>
							<div class="col-md-6 col-xs-6" id="despachomaterial" hidden="hidden">
								<a href="./despachomaterial" class="tile text-shadow  fg-white" style="background: #FA6800" data-role="tile">
									<div class="tile-content iconic  mif-ani-hover-shuttle">
										<img class="icon" src="Archivos/images/iconmenu/DESPACHO1.png"></img>
									</div> <span class="tile-label">Despachos</span>
								</a>
							
							</div>
							<div class="col-md-12 col-xs-12" id="inspeccion" hidden="hidden">
								<a	href="./inspeccion?Proyecto=0&Obra=0&Etapa=0&filtradoInspeccion=1" class="tile-wide text-shadow  fg-white" style="background: #003399" data-role="tile">
									<div class="tile-content iconic  mif-ani-hover-shuttle">
										<img class="icon" src="Archivos/images/iconmenu/INSPECCION1.png"></img>
									</div> <span class="tile-label ">Inspección</span>
								</a>
							
							</div>
							<div class="col-md-6 col-xs-6" id="pago" hidden="hidden">
								 <a href="./pago" class="tile text-shadow  fg-white" style="background: #FA1100" data-role="tile">
									<div class="tile-content iconic  mif-ani-hover-shuttle">
										<img class="icon" src="Archivos/images/iconmenu/ASIGDEPAGO.png"></img>
									</div> <span class="tile-label">Asignacion de Pagos</span>
								</a>
							</div>
							<div class="col-md-6 col-xs-6" id="precio" hidden="hidden">
								<a href="./precio" class="tile text-shadow  fg-white" style="background: #669933" data-role="tile">
									<div class="tile-content iconic  mif-ani-hover-shuttle">
										<img class="icon" src="Archivos/images/iconmenu/PRECIO.png"></img>
									</div> <span class="tile-label">Asignacion de Precios</span>
								</a>
							</div>
						</div>
					
					</div>
				</div>
				   
			</div>
		</div>
		<!-- ##### FIN DEL CUARTO CONTENEDOR DE LOS MODULOS -->

		<!-- ##### INICIO DEL CUARTO CONTENEDOR DE LOS MODULOS -->
		<div class="tile-group double" id="contConfiguracion" hidden="hidden">
			<span class="tile-group-title">Configuración</span>

			<div class="tile-container">
				<div class="row">				
					<div class="col-md-11 col-sm-11 col-xs-11">
						<div class="row">
							<div class="col-md-6 col-xs-6" id="usuario" hidden="hidden">
								<a href="./usuario" class="tile text-shadow  fg-white" style="background: #666" data-role="tile">
									<div class="tile-content iconic  mif-ani-hover-shuttle">
										<span class="icon mif-user"></span>
									</div> <span class="tile-label">Usuarios</span>
								</a>
							</div>
						</div>
					</div>
				</div>
				
			</div>
		</div>
		<!-- ##### FIN DEL CUARTO CONTENEDOR DE LOS MODULOS -->
	</div>
		<!-- <style>
	.footer {
		  margin-top:50px;
		  border:solid 0px white;
		  position:static;
		  
		  width: 100%;
		  height:40px;
		  color: white;
		 
		}
	</style>
	<footer class="footer" style="text-align:center">
		<span  > <img src="Archivos/images/iconmenu/logoeureka.png" style="width:120px;"></span>
	</footer> -->
	
</body>



<%
if(rs!=null) rs.close();
st.close();

conexion.close(); %> 
