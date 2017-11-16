
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
	

	ArrayList avanceobras = new ArrayList();
	rs = st.executeQuery("select inspeccion.idobra as idobra, obra.nombre as nombreobra, "
			+ "sum(inspeccion.porcentaje)*detalleetapa.porcentaje/100*etapa.porcentaje/100 as porcentajefinal "
			+ "from inspeccion "
			+ "inner join detalleetapa on detalleetapa.iddetalleetapa=inspeccion.iddetalleetapa "
			+ "inner join obra on obra.idobra=inspeccion.idobra "
			+ "inner join etapa on etapa.idetapa=detalleetapa.idetapa "
			+ "inner join subetapa on subetapa.idsubetapa=detalleetapa.idsubetapa "
			+ "where obra.idproyecto="+session.getAttribute("idproyecto")+" group by inspeccion.idobra, obra.nombre, inspeccion.iddetalleetapa, "
			+ "etapa.nombre, detalleetapa.porcentaje, etapa.porcentaje, etapa.idetapa");

	/* while (rs.next()) {

		avanceobras.add(rs.getString("idobra") + "/" + rs.getString("nombreobra"));
		
	} */
	
	Double sumatotal = 0.00;
	Double restante = 0.00;

	Double resultado = 0.00;
	Integer contarobras =0;
	String aa = "";
	String aa2 = "";
	while (rs.next()) {
		sumatotal += rs.getDouble("porcentajefinal");
	
	}
	
	respuesta.clear();
	
	rs2 = st2.executeQuery("select count(idobra) as conteo from obra");
	
	while (rs2.next()) {
		contarobras= rs2.getInt("conteo");
	
	}
		resultado=sumatotal/contarobras;
		restante=100-resultado;
		
		aa=ValidaFormato.formato(String.valueOf(restante));
		restante=Double.valueOf(aa.replace(",","."));
		
		aa2=ValidaFormato.formato(String.valueOf(resultado));
		resultado=Double.valueOf(aa2.replace(",","."));
		
		
		//CONSULTAS PARA EL GRAFICO DE AVANCE DE OBRAS Y ETAPAS
		
			
		
%>



<!-- ### INICIO DEL CONTENEDOR DEL GRAFICO -->
<div class="col-sm-6 col-md-4 col-xs-12">
<div class="orden grafico4 col-md-12 col-sm-12 col-xs-12" style="border: solid 0px red;padding-right:0px;padding-left:0px">
	<div class="panel panel-default ">
		<div class="panel-heading">
			<ul class="panel-opcion" style="margin-top: -5px;margin-left:-10px">
				<!-- <li><a href="#" class="" data-toggle="modal" data-target=".charts-grafico2"><span class="glyphicon glyphicon-fullscreen"></span></a></li> -->
			</ul>
			<h3 class="panel-title" style="font-size: 18px;">Avance del Proyecto <%=session.getAttribute("nombreproyecto") %> </h3>
		</div>
		<div class="panel panel-body" style="padding: 0px">
			<div id="avanceproyecto" class="chart-holder"></div>
		</div>
	</div>
</div>
</div>
<!-- ### FIN DEL CONTENEDOR DEL GRAFICO -->

<!-- INICIO DEL MODAL DEL GRAFICO -->
<div class="modal fade charts-grafico2" role="dialog" tabindex=-1 aria-labelledby="myLargeModalLabel">
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden=true>&times;</span>
				</button>
				<h4 class="modal-title" id="myLargeModalLabel"	style="text-align: center;">Avance del Proyecto</h4>
			</div>
			<div class="modal-body" style="min-height: 500px; margin-top: -20px;">
				<div class="row">
					<div>
						<div id="avanceproyecto2" class="chart-holder col-md-6">No se muestra el Grafico</div>
						<div id="" class="col-md-6" style="height: 260px;">
							<h3>Datos</h3>
							<p>Este grafico se Genera partiendo del estado de las etapas
								en el proyecto, lo que nos dara como resultado el avance el
								terminos de porcentaje sobre el proyecto</p>
						</div>
					</div>
					<div class="col-md-12" id="obrasetapas"	style="height: 400px; margin-bottom: 50px;"></div>
				</div>
			</div>
		</div>
	</div>
</div>

<!-- FIN DEL MODAL DEL GRAFICO -->

<!-- ###  INICIO DE JAVASCRIPT PARA GRAFICO HIGHCHARTS -->
<script type="text/javascript">

Highcharts.chart('avanceproyecto', {
    chart: {
        plotBackgroundColor: null,
        plotBorderWidth: 0,
        plotShadow: false
    },
    title: {
        text: '<span style="font-size:16px;color:green; font-weigth:bold;"></span>',
        align: 'center',
        verticalAlign: 'middle',
        y: -120,
        x: -110
    },
    tooltip: {
        pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
    },
    plotOptions: {
        pie: {
            dataLabels: {
                enabled: true,
                
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
        innerSize: '58%',
        dataLabels: {
            format: '<span style="text-align:center; margin-top:10px; margin-left:70px;"><span style="font-size:14px;color:' +
                ((Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black') + '">{y} %</span></span>'
        },
        data: [{
            y: <%=resultado %>,
            name: "Avance",
            color: "#088A29"
        }, {
            y: <%=restante %>,
            name: "",
            color: "#cccccc"
        }]
    }]
});

//alert(data);
		</script>
<!-- ### FIN DE JAVASCRIPT PARA GRAFICO HIGHCHARTS-->

<!-- INICIO DE JAVASCRIPT PARA EL GRAFICO DE MODAL -->
<script type="text/javascript">
		//SCRIPT DEL GRAFICO QUE SE ENCUENTRA EN EL MODAL

		Highcharts.chart('avanceproyecto2', {
		    chart: {
		        plotBackgroundColor: null,
		        plotBorderWidth: 0,
		        plotShadow: false
		    },
		    title: {
		        text: '<span style="font-size:16px;color:green; font-weigth:bold;"></span>',
		        align: 'center',
		        verticalAlign: 'middle',
		        y: -120,
		        x: -110
		    },
		    tooltip: {
		        pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
		    },
		    plotOptions: {
		        pie: {
		            dataLabels: {
		                enabled: true,
		                
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
		        innerSize: '58%',
		        dataLabels: {
		            format: '<span style="text-align:center; margin-top:10px; margin-left:70px;"><span style="font-size:14px;color:' +
		                ((Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black') + '">{y} %</span></span>'
		        },
		        data: [{
		        	y: <%=resultado %>,
		            name: "Avance",
		            color: "#088A29"
		        }, {
		            y: <%=restante %>,
		            name: "",
		            color: "#cccccc"
		        }]
		   
		    }]
		});
		//SCRIPT DEL GRAFICO AVANCE DE OBRAS Y ETAPAS
		
		
		
		
		
</script>
<%
    respuesta.clear();
	if (rs != null)
		rs.close();
		st.close();
	if (rs2 != null)
		rs2.close();
		st2.close();
		
		conexion.close();
%>
<!-- FIN DE JAVASCRIPT PARA GRAFICO DE MODAL -->





