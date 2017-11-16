 package ve.com.proherco.web.modulos;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import ve.com.proherco.web.comun.ConexionWeb;
import ve.com.proherco.web.comun.Constantes;
import ve.com.proherco.web.comun.PermisosModulo;
import ve.com.proherco.web.comun.ValidaFormato;

/**
 * Servlet implementation class Proyecto
 */
@WebServlet("/Dashboard")
public class Dashboard extends HttpServlet implements Constantes {
	private static final long serialVersionUID = 1L;
	JSONObject respuesta = new JSONObject();
	Connection conexion;
	ConexionWeb conWeb = new ConexionWeb();
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Dashboard() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		//variables necesarias en todo servlet
		//----------------------------------------------------------
		response.setContentType("application/json; charset=UTF-8");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();	
										
		//----------------------------------------------------------
		int operacion = request.getParameter("operacion")==null ? 0:(Integer.valueOf(request.getParameter("operacion")));
		try {
			conexion = conWeb.abrirConn();
			Statement st = conexion.createStatement();
			ResultSet rs =null; 
			
			
			
			
			if(operacion==OPERACION_LISTADO) {
				int grafico3 = request.getParameter("grafico3")==null ? 0:(Integer.valueOf(request.getParameter("grafico3")));
				int grafico5 = request.getParameter("grafico5")==null ? 0:(Integer.valueOf(request.getParameter("grafico5")));
				int grafico6 = request.getParameter("grafico6")==null ? 0:(Integer.valueOf(request.getParameter("grafico6")));
				
				JSONArray data = new JSONArray();
				JSONArray data2 = new JSONArray();
				
				if(grafico5 == 1) {
					String iddetalleetapa= request.getParameter("iddetalleetapa").toString().trim();
					String idobra= request.getParameter("idobra").toString().trim();
					String idtipoobra= request.getParameter("idtipoobra").toString().trim();
					String idsubetapa= request.getParameter("idsubetapa").toString().trim();
					
					rs = st.executeQuery("select  detallesolicitud.idmaterial, material.nombre as nombrematerial , sum(detallesolicitud.cantidad) as sumacantidad, solicitudmaterial.idobra, obra.nombre, " 
							+ "materialporobra.cantidadestimada as cantidadestimada, solicitudmaterial.idsubetapa, materialporobra.iddetalleetapa " 
							+ "from detallesolicitud " 
							+ "inner join solicitudmaterial on solicitudmaterial.idsolicitudmaterial=detallesolicitud.idsolicitudmaterial " 
							+ "inner join obra on obra.idobra=solicitudmaterial.idobra " 
							+ "inner join material on material.idmaterial=detallesolicitud.idmaterial " 
							+ "inner join materialporobra on materialporobra.idmaterial=material.idmaterial " 
							+ "inner join tipoobra on tipoobra.idtipoobra=materialporobra.idtipoobra "
							+ "inner join detalleetapa on detalleetapa.idsubetapa=solicitudmaterial.idsubetapa " 
							+ "where tipoobra.idtipoobra="+idtipoobra+ " and solicitudmaterial.idobra="+idobra+" and solicitudmaterial.estatus=1 and materialporobra.iddetalleetapa="+iddetalleetapa+" "
							+ "and solicitudmaterial.idsubetapa="+idsubetapa+" " 
							+ "group by detallesolicitud.idmaterial, material.nombre, solicitudmaterial.idobra, obra.nombre, " 
							+ "solicitudmaterial.idsubetapa, materialporobra.cantidadestimada, materialporobra.iddetalleetapa");
					while (rs.next()) {
						JSONArray p = new JSONArray();
						p.add(rs.getString("nombrematerial"));
						p.add(rs.getString("sumacantidad").trim());
						p.add(rs.getString("cantidadestimada").trim());
						data.add(p);
					}
				}if(grafico6 == 1) {
					String idmaterial= request.getParameter("idmaterial").toString().trim();  
					
					rs = st.executeQuery("select compramaterial.idmaterial, material.nombre as nombrematerial, compra.fecha as fechacompra, proveedor.nombre as nombreproveedor, compra.numerofactura as facturacompra, " 
								+ "compramaterial.cantidad as cantidadmaterial, compramaterial.costounitario as preciounitario, compramaterial.costounitariousd as costo "  
								+ "from compramaterial "  
								+ "inner join compra on compra.idcompra=compramaterial.idcompra "  
								+ "inner join material on material.idmaterial=compramaterial.idmaterial " 
								+ "inner join proveedor on proveedor.idproveedor=compra.idproveedor " 
								+ "where compramaterial.idmaterial="+idmaterial+" order by compra.fecha asc");
					while (rs.next()) {
						JSONArray p = new JSONArray();
						p.add(rs.getString("nombrematerial"));
						//p.add(rs.getString("fechacompra").trim());
						p.add(ValidaFormato.cambiarFecha(rs.getString("fechacompra").trim(), 2));
						p.add(rs.getString("facturacompra").trim());
						p.add(rs.getString("nombreproveedor").trim());
						p.add(rs.getInt("cantidadmaterial"));
						p.add(ValidaFormato.formato(rs.getString("preciounitario")).trim());					
						
						data.add(p);
					}
				}if(grafico3 == 1) {
					String idobra= request.getParameter("idobra").toString().trim();  
					
					rs = st.executeQuery("select etapa.nombre as nombreetapa, etapa.idetapa as idetapa,obra.nombre as nombreobra, inspeccion.idobra as idobra " 
							+ "from inspeccion " 
							+ "inner join detalleetapa on detalleetapa.iddetalleetapa=inspeccion.iddetalleetapa "
							+ "inner join etapa on etapa.idetapa=detalleetapa.idetapa "
							+ "inner join subetapa on subetapa.idsubetapa=detalleetapa.idsubetapa " 
							+ "inner join obra on obra.idobra=inspeccion.idobra "
							+ "where inspeccion.idobra="+idobra+ "group by etapa.nombre, obra.nombre, etapa.idetapa, inspeccion.idobra order by etapa.idetapa asc");
					while (rs.next()) {
						JSONArray p = new JSONArray();
						p.add(rs.getString("idetapa"));
						p.add(rs.getString("nombreetapa").trim());
						p.add(rs.getString("nombreobra").trim());
						p.add(rs.getString("idobra"));
						
						data.add(p);
					}
				}if(grafico3 == 2) {
					String idetapa= request.getParameter("idetapa").toString().trim();
					String idobra= request.getParameter("idobra").toString().trim(); 
					
					rs = st.executeQuery("select subetapa.idsubetapa,obra.idobra as idobra, etapa.idetapa as idetapa, subetapa.nombre as nombresubetapa, sum(inspeccion.porcentaje) as porcentajesubetapa "
							+ "from inspeccion "
							+ "inner join detalleetapa on detalleetapa.iddetalleetapa=inspeccion.iddetalleetapa "
							+ "inner join etapa on etapa.idetapa=detalleetapa.idetapa "
							+ "inner join subetapa on subetapa.idsubetapa=detalleetapa.idsubetapa "
							+ "inner join obra on obra.idobra=inspeccion.idobra "
							+ "where detalleetapa.idetapa="+idetapa+" and inspeccion.idobra="+idobra+ "group by subetapa.idsubetapa,obra.idobra,etapa.idetapa, subetapa.nombre order by subetapa.idsubetapa asc");
					while (rs.next()) {
						JSONArray p = new JSONArray();
						p.add(rs.getString("idobra"));
						p.add(rs.getString("idetapa"));
						p.add(rs.getString("idsubetapa"));
						p.add(rs.getString("nombresubetapa").trim());
						p.add(rs.getString("porcentajesubetapa").trim());
						
						data.add(p);
					}
				}if(grafico3 == 3) {
					String idobra= request.getParameter("idobra").toString().trim();
					String idetapa= request.getParameter("idetapa").toString().trim();
					String idsube= request.getParameter("idsube").toString().trim();
					
					rs = st.executeQuery("select inspeccion.fechainspeccion as fechainspeccion, etapa.idetapa, subetapa.idsubetapa,  subetapa.nombre as nombresubetapa, "
							+ "cuadrilla.nombre as nombrecuadrilla, inspeccion.porcentaje as porcentxinspeccion, inspeccion.observacion as observacion "
							+ "from inspeccion "
							+ "inner join detalleetapa on detalleetapa.iddetalleetapa=inspeccion.iddetalleetapa " 
							+ "inner join etapa on etapa.idetapa=detalleetapa.idetapa "
							+ "inner join subetapa on subetapa.idsubetapa=detalleetapa.idsubetapa " 
							+ "inner join obra on obra.idobra=inspeccion.idobra "
							+ "inner join cuadrilla on cuadrilla.idcuadrilla=inspeccion.idcuadrilla " 
							+ "where inspeccion.idobra="+idobra+ " and etapa.idetapa="+idetapa+" and subetapa.idsubetapa="+idsube+" order by inspeccion.fechainspeccion asc");
					while (rs.next()) {
						JSONArray p = new JSONArray();
						p.add(rs.getString("nombresubetapa").trim());
						p.add(rs.getString("fechainspeccion"));
						p.add(rs.getString("nombrecuadrilla").trim());
						p.add(rs.getString("observacion").trim());
						p.add(rs.getDouble("porcentxinspeccion"));
						
						
						data.add(p);
					}
				}if(grafico3 == 4) {
					String idobrar= request.getParameter("idobrar").toString().trim();
									
					rs = st.executeQuery("select tabla1.*, tabla2.sumaestimado from (select material.categoria as categoria,obra.idobra as idobra, obra.nombre as nombreobra, " 
							+ "detallesolicitud.idmaterial, material.nombre as nombrematerial, sum(detallesolicitud.cantidad) as totalmaterial " 
							+ "from detallesolicitud "
							+ "inner join solicitudmaterial on solicitudmaterial.idsolicitudmaterial=detallesolicitud.idsolicitudmaterial " 
							+ "inner join material on material.idmaterial=detallesolicitud.idmaterial "
							+ "inner join obra on obra.idobra=solicitudmaterial.idobra "
							+ "where solicitudmaterial.idobra="+idobrar+" and solicitudmaterial.estatus=1"
							+ "group by solicitudmaterial.idobra,obra.idobra,obra.nombre,detallesolicitud.idmaterial,material.nombre, obra.idtipoobra,material.categoria) as tabla1 left join " 
							+ "(select materialporobra.idmaterial, material.nombre,materialporobra.idtipoobra, "
							+ "tipoobra.nombre, sum(materialporobra.cantidadestimada) as sumaestimado "
							+ "from materialporobra "
							+ "inner join material on material.idmaterial=materialporobra.idmaterial " 
							+ "inner join detalleetapa on detalleetapa.iddetalleetapa=materialporobra.iddetalleetapa "
							+ "inner join tipoobra on tipoobra.idtipoobra=materialporobra.idtipoobra "
							+ "inner join obra on obra.idtipoobra=tipoobra.idtipoobra "
							+ "where obra.idobra="+idobrar+" "
							+ "group by materialporobra.idmaterial, material.nombre, materialporobra.idtipoobra, "
							+ "tipoobra.nombre) as tabla2 on tabla1.idmaterial=tabla2.idmaterial");
					while (rs.next()) {
						JSONArray p = new JSONArray();
						p.add(rs.getString("nombreobra").trim());
						p.add(rs.getString("nombrematerial").trim());
						p.add(rs.getString("categoria").trim());
						p.add(rs.getString("totalmaterial"));
						p.add(rs.getString("idobra"));
						p.add(rs.getInt("sumaestimado"));
						data.add(p);
					}
				}if(grafico3 == 5) {
					String idobra= request.getParameter("idobra").toString().trim();
									
					rs = st.executeQuery("select solicitudmaterial.idobra as idobra, solicitudmaterial.idsubetapa as idsubetapa, subetapa.nombre as nombresubetapa "
							+ "from solicitudmaterial "
							+ "inner join subetapa on subetapa.idsubetapa=solicitudmaterial.idsubetapa " 
							+ "where solicitudmaterial.idobra="+idobra+" and solicitudmaterial.estatus=1" 
							+ "group by solicitudmaterial.idobra, solicitudmaterial.idsubetapa, subetapa.nombre ");
					while (rs.next()) {
						JSONArray p = new JSONArray();
						p.add(rs.getString("idsubetapa").trim());
						p.add(rs.getString("idobra").trim());
						p.add(rs.getString("nombresubetapa").trim());
						
						data.add(p);
					}
				}if(grafico3 == 6) {
					String idobra= request.getParameter("idobra").toString().trim();
					String idsubetapa= request.getParameter("idsubetapa").toString().trim();
									
					rs = st.executeQuery("select tabla1.*, tabla2.estimada from (select solicitudmaterial.idobra, solicitudmaterial.idsubetapa, subetapa.nombre, detallesolicitud.idmaterial,material.nombre as nombrematerial,material.categoria as categoria, " 
							+ "sum(detallesolicitud.cantidad)  as sumamateriales " 
							+ "from solicitudmaterial "
							+ "inner join subetapa on subetapa.idsubetapa=solicitudmaterial.idsubetapa " 
							+ "inner join detallesolicitud on detallesolicitud.idsolicitudmaterial=solicitudmaterial.idsolicitudmaterial "
							+ "inner join material on material.idmaterial=detallesolicitud.idmaterial "
							+ "where solicitudmaterial.idobra="+idobra+" and solicitudmaterial.idsubetapa="+idsubetapa+" and solicitudmaterial.estatus=1 " 
							+ "group by solicitudmaterial.idobra, solicitudmaterial.idsubetapa, subetapa.nombre, detallesolicitud.idmaterial,material.nombre, material.categoria) as tabla1 left join " 
							+ "(select materialporobra.idmaterial, material.nombre,materialporobra.idtipoobra, "
							+ "tipoobra.nombre, sum(materialporobra.cantidadestimada) as estimada "
							+ "from materialporobra "
							+ "inner join material on material.idmaterial=materialporobra.idmaterial "
							+ "inner join detalleetapa on detalleetapa.iddetalleetapa=materialporobra.iddetalleetapa "
							+ "inner join subetapa on subetapa.idsubetapa=detalleetapa.idsubetapa "
							+ "inner join tipoobra on tipoobra.idtipoobra=materialporobra.idtipoobra " 
							+ "inner join obra on obra.idtipoobra=tipoobra.idtipoobra "
							+ "where obra.idobra="+idobra+" and subetapa.idsubetapa="+idsubetapa+" "
							+ "group by materialporobra.idmaterial, material.nombre, materialporobra.idtipoobra, " 
							+ "tipoobra.nombre) as tabla2 on tabla1.idmaterial=tabla2.idmaterial");
					while (rs.next()) {
						JSONArray p = new JSONArray();
						p.add(rs.getString("nombrematerial").trim());
						p.add(rs.getString("categoria").trim());
						p.add(rs.getString("sumamateriales"));
						p.add(rs.getString("estimada"));
						
						data.add(p);
					}
				}if(grafico3 == 7) {
					String idobra= request.getParameter("idobra").toString().trim();
									
					rs = st.executeQuery("select tabla1.*, tabla2.sumaestimado from (select material.categoria as categoria,obra.idobra as idobra, obra.nombre as nombreobra, " 
							+ "detallesolicitud.idmaterial, material.nombre as nombrematerial, sum(detallesolicitud.cantidad) as totalmaterial " 
							+ "from detallesolicitud "
							+ "inner join solicitudmaterial on solicitudmaterial.idsolicitudmaterial=detallesolicitud.idsolicitudmaterial " 
							+ "inner join material on material.idmaterial=detallesolicitud.idmaterial "
							+ "inner join obra on obra.idobra=solicitudmaterial.idobra "
							+ "where solicitudmaterial.idobra="+idobra+" and solicitudmaterial.estatus=0"
							+ "group by solicitudmaterial.idobra,obra.idobra,obra.nombre,detallesolicitud.idmaterial,material.nombre, obra.idtipoobra,material.categoria) as tabla1 left join " 
							+ "(select materialporobra.idmaterial, material.nombre,materialporobra.idtipoobra, "
							+ "tipoobra.nombre, sum(materialporobra.cantidadestimada) as sumaestimado "
							+ "from materialporobra "
							+ "inner join material on material.idmaterial=materialporobra.idmaterial " 
							+ "inner join detalleetapa on detalleetapa.iddetalleetapa=materialporobra.iddetalleetapa "
							+ "inner join tipoobra on tipoobra.idtipoobra=materialporobra.idtipoobra "
							+ "inner join obra on obra.idtipoobra=tipoobra.idtipoobra "
							+ "where obra.idobra="+idobra+" "
							+ "group by materialporobra.idmaterial, material.nombre, materialporobra.idtipoobra, "
							+ "tipoobra.nombre) as tabla2 on tabla1.idmaterial=tabla2.idmaterial");
					while (rs.next()) {
						JSONArray p = new JSONArray();
						p.add(rs.getString("nombreobra").trim());
						p.add(rs.getString("nombrematerial").trim());
						p.add(rs.getString("categoria").trim());
						p.add(rs.getString("totalmaterial"));
						p.add(rs.getString("idobra"));
						p.add(rs.getInt("sumaestimado"));
						data.add(p);
					}
				}if(grafico3 == 8) {
					String idobra= request.getParameter("idobra").toString().trim();
									
					rs = st.executeQuery("select solicitudmaterial.idobra as idobra, solicitudmaterial.idsubetapa as idsubetapa, subetapa.nombre as nombresubetapa "
							+ "from solicitudmaterial "
							+ "inner join subetapa on subetapa.idsubetapa=solicitudmaterial.idsubetapa " 
							+ "where solicitudmaterial.idobra="+idobra+" and solicitudmaterial.estatus=0" 
							+ "group by solicitudmaterial.idobra, solicitudmaterial.idsubetapa, subetapa.nombre ");
					while (rs.next()) {
						JSONArray p = new JSONArray();
						p.add(rs.getString("idsubetapa").trim());
						p.add(rs.getString("idobra").trim());
						p.add(rs.getString("nombresubetapa").trim());
						
						data.add(p);
					}
				}if(grafico3 == 9) {
					String idobra1= request.getParameter("idobra1").toString().trim();
					String idsubetapa1= request.getParameter("idsubetapa1").toString().trim();
									
					rs = st.executeQuery("select tabla1.*, tabla2.estimada from (select solicitudmaterial.idobra, solicitudmaterial.idsubetapa, subetapa.nombre, detallesolicitud.idmaterial,material.nombre as nombrematerial,material.categoria as categoria, " 
							+ "sum(detallesolicitud.cantidad)  as sumamateriales " 
							+ "from solicitudmaterial "
							+ "inner join subetapa on subetapa.idsubetapa=solicitudmaterial.idsubetapa " 
							+ "inner join detallesolicitud on detallesolicitud.idsolicitudmaterial=solicitudmaterial.idsolicitudmaterial "
							+ "inner join material on material.idmaterial=detallesolicitud.idmaterial "
							+ "where solicitudmaterial.idobra="+idobra1+" and solicitudmaterial.idsubetapa="+idsubetapa1+" and solicitudmaterial.estatus=0 " 
							+ "group by solicitudmaterial.idobra, solicitudmaterial.idsubetapa, subetapa.nombre, detallesolicitud.idmaterial,material.nombre, material.categoria) as tabla1 left join " 
							+ "(select materialporobra.idmaterial, material.nombre,materialporobra.idtipoobra, "
							+ "tipoobra.nombre, sum(materialporobra.cantidadestimada) as estimada "
							+ "from materialporobra "
							+ "inner join material on material.idmaterial=materialporobra.idmaterial "
							+ "inner join detalleetapa on detalleetapa.iddetalleetapa=materialporobra.iddetalleetapa "
							+ "inner join subetapa on subetapa.idsubetapa=detalleetapa.idsubetapa "
							+ "inner join tipoobra on tipoobra.idtipoobra=materialporobra.idtipoobra " 
							+ "inner join obra on obra.idtipoobra=tipoobra.idtipoobra "
							+ "where obra.idobra="+idobra1+" and subetapa.idsubetapa="+idsubetapa1+" "
							+ "group by materialporobra.idmaterial, material.nombre, materialporobra.idtipoobra, " 
							+ "tipoobra.nombre) as tabla2 on tabla1.idmaterial=tabla2.idmaterial");
					while (rs.next()) {
						JSONArray p = new JSONArray();
						p.add(rs.getString("nombrematerial").trim());
						p.add(rs.getString("categoria").trim());
						p.add(rs.getString("sumamateriales"));
						p.add(rs.getString("estimada"));
						
						data.add(p);
					}
				}if(grafico3 ==10) {
					String idobra= request.getParameter("idobra").toString().trim();
									
					rs = st.executeQuery("select inspeccion.fechainspeccion as fechainspeccion, etapa.idetapa, subetapa.idsubetapa,  subetapa.nombre as nombresubetapa, "
							+ "cuadrilla.nombre as nombrecuadrilla, inspeccion.porcentaje as porcentxinspeccion,inspeccion.porcentajegeneral as porcen, inspeccion.observacion as observacion "
							+ "from inspeccion "
							+ "inner join detalleetapa on detalleetapa.iddetalleetapa=inspeccion.iddetalleetapa "
							+ "inner join etapa on etapa.idetapa=detalleetapa.idetapa "
							+ "inner join subetapa on subetapa.idsubetapa=detalleetapa.idsubetapa "
							+ "inner join obra on obra.idobra=inspeccion.idobra "
							+ "inner join cuadrilla on cuadrilla.idcuadrilla=inspeccion.idcuadrilla " 
							+ "where inspeccion.idobra="+idobra+" order by inspeccion.fechainspeccion asc");
					while (rs.next()) {
						JSONArray p = new JSONArray();
						
						p.add(rs.getString("fechainspeccion"));
						p.add(rs.getString("nombresubetapa").trim());
						p.add(rs.getString("observacion").trim());
						p.add(rs.getDouble("porcentxinspeccion"));
						p.add(rs.getDouble("porcen"));
						data.add(p);
					}
				}if(grafico3 ==11) {
					String idobra= request.getParameter("idobra").toString().trim();
									
					rs = st.executeQuery("select subetapa.nombre as nombresubetapa, subetapa.idsubetapa as idsubetapa, inspeccion.idobra as idobra, sum(inspeccion.porcentaje) as porcentajesubetapa " 
							+ "from inspeccion "
							+ "inner join detalleetapa on detalleetapa.iddetalleetapa=inspeccion.iddetalleetapa "
							+ "inner join subetapa on subetapa.idsubetapa=detalleetapa.idsubetapa "
							+ "where inspeccion.idobra="+idobra+" "
							+ "group by subetapa.nombre, subetapa.idsubetapa, inspeccion.idobra order by subetapa.idsubetapa asc");
					while (rs.next()) {
						JSONArray p = new JSONArray();
						p.add(rs.getString("idsubetapa"));
						p.add(rs.getString("idobra"));
						p.add(rs.getString("nombresubetapa"));
						p.add(rs.getString("porcentajesubetapa"));
						data.add(p);
						
						}
				}if(grafico3 == 12) {
					String idobra= request.getParameter("idobra").toString().trim();
					String idsubetapa= request.getParameter("idsubetapa").toString().trim();
									
					rs = st.executeQuery("select subetapa.nombre, subetapa.idsubetapa, inspeccion.idobra as idobra, inspeccion.fechainspeccion as fechainspeccion,  "
							+ "cuadrilla.nombre as nombrecuadrilla, inspeccion.observacion as observacion, inspeccion.porcentaje as porcenta, inspeccion.porcentajegeneral as porcent "
							+ "from inspeccion "
							+ "inner join detalleetapa on detalleetapa.iddetalleetapa=inspeccion.iddetalleetapa "
							+ "inner join subetapa on subetapa.idsubetapa=detalleetapa.idsubetapa " 
							+ "inner join cuadrilla on cuadrilla.idcuadrilla=inspeccion.idcuadrilla "
							+ "where inspeccion.idobra="+idobra+" and subetapa.idsubetapa="+idsubetapa+" "
							+ "order by inspeccion.fechainspeccion asc");
					while (rs.next()) {
						JSONArray p = new JSONArray();
						p.add(rs.getString("fechainspeccion"));
						p.add(rs.getString("nombrecuadrilla").trim());
						p.add(rs.getString("observacion").trim());
						p.add(rs.getDouble("porcenta"));
						p.add(rs.getDouble("porcent"));
						
						data.add(p);
					}
				}if(grafico3 == 13) {
					String idobra= request.getParameter("idobra").toString().trim();
					
									
					rs = st.executeQuery("select inspeccion.idobra as idobra, obra.nombre as nombreobra, obra.idtipoobra as tipoobra, "
							+ "sum(inspeccion.porcentaje*detalleetapa.porcentaje/100*etapa.porcentaje/100) as porcentajefinal "
							+ "from inspeccion " 
							+ "inner join detalleetapa on detalleetapa.iddetalleetapa=inspeccion.iddetalleetapa "
							+ "inner join obra on obra.idobra=inspeccion.idobra "
							+ "inner join etapa on etapa.idetapa=detalleetapa.idetapa " 
							+ "inner join subetapa on subetapa.idsubetapa=detalleetapa.idsubetapa " 
							+ "where inspeccion.idobra="+idobra+" group by inspeccion.idobra, obra.nombre, obra.idtipoobra " 
							+ "order by obra.nombre asc");
					while (rs.next()) {
						JSONArray p = new JSONArray();
						p.add(rs.getString("idobra"));
						p.add(rs.getString("nombreobra").trim());
						p.add(rs.getDouble("porcentajefinal"));
						p.add(rs.getString("tipoobra").trim());
						data.add(p);
					}
				}if(grafico3 == 14) {
					String idtipoobra= request.getParameter("idtipoobra").toString().trim();
					
									
					rs = st.executeQuery("select materialporobra.idtipoobra as idtipoobra, tipoobra.nombre as nombretipo, etapa.idetapa as idetapa, etapa.nombre as nombreetapa "
							+ "from materialporobra " 
							+ "inner join tipoobra on tipoobra.idtipoobra=materialporobra.idtipoobra "
							+ "inner join detalleetapa on detalleetapa.iddetalleetapa=materialporobra.iddetalleetapa " 
							+ "inner join etapa on etapa.idetapa=detalleetapa.idetapa "
							+ "where materialporobra.idtipoobra="+idtipoobra+" group by materialporobra.idtipoobra, tipoobra.nombre, etapa.idetapa, etapa.nombre");
					while (rs.next()) {
						JSONArray p = new JSONArray();
						p.add(rs.getString("nombreetapa"));
						p.add(rs.getString("idetapa"));
						p.add(rs.getString("idtipoobra"));
						p.add(rs.getString("nombretipo"));
						data.add(p);
					}
				}if(grafico3 == 15) {
					String idtipoobra= request.getParameter("idtipoobra").toString().trim();
					String idetapa= request.getParameter("idetapa").toString().trim();
									
					rs = st.executeQuery("select materialporobra.idtipoobra as idtipoobra, tipoobra.nombre, etapa.idetapa as idetapa, etapa.nombre, "
							+ "subetapa.idsubetapa as idsubetapa,subetapa.nombre as nombresubetapa "
							+ "from materialporobra "
							+ "inner join tipoobra on tipoobra.idtipoobra=materialporobra.idtipoobra "
							+ "inner join detalleetapa on detalleetapa.iddetalleetapa=materialporobra.iddetalleetapa "
							+ "inner join etapa on etapa.idetapa=detalleetapa.idetapa "
							+ "inner join subetapa on subetapa.idsubetapa=detalleetapa.idsubetapa " 
							+ "where materialporobra.idtipoobra="+idtipoobra+" and etapa.idetapa="+idetapa+" group by materialporobra.idtipoobra, tipoobra.nombre, etapa.idetapa, etapa.nombre, " 
							+ "subetapa.idsubetapa,subetapa.nombre");
					while (rs.next()) {
						JSONArray p = new JSONArray();
						p.add(rs.getString("nombresubetapa"));
						p.add(rs.getString("idsubetapa"));
						p.add(rs.getString("idetapa"));
						p.add(rs.getString("idtipoobra"));
						data.add(p);
					}
				}if(grafico3 == 16) {
					String idtipoobra= request.getParameter("idtipoobra").toString().trim();
					String idetapa= request.getParameter("idetapa").toString().trim();
									
					rs = st.executeQuery("select etapa.idetapa,etapa.nombre as nombreetapa, materialporobra.idmaterial, material.nombre as nombrematerial, "
							+ "sum(materialporobra.cantidadestimada) as cantidadtotal "
							+ "from materialporobra " 
							+ "inner join material on material.idmaterial=materialporobra.idmaterial "
							+ "inner join detalleetapa on detalleetapa.iddetalleetapa=materialporobra.iddetalleetapa "
							+ "inner join etapa on etapa.idetapa=detalleetapa.idetapa "
							+ "inner join subetapa on subetapa.idsubetapa=detalleetapa.idsubetapa " 
							+ "where etapa.idetapa="+idetapa+"and materialporobra.idtipoobra="+idtipoobra+" "
							+ "group by etapa.idetapa,etapa.nombre, materialporobra.idmaterial, material.nombre");
					while (rs.next()) {
						JSONArray p = new JSONArray();
						p.add(rs.getString("nombrematerial"));
						p.add(rs.getString("cantidadtotal"));
						p.add(rs.getString("nombreetapa"));
						data.add(p);
					}
				}if(grafico3 == 17) {
					String idtipoobra= request.getParameter("idtipoobra").toString().trim();
					String idetapa= request.getParameter("idetapa").toString().trim();
					String idsubetapa= request.getParameter("idsubetapa").toString().trim();
									
					rs = st.executeQuery("select etapa.idetapa,etapa.nombre, subetapa.idsubetapa, subetapa.nombre as nombresubetapa, materialporobra.idmaterial, material.nombre as nombrematerial, materialporobra.cantidadestimada as cantidad " 
							+ "from materialporobra "
							+ "inner join material on material.idmaterial=materialporobra.idmaterial "
							+ "inner join detalleetapa on detalleetapa.iddetalleetapa=materialporobra.iddetalleetapa " 
							+ "inner join etapa on etapa.idetapa=detalleetapa.idetapa "
							+ "inner join subetapa on subetapa.idsubetapa=detalleetapa.idsubetapa "
							+ "where etapa.idetapa="+idetapa+" and materialporobra.idtipoobra="+idtipoobra+" and subetapa.idsubetapa="+idsubetapa);
					while (rs.next()) {
						JSONArray p = new JSONArray();
						p.add(rs.getString("nombrematerial"));
						p.add(rs.getString("cantidad"));
						p.add(rs.getString("nombresubetapa"));
						data.add(p);
					}
				}if(grafico3 == 18) {
					String idtipoobra= request.getParameter("idtipoobra").toString().trim();
					
									
					rs = st.executeQuery("select materialporobra.idmaterial, material.nombre as nombrematerial,sum(materialporobra.cantidadestimada) as cantidadtotal "
							+ "from materialporobra "
							+ "inner join material on material.idmaterial=materialporobra.idmaterial "
							+ "inner join detalleetapa on detalleetapa.iddetalleetapa=materialporobra.iddetalleetapa " 
							+ "inner join etapa on etapa.idetapa=detalleetapa.idetapa "
							+ "inner join subetapa on subetapa.idsubetapa=detalleetapa.idsubetapa " 
							+ "where materialporobra.idtipoobra="+idtipoobra+" "
							+ "group by  materialporobra.idmaterial, material.nombre");
					while (rs.next()) {
						JSONArray p = new JSONArray();
						p.add(rs.getString("nombrematerial"));
						p.add(rs.getString("cantidadtotal"));
						data.add(p);
					}
				}
			
				
				
				
				
				
				
				
				
				
				
					
				respuesta.clear();
				respuesta.put("valido", true);
				respuesta.put("data", data);
				
			}else if(operacion==OPERACION_INCLUIR){
					String precios= request.getParameter("precios")==null ? "0":request.getParameter("precios").toString().trim();
					precios = precios.replace(".", "").replace(",", ".");
					String fecha= request.getParameter("fecha")==null ? "0":request.getParameter("fecha").toString().trim();
					//System.out.print(precios+" "+fecha);
					rs = st.executeQuery("SELECT * FROM dolartoday where valor = "+precios+" and fecha='"+fecha+"'");
					
					respuesta.clear();
					if(rs.next()) {
						String cade = " UPDATE dolartoday set valor="+precios+" where fecha='"+fecha+"'";
						//System.out.print(cade);
					st.execute(cade);
						
					}else {
						String cade = "INSERT INTO dolartoday(valor,fecha) VALUES("+precios+",'"+fecha+"')";
						st.execute(cade);
						//System.out.print(cade);
					}
													
					respuesta.put("valido", true);
					respuesta.put("preciow",precios);
					
				}	
				
				
			else if(operacion==OPERACION_CONSULTAR){
				int condicion = request.getParameter("condicion")==null ? 0:(Integer.valueOf(request.getParameter("condicion")));
				
				if (condicion==1) {
					String idmaterial= request.getParameter("idmaterial").toString().trim();
					rs = st.executeQuery("select detallesolicitud.idmaterial, solicitudmaterial.estatus, sum(detallesolicitud.cantidad) as despachado "
							+ "from detallesolicitud " 
							+ "inner join solicitudmaterial on solicitudmaterial.idsolicitudmaterial=detallesolicitud.idsolicitudmaterial " 
							+ "where solicitudmaterial.estatus=1 and idmaterial="+idmaterial+" " 
							+ "group by detallesolicitud.idmaterial, solicitudmaterial.estatus");
					respuesta.clear();
					if(rs.next()) {
						
						respuesta.put("valido", true);
						respuesta.put("despacho", rs.getInt("despachado"));
					}else {
						respuesta.put("valido", true);
						respuesta.put("despacho", "N");
					}
				} if(condicion==2) {
					String idmaterial= request.getParameter("idmaterial").toString().trim();
					rs = st.executeQuery("select detallesolicitud.idmaterial, solicitudmaterial.estatus, sum(detallesolicitud.cantidad) as pordes "
							+ "from detallesolicitud " 
							+ "inner join solicitudmaterial on solicitudmaterial.idsolicitudmaterial=detallesolicitud.idsolicitudmaterial " 
							+ "where solicitudmaterial.estatus=0 and idmaterial="+idmaterial+" " 
							+ "group by detallesolicitud.idmaterial, solicitudmaterial.estatus");
					respuesta.clear();
					if(rs.next()) {
						
						respuesta.put("valido", true);
						respuesta.put("pordespachar", rs.getInt("pordes"));
					}else {
						respuesta.put("valido", true);
						respuesta.put("pordespachar", "P");
					}
					
					
					
				}
			}
			
			if(rs!=null) rs.close();
			st.close();
			
			
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			respuesta.clear();
			respuesta.put("valido", false);
			respuesta.put("msj", "Error interno en el servidor.");			
		}
		//cerrar las conexiones------------------------
		try {
			if(!conexion.isClosed()) {
				////conexion.commit();
				conexion.close();
			}		
		} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
		}
		//-----------------------------------------------		
		
		//al final del metodo doGet debe ir la respuesta
		//-----------------------------
		
		
		
		out.print(respuesta);
		out.flush();
		//-----------------------------
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
