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
 * Servlet implementation class Proveedor
 */
@WebServlet("/Proveedor")
public class Proveedor extends HttpServlet implements Constantes {
	private static final long serialVersionUID = 1L;
	JSONObject respuesta = new JSONObject();
	Connection conexion;
	ConexionWeb conWeb = new ConexionWeb();
	HttpSession session;
	PermisosModulo permisos = new PermisosModulo();
	String MODULO = "proveedor";
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Proveedor() {
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
				int desdeListadoCompra = request.getParameter("desdeListadoCompra")==null ? 0:(Integer.valueOf(request.getParameter("desdeListadoCompra")));
				
				JSONArray data = new JSONArray();
				if(desdeListadoCompra == 1) {
					
					rs = st.executeQuery("select proveedor.idproveedor, proveedor.nombre, proveedor.rif  from proveedor inner join compra on compra.idproveedor=proveedor.idproveedor " + 
							"group by proveedor.idproveedor, proveedor.nombre, proveedor.rif");
					while (rs.next()) {
							JSONArray p = new JSONArray();
							p.add(rs.getLong("idproveedor"));							
							p.add(rs.getString("rif").trim());
							p.add(rs.getString("nombre").trim());
							data.add(p);
					}	
				}else {
					rs = st.executeQuery("SELECT * FROM proveedor");
					while (rs.next()) {
							JSONArray p = new JSONArray();
							p.add(rs.getLong("idproveedor"));
							p.add(rs.getString("nombre").trim());
							p.add(rs.getString("rif").trim());
							p.add(rs.getString("direccion"));
							p.add(rs.getString("descripcion").trim());
							p.add(rs.getInt("estatus"));	
							p.add(rs.getString("telefono").trim());
							data.add(p);
					}
				}
				
						
				respuesta.clear();
				respuesta.put("valido", true);
				respuesta.put("data", data);
			}else if(operacion==OPERACION_INCLUIR){
				if(permisos.getPermiso(session, MODULO, PERMISO_TIPO_INCLUIR)) {
					String txtNombre= request.getParameter("txtNombre").toString().trim();
					String txtRif= request.getParameter("txtRif").toString().trim();
					String txtDireccion= request.getParameter("txtDireccion").toString().trim();
					String txtDescripcion= request.getParameter("txtDescripcion").toString().trim();
					String cmbEstatus= request.getParameter("cmbEstatus").toString().trim();
					String txtTelefono= request.getParameter("txtTelefono").toString().trim();
					String idProveedor = "";
					rs = st.executeQuery("SELECT nextval('idproveedor') as idproveedor");
					if(rs.next()) {
						idProveedor = rs.getString("idproveedor");
					}
					String cade = "INSERT INTO proveedor(idproveedor,nombre, rif, direccion, descripcion, estatus, telefono)"
								 + " VALUES("+idProveedor+",'"+txtNombre+"', '"+txtRif+"', '"+txtDireccion+"', '"+txtDescripcion+"', "+cmbEstatus+", '"+txtTelefono+"' )";
					st.execute(cade);
					respuesta.put("valido", true);
					respuesta.put("msj", "Registro incluido con exito!");
					respuesta.put("idproveedor", idProveedor);
					respuesta.put("rif", txtRif);
					respuesta.put("nombre", txtNombre);
					respuesta.put("direccion", txtDireccion);
				}else {
					respuesta.put("valido", false);
					respuesta.put("msj", MSJ_NO_PERMISO);
				}
			}else if(operacion==OPERACION_EDITAR){
				if(permisos.getPermiso(session, MODULO, PERMISO_TIPO_EDITAR)) {
					String idproveedor= request.getParameter("idproveedor")==null ? "0":request.getParameter("idproveedor").toString().trim();
					String txtNombre= request.getParameter("txtNombre").toString().trim();
					String txtRif= request.getParameter("txtRif").toString().trim();
					String txtDireccion= request.getParameter("txtDireccion").toString().trim();
					String txtDescripcion= request.getParameter("txtDescripcion").toString().trim();
					String cmbEstatus= request.getParameter("cmbEstatus").toString().trim();
					String txtTelefono= request.getParameter("txtTelefono").toString().trim();
					
					String cade = "UPDATE proveedor SET nombre = '"+txtNombre+"', rif = '"+txtRif+"', direccion = '"+txtDireccion+"', descripcion = '"+txtDescripcion+"', estatus = "+cmbEstatus+", telefono = '"+txtTelefono+"'"
					+" WHERE idproveedor = "+idproveedor;
					st.execute(cade);
					respuesta.put("valido", true);
					respuesta.put("msj", "Registro editado con exito!");
				}else {
					respuesta.put("valido", false);
					respuesta.put("msj", MSJ_NO_PERMISO);
				}
			}else if(operacion==OPERACION_ELIMINAR){
				if(permisos.getPermiso(session, MODULO, PERMISO_TIPO_ELIMINAR)) {
					String idproveedor= request.getParameter("idproveedor")==null ? "0":request.getParameter("idproveedor").toString().trim();
					st.execute("DELETE FROM proveedor WHERE idproveedor = "+idproveedor);
					respuesta.put("valido", true);
					respuesta.put("msj", "Registro eliminado con exito!");
				}else {
					respuesta.put("valido", false);
					respuesta.put("msj", MSJ_NO_PERMISO);
				}
			}else if(operacion==OPERACION_CONSULTAR){
				if(permisos.getPermiso(session, MODULO, PERMISO_TIPO_CONSULTAR)) {
					int consultarRif = request.getParameter("consultarRif")==null ? 0:(Integer.valueOf(request.getParameter("consultarRif")));
					String idproveedor= request.getParameter("idproveedor")==null ? "0":request.getParameter("idproveedor").toString().trim();
					String rif= request.getParameter("rif")==null ? "0":request.getParameter("rif").toString().trim().toUpperCase();
					
					if(consultarRif == 1) {
						rs = st.executeQuery("SELECT * FROM proveedor where rif = '"+rif+"' ");
						respuesta.clear();
						if(rs.next()) {
							respuesta.put("valido", true);
							respuesta.put("idproveedor", rs.getLong("idproveedor"));
							respuesta.put("txtNombre", rs.getString("nombre").trim());
							respuesta.put("txtRif", rs.getString("rif").trim());
							respuesta.put("txtDireccion", rs.getString("direccion").trim());
							respuesta.put("txtDescripcion", rs.getString("descripcion").trim());
							respuesta.put("cmbEstatus", rs.getInt("estatus"));
							respuesta.put("txtTelefono", rs.getString("telefono").trim());
							
						}
					}else {
						rs = st.executeQuery("SELECT * FROM proveedor where idproveedor = "+idproveedor);
						respuesta.clear();
						if(rs.next()) {
							respuesta.put("valido", true);
							respuesta.put("idproveedor", idproveedor);
							respuesta.put("txtNombre", rs.getString("nombre").trim());
							respuesta.put("txtRif", rs.getString("rif").trim());
							respuesta.put("txtDireccion", rs.getString("direccion").trim());
							respuesta.put("txtDescripcion", rs.getString("descripcion").trim());
							respuesta.put("cmbEstatus", rs.getInt("estatus"));
							respuesta.put("txtTelefono", rs.getString("telefono").trim());
							
						}else {
							respuesta.put("valido", false);
							respuesta.put("msj", "No existe una persona con el id="+idproveedor);
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
