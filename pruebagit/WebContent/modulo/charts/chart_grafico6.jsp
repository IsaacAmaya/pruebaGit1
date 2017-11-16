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

	%>
  
  <!-- ### INICIO DEL CONTENEDOR DEL GRAFICO -->
  <div class="col-sm-6 col-md-4 col-xs-12">
<div class="orden grafico6 col-md-12 col-sm-12 col-xs-12" style="border: solid 0px red;padding-right:0px;padding-left:0px">
	<div class="panel panel-default ">
		<div class="panel-heading">
			<ul class="panel-opcion" style="margin-top: -5px;">
				<li><a href="#" class="" data-toggle="modal"
					data-target=".charts-grafico6"><span
						class="glyphicon glyphicon-fullscreen"></span></a></li>

			</ul>
			<h3 class="panel-title" style="font-size: 18px; ">Precios Materiales</h3>
		</div>

		<div class="panel panel-body" style="padding: 0px;">
			<div class="chart-holder" style=" height: 260px; overflow: auto;" id="scrollbar3">
				<table class="table-bordered table-hover tared tab"
					style="box-sizing: border-box; width: 100%;">
					<thead>
						<tr>

							<th>MATERIAL</th>
							<th>FECHA</th>
							<th>PRECIO</th>
						</tr>
					</thead>
					<tbody>
						<%
							Integer contador = 0;
							rs = st.executeQuery(
									"select T1.idmaterial as idmaterial, material.nombre as nombrematerial, T1.costounitario as preciocompra, compra.fecha as fechacompra "
											+ "from compramaterial T1 " + "inner join compra on compra.idcompra=T1.idcompra "
											+ "inner join material on material.idmaterial=T1.idmaterial where compra.fecha = (select max(compra.fecha) from material T2 "
											+ "inner join compramaterial on compramaterial.idmaterial=T2.idmaterial "
											+ "inner join compra on compra.idcompra=compramaterial.idcompra where T1.idmaterial= T2.idmaterial ) order by material.nombre ");
							while (rs.next()) {
								contador++;
								String precio = String.valueOf(rs.getDouble("preciocompra"));
								//ValidaFormato.formato(precio)
								precio = ValidaFormato.formato(precio);
								String fecha="";
								fecha = ValidaFormato.cambiarFecha(rs.getString("fechacompra"), 2);
								//respuesta.put("txtPresupuesto", ValidaFormato.formato(presupuesto));
						%>
						<tr data-toggle="modal" data-target="#E" style="cursor: pointer" id="<%=rs.getString("idmaterial")%>" onclick="cargarRegistroCompra(this.id)">
							<td>&nbsp;&nbsp;&nbsp;&nbsp;<%=rs.getString("nombrematerial")%></td>

							<td style="text-align: center"><%=fecha%></td>
							<td style="text-align: right"><%=precio%> Bs &nbsp;&nbsp;&nbsp;</td>
						</tr>
						<%
							}

						respuesta.clear();
						if (rs != null)
							rs.close();
						st.close();
					%>
					</tbody>
				</table>

			</div>
		</div>
	</div>

</div>
</div>






<!-- ### FIN DEL CONTENEDOR DEL GRAFICO -->
      <div id="E" class="modal fade clasematerial" role="dialog">
							
							
							
							
							<div class="modal-dialog modal-lg">
								<!-- Modal content-->
								<div class="modal-content">
									<div class="modal-header">
										<button type="button" class="close" data-dismiss="modal">&times;</button>
										<h4 class="modal-title" style="text-align: center" id="tituloregistromateriales"> </h4>

									</div>
									<div class="modal-body" style="min-height:300px;margin-top:-20px;">
										<div class="row" >
										<div class=" col-md-12" style="border:solid 0px blue;max-height:300px" >
												<table class="table-hover table-bordered tab" id="registrosPreciosmateriales" style="box-sizing: border-box; width:100%;" >
											           <thead >
											              <tr >
											              <th >FECHA</th>
											                <th >FACTURA</th>
											                <th >PROVEEDOR</th>
											                <th >CANTIDAD</th>
											                <th >PRECIO</th>
											                
											                
											              </tr>
											            </thead>
											            <tbody>
														</tbody>
													</table>
										</div>			
										<div class=" col-md-12" id="resultado" style="border:solid 1px #fff;margin-top:10px;">aaa</div>
										
									</div>
									
									</div>
								</div>
							</div>

						</div>
      
      
      
      
      
     <!-- INICIO DEL MODAL DEL GRAFICO -->
