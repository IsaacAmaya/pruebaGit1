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
 * Servlet implementation class Matierial
 */
@WebServlet("/Material")
public class Material extends HttpServlet implements Constantes {
	private static final long serialVersionUID = 1L;
	JSONObject respuesta = new JSONObject();
	Connection conexion;
	ConexionWeb conWeb = new ConexionWeb();
	HttpSession session;
	PermisosModulo permisos = new PermisosModulo();
	String MODULO = "material";
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Material() {
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
				int desdeSolicitud = request.getParameter("desdeSolicitud")==null ? 0:(Integer.valueOf(request.getParameter("desdeSolicitud")));
				int listadoCategoria = request.getParameter("listadoCategoria")==null ? 0:(Integer.valueOf(request.getParameter("listadoCategoria")));
				int desdeListadoCompra = request.getParameter("desdeListadoCompra")==null ? 0:(Integer.valueOf(request.getParameter("desdeListadoCompra")));
				String iddetalleetapa= request.getParameter("iddetalleetapa")==null ? "0":request.getParameter("iddetalleetapa").toString().trim();
				String idtipoobra= request.getParameter("idtipoobra")==null ? "0":request.getParameter("idtipoobra").toString().trim();
				JSONArray data = new JSONArray();
				if(desdeSolicitud==1) {
					String nombrematerial= request.getParameter("nombrematerial").toString().trim();
					String condicionWhere = "";
					if(nombrematerial != "") {
						condicionWhere = " AND nombre LIKE '%"+nombrematerial+"%'";
					}
					
					rs = st.executeQuery("SELECT material.idmaterial, nombre, marca, descripcion, existencia, iddetalleetapa " + 
							" FROM material inner join materialporobra on materialporobra.idmaterial=material.idmaterial " + 
							" where materialporobra.iddetalleetapa="+iddetalleetapa+" and materialporobra.idtipoobra="+idtipoobra+condicionWhere);
					while (rs.next()) {
						JSONArray p = new JSONArray();
						p.add(rs.getLong("idmaterial"));
						p.add(rs.getString("nombre").trim());
						//p.add(rs.getString("marca").trim());
						p.add(rs.getDouble("existencia"));
						data.add(p);
					}
				}else if(listadoCategoria==1) {
					
					rs = st.executeQuery("SELECT categoria FROM material group by categoria");
					while (rs.next()) {
						JSONArray p = new JSONArray();
						p.add(rs.getString("categoria").trim());
						data.add(p);
					}
				}else if(desdeListadoCompra==1) {
					String proveedor= request.getParameter("proveedor")=="" ? "0":request.getParameter("proveedor").toString().trim();
					String condicion = "";
					if(proveedor !="0" ) {
						condicion = " where compra.idproveedor="+proveedor;
					}
					rs = st.executeQuery("select material.categoria from material inner join compramaterial on compramaterial.idmaterial=material.idmaterial " + 
							"inner join compra on compra.idcompra=compramaterial.idcompra "+condicion+" group by material.categoria");
					while (rs.next()) {
						JSONArray p = new JSONArray();
						p.add(rs.getString("categoria").trim());
						data.add(p);
					}
				}else if(desdeListadoCompra==2) {
					String categoria= request.getParameter("categoria")=="" ? "0":request.getParameter("categoria").toString().trim();
					String condicion = "";
					if(categoria !="0" ) {
						condicion = " where material.categoria='"+categoria+"'";
					}
					rs = st.executeQuery("select material.idmaterial, material.nombre from material inner join compramaterial on compramaterial.idmaterial=material.idmaterial " +condicion+
							" group by material.idmaterial, material.nombre");
					while (rs.next()) {
						JSONArray p = new JSONArray();
						p.add(rs.getLong("idmaterial"));
						p.add(rs.getString("nombre").trim());
						data.add(p);
					}
				}else {
					rs = st.executeQuery("SELECT * FROM material");
					while (rs.next()) {
						JSONArray p = new JSONArray();
						p.add(rs.getLong("idmaterial"));
						p.add(rs.getString("nombre").trim());
						//p.add(rs.getString("marca").trim());
						p.add(rs.getString("descripcion").trim());
						p.add(rs.getString("categoria").trim());
						p.add(rs.getDouble("existencia"));
						
						if(request.getParameter("app")!=null) {
							String cadeCM = "select cm.costounitario, cm.costounitariousd, c.fecha " + 
											"from compramaterial as cm " + 
											"left join compra as c on cm.idcompra=c.idcompra " + 
											"where cm.idmaterial = "+rs.getLong("idmaterial");
							Statement stCM = conexion.createStatement();
							ResultSet rsCM = stCM.executeQuery(cadeCM);
							if(rsCM.next()) {
								if(rsCM.getDate("fecha")!=null) {
									p.add(ValidaFormato.cambiarFecha(rsCM.getDate("fecha").toString(), 2));
								}else {
									p.add("--");
								}
								p.add(ValidaFormato.formato(String.valueOf(rsCM.getDouble("costounitario"))));
								p.add(ValidaFormato.formato(String.valueOf(rsCM.getDouble("costounitariousd"))));
							}else {
								p.add("--");
								p.add("0.0");
								p.add("0.0");
							}
						}
						
						
						
						
						//p.add(ValidaFormato.estatus(rs.getInt("estatus")));					
						data.add(p);
					}	
				}
				
				respuesta.clear();
				respuesta.put("valido", true);
				respuesta.put("data", data);
			}else if(operacion==OPERACION_INCLUIR){
				if(permisos.getPermiso(session, MODULO, PERMISO_TIPO_INCLUIR)) {
					String txtNombre= request.getParameter("txtNombre").toString().trim();
					//String txtMarca= request.getParameter("txtMarca").toString().trim();
					String txtCategoria= request.getParameter("txtCategoria").toString().trim();
					String txtDescripcion= request.getParameter("txtDescripcion").toString().trim();
					String cmbEstatus= request.getParameter("cmbEstatus").toString().trim();
					
					String idMaterial = "";
					rs = st.executeQuery("SELECT nextval('idmaterial') as idmaterial");
					if(rs.next()) {
						idMaterial = rs.getString("idmaterial");
					}
					
					String cade = "INSERT INTO material(idmaterial,nombre,descripcion,estatus,categoria,existencia)"
								 + " VALUES("+idMaterial+",'"+txtNombre+"', '"+txtDescripcion+"', "+cmbEstatus+",'"+txtCategoria+"',0 )";
					st.execute(cade);
					respuesta.put("valido", true);
					respuesta.put("msj", "Registro incluido con exito!");
					respuesta.put("idmaterial", idMaterial);
					respuesta.put("nombrematerial", txtNombre);
				}else {
					respuesta.put("valido", false);
					respuesta.put("msj", MSJ_NO_PERMISO);
				}
			}else if(operacion==OPERACION_EDITAR){
				if(permisos.getPermiso(session, MODULO, PERMISO_TIPO_EDITAR)) {
					String idmaterial= request.getParameter("idmaterial")==null ? "0":request.getParameter("idmaterial").toString().trim();
					String txtNombre= request.getParameter("txtNombre").toString().trim();
					//String txtMarca= request.getParameter("txtMarca").toString().trim();
					String txtCategoria= request.getParameter("txtCategoria").toString().trim();
					String txtDescripcion= request.getParameter("txtDescripcion").toString().trim();
					String cmbEstatus= request.getParameter("cmbEstatus").toString().trim();
					
					String cade = "UPDATE material SET nombre = '"+txtNombre+"', descripcion = '"+txtDescripcion+"', estatus = "+cmbEstatus+", categoria='"+txtCategoria+"'" 
								 +" WHERE idmaterial = "+idmaterial;
					st.execute(cade);
					respuesta.put("valido", true);
					respuesta.put("msj", "Registro editado con exito!");
				}else {
					respuesta.put("valido", false);
					respuesta.put("msj", MSJ_NO_PERMISO);
				}
			}else if(operacion==OPERACION_ELIMINAR){
				if(permisos.getPermiso(session, MODULO, PERMISO_TIPO_ELIMINAR)) {
					String idmaterial= request.getParameter("idmaterial")==null ? "0":request.getParameter("idmaterial").toString().trim();
					st.execute("DELETE FROM material WHERE idmaterial = "+idmaterial);
					respuesta.put("valido", true);
					respuesta.put("msj", "Registro eliminado con exito!");
				}else {
					respuesta.put("valido", false);
					respuesta.put("msj", MSJ_NO_PERMISO);
				}
			}else if(operacion==OPERACION_CONSULTAR){
				if(permisos.getPermiso(session, MODULO, PERMISO_TIPO_CONSULTAR)) {
					String idmaterial= request.getParameter("idmaterial")==null ? "0":request.getParameter("idmaterial").toString().trim();
					int desdeSolicitud = request.getParameter("desdeSolicitud")==null ? 0:(Integer.valueOf(request.getParameter("desdeSolicitud")));
					int condicion = request.getParameter("condicion")==null ? 0:(Integer.valueOf(request.getParameter("condicion")));
					
					if(desdeSolicitud == 1) {
						rs = st.executeQuery("SELECT * FROM material where idmaterial = "+idmaterial);
						respuesta.clear();
						if(rs.next()) {
							respuesta.put("valido", true);
							respuesta.put("txtDisponible", rs.getDouble("existencia"));
							
						}
					}else {
						if(condicion == 1) {
							String nombreMaterial = request.getParameter("nombreMaterial").toString().trim();
							rs = st.executeQuery("SELECT * FROM material where nombre = '"+nombreMaterial+"'");
							respuesta.clear();
							if(rs.next()) {
								respuesta.put("valido", true);
								respuesta.put("idmaterial", rs.getLong("idmaterial"));
								respuesta.put("txtNombre", rs.getString("nombre").trim());
								//respuesta.put("txtMarca", rs.getString("marca").trim());
								respuesta.put("txtCategoria", rs.getString("categoria").trim());
								respuesta.put("txtDescripcion", rs.getString("descripcion").trim());
								respuesta.put("cmbEstatus", rs.getInt("estatus"));
								
							}else {
								respuesta.put("valido", false);
								respuesta.put("msj", "No existe un material con el id="+idmaterial);
							}
						}else { 
							rs = st.executeQuery("SELECT * FROM material where idmaterial = "+idmaterial);
							respuesta.clear();
							if(rs.next()) {
								respuesta.put("valido", true);
								respuesta.put("idmaterial", idmaterial);
								respuesta.put("txtNombre", rs.getString("nombre").trim());
								//respuesta.put("txtMarca", rs.getString("marca").trim());
								respuesta.put("txtCategoria", rs.getString("categoria").trim());
								respuesta.put("txtDescripcion", rs.getString("descripcion").trim());
								respuesta.put("cmbEstatus", rs.getInt("estatus"));
								respuesta.put("txtExistencia", rs.getDouble("existencia"));
								
							}else {
								respuesta.put("valido", false);
								respuesta.put("msj", "No existe un material con el id="+idmaterial);
							}
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
