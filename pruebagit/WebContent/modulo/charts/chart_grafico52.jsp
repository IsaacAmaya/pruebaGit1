
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

	//String variable= request.getParameter("variable")==null ? "0":request.getParameter("variable").toString().trim();

	//if(variable == "hola"){
	//	System.out.print("si");

	//}else{
	//	System.out.print("no");
	//}

	ArrayList obras = new ArrayList();
	//String lista =new String();
	//rs = st.executeQuery("select solicitudmaterial.idobra as idobra, obra.nombre as nombreobra from solicitudmaterial inner join obra on obra.idobra=solicitudmaterial.idobra");
	rs = st.executeQuery("select solicitudmaterial.idobra as idobra, obra.nombre as nombreobra, obra.idtipoobra as idtipoobra "
			+ "from solicitudmaterial "
			+ "inner join detalleetapa on detalleetapa.idsubetapa=solicitudmaterial.idsubetapa "
			+ "inner join obra on obra.idobra=solicitudmaterial.idobra "
			+ "inner join etapa on etapa.idetapa=detalleetapa.idetapa group by solicitudmaterial.idobra, obra.nombre , obra.idtipoobra");

	while (rs.next()) {

		obras.add(rs.getString("idobra") + "/" + rs.getString("nombreobra") + "/" + rs.getString("idtipoobra"));
	}
	respuesta.clear();

	//System.out.print(obras);

	if (rs != null)
%>


<!-- ### INICIO DEL CONTENEDOR DEL GRAFICO -->
<div class="orden grafico5">
	<div class="panel panel-default ">
		<div class="panel-heading">
			<ul class="panel-opcion" style="margin-top: -5px;">
				<!--  <li><a href="#" class="abrir" data-toggle="modal" data-target=".charts-grafico5" onclick="cargarExistenciaMaterial();cargarMaterialDespachado();cargarMaterialporDespachar()"><span class="glyphicon glyphicon-fullscreen"></span></a></li>
						-->	</ul>
			<h3 class="panel-title" style="font-size: 18px; width: 400px;">Material Entregado</h3>
		</div>

		<div class="panel panel-body" style="padding: 0px;">
			<div class="chart-holder"
				style="width: 430px; height: 260px; overflow: auto;" id="scrollbar2">
				<div class="panel-group" id="accordion">
					<%
						String[] separarobras;
						Integer contador = 0;
						
						for (int i = 0; i < obras.size(); i++) {
							//System.out.print(String.valueOf(obras.get(i)));
							String nombreobras = String.valueOf(obras.get(i));
							separarobras = nombreobras.split("/");
							//System.out.print(separ[1]);
					%>
					<div class="panel panel-default">
						<div class="panel-heading" data-toggle="collapse"
							data-parent="#accordion" href="#c<%=i%>"
							style="cursor: pointer">
							<h4 class="panel-title">
								<span class=""><%=separarobras[1]%> </span>
							</h4>
						</div>

						<div id="c<%=i%>" class="panel-collapse1 collapse">

							<%
								rs = st.executeQuery(
											"select detalleetapa.idetapa as idetapa, etapa.nombre as nombreetapa from solicitudmaterial inner join detalleetapa on detalleetapa.idsubetapa=solicitudmaterial.idsubetapa inner join obra on obra.idobra=solicitudmaterial.idobra inner join etapa on etapa.idetapa=detalleetapa.idetapa where solicitudmaterial.idobra="
													+ separarobras[0] + " group by detalleetapa.idetapa, etapa.nombre");

									while (rs.next()) {
										contador++;
										//etapas.add(rs.getString("idetapa")+"/"+rs.getString("nombreetapa")+"/"+rs.getString("idetapa")+"/"+rs.getString("nombreetapa"));
							%>
							<a href="#" class="list-group-item"	style="padding: 0px; padding-left: 20px;" onmouseover="this.style.fontWeight='bold';this.style.background='#ccc'" onmouseout="this.style.fontWeight='normal';this.style.background='white'" data-toggle="modal" data-target="#E<%=rs.getString("idetapa") + contador%>"><%=rs.getString("nombreetapa")%></a>
							
							
							<div id="E<%=rs.getString("idetapa") + contador%>" class="modal fade clasematerial" role="dialog">
								<div class="modal-dialog modal-lg">

									<!-- Modal content-->
									<div class="modal-content">
										<div class="modal-header">
											<button type="button" class="close" data-dismiss="modal">&times;</button>
											<h4 class="modal-title" style="text-align:center">
												Material Entregado <%=separarobras[1]%></h4>
												
										</div>
										<div class="modal-body">
											<div class="row">
												
												<div class="col-md-5" style="min-height:300px;">
												<!-- <p><%=rs.getString("idetapa")%><%=rs.getString("nombreetapa")%></p> -->
													<%
													rs2 = st2.executeQuery("select obra.idobra, subetapa.idsubetapa as idsubetapa, obra.idtipoobra as idtipoobra,"
															+ "subetapa.nombre as nombresubetapa, materialporobra.iddetalleetapa as iddetalleetapa "
															+ "from detallesolicitud "
															+ "inner join solicitudmaterial on solicitudmaterial.idsolicitudmaterial=detallesolicitud.idsolicitudmaterial "
															+ "inner join detalleetapa on detalleetapa.idsubetapa=solicitudmaterial.idsubetapa "
															+ "inner join etapa on etapa.idetapa=detalleetapa.idetapa "
															+ "inner join subetapa on subetapa.idsubetapa=detalleetapa.idsubetapa "
															+ "inner join obra on obra.idobra=solicitudmaterial.idobra "
															+ "inner join materialporobra on materialporobra.iddetalleetapa=detalleetapa.iddetalleetapa "
															+ "where obra.idobra="+ separarobras[0] + "and obra.idtipoobra="+ separarobras[2] + "and etapa.idetapa=" + rs.getInt("idetapa")
															+ "group by subetapa.idsubetapa, subetapa.nombre, obra.idobra, obra.idtipoobra, materialporobra.iddetalleetapa");
													Integer cont = 0;
													while (rs2.next()) {
														cont++;
													
													%>	
												
													
														<a class="btn btn-lg btn-default form-control" id="<%=rs2.getString("iddetalleetapa")+"/"+rs2.getString("idobra")+"/"+rs2.getString("idtipoobra")+"/"+rs2.getString("idsubetapa")%>" onclick="cargarMaterialAsignado(this.id)"><%=rs2.getString("nombresubetapa")%></a>
														
																										
													<% }%>
												</div>
												<div class="col-md-7" style="min-height:300px;">
													<table class="table-bordered tab" id="materialEntregado" style="box-sizing: border-box; width: 100%;">

															<thead>
																<tr>
																	<th style="width:40%; font-size:14px;">Material</th>
																	<th style="width:30%; font-size:14px; text-align:center;">Total Entregado</th>
																	<th style="width:30%; font-size:14px; text-align:center;">Cantidad Estimada</th>
																</tr>
															</thead>
															<tbody>
															</tbody>
														</table>
												</div>
													
														
												
											</div>
										</div>
									</div>
								</div>
							</div>
							<%
								}
							%>
						</div>
					</div>
					<%
						}

						respuesta.clear();
						if (rs != null)
						rs.close();
						st.close();
					%>
				</div>
			</div>
		</div>
	</div>


	<!-- ### FIN DEL CONTENEDOR DEL GRAFICO -->

	
