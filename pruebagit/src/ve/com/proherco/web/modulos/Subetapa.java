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
 * Servlet implementation class Cargo
 */
@WebServlet("/Subetapa")
public class Subetapa extends HttpServlet implements Constantes {
	private static final long serialVersionUID = 1L;
	JSONObject respuesta = new JSONObject();
	Connection conexion;
	ConexionWeb conWeb = new ConexionWeb();
	HttpSession session;
	PermisosModulo permisos = new PermisosModulo();
	String MODULO = "subetapa";
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Subetapa() {
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
		session = request.getSession();									
		//----------------------------------------------------------
		int operacion = request.getParameter("operacion")==null ? 0:(Integer.valueOf(request.getParameter("operacion")));
		try {
			conexion = conWeb.abrirConn();
			Statement st = conexion.createStatement();
			ResultSet rs =null; 
			
			if(operacion==OPERACION_LISTADO) {
				JSONArray data = new JSONArray();
				String nombreetapa= ValidaFormato.ucFirst(request.getParameter("nombreEtapa")==null ? "":request.getParameter("nombreEtapa").toString().trim().toUpperCase()) ;
				String condicionWhere = "";
				if(nombreetapa != "") {
					condicionWhere = " WHERE nombre LIKE '%"+nombreetapa+"%'";
				}
				rs = st.executeQuery("SELECT * FROM subetapa"+condicionWhere);
				while (rs.next()) {
						JSONArray p = new JSONArray();
						p.add(rs.getLong("idsubetapa"));
						p.add(rs.getString("nombre").trim());
						p.add(rs.getString("descripcion").trim());
						p.add(rs.getInt("tiempoestimado")+" Dias ");
						data.add(p);
				}			
				respuesta.clear();
				respuesta.put("valido", true);
				respuesta.put("data", data);
			}else if(operacion==OPERACION_INCLUIR){
				if(permisos.getPermiso(session, MODULO, PERMISO_TIPO_INCLUIR)) {
					String txtNombre= request.getParameter("txtNombre").toString().toUpperCase().trim();
					String txtDescripcion= request.getParameter("txtDescripcion").toString().trim();
					//String txtPorcentaje= request.getParameter("txtPorcentaje").toString().trim();
					String txtTiempoestimado= request.getParameter("txtTiempoestimado").toString().trim();
					String cmbEstatus= request.getParameter("cmbEstatus").toString().trim();
					
					String cade = "INSERT INTO subetapa(nombre, descripcion, tiempoestimado, estatus)"
								 + " VALUES('"+txtNombre+"', '"+txtDescripcion+"', "+txtTiempoestimado+", "+cmbEstatus+" )";
					st.execute(cade);
					respuesta.put("valido", true);
					respuesta.put("msj", "Registro incluido con exito!");
				}else {
					respuesta.put("valido", false);
					respuesta.put("msj", MSJ_NO_PERMISO);
				}
			}else if(operacion==OPERACION_EDITAR){

				if(permisos.getPermiso(session, MODULO, PERMISO_TIPO_EDITAR)) {
					String idsubetapa= request.getParameter("idsubetapa")==null ? "0":request.getParameter("idsubetapa").toString().trim();
					String txtNombre= request.getParameter("txtNombre").toString().toUpperCase().trim();
					String txtDescripcion= request.getParameter("txtDescripcion").toString().trim();
					//String txtPorcentaje= request.getParameter("txtPorcentaje").toString().trim();
					String txtTiempoestimado= request.getParameter("txtTiempoestimado").toString().trim();
					String cmbEstatus= request.getParameter("cmbEstatus").toString().trim();
					
					String cade = "UPDATE subetapa SET nombre = '"+txtNombre+"', descripcion = '"+txtDescripcion+"', tiempoestimado = "+txtTiempoestimado+", estatus = "+cmbEstatus+
								  " WHERE idsubetapa = "+idsubetapa;
					st.execute(cade);
					respuesta.put("valido", true);
					respuesta.put("msj", "Registro editado con exito!");
				}else {
					respuesta.put("valido", false);
					respuesta.put("msj", MSJ_NO_PERMISO);
				}
			}else if(operacion==OPERACION_ELIMINAR){
				if(permisos.getPermiso(session, MODULO, PERMISO_TIPO_ELIMINAR)) {
					String idsubetapa= request.getParameter("idsubetapa")==null ? "0":request.getParameter("idsubetapa").toString().trim();
					st.execute("DELETE FROM subetapa WHERE idsubetapa = "+idsubetapa);
					respuesta.put("valido", true);
					respuesta.put("msj", "Registro eliminado con exito!");
				}else {
					respuesta.put("valido", false);
					respuesta.put("msj", MSJ_NO_PERMISO);
				}
			}else if(operacion==OPERACION_CONSULTAR){
				if(permisos.getPermiso(session, MODULO, PERMISO_TIPO_CONSULTAR)) {
					int consultarSubetapa = request.getParameter("consultarSubetapa")==null ? 0:(Integer.valueOf(request.getParameter("consultarSubetapa")));
					String idsubetapa= request.getParameter("idsubetapa")==null ? "0":request.getParameter("idsubetapa").toString().trim();
					String nombre= request.getParameter("nombre")==null ? "0":request.getParameter("nombre").toString().trim();
					
					if(consultarSubetapa == 1) {
						rs = st.executeQuery("SELECT * FROM subetapa where nombre = '"+nombre+"'");
						respuesta.clear();
						if(rs.next()) {
							
							respuesta.put("valido", true);
							respuesta.put("idsubetapa", rs.getLong("idsubetapa"));
							respuesta.put("txtNombre", rs.getString("nombre").trim());
							respuesta.put("txtDescripcion", rs.getString("descripcion").trim());
							//respuesta.put("txtPorcentaje", rs.getDouble("porcentaje"));
							respuesta.put("txtTiempoestimado", rs.getInt("tiempoestimado"));
							respuesta.put("cmbEstatus", rs.getInt("estatus"));
						}
					}else {
						rs = st.executeQuery("SELECT * FROM subetapa where idsubetapa = "+idsubetapa);
						respuesta.clear();
						if(rs.next()) {
							
							respuesta.put("valido", true);
							respuesta.put("idsubetapa", idsubetapa);
							respuesta.put("txtNombre", rs.getString("nombre").trim());
							respuesta.put("txtDescripcion", rs.getString("descripcion").trim());
							//respuesta.put("txtPorcentaje", rs.getDouble("porcentaje"));
							respuesta.put("txtTiempoestimado", rs.getInt("tiempoestimado"));
							respuesta.put("cmbEstatus", rs.getInt("estatus"));
						}else {
							respuesta.put("valido", false);
							respuesta.put("msj", "No existe un cargo con el id="+idsubetapa);
						}
					}
					
				}else {
					respuesta.put("valido", false);
					respuesta.put("msj", MSJ_NO_PERMISO);
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
				//conexion.commit();
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
