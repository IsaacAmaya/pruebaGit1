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
	ArrayList proyectos = new ArrayList();
	Integer cont=0;
	rs2 = st2.executeQuery("select * from proyecto where estatus=1");
	while (rs2.next()) {
		cont++;
		proyectos.add(rs2.getString("idproyecto") + "/" + rs2.getString("nombre"));
	}

%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="ISO-8859-1">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<meta name="description" content="Plataforma web Proherco">
		<meta name="author" content="Corporación Eureka CA">
		<link href="Archivos/css/cssmetro/metro-bootstrap.min.css" rel="stylesheet">		
		<link href="Archivos/css/cssmetro/metro-icons.css" rel="stylesheet">
		
		<!-- <link href="Archivos/css/cssmetro/metro.css" rel="stylesheet">
<link href="Archivos/css/cssmetro/metro-icons.css" rel="stylesheet"> -->

		<script src="Archivos/js/jsmetro/jquery.js"></script>
		<script src="Archivos/js/bootstrap.min.js"></script>
		<script src="Archivos/js/jquery-ui.js"></script>
		<script src="Archivos/js/comun.js"></script>
		<script src="Archivos/js/md5.js"></script>		
		<script src="Archivos/js/SweetAlert/dist/sweetalert.min.js"></script>
		<script src="Archivos/js/variables.js"></script>
		
		<style type="text/css">
@import "Archivos/css/bootstrap.min.css";

@import "Archivos/css/variables.less";

@import "Archivos/css/bootswatch.less";
</style>
		
		<style type="text/css">
			@font-face {
			   font-family: "crillee";
			   src: url("Archivos/fonts/crillee.ttf") format("truetype");
			   
			}
			#crillee {
			   font-family:"crillee";
			   
			}

            .mostrar {
                padding: 10px;
                cursor: pointer;
                color: white;
                border: 1px solid #ccc;
                position: relative;
                top: 120px;
                margin-left: -105px;
                transition: margin-left 0.6s;
                background: gray;
                
                
            }
                    
            .mostrar:hover{
                margin-left: -5px;
                background: white;
                color: dodgerblue;
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
		
		</style>
		<script>
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
	        
		</script>
		<link rel="stylesheet" type="text/css" href="Archivos/css/estilos.css">
	
		<title>PROHERCO</title>
	</head>
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
        $(document).ready(function(){
            var mPersonal = ['persona','cargo','trabajador','cuadrilla'];
        	var mCompras = ['material','proveedor','compra'];
        	var mProyectos = ['proyecto','etapa','subetapa','obras','tipoobra'];
        	var mAsignacion = ['solicitudmaterial','despachomaterial','inspeccion','pago','precio'];
        	var mConfiguracion = 'usuario';
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
    	        }
    		});
        	 
        });
        
        
    </script>
    <input type="hidden" id="idUsuario" value="<%=session.getAttribute("idusuario") %>">
	<body>
		
		<div class="">