<!-- INICIO SCRIPTS DE LAS FUNCIONES DE LOS BOTONES DEL CONTENEDOR -->

<script>
	$(document).ready(function() {
				
		$('.clasematerial').on('hide.bs.modal', function (e) {
			$('#materialEntregado tbody').html("");
	  	});
		
	});

	
	function cargarMaterialAsignado(idsubetapa){
		
		var separar = idsubetapa.split("/");
		
		
		//alert(idsubetapa);
		
		 //ENVIO DE DATOS PARA LA CONSULTA Y TRAER LOS MATERIALES ENTREGADOS
		$.post('./Dashboard',{
			//VARIALES ENVIADAS PARA GENERAR LA CONSULTA
			operacion: OPERACION_LISTADO,
			iddetalleetapa : separar[0],
			idobra : separar[1],
			idtipoobra: separar[2],
			idsubetapa: separar[3],
			grafico5 : 1
		},
		//FUNCION PARA RECIBIR Y MOSTRAR LOS DATOS OBTENIDOS EN LA CONSULTA
		function (json){
			if(json.valido){
				var valor = json.data;
				var tabla = '';
				var cont = 0;
				for(var i=0 ; i < valor.length ; i++){
					cont++;
					var celda ="";
					
					var separado = valor[i].toString().split(",");	
					if (parseInt(separado[1]) > parseInt(separado[2])){
						celda =" color:red;"
					}
					if (parseInt(separado[1]) == parseInt(separado[2])){
						celda =" color:green;"
					}
					
					tabla += '<tr><td style="text-align:center;"><span style="font-size:14px;'+celda+'"><b>'+separado[0]+'</b></span></td><td style="text-align:center;'+celda+';font-size:14px"><b>'+separado[1]+'</b></td><td style="text-align:center;'+celda+'; font-size:14px"><b>'+separado[2]+'</b></td></tr>';
					
				}
			
				if(cont>0){
					
					$('#materialEntregado tbody').html(tabla);
				}else{
					$('#materialEntregado tbody').html("<tr><td colspan='3'><center>No han entregado materiales</center></td></tr>");
				}
	        }
		}); 
	}
	
		
</script>

<!-- FIN DE SCRIPTS DE LAS FUNCIONES DE LOS BOTONES DEL CONTENEDOR -->



