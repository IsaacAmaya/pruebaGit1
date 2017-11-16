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

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import ve.com.proherco.web.comun.ConexionWeb;
import ve.com.proherco.web.comun.Constantes;
import ve.com.proherco.web.comun.ValidaFormato;

/**
 * Servlet implementation class Inspeccion
 */
@WebServlet("/Inspeccion")
public class Inspeccion extends HttpServlet implements Constantes {
	private static final long serialVersionUID = 1L;
	JSONObject respuesta = new JSONObject();
	Connection conexion;
	ConexionWeb conWeb = new ConexionWeb();
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Inspeccion() {
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
				String idproyecto= request.getParameter("idproyecto")==null ? "0":request.getParameter("idproyecto").toString().trim();
				String iddetalleetapa= request.getParameter("iddetalleetapa")==null ? "0":request.getParameter("iddetalleetapa").toString().trim();
				String idobra= request.getParameter("idobra")==null ? "0":request.getParameter("idobra").toString().trim();
				String idetapa= request.getParameter("idetapa")==null ? "0":request.getParameter("idetapa").toString().trim();
				int listadoPrincipal = request.getParameter("listadoPrincipal")==null ? 0:(Integer.valueOf(request.getParameter("listadoPrincipal")));
				int filtradoInspeccion = request.getParameter("filtradoInspeccion")==null ? 0:(Integer.valueOf(request.getParameter("filtradoInspeccion")));
				int porcentajeAux = 0;
				JSONArray data = new JSONArray();			
				
				if(listadoPrincipal == 1) {
					rs = st.executeQuery("select inspeccion.idinspeccion, obra.nombre as nombreobra, etapa.nombre as nombreetapa, subetapa.nombre as nombresubetapa, " + 
							"inspeccion.porcentaje, inspeccion.fechainspeccion  from inspeccion inner join obra on " + 
							"obra.idobra=inspeccion.idobra inner join detalleetapa on detalleetapa.iddetalleetapa=inspeccion.iddetalleetapa inner join " + 
							"etapa on etapa.idetapa=detalleetapa.idetapa inner join subetapa on subetapa.idsubetapa=detalleetapa.idsubetapa order by " + 
							"inspeccion.idinspeccion desc");
					while (rs.next()) {
							JSONArray p = new JSONArray();
							p.add(rs.getLong("idinspeccion"));							
							p.add(rs.getString("nombreobra"));
							p.add(rs.getString("nombreetapa"));
							p.add(rs.getString("nombresubetapa"));
							p.add(ValidaFormato.cambiarFecha(rs.getString("fechainspeccion").trim(), 2));
							p.add(rs.getInt("porcentaje")+"%");
							
							data.add(p);
					}
				}else if(filtradoInspeccion == 1){
					Integer idProyecto = request.getParameter("Proyecto")=="0" ? 0:(Integer.valueOf(request.getParameter("Proyecto")));
					Integer idObra = request.getParameter("Obra")=="0" ? 0:(Integer.valueOf(request.getParameter("Obra")));
					Integer idEtapa = request.getParameter("Etapa")=="0" ? 0:(Integer.valueOf(request.getParameter("Etapa")));				
					
					String Proyecto = "true";
					String Obra = "";
					String Etapa = "";
					if(idProyecto == 0 && request.getParameter("app")==null) {
						rs = st.executeQuery("SELECT max(idproyecto) as idproyecto FROM proyecto");						
						while(rs.next()) {
							idProyecto = rs.getInt("idproyecto");
						}						
					}
					
					if(idProyecto != 0) {
						Proyecto = "inspeccion.idproyecto="+idProyecto;
					}
					
					if(idObra != 0) {
						Obra = " and inspeccion.idobra="+idObra;
						//System.out.print(Obra);
					}
					
					if(idEtapa != 0) {
						Etapa = " and detalleetapa.idetapa="+idEtapa;
						//System.out.print(Etapa);
					}
					//System.out.print(Obra+Etapa);
					rs = st.executeQuery("select inspeccion.idinspeccion"
										+ ", obra.nombre as nombreobra"
										+ ", etapa.nombre as nombreetapa"
										+ ", subetapa.nombre as nombresubetapa"
										+ ", inspeccion.porcentaje"
										+ ", inspeccion.fechainspeccion "
										+ ", proyecto.nombre as nombreproyecto "
										+ " from inspeccion "
										+ "inner join obra on obra.idobra=inspeccion.idobra "
										+ "inner join detalleetapa on detalleetapa.iddetalleetapa=inspeccion.iddetalleetapa "
										+ "inner join etapa on etapa.idetapa=detalleetapa.idetapa "
										+ "inner join subetapa on subetapa.idsubetapa=detalleetapa.idsubetapa "
										+ "left join proyecto on inspeccion.idproyecto=proyecto.idproyecto "
										+ "where "+Proyecto+Obra+Etapa+
							" order by inspeccion.idinspeccion");
					while (rs.next()) {
							JSONArray p = new JSONArray();
							p.add(rs.getLong("idinspeccion"));
							p.add(rs.getString("nombreobra"));
							p.add(rs.getString("nombreetapa"));
							p.add(rs.getString("nombresubetapa"));
							p.add(ValidaFormato.cambiarFecha(rs.getString("fechainspeccion").trim(), 2));
							p.add(rs.getInt("porcentaje")+"%");
							if(request.getParameter("app")!=null) {
								p.add(rs.getString("nombreproyecto"));
							}
							data.add(p);
					}
					//System.out.print(idProyecto+" "+idObra+" "+idEtapa);
				}else{
					
					rs = st.executeQuery("select * from inspeccion inner join detalleetapa on detalleetapa.iddetalleetapa=inspeccion.iddetalleetapa " + 
							"inner join subetapa on subetapa.idsubetapa=detalleetapa.idsubetapa where idproyecto="+idproyecto+" and idobra="+idobra+" and "+
							"inspeccion.iddetalleetapa="+iddetalleetapa);
					while (rs.next()) {
							porcentajeAux += rs.getInt("porcentaje");
							JSONArray p = new JSONArray();
							p.add(ValidaFormato.cambiarFecha(rs.getString("fechainspeccion").trim(), 2));
							p.add(rs.getInt("porcentaje"));
							p.add(rs.getString("observacion"));
							p.add(rs.getInt("estatus"));
							p.add(porcentajeAux);
							data.add(p);
					}
				}
				
						
				respuesta.clear();
				respuesta.put("valido", true);
				respuesta.put("data", data);
				
			}else if(operacion==OPERACION_INCLUIR){
				
				String idobra= request.getParameter("idobra").toString().trim();
				String iddetalleetapa= request.getParameter("iddetalleetapa").toString().trim();
				String idproyecto= request.getParameter("idproyecto").toString().trim();
				String progreso= request.getParameter("progreso").toString().trim();
				String idcuadrilla= request.getParameter("idcuadrilla").toString().trim();
				String fecha= request.getParameter("fecha").toString().trim();
				String observacion= request.getParameter("observacion").toString().trim();
				Integer estatus = 1;
				Integer progresogeneral = Integer.valueOf(progreso);
				rs = st.executeQuery("SELECT * FROM inspeccion WHERE idproyecto ="+idproyecto+" and idobra ="+idobra+" and iddetalleetapa="+iddetalleetapa);
				
				while(rs.next()) {
					progresogeneral += rs.getInt("porcentaje");
				}
				
				if(progresogeneral == 100) {
					estatus = 0;
					String cade = "UPDATE inspeccion SET estatus = "+estatus+"  WHERE idproyecto ="+idproyecto+" and idobra ="+idobra+" and iddetalleetapa="+iddetalleetapa;
					st.execute(cade);
				}				
				
				String cade = "INSERT INTO inspeccion(" + 
						" idproyecto, idobra, iddetalleetapa, fechainspeccion, observacion, estatus, idcuadrilla, porcentaje, porcentajegeneral)" + 
						"	VALUES ("+idproyecto+", "+idobra+", "+iddetalleetapa+", '"+fecha+"' , '"+observacion+"' , "+estatus+" , "+idcuadrilla+", "+progreso+" , "+progresogeneral+" )";
				st.execute(cade);
				
				
				
				
				respuesta.put("valido", true);
				respuesta.put("msj", "Registro incluido con exito!");
			}else if(operacion==OPERACION_EDITAR){
				String idproyecto= request.getParameter("idproyecto").toString().trim();
				String idtipoobra= request.getParameter("idtipoobra").toString().trim();
				String iddetalleetapa= request.getParameter("iddetalleetapa").toString().trim();
				String costo= request.getParameter("precio").toString().trim();
				costo = costo.replace(".", "").replace(",", ".");
				
				String cade = "UPDATE precio SET costo = "+costo+" WHERE idproyecto = "+idproyecto+" and idtipoobra="+idtipoobra+" and iddetalleetapa="+iddetalleetapa;
							 
				st.execute(cade);
				respuesta.put("valido", true);
				respuesta.put("msj", "Registro editado con exito!");
			}else if(operacion==OPERACION_CONSULTAR){
				String idinspeccion= request.getParameter("idinspeccion")==null ? "0":request.getParameter("idinspeccion").toString().trim();
				
				rs = st.executeQuery("select inspeccion.idinspeccion, inspeccion.observacion, proyecto.nombre as nombreproyecto, obra.nombre as nombreobra, etapa.nombre as nombreetapa, subetapa.nombre as nombresubetapa, " + 
						"inspeccion.porcentaje, inspeccion.fechainspeccion  from inspeccion inner join obra on " + 
						"obra.idobra=inspeccion.idobra inner join detalleetapa on detalleetapa.iddetalleetapa=inspeccion.iddetalleetapa inner join " + 
						"etapa on etapa.idetapa=detalleetapa.idetapa inner join subetapa on subetapa.idsubetapa=detalleetapa.idsubetapa inner join proyecto on "+
						"proyecto.idproyecto=inspeccion.idproyecto where " + 
						"inspeccion.idinspeccion="+idinspeccion);
				respuesta.clear();
				if(rs.next()) {
					respuesta.put("valido", true);
					respuesta.put("nombreproyecto", rs.getString("nombreproyecto"));
					respuesta.put("nombreobra", rs.getString("nombreobra"));
					respuesta.put("nombreetapa", rs.getString("nombreetapa"));
					respuesta.put("nombresubetapa", rs.getString("nombresubetapa"));
					respuesta.put("fechainspeccion", ValidaFormato.cambiarFecha(rs.getString("fechainspeccion").trim(), 2));
					respuesta.put("porcentaje", rs.getInt("porcentaje"));
					respuesta.put("observacion", rs.getString("observacion"));
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

	private Object mostrarEstatus(int int1) {
		// TODO Auto-generated method stub
		return null;
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
