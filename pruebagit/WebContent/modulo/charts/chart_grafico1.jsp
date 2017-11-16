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
  	
  //System.out.print(session.getAttribute("idproyecto"));
  
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
  	Double dolar = 0.00;
  	String dato = request.getParameter("a");
  	
	Double montocom = 0.00;
	rs = st.executeQuery("select sum(montofactura) as montocompra from compra");
		if	(rs.next()){
		montocom=rs.getDouble("montocompra");
	}
	
	Double montopago = 0.00;
	rs2 = st2.executeQuery("select sum(montototal) as montopago from pago where estatus=0");
	if	(rs2.next()){
		montopago=rs2.getDouble("montopago");
	}
	Double montodolar = 0.00;
	rs3 = st3.executeQuery("select valor, fecha from dolartoday order by iddolar desc limit 1");
		if	(rs3.next()){
		montodolar=rs3.getDouble("valor");
	}
	
	
	ArrayList m = new ArrayList();
	ArrayList mont = new ArrayList();
	rs = st.executeQuery("select date_part('month',fecha) as mes, sum(montofactura)as montomes from compra group by mes order by mes asc");
	while (rs.next()) {
		//montocom = rs.getInt("montocompra");
		m.add("'"+ValidaFormato.MESES[rs.getInt("mes")-1]+"'");
		mont.add(rs.getDouble("montomes"));
	}
	ArrayList ms = new ArrayList();
	ArrayList pago = new ArrayList();
	rs = st.executeQuery("select date_part('month',fecharegistro) as mes, sum(montototal)as montopago from pago where estatus=0 group by mes order by mes asc");
	while (rs.next()) {
		//montocom = rs.getInt("montocompra");
		ms.add("'"+ValidaFormato.MESES[rs.getInt("mes")-1]+"'");
		pago.add(rs.getDouble("montopago"));
	}
	
	Double montototal = 0.00;
	montototal=montocom+montopago;
	
	Double montoendolares=0.00;
	montoendolares=montocom/montodolar+montopago/montodolar;
	
	Double montocomdolar=0.00;
	montocomdolar=montocom/montodolar;
	
	Double montopagodolar=0.00;
	montopagodolar=montopago/montodolar;
	
	String pp = "";
	String cd = "";
	String pd = "";
	String MontoTotal = "";
	
	pp=ValidaFormato.formato(String.valueOf(montoendolares));
	//System.out.print(pp);
	//montoendolares=Double.valueOf(pp.replace(".", "").replace(",", "."));
	
	cd=ValidaFormato.formato(String.valueOf(montocomdolar));
	montocomdolar=Double.valueOf(cd.replace(".", "").replace(",", "."));
	
	pd=ValidaFormato.formato(String.valueOf(montopagodolar));
	montopagodolar=Double.valueOf(pd.replace(".", "").replace(",", "."));
	
	MontoTotal=ValidaFormato.formato(String.valueOf(montototal));
	
	
	respuesta.clear();
	if(rs!=null) rs.close();
	if(rs2!=null) rs2.close();
	if(rs3!=null) rs3.close();
	st.close();
	st2.close();
	st3.close();
%>

<script src="Archivos/js/charts/exporting.js"></script>
 
		<!-- ### INICIO DEL CONTENEDOR DEL GRAFICO -->
		<div class="col-sm-6 col-md-4 col-xs-12">
		<div class="orden grafico1 col-md-12 col-sm-12 col-xs-12" style="border: solid 0px blue;padding-right:0px;padding-left:0px;">
    		<div class="panel panel-default " >
    				<div class="panel-heading" > 
    				<ul class="panel-opcion" style="margin-top:-5px;">
                        <li><a href="#" class=""  data-toggle="modal" data-target=".charts-grafico1"><span class="glyphicon glyphicon-fullscreen"></span></a></li>
                                        
                                        
                    </ul>
               <h3 class="panel-title" style="font-size: 18px;">Inversión General</h3>
                    </div>
    
			    <div class="panel panel-body" style="padding:0px">
			    	<div id="container-presupuestogeneral" class="chart-holder"></div>
			    </div>
    		</div>
    	</div>
    	</div>
      	<!-- ### FIN DEL CONTENEDOR DEL GRAFICO -->
     
		<!-- INICIO DEL MODAL DEL GRAFICO -->
