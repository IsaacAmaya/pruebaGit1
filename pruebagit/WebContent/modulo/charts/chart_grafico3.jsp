<%@page import="java.util.ArrayList"%>
<%@ page language="java"%>
<%@ page import="java.io.IOException"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.Statement"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="java.sql.SQLException"%>

<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="ve.com.proherco.web.comun.ValidaFormato"%>
<%@ page import="ve.com.proherco.web.comun.ConexionWeb"%>
<%
	JSONObject respuesta = new JSONObject();
	Connection conexion;
	ConexionWeb conWeb = new ConexionWeb();

	response.setContentType("application/json; charset=UTF-8");
	response.setCharacterEncoding("UTF-8");

	conexion = conWeb.abrirConn();
	Statement st = conexion.createStatement();
	Statement st2 = conexion.createStatement();
	Statement st3 = conexion.createStatement();
	ResultSet rs = null;
	ResultSet rs2 = null;
	ResultSet rs3 = null;
	

	ArrayList nomobras = new ArrayList();
	//String lista =new String();
	//rs = st.executeQuery("select solicitudmaterial.idobra as idobra, obra.nombre as nombreobra from solicitudmaterial inner join obra on obra.idobra=solicitudmaterial.idobra");
	rs = st.executeQuery("select obra.idobra as idobra, obra.nombre as nombreobra, obra.idtipoobra as idtipoobra from obra "
			+ "inner join proyecto on proyecto.idproyecto=obra.idproyecto "
			+ "inner join inspeccion on inspeccion.idobra=obra.idobra "
			+ "where obra.idproyecto="+session.getAttribute("idproyecto")+" group by obra.nombre, obra.idobra, obra.idtipoobra order by obra.idobra asc");

	while (rs.next()) {

		nomobras.add(rs.getString("idobra") + "/" + rs.getString("nombreobra")+ "/" + rs.getString("idtipoobra"));
		
	}
	respuesta.clear();
	String tipoobra="";
	//System.out.print(obras);

	if (rs != null)
	
	%>	
	
  	  <!-- ### INICIO DEL CONTENEDOR DEL GRAFICO -->
  	<div class="col-sm-6 col-md-4 col-xs-12">
