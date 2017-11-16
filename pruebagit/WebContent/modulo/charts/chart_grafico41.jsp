<%@page import="java.util.ArrayList"%>
  <%@ page language="java" %>
  <%@ page import ="java.io.IOException"%> 
  <%@ page import ="java.sql.Connection"%>
  <%@ page import ="java.sql.ResultSet"%>
  <%@ page import ="java.sql.Statement"%>
  <%@ page import ="java.io.PrintWriter"%>
  <%@ page import ="java.sql.SQLException"%>
  
  <%@ page import ="org.json.simple.JSONArray"%>
  <%@ page import ="org.json.simple.JSONObject"%>
  <%@ page import="ve.com.proherco.web.comun.ValidaFormato"%>
  <%@ page import ="ve.com.proherco.web.comun.ConexionWeb"%>

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
	ResultSet rs =null; 
	ResultSet rs2 =null; 
	ResultSet rs3 =null; 
  	
	
	
	ArrayList nobras = new ArrayList();
	ArrayList naa = new ArrayList();
	
	rs = st.executeQuery("select obra.idobra as idobra, obra.nombre as nombreobra, detalleetapa.idetapa as idetapa from obra inner join inspeccion on inspeccion.idobra=obra.idobra inner join detalleetapa on detalleetapa.iddetalleetapa=inspeccion.iddetalleetapa group by obra.idobra, obra.nombre, detalleetapa.idetapa");
	Integer contObras = 0;
	Integer cont = 0;
	Double suma = 0.00;
	while (rs.next()) {
		contObras++;
			nobras.add("{name: '"+rs.getString("nombreobra")+"', y: 90, drilldown: '"+rs.getString("nombreobra")+"'}");
		
			
			
			
			rs2 = st2.executeQuery("select inspeccion.idobra,obra.nombre as nombreobra, inspeccion.iddetalleetapa, etapa.nombre as nombreetapa,subetapa.nombre as nombresubetapa, sum(inspeccion.porcentaje) as porcentajefininspeccion , "
					+ "detalleetapa.porcentaje, sum(inspeccion.porcentaje)*detalleetapa.porcentaje/100 as porcentajefin "
					+ "from inspeccion "
					+ "inner join detalleetapa on detalleetapa.iddetalleetapa=inspeccion.iddetalleetapa "
					+ "inner join obra on obra.idobra=inspeccion.idobra "
					+ "inner join etapa on etapa.idetapa=detalleetapa.idetapa "
					+ "inner join subetapa on subetapa.idsubetapa=detalleetapa.idsubetapa "
					//+ "where inspeccion.idobra=58 and detalleetapa.idetapa=13 "
					+ "group by inspeccion.idobra, inspeccion.iddetalleetapa, detalleetapa.porcentaje, obra.nombre, etapa.nombre,subetapa.nombre");
			
			
			cont = 0;
			suma = 0.00;
			while (rs2.next()) {
				suma += rs2.getDouble("porcentajefin");
				naa.add("'"+rs2.getString("nombresubetapa")+"'"+rs2.getString("porcentajefin")+" SUMA:"+suma);
				cont++;
			}
			
			//System.out.println("suma de porcentaje: "+suma);
	}
	//System.out.println("numero de subetapas por obra: "+cont);
	/* System.out.println("numero de obras: "+contObras);*/
	
	respuesta.clear();
	if(rs!=null) rs.close();
	if(rs2!=null) rs2.close();
	if(rs3!=null) rs3.close();
	st.close();
	st2.close();
	st3.close();
%>



<script src="Archivos/js/charts/exporting.js"></script>
<script src="Archivos/js/charts/drilldown.js"></script>		
  <!-- ### INICIO DEL CONTENEDOR DEL GRAFICO -->
      <div class="orden grafico7">
    		<div class="panel panel-default " >
    				<div class="panel-heading" > 
    				<ul class="panel-opcion" style="margin-top:-5px;"> 
    									 <li><a href="#" class=""   data-toggle="modal" data-target=".charts-grafico4"><span class="glyphicon glyphicon-fullscreen"></span></a></li>
                                              
                    </ul>
               <h3 class="panel-title" style="font-size: 18px;width:400px;">Estado de Obras y Etapas</h3>
                    </div>
    
			    <div class="panel panel-body" style="padding:0px; width:880px; height:580px;">
			    	
			    	 <div id="detalleobras" style="height:580px;"></div>
			    </div>
    		</div>
    	</div>
      
      
      
      <!-- ### FIN DEL CONTENEDOR DEL GRAFICO -->
      
 <!-- INICIO DEL MODAL DEL GRAFICO -->