<div class="modal fade charts-grafico1" role="dialog" tabindex=-1 aria-labelledby="myLargeModalLabel">
 <div class="modal-dialog modal-lg" role="document">
  <div class="modal-content"> <div class="modal-header"> 
 		<button type="button" class="close" data-dismiss="modal" aria-label="Close">
 		<span aria-hidden=true>&times;</span>
 		</button>
  <h4 class="modal-title" id="myLargeModalLabel" style="text-align:center;font-size:30px;">Inversion General</h4>
   </div> 
   <div class="modal-body" style="min-height:500px;margin-top:-20px;"> 
   	<div class="row" >
	   		<div >
	   			<div id="container-presupuestogeneral2" class="chart-holder col-md-6">No se muestra el Grafico</div>
	   
		   		<div id="" class="col-md-6" style="height:260px; width:49%; border:solid 0px #000"><h3>Inversión</h3>
		   		<p style="text-align:justify">
		   		Estos 3 graficos se generan, obteniendo la información de las Inversiones realizadas en Compras y Pagos, Ademas al obtener el valor del Dolar($)
		   		logramos detallar cuanto hemos invertido a nivel General (Sumatoria entre Compras y Gastos), Individual (Total de todas las Compras y Pagos)
		   		  y Mensual (Compras y Pagos realizados durante el Mes). 
		   		
		   		</p>
		   		
		   		</div>
		   		
	   		</div>	
	   			<div class="col-md-12" id="bar-gastos" style="height: 100px;"></div>	
   			<div class=" col-md-12" id="gastosmensuales" style="border:solid 1px #fff;margin-top:10px;"> 
   				
   			
   			</div>
   </div>
   
   </div> 
   </div> 
   </div> 
   </div>
    	<!-- FIN DEL MODAL DEL GRAFICO -->
     
     	<!-- ###  INICIO DE JAVASCRIPT PARA GRAFICO HIGHCHARTS INICIO -->
<script type="text/javascript">


 var presupuestogeneral = {

    chart: {
        type: 'solidgauge',
        width: 200
    },
    
    title: ' s',

    pane: {
        center: ['50%', '60%'],
        size: '100%',
        startAngle: -140,
        endAngle: 90,
        background: {
            backgroundColor: (Highcharts.theme && Highcharts.theme.background2) || '#EEE',
            innerRadius: '60%',
            outerRadius: '100%',
            shape: 'arc'
        }
    },

    tooltip: {
        enabled: false
    },

    // the value axis
    yAxis: {
        stops: [
        	// [0.1, '#DF5353'], // green
	           // [0.5, '#DDDF0D'], // yellow
	           // [0.8, '#55BF3B'] // red
	           [0.1, '#FF0000'], // green
	             [0.3, '#FF8000'],
	            [0.5, '#DDDF0D'], // yellow
	             [0.7, '#5FB404'],
	            [0.9, '#088A29'] // red
         
           
        ],
        lineWidth: 0,
        minorTickInterval: null,
        tickColor: "#000000",
        tickAmount: 0,
       
        title: {
            y: -180
        },
        labels: {
        	     	
            y: 16
        }
    },
    credits: {
   	 enabled: true,
       text: 'CorporacionEureka.com',
       href: 'http://www.corporacioneureka.com'
   },
    plotOptions: {
        solidgauge: {
            dataLabels: {
                y: 5,
                borderWidth: 0,
                useHTML: true
            }
        }
    }
};

 Highcharts.chart('container-presupuestogeneral', {
	    chart: {
	        plotBackgroundColor: null,
	        plotBorderWidth: 0,
	        plotShadow: false,
	        
	    },
	    title: {
	    	useHTML : false,
	        text: '<b><%=MontoTotal%> Bs</b><br><b><%=pp %> $</b>',
	        align: 'center',
	        verticalAlign: 'middle',
	        y: 70
	    },
	  
	    tooltip: {
	        pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
	    },
	    plotOptions: {
	        pie: {
	            dataLabels: {
	                enabled: true,
	                distance: -30,
	                style: {
	                    fontWeight: 'bold',
	                    color: 'white'
	                }
	            },
	            startAngle: -90,
	            endAngle: 90,
	            size: '140%',
	            center: ['50%', '75%']
	        },
	    },
	    credits: {
	    	 enabled: true,
	        text: 'CorporacionEureka.com',
	        href: 'http://www.corporacioneureka.com'
	    },
	    series: [{
	        type: 'pie',
	        name: 'Porcentaje de Gastos',
	        innerSize: '50%',
	        data: [
	            ['Compras', <%=montocom%>],
	            ['Pagos',   <%=montopago%>],
	            
	        ]
	    }]
	});
 
 
		</script>
		<!-- ### FIN DE JAVASCRIPT PARA GRAFICO HIGHCHARTS-->
   
    	<!-- INICIO DE JAVASCRIPT PARA EL GRAFICO DE MODAL -->     