<!-- **************************************************************************************************************************************************** -->
			<nav class="navbar navbar-default" role="navigation" style="margin-bottom:0px;border-radius:0px;background: #750000;padding-top:10px;">
			  <div class="container-fluid">
			    <!-- Brand and toggle get grouped for better mobile display -->
			    <div class="navbar-header" style="border:solid 0px #fff; height:50px">
			      <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" style="border:solid 0px #fff;margin-top:10px;padding:8px;">
			        <span class="glyphicon glyphicon-menu-hamburger exit" style="font-size:24px;color:white;"></span>
			      </button>
			      <a class="exit" href="./menu" style="padding-left:10px;"><img class="icon" src="Archivos/images/iconmenu/LOGO.png" style="width:200px; height:30px; margin-top:7px" ></img></a>
			    </div>
			
			    <!-- Collect the nav links, forms, and other content for toggling -->
			    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1" style="border:solid 0px #fff">
			     
			      <ul class="nav navbar-nav navbar-right" style="border:solid 0px #fff; margin-top:0px;">
			        <span class="usuario" style="border:solid 0px #fff; margin-top:5px;"> 
		    	  	<span style="font-size:18px;" id="nombreUsuario"><%=session.getAttribute("nombre") %></span>
		    	  	<input type="hidden" id="idUsuario" value="<%=session.getAttribute("idusuario") %>">
		            <span> <a class="mif-dollar2 icon exit" style=" color:#fff;padding-bottom:7px;padding-left:7px; margin-left:0px;" data-toggle="modal" data-target=".modal_dolar" title="DolarToday"></a></span>
		            <span> <a href="#" class="mif-meter icon exit" style="padding-bottom:7px;padding-left:7px; color:#fff; margin-left:0px;" data-toggle="modal" data-target=".modalproyecto" title="Dashboard"></a></span>
		            
		            <span class="mif-question exit icon" style="padding-bottom:7px;padding-left:7px; color:#fff; margin-left:0px;" data-toggle="modal" data-target=".modal_about" title="Ayuda" onclick="verAbout();"></span>
		            
		            <span> <a href="./logout" class="mif-exit icon exit" style="padding-bottom:7px;padding-left:7px; color:#fff; margin-left:0px;margin-right:50px;" title="Cerrar Sesión"></a></span>
		            </span> 
			        
			      </ul>
			    </div><!-- /.navbar-collapse -->
			  </div><!-- /.container-fluid -->
			</nav>
<!-- **************************************************************************************************************************************************** -->
			<div class="col-md-12" role="main">
				<div class="bs-docs-section">
					<div class="page-header">
				      	<h2 id="tiles">Modulos</h2>
				    </div>	
					
				    <div class="bs-example" id="contPersonal" hidden="hidden" >
				    	<h4 id="thumbnails-default" >Personal</h4>
					    <div class="row">
					        
							<div class="col-sm-6 col-md-3" id="persona" hidden="hidden">
								<div class="thumbnail tile tile-medium col-md-3" style="background: #666633">
									<a href="./persona" >
										<img class="icon" src="Archivos/images/iconmenu/PERSONA.png" style="width:50%;margin-top:20%"></img>
									</a>
								</div>
					        </div>
							<div class="col-sm-6 col-md-3" id="cargo" hidden="hidden">
								<div class="thumbnail tile tile-medium col-md-3" style="background: #105284">
									<a href="./cargo" >
										<span class="icon mif-profile" style="font-size:70px;color:#EEE;margin-top:18%"></span>
									</a>
								</div>
					        </div>
							<div class="col-sm-6 col-md-3" id="trabajador" hidden="hidden">
								<div class="thumbnail tile tile-medium col-md-3" style="background: #CE352C">
									<a href="./trabajador" >
										<img class="icon" src="Archivos/images/iconmenu/TRABAJADOR.png" style="width:50%;margin-top:20%"></img>
									</a>
								</div>
					        </div>
							<div class="col-sm-6 col-md-3" id="cuadrilla" hidden="hidden">
								<div class="thumbnail tile tile-medium col-md-3" style="background: #ECB54E">
									<a href="./cuadrilla" >
										<img class="icon" src="Archivos/images/iconmenu/CUADRILLAS.png" style="width:50%;margin-top:20%"></img>
									</a>
								</div>
					        </div>
					    </div><!-- /.bs-example -->
					</div>
<!-- *************************************************************************************************************************************************************************** -->
					
				    <div class="bs-example" id="contCompras" hidden="hidden">
				    	<h4 id="thumbnails-default">Compras</h4>
					    <div class="row">
					        
							<div class="col-sm-6 col-md-3" id="material" hidden="hidden">
								<div class="thumbnail tile tile-medium col-md-3" style="background: #A35612">
									<a href="./material" >
										<img class="icon" src="Archivos/images/iconmenu/MATERIAL.png" style="width:50%;margin-top:20%"></img>
									</a>
								</div>
					        </div>
							<div class="col-sm-6 col-md-3" id="proveedor" hidden="hidden">
								<div class="thumbnail tile tile-medium col-md-3" style="background: #29286A">
									<a href="./proveedor" >
										<img class="icon" src="Archivos/images/iconmenu/PROVEEDOR.png" style="width:50%;margin-top:20%"></img>
									</a>
								</div>
					        </div>
							<div class="col-sm-6 col-md-3" id="compra" hidden="hidden">
								<div class="thumbnail tile tile-medium col-md-3" style="background: #00A0E3">
									<a href="./compra" >
										<img class="icon" src="Archivos/images/iconmenu/COMPRAMATERIAL.png" style="width:50%;margin-top:20%"></img>
									</a>
								</div>
					        </div>
					    </div><!-- /.bs-example -->
					</div>