<div class="modal fade charts-grafico4" role="dialog" tabindex=-1 aria-labelledby="myLargeModalLabel">
 <div class="modal-dialog modal-lg" role="document">
  <div class="modal-content"> <div class="modal-header"> 
 		<button type="button" class="close" data-dismiss="modal" aria-label="Close">
 		<span aria-hidden=true>&times;</span>
 		</button>
  <h4 class="modal-title" id="myLargeModalLabel" style="text-align:center;">Estado de Obras y Etapas </h4>
   </div> 
   <div class="modal-body" style="min-height:500px;margin-top:-20px;"> 
   	<div class="row" >
	   		<div >
	   				   
		   		<div id="" class="col-md-12" style="height:130px;"><!--<h3>Datos</h3>
		   		  <p>Este Grafico representa mayor complejidad en los datos, ya que muestra todas las obras, indicando el avance en el que esta cada una, 
		   		se debe tener en cuenta que el resultado de esto, es la sumatoria de las etapas, que a su vez son el resultado de la suma de las subetapas.
		   		
		   		</p>-->
		   		
		   		</div>
		   		
	   		</div>	
	   			<div class="col-md-12" id="detalleobras2" style="height: 580px; margin-bottom:50px;"></div>
   			</div>
   </div>
   
   </div> 
   </div> 
   </div> 
   
    	<!-- FIN DEL MODAL DEL GRAFICO -->     
      
    	<!-- INICIO DE GRAFICO DE OBRAS Y ETAPAS -->
     <script type="text/javascript">
     Highcharts.setOptions({
    	    lang: {
    	        drillUpText: '< Regresar a las {series.name}'
    	    }
    	});