<script type="text/javascript">
		//SCRIPT DEL GRAFICO QUE SE ENCUENTRA EN EL MODAL
 Highcharts.chart('container-presupuestogeneral2', {
	    chart: {
	        plotBackgroundColor: null,
	        plotBorderWidth: 0,
	        plotShadow: false
	        
	    },
	    title: {
	        text: '<b><%=MontoTotal%> Bs</b><br><b><%=pp %> $</b>',
	        align: 'center',
	        verticalAlign: 'middle',
	        y: 70
	    },
	  
	    tooltip: {
	        pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
	    },
	    plotOptions: {
	        pie: {
	            dataLabels: {
	                enabled: true,
	                distance: -30,
	                style: {
	                    fontWeight: 'bold',
	                    color: 'white'
	                }
	            },
	            startAngle: -90,
	            endAngle: 90,
	            size: '140%',
	            center: ['50%', '75%']
	        },
	    },
	    credits: {
	    	 enabled: true,
	        text: 'CorporacionEureka.com',
	        href: 'http://www.corporacioneureka.com'
	    },
	    series: [{
	        type: 'pie',
	        name: 'Porcentaje de Gastos',
	        innerSize: '50%',
	        data: [
	            ['Compras', <%=montocom%>],
	            ['Pagos',   <%=montopago%>],
	            
	        ]
	    }]
	});
				
//GRAFICO DE GASTOS DE TIPO BARRA EL CUAL REFLEJA LAS COMPRAS Y PAGOS EN UNA MISMA LINEA
		Highcharts.chart('bar-gastos', {
		    chart: {
		        type: 'bar'
		    },
		    title: null,
		    xAxis: {
		        categories: ['']
		    },
		    yAxis: {
		        min: null,
		        title: {
		            text: ''
		        }
		    },
		    legend: {
		        layout: 'vertical',
		        align: 'left',
		        verticalAlign: 'top',
		        x: 10,
		        y: 2,
		        reversed: false,
		        floating: false,
		        borderWidth: 1,
		        backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '#FFFFFF'
		    },
		    
		    plotOptions: {
		        series: {
		            stacking: 'normal'
		        }
		    },
		    credits: {
		    	 enabled: true,
		        text: 'CorporacionEureka.com',
		        href: 'http://www.corporacioneureka.com'
		    },
		    
		    
		    series: [{
		        name: 'Compras <%=montocomdolar%>$ ',
		        data: [<%=montocom %>]
		    }, {
		        name: 'Pagos <%=montopagodolar%>$ ',
		        data: [<%=montopago%>]
		    }]
		});
		
		
		//GRAFICO QUE REFLEJA LOS GASTOS DE COMPRA Y PAGOS A NIVEL MENSUAL
Highcharts.chart('gastosmensuales', {
    chart: {
        type: 'areaspline'
    },
    title: {
        text: 'Relación de Gastos Mensuales'
    },
    
    xAxis: {
        categories: <%=m%>
        	 ,
        
    },
    yAxis: {
        title: {
            text: 'Inversión en Bolivares'
        },
        labels: {
            formatter: function () {
                return this.value / 1000 + 'k';
            }
        }
    },
    tooltip: {
        shared: true,
        valueSuffix: ' Bs',
        valuePrefix: ''
        
    },
    credits: {
   	 enabled: true,
       text: 'CorporacionEureka.com',
       href: 'http://www.corporacioneureka.com'
   },
    plotOptions: {
        areaspline: {
            fillOpacity: 0.5
        }
    },
    series: [{
        name: 'Compras  <%=montocomdolar%>$ ',
        data: <%=mont%>,
        stack: 'gastos'
    }, {
        name: 'Pagos  <%=montopagodolar%>$ ',
        data: <%=pago%>,
        stack: 'gastos'
    }]
});



		</script>
		<!-- FIN DE JAVASCRIPT PARA GRAFICO DE MODAL -->

	<%conexion.close(); %> 
     
     