<!-- *************************************************************************************************************************************************************************** -->
					
				    <div class="bs-example" id="contProyectos" hidden="hidden">
				    	<h4 id="thumbnails-default">Proyectos</h4>
					    <div class="row">
					        
							<div class="col-sm-6 col-md-3" id="proyecto" hidden="hidden">
								<div class="thumbnail tile tile-medium col-md-3" style="background: #D1903A">
									<a href="./proyecto" >
										<img class="icon" src="Archivos/images/iconmenu/PROYECTOS.png" style="width:50%;margin-top:20%"></img>
									</a>
								</div>
					        </div>
							<div class="col-sm-6 col-md-3" id="etapa" hidden="hidden">
								<div class="thumbnail tile tile-medium col-md-3" style="background: #008A00">
									<a href="./etapa" >
										<img class="icon" src="Archivos/images/iconmenu/ETAPAS.png" style="width:50%;margin-top:20%"></img>
									</a>
								</div>
					        </div>
							<div class="col-sm-6 col-md-3" id="subetapa" hidden="hidden">
								<div class="thumbnail tile tile-medium col-md-3" style="background: #61A184">
									<a href="./subetapa" >
										<img class="icon" src="Archivos/images/iconmenu/SUBETAPAS.png" style="width:50%;margin-top:20%"></img>
									</a>
								</div>
					        </div>
					        <div class="col-sm-6 col-md-3" id="obras" hidden="hidden">
								<div class="thumbnail tile tile-medium col-md-3" style="background: #647687">
									<a href="./obra" >
										<img class="icon" src="Archivos/images/iconmenu/OBRA3.png" style="width:50%;margin-top:20%"></img>
									</a>
								</div>
					        </div>
							<div class="col-sm-6 col-md-3" id="tipoobra" hidden="hidden">
								<div class="thumbnail tile tile-medium col-md-3" style="background: #CE352C">
									<a href="./tipoobra" >
										<img class="icon" src="Archivos/images/iconmenu/TIPOSDEOBRA.png" style="width:50%;margin-top:20%"></img>
									</a>
								</div>
					        </div>
					    </div><!-- /.bs-example -->
					</div>
<!-- *************************************************************************************************************************************************************************** -->
					
				    <div class="bs-example" id="contAsignacion" hidden="hidden">
				    	<h4 id="thumbnails-default">Asignación</h4>
					    <div class="row">
					        
							<div class="col-sm-6 col-md-3" id="solicitudmaterial" hidden="hidden">
								<div class="thumbnail tile tile-medium col-md-3" style="background: #CD7372">
									<a href="./solicitudmaterial" >
										<img class="icon" src="Archivos/images/iconmenu/SOLICITUD1.png" style="width:50%;margin-top:20%"></img>
									</a>
								</div>
					        </div>
							<div class="col-sm-6 col-md-3" id="despachomaterial" hidden="hidden">
								<div class="thumbnail tile tile-medium col-md-3" style="background: #FA6800">
									<a href="./despachomaterial" >
										<img class="icon" src="Archivos/images/iconmenu/DESPACHO1.png" style="width:50%;margin-top:20%"></img>
									</a>
								</div>
					        </div>
							<div class="col-sm-6 col-md-3" id="inspeccion" hidden="hidden">
								<div class="thumbnail tile tile-medium col-md-3" style="background: #003399">
									<a href="./inspeccion?Proyecto=0&Obra=0&Etapa=0&filtradoInspeccion=1" >
										<img class="icon" src="Archivos/images/iconmenu/INSPECCION1.png" style="width:50%;margin-top:20%"></img>
									</a>
								</div>
					        </div>
					        <div class="col-sm-6 col-md-3" id="pago" hidden="hidden">
								<div class="thumbnail tile tile-medium col-md-3" style="background: #FA1100">
									<a href="./pago" >
										<img class="icon" src="Archivos/images/iconmenu/ASIGDEPAGO.png" style="width:50%;margin-top:20%"></img>
									</a>
								</div>
					        </div>
							<div class="col-sm-6 col-md-3" id="precio" hidden="hidden">
								<div class="thumbnail tile tile-medium col-md-3" style="background: #669933">
									<a href="./precio" >
										<img class="icon" src="Archivos/images/iconmenu/PRECIO.png" style="width:50%;margin-top:20%"></img>
									</a>
								</div>
					        </div>
					    </div><!-- /.bs-example -->
					</div>
