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
 * Servlet implementation class Persona
 */
@WebServlet("/Persona")
public class Persona extends HttpServlet implements Constantes {
	private static final long serialVersionUID = 1L;
	JSONObject respuesta = new JSONObject();
	Connection conexion;
	ConexionWeb conWeb = new ConexionWeb();
	HttpSession session;
	PermisosModulo permisos = new PermisosModulo();
	String MODULO = "persona";
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Persona() {
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
				rs = st.executeQuery("SELECT * FROM persona");
				while (rs.next()) {
						JSONArray p = new JSONArray();
						p.add(rs.getLong("idpersona"));
						p.add(rs.getLong("cedula"));
						p.add(rs.getString("apellido").trim()+" "+rs.getString("nombre").trim());
						p.add(rs.getString("telefonohabitacion").trim()+" / "+rs.getString("telefonomovil").trim());
						//p.add(rs.getString("telefonohabitacion")==null ? "": rs.getString("telefonomovil").trim());
									
						data.add(p);
				}			
				respuesta.clear();
				respuesta.put("valido", true);
				respuesta.put("data", data);
				
			}else if(operacion==OPERACION_LISTADO_SOLO_PERSONAS) {
				JSONArray data = new JSONArray();
				rs = st.executeQuery("SELECT * FROM persona left join trabajador on persona.idpersona=trabajador.idpersona WHERE trabajador.idtrabajador IS NULL");
				while (rs.next()) {
						JSONArray p = new JSONArray();
						p.add(rs.getLong("idpersona"));
						p.add(rs.getLong("cedula"));
						p.add(rs.getString("nombre").trim());
						p.add(rs.getString("apellido").trim());
						p.add(rs.getString("telefonohabitacion").trim()+" / "+rs.getString("telefonomovil").trim());
						//p.add(rs.getString("telefonohabitacion")==null ? "": rs.getString("telefonomovil").trim());
									
						data.add(p);
				}
				respuesta.clear();
				respuesta.put("valido", true);
				respuesta.put("data", data);
			}else if(operacion==OPERACION_INCLUIR){
				if(permisos.getPermiso(session, MODULO, PERMISO_TIPO_INCLUIR)) {
					String txtCedula= request.getParameter("txtCedula").toString().trim();
					String txtNombre= request.getParameter("txtNombre").toString().trim();
					String txtApellido= request.getParameter("txtApellido").toString().trim();
					String txtFechanacimiento= request.getParameter("txtFechanacimiento").toString().trim();
					String cmbGenero= request.getParameter("cmbGenero").toString().trim();
					String cmbEstadocivil= request.getParameter("cmbEstadocivil").toString().trim();
					String txtTelefonomovil= request.getParameter("txtTelefonomovil").toString().trim();
					String txtTelefonohabitacion= request.getParameter("txtTelefonohabitacion").toString().trim();
					String txtEmail= request.getParameter("txtEmail").toString().trim();
					String txtDireccion= request.getParameter("txtDireccion").toString().trim();
					String cmbEstatus= request.getParameter("cmbEstatus").toString().trim();
					
					String cade = "INSERT INTO persona(nombre,apellido,cedula,direccion,telefonomovil,telefonohabitacion,estatus,estadocivil,genero,email,fechanacimiento)"
								 + " VALUES('"+txtNombre+"', '"+txtApellido+"', "+txtCedula+", '"+txtDireccion+"', '"+txtTelefonomovil+"', '"+txtTelefonohabitacion+"', "+cmbEstatus+", "+cmbEstadocivil+", "+cmbGenero+", '"+txtEmail+"' ,'"+txtFechanacimiento+"' )";
					st.execute(cade);
					respuesta.put("valido", true);
					respuesta.put("msj", "Registro incluido con exito!");
				}else {
					respuesta.put("valido", false);
					respuesta.put("msj", MSJ_NO_PERMISO);
				}
			}else if(operacion==OPERACION_EDITAR){
				if(permisos.getPermiso(session, MODULO, PERMISO_TIPO_EDITAR)) {
					String idpersona= request.getParameter("idpersona")==null ? "0":request.getParameter("idpersona").toString().trim();
					String txtCedula= request.getParameter("txtCedula").toString().trim();
					String txtNombre= request.getParameter("txtNombre").toString().trim();
					String txtApellido= request.getParameter("txtApellido").toString().trim();
					String txtFechanacimiento= request.getParameter("txtFechanacimiento").toString().trim();
					String cmbGenero= request.getParameter("cmbGenero").toString().trim();
					String cmbEstadocivil= request.getParameter("cmbEstadocivil").toString().trim();
					String txtTelefonomovil= request.getParameter("txtTelefonomovil").toString().trim();
					String txtTelefonohabitacion= request.getParameter("txtTelefonohabitacion").toString().trim();
					String txtEmail= request.getParameter("txtEmail").toString().trim();
					String txtDireccion= request.getParameter("txtDireccion").toString().trim();
					String cmbEstatus= request.getParameter("cmbEstatus").toString().trim();
					
					String cade = "UPDATE persona SET nombre = '"+txtNombre+"', apellido = '"+txtApellido+"', cedula = "+txtCedula+", direccion = '"+txtDireccion+"', telefonomovil = '"+txtTelefonomovil+"', "
								 +" telefonohabitacion = '"+txtTelefonohabitacion+"', estatus = "+cmbEstatus+", estadocivil = "+cmbEstadocivil+", genero = "+cmbGenero+", email = '"+txtEmail+"', fechanacimiento = '"+txtFechanacimiento+"' "
								 +" WHERE idpersona = "+idpersona;
					st.execute(cade);
					respuesta.put("valido", true);
					respuesta.put("msj", "Registro editado con exito!");
				}else {
					respuesta.put("valido", false);
					respuesta.put("msj", MSJ_NO_PERMISO);
				}
			}else if(operacion==OPERACION_ELIMINAR){
				if(permisos.getPermiso(session, MODULO, PERMISO_TIPO_ELIMINAR)) {
					String idpersona= request.getParameter("idpersona")==null ? "0":request.getParameter("idpersona").toString().trim();
					st.execute("DELETE FROM persona WHERE idpersona = "+idpersona);
					respuesta.put("valido", true);
					respuesta.put("msj", "Registro eliminado con exito!");
				}else {
					respuesta.put("valido", false);
					respuesta.put("msj", MSJ_NO_PERMISO);
				}
			}else if(operacion==OPERACION_CONSULTAR){
				if(permisos.getPermiso(session, MODULO, PERMISO_TIPO_CONSULTAR)) {
					String idpersona= request.getParameter("idpersona")==null ? "0":request.getParameter("idpersona").toString().trim();
					String cedula= request.getParameter("cedula")==null ? "0":request.getParameter("cedula").toString().trim();
					int consultarCedula = request.getParameter("consultarCedula")==null ? 0:(Integer.valueOf(request.getParameter("consultarCedula")));
					int desdeUsuario = request.getParameter("desdeUsuario")==null ? 0:(Integer.valueOf(request.getParameter("desdeUsuario")));
					
					if(consultarCedula == 1) {
						rs = st.executeQuery("SELECT * FROM persona where cedula = "+cedula);
						respuesta.clear();
						if(rs.next()) {
							respuesta.put("valido", true);
							respuesta.put("idpersona", idpersona);
							respuesta.put("txtCedula", rs.getLong("cedula"));
							respuesta.put("txtNombre", rs.getString("nombre").trim());
							respuesta.put("txtApellido", rs.getString("apellido").trim());
							String fecha = rs.getString("fechanacimiento")==null ? "":rs.getString("fechanacimiento").trim();
							if(fecha!="") {
								respuesta.put("txtFechanacimiento", ValidaFormato.cambiarFecha(fecha, 2));
							}else {
								respuesta.put("txtFechanacimiento", "");
							}
							respuesta.put("txtTelefonomovil", rs.getString("telefonomovil")==null ? "":rs.getString("telefonomovil").trim());
							respuesta.put("txtTelefonohabitacion", rs.getString("telefonohabitacion")==null ? "":rs.getString("telefonohabitacion").trim());
							respuesta.put("txtEmail", rs.getString("email")==null ? "":rs.getString("email").trim());
							respuesta.put("txtDireccion", rs.getString("direccion")==null ? "":rs.getString("direccion").trim());
		
							respuesta.put("cmbGenero", rs.getInt("genero"));
							respuesta.put("cmbEstadocivil", rs.getInt("estadocivil"));
							respuesta.put("cmbEstatus", rs.getInt("estatus"));
							
						}
						
					}else if(desdeUsuario == 1){
						String idusuario= request.getParameter("usuario")==null ? "0":request.getParameter("usuario").toString().trim();
						String clave= request.getParameter("clave")==null ? "0":request.getParameter("clave").toString().trim();
						rs = st.executeQuery("SELECT * FROM usuarios where idusuario = "+idusuario+" and clave='"+clave+"'");
						respuesta.clear();
						if(rs.next()) {
							respuesta.put("valido", true);
						}
					}else if(desdeUsuario == 2){
						String idusuario= request.getParameter("usuario")==null ? "0":request.getParameter("usuario").toString().trim();
						String clave= request.getParameter("clave")==null ? "0":request.getParameter("clave").toString().trim();
						String cade = "UPDATE usuarios SET clave = '"+clave+"' WHERE idusuario = "+idusuario;
						st.execute(cade);
						respuesta.put("valido", true);
						//respuesta.put("msj", "Registro editado con exito!");
							
					}else {
						rs = st.executeQuery("SELECT * FROM persona where idpersona = "+idpersona);
						respuesta.clear();
						if(rs.next()) {
							respuesta.put("valido", true);
							respuesta.put("idpersona", idpersona);
							respuesta.put("txtCedula", rs.getLong("cedula"));
							respuesta.put("txtNombre", rs.getString("nombre").trim());
							respuesta.put("txtApellido", rs.getString("apellido").trim());
							String fecha = rs.getString("fechanacimiento")==null ? "":rs.getString("fechanacimiento").trim();
							if(fecha!="") {
								respuesta.put("txtFechanacimiento", ValidaFormato.cambiarFecha(fecha, 2));
							}else {
								respuesta.put("txtFechanacimiento", "");
							}
							
							respuesta.put("txtTelefonomovil", rs.getString("telefonomovil")==null ? "":rs.getString("telefonomovil").trim());
							respuesta.put("txtTelefonohabitacion", rs.getString("telefonohabitacion")==null ? "":rs.getString("telefonohabitacion").trim());
							respuesta.put("txtEmail", rs.getString("email")==null ? "":rs.getString("email").trim());
							respuesta.put("txtDireccion", rs.getString("direccion")==null ? "":rs.getString("direccion").trim());
		
							respuesta.put("cmbGenero", rs.getInt("genero"));
							respuesta.put("cmbEstadocivil", rs.getInt("estadocivil"));
							respuesta.put("cmbEstatus", rs.getInt("estatus"));
							
						}else {
							respuesta.put("valido", false);
							respuesta.put("msj", "No existe una persona con el id="+idpersona);
						}
					}
					
				}else {
					respuesta.put("valido", false);
					respuesta.put("msj", MSJ_NO_PERMISO);
				}
			}else if(operacion==OPERACION_CONSULTAR_CEDULA){
				String cedula= request.getParameter("cedula")==null ? "0":request.getParameter("cedula").toString().trim();
				rs = st.executeQuery("SELECT *, persona.estatus as estatuspersona FROM persona inner join trabajador on trabajador.idpersona=persona.idpersona WHERE cedula = "+cedula);
				respuesta.clear();				
				if(rs.next()) {
					respuesta.put("valido", true);
					//DATOS DE TRABAJADOR
					respuesta.put("idtrabajador", rs.getLong("idtrabajador"));
					respuesta.put("idpersona", rs.getLong("idpersona"));
					respuesta.put("idcargo", rs.getLong("idcargo"));
					respuesta.put("txtApodo", rs.getString("apodo").trim());
					respuesta.put("txtPantalon", rs.getString("pantalon").trim());
					respuesta.put("txtCamisa", rs.getString("camisa").trim());
					respuesta.put("txtBotas", rs.getString("botas").trim());
					respuesta.put("txtTiposangre", rs.getString("tiposangre").trim());
					//respuesta.put("txtLumbosacra", rs.getString("lumbosacra").trim());
					respuesta.put("txtFechaingreso", ValidaFormato.cambiarFecha(rs.getString("fechaingreso").trim(), 2));
					respuesta.put("txtCantidadhijo", rs.getString("cantidadhijo").trim());
					respuesta.put("cmbEstatus", rs.getInt("estatus"));
					
					respuesta.put("txtNombretitular", rs.getString("nombretitular").trim());
					respuesta.put("txtCedulatitular", rs.getLong("cedulatitular"));
					
					respuesta.put("txtBanco", rs.getString("banco").trim());
					respuesta.put("txtNumerocuenta", rs.getString("numerocuenta").trim());
					respuesta.put("txtTipocuenta", rs.getString("tipocuenta").trim());
					//DATOS PERSONALES
					respuesta.put("txtCedula", rs.getLong("cedula"));
					respuesta.put("txtNombre", rs.getString("nombre").trim());
					respuesta.put("txtApellido", rs.getString("apellido").trim());
					String fecha = rs.getString("fechanacimiento")==null ? "":rs.getString("fechanacimiento").trim();
					if(fecha!="") {
						respuesta.put("txtFechanacimiento", ValidaFormato.cambiarFecha(fecha, 2));
					}else {
						respuesta.put("txtFechanacimiento", "");
					}
					respuesta.put("txtTelefonomovil", rs.getString("telefonomovil")==null ? "":rs.getString("telefonomovil").trim());
					respuesta.put("txtTelefonohabitacion", rs.getString("telefonohabitacion")==null ? "":rs.getString("telefonohabitacion").trim());
					respuesta.put("txtEmail", rs.getString("email")==null ? "":rs.getString("email").trim());
					respuesta.put("txtDireccion", rs.getString("direccion")==null ? "":rs.getString("direccion").trim());
					respuesta.put("cmbGenero", rs.getInt("genero"));
					respuesta.put("cmbEstadocivil", rs.getInt("estadocivil"));
					respuesta.put("cmbEstatusPersona", rs.getInt("estatuspersona"));
					respuesta.put("valido", true);
					respuesta.put("msj", "Ya esta registrado este trabajador!");
				}else {
					rs = st.executeQuery("SELECT * FROM persona WHERE cedula = "+cedula);
					respuesta.clear();
					if(rs.next()) {
						respuesta.put("txtCedula", cedula);
						respuesta.put("idpersona", rs.getLong("idpersona"));
						respuesta.put("txtNombre", rs.getString("nombre").trim());
						respuesta.put("txtApellido", rs.getString("apellido").trim());
						respuesta.put("txtFechanacimiento", ValidaFormato.cambiarFecha(rs.getString("fechanacimiento").trim(), 2));
						respuesta.put("txtTelefonomovil", rs.getString("telefonomovil")==null ? "":rs.getString("telefonomovil").trim());
						respuesta.put("txtTelefonohabitacion", rs.getString("telefonohabitacion")==null ? "":rs.getString("telefonohabitacion").trim());
						respuesta.put("txtEmail", rs.getString("email")==null ? "":rs.getString("email").trim());
						respuesta.put("txtDireccion", rs.getString("direccion")==null ? "":rs.getString("direccion").trim());
						respuesta.put("cmbGenero", rs.getInt("genero"));
						respuesta.put("cmbEstadocivil", rs.getInt("estadocivil"));
						respuesta.put("cmbEstatusPersona", rs.getInt("estatus"));
						respuesta.put("valido", true);
						respuesta.put("msj", "Ya existe este registro!");
					}
					/*respuesta.put("valido", false);
					respuesta.put("msj", "No existe una persona con la cedula="+cedula);*/
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
