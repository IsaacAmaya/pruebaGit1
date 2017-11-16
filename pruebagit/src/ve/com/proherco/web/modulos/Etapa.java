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
@WebServlet("/Etapa")
public class Etapa extends HttpServlet implements Constantes {
	private static final long serialVersionUID = 1L;
	JSONObject respuesta = new JSONObject();
	Connection conexion;
	ConexionWeb conWeb = new ConexionWeb();
	HttpSession session;
	PermisosModulo permisos = new PermisosModulo();
	String MODULO = "etapa";
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Etapa() {
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
			ResultSet rs = null; 
			
			if(operacion==OPERACION_LISTADO) {
				int desdeSolicitud = request.getParameter("desdeSolicitud")==null ? 0:(Integer.valueOf(request.getParameter("desdeSolicitud")));
				int desdeInspeccion = request.getParameter("desdeInspeccion")==null ? 0:(Integer.valueOf(request.getParameter("desdeInspeccion")));
				String idtipoobra= request.getParameter("idtipoobra")==null ? "0":request.getParameter("idtipoobra").toString().trim();
				String idobra= request.getParameter("idobra")==null ? "0":request.getParameter("idobra").toString().trim();
				JSONArray data = new JSONArray();
				
				if(desdeSolicitud==1) {
					
					String nombreetapa= ValidaFormato.ucFirst(request.getParameter("nombreetapa").toString().trim()) ;
					String condicionWhere = "";
					if(nombreetapa != "") {
						condicionWhere = " AND nombre LIKE '%"+nombreetapa+"%'";
					}
					
					rs = st.executeQuery("SELECT etapa.idetapa, etapa.nombre, etapa.descripcion " + 
							" FROM etapa inner join detalleetapa on detalleetapa.idetapa=etapa.idetapa inner join materialporobra on " + 
							" materialporobra.iddetalleetapa=detalleetapa.iddetalleetapa where idtipoobra="+idtipoobra+condicionWhere+" group by etapa.idetapa");
					while (rs.next()) {
							JSONArray p = new JSONArray();
							p.add(rs.getLong("idetapa"));
							p.add(rs.getString("nombre").trim());
							p.add(rs.getString("descripcion").trim());
							data.add(p);
					}
				}else if(desdeInspeccion == 1){
					rs = st.executeQuery("SELECT etapa.idetapa, etapa.nombre FROM etapa inner join detalleetapa on detalleetapa.idetapa=etapa.idetapa inner join materialporobra on " + 
							"materialporobra.iddetalleetapa=detalleetapa.iddetalleetapa inner join tipoobra on tipoobra.idtipoobra=materialporobra.idtipoobra " + 
							"inner join obra on obra.idtipoobra=tipoobra.idtipoobra " + 
							"where obra.idobra="+idobra+" group by etapa.idetapa, etapa.nombre");
					while (rs.next()) {
							JSONArray p = new JSONArray();
							p.add(rs.getLong("idetapa"));
							p.add(rs.getString("nombre").trim());
							data.add(p);
					}
					System.out.print("entro aqui");
				}else{
					rs = st.executeQuery("SELECT * FROM etapa");
					while (rs.next()) {
							JSONArray p = new JSONArray();
							p.add(rs.getLong("idetapa"));
							p.add(rs.getString("nombre").trim());
							p.add(rs.getString("descripcion").trim());
							p.add(rs.getInt("tiempoestimado")+" Dias ");
							p.add(rs.getInt("estatus"));
							data.add(p);
					}
				}
				
				respuesta.clear();
				respuesta.put("valido", true);
				respuesta.put("data", data);
			}else if(operacion==OPERACION_INCLUIR){
				if(permisos.getPermiso(session, MODULO, PERMISO_TIPO_INCLUIR)) {
					String idEtapa = "";
					rs = st.executeQuery("SELECT nextval('idetapa') as idetapa");
					if(rs.next()) {
						idEtapa = rs.getString("idetapa");
					}
					String txtNombre= request.getParameter("txtNombre").toString().toUpperCase().trim();
					String txtDescripcion= request.getParameter("txtDescripcion").toString().trim();
					String txtPorcentaje= request.getParameter("txtPorcentaje").toString().trim();
					String txtTiempoestimado= request.getParameter("txtTiempoestimado").toString().trim();
					String cmbEstatus= request.getParameter("cmbEstatus").toString().trim();
					
					String cade = "INSERT INTO etapa(idetapa, nombre, descripcion, porcentaje, tiempoestimado, estatus)"
								 + " VALUES("+idEtapa+",'"+txtNombre+"', '"+txtDescripcion+"', "+txtPorcentaje+", "+txtTiempoestimado+", "+cmbEstatus+" )";
					st.execute(cade);
					
					String listaSubEtapa= request.getParameter("listaSubEtapa").toString().trim();
					String listaPorcentaje= request.getParameter("listaPorcentaje").toString().trim();
					if(listaSubEtapa!="") {
						String[] SubEtapas = listaSubEtapa.split(",");	
						String[] Porcentaje = listaPorcentaje.split(",");
						for (int i = 0; i < SubEtapas.length; i++) {					
							String cade2 = "INSERT INTO detalleetapa (idetapa,idsubetapa,porcentaje,estatus) VALUES ("+idEtapa+", "+SubEtapas[i]+", "+Porcentaje[i]+", 1)";
							st.execute(cade2);
						}
					}
					respuesta.put("valido", true);
					respuesta.put("msj", "Registro incluido con exito!");
				}else {
					respuesta.put("valido", false);
					respuesta.put("msj", MSJ_NO_PERMISO);
				}
			}else if(operacion==OPERACION_EDITAR){
				if(permisos.getPermiso(session, MODULO, PERMISO_TIPO_EDITAR)) {
					String idetapa= request.getParameter("idetapa")==null ? "0":request.getParameter("idetapa").toString().trim();
					String txtNombre= request.getParameter("txtNombre").toString().toUpperCase().trim();
					String txtDescripcion= request.getParameter("txtDescripcion").toString().trim();
					String txtPorcentaje= request.getParameter("txtPorcentaje").toString().trim();
					String txtTiempoestimado= request.getParameter("txtTiempoestimado").toString().trim();
					String cmbEstatus= request.getParameter("cmbEstatus").toString().trim();
					
					/*String cade1 = "DELETE FROM detalleetapa WHERE idetapa = "+idetapa;
					st.execute(cade1);*/
					
					String listaSubEtapa= request.getParameter("listaSubEtapa").toString().trim();
					String listaPorcentaje= request.getParameter("listaPorcentaje").toString().trim();
					if(listaSubEtapa!="") {
						String[] SubEtapas = listaSubEtapa.split(",");
						String[] Porcentaje = listaPorcentaje.split(",");
						for (int i = 0; i < SubEtapas.length; i++) {
							String cade2 = "UPDATE detalleetapa SET porcentaje="+Porcentaje[i]+" WHERE idetapa="+idetapa+" AND idsubetapa="+SubEtapas[i];
							st.execute(cade2);
						}
					}						
					
					String cade = "UPDATE etapa SET nombre = '"+txtNombre+"', descripcion = '"+txtDescripcion+"', porcentaje = "+txtPorcentaje+",  tiempoestimado = "+txtTiempoestimado+", estatus= "+cmbEstatus+" "
								 +" WHERE idetapa = "+idetapa;
					st.execute(cade);
					respuesta.put("valido", true);
					respuesta.put("msj", "Registro editado con exito!");
				}else {
					respuesta.put("valido", false);
					respuesta.put("msj", MSJ_NO_PERMISO);
				}
			}else if(operacion==OPERACION_ELIMINAR){
				if(permisos.getPermiso(session, MODULO, PERMISO_TIPO_ELIMINAR)) {
					String idetapa= request.getParameter("idetapa")==null ? "0":request.getParameter("idetapa").toString().trim();
					st.execute("DELETE FROM etapa WHERE idetapa = "+idetapa);
					respuesta.put("valido", true);
					respuesta.put("msj", "Registro eliminado con exito!");
				}else {
					respuesta.put("valido", false);
					respuesta.put("msj", MSJ_NO_PERMISO);
				}
			}else if(operacion==OPERACION_CONSULTAR){
				if(permisos.getPermiso(session, MODULO, PERMISO_TIPO_CONSULTAR)) {
					int consultarEtapa = request.getParameter("consultarEtapa")==null ? 0:(Integer.valueOf(request.getParameter("consultarEtapa")));
					String idetapa= request.getParameter("idetapa")==null ? "0":request.getParameter("idetapa").toString().trim();
					String nombre= request.getParameter("nombre")==null ? "0":request.getParameter("nombre").toString().trim();
					
					if(consultarEtapa == 1) {
						rs = st.executeQuery("SELECT * FROM etapa where nombre = '"+nombre+"'");
						respuesta.clear();
						if(rs.next()) {
							respuesta.put("valido", true);
							respuesta.put("idetapa", rs.getLong("idetapa"));
							respuesta.put("txtNombre", rs.getString("nombre").trim());
							respuesta.put("txtDescripcion", rs.getString("descripcion").trim());
							respuesta.put("txtPorcentaje", rs.getDouble("porcentaje"));
							respuesta.put("txtTiempoestimado", rs.getInt("tiempoestimado"));
							respuesta.put("cmbEstatus", rs.getInt("estatus"));					
						}
					}else {
						rs = st.executeQuery("SELECT * FROM etapa where idetapa = "+idetapa);
						respuesta.clear();
						if(rs.next()) {
							respuesta.put("valido", true);
							respuesta.put("idetapa", idetapa);
							respuesta.put("txtNombre", rs.getString("nombre").trim());
							respuesta.put("txtDescripcion", rs.getString("descripcion").trim());
							respuesta.put("txtPorcentaje", rs.getDouble("porcentaje"));
							respuesta.put("txtTiempoestimado", rs.getInt("tiempoestimado"));
							respuesta.put("cmbEstatus", rs.getInt("estatus"));					
						}else {
							respuesta.put("valido", false);
							respuesta.put("msj", "No existe un cargo con el id="+idetapa);
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