<!-- ****************************************************************************************************************************************************************************** -->
					
				    <div class="bs-example" id="contConfiguracion" hidden="hidden">
				    	<h4 id="thumbnails-default">Configuración</h4>
					    <div class="row">
					        
							<div class="col-sm-6 col-md-3" id="usuario" hidden="hidden">
								<div class="thumbnail tile tile-medium col-md-3" style="background: #666">
									<a href="./usuario" >
										<span class="icon mif-cog" style="font-size:70px;color:#EEE;margin-top:20%"></span>
									</a>
								</div>
					        </div>
					    </div><!-- /.bs-example -->
					</div>
<!-- ***************************************************************************************************************************************************************************** -->
				</div>
			</div>
		</div>
<!-- ***************************************************************************************************************************************************************************** -->
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
<!-- ***************************************************************************************************************************************************************************** -->
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
		       %>
       			<div class="col-md-6" style="border:solid 0px red;margin-bottom:30px;">
      				
					<a href="./dashboard?id=<%=separproyectos[0]%>&np=<%=separproyectos[1]%>" class="tile text-shadow col-md-12 fg-white"
						style="background: #D1903A;width:100%;margin:0px;text-align:center" data-role="tile">
						<div class="tile-content iconic  mif-ani-hover-shuttle">
						<img class="icon" src="Archivos/images/iconmenu/PROYECTOS.png" style="margin-top:-50px;text-align:center"></img>
						</div> <span class="tile-label"style="font-size:18px;"><%=separproyectos[1]%></span>
					</a>
			
	       		
      			</div>
       <% }}%>
		       </div>
		       
		      </div>
		       
		    </div>
		  </div>
		</div>
