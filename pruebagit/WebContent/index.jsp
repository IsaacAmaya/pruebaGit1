<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
        <meta charset="ISO-8859-1">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="Plataforma web Proherco">
        <meta name="author" content="Corporación Eureka CA">
        <style type="text/css">
        	@import "Archivos/css/bootstrap.min.css";
			@import "Archivos/css/variables.less";
			@import "Archivos/css/bootswatch.less";
			
        </style>
        <link href="Archivos/css/dataTables.bootstrap.css" rel="stylesheet">
        <link href="Archivos/css/jquery.dataTables.css" rel="stylesheet">
        <link href="Archivos/css/jquery-ui.css" rel="stylesheet">
        <link rel="shortcut icon" href="Archivos/imagenes/favicon.ico">
		<script src="Archivos/js/jquery.js"></script>
        <script src="Archivos/js/bootstrap.min.js"></script>
        <script src="Archivos/js/jquery-ui.js"></script>
        <script src="Archivos/js/jquery.blockUI.js"></script>
        <script src="Archivos/js/jquery.numeric.js"></script>
        <script src="Archivos/js/jquery.dataTables.min.js"></script>
        <script src="Archivos/js/dataTables.bootstrap.js"></script>
        <script src="Archivos/js/variables.js"></script>
        <script src="Archivos/js/comun.js"></script>
        <script src="Archivos/js/modulo/login.js"></script>
        <script src="Archivos/js/md5.js"></script>
        
        <script src="Archivos/js/SweetAlert/dist/sweetalert.min.js"></script>
        <link rel="stylesheet" type="text/css" href="Archivos/js/SweetAlert/dist/sweetalert.css">
        <link rel="stylesheet" type="text/css" href="Archivos/js/SweetAlert/themes/google/google.css">
        <!-- <link rel="stylesheet" type="text/css" href="Archivos/js/SweetAlert/themes/facebook/facebook.css"> -->
        <!-- <link rel="stylesheet" type="text/css" href="Archivos/js/SweetAlert/themes/twitter/twitter.css"> -->
        
        <link href="Archivos/css/cssmetro/metro-icons.css" rel="stylesheet">
        <link href="Archivos/css/fontello/css/fontello.css" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="Archivos/css/estilos.css">
          <style>
          @font-face {
			   font-family: "crillee";
			   src: url("Archivos/fonts/crillee.ttf") format("truetype");
			   
			}
			#crillee {
			   font-family:"crillee";
			   
			}
          
	.footer {
		  
		  position: fixed;
		  bottom: 0px;
		  width: 100%;
		  height:60px;
		  color: white;
		}
	.botonbajarabout:hover {
		text-shadow:0px 0px 5px white;
	}
	.eurk:hover {
            	background:#2cae11;
            	color:white;
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
	
	</style>
	<script>
	$(document).ready(function(){
		 $('#contenedorabout').hide();
		
		
	});
	
	function vercontenedorAbout(valor){
		//alert(valor);
		
		if(valor==1){
			$('.botonbajarabout').removeAttr("id","1").attr("id","0");
			$('.botonbajarabout').css("transform","rotate(180deg)");
			$('.botonbajarabout').css("transition","transform 1.5s");
			$('.mif-ani-slow').removeClass("mif-ani-vertical")
			$('#contenedorabout').show(800);
			$('#contenedorabout').fadeIn(1300);
			$('#titulopregunta').hide();
			$('#respuestapregunta').hide();
			$('#comentario1').show();
			$('#ubicacionmaps').hide();
			
			
		}else {
			$('.botonbajarabout').attr("id","1");
			$('#contenedorabout').hide(800);
			$('.botonbajarabout').css("transform","rotate(0deg)");
			$('.botonbajarabout').css("transition","transform 1s");
			$('.mif-ani-slow').addClass("mif-ani-vertical")
			$('#comentario1').show();
			$('#ubicacionmaps').hide();
		}
		
	}		
		
		
		function verrespuesta1(){
			 
			 $('#comentario1').hide();
			 $('#titulopregunta').hide();
			 $('#titulopregunta').show(500);
			 $('#titulopregunta').text('¿Quien es Corporación Eureka!?');
			 
			 $('#respuestapregunta').hide();
			 $('#respuestapregunta').fadeIn(800);
			 $('#respuestapregunta').html('<p style="margin-left:0px;text-align:justify;line-height:16px;">&nbsp;&nbsp;&nbsp;&nbsp;Corporación Eureka! es una compañía proveedora ' +
 					'de servicios informáticos y soluciones tecnológicas para todo tipo de empresas e instituciones.</p>'+
					'<p style="margin-left:0px;text-align:justify;line-height:16px;">&nbsp;&nbsp;&nbsp;Contamos con un equipo de profesionales expertos en informática, redes, ' +
					'sistemas de seguridad, diseño y programadores capaces de llevar a cabo cualquier tipo de proyecto de TI por muy ambicioso que parezca.</p>');
			 $('#respuestapregunta').fadeIn(800);
			 $('#ubicacionmaps').hide();
		 }
		
		 function verrespuesta2(){
			 
			 
			 $('#comentario1').hide();
			 $('#titulopregunta').hide();
			 $('#titulopregunta').show(500);
			 $('#titulopregunta').text('¿Que realiza Corporación Eureka!?');
			 
			 $('#respuestapregunta').hide();
			 $('#respuestapregunta').fadeIn(800);
			 $('#respuestapregunta').html('<p style="margin-left:0px;text-align:justify;line-height:16px;">&nbsp;&nbsp;Diseñamos e implementamos soluciones que permiten cubrir integralmente las necesidades de TI de una organización.'+ 
					 'Considerando las necesidades particulares, nos enfocamos hasta en los más mínimos detalles.</p>'+
					'<p style="margin-left:0px;text-align:justify;line-height:16px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Los proyectos que desarrollamos pueden llegar a ser de gran complejidad o tamaño, requerir de vastos conocimientos y recursos, así como experiencia en múltiples geografías e industrias,'+
					' todas ellas, capacidades que Corporación Eureka! está en condiciones de aportar a sus clientes.</p>');
			 $('#respuestapregunta').fadeIn(800);
			 $('#ubicacionmaps').hide();
		 }
			function verrespuesta3(){
			 
			 
			 $('#comentario1').hide();
			 $('#titulopregunta').hide();
			 $('#titulopregunta').show(500);
			 $('#titulopregunta').text('Por Supuesto que SI te Interesa saber de Corporación Eureka!');
			 
			 $('#respuestapregunta').hide();
			 $('#respuestapregunta').fadeIn(800);
			 $('#respuestapregunta').html('<p style="margin-left:0px;text-align:justify;line-height:16px;">&nbsp;&nbsp;En que nos basamos para afirmarlo, pues si actualmente te identificas con alguno de los siguientes casos, entonces te interesara saber de nosotros:</p>' +
					'<p style="margin-left:20px;margin-bottom:0px;line-height:16px;text-align:justify"> <span style="font-weight:bold;font-size:14px;"class="glyphicon glyphicon-hand-right"></span> Si Posees una PYME y consideras que quieres mejorar tu infraestructura y seguridad, puedes contar con nosotros, pues somos los mejores.</p>'+
					'<p style="margin-left:20px;margin-bottom:0px;line-height:16px;text-align:justify"> <span style="font-weight:bold;font-size:14px;"class="glyphicon glyphicon-hand-right"></span> Si Tienes un proyecto de TI en mente  que consideras que nadie lo puede realizar, te podemos asegurar que podemos realizarlo con los mas altos estándares de calidad.</p>'+
					'<p style="margin-left:20px;line-height:16px;text-align:justify"> <span style="font-weight:bold;font-size:14px;"class="glyphicon glyphicon-hand-right"></span> Si por el contrario consideras que posees talento en la rama de informática, y quieres ser parte de nuestro Equipo, con mayor razón te interesara conocernos.</p>'+
					'<p style="margin-left:0px;line-height:16px;text-align:justify">&nbsp;&nbsp;Solo te queda una ultima pregunta ¿Como los puedo contactar?</p>');
			 $('#respuestapregunta').fadeIn(800);
			 $('#ubicacionmaps').hide();
		 }
			
			function verrespuesta4(){
				 
				 
				 $('#comentario1').hide();
				 $('#titulopregunta').hide();
				 $('#titulopregunta').show(500);
				 $('#titulopregunta').text('Puedes Contactarnos a través de');
				 
				 $('#respuestapregunta').hide();
				 $('#respuestapregunta').fadeIn(800);
				 $('#respuestapregunta').html('<p style="margin-left:0px;margin-bottom:0px;font-size:14px;">Redes Sociales <span style="font-weight:bold;">@corpoeureka</span></p><a class="icon-facebook social face links" title="Contactanos en Facebook" href="https://www.facebook.com/corpoeureka/" target=”_blank”></a>'+
						 '<a class="icon-twitter social twi links" title="Contactanos en Twitter" href="https://twitter.com/corpoeureka" target=”_blank”></a>'+
			     			'<a class="icon-instagram social inst links" title="Contactanos en Instagram" href="https://www.instagram.com/corpoeureka/" target=”_blank”></a>'+
			     			'<a title="Visita Nuestra Web" href="http://www.corporacioneureka.com/web/" target=”_blank” class="social eurk links" style="padding:0px 8px;"><span id="crillee" style="font-size:28px;font-weight:bold;">E</span><span id="crillee" style="font-size:35px;font-weight:bold;">!</span></a>'+
				 			'<p style="margin-left:0px;margin-bottom:-10px;font-size:14px;">Información de Contacto</p>'+
				 			'<div style="margin-bottom:-15px"><span class="icon-whatsapp social whats links" title="Contactanos por WhatsApp" onclick="vertelefono();" style="margin-bottom:0px;"></span><span id="comentario2"><span class="glyphicon glyphicon-hand-left" style="font-weight:bold;font-size:14px;"></span> Click para Obtener el Contacto</span> <span style="margin-top:-20px;">  <span id="numerotelefono" style="font-size:16px;font-weight:bold;margin-top:50px;"> (+58) 412 3024924 </span></span></div>'+
				 			'<div style="margin-bottom:-15px"><span class="icon-mail social whats links" title="Contactanos vía Email" onclick="vercorreo();"></span><span id="comentario3"><span class="glyphicon glyphicon-hand-left" style="font-weight:bold;font-size:14px;"></span> Click para Obtener el Contacto</span> <span style="margin-top:-20px;">  <span id="correoeureka" style="font-size:16px;font-weight:bold;margin-top:50px;">info@corporacioneureka.com</span></span></div>'+
				 			'<div><span class="icon-phone social whats links" title="Contactanos Vía Telefonica" onclick="vertelefonoserk();"></span><span id="comentario4"><span class="glyphicon glyphicon-hand-left" style="font-weight:bold;font-size:14px;"></span> Click para Obtener el Contacto</span> <span style="margin-top:-20px;"> <span id="telefonoseureka" style="font-size:16px;font-weight:bold;border:solid 0px #000;"><div style="width:160px;display:inline-flex;line-height:20px;margin-bottom:10px;">(+58) 255 6236905 <br> (+58) 255 7113130 <br> (+58) 255 7113131</div></span></span></div>');
				 
				 //
				 
				 
				 $('#respuestapregunta').fadeIn(800);
				 $('#numerotelefono').hide();
				 $('#correoeureka').hide();
				 $('#telefonoseureka').hide();
				 $('#ubicacionmaps').hide();
				 $('#ubicacionmaps').show(800);
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
		
		
	
	

	        
	</script>
	
        <title>PROHERCO</title>
</head>

<body style="background-color: #ccc; border:solid 0px blue;">

	<div id="" class="row" style="margin-right:0px;">
			
			<div class="col-md-offset-4 col-md-4 col-sm-offset-3 col-sm-6 col-xs-offset-1 col-xs-10" style="border:solid 0px #000;margin-top:70px;">
				
	        	<div class="panel">
	        		<div class="progress" id="progressBar" style="visibility: hidden; margin-bottom: 5px;margin-top:0px">
		        		<div class="progress-bar progress-bar-striped active" role="progressbar" aria-valuenow="40" aria-valuemin="0" aria-valuemax="100" style="width: 100%">
							<span class="sr-only"></span>
						</div>
					</div>
		            <div class="panel-heading" style="background-color: #750000;margin-top:-11px;"> 
			            
		                <div class="text-center">
		                        <img src="Archivos/images/iconmenu/LOGO2.png" style="width:280px;  margin-top:0px" class="mCS_img_loaded">
		                </div>
		            </div> 
	
	
		            <div class="panel-body">
		            Este es una modificacion
		                
		                <div class="form-group " >
		                    <div class="col-xs-12" style="padding-bottom: 10px; z-index: 100;" >
		                        <input class="form-control" id="txtUsuario" type="text"  placeholder="Usuario">
		                    </div>
		                </div>
		
		                <div class="form-group">
		                    <div class="col-xs-12" style="padding-bottom: 10px; z-index: 100;" >
		                        <input class="form-control" id="txtClave" type="password" placeholder="Clave">
		                    </div>
		                </div>
		                
		                <div class="form-group">
		                    <div class="col-xs-12" style="padding-bottom: 10px" >
		                        <button id="btnLogin" class="btn btn-primary btn-lg btn-block" onclick="login();" style="text-transform: none;">Entrar</button>
		                    </div>
		                </div>
		
		                <!-- <div class="form-group" style="text-align:center">
		                    <div class="col-xs-12">
		                        <a href="" class="text-dark" style="color:white"> ¿Olvidó su clave?</a>
		                    </div>
		                </div> -->
		          
		             <div class="col-md-12 col-xs-12 botoon" id="contenedorabout" style="border-top:solid 1px #750000;margin-top:10px;padding:0px;padding-top:5px;">
		             
		            <p style="line-height: 15px;border:solid 0px #000">&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-size:14px;font-weight:bold;color:#750000">PROHERCO-GPO</span> ha sido desarrollado bajo Estandares de Calidad y Normas ISO, realizado en su totalidad por Corporación Eureka.</p> 
     				
						<div class="col-md-3 col-xs-12" style="border:solid 0px #000;padding-left:0px;padding-right:0px;">
							<span id="pregunta1" class="btn-sm btn-primary col-md-12 col-xs-12" style="cursor:pointer;margin-bottom:2px;" onclick="verrespuesta1();" title="¿Quien es Corporación Eureka?"> ¿Quien es? </span> 
	     				 	<span id="pregunta2" class="btn-sm btn-primary col-md-12 col-xs-12" style="cursor:pointer;margin-bottom:2px;" onclick="verrespuesta2();" title="¿Que realiza Corporación Eureka?"> ¿Que Hace? </span> 
	     				 	<span id="pregunta3" class="btn-sm btn-primary col-md-12 col-xs-12" style="cursor:pointer;margin-bottom:2px;" onclick="verrespuesta3();" title="¿Me interesa Conocer a Corporación Eureka?"> ¿Me Interesa? </span>
	     				 	<span id="pregunta3" class="btn-sm btn-primary col-md-12 col-xs-12" style="cursor:pointer;margin-bottom:2px;" onclick="verrespuesta4();" title="¿Como Contacto con Corporación Eureka?"> ¿Contactarlos? </span>
     					
     					<!-- <span class="col-md-12 col-md-offset-0 col-xs-offset-3 col-xs-6" style="padding:0px;border:solid 1px blue">
     						<img class="icon" src="Archivos/images/iconmenu/logoeurekacircular.png" style="width:100%;text-align:center;"></img>
     					</span> -->
     					
     					</div>
     					<div class="col-md-9  col-xs-12" style="border:solid 0px #000;padding-right:0px;padding-left:0px;float:right;">
     					
	     					<span id="comentario1"><!-- <span style="font-size:18px;" class="glyphicon glyphicon-hand-left"></span> Haz Click para obtener la respuesta -->
	     				<br>
	     					
	     					
	     					
	     					<!-- INICIO DE SECCION DE PROGRAMADORES -->
     					<div style="border:solid 0px #000;float:right;">
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
	     				</div>
     					<!-- FIN DE SECCION DE PROGRAMADORES -->
	     					
	     					
	     					
	     					
	     					</span>
							
	     					<div id="titulopregunta" class="col-md-12 col-xs-12" style="border:solid 0px blue;font-size:16px;font-weight:bold;padding-left:5px;">Titulo = pregunta</div>
	     					<div id="respuestapregunta" class="col-md-12 col-xs-12" style="border:solid 0px red;float:right;">Contenido</div>
	     				
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
						
		             		<div class="col-md-12 col-xs-12" id="ubicacionmaps" style="padding:0px;">
	      			        	<iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d11127.809100211585!2d-69.21736371378003!3d9.57157769263843!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x8e7dc1983ee4a429%3A0x11cac4b47067b12a!2sCorporaci%C3%B3n+Eureka%2C+C.A.!5e0!3m2!1ses!2sve!4v1510002920959" width="100%" height="200" frameborder="0" style="border:0" allowfullscreen></iframe>
				     		</div>
		             
		             </div>
		             
		             
		            </div> 
		           
			            
		            
		            
		           <div class="panel-heading col-md-12 col-xs-12" style="padding:0px;background-color: #750000;opacity:0.9;margin-top:0px;min-height:30px;border-radius:0px 0px 2px 2px ;"> 
			            <span class="col-md-10 col-xs-10" style="color:white;text-align:left;border:solid 0px white;padding:0px;font-size:11px;line-height: 15px;">&nbsp;Copyright © 2017
			             <a href="http://www.corporacioneureka.com/web/" target=”_blank” style="text-decoracion:none;color:white;">Corporación Eureka.</a> All rights reserved.</span>
			           
			           
			             <span class="mif-ani-slow mif-ani-vertical col-md-2 col-xs-2 " style="border:solid 0px #000; cursor:pointer;padding:0px;"><span id="1" onclick="vercontenedorAbout(this.id);" 
			             class=" glyphicon glyphicon-chevron-down  botonbajarabout col-md-12 col-xs-12" 
			             style="font-size:26px;text-align:center;color:white;border:solid 0px white;height:100%;"></span></span>
		                
		            </div> 

	            </div>
	            
	            
            </div> 
            
                                      
           
          
             
    </div>
	
	
	<!--  <footer>
	<span class="footer" style="text-align:center"> <img src="Archivos/images/iconmenu/logoeureka.png" style="width:120px;"></span>
	</footer> -->
	


</body>
</html>