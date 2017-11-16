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
@WebServlet("/Cargo")
public class Cargo extends HttpServlet implements Constantes {
	private static final long serialVersionUID = 1L;
	JSONObject respuesta = new JSONObject();
	Connection conexion;
	ConexionWeb conWeb = new ConexionWeb();
	HttpSession session;
	PermisosModulo permisos = new PermisosModulo();
	String MODULO = "cargo";
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Cargo() {
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
				int menuInicio = request.getParameter("menuInicio")==null ? 0:(Integer.valueOf(request.getParameter("menuInicio")));
				JSONArray data = new JSONArray();
				
				if(menuInicio == 1) {
					String idUsuario= request.getParameter("idusuario")==null ? "0":request.getParameter("idusuario").toString().trim();
					rs = st.executeQuery("SELECT * FROM permisos where idusuario="+idUsuario);
					while (rs.next()) {
							JSONArray p = new JSONArray();
							if(rs.getBoolean("incluir") == true || rs.getBoolean("editar")==true || rs.getBoolean("eliminar")==true || rs.getBoolean("consultar")==true) {
								p.add(rs.getString("modulo").trim());
							}
							data.add(p);
					}
				}else if(menuInicio == 2){
					String idUsuario= request.getParameter("idusuario")==null ? "0":request.getParameter("idusuario").toString().trim();
					String modulo= request.getParameter("modulo")==null ? "0":request.getParameter("modulo").toString().trim();
					rs = st.executeQuery("SELECT * FROM permisos where idusuario="+idUsuario+" and modulo='"+modulo+"'");
					while (rs.next()) {
						
							JSONArray p = new JSONArray();
							p.add(rs.getBoolean("incluir"));
							p.add(rs.getBoolean("editar"));
							p.add(rs.getBoolean("eliminar"));
							p.add(rs.getBoolean("consultar"));
							data.add(p);
					}
				}else {
					rs = st.executeQuery("SELECT * FROM cargo");
					while (rs.next()) {
							JSONArray p = new JSONArray();
							p.add(rs.getLong("idcargo"));
							p.add(rs.getString("nombre").trim());
							p.add(rs.getString("descripcion").trim());
							p.add(ValidaFormato.formato(rs.getString("sueldo"))+" Bs ");
							p.add(ValidaFormato.estatus(rs.getInt("estatus")));
							data.add(p);
					}	
				}
						
				respuesta.clear();
				respuesta.put("valido", true);
				respuesta.put("data", data);
			}else if(operacion==OPERACION_INCLUIR){
				if(permisos.getPermiso(session, MODULO, PERMISO_TIPO_INCLUIR)) {
					int desdeTrabajador = request.getParameter("desdeTrabajador")==null ? 0:(Integer.valueOf(request.getParameter("desdeTrabajador")));
					
					String txtNombre= request.getParameter("txtNombre")==null ? "0":request.getParameter("txtNombre").toString().trim();
					String txtDescripcion= request.getParameter("txtDescripcion")==null ? "0":request.getParameter("txtDescripcion").toString().trim();
					String txtSueldo= request.getParameter("txtSueldo")==null ? "0":request.getParameter("txtSueldo").toString().trim();
					txtSueldo = txtSueldo.replace(".", "").replace(",", ".");
					String cmbEstatus= request.getParameter("idcargo")==null ? "0":request.getParameter("cmbEstatus").toString().trim();
					
					rs = st.executeQuery("SELECT * from cargo where nombre='"+txtNombre+"'");//VERIFICAMOS QUE EL CARGO NO EXISTA
					if(!rs.next()) {
						if(desdeTrabajador == 1) {
							String idCargo = "";
							rs = st.executeQuery("SELECT nextval('idcargo') as idcargo");
							if(rs.next()) {
								idCargo= rs.getString("idcargo");
							}
							String cade = "INSERT INTO cargo(idcargo,nombre, estatus)"+
									      " VALUES("+idCargo+",'"+txtNombre+"',  1 )";
							st.execute(cade);
							respuesta.put("valido", true);
							respuesta.put("msj", "Registro incluido con exito!");
							respuesta.put("idcargo", idCargo);
							respuesta.put("txtNombrecargo", txtNombre);
						}else {
							String cade = "INSERT INTO cargo(nombre, descripcion, sueldo, estatus)"+
									      " VALUES('"+txtNombre+"', '"+txtDescripcion+"', "+txtSueldo+", "+cmbEstatus+" )";
							st.execute(cade);
							respuesta.put("valido", true);
							respuesta.put("msj", "Registro incluido con exito!");
						}
					}					
					
				}else {
					respuesta.put("valido", false);
					respuesta.put("msj", MSJ_NO_PERMISO);
				}
			}else if(operacion==OPERACION_EDITAR){
				if(permisos.getPermiso(session, MODULO, PERMISO_TIPO_EDITAR)) {
					String idcargo= request.getParameter("idcargo")==null ? "0":request.getParameter("idcargo").toString().trim();
					String txtNombre= request.getParameter("txtNombre").toString().trim();
					String txtDescripcion= request.getParameter("txtDescripcion").toString().trim();
					String txtSueldo= request.getParameter("txtSueldo").toString().trim();
					txtSueldo = txtSueldo.replace(".", "").replace(",", ".");
					String cmbEstatus= request.getParameter("cmbEstatus").toString().trim();
					
					String cade = "UPDATE cargo SET nombre = '"+txtNombre+"', descripcion = '"+txtDescripcion+"', sueldo = "+txtSueldo+",  estatus = "+cmbEstatus+
								  " WHERE idcargo = "+idcargo;
					st.execute(cade);
					respuesta.put("valido", true);
					respuesta.put("msj", "Registro editado con exito!");
				}else {
					respuesta.put("valido", false);
					respuesta.put("msj", MSJ_NO_PERMISO);
				}
			}else if(operacion==OPERACION_ELIMINAR){
				if(permisos.getPermiso(session, MODULO, PERMISO_TIPO_ELIMINAR)) {
					String idcargo= request.getParameter("idcargo")==null ? "0":request.getParameter("idcargo").toString().trim();
					st.execute("DELETE FROM cargo WHERE idcargo = "+idcargo);
					respuesta.put("valido", true);
					respuesta.put("msj", "Registro eliminado con exito!");
				}else {
					respuesta.put("valido", false);
					respuesta.put("msj", MSJ_NO_PERMISO);
				}
			}else if(operacion==OPERACION_CONSULTAR){
				if(permisos.getPermiso(session, MODULO, PERMISO_TIPO_CONSULTAR)) {
					String idcargo= request.getParameter("idcargo")==null ? "0":request.getParameter("idcargo").toString().trim();
					int consultarCargo = request.getParameter("consultarCargo")==null ? 0:(Integer.valueOf(request.getParameter("consultarCargo")));
					String nombre= request.getParameter("nombre")==null ? "0":request.getParameter("nombre").toString().trim();
					if(consultarCargo == 1) {
						rs = st.executeQuery("SELECT * FROM cargo where nombre='"+nombre+"'");
						respuesta.clear();
						if(rs.next()) {
							respuesta.put("valido", true);
							respuesta.put("idcargo", rs.getLong("idcargo"));
							respuesta.put("txtNombre", rs.getString("nombre").trim());
							respuesta.put("txtDescripcion", rs.getString("descripcion").trim());
							String sueldo = String.valueOf(rs.getDouble("sueldo"));
							respuesta.put("txtSueldo", ValidaFormato.formato(sueldo));
							respuesta.put("cmbEstatus", rs.getInt("estatus"));					
						}
					}else {
						rs = st.executeQuery("SELECT * FROM cargo where idcargo = "+idcargo);
						respuesta.clear();
						if(rs.next()) {
							respuesta.put("valido", true);
							respuesta.put("idcargo", idcargo);
							respuesta.put("txtNombre", rs.getString("nombre").trim());
							respuesta.put("txtDescripcion", rs.getString("descripcion").trim());
							String sueldo = String.valueOf(rs.getDouble("sueldo"));
							respuesta.put("txtSueldo", ValidaFormato.formato(sueldo));
							respuesta.put("cmbEstatus", rs.getInt("estatus"));					
						}else {
							respuesta.put("valido", false);
							respuesta.put("msj", "No existe un cargo con el id="+idcargo);
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
