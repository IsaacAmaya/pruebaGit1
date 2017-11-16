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
 * Servlet implementation class Cuadrilla
 */
@WebServlet("/Cuadrilla")
public class Cuadrilla extends HttpServlet implements Constantes {
	private static final long serialVersionUID = 1L;
	JSONObject respuesta = new JSONObject();
	Connection conexion;
	ConexionWeb conWeb = new ConexionWeb();
	HttpSession session;
	PermisosModulo permisos = new PermisosModulo();	
	String MODULO = "cuadrilla";
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Cuadrilla() {
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
				int desdePago = request.getParameter("desdePago")==null ? 0:(Integer.valueOf(request.getParameter("desdePago")));
				String idcuadrilla= request.getParameter("idcuadrilla")==null ? "0":request.getParameter("idcuadrilla").toString().trim();
				JSONArray data = new JSONArray();
				
				if(desdePago == 1) {
					rs = st.executeQuery("select cuadrilla.idcuadrilla, cuadrilla.nombre, persona.nombre as nombrepersona, persona.apellido from inspeccion " + 
							"inner join cuadrilla on cuadrilla.idcuadrilla=inspeccion.idcuadrilla " + 
							"left join detallepagoinspeccion on detallepagoinspeccion.idinspeccion=inspeccion.idinspeccion " + 
							"inner join trabajador on trabajador.idtrabajador=cuadrilla.idtrabajador inner join persona on " + 
							"persona.idpersona=trabajador.idpersona " + 
							"where detallepagoinspeccion.idinspeccion is null group by cuadrilla.idcuadrilla, cuadrilla.nombre, " + 
							"persona.nombre, persona.apellido");
					while (rs.next()) {
							JSONArray p = new JSONArray();
							p.add(rs.getLong("idcuadrilla"));
							p.add(rs.getString("nombre").trim());
							p.add(rs.getString("nombrepersona").trim()+" "+rs.getString("apellido").trim());
							data.add(p);
					}
					
				}else if(desdePago == 2) {
					String idpago= request.getParameter("idpago")==null ? "0":request.getParameter("idpago").toString().trim();
					rs = st.executeQuery("SELECT trabajadorcuadrilla.idtrabajadorcuadrilla, persona.nombre, persona.apellido,detallepagotrabajador.monto, " + 
							"detallepagotrabajador.modopago, detallepagotrabajador.referencia, detallepagotrabajador.iddetallepagotrabajador  FROM trabajadorcuadrilla " + 
							"inner join cuadrilla on cuadrilla.idcuadrilla=trabajadorcuadrilla.idcuadrilla " + 
							"inner join trabajador on trabajador.idtrabajador=trabajadorcuadrilla.idtrabajador inner join persona " + 
							"on persona.idpersona=trabajador.idpersona " + 
							"left join detallepagotrabajador on detallepagotrabajador.idtrabajadorcuadrilla=trabajadorcuadrilla.idtrabajadorcuadrilla "+
							"where cuadrilla.idcuadrilla="+idcuadrilla+" and detallepagotrabajador.idpago="+idpago);
					while (rs.next()) {
							JSONArray p = new JSONArray();
							p.add(rs.getLong("idtrabajadorcuadrilla"));
							p.add(rs.getString("nombre").trim()+" "+rs.getString("apellido").trim());							
							String monto = String.valueOf(rs.getDouble("monto"));
							p.add(ValidaFormato.formato(monto));						
							p.add(rs.getString("modopago"));
							p.add(rs.getString("referencia"));
							p.add(rs.getLong("iddetallepagotrabajador"));
							data.add(p);
					}
					
				}else {
					rs = st.executeQuery("SELECT *,persona.nombre as nombrepersona, persona.apellido as apellido FROM cuadrilla inner join trabajador on trabajador.idtrabajador=cuadrilla.idtrabajador inner join persona on persona.idpersona=trabajador.idpersona");
					while (rs.next()) {
							JSONArray p = new JSONArray();
							p.add(rs.getLong("idcuadrilla"));
							p.add(rs.getString("nombre").trim());
							p.add(rs.getString("nombrepersona").trim()+" "+rs.getString("apellido").trim());
							p.add(rs.getString("apodo").trim());
							p.add(rs.getString("descripcion").trim());
							p.add(rs.getInt("estatus"));					
							data.add(p);
					}
				}		
				respuesta.clear();
				respuesta.put("valido", true);
				respuesta.put("data", data);
			}else if(operacion==OPERACION_INCLUIR){
				if(permisos.getPermiso(session, MODULO, PERMISO_TIPO_INCLUIR)) {
					String idCuadrilla = "";
					rs = st.executeQuery("SELECT nextval('idcuadrilla') as idcuadrilla");
					if(rs.next()) {
						idCuadrilla = rs.getString("idcuadrilla");
					}
					String txtNombre= request.getParameter("txtNombre").toString().trim();
					String idtrabajador= request.getParameter("idtrabajador").toString().trim();
					String txtApodo= request.getParameter("txtApodo").toString().trim();
					String txtDescripcion= request.getParameter("txtDescripcion").toString().trim();
					String cmbEstatus= request.getParameter("cmbEstatus").toString().trim();								
					
					String cade = "INSERT INTO cuadrilla(idcuadrilla,nombre,apodo,descripcion,estatus,idtrabajador)"
								 + " VALUES("+idCuadrilla+",'"+txtNombre+"', '"+txtApodo+"', '"+txtDescripcion+"', "+cmbEstatus+", "+idtrabajador+")";
					//System.out.print(cade);
					st.execute(cade);
					
					String listaIntegrantesCuadrilla= request.getParameter("listaIntegrantesCuadrilla").toString().trim();
					
					if(listaIntegrantesCuadrilla!=""){
						String[] IntegrantesCuadrilla = listaIntegrantesCuadrilla.split(",");
						for (int i = 0; i < IntegrantesCuadrilla.length; i++) {
							String cade2 = "INSERT INTO trabajadorcuadrilla (idcuadrilla,idtrabajador,estatus) VALUES ("+idCuadrilla+", "+IntegrantesCuadrilla[i]+", 1)";
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
					int cambiarJefe = request.getParameter("cambiarJefe")==null ? 0:(Integer.valueOf(request.getParameter("cambiarJefe")));
					String idcuadrilla= request.getParameter("idcuadrilla")==null ? "0":request.getParameter("idcuadrilla").toString().trim();
					String idtrabajador= request.getParameter("idtrabajador").toString().trim();					
					
					if(cambiarJefe == 1) {
						String cade = "UPDATE cuadrilla SET idtrabajador = "+idtrabajador+" WHERE idcuadrilla="+idcuadrilla;
						st.execute(cade);
						
					}else {
						String txtNombre= request.getParameter("txtNombre").toString().trim();						
						String txtApodo= request.getParameter("txtApodo").toString().trim();
						String txtDescripcion= request.getParameter("txtDescripcion").toString().trim();
						String cmbEstatus= request.getParameter("cmbEstatus").toString().trim();
						/*String cade1 = "DELETE FROM trabajadorcuadrilla WHERE idcuadrilla = "+idcuadrilla;
						st.execute(cade1);
						
						String listaIntegrantesCuadrilla= request.getParameter("listaIntegrantesCuadrilla").toString().trim();
						if(listaIntegrantesCuadrilla!="") {
							String[] IntegrantesCuadrilla = listaIntegrantesCuadrilla.split(",");
							for (int i = 0; i < IntegrantesCuadrilla.length; i++) {
								String cade2 = "INSERT INTO trabajadorcuadrilla (idcuadrilla,idtrabajador,estatus) VALUES ("+idcuadrilla+", "+IntegrantesCuadrilla[i]+", 1)";
								st.execute(cade2);
							}
						}*/
						
						String cade = "UPDATE cuadrilla SET nombre = '"+txtNombre+"', idtrabajador = "+idtrabajador+", apodo = '"+txtApodo+"', "
								 +" descripcion = '"+txtDescripcion+"', estatus = "+cmbEstatus+" "
								 +" WHERE idcuadrilla = "+idcuadrilla;
						//System.out.print(cade);
						st.execute(cade);
					}
					
					
					respuesta.put("valido", true);
					respuesta.put("msj", "Registro editado con exito!");
				}else {
					respuesta.put("valido", false);
					respuesta.put("msj", MSJ_NO_PERMISO);
				}
			}else if(operacion==OPERACION_ELIMINAR){
				String idcuadrilla= request.getParameter("idcuadrilla")==null ? "0":request.getParameter("idcuadrilla").toString().trim();
				st.execute("DELETE FROM cuadrilla WHERE idcuadrilla = "+idcuadrilla);
				respuesta.put("valido", true);
				respuesta.put("msj", "Registro eliminado con exito!");
			}else if(operacion==OPERACION_CONSULTAR){
				String idcuadrilla= request.getParameter("idcuadrilla")==null ? "0":request.getParameter("idcuadrilla").toString().trim();
				String nombre= request.getParameter("nombre")==null ? "0":request.getParameter("nombre").toString().trim();
				int consultarCuadrilla = request.getParameter("consultarCuadrilla")==null ? 0:(Integer.valueOf(request.getParameter("consultarCuadrilla")));
				if(consultarCuadrilla == 1) {
					rs = st.executeQuery("SELECT *,persona.nombre as nombrepersona, persona.apellido as apellido FROM cuadrilla inner join trabajador on trabajador.idtrabajador=cuadrilla.idtrabajador inner join persona on persona.idpersona=trabajador.idpersona  where cuadrilla.nombre = '"+nombre+"'");
					respuesta.clear();
					if(rs.next()) {
						respuesta.put("valido", true);
						respuesta.put("idcuadrilla", rs.getLong("idcuadrilla"));
						respuesta.put("idtrabajador", rs.getLong("idtrabajador"));
						respuesta.put("txtNombre", rs.getString("nombre").trim());
						respuesta.put("txtDatosTrabajador", rs.getString("nombrepersona").trim()+" "+rs.getString("apellido").trim());
						respuesta.put("txtApodo", rs.getString("apodo").trim());
						respuesta.put("txtDescripcion", rs.getString("descripcion").trim());
						respuesta.put("cmbEstatus", rs.getInt("estatus"));
						
					}else {
						respuesta.put("valido", false);
						respuesta.put("msj", "No existe una persona con el id="+idcuadrilla);
					}
				}else {
					rs = st.executeQuery("SELECT *,persona.nombre as nombrepersona, persona.apellido as apellido FROM cuadrilla inner join trabajador on trabajador.idtrabajador=cuadrilla.idtrabajador inner join persona on persona.idpersona=trabajador.idpersona  where idcuadrilla = "+idcuadrilla);
					respuesta.clear();
					if(rs.next()) {
						respuesta.put("valido", true);
						respuesta.put("idcuadrilla", idcuadrilla);
						respuesta.put("idtrabajador", rs.getLong("idtrabajador"));
						respuesta.put("txtNombre", rs.getString("nombre").trim());
						respuesta.put("txtDatosTrabajador", rs.getString("nombrepersona").trim()+" "+rs.getString("apellido").trim());
						respuesta.put("txtApodo", rs.getString("apodo").trim());
						respuesta.put("txtDescripcion", rs.getString("descripcion").trim());
						respuesta.put("cmbEstatus", rs.getInt("estatus"));
						
					}else {
						respuesta.put("valido", false);
						respuesta.put("msj", "No existe una persona con el id="+idcuadrilla);
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
	
		
		//al final del metodo doGet debe ir la respuesta
		//-----------------------------
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