// Create the chart
Highcharts.chart('detalleobras', {
    
	
	
	chart: {
		type: 'bar',
		backgroundColor: "#FFF"
    },
    title: {
        text:null
    },
    xAxis: {
        type: 'category'
    },
    yAxis: {
        min:0,
        max:100,
        title: {
            text: 'Total Porcentaje de Avance'
        }

    },
    legend: {
        enabled: false
    },
    plotOptions: {
        series: {
            borderWidth: 0,
            dataLabels: {
                enabled: true,
                format: '{point.y:.1f}%'
            }
        }
    },

    tooltip: { 
    	headerFormat: '<span style="font-size:11px">{series.name}</span><br>',
        pointFormat: '<span style="color:{point.color}">{point.name}</span>: <b>{point.y:.2f}%</b> of total<br/>',
       
    },
    
    series: [{
        name: 'Obras',
        colorByPoint: true,
        data: <%=nobras%>
    		}],
    drilldown:{
    	
    	drillUpButton: {
            relativeTo: 'spacingBox',
            position: {
                y: 0,
                x: 0
            },
    	 },
    	
    	
    	 series: [
    		 {name: 'Casa Viuda 1',id:'Casa Viuda 1',data:[['Losa de Piso',100],['Bloquear',100],['FRISO',100 ],['MMT',100],['ACC',0 ]]}, 	        
	         {name: 'Casa Modular 2-3',id:'Casa Modular 2-3',data:[['Losa de Piso',100],['Bloquear',100],['FRISO',100 ],['MMT', 100 ],['ACC',0]]}
    		 	 ]
    }
});
		</script>
     <!-- FIN DE GRAFICO DE OBRAS Y ETAPAS -->
     
     <!-- INICIO DE GRAFICO DE MODAL -->
      <script type="text/javascript">
     Highcharts.chart('detalleobras2', {
    	    
    		
    		
    		chart: {
    	        type: 'bar'
    	    },
    	    title: {
    	        text: 'Grafico de Estado de Obras y Etapas'
    	    },
    	    xAxis: {
    	        type: 'category'
    	    },
    	    yAxis: {
    	        min:0,
    	        max:100,
    	        title: {
    	            text: 'Total Porcentaje de Avance'
    	        }

    	    },
    	    legend: {
    	        enabled: false
    	    },
    	    plotOptions: {
    	        series: {
    	            borderWidth: 0,
    	            dataLabels: {
    	                enabled: true,
    	                format: '{point.y:.1f}%'
    	            }
    	        }
    	    },

    	    tooltip: { 
    	    	useHTML:true,
    	    	headerFormat: '<span style="font-size:11px">{series.name}</span><br>',
    	        pointFormat: '<span style="color:{point.color}">{point.name}</span>: <b>{point.y:.1f}%</b><br/>',
    	       
    	    },
    	    
    	    series: [{
    	    	
    	        name: 'Obras',
    	        colorByPoint: true,
    	        data: [{
    	            name: 'Casa Viuda 1',
    	            y: 90,
    	            drilldown: 'Casa Viuda 1'
    	        }, {
    	            name: 'Casa Modular 2-3',
    	            y: 90,
    	            drilldown: 'Casa Modular 2-3'
    	        }, {
    	            name: 'Casa Modular 4-5',
    	            y: 90,
    	            drilldown: 'Casa Modular 4-5'
    	        },{
    	            name: 'Casa Modular 6-7',
    	            y: 75,
    	            drilldown: 'Casa Modular 6-7'
    	        },{
    	            name: 'Casa Modular 8-9',
    	            y: 75,
    	            drilldown: 'Casa Modular 8-9'
    	        },{
    	            name: 'Casa Modular 10-11',
    	            y: 75,
    	            drilldown: 'Casa Modular 10-11'
    	        },{
    	            name: 'Casa Modular 12-13',
    	            y: 75,
    	            drilldown: 'Casa Modular 12-13'
    	        },{
    	            name: 'Casa Modular 14-15',
    	            y: 50,
    	            drilldown: 'Casa Modular 14-15'
    	        },{
    	            name: 'Casa Modular 16-17',
    	            y: 50,
    	            drilldown: 'Casa Modular 16-17'
    	        },{
    	            name: 'Casa Modular 18-19',
    	            y: 15,
    	            drilldown: 'Casa Modular 18-19'
    	        },{
    	            name: 'Casa Modular 20-21',
    	            y: 15,
    	            drilldown: 'Casa Modular 20-21'
    	        },{
    	            name: 'Casa Modular 22-23',
    	            y: 15,
    	            drilldown: 'Casa Modular 22-23'
    	        },{
    	            name: 'Casa Modular 24-25',
    	            y: 15,
    	            drilldown: 'Casa Modular 24-25'
    	        },{
    	            name: 'Casa Modular 26-27',
    	            y: 15,
    	            drilldown: 'Casa Modular 26-27'
    	        },{
    	            name: 'Casa Modular 28-29',
    	            y: 15,
    	            drilldown: 'Casa Modular 28-29'
    	        },{
    	            name: 'Casa Modular 30-31',
    	            y: 15,
    	            drilldown: 'Casa Modular 30-31'
    	        },{
    	            name: 'Casa Modular 32-33',
    	            y: 15,
    	            drilldown: 'Casa Modular 32-33'
    	        },{
    	            name: 'Casa Modular 34-35',
    	            y: 15,
    	            drilldown: 'Casa Modular 34-35'
    	        },{
    	            name: 'Casa Modular 36-37',
    	            y: 15,
    	            drilldown: 'Casa Modular 36-37'
    	        },{
    	            name: 'Casa Modular 38-39',
    	            y: 15,
    	            drilldown: 'Casa Modular 38-39'
    	        },{
    	            name: 'Casa Viuda 40',
    	            y: 90,
    	            drilldown: 'Casa Viuda 40'
    	        }]
    	    }],
    	    drilldown:{
    	    	
    	    	drillUpButton: {
    	            relativeTo: 'spacingBox',
    	            position: {
    	                y: 0,
    	                x: 0
    	            },
    	    	 },
    	    	
    	    	
    	        series: [{
    	            name: 'Casa Viuda 1',
    	            id: 'Casa Viuda 1',
    	            data: [
    	                [
    	                    'Losa de Piso',
    	                    100
    	                ],[
    	                    'Bloquear',
    	                    100
    	                ],[
    	                    'FRISO',
    	                    100
    	                ],[
    	                    'MMT',
    	                    100
    	                ],[
    	                    'ACC',
    	                    0
    	                ]
    	            ]
    	        }, 
    	        
    	        
    	        	{
    	            name: 'Casa Modular 2-3',
    	            id: 'Casa Modular 2-3',
    	            data: [
    	                [
    	                    'Losa de Piso',
    	                    100
    	                ],[
    	                    'Bloquear',
    	                    100
    	                ],[
    	                    'FRISO',
    	                    100
    	                ],[
    	                    'MMT',
    	                    100
    	                ],[
    	                    'ACC',
    	                    0
    	                ]
    	            ]
    	        },{
    	            name: 'Casa Modular 4-5',
    	            id: 'Casa Modular 4-5',
    	            data: [
    	                [
    	                    'Losa de Piso',
    	                    100
    	                ],[
    	                    'Bloquear',
    	                    100
    	                ],[
    	                    'FRISO',
    	                    100
    	                ],[
    	                    'MMT',
    	                    100
    	                ],[
    	                    'ACC',
    	                    0
    	                ]
    	            ]
    	        },{
    	            name: 'Casa Modular 6-7',
    	            id: 'Casa Modular 6-7',
    	            data: [
    	                [
    	                    'Losa de Piso',
    	                    100
    	                ],[
    	                    'Bloquear',
    	                    100
    	                ],[
    	                    'FRISO',
    	                    0
    	                ],[
    	                    'MMT',
    	                    100
    	                ],[
    	                    'ACC',
    	                    0
    	                ]
    	            ]
    	        },{
    	            name: 'Casa Modular 8-9',
    	            id: 'Casa Modular 8-9',
    	            data:[
    	                [
    	                    'Losa de Piso',
    	                    100
    	                ],[
    	                    'Bloquear',
    	                    100
    	                ],[
    	                    'FRISO',
    	                    0
    	                ],[
    	                    'MMT',
    	                    100
    	                ],[
    	                    'ACC',
    	                    0
    	                ]
    	            ]
    	        },{
    	            name: 'Casa Modular 10-11',
    	            id: 'Casa Modular 10-11',
    	            data: [
    	                [
    	                    'Losa de Piso',
    	                    100
    	                ],[
    	                    'Bloquear',
    	                    100
    	                ],[
    	                    'FRISO',
    	                    0
    	                ],[
    	                    'MMT',
    	                    100
    	                ],[
    	                    'ACC',
    	                    0
    	                ]
    	            ]
    	        },{
    	            name: 'Casa Modular 12-13',
    	            id: 'Casa Modular 12-13',
    	            data: [
    	                [
    	                    'Losa de Piso',
    	                    100
    	                ],[
    	                    'Bloquear',
    	                    100
    	                ],[
    	                    'FRISO',
    	                    0
    	                ],[
    	                    'MMT',
    	                    100
    	                ],[
    	                    'ACC',
    	                    0
    	                ]
    	            ]
    	        },{
    	            name: 'Casa Modular 14-15',
    	            id: 'Casa Modular 14-15',
    	            data: [
    	                [
    	                    'Losa de Piso',
    	                    100
    	                ],[
    	                    'Bloquear',
    	                    100
    	                ],[
    	                    'FRISO',
    	                    0
    	                ],[
    	                    'MMT',
    	                    0
    	                ],[
    	                    'ACC',
    	                    0
    	                ]
    	            ]
    	        },{
    	            name: 'Casa Modular 16-17',
    	            id: 'Casa Modular 16-17',
    	            data: [
    	                [
    	                    'Losa de Piso',
    	                    100
    	                ],[
    	                    'Bloquear',
    	                    100
    	                ],[
    	                    'FRISO',
    	                    0
    	                ],[
    	                    'MMT',
    	                    0
    	                ],[
    	                    'ACC',
    	                    0
    	                ]
    	            ]
    	        },{
    	            name: 'Casa Modular 18-19',
    	            id: 'Casa Modular 18-19',
    	            data: [
    	                [
    	                    'Losa de Piso',
    	                    100
    	                ],[
    	                    'Bloquear',
    	                    0
    	                ],[
    	                    'FRISO',
    	                    0
    	                ],[
    	                    'MMT',
    	                    0
    	                ],[
    	                    'ACC',
    	                    0
    	                ]
    	            ]
    	        },{
    	            name: 'Casa Modular 20-21',
    	            id: 'Casa Modular 20-21',
    	            data: [
    	                [
    	                    'Losa de Piso',
    	                    100
    	                ],[
    	                    'Bloquear',
    	                    0
    	                ],[
    	                    'FRISO',
    	                    0
    	                ],[
    	                    'MMT',
    	                    0
    	                ],[
    	                    'ACC',
    	                    0
    	                ]
    	            ]
    	        },{
    	            name: 'Casa Modular 22-23',
    	            id: 'Casa Modular 22-23',
    	            data: [
    	                [
    	                    'Losa de Piso',
    	                    100
    	                ],[
    	                    'Bloquear',
    	                    0
    	                ],[
    	                    'FRISO',
    	                    0
    	                ],[
    	                    'MMT',
    	                    0
    	                ],[
    	                    'ACC',
    	                    0
    	                ]
    	            ]
    	        },{
    	            name: 'Casa Modular 24-25',
    	            id: 'Casa Modular 24-25',
    	            data: [
    	                [
    	                    'Losa de Piso',
    	                    100
    	                ],[
    	                    'Bloquear',
    	                    0
    	                ],[
    	                    'FRISO',
    	                    0
    	                ],[
    	                    'MMT',
    	                    0
    	                ],[
    	                    'ACC',
    	                    0
    	                ]
    	            ]
    	        },{
    	            name: 'Casa Modular 26-27',
    	            id: 'Casa Modular 26-27',
    	            data: [
    	                [
    	                    'Losa de Piso',
    	                    100
    	                ],[
    	                    'Bloquear',
    	                    0
    	                ],[
    	                    'FRISO',
    	                    0
    	                ],[
    	                    'MMT',
    	                    0
    	                ],[
    	                    'ACC',
    	                    0
    	                ]
    	            ]
    	        },{
    	            name: 'Casa Modular 28-29',
    	            id: 'Casa Modular 28-29',
    	            data: [
    	                [
    	                    'Losa de Piso',
    	                    100
    	                ],[
    	                    'Bloquear',
    	                    0
    	                ],[
    	                    'FRISO',
    	                    0
    	                ],[
    	                    'MMT',
    	                    0
    	                ],[
    	                    'ACC',
    	                    0
    	                ]
    	            ]
    	        },{
    	            name: 'Casa Modular 30-31',
    	            id: 'Casa Modular 30-31',
    	            data: [
    	                [
    	                    'Losa de Piso',
    	                    100
    	                ],[
    	                    'Bloquear',
    	                    0
    	                ],[
    	                    'FRISO',
    	                    0
    	                ],[
    	                    'MMT',
    	                    0
    	                ],[
    	                    'ACC',
    	                    0
    	                ]
    	            ]
    	        },{
    	            name: 'Casa Modular 32-33',
    	            id: 'Casa Modular 32-33',
    	            data: [
    	                [
    	                    'Losa de Piso',
    	                    100
    	                ],[
    	                    'Bloquear',
    	                    0
    	                ],[
    	                    'FRISO',
    	                    0
    	                ],[
    	                    'MMT',
    	                    0
    	                ],[
    	                    'ACC',
    	                    0
    	                ]
    	            ]
    	        },{
    	            name: 'Casa Modular 34-35',
    	            id: 'Casa Modular 34-35',
    	            data: [
    	                [
    	                    'Losa de Piso',
    	                    100
    	                ],[
    	                    'Bloquear',
    	                    0
    	                ],[
    	                    'FRISO',
    	                    0
    	                ],[
    	                    'MMT',
    	                    0
    	                ],[
    	                    'ACC',
    	                    0
    	                ]
    	            ]
    	        },{
    	            name: 'Casa Modular 36-37',
    	            id: 'Casa Modular 36-37',
    	            data: [
    	                [
    	                    'Losa de Piso',
    	                    100
    	                ],[
    	                    'Bloquear',
    	                    0
    	                ],[
    	                    'FRISO',
    	                    0
    	                ],[
    	                    'MMT',
    	                    0
    	                ],[
    	                    'ACC',
    	                    0
    	                ]
    	            ]
    	        },{
    	            name: 'Casa Modular 38-39',
    	            id: 'Casa Modular 38-39',
    	            data: [
    	                [
    	                    'Losa de Piso',
    	                    100
    	                ],[
    	                    'Bloquear',
    	                    0
    	                ],[
    	                    'FRISO',
    	                    0
    	                ],[
    	                    'MMT',
    	                    0
    	                ],[
    	                    'ACC',
    	                    0
    	                ]
    	            ]
    	        },{
    	            name: 'Casa Viuda 40',
    	            id: 'Casa Viuda 40',
    	            data: [
    	                [
    	                    'Losa de Piso',
    	                    100
    	                ],[
    	                    'Bloquear',
    	                    100
    	                ],[
    	                    'FRISO',
    	                    100
    	                ],[
    	                    'MMT',
    	                    100
    	                ],[
    	                    'ACC',
    	                    0
    	                ]
    	            ]
    	        }]
    	    }
    	});
     
     
     </script>
     <!-- FIN DE GRAFICO DE MODAL -->
     
      <!-- INICIO SCRIPTS DE LAS FUNCIONES DE LOS BOTONES DEL CONTENEDOR -->
      
     
 
     <!-- FIN DE SCRIPTS DE LAS FUNCIONES DE LOS BOTONES DEL CONTENEDOR -->
     
     
     
     