<div class="orden grafico3 col-md-12 col-sm-12 col-xs-12" style="border: solid 0px green;padding-right:0px;padding-left:0px">
    		<div class="panel panel-default " >
    				<div class="panel-heading" > 
    				<ul class="panel-opcion" style="margin-top:-5px;margin-left:-10px"> 
    				<!--  <li><a href="#" class="caja"  data-toggle="modal" data-target=".charts-grafico3"><span class="glyphicon glyphicon-fullscreen">
    				</span><span class="info"><table>TEXTO</span></a></li>-->
                    
                    
                   <!-- <style> 
                    .caja {
position: relative; /*Para poder ubicar la info dentro de la caja

}
.caja img {
border:2px solid black;
}
.info {
position: absolute; /*Info sobre la imagen
top: 5%;
left: 10%; /*Desplazamos a partir de la esquina superior izquierda
zoom: 1;
filter: alpha(opacity=0); /*Opacidad Para IE 
opacity: 0; /*Inicialmente transparente 
padding: 5px;
color: white;
background: black;
-moz-transition:all ease .8s; /*Aplicamos una ligera transición
-webkit-transition:all ease .8s ;
transition:all ease .8s;
}
.caja:hover .info {
filter: alpha(opacity=80);
opacity: .8; /*Al hacer hover sobre la caja hacemos visible los datos
}
                    </style>--> 
                    
                    
                    
                     </ul>
               <h3 class="panel-title" style="font-size: 18px;" >Estado de Obras <%=session.getAttribute("nombreproyecto") %></h3>
                    </div>
    			 <div class="panel panel-body" style="padding:0px;" >
			     <div  class="" style="height:260px; overflow:auto;"  >
			     <table class="table-bordered tab" style="box-sizing: border-box; width:100%;" >
              <thead >
              <tr >
                <th style="width:35%">OBRA </th>
                <th style="width:30% ">INSPECCIONES</th>
                <th style="width:35%">AVANCE</th>
               </tr>
            </thead>
            <tbody>
            <%
						String[] separadorobras;
						String contador = "";
						
						for (int i = 0; i < nomobras.size(); i++) {
							//System.out.print(String.valueOf(obras.get(i)));
							String nombreobras = String.valueOf(nomobras.get(i));
							separadorobras = nombreobras.split("/");
							//System.out.print(separ[1]);
							//contador=separadorobras[2];
							
							
					%>
                      
                      <%
                                           
						rs2 = st2.executeQuery("select inspeccion.idobra as idobra, obra.idtipoobra as idtipo, obra.nombre as nombreobra, inspeccion.iddetalleetapa, etapa.nombre, etapa.idetapa as idetapa, "
								+ "sum(inspeccion.porcentaje)*detalleetapa.porcentaje/100*etapa.porcentaje/100 as porcentajefinal, count (inspeccion.idobra) as registros "
								+ "from inspeccion "
								+ "inner join detalleetapa on detalleetapa.iddetalleetapa=inspeccion.iddetalleetapa "
								+ "inner join obra on obra.idobra=inspeccion.idobra "
								+ "inner join etapa on etapa.idetapa=detalleetapa.idetapa "
								+ "inner join subetapa on subetapa.idsubetapa=detalleetapa.idsubetapa "
								+ "where inspeccion.idobra=" +separadorobras[0]+ "group by inspeccion.idobra, obra.nombre, obra.idtipoobra, inspeccion.iddetalleetapa, etapa.nombre, detalleetapa.porcentaje, etapa.porcentaje, etapa.idetapa "
								+ "order by obra.nombre asc");
                      
						Integer cont = 0;
						Integer porcentajeEtapa = 0;
						Double sumaporobra = 0.00;
						Double resultadoobra = 0.00;
						Integer contarRegistros =0;
						
						
						while (rs2.next()) {
							contarRegistros += rs2.getInt("registros");
							sumaporobra += rs2.getDouble("porcentajefinal");
							cont++;
							tipoobra=rs2.getString("idtipo");
							
						}
						
						%>	
                      
                      <tr style="cursor: pointer" data-toggle="modal" data-target="#OBD1" id="<%=separadorobras[0] %>" onclick="cargarGraficoBotones(this.id);">
                      <td style="color:#666;">&nbsp;&nbsp;&nbsp;&nbsp;<b><%=separadorobras[1]%></b></td>
                      <td style="text-align:center;font-size:14px;"><span class="label label-success"><%=contarRegistros%> REALIZADAS</span></td>
                      <td class="progress">
                      <div class="progress-bar progress-bar-success progress-bar-striped active " role="progressbar" aria-valuenow="40" aria-valuemin="0" aria-valuemax="100" style="font-weight:bold;color:#444;width:<%=sumaporobra%>%">
    				  <%=sumaporobra%>%</div></td>
                      </tr>
						
						<%  }%>
              			
              
              
            </tbody>
          </table>
			    	
			    	
			    	</div>
			   </div>
    		</div>
    	</div>
    	</div>
      <!-- ### FIN DEL CONTENEDOR DEL GRAFICO -->
       <% 
    	respuesta.clear();
		if (rs != null)
			rs.close();
			st.close();
			if (rs2 != null)
				rs2.close();
				st2.close();
			%>
      
      
       <div id="OBD3" class="modal fade clasematerial2" role="dialog">
							
			<div class="modal-dialog modal-lg" style="width:1100px;">
				<!-- Modal content-->
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal">&times;</button>
						<h4 class="modal-title" style="text-align: center" id="tituloregistromaterial"> no cargo la consulta </h4>
	
					</div>
					<div class="modal-body" style="min-height:250px; border:solid 0px #000;">
						<div class="row" style="border:solid 0px #000;margin-top:-25px;">
							
								<div class="col-md-2 " style="border:solid 0px blue;height:300px;overflow:auto;padding:0px;margin-top:24px;">
								<table class="table-hover table-bordered tared tab" id="tablaetapasavance" style="width:100%;">
							           <thead >
							              <tr >
							              <th style="font-size:14px;">AVANCE DE ETAPAS</th>
							              </tr>
							            </thead>
							            <tbody>
										</tbody>
									</table>
								
								
								
								
								</div>
								<div class="col-md-3" style="border:solid 0px green;height:300px;overflow:auto;padding-right:10px;padding-left:0px;margin-top:24px;">
								<table class="table-hover table-bordered tab " id="tablasubetapasavance" style="width:100%;">
							           <thead >
							              <tr >
							              <th style="font-size:14px;">AVANCE DE SUBETAPAS</th>
							              <th style="font-size:14px; width:35px;">%</th>
							              </tr>
							            </thead>
							            <tbody class="">
										</tbody>
									</table>
								
								
								
								
								</div>
								
								
								
								
								 
								<!--  INICIO TABLA PARA LISTAR LAS INSPECCIONES REALIZADAS A LA OBRA-->
								<div class="col-md-7" style="border:solid 0px green;height:300px;overflow:auto;padding-right:10px;padding-left:0px;">
								
								<table class="table-hover table-bordered tab" id="tabladatosinspeccionobra" style="box-sizing: border-box;width:100%">
							           <thead >
							              <tr><td colspan='4' style="font-weight:bold;color:#444;" id="tituloinspeccionessubetapas">HISTORIAL DE INSPECCION DE </td></tr>
							              <tr >
							              	<th style="font-size:14px;">FECHA</th>
							                <th style="font-size:14px;">CUADRILLA</th>
							                <th style="font-size:14px;">OBSERVACION</th>
							                <th style="font-size:14px;">% INSP.</th>
							              </tr>
							            </thead>
							            <tbody>
										</tbody>
									</table>
										
								</div> 
								
								
								<!-- FIN DE LA TABLA PARA LISTAR LAS INSPECCIONES A LA OBRA	-->
									
								
								
								
								
						</div>
						
						
								
						
					</div>
				</div>
			</div>
	
		</div>
      
      
     
      
      <div id="OBD1" class="modal fade clasematerial2" role="dialog">
							
			<div class="modal-dialog modal-lg" style="width:1100px;">
				<!-- Modal content-->
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal">&times;</button>
						<h4 class="modal-title" style="text-align: center" id="tituloregistromaterialobra">... </h4>
	
					</div>
					<div class="modal-body" style="min-height:330px; border:solid 0px #000;">
						<div class="row" style="border:solid 0px #000;margin-top:0px;">
								
								
								<div class="col-md-2">
									<div class="col-md-12" style="border:solid 0px green;height:180px;overflow:auto;padding-right:10px;padding-left:10px;" id="botonesdetalles">
									</div>
											<!-- <button class="btn btn-xs btn-success " style="width:100%">General</button><br>
											<button class="btn btn-xs btn-primary" style="width:100%">Detallatada</button>
											<button class="btn btn-xs btn-warning" style="width:100%">Por Entregar</button> -->
									
										<div id="avancesobras" class="chart-holder col-md-12"  style="border:solid 0px #000;height:150px;"></div>
									
								</div>	
									
							
									
									
									<div class="col-md-3" style="border:solid 0px green;height:300px;overflow:auto;padding-right:10px;padding-left:10px;" id="listasubetapas">
										<table class="table-hover table-bordered tab"  style="box-sizing: border-box;width:100%">
							           <thead >
							              <tr >
							              	<th style="font-size:14px;">SUB-ETAPA	</th>
							              </tr>
							            </thead>
							            <tbody>
										</tbody>
									</table>
									</div>
									
								
								<!--  INICIO TABLA PARA LISTAR LOS MATERIALES ENTREGADOS A LA OBRA-->
								<div class="col-md-7" style="border:solid 0px green;height:300px;overflow:auto;padding-right:10px;padding-left:0px;" id="totalmaterialesentregados">
								
								<table class="table-hover table-bordered tab"  style="box-sizing: border-box;width:100%">
							           <thead >
							              <tr >
							              	<th style="font-size:14px;"  id="nombrehead1">MATERIAL</th>
							              	<th style="font-size:14px;"  id="nombrehead2">CATEGORIA</th>
							                <th style="font-size:14px;"  id="nombrehead3">ENTREGADO</th>
							                <th style="font-size:14px;"  id="nombrehead4">ESTIMADO</th>
							                
							              </tr>
							            </thead>
							            <tbody>
										</tbody>
									</table>
										
								</div> 
								
								<!-- TABLA PARA LISTAR LOS MATERIALES SIN LA OPCION DE DETALLE -->
								
								<div class="col-md-10" style="border:solid 0px green;height:300px;overflow:auto;padding-right:10px;padding-left:0px;" id="tablageneral">
								
								<table class="table-hover table-bordered tab"  style="box-sizing: border-box;width:100%">
							           <thead >
							              <tr >
							              	<th style="font-size:14px;"  id="nombrehead5">MATERIAL</th>
							              	<th style="font-size:14px;"  id="nombrehead6">CATEGORIA</th>
							                <th style="font-size:14px;"  id="nombrehead7">ENTREGADO</th>
							                <th style="font-size:14px;"  id="nombrehead8">ESTIMADO</th>
							                
							              </tr>
							            </thead>
							            <tbody>
										</tbody>
									</table>
										
								</div> 
								
								
								
								<!-- FIN DE LA TABLA PARA LISTAR LOS MATERIALES ENTREGADOS A LA OBRA	-->
<style >
.lista ul {
    list-style-type: none;
    margin: 0;
    padding: 0;
    background-color: #f1f1f1;
}
.lista li {
	list-style:none;
}
.lista li a {
    display: block;
    color: #000;
    padding: 4px 0 4px 16px;
    text-decoration: none;
    border:solid 1px #ccc;
}

/* Change the link color on hover */
.lista li a:hover {
    background-color: #ccc;
	cursor: pointer;
}
.activado {
	    background-color: #ccc;
	   
	}
</style>
									
									<!--  INICIO  PARA IMPIMIR LOS COMPUTOS METRICOS DE ESE TIPO DE OBRA-->
								<div class="col-md-10" style="border:solid 0px green;padding-right:10px;padding-left:0px;padding-bottom:0px;height:300px"id="contenedortablascomputos">
								
								<!-- ACORDION PARA IMPRIMIR LAS ETAPAS -->
								<div class="panel-group col-md-7" id="accordion" style="border:solid 0px green;height:300px;overflow:auto;">
									  
									  
									  
								</div>
								<!-- FIN ACORDION PARA IMPRIMIR LAS ETAPAS -->
								
								<!-- SECCION PARA EL DETALLE DE LOS MATERIALES -->
								
									  <table class="table-hover table-bordered tab col-md-5"  style="border:solid 0px #000;"  id="materialesestimados">
							           		
							           <thead >
							           <tr ><th colspan=2 style="font-size:14px;" >Computos Metricos a usar en 
							           <span id="titulodemateriales" style="background:#4caf50;color:white;padding-left:5px;padding-right:5px;"></span></th></tr>
							              <tr >
							              	<th style="font-size:14px;">MATERIAL</th>
							              	<th style="font-size:14px;">CANTIDAD</th>
							              </tr>
							            </thead>
							            <tbody>
							            
										</tbody>
									</table>
									  
									  
								
								<!-- FIN DE LA SECCION PARA EL DETALLE DE LOS MATERIALES -->


	
								</div> 
								
								
								<!-- FIN DE TABLA PARA IMPIMIR LOS COMPUTOS METRICOS DE ESE TIPO DE OBRA	-->
								
						</div>
						
						
								
						
					</div>
					
					
					
				</div>
			</div>
	
		</div>
      
      
      <!-- INICIO DEL MODAL DEL GRAFICO -->
<div class="modal fade charts-grafico3" role="dialog" tabindex=-1 aria-labelledby="myLargeModalLabel">
 <div class="modal-dialog modal-lg" role="document">
  <div class="modal-content"> <div class="modal-header"> 
 		<button type="button" class="close" data-dismiss="modal" aria-label="Close">
 		<span aria-hidden=true>&times;</span>
 		</button>
  <h4 class="modal-title" id="myLargeModalLabel" style="text-align:center;">Estado de Obras</h4>
   </div> 
   <div class="modal-body" style="min-height:500px;margin-top:-20px;"> 
   	<div class="row">
	   		
	   			<div id="" class="col-md-6">
	 			
			    	<table class="table-bordered tab" style="box-sizing: border-box; width:100%;" >
          
            <thead >
              <tr >
                
                <th style="width:35%" title="SALEEEEE">OBRA</th>
                <th style="width:30% ">ESTADO</th>
                <th style="width:35%">PROGRESO</th>
              </tr>
            </thead>
            <tbody>
              <tr >              
                <td>Casa Viuda 1</td>
                <td><span class="label label-success">EJECUCIÓN</span></td>
                <!-- BARRA DE PROGRESO -->
                <td class="progress">
  				<div class="progress-bar  progress-bar-striped active " role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 100%">
    			100%</div>
    			</td>
                <!-- FIN DE BARRA DE PROGRESO -->
              </tr>
              
              <tr >               
                <td>Casa Modular 2-3</td>
                <td><span class="label label-success">EJECUCIÓN</span></td>
                <!-- BARRA DE PROGRESO -->
                <td class="progress">
  				<div class="progress-bar progress-bar-success progress-bar-striped active " role="progressbar" aria-valuenow="40" aria-valuemin="0" aria-valuemax="100" style="width: 90%">
    			90%</div>
    			</td>
                <!-- FIN DE BARRA DE PROGRESO -->
              </tr>
              
              
              
            </tbody>
          </table>
			    </div>	
			    	
	   
	   
		   		<div id="" class="col-md-6" style="height:260px;"><h3>Datos</h3>
		   		<p>La informacion se genera de las obras, es decir, partiendo del estatus en el que se encuentra la obra,
		   		y siendo identificado con colores en especifico, los cuales se reflejan en el grafico inferior, indicando la cantidad 
		   		y el porcentaje que representa el estado de todas las obras creadas </p>
		   		
		   		
		   		<div id="estadodeobrasa" class="chart-holder col-md-6"></div>
		   		</div>
		   		
   			</div>
   </div>
   
   </div> 
   </div> 
   </div> 
   
    	<!-- FIN DEL MODAL DEL GRAFICO -->
      
      
      
      <!-- INICIO DE JAVASCRIPT PARA EL GRAFICO DEL MODAL -->
       <script>
       $(document).ready(function() {
			
   		$('.clasematerial2').on('hide.bs.modal', function (e) {
   			$('#tablasubetapasavance tbody').html("");
   			$('#tabladatosinspeccionobra tbody').html("");
   			$('#tituloinspeccionessubetapas').text("HISTORIAL DE INSPECCION DE ");
   			//$('#tabladatosinspeccionobra tbody').html("");
   			$('#totalmaterialesentregados tbody').html("");
   			$('#listasubetapas tbody').html("");
   	  	});
   		
   	});   
      
       
       
       function cargarGraficoBotones(idobra){
      	 $('#listasubetapas tbody').html("");
      	 $('#listasubetapas').hide();
      	 $('#tablageneral').hide();
 	  	 $('#totalmaterialesentregados').hide();
 	  	$('#contenedortablascomputos').hide();
 	  	
      	 var separaid = idobra.split("/");
     		
     		
     		//alert(separaid);
     		
     		 //ENVIO DE DATOS PARA LA CONSULTA Y TRAER LOS MATERIALES ENTREGADOS
     		$.post('./Dashboard',{
     			//VARIALES ENVIADAS PARA GENERAR LA CONSULTA
     			operacion: OPERACION_LISTADO,
     			idobra : separaid[0],
     			grafico3 : 13
     		},
     		//FUNCION PARA RECIBIR Y MOSTRAR LOS DATOS OBTENIDOS EN LA CONSULTA
     		function (json){
     			if(json.valido){
     				var valor = json.data;
     				var tabla = '';
     				var titulo = '';
     				var cont = 0;
     				var botones= '';
     				var porcentaje= 0.00;
     				
     				for(var i=0 ; i < valor.length ; i++){
     					cont++;
     					 					
     					var separado = valor[i].toString().split(",");	
     					
     					titulo = ' Resumen Actividades '+separado[1];
     					botones ='<button class="btn btn-xs btn-success " style="width:100%" id="'+separado[0]+'" onclick="cargarDetalleMaterial(this.id);">Material</button><br><button class="btn btn-xs btn-primary" style="width:100%" id="'+separado[0]+'" onclick="cargarDetalleMaterialDetalle(this.id);">Detalle Mat.</button><button class="btn btn-xs btn-warning" style="width:100%" id="'+separado[0]+'" onclick="cargarMaterialporEntregar(this.id);">Mat. Por Entregar</button><button class="btn btn-xs btn-warning" style="width:100%" id="'+separado[0]+'" onclick="cargarSubetapasMaterialporEntregar(this.id);">Detallada</button><button class="btn btn-xs btn-success" style="width:100%" id="'+separado[0]+'" onclick="cargarInspeccionesTotales(this.id);">Inspecciones</button><button class="btn btn-xs btn-primary" style="width:100%" id="'+separado[0]+'" onclick="cargarSubetapasDetalleInspeccion(this.id);">Detalle Insp.</button><button class="btn btn-xs btn-info" style="width:100%;background:#CE352C" id="'+separado[3]+'" onclick="cargarTipoObra(this.id);">Computos Metricos</button>'
     					
     					porcentaje=separado[2];
     				}
     			
     				if(cont>0){
     					
     					graficoavanceobras(porcentaje);
     					$('#botonesdetalles').html(botones);
     					$('#tituloregistromaterialobra').text(titulo);
     					$('#nombrehead1').text("MATERIAL");
     					$('#nombrehead2').text("CATEGORIA");
     					$('#nombrehead3').text("ENTREGADO");
     					$('#nombrehead4').text("ESTIMADO");
     					
     				}else{
     					$('#totalmaterialesentregados tbody').html("<tr><td colspan='4'><center>No Posee Materiales Asignados </center></td></tr>");
     					$('#tituloregistromaterialobra').text("");
     					$('#botonesdetalles').html(botones);
     				}
     	        }
     		}); 
     	}
       
       function graficoavanceobras(porcent){  
    	   //alert(porcent)
    	   var restante =0;
    	   restante=100-porcent;
    	   var cantidad = parseFloat(porcent);
    	   //alert(cantidad);
    	   
       Highcharts.chart('avancesobras', {
    	    chart: {
    	        plotBackgroundColor: null,
    	        plotBorderWidth: 0,
    	        plotShadow: false,
    	        //width: 300,
    	        spacingLeft: -30,
    	        spacingRight:-30,
    	        spacingTop:0
    	    },
    	    title: {
    	        text: '<span style="font-size:16px;color:green; font-weigth:bold;"></span>',
    	        align: 'center',
    	        verticalAlign: 'middle',
    	        y: -120,
    	        x: -110
    	    },
    	    tooltip: {
    	        pointFormat: '{series.name}: <b>{point.percentage:.2f}%</b>'
    	    },
    	    plotOptions: {
    	        pie: {
    	            dataLabels: {
    	                enabled: false,
    	                
    	                distance: 0,
    	                style: {
    	                    fontWeight: 'bold',
    	                    color: '#000'
    	                }
    	            },
    	            startAngle: -180,
    	            endAngle: 180,
    	            center: ['50%', '55%']
    	        }
    	    },
    	    credits: {
    	   	 enabled: true,
    	       text: 'CorporacionEureka.com',
    	       href: 'http://www.corporacioneureka.com'
    	   },
    	    series: [{
    	        type: 'pie',
    	        name: 'total',
    	        innerSize: '50%',
    	        dataLabels: {
    	            format: '<span style="text-align:center; margin-top:10px; margin-left:70px;"><span style="font-size:14px;color:' +
    	                ((Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black') + '">{y} %</span></span>'
    	        },
    	        data: [{
    	            y: cantidad,
    	            name: "Avance",
    	            color: "#088A29"
    	        }, {
    	            y: restante,
    	            name: "",
    	            color: "#cccccc"
    	        }]
    	    }]
    	});
       
       }
       //FIN DEL GRAFICO PARA MOSTRAR EL AVANCE DE LAS OBRAS
       
       
       function cargarTipoObra(idtipoobra){
    	   $('#listasubetapas').hide();
    	   $('#totalmaterialesentregados').hide();
    	   $('#tablageneral').hide();
    	   $('#materialesestimados').show();
    	   $('#contenedortablascomputos').show();
    	   
 		//var separar = idobra.split("/");
 		//alert (idtipoobra)
 		
 		//alert(separar);
 		
 		 //ENVIO DE DATOS PARA LA CONSULTA Y TRAER LOS MATERIALES ENTREGADOS
 		$.post('./Dashboard',{
 			//VARIALES ENVIADAS PARA GENERAR LA CONSULTA
 			operacion: OPERACION_LISTADO,
 			idtipoobra : idtipoobra,
 			grafico3 : 14
 		},
 		//FUNCION PARA RECIBIR Y MOSTRAR LOS DATOS OBTENIDOS EN LA CONSULTA
 		function (json){
 			if(json.valido){
 				var valor = json.data;
 				var tabla = '';
 				var cabe = '';
 				var cont = 0;
 				var nomtipo='';
 				
 				for(var i=0 ; i < valor.length ; i++){
 					cont++;
 					 var et='';			
 					var separado = valor[i].toString().split(",");	
 					
 					//cabe += '<thead ><tr><th>'+separado[0]+(cargarsubetapa(separado[1]+"/"+separado[2]+"/tabla"+cont))+'</th></tr></thead><tbody id="tabla'+cont+'"></tbody>';
 					cabe += '<div class="panel panel-default" style="margin-top:0px;"><div class="panel-heading" data-toggle="collapse" data-parent="#accordion" href="#etapa'+separado[1]+'" style="cursor:pointer;border:solid 1px #ccc;" id="'+separado[1]+"/"+separado[2]+'" onclick="cargarsubetapa(this.id);"><h4 class="panel-title" style="color:#2196f3;" >'+separado[0]+'</h4></div>'+
 							'<div id="etapa'+separado[1]+'" class="panel-collapse collapse"><ul class="list-group lista"></ul></div></div>';
 					nomtipo= separado[3];
 				}
 				
 					
 				if(cont>0){
 					cargartotalmaterialobra(idtipoobra,nomtipo);
 					$('#accordion').html(cabe);
 					//$('#tablaetapasavance tbody').html(tabla);
 					//$('#tituloregistromaterial').text(titulo);
 					//alert(cabe);
 				}else{
 					//$('#registrosPreciosmateriales tbody').html("<tr><td colspan='3'><center>No existen registros</center></td></tr>");
 				}
 	        }
 		});      
     }
       
       
       
       ////////////////////////////////////////////////////////
       
       function cargarsubetapa(idetapa){
    	   $('#materialesestimados').show();
 		var separar = idetapa.split("/");
 		
 		
 		//alert(idetapa);
 		
 		   //ENVIO DE DATOS PARA LA CONSULTA Y TRAER LOS MATERIALES ENTREGADOS
 		$.post('./Dashboard',{
 			//VARIALES ENVIADAS PARA GENERAR LA CONSULTA
 			operacion: OPERACION_LISTADO,
 			idetapa : separar[0],
 			idtipoobra : separar[1],
 			grafico3 : 15
 		},
 		//FUNCION PARA RECIBIR Y MOSTRAR LOS DATOS OBTENIDOS EN LA CONSULTA
 		function (json){
 			if(json.valido){
 				var valor = json.data;
 				var tabla = '';
 				var titulo = '';
 				var cont = 0;
 				var sum = separar[1];
 				//alert(valor);
 				for(var i=0 ; i < valor.length ; i++){
 					cont++;
 										
 					var separado = valor[i].toString().split(",");	
 					
 					//tabla += '<td style="text-align:center;"><span style="font-size:14px;">'+separado[0]+'</span></td>';
 					tabla += '<li><a class="a'+cont+'" id="'+separado[1]+"/"+separado[2]+"/"+separado[3]+"/"+cont+'" onclick="cargartotalmaterialessubetapas(this.id);"><span class="glyphicon glyphicon-search" aria-hidden="true"> </span>&nbsp;&nbsp;&nbsp;' +separado[0]+'</a></li>';
 					 
 					/* <div id="collapse1" class="panel-collapse collapse">
				       	<ul class="list-group lista">
				     	<li><a id=""><span class="glyphicon glyphicon-search" aria-hidden="true"></span> Subetapa1</a></li>
				     	</ul>
				    </div>
				  </div>*/
 					
 				}
 			
 				if(cont>0){
 					//$('#tabla tbody').html(tabla);
 					cargartotalmateriales(separar[1],separar[0]);
 					$('#etapa'+separar[0]+' ul').html(tabla);
 					//$('#tablaetapasavance tbody').html(tabla);
 					//$('#tituloregistromaterial').text(titulo);
 					//alert(cabe);
 				}else{
 					//$('#registrosPreciosmateriales tbody').html("<tr><td colspan='3'><center>No existen registros</center></td></tr>");
 				}
 	        }
 		});       
     }
       
       
       /////////////////////////////////////////////////////////
       
       
        function cargartotalmateriales(idtipo,idetapa){
 		
 		//var separar = idetapa.split("/");
 		
 		
 		//alert(idetapa+idtipo);
 		
 		   //ENVIO DE DATOS PARA LA CONSULTA Y TRAER LOS MATERIALES ENTREGADOS
 		$.post('./Dashboard',{
 			//VARIALES ENVIADAS PARA GENERAR LA CONSULTA
 			operacion: OPERACION_LISTADO,
 			idetapa : idetapa,
 			idtipoobra : idtipo,
 			grafico3 : 16
 		},
 		//FUNCION PARA RECIBIR Y MOSTRAR LOS DATOS OBTENIDOS EN LA CONSULTA
 		function (json){
 			if(json.valido){
 				var valor = json.data;
 				var tabla = '';
 				var titulo = '';
 				var cont = 0;
 				
 				for(var i=0 ; i < valor.length ; i++){
 					cont++;
 					var separado = valor[i].toString().split(",");	
 					
 					tabla += '<tr><td style="text-align:center;"><span style="font-size:14px;">'+separado[0]+'</span></td><td style="text-align:center;"><span style="font-size:14px;">'+separado[1]+'</span></td></tr>';
 					//tabla += '<li><a id="">'+
 							 //'<span class="glyphicon glyphicon-search" aria-hidden="true"> </span>&nbsp;&nbsp;&nbsp;' +separado[0]+'</a></li>';
 					titulo = separado[2];
 					
 				}
 			
 				if(cont>0){
 					$('#materialesestimados tbody').html(tabla);
 					$('#titulodemateriales').text(titulo);
 					
 					//$('#etapa'+separar[0]+' ul').html(tabla);
 					//$('#materialestotales tbody').html(tabla);
 					//$('#tituloregistromaterial').text(titulo);
 					//alert(cabe);
 				}else{
 					//$('#registrosPreciosmateriales tbody').html("<tr><td colspan='3'><center>No existen registros</center></td></tr>");
 				}
 	        }
 		});       
     }
       
       /////////////////////////////////////////////////////////
       
     
       
       function cargartotalmaterialessubetapas(ids){
 			
 			
 			//alert(valor);
 			  $(".lista a").each(function(){
 	 			$(this).removeClass("activado");
 	 		}); 	
 	 		
 			
 	 		
 			
 		var separar = ids.split("/");
 		//alert(separar[3]);
 		$(".a"+separar[3]).addClass('activado');
 	   
 		
 		
 		//alert(ids);
 		
 		   //ENVIO DE DATOS PARA LA CONSULTA Y TRAER LOS MATERIALES ENTREGADOS
 		$.post('./Dashboard',{
 			//VARIALES ENVIADAS PARA GENERAR LA CONSULTA
 			operacion: OPERACION_LISTADO,
 			idetapa : separar[1],
 			idtipoobra : separar[2],
 			idsubetapa : separar[0],
 			grafico3 : 17
 		},
 		//FUNCION PARA RECIBIR Y MOSTRAR LOS DATOS OBTENIDOS EN LA CONSULTA
 		function (json){
 			if(json.valido){
 				var valor = json.data;
 				var tabla = '';
 				var titulo = '';
 				var cont = 0;
 				
 				for(var i=0 ; i < valor.length ; i++){
 					cont++;
 					var separado = valor[i].toString().split(",");	
 					
 					tabla += '<tr><td style="text-align:center;"><span style="font-size:14px;">'+separado[0]+'</span></td><td style="text-align:center;"><span style="font-size:14px;">'+separado[1]+'</span></td></tr>';
 					//tabla += '<li><a id="">'+
 							 //'<span class="glyphicon glyphicon-search" aria-hidden="true"> </span>&nbsp;&nbsp;&nbsp;' +separado[0]+'</a></li>';
 					titulo = separado[2];
 					
 				}
 			
 				if(cont>0){
 					$('#materialesestimados tbody').html(tabla);
 					$('#titulodemateriales').text(titulo);
 					
 					//$('#etapa'+separar[0]+' ul').html(tabla);
 					//$('#materialestotales tbody').html(tabla);
 					//$('#tituloregistromaterial').text(titulo);
 					//alert(cabe);
 				}else{
 					//$('#registrosPreciosmateriales tbody').html("<tr><td colspan='3'><center>No existen registros</center></td></tr>");
 				}
 	        }
 		});       
     }
       
       
       /////////////////////////////////////////////////////////
       
       function cargartotalmaterialobra(idtipoobra,nombretipo){
 		
 		//var separar = id.split("/");
 		
 		
 		//alert(idtipoobra+nombretipo);
 		
 		   //ENVIO DE DATOS PARA LA CONSULTA Y TRAER LOS MATERIALES ENTREGADOS
 		$.post('./Dashboard',{
 			//VARIALES ENVIADAS PARA GENERAR LA CONSULTA
 			operacion: OPERACION_LISTADO,
 			idtipoobra : idtipoobra,
 			grafico3 : 18
 		},
 		//FUNCION PARA RECIBIR Y MOSTRAR LOS DATOS OBTENIDOS EN LA CONSULTA
 		function (json){
 			if(json.valido){
 				var valor = json.data;
 				var tabla = '';
 				var titulo = '';
 				var cont = 0;
 				
 				for(var i=0 ; i < valor.length ; i++){
 					cont++;
 					var separado = valor[i].toString().split(",");	
 					
 					tabla += '<tr><td style="text-align:center;"><span style="font-size:14px;">'+separado[0]+'</span></td><td style="text-align:center;"><span style="font-size:14px;">'+separado[1]+'</span></td></tr>';
 					//tabla += '<li><a id="">'+
 							 //'<span class="glyphicon glyphicon-search" aria-hidden="true"> </span>&nbsp;&nbsp;&nbsp;' +separado[0]+'</a></li>';
 					titulo = nombretipo;
 					
 				}
 			
 				if(cont>0){
 					$('#materialesestimados tbody').html(tabla);
 					$('#titulodemateriales').text(titulo);
 					
 					//$('#etapa'+separar[0]+' ul').html(tabla);
 					//$('#materialestotales tbody').html(tabla);
 					//$('#tituloregistromaterial').text(titulo);
 					//alert(cabe);
 				}else{
 					//$('#registrosPreciosmateriales tbody').html("<tr><td colspan='3'><center>No existen registros</center></td></tr>");
 				}
 	        }
 		});       
     }
       
       /////////////////////////////////////////////////////////
       
       
       
       
       function cargarDetalleAvanceObra(idobra){
 		
 		var separar = idobra.split("/");
 		
 		
 		//alert(separar);
 		
 		 //ENVIO DE DATOS PARA LA CONSULTA Y TRAER LOS MATERIALES ENTREGADOS
 		$.post('./Dashboard',{
 			//VARIALES ENVIADAS PARA GENERAR LA CONSULTA
 			operacion: OPERACION_LISTADO,
 			idobra : separar[0],
 			grafico3 : 1
 		},
 		//FUNCION PARA RECIBIR Y MOSTRAR LOS DATOS OBTENIDOS EN LA CONSULTA
 		function (json){
 			if(json.valido){
 				var valor = json.data;
 				var tabla = '';
 				var titulo = '';
 				var cont = 0;
 				var sum = separar[1];
 				
 				for(var i=0 ; i < valor.length ; i++){
 					cont++;
 					 					
 					var separado = valor[i].toString().split(",");	
 					//alert();
 					//if(separado.length>6){
 					tabla += '<tr><td style="text-align:center; cursor:pointer;" id="'+separado[0]+"/"+separado[3]+'" onclick="cargarDetalleAvanceObraEtapa(this.id);"><span style="font-size:14px;">'+separado[1]+'</span></td></tr>';
 					//}else{
 					//	tabla += '<tr><td style="text-align:center;"><span style="font-size:14px;">'+separado[1]+'</span></td><td style="text-align:center;font-size:14px">'+separado[2]+'</td><td style="text-align:center; font-size:14px">'+separado[3]+'</td><td style="text-align:center; font-size:14px">'+separado[4]+'</td><td style="text-align:center; font-size:14px"><b>'+separado[5]+'</b></td></tr>';
 					//}
 					
 					titulo = ' Estado Actual de '+separado[2]+'  ( '+sum+ '% ) ';
 				}
 			
 				if(cont>0){
 					
 					$('#tablaetapasavance tbody').html(tabla);
 					$('#tituloregistromaterial').text(titulo);
 				}else{
 					//$('#registrosPreciosmateriales tbody').html("<tr><td colspan='3'><center>No existen registros</center></td></tr>");
 				}
 	        }
 		});      
     }
     
     // #########################################################################################################################
     
      function cargarDetalleAvanceObraEtapa(idetapa){
  		var separar = idetapa.split("/");
  		//alert(separar);
  		 //ENVIO DE DATOS PARA LA CONSULTA Y TRAER LOS MATERIALES ENTREGADOS
  		$.post('./Dashboard',{
  			//VARIALES ENVIADAS PARA GENERAR LA CONSULTA
  			operacion: OPERACION_LISTADO,
  			idetapa : separar[0],
  			idobra : separar[1],
  			grafico3 : 2
  		},
  		//FUNCION PARA RECIBIR Y MOSTRAR LOS DATOS OBTENIDOS EN LA CONSULTA
  		function (json){
  			if(json.valido){
  				var valor = json.data;
  				var tabla = '';
  				var titulo = '';
  				var cont = 0;
  				for(var i=0 ; i < valor.length ; i++){
  					cont++;
  					var separado = valor[i].toString().split(",");	
  					//alert();
  					tabla += '<tr style="cursor:pointer"><td id="'+separado[0]+"/"+separado[1]+"/"+separado[2]+'" onclick="cargarDetalleAvanceObraEtapaSubetapa(this.id);" class="progress"><div  class="progress-bar progress-bar-success progress-bar-striped active " role="progressbar" aria-valuenow="40" aria-valuemin="0" aria-valuemax="100" style="width:'+separado[4]+'%"><span style="color:#444;float">'+separado[3]+'</span></div></td><td class="progress"><span style="color:#444;font-size:12px;float:right">'+separado[4]+'%</span> </td></tr>';
  					//tabla += '<tr><td  class="progress"><div  class="progress-bar progress-bar-success progress-bar-striped active " role="progressbar" aria-valuenow="40" aria-valuemin="0" aria-valuemax="100" style="width:'+separado[1]+'%">s</div></td></tr>';
  					//tabla += '<tr><td style="text-align:center; cursor:pointer;" id="'+separado[0]+"/"+separado[1]+"/"+separado[2]+'" onclick="cargarInspecciondetalle(this.id);"><span style="font-size:14px;">'+separado[1]+'</span></td></tr>';
  					}
  			if(cont>0){
  					$('#tablasubetapasavance tbody').html(tabla);
  					$('#tabladatosinspeccionobra tbody').html("");
  					$('#tituloinspeccionessubetapas').text("HISTORIAL DE INSPECCION DE ");
  				}else{
  					//$('#registrosPreciosmateriales tbody').html("<tr><td colspan='3'><center>No existen registros</center></td></tr>");
  				}
  	        }
  		}); 
  		 
  	 
  		 
  	}
     
     
     // FUNCION PARA CARGAR LA TABLA DE DETALLE DE LAS INSPECCIONES PARTIENDO DEL IDOBRA Y IDETAPA
     
     function cargarDetalleAvanceObraEtapaSubetapa(inspec){
  		
  		var datosinspeccion = inspec.split("/");
  		
  		
  		//alert(datosinspeccion);
  		
  		 //ENVIO DE DATOS PARA LA CONSULTA Y TRAER LOS MATERIALES ENTREGADOS
  		$.post('./Dashboard',{
  			//VARIALES ENVIADAS PARA GENERAR LA CONSULTA
  			operacion: OPERACION_LISTADO,
  			idobra : datosinspeccion[0],
  			idetapa : datosinspeccion[1],
  			idsube : datosinspeccion[2],
  			grafico3 : 3
  		},
  		//FUNCION PARA RECIBIR Y MOSTRAR LOS DATOS OBTENIDOS EN LA CONSULTA
  		function (json){
  			if(json.valido){
  				var valor = json.data;
  				var tabla = '';
  				var titulo = '';
  				var cont = 0;
  				
  				
  				for(var i=0 ; i < valor.length ; i++){
  					cont++;
  					 					
  					var separado = valor[i].toString().split(",");	
  					
  					tabla += '<tr><td style="">'+separado[1]+'</td><td style="">'+separado[2]+'</td><td style="text-align:center">'+separado[3]+'</td><td style="text-align:center">'+separado[4]+'</td></tr>';
  					
  					titulo = ' HISTORIAL DE INSPECCION DE '+separado[0];
  				}
  			
  				if(cont>0){
  					
  					$('#tabladatosinspeccionobra tbody').html(tabla);
  					$('#tituloinspeccionessubetapas').text(titulo);
  				}else{
  					//$('#registrosPreciosmateriales tbody').html("<tr><td colspan='3'><center>No existen registros</center></td></tr>");
  				}
  	        }
  		}); 
  	} 
     
     
     
     
     function cargarDetalleMaterial(idobram){
    	
    	 $('#listasubetapas').hide();
 	  	 $('#tablageneral').show();
 	  	$('#totalmaterialesentregados').hide();
 	  	 $('#listasubetapas tbody').html("");
 	  	$('#contenedortablascomputos').hide();
   		var separaid = idobram.split("/");
   		
   		
   		//alert(separaid);
   		
   		 //ENVIO DE DATOS PARA LA CONSULTA Y TRAER LOS MATERIALES ENTREGADOS
   		$.post('./Dashboard',{
   			//VARIALES ENVIADAS PARA GENERAR LA CONSULTA
   			operacion: OPERACION_LISTADO,
   			idobrar : separaid[0],
   			grafico3 : 4
   		},
   		//FUNCION PARA RECIBIR Y MOSTRAR LOS DATOS OBTENIDOS EN LA CONSULTA
   		function (json){
   			if(json.valido){
   				var valor = json.data;
   				var tabla = '';
   				var titulo = '';
   				var cont = 0;
   				var botones= '';
   				
   				for(var i=0 ; i < valor.length ; i++){
   					cont++;
   					 					
   					var separado = valor[i].toString().split(",");	
   					
   					tabla += '<tr><td style="">'+separado[1]+'</td><td style="">'+separado[2]+'</td><td style="text-align:center">'+separado[3]+'</td><td style="text-align:center">'+separado[5]+'</td></tr>';
   					titulo = ' Resumen Actividades '+separado[0];
   					//botones ='<button class="btn btn-xs btn-success " style="width:100%" id="'+separado[4]+'" onclick="cargarDetalleMaterial(this.id);">Material</button><br><button class="btn btn-xs btn-primary" style="width:100%" id="'+separado[4]+'" onclick="cargarDetalleMaterialDetalle(this.id);">Detalle Mat.</button><button class="btn btn-xs btn-warning" style="width:100%" id="'+separado[4]+'" onclick="cargarMaterialporEntregar(this.id);">Mat. Por Entregar</button><button class="btn btn-xs btn-warning" style="width:100%" id="'+separado[4]+'" onclick="cargarSubetapasMaterialporEntregar(this.id);">Detallada</button><button class="btn btn-xs btn-success" style="width:100%" id="'+separado[4]+'" onclick="cargarInspeccionesTotales(this.id);">Inspecciones</button><button class="btn btn-xs btn-primary" style="width:100%" id="'+separado[4]+'" onclick="cargarSubetapasDetalleInspeccion(this.id);">Detalle Insp.</button>'
   					
   				}
   			
   				if(cont>0){
   					
   					$('#tablageneral tbody').html(tabla);
   					//$('#botonesdetalles').html(botones);
   					//$('#tituloregistromaterialobra').text(titulo);
   					$('#nombrehead5').text("MATERIAL");
   					$('#nombrehead6').text("CATEGORIA");
   					$('#nombrehead7').text("ENTREGADO");
   					$('#nombrehead8').text("ESTIMADO");
   					
   				}else{
   					$('#totalmaterialesentregados tbody').html("<tr><td colspan='4'><center>No Posee Materiales Asignados </center></td></tr>");
   					//$('#tituloregistromaterialobra').text("");
   					//$('#botonesdetalles').html(botones);
   				}
   	        }
   		}); 
   	} 
     
     //FUNCION PARA CARGAR LAS SUBETAPAS DEL BOTON DE DETALLE EN LA VISTA DE MATERIALES ENTREGADOS
     function cargarDetalleMaterialDetalle(idobra){
    	 $('#totalmaterialesentregados tbody').html("");
    	 $('#listasubetapas').show();
 	  	 $('#totalmaterialesentregados').hide();
 	  	 $('#tablageneral').hide();
 	  	$('#contenedortablascomputos').hide();
    		//var separaid = idobra.split("/");
    		
    		
    		//alert(idobra);
    		
    		 //ENVIO DE DATOS PARA LA CONSULTA Y TRAER LOS MATERIALES ENTREGADOS
    		$.post('./Dashboard',{
    			//VARIALES ENVIADAS PARA GENERAR LA CONSULTA
    			operacion: OPERACION_LISTADO,
    			idobra : idobra,
    			grafico3 : 5
    		},
    		//FUNCION PARA RECIBIR Y MOSTRAR LOS DATOS OBTENIDOS EN LA CONSULTA
    		function (json){
    			if(json.valido){
    				var valor = json.data;
    				var tabla = '';
    				var titulo = '';
    				var cont = 0;
    				
    				
    				for(var i=0 ; i < valor.length ; i++){
    					cont++;
    					 					
    					var separado = valor[i].toString().split(",");	
    					
    					tabla += '<tr><td style="text-align:center;cursor:pointer" id="'+separado[0]+"/"+separado[1]+'" onclick="cargarDetalleMaterialDetalleEntregados(this.id);">'+separado[2]+'</td></tr>';
    				
    					
    				}
    			
    				if(cont>0){
    					
    					$('#listasubetapas tbody').html(tabla);
    					$('#nombrehead1').text("MATERIAL");
       					$('#nombrehead2').text("CATEGORIA");
       					$('#nombrehead3').text("ENTREGADO");
       					$('#nombrehead4').text("ESTIMADO");
    					
    				}else{
    					$('#totalmaterialesentregados tbody').html("<tr><td colspan='4'><center>No Existen Materiales Asignados</center></td></tr>");
    					
    				}
    	        }
    		}); 
    	} 
     
     //FUNCION PARA CARGAR LA INFORMACION EN LA TABLA DE MATERIALES ENTREGADOS
     function cargarDetalleMaterialDetalleEntregados(idobra){
    	 $('#totalmaterialesentregados').show();
 		var separaid = idobra.split("/");
 		
 		
 		//alert(separaid);
 		
 		 //ENVIO DE DATOS PARA LA CONSULTA Y TRAER LOS MATERIALES ENTREGADOS
 		$.post('./Dashboard',{
 			//VARIALES ENVIADAS PARA GENERAR LA CONSULTA
 			operacion: OPERACION_LISTADO,
 			idsubetapa : separaid[0],
 			idobra : separaid[1],
 			grafico3 : 6
 		},
 		//FUNCION PARA RECIBIR Y MOSTRAR LOS DATOS OBTENIDOS EN LA CONSULTA
 		function (json){
 			if(json.valido){
 				var valor = json.data;
 				var tabla = '';
 				var titulo = '';
 				var cont = 0;
 				
 				
 				for(var i=0 ; i < valor.length ; i++){
 					cont++;
 					 					
 					var separado = valor[i].toString().split(",");	
 					
 					tabla += '<tr><td style="">'+separado[0]+'</td><td style="">'+separado[1]+'</td><td style="text-align:center">'+separado[2]+'</td><td style="text-align:center">'+separado[3]+'</td></tr>';
 				
 					
 				}
 			
 				if(cont>0){
 					
 					$('#totalmaterialesentregados tbody').html(tabla);
 					$('#nombrehead1').text("MATERIAL");
   					$('#nombrehead2').text("CATEGORIA");
   					$('#nombrehead3').text("ENTREGADO");
   					$('#nombrehead4').text("ESTIMADO");
 					
 				}else{
 					$('#totalmaterialesentregados tbody').html("<tr><td colspan='4'><center>La Subetapa No Posee Materiales Asignados </center></td></tr>");
 					
 				}
 	        }
 		}); 
 	} 
     
     function cargarMaterialporEntregar(idobra){
    	 $('#listasubetapas').hide();
 	  	 $('#tablageneral').show();
 	  	$('#totalmaterialesentregados').hide();
 	  	$('#contenedortablascomputos').hide();
    	 $('#listasubetapas tbody').html("");
    	 $('#nombrehead1').text("MATERIAL");
			$('#nombrehead2').text("CATEGORIA");
			$('#nombrehead7').text("POR ENTREGAR");
			$('#nombrehead4').text("ESTIMADO");
   		//var separaid = idobra.split("/");
   		
   		
   		//alert(idobra);
   		
   		 //ENVIO DE DATOS PARA LA CONSULTA Y TRAER LOS MATERIALES ENTREGADOS
   		$.post('./Dashboard',{
   			//VARIALES ENVIADAS PARA GENERAR LA CONSULTA
   			operacion: OPERACION_LISTADO,
   			idobra : idobra,
   			grafico3 : 7
   		},
   		//FUNCION PARA RECIBIR Y MOSTRAR LOS DATOS OBTENIDOS EN LA CONSULTA
   		function (json){
   			if(json.valido){
   				var valor = json.data;
   				var tabla = '';
   				var titulo = '';
   				var cont = 0;
   				
   				
   				for(var i=0 ; i < valor.length ; i++){
   					cont++;
   					 					
   					var separado = valor[i].toString().split(",");	
   					
   					tabla += '<tr><td style="">'+separado[1]+'</td><td style="">'+separado[2]+'</td><td style="text-align:center">'+separado[3]+'</td><td style="text-align:center">'+separado[5]+'</td></tr>';
   					
   				}
   			
   				if(cont>0){
   					
   					$('#tablageneral tbody').html(tabla);
   					//$('#botonesdetalles').html(botones);
   					//$('#cambiarnombre').text("POR ENTREGAR");
   					
   				}else{
   					$('#nombrehead3').text("POR ENTREGAR");
   					$('#tablageneral tbody').html("<tr><td colspan='4'><center>No Posee Materiales pendientes por Entregar</center></td></tr>");
   					//$('#tituloregistromaterialobra').text("Resumen materiales entregados ");
   				}
   	        }
   		}); 
   	} 
     
     
     //FUNCION PARA CARGAR LAS SUBETAPAS DEL BOTON DE DETALLE POR ENTREGAR
     function cargarSubetapasMaterialporEntregar(idobra){
    	 $('#listasubetapas').show();
 	  	 $('#totalmaterialesentregados').hide();
 	  	$('#tablageneral').hide();
 	  	$('#contenedortablascomputos').hide();
    	 $('#totalmaterialesentregados tbody').html("");
    		//var separaid = idobra.split("/");
    		
    		
    		//alert(idobra);
    		
    		 //ENVIO DE DATOS PARA LA CONSULTA Y TRAER LOS MATERIALES ENTREGADOS
    		$.post('./Dashboard',{
    			//VARIALES ENVIADAS PARA GENERAR LA CONSULTA
    			operacion: OPERACION_LISTADO,
    			idobra : idobra,
    			grafico3 : 8
    		},
    		//FUNCION PARA RECIBIR Y MOSTRAR LOS DATOS OBTENIDOS EN LA CONSULTA
    		function (json){
    			if(json.valido){
    				var valor = json.data;
    				var tabla = '';
    				var titulo = '';
    				var cont = 0;
    				
    				
    				for(var i=0 ; i < valor.length ; i++){
    					cont++;
    					 					
    					var separado = valor[i].toString().split(",");	
    					
    					tabla += '<tr><td style="text-align:center;cursor:pointer" id="'+separado[0]+"/"+separado[1]+'" onclick="cargarDetalleMaterialporEntregar(this.id);">'+separado[2]+'</td></tr>';
    				
    					
    				}
    			
    				if(cont>0){
    					
    					$('#listasubetapas tbody').html(tabla);
    					$('#nombrehead1').text("MATERIAL");
       					$('#nombrehead2').text("CATEGORIA");
       					$('#nombrehead3').text("POR ENTREGAR");
       					$('#nombrehead4').text("ESTIMADO");
    					
    				}else{
    					//$('#totalmaterialesentregados tbody').html("<tr><td colspan='4'><center>No Posee Materiales por Entregar</center></td></tr>");
    					$('#listasubetapas tbody').html("<tr><td><center>No Posee Materiales Pendientes</center></td></tr>");
    				}
    	        }
    		}); 
    	} 
     
     
     
     function cargarDetalleMaterialporEntregar(idetapa){
    	 $('#totalmaterialesentregados').show();
   		var separar = idetapa.split("/");
   		//alert(separar);
   		 //ENVIO DE DATOS PARA LA CONSULTA Y TRAER LOS MATERIALES ENTREGADOS
   		$.post('./Dashboard',{
   			//VARIALES ENVIADAS PARA GENERAR LA CONSULTA
   			operacion: OPERACION_LISTADO,
   			idsubetapa1 : separar[0],
   			idobra1 : separar[1],
   			grafico3 : 9
   		},
   		//FUNCION PARA RECIBIR Y MOSTRAR LOS DATOS OBTENIDOS EN LA CONSULTA
   		function (json){
   			if(json.valido){
   				
   				var valor = json.data;
   				var tabla = '';
   				var titulo = '';
   				var cont = 0;
   				
   				for(var i=0 ; i < valor.length ; i++){
   					cont++;
   					var separado = valor[i].toString().split(",");	
   					//alert(valor);
   					tabla += '<tr><td style="">'+separado[0]+'</td><td style="">'+separado[1]+'</td><td style="text-align:center">'+separado[2]+'</td><td style="text-align:center">'+separado[3]+'</td></tr>';
   	 				
					}
   			if(cont>0){
   				$('#totalmaterialesentregados tbody').html(tabla);
   					
   				}else{
   					$('#totalmaterialesentregados tbody').html("<tr><td colspan='4'><center>No Posee Materiales por Entregar</center></td></tr>");
   				}
   	        }
   		}); 
   	}
     
     
     
     function cargarInspeccionesTotales(idobra){
    	 $('#listasubetapas').hide();
 	  	 $('#totalmaterialesentregados').hide();
 	  	$('#tablageneral').show();
 	  	$('#contenedortablascomputos').hide();
    	 $('#nombrehead5').text("FECHA");
    	 $('#nombrehead6').text("SUBETAPA");
    	 $('#nombrehead7').text("OBSERVACION");
    	 $('#nombrehead8').text("% INSP.");
   		//var separaid = idobra.split("/");
   		$('#listasubetapas tbody').html("");
   		
   		//alert(idobra);
   		
   		 //ENVIO DE DATOS PARA LA CONSULTA Y TRAER LOS MATERIALES ENTREGADOS
   		$.post('./Dashboard',{
   			//VARIALES ENVIADAS PARA GENERAR LA CONSULTA
   			operacion: OPERACION_LISTADO,
   			idobra : idobra,
   			grafico3 : 10
   		},
   		//FUNCION PARA RECIBIR Y MOSTRAR LOS DATOS OBTENIDOS EN LA CONSULTA
   		function (json){
   			if(json.valido){
   				var valor = json.data;
   				var tabla = '';
   				var titulo = '';
   				var cont = 0;
   				
   				
   				for(var i=0 ; i < valor.length ; i++){
   					cont++;
   					 					
   					var separado = valor[i].toString().split(",");	
   					
   					tabla += '<tr><td style="">'+separado[0]+'</td><td style="">'+separado[1]+'</td><td style="text-align:center">'+separado[2]+'</td><td style="text-align:center">'+separado[3]+'%  =  '+separado[4]+'%</td></tr>';
   					
   				}
   			
   				if(cont>0){
   					
   					$('#tablageneral tbody').html(tabla);
   					//$('#botonesdetalles').html(botones);
   					//$('#cambiarnombre').text("POR ENTREGAR");
   					
   				}else{
   					$('#tablageneral tbody').html("<tr><td colspan='4'><center>No posee Inspecciones</center></td></tr>");
   					//$('#tituloregistromaterialobra').text("Resumen materiales entregados ");
   				}
   	        }
   		}); 
   	} 
  
     
     
     //FUNCION PARA CARGAR LAS SUBETAPAS DEL BOTON DE DETALLE EN LA VISTA DE MATERIALES ENTREGADOS
     function cargarSubetapasDetalleInspeccion(idobra){
    	 $('#listasubetapas').show();
 	  	 $('#totalmaterialesentregados').hide();
 	  	$('#tablageneral').hide();
 	  	$('#contenedortablascomputos').hide();
    	 $('#totalmaterialesentregados tbody').html("");
    	 
    		//var separaid = idobra.split("/");
    		
    		
    		//alert(idobra);
    		
    		 //ENVIO DE DATOS PARA LA CONSULTA Y TRAER LOS MATERIALES ENTREGADOS
    		$.post('./Dashboard',{
    			//VARIALES ENVIADAS PARA GENERAR LA CONSULTA
    			operacion: OPERACION_LISTADO,
    			idobra : idobra,
    			grafico3 : 11
    		},
    		//FUNCION PARA RECIBIR Y MOSTRAR LOS DATOS OBTENIDOS EN LA CONSULTA
    		function (json){
    			if(json.valido){
    				var valor = json.data;
    				var tabla = '';
    				var titulo = '';
    				var cont = 0;
    				
    				
    				for(var i=0 ; i < valor.length ; i++){
    					cont++;
    					 					
    					var separado = valor[i].toString().split(",");	
    					
    					tabla += '<tr><td style="text-align:center;cursor:pointer" id="'+separado[0]+"/"+separado[1]+'" onclick="cargarDetalleInspeccionesporSubetapas(this.id);" class="progress"><div  class="progress-bar progress-bar-success progress-bar-striped active " role="progressbar" aria-valuenow="40" aria-valuemin="0" aria-valuemax="100" style="width:'+separado[3]+'%">'+separado[2]+"/"+'<span style="color:#444;font-weight:bold;">'+separado[3]+'%</span></div></td></tr>';
    				
    					
    				}
    			
    				if(cont>0){
    					
    					$('#listasubetapas tbody').html(tabla);
    					 $('#nombrehead1').text("FECHA");
    			    	 $('#nombrehead2').text("CUADRILLA");
    			    	 $('#nombrehead3').text("OBSERVACION");
    			    	 $('#nombrehead4').text("% INSP.");
    					
    				}else{
    					$('#totalmaterialesentregados tbody').html("<tr><td colspan='4'><center>No posee Inspecciones</center></td></tr>");
    					
    				}
    	        }
    		}); 
    	} 
     
     
     
     
     function cargarDetalleInspeccionesporSubetapas(idsubetapa){
    	 $('#totalmaterialesentregados').show();
	    	 $('#nombrehead1').text("FECHA");
	    	 $('#nombrehead2').text("CUADRILLA");
	    	 $('#nombrehead3').text("OBSERVACION");
	    	 $('#nombrehead4').text("% INSP.");
    	 	var separar = idsubetapa.split("/");
    		//alert(separar);
    		 //ENVIO DE DATOS PARA LA CONSULTA Y TRAER LOS MATERIALES ENTREGADOS
    		$.post('./Dashboard',{
    			//VARIALES ENVIADAS PARA GENERAR LA CONSULTA
    			operacion: OPERACION_LISTADO,
    			idsubetapa : separar[0],
    			idobra : separar[1],
    			grafico3 : 12
    		},
    		//FUNCION PARA RECIBIR Y MOSTRAR LOS DATOS OBTENIDOS EN LA CONSULTA
    		function (json){
    			if(json.valido){
    				
    				var valor = json.data;
    				var tabla = '';
    				var titulo = '';
    				var cont = 0;
    				
    				for(var i=0 ; i < valor.length ; i++){
    					cont++;
    					var separado = valor[i].toString().split(",");	
    					//alert(valor);
    					tabla += '<tr><td style="">'+separado[0]+'</td><td style="">'+separado[1]+'</td><td style="text-align:center">'+separado[2]+'</td><td style="text-align:center">'+separado[3]+'%  =  '+separado[4]+'%</td></tr>';
    	 				
 					}
    			if(cont>0){
    				$('#totalmaterialesentregados tbody').html(tabla);
    					
    				}else{
    					$('#totalmaterialesentregados tbody').html("<tr><td colspan='4'><center>No Posee Materiales por Entregar</center></td></tr>");
    				}
    	        }
    		}); 
    	}
     
     
		</script>
      <!-- FIN DE JAVASCRIPT PARA EL GRAFICO DEL MODAL -->
     
    <%conexion.close(); %> 
    
     
     
     
     