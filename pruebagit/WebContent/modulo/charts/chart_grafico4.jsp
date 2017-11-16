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
	ArrayList nombreobras = new ArrayList();
	
	rs = st.executeQuery("select obra.idobra as idobra, obra.nombre as nombreobra  from obra "
			+ "inner join proyecto on proyecto.idproyecto=obra.idproyecto "
			+ "inner join inspeccion on inspeccion.idobra=obra.idobra "
			+ "where obra.idproyecto="+session.getAttribute("idproyecto")+" group by obra.nombre, obra.idobra order by obra.idobra asc");

	while (rs.next()) {

		nombreobras.add(rs.getString("idobra") + "/" + rs.getString("nombreobra"));
		
	}
	
	String[] separadorobras;
	ArrayList segunda = new ArrayList();
	ArrayList obrastotales = new ArrayList();
	for (int i = 0; i < nombreobras.size(); i++) {
		String nombobras = String.valueOf(nombreobras.get(i));
		separadorobras = nombobras.split("/");
		
	
		//System.out.print(separadorobras[0]+",");
	
		
		
		rs2 = st2.executeQuery("select inspeccion.idobra as idobra, obra.nombre as nombreobra, etapa.nombre as nombreetapa, etapa.idetapa, "
				+ "sum(inspeccion.porcentaje*detalleetapa.porcentaje/100) as porcentajefinal, "
				+ "sum(inspeccion.porcentaje*detalleetapa.porcentaje/100*etapa.porcentaje/100) as porcentajefinal2 "
				+ "from inspeccion "
				+ "inner join detalleetapa on detalleetapa.iddetalleetapa=inspeccion.iddetalleetapa "
				+ "inner join obra on obra.idobra=inspeccion.idobra "
				+ "inner join etapa on etapa.idetapa=detalleetapa.idetapa "
				+ "where inspeccion.idobra="+separadorobras[0]+" group by inspeccion.idobra, obra.nombre,  etapa.nombre, etapa.idetapa "
				+ "order by etapa.idetapa asc");
		
		Double sumaobra= 0.00;
		String nombreobra = "";
		ArrayList subeobras = new ArrayList();
		
		while (rs2.next()) {
			sumaobra+=(rs2.getDouble("porcentajefinal2"));
			nombreobra =(rs2.getString("nombreobra"));
			subeobras.add("['"+rs2.getString("nombreetapa")+"',"+rs2.getDouble("porcentajefinal")+"]");
			
		}
		//System.out.print(sumaobra+nombreobra+",");
		//System.out.print(nombreobra+subeobras+"aaaaaaaa,");
		obrastotales.add("{ name:'"+nombreobra+"', y:"+sumaobra+",drilldown:'"+nombreobra+"'}");
		
		segunda.add("{ name:'"+nombreobra+"',id:'"+nombreobra+"', data:"+subeobras+"}");
		
		//System.out.print(obrastotales+",");
		
		//System.out.print(segunda+",aaaaaaaaaaaaaaaaaaaaaaa");
		
	}
	
	
%>



<script src="Archivos/js/charts/exporting.js"></script>
<script src="Archivos/js/charts/drilldown.js"></script>		
  <!-- ### INICIO DEL CONTENEDOR DEL GRAFICO -->
       <div class="col-sm-6 col-md-8 col-xs-12">
      <div class="orden grafico7 col-md-12 col-xs-12" style="border: solid 0px red;padding-right:0px;padding-left:0px">
    		<div class="panel panel-default " >
    				<div class="panel-heading" > 
    				<ul class="panel-opcion" style="margin-top:-5px;"> 
    				<!--  <li><a href="#" class=""   data-toggle="modal" data-target=".charts-grafico4"><span class="glyphicon glyphicon-fullscreen"></span></a></li>-->
                                              
                    </ul>
               <h3 class="panel-title" style="font-size: 18px;">Estado de Obras y Etapas <%=session.getAttribute("nombreproyecto") %></h3>
                    </div>
    
			    <div class="panel panel-body" style="padding:0px;  height:580px;">
			    	
			    	 <div id="detalleobras" class="chart-holder" style="height:580px;"></div>
			    </div>
    		</div>
    	</div>
      </div>
      
      
      <!-- ### FIN DEL CONTENEDOR DEL GRAFICO -->
      
 
      
    	<!-- INICIO DE GRAFICO DE OBRAS Y ETAPAS -->
     <script type="text/javascript">
     Highcharts.setOptions({
    	    lang: {
    	        drillUpText: 'Regresar a las {series.name}'
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
        pointFormat: '<span style="color:{point.color}">{point.name}</span>: <b>{point.y:.2f}%</b> de total<br/>',
       
    },
    
    credits: {
    	 enabled: true,
        text: 'CorporacionEureka.com',
        href: 'http://www.corporacioneureka.com'
    },
    
    series: [{
        name: 'Obras',
        colorByPoint: true,
        data: <%=obrastotales%>
    		}],
    drilldown:{
    	
    	drillUpButton: {
            relativeTo: 'spacingBox',
            position: {
                y: 0,
                x: -40
            },
            theme: {
                fill: 'white',
                'stroke-width': 1,
                stroke: 'gray',
                r: 5,
                states: {
                    hover: {
                        fill: '#a4edba'
                    },
                    select: {
                        stroke: '#039',
                        fill: '#a4edba'
                    }
                }
            }
    	 },
    	
    	
    	 series: <%=segunda %>
    }
});
		</script>
     <!-- FIN DE GRAFICO DE OBRAS Y ETAPAS -->
     
    
                    
     
      <!-- INICIO SCRIPTS DE LAS FUNCIONES DE LOS BOTONES DEL CONTENEDOR -->
      
     <%
     if (rs != null)
 		rs.close();
 		st.close();
 		
 	if (rs2 != null)
 		rs2.close();
 		st2.close();
 		
 		if (rs3 != null)
 	 		rs3.close();
 	 		st3.close();	
 		
 		conexion.close();
     %>
 
     <!-- FIN DE SCRIPTS DE LAS FUNCIONES DE LOS BOTONES DEL CONTENEDOR -->
     
     
     
     