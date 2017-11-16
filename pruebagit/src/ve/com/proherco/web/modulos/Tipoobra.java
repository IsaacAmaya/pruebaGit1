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
 * Servlet implementation class Tipoobra
 */
@WebServlet("/Tipoobra")
public class Tipoobra extends HttpServlet implements Constantes {
	private static final long serialVersionUID = 1L;
	JSONObject respuesta = new JSONObject();
	Connection conexion;
	ConexionWeb conWeb = new ConexionWeb();
	HttpSession session;
	PermisosModulo permisos = new PermisosModulo();
	String MODULO = "tipoobra";
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Tipoobra() {
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
				rs = st.executeQuery("SELECT * FROM tipoobra");
				while (rs.next()) {
						JSONArray p = new JSONArray();
						p.add(rs.getLong("idtipoobra"));
						p.add(rs.getString("nombre").trim());
						p.add(rs.getString("descripcion").trim());
						/*p.add(ValidaFormato.formato(rs.getString("montoobra"))+" Bs ");
						p.add(rs.getDouble("montomanoobra"));*/
						p.add(rs.getInt("estatus"));					
						data.add(p);
				}			
				respuesta.clear();
				respuesta.put("valido", true);
				respuesta.put("data", data);
			}else if(operacion==OPERACION_INCLUIR){
				if(permisos.getPermiso(session, MODULO, PERMISO_TIPO_INCLUIR)) {
					String txtNombre= request.getParameter("txtNombre").toString().trim();
					String txtDescripcion= request.getParameter("txtDescripcion").toString().trim();
					/*String txtMontoobra= request.getParameter("txtMontoobra").toString().trim();
					txtMontoobra = txtMontoobra.replace(".", "").replace(",", ".");
					String txtMontomanoobra= request.getParameter("txtMontomanoobra").toString().trim();
					txtMontomanoobra = txtMontomanoobra.replace(".", "").replace(",", ".");*/
					String cmbEstatus= request.getParameter("cmbEstatus").toString().trim();
					
					String idTipoobra = "";
					rs = st.executeQuery("SELECT nextval('idtipoobra') as idtipoobra");
					if(rs.next()) {
						idTipoobra = rs.getString("idtipoobra");
					}
	
					String cade = "INSERT INTO tipoobra(idtipoobra,nombre,descripcion,estatus)"
								 + " VALUES("+idTipoobra+",'"+txtNombre+"', '"+txtDescripcion+"', "+cmbEstatus+")";
					st.execute(cade);
					respuesta.put("valido", true);
					respuesta.put("msj", "Registro incluido con exito!");
					respuesta.put("idTipoobra", idTipoobra);
				}else {
					respuesta.put("valido", false);
					respuesta.put("msj", MSJ_NO_PERMISO);
				}
			}else if(operacion==OPERACION_EDITAR){
				if(permisos.getPermiso(session, MODULO, PERMISO_TIPO_EDITAR)) {
					String idtipoobra= request.getParameter("idtipoobra")==null ? "0":request.getParameter("idtipoobra").toString().trim();
					String iddetalleetapa= request.getParameter("iddetalleetapa")==null ? "0":request.getParameter("iddetalleetapa").toString().trim();
					String txtNombre= request.getParameter("txtNombre").toString().trim();
					String txtDescripcion= request.getParameter("txtDescripcion").toString().trim();
					/*String txtMontoobra= request.getParameter("txtMontoobra").toString().trim();
					txtMontoobra = txtMontoobra.replace(".", "").replace(",", ".");
					String txtMontomanoobra= request.getParameter("txtMontomanoobra").toString().trim();
					txtMontomanoobra = txtMontomanoobra.replace(".", "").replace(",", ".");*/
					String cmbEstatus= request.getParameter("cmbEstatus").toString().trim();
					
					/*if(iddetalleetapa!="") {
						
						String cade1 = "DELETE FROM materialporobra WHERE idtipoobra = "+idtipoobra+" AND iddetalleetapa = "+iddetalleetapa;
						st.execute(cade1);
					}			
					
					String listaMaterial = request.getParameter("listaMaterial").toString().trim();
					if(listaMaterial!="") {
						String[] Materiales = listaMaterial.split(",");
						for (int i = 0; i < Materiales.length; i++) {
							String cade2 = "INSERT INTO materialporobra (idmaterial,iddetalleetapa,idtipoobra) VALUES ("+Materiales[i]+", "+iddetalleetapa+", "+idtipoobra+")";
							st.execute(cade2);
						}
					}*/
					
					String cade = "UPDATE tipoobra SET nombre = '"+txtNombre+"', descripcion = '"+txtDescripcion+"', estatus = "+cmbEstatus+" WHERE idtipoobra = "+idtipoobra;
					st.execute(cade);
					respuesta.put("valido", true);
					respuesta.put("msj", "Registro editado con exito!");
				}else {
					respuesta.put("valido", false);
					respuesta.put("msj", MSJ_NO_PERMISO);
				}
			}else if(operacion==OPERACION_ELIMINAR){
				if(permisos.getPermiso(session, MODULO, PERMISO_TIPO_ELIMINAR)) {
					String idtipoobra= request.getParameter("idtipoobra")==null ? "0":request.getParameter("idtipoobra").toString().trim();
					st.execute("DELETE FROM tipoobra WHERE idtipoobra = "+idtipoobra);
					respuesta.put("valido", true);
					respuesta.put("msj", "Registro eliminado con exito!");
				}else {
					respuesta.put("valido", false);
					respuesta.put("msj", MSJ_NO_PERMISO);
				}
			}else if(operacion==OPERACION_CONSULTAR){
				if(permisos.getPermiso(session, MODULO, PERMISO_TIPO_CONSULTAR)) {
					int consultarTipoobra = request.getParameter("consultarTipoobra")==null ? 0:(Integer.valueOf(request.getParameter("consultarTipoobra")));
					String idtipoobra= request.getParameter("idtipoobra")==null ? "0":request.getParameter("idtipoobra").toString().trim();
					String nombre= request.getParameter("nombre")==null ? "0":request.getParameter("nombre").toString().trim();
					
					if(consultarTipoobra==1) {
						rs = st.executeQuery("SELECT * FROM tipoobra where nombre = '"+nombre+"'");
						respuesta.clear();
						if(rs.next()) {
							respuesta.put("valido", true);
							respuesta.put("idtipoobra", rs.getLong("idtipoobra"));
							respuesta.put("txtNombre", rs.getString("nombre").trim());
							respuesta.put("txtDescripcion", rs.getString("descripcion").trim());
							respuesta.put("cmbEstatus", rs.getInt("estatus"));							
						}
					}else {
						rs = st.executeQuery("SELECT * FROM tipoobra where idtipoobra = "+idtipoobra);
						respuesta.clear();
						if(rs.next()) {
							respuesta.put("valido", true);
							respuesta.put("idtipoobra", idtipoobra);
							respuesta.put("txtNombre", rs.getString("nombre").trim());
							respuesta.put("txtDescripcion", rs.getString("descripcion").trim());
							/*String montoobra = String.valueOf(rs.getDouble("montoobra"));
							respuesta.put("txtMontoobra", ValidaFormato.formato(montoobra));
							String montomanoobra = String.valueOf(rs.getDouble("montomanoobra"));
							respuesta.put("txtMontomanoobra", ValidaFormato.formato(montomanoobra));*/
							respuesta.put("cmbEstatus", rs.getInt("estatus"));
							
						}else {
							respuesta.put("valido", false);
							respuesta.put("msj", "No existe el tipo de obra con el id="+idtipoobra);
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
			respuesta.put("msj", "Error interno en el servidor. Error en el archivo .Java");			
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
