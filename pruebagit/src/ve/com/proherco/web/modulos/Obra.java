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
 * Servlet implementation class Obra
 */
@WebServlet("/Obra")
public class Obra extends HttpServlet implements Constantes {
	private static final long serialVersionUID = 1L;
	JSONObject respuesta = new JSONObject();
	Connection conexion;
	ConexionWeb conWeb = new ConexionWeb();
	HttpSession session;
	PermisosModulo permisos = new PermisosModulo();
	String MODULO = "obras";
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Obra() {
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
				int condicion = request.getParameter("condicion")==null ? 0:(Integer.valueOf(request.getParameter("condicion")));
				int desdePrecio = request.getParameter("desdePrecio")==null ? 0:(Integer.valueOf(request.getParameter("desdePrecio")));
				String idproyecto= request.getParameter("idproyecto")==null ? "0":request.getParameter("idproyecto").toString().trim();
				JSONArray data = new JSONArray();
				
				if(condicion == 1) {
					rs = st.executeQuery("SELECT idtipoobra, idobra, nombre, descripcion FROM obra where idproyecto ="+idproyecto);
					while (rs.next()) {
							JSONObject p = new JSONObject();
							p.put("id",rs.getLong("idobra"));
							p.put("text",rs.getString("nombre").trim());
							data.add(p);
					}
				}else if(desdeSolicitud==1) {
					
					String nombreobra= ValidaFormato.ucFirst(request.getParameter("nombreobra").toString().trim()) ;
					System.out.print(nombreobra);
					String condicionWhere = "";
					if(nombreobra != "") {
						condicionWhere = " AND nombre LIKE '%"+nombreobra+"%'";
					}
					rs = st.executeQuery("SELECT idtipoobra, idobra, nombre, descripcion,idproyecto FROM obra where idproyecto ="+idproyecto+condicionWhere);
					while (rs.next()) {
							JSONArray p = new JSONArray();
							p.add(rs.getLong("idobra"));
							p.add(rs.getString("nombre").trim());
							p.add(rs.getString("descripcion").trim());
							p.add(rs.getLong("idtipoobra"));
							p.add(rs.getLong("idproyecto"));
							data.add(p);
					}
					System.out.print("entro aqui");
				}else if(desdePrecio == 1){
					
					rs = st.executeQuery("SELECT obra.idtipoobra, tipoobra.nombre FROM obra inner join proyecto on proyecto.idproyecto=obra.idproyecto inner join tipoobra on tipoobra.idtipoobra=obra.idtipoobra where obra.idproyecto="+idproyecto+" group by obra.idtipoobra, tipoobra.nombre");
					while (rs.next()) {
							JSONArray p = new JSONArray();
							p.add(rs.getLong("idtipoobra"));
							p.add(rs.getString("nombre").trim());
							data.add(p);
					}
				}else {
					rs = st.executeQuery("SELECT *,proyecto.nombre as nombrepro,tipoobra.nombre as nombreti FROM obra inner join proyecto on proyecto.idproyecto=obra.idproyecto inner join tipoobra on tipoobra.idtipoobra=obra.idtipoobra");
					while (rs.next()) {
							JSONArray p = new JSONArray();
							p.add(rs.getLong("idobra"));
							p.add(rs.getString("nombrepro"));
							p.add(rs.getString("nombreti"));
							p.add(rs.getString("nombre").trim());
							p.add(ValidaFormato.cambiarFecha(rs.getString("fechainicio").trim(), 2));
											
							data.add(p);
					}
				}
						
				respuesta.clear();
				respuesta.put("valido", true);
				respuesta.put("data", data);
			}else if(operacion==OPERACION_INCLUIR){
				String idproyecto= request.getParameter("idproyecto").toString().trim();
				String idtipoobra= request.getParameter("idtipoobra").toString().trim();
				String txtNombre= ValidaFormato.ucFirst(request.getParameter("txtNombre").toString().trim());
				String txtLote= request.getParameter("txtLote").toString().trim();
				String txtDescripcion= request.getParameter("txtDescripcion").toString().trim();
				//String txtPorcentaje= request.getParameter("txtPorcentaje").toString().trim();
				String txtFechainicio= request.getParameter("txtFechainicio").toString().trim();
				String txtFechafinestimada= request.getParameter("txtFechafinestimada").toString().trim();
				String txtFechafin= request.getParameter("txtFechafin").toString().trim();
				String cmbEstatus= request.getParameter("cmbEstatus").toString().trim();
				
				String cade = "INSERT INTO obra(idproyecto,idtipoobra,nombre,lote,descripcion,fechainicio,fechafinestimada,fechafin,estatus)"
							 + " VALUES("+idproyecto+", "+idtipoobra+", '"+txtNombre+"', '"+txtLote+"', '"+txtDescripcion+"', '"+txtFechainicio+"', '"+txtFechafinestimada+"', "+(txtFechafin.equals("") ? "null":("'"+txtFechafin+"'"))+", "+cmbEstatus+")";
				st.execute(cade);
				respuesta.put("valido", true);
				respuesta.put("msj", "Registro incluido con exito!");
			}else if(operacion==OPERACION_EDITAR){
				String idobra= request.getParameter("idobra")==null ? "0":request.getParameter("idobra").toString().trim();
				String idproyecto= request.getParameter("idproyecto").toString().trim();
				String idtipoobra= request.getParameter("idtipoobra").toString().trim();
				String txtNombre= ValidaFormato.ucFirst(request.getParameter("txtNombre").toString().trim());
				String txtLote= request.getParameter("txtLote").toString().trim();
				String txtDescripcion= request.getParameter("txtDescripcion").toString().trim();
				//String txtPorcentaje= request.getParameter("txtPorcentaje").toString().trim();
				String txtFechainicio= request.getParameter("txtFechainicio").toString().trim();
				String txtFechafinestimada= request.getParameter("txtFechafinestimada").toString().trim();
				String txtFechafin= request.getParameter("txtFechafin").toString().trim();
				String cmbEstatus= request.getParameter("cmbEstatus").toString().trim();
				
				String cade = "UPDATE obra SET idproyecto = "+idproyecto+", idtipoobra = "+idtipoobra+", nombre = '"+txtNombre+"', lote = '"+txtLote+"', descripcion = '"+txtDescripcion+"', "
							 +" fechainicio = '"+txtFechainicio+"', fechafinestimada = '"+txtFechafinestimada+"', fechafin = "+(txtFechafin.equals("") ? "null":("'"+txtFechafin+"'"))+", estatus = "+cmbEstatus+" WHERE idobra = "+idobra;
				st.execute(cade);
				respuesta.put("valido", true);
				respuesta.put("msj", "Registro editado con exito!");
			}else if(operacion==OPERACION_ELIMINAR){
				String idobra= request.getParameter("idobra")==null ? "0":request.getParameter("idobra").toString().trim();
				st.execute("DELETE FROM obra WHERE idobra = "+idobra);
				respuesta.put("valido", true);
				respuesta.put("msj", "Registro eliminado con exito!");
			}else if(operacion==OPERACION_CONSULTAR){
				int consultarObra = request.getParameter("consultarObra")==null ? 0:(Integer.valueOf(request.getParameter("consultarObra")));
				String idobra= request.getParameter("idobra")==null ? "0":request.getParameter("idobra").toString().trim();
				String idtipoobra= request.getParameter("idtipoobra")==null ? "0":request.getParameter("idtipoobra").toString().trim();
				String idproyecto= request.getParameter("idproyecto")==null ? "0":request.getParameter("idproyecto").toString().trim();
				String lote= request.getParameter("lote")==null ? "0":request.getParameter("lote").toString().trim();
				String nombre= request.getParameter("nombre")==null ? "0":request.getParameter("nombre").toString().trim();
				if(consultarObra == 1) {
					rs = st.executeQuery("SELECT *,proyecto.nombre as nombrepro,tipoobra.nombre as nombreti FROM obra inner join proyecto on proyecto.idproyecto=obra.idproyecto inner join tipoobra on "
							+ "tipoobra.idtipoobra=obra.idtipoobra where obra.idtipoobra="+idtipoobra+" and proyecto.idproyecto="+idproyecto+" and obra.nombre = '"+nombre+"'");
					respuesta.clear();
					if(rs.next()) {
						respuesta.put("valido", true);
						respuesta.put("idobra", rs.getLong("idobra"));
						respuesta.put("idproyecto", rs.getLong("idproyecto"));
						respuesta.put("txtDatosProyecto", rs.getString("nombrepro").trim());
						respuesta.put("txtDatosTipoobra", rs.getString("nombreti").trim());
						respuesta.put("idtipoobra", rs.getLong("idtipoobra"));
						respuesta.put("txtNombre", rs.getString("nombre").trim());
						respuesta.put("txtLote", rs.getString("lote").trim());
						respuesta.put("txtDescripcion", rs.getString("descripcion").trim());
						//respuesta.put("txtPorcentaje", rs.getDouble("porcentaje"));
						respuesta.put("txtFechainicio", ValidaFormato.cambiarFecha(rs.getString("fechainicio").trim(), 2));
						respuesta.put("txtFechafinestimada", ValidaFormato.cambiarFecha(rs.getString("fechafinestimada").trim(), 2));
						respuesta.put("txtFechafin", rs.getString("fechafin"));
						respuesta.put("cmbEstatus", rs.getInt("estatus"));					
					}	
				}else {
					rs = st.executeQuery("SELECT *,proyecto.nombre as nombrepro,tipoobra.nombre as nombreti FROM obra inner join proyecto on proyecto.idproyecto=obra.idproyecto inner join tipoobra on tipoobra.idtipoobra=obra.idtipoobra where idobra = "+idobra);
					respuesta.clear();
					if(rs.next()) {
						respuesta.put("valido", true);
						respuesta.put("idobra", idobra);
						respuesta.put("idproyecto", rs.getLong("idproyecto"));
						respuesta.put("txtDatosProyecto", rs.getString("nombrepro").trim());
						respuesta.put("txtDatosTipoobra", rs.getString("nombreti").trim());
						respuesta.put("idtipoobra", rs.getLong("idtipoobra"));
						respuesta.put("txtNombre", rs.getString("nombre").trim());
						respuesta.put("txtLote", rs.getString("lote").trim());
						respuesta.put("txtDescripcion", rs.getString("descripcion").trim());
						//respuesta.put("txtPorcentaje", rs.getDouble("porcentaje"));
						respuesta.put("txtFechainicio", ValidaFormato.cambiarFecha(rs.getString("fechainicio").trim(), 2));
						respuesta.put("txtFechafinestimada", ValidaFormato.cambiarFecha(rs.getString("fechafinestimada").trim(), 2));
						respuesta.put("txtFechafin", rs.getString("fechafin"));
						respuesta.put("cmbEstatus", rs.getInt("estatus"));					
					}else {
						respuesta.put("valido", false);
						respuesta.put("msj", "No existe una obra con el id="+idobra);
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
