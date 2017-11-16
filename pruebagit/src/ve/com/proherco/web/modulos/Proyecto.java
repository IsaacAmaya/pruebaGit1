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
@WebServlet("/Proyecto")
public class Proyecto extends HttpServlet implements Constantes {
	private static final long serialVersionUID = 1L;
	JSONObject respuesta = new JSONObject();
	Connection conexion;
	ConexionWeb conWeb = new ConexionWeb();
	HttpSession session;
	PermisosModulo permisos = new PermisosModulo();
	String MODULO = "proyecto";
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Proyecto() {
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
				int condicion = request.getParameter("condicion")==null ? 0:(Integer.valueOf(request.getParameter("condicion")));
				int desdeSolicitud = request.getParameter("desdeSolicitud")==null ? 0:(Integer.valueOf(request.getParameter("desdeSolicitud")));
				int listadoPrincipal = request.getParameter("listadoPrincipal")==null ? 0:(Integer.valueOf(request.getParameter("listadoPrincipal")));
				
				JSONArray data = new JSONArray();
				
				if(desdeSolicitud == 1) {
					String nombreproyecto= request.getParameter("nombreproyecto").toString().trim() ;
					System.out.print(nombreproyecto);
					String condicionWhere = "";
					if(nombreproyecto != "") {
						condicionWhere = "WHERE nombre LIKE '%"+nombreproyecto+"%'";
					}
					rs = st.executeQuery("SELECT * FROM proyecto "+condicionWhere);
					while (rs.next()) {
						JSONArray p = new JSONArray();
						p.add(rs.getLong("idproyecto"));
						p.add(rs.getString("nombre").trim());
						p.add(rs.getString("descripcion").trim());
						data.add(p);
					}
				}else if(condicion == 1) {
					rs = st.executeQuery("SELECT * FROM proyecto");
					while (rs.next()) {
							JSONObject p = new JSONObject();
							p.put("id",rs.getLong("idproyecto"));
							p.put("text",rs.getString("nombre").trim());
							data.add(p);
					}
				}else if(condicion==2){
					
					rs = st.executeQuery("SELECT * FROM proyecto ORDER BY idproyecto DESC");
					while (rs.next()) {
							JSONArray p = new JSONArray();
							p.add(rs.getLong("idproyecto"));
							p.add(rs.getString("nombre").trim());
							p.add(rs.getString("descripcion").trim());
							p.add(ValidaFormato.cambiarFecha(rs.getString("fechainicio").trim(), 2));
							p.add(rs.getInt("estatus"));
							data.add(p);
					}					
					
				}else{
					rs = st.executeQuery("SELECT * FROM proyecto");
					while (rs.next()) {
							JSONArray p = new JSONArray();
							p.add(rs.getLong("idproyecto"));
							p.add(rs.getString("nombre").trim());
							p.add(rs.getString("descripcion").trim());
							p.add(ValidaFormato.cambiarFecha(rs.getString("fechainicio").trim(), 2));
							p.add(rs.getInt("estatus"));
							data.add(p);
					}
				}
						
				respuesta.clear();
				respuesta.put("valido", true);
				respuesta.put("data", data);
			}else if(operacion==OPERACION_INCLUIR){
				
				String txtNombre= ValidaFormato.ucFirst(request.getParameter("txtNombre").toString().trim());
				String txtDireccion= request.getParameter("txtDireccion").toString().trim();
				String txtDescripcion= request.getParameter("txtDescripcion").toString().trim();
				String txtCoordenadas= request.getParameter("txtCoordenadas").toString().trim();
				String txtFechainicio= request.getParameter("txtFechainicio").toString().trim();
				String txtFechafinestimada= request.getParameter("txtFechafinestimada").toString().trim();
				String txtFechafin= request.getParameter("txtFechafin").toString().trim();
				String txtPresupuesto= request.getParameter("txtPresupuesto").toString().trim();
				txtPresupuesto = txtPresupuesto.replace(".", "").replace(",", ".");
				String cmbEstatus= request.getParameter("cmbEstatus").toString().trim();
				String cade = "INSERT INTO proyecto (nombre,direccion,descripcion,coordenadas,fechainicio,fechafinestimada,fechafin,presupuesto,estatus) VALUES('"+txtNombre+"', '"+txtDireccion+"', '"+txtDescripcion+"', '"+txtCoordenadas+"', '"+txtFechainicio+"', '"+txtFechafinestimada+"', "+(txtFechafin.equals("") ? "null":("'"+txtFechafin+"'"))+", "+txtPresupuesto+", "+cmbEstatus+" )";
				st.execute(cade);
				respuesta.put("valido", true);
				respuesta.put("msj", "Registro incluido con exito!");
			}else if(operacion==OPERACION_EDITAR){
				String idproyecto= request.getParameter("idproyecto")==null ? "0":request.getParameter("idproyecto").toString().trim();
				String txtNombre= ValidaFormato.ucFirst(request.getParameter("txtNombre").toString().trim());
				String txtDireccion= request.getParameter("txtDireccion").toString().trim();
				String txtDescripcion= request.getParameter("txtDescripcion").toString().trim();
				String txtCoordenadas= request.getParameter("txtCoordenadas").toString().trim();
				String txtFechainicio= request.getParameter("txtFechainicio").toString().trim();
				String txtFechafinestimada= request.getParameter("txtFechafinestimada").toString().trim();
				String txtFechafin= request.getParameter("txtFechafin").toString().trim();
				String txtPresupuesto= request.getParameter("txtPresupuesto").toString().trim();
				txtPresupuesto = txtPresupuesto.replace(".", "").replace(",", ".");
				String cmbEstatus= request.getParameter("cmbEstatus").toString().trim();
				
				
				String cade = "UPDATE proyecto SET nombre = '"+txtNombre+"', direccion = '"+txtDireccion+"', descripcion = '"+txtDescripcion+"', coordenadas = '"+txtCoordenadas+"', fechainicio = '"+txtFechainicio+"', fechafinestimada = '"+txtFechafinestimada+"', fechafin = "+(txtFechafin.equals("") ? "null":("'"+txtFechafin+"'"))+", presupuesto = "+txtPresupuesto+", estatus = "+cmbEstatus+" "
						 +" WHERE idproyecto = "+idproyecto;
				st.execute(cade);
				respuesta.put("valido", true);
				respuesta.put("msj", "Registro editado con exito!");
			}else if(operacion==OPERACION_ELIMINAR){
				String idproyecto= request.getParameter("idproyecto")==null ? "0":request.getParameter("idproyecto").toString().trim();
				st.execute("DELETE FROM proyecto WHERE idproyecto = "+idproyecto);
				respuesta.put("valido", true);
				respuesta.put("msj", "Registro eliminado con exito!");
			}else if(operacion==OPERACION_CONSULTAR){
				int consultarProyecto = request.getParameter("consultarProyecto")==null ? 0:(Integer.valueOf(request.getParameter("consultarProyecto")));
				String idproyecto= request.getParameter("idproyecto")==null ? "0":request.getParameter("idproyecto").toString().trim();
				String nombre= request.getParameter("nombre")==null ? "0":request.getParameter("nombre").toString().trim();
				
				if(consultarProyecto == 1) {
					rs = st.executeQuery("SELECT idproyecto,nombre,direccion,presupuesto,coordenadas,to_char(fechafinestimada, 'DD/MM/YYYY') as fechafinestimada,to_char(fechafin, 'DD/MM/YYYY') as fechafin,to_char(fechainicio,'DD/MM/YYYY') as fechainicio,descripcion,estatus FROM proyecto where nombre ='"+nombre+"'");
					respuesta.clear();
					if(rs.next()) {
						
						respuesta.put("valido", true);
						respuesta.put("idproyecto", rs.getLong("idproyecto"));
						respuesta.put("txtNombre", rs.getString("nombre"));
						respuesta.put("txtDireccion", rs.getString("direccion"));
						respuesta.put("txtDescripcion", rs.getString("descripcion"));
						respuesta.put("txtCoordenadas", rs.getString("coordenadas"));
						respuesta.put("txtFechainicio", rs.getString("fechainicio"));
						respuesta.put("txtFechafinestimada", rs.getString("fechafinestimada"));
						respuesta.put("txtFechafin", rs.getString("fechafin"));
						String presupuesto = String.valueOf(rs.getDouble("presupuesto"));
						respuesta.put("txtPresupuesto", ValidaFormato.formato(presupuesto));
						respuesta.put("cmbEstatus", rs.getString("estatus"));
					}
				}else {
					rs = st.executeQuery("SELECT idproyecto,nombre,direccion,presupuesto,coordenadas,to_char(fechafinestimada, 'DD/MM/YYYY') as fechafinestimada,to_char(fechafin, 'DD/MM/YYYY') as fechafin,to_char(fechainicio,'DD/MM/YYYY') as fechainicio,descripcion,estatus FROM proyecto where idproyecto ="+idproyecto);
					respuesta.clear();
					if(rs.next()) {
						
						respuesta.put("valido", true);
						respuesta.put("idproyecto", idproyecto);
						respuesta.put("txtNombre", rs.getString("nombre"));
						respuesta.put("txtDireccion", rs.getString("direccion"));
						respuesta.put("txtDescripcion", rs.getString("descripcion"));
						respuesta.put("txtCoordenadas", rs.getString("coordenadas"));
						respuesta.put("txtFechainicio", rs.getString("fechainicio"));
						respuesta.put("txtFechafinestimada", rs.getString("fechafinestimada"));
						respuesta.put("txtFechafin", rs.getString("fechafin"));
						String presupuesto = String.valueOf(rs.getDouble("presupuesto"));
						respuesta.put("txtPresupuesto", ValidaFormato.formato(presupuesto));
						respuesta.put("cmbEstatus", rs.getString("estatus"));
					}else {
						respuesta.put("valido", false);
						respuesta.put("msj", "No existe un proyecto con el id="+idproyecto);
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