<div class="modal fade charts-grafico6" role="dialog" tabindex=-1 aria-labelledby="myLargeModalLabel">
 <div class="modal-dialog modal-lg" role="document">
  <div class="modal-content"> <div class="modal-header"> 
 		<button type="button" class="close" data-dismiss="modal" aria-label="Close">
 		<span aria-hidden=true>&times;</span>
 		</button>
  <h4 class="modal-title" id="myLargeModalLabel" style="text-align:center;"> Precios Materiales (Ultima Vez Comprado) </h4>
   </div> 
   <div class="modal-body" style="min-height:300px;margin-top:-20px;"> 
   	<div class="row">
	   		
	   			<div id="" class="col-md-12" style="max-height:500px;overflow:auto;">
	 			
			    	<table class="table-hover table-bordered tab" style="box-sizing: border-box; width:100%;" >
           <thead >
              <tr >
                <th >FACTURA</th>
                <th >FECHA</th>
                <th >PROVEEDOR</th>
                <th >MATERIAL</th>
                <th >PRECIO</th>
                <th >CANTIDAD</th>
                
                
                
              </tr>
            </thead>
            <tbody>
            <%
            rs3 = st3.executeQuery("select T1.idmaterial, material.nombre as nombrematerial,proveedor.nombre as nombreproveedor,compra.numerofactura as factura, T1.costounitario as preciocompra, T1.cantidad as cantidadmaterial, compra.fecha as fechacompra "
            		+ "from compramaterial T1 "
            		+ "inner join compra on compra.idcompra=T1.idcompra "
            		+ "inner join material on material.idmaterial=T1.idmaterial "
            		+ "inner join proveedor on proveedor.idproveedor=compra.idproveedor "
            		+ "where compra.fecha = (select max(compra.fecha) from material T2 "
            		+ "inner join compramaterial on compramaterial.idmaterial=T2.idmaterial "
            		+ "inner join compra on compra.idcompra=compramaterial.idcompra "
            		+ "where T1.idmaterial= T2.idmaterial ) order by material.nombre");
        	while (rs3.next()) {
        		
        		String precio = String.valueOf(rs3.getDouble("preciocompra"));
				precio=ValidaFormato.formato(precio);
				
				String fecha="";
				fecha = ValidaFormato.cambiarFecha(rs3.getString("fechacompra"), 2);
				
				%>
			<tr>               
				<td style="text-align:center"><%=rs3.getString("factura")%></td>
				<td style="text-align:center"><%=fecha%></td>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;<%=rs3.getString("nombreproveedor")%></td>
                <td>&nbsp;&nbsp;&nbsp;&nbsp;<%=rs3.getString("nombrematerial")%></td>
            	<td style="text-align:right"><%=precio%> Bs &nbsp;&nbsp;&nbsp;</td>
                <td style="text-align:center"><%=rs3.getString("cantidadmaterial")%></td>
                
            </tr>
			
			
			<%	}	
				respuesta.clear();
				if (rs3 != null)
				rs3.close();
				st3.close();
			%>  
            </tbody>
          </table>
			    </div>	
			    	
	   
		   		
   			</div>
   </div>
   
   </div> 
   </div> 
   </div> 
   
    	<!-- FIN DEL MODAL DEL GRAFICO --> 
 
     
     
      <!-- INICIO SCRIPTS DE LAS FUNCIONES DE LOS BOTONES DEL CONTENEDOR -->
     
     <script>
     
     function cargarRegistroCompra(idmaterial){
 		
 		//var separar = idsubetapa.split("/");
 		
 		
 		//alert(idmaterial);
 		
 		 //ENVIO DE DATOS PARA LA CONSULTA Y TRAER LOS MATERIALES ENTREGADOS
 		$.post('./Dashboard',{
 			//VARIALES ENVIADAS PARA GENERAR LA CONSULTA
 			operacion: OPERACION_LISTADO,
 			idmaterial : idmaterial,
 			grafico6 : 1
 		},
 		//FUNCION PARA RECIBIR Y MOSTRAR LOS DATOS OBTENIDOS EN LA CONSULTA
 		function (json){
 			if(json.valido){
 				var valor = json.data;
 				var tabla = '';
 				var titulo = '';
 				var cont = 0;
 				var fechas = new Array();
 				var monto = new Array();
 				var data ='';
 				var cant= new Array();
 				
 				for(var i=0 ; i < valor.length ; i++){
 					cont++;
 					 					
 					var separado = valor[i].toString().split(",");	
 					//alert(separado);
 					//monto.push(separado[6]);
 					if(separado.length>7){
 						tabla += '<tr><td style="text-align:center;"><span style="font-size:14px;">'+separado[1]+'</span></td><td style="text-align:center;font-size:14px">'+separado[2]+'</td><td style="text-align:center; font-size:14px">'+separado[3]+','+separado[4]+'</td><td style="text-align:center; font-size:14px">'+separado[5]+'</td><td style="text-align:center; font-size:14px"><b>'+separado[6]+','+separado[7]+'</b></td></tr>';
 						monto.push(separado[6]);
 						cant.push(separado[5]);
 						//data += "['"+separado[1]+"',"+separado[6]+'.'+separado[7]+"]";
 						
 					}else{
 						tabla += '<tr><td style="text-align:center;"><span style="font-size:14px;">'+separado[1]+'</span></td><td style="text-align:center;font-size:14px">'+separado[2]+'</td><td style="text-align:center; font-size:14px">'+separado[3]+'</td><td style="text-align:center; font-size:14px">'+separado[4]+'</td><td style="text-align:center; font-size:14px"><b>'+separado[5]+','+separado[6]+'</b></td></tr>';
 						monto.push(separado[5]);
 						cant.push(separado[4]);
 						//data += "['"+separado[1]+"',"+separado[5]+'.'+separado[6]+"]";
 						
 					}
 					
 					titulo = 'Registro de Compra de '+separado[0];
 					fechas.push(separado[1]);
 					nombre =separado[0];
 					//monto.push(separado[5]+'.'+separado[6]);
 					//data.push("'"+separado[1]+monto)
 					
 				}
 			
 				if(cont>0){
 					graficogasto(monto,fechas,nombre,cant);
 					$('#registrosPreciosmateriales tbody').html(tabla);
 					$('#tituloregistromateriales').text(titulo);
 				}else{
 					$('#registrosPreciosmateriales tbody').html("<tr><td colspan='3'><center>No existen registros</center></td></tr>");
 				}
 	        }
 		}); 
     }
     
        
 	function graficogasto(mont,fech,nom,cant){  
 		 
 		
 		 var fecha = fech;
 		 var nomb=nom;
 		 var cantidad = parseFloat(cant);
 		 //alert(cant)
 		 
    	 var es =new Array();
    	 var a2= mont.toString().split(",");
    	 var i=0 ;    	 
    	 for(i=0 ; i < a2.length ; i++){    		 
    		 es.push(parseFloat(a2[i].replace(/\./g, '')));    		 
    	 }    	 
    	//alert(es);
    	 
    	 var eso =new Array();
    	 var a3= cant.toString().split(",");
    	 var o=0 ;    	 
    	 for(o=0 ; o < a3.length ; o++){    		 
    		 eso.push(parseFloat(a3[o]));    		 
    	 }    
    	 
    	 //alert(eso);
    	 
     Highcharts.chart('resultado', {
    	    chart: {
    	        type: 'areaspline'
    	    },
    	    title: {
    	        text: 'Relación de Gastos de '+nomb
    	    },
    	    
    	    xAxis: {
    	        categories: fech
    	        	 
    	        
    	    },
    	    yAxis: {
    	        title: {
    	            text: 'Costo'
    	        },
    	        /*labels: {
    	            formatter: function () {
    	                return this.value / 1000 + 'k';
    	            }
    	        }*/
    	    },
    	    tooltip: {
    	        shared: true,
    	        valueSuffix: '',
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
    	    	name: 'Costo Bs', data: es
    	    	},{
    	    	name: 'Cantidad', data: eso
    	    	}]
    	});
     }
     
 	
 	
 	
 	
     </script>
     <!-- FIN DE SCRIPTS DE LAS FUNCIONES DE LOS BOTONES DEL CONTENEDOR -->
     
     
     <%conexion.close(); %>
     