<!-- FIN DEL MODAL PARA SELECCIONAR PROYECTO -->
<!-- ***************************************************************************************************************************************************************************** -->
<!-- INICIO DE MODAL ABOUT-->     
		<div class="modal fade modal_about" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel">
		  <div class="modal-dialog modal-lg" role="document" style="">
		    <div class="modal-content">
		      
		      <div class="modal-header" style="height:50px;border:solid 0px blue;background-color:#750000">
		        <button type="button" class="close" data-dismiss="modal" aria-label="Close" style="color:white;border:solid 0px white;margin-top:-10px;"><span aria-hidden="true">&times;</span></button>
		        <h5 class="modal-title " id="titleabout" style="text-align:center;border:solid 0px #000;color:#ffffff;margin-top:-10px;">Seleccione una Opcion</h5>
		      </div>
		      <div class="modal-body " id="" style="">
		     	<div class="row" style="">
		     		<div class="col-md-12" style="border:solid 0px #000">
		     			<div class="col-md-2" id="BotonesAbout" style="border:solid 0px green;padding:0px;">
		     				<ul class="list-group">
		     				<li id="boton1" class="list-group-item btn-warning opcionesabout" style="cursor:pointer;font-size:14px;font-weight:bold;width:100%;" onclick="verAboutopcion1();" title="Contiene el Manual de usuario y Tips para su uso">DOCUMENTACIÓN</li>
		     				<li id="boton2" class="list-group-item btn-primary opcionesabout" style="cursor:pointer;font-size:14px;font-weight:bold;width:100%;" onclick="verAboutopcion2();" title="Contiene la informacion de que es proherco">PROHERCO-GPO</li>
		     				<li id="boton3" class="list-group-item btn-success opcionesabout" style="cursor:pointer;font-size:14px;font-weight:bold;width:100%;" onclick="verAboutopcion3();">DEVELOPED</li>
		     				</ul>
		     			</div>
		     			<div class="col-md-10" id="ContentAbout1" style="border:solid 0px blue;height:200px;">contenido1</div>
		     			<div class="col-md-10" id="ContentAbout2" style="border:solid 0px blue;height:auto;">Contenido2</div>
		     			<div class="col-md-10" id="ContentAbout3" style="border:solid 0px red;height:auto;float:right;margin-bottom:25px;">
		     				<br><p>&nbsp;&nbsp;&nbsp;&nbsp;Como ya debes Saber <span class="label label-danger" style="color:white;background:#750000;font-size:13px;font-weight:bold;cursor:pointer;" title="Click para Conocer PROHERCO-GPO" onclick="verAboutopcion2();">PROHERCO-GPO</span>
		     				 fue desarrollado por <a href="http://www.corporacioneureka.com/web/" target=”_blank” class="label" style="background:#2cae11;color:white;font-size:13px;font-weight:bold;cursor:pointer;" title="Click para Visitar Nuestra Web">CORPORACIÓN EUREKA</a>
		     				 , así que ahora te estaras haciendo estas preguntas:<br><br> 
		     				 <span id="pregunta1" class="btn-sm btn-primary" style="cursor:pointer;margin-right:10px;" onclick="verrespuesta1();" title="Click para ver respuesta"> ¿Quienes son? </span> 
		     				 <span id="pregunta2" class="btn-sm btn-primary" style="cursor:pointer;margin-right:10px;" onclick="verrespuesta2();" title="Click para ver respuesta"> ¿Que Hacen? </span> 
		     				 <span id="pregunta3" class="btn-sm btn-primary" style="cursor:pointer;margin-right:10px;" onclick="verrespuesta3();" title="Click para ver respuesta"> ¿Me interesa Saberlo? </span>
		     				 <span id="pregunta3" class="btn-sm btn-primary" style="cursor:pointer;margin-right:10px;" onclick="verrespuesta4();" title="Click para ver respuesta"> ¿Como Contactarlos? </span>
		     				</p>
		     				<span id="comentario1"><span style="font-size:18px;" class="glyphicon glyphicon-hand-up"></span> Haz Click para obtener la respuesta</span>						
		     					<div id="titulopregunta" class="col-md-12" style="border:solid 0px blue;font-size:16px;font-weight:bold;">Titulo = pregunta</div>
		     					<div id="respuestapregunta" class="col-md-12" style="border:solid 0px red;float:right;"></div>
		     			</div>
		     		<div class="" id="googlemaps" style="border:solid 0px #000;bottom:0px;padding:0px;">
		     			 <div class="google-maps">
					        <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d11127.809100211585!2d-69.21736371378003!3d9.57157769263843!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x8e7dc1983ee4a429%3A0x11cac4b47067b12a!2sCorporaci%C3%B3n+Eureka%2C+C.A.!5e0!3m2!1ses!2sve!4v1510002920959" width="860" height="200" frameborder="0" style="border:0" allowfullscreen></iframe>
					      </div>
		     		</div>
		     		</div>
		     	</div>
		      </div>
		      
		    </div>
		  </div>
		</div>

<!-- FIN DEL MODAL PARA ABOUT -->
<!-- ***************************************************************************************************************************************************************************** -->
<!-- ***************************************************************************************************************************************************************************** -->
	</body>
<%
	if(rs!=null) rs.close();
	st.close();
	
	conexion.close();
%> 
