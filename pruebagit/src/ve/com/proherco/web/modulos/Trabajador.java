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
 * Servlet implementation class Trabajador
 */
@WebServlet("/Trabajador")
public class Trabajador extends HttpServlet implements Constantes {
	private static final long serialVersionUID = 1L;
	JSONObject respuesta = new JSONObject();
	Connection conexion;
	ConexionWeb conWeb = new ConexionWeb();
	HttpSession session;
	PermisosModulo permisos = new PermisosModulo();
	String MODULO = "trabajador";
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Trabajador() {
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
			
			if(operacion==OPERACION_LISTADO) {//NUEVA OPCION
				int desdeSolicitud = request.getParameter("desdeSolicitud")==null ? 0:(Integer.valueOf(request.getParameter("desdeSolicitud")));
				int desdeCuadrilla = request.getParameter("desdeCuadrilla")==null ? 0:(Integer.valueOf(request.getParameter("desdeCuadrilla")));
				JSONArray data = new JSONArray();
				if(desdeSolicitud==1) {
					rs = st.executeQuery("SELECT *,persona.nombre as nombre, persona.apellido as apellido,cargo.nombre as nombrecargo, cuadrilla.nombre as nombrecuadrilla "
							+ "FROM trabajador inner join persona on persona.idpersona=trabajador.idpersona inner join cargo on cargo.idcargo=trabajador.idcargo "
							+ "inner join cuadrilla on cuadrilla.idtrabajador=trabajador.idtrabajador");
					while (rs.next()) {
							JSONArray p = new JSONArray();
							p.add(rs.getLong("idtrabajador"));
							p.add(rs.getString("nombre").trim()+" "+rs.getString("apellido").trim());
							p.add(rs.getString("nombrecargo").trim());
							p.add(rs.getString("nombrecuadrilla").trim());
							p.add(ValidaFormato.cambiarFecha(rs.getString("fechaingreso").trim(), 2));
							p.add(rs.getString("cedula").trim());
							data.add(p);
					}	
					
					System.out.print("desde solicitud");
				}else if(desdeCuadrilla == 1) {
					rs = st.executeQuery("SELECT *,persona.nombre as nombre, persona.apellido as apellido,cargo.nombre as nombrecargo FROM " + 
							"trabajador inner join persona on persona.idpersona=trabajador.idpersona inner join cargo on " + 
							"cargo.idcargo=trabajador.idcargo left join cuadrilla on cuadrilla.idtrabajador=trabajador.idtrabajador where cuadrilla.idtrabajador is null");
					while (rs.next()) {
							JSONArray p = new JSONArray();
							p.add(rs.getLong("idtrabajador"));
							p.add(rs.getLong("cedula"));
							p.add(rs.getString("nombre").trim()+" "+rs.getString("apellido").trim());
							p.add(rs.getString("nombrecargo").trim());
							p.add(rs.getString("apodo").trim());
							p.add(ValidaFormato.cambiarFecha(rs.getString("fechaingreso").trim(), 2));
							data.add(p);
					}
					System.out.print("desde cuadrilla 1");
				}else if(desdeCuadrilla == 2) {
					String nombretrabajador= request.getParameter("nombretrabajador").toString().trim();
					String condicionWhere = "";
					if(nombretrabajador != "") {
						condicionWhere = " AND persona.nombre LIKE '%"+nombretrabajador+"%'";
					}
					rs = st.executeQuery("SELECT *,persona.nombre as nombrepersona, persona.apellido as apellido, cargo.nombre as nombrecargo FROM trabajador left join trabajadorcuadrilla on trabajador.idtrabajador=trabajadorcuadrilla.idtrabajador " + 
							"inner join cargo on cargo.idcargo=trabajador.idcargo inner join persona on persona.idpersona=trabajador.idpersona " + 
							"where trabajadorcuadrilla.idtrabajador is null"+condicionWhere);
					while (rs.next()) {
							JSONArray p = new JSONArray();
							p.add(rs.getLong("idtrabajador"));
							p.add(rs.getLong("cedula"));
							p.add(rs.getString("nombrepersona").trim()+" "+rs.getString("apellido").trim());
							p.add(rs.getString("nombrecargo").trim());
							p.add(rs.getString("apodo").trim());
							p.add(ValidaFormato.cambiarFecha(rs.getString("fechaingreso").trim(), 2));
							data.add(p);
					}
					System.out.print("desde cuadrilla 2");
				}else {
					rs = st.executeQuery("SELECT *,persona.nombre as nombre, persona.apellido as apellido,cargo.nombre as nombrecargo FROM trabajador inner join persona on persona.idpersona=trabajador.idpersona inner join cargo on cargo.idcargo=trabajador.idcargo");
					while (rs.next()) {
							JSONArray p = new JSONArray();
							p.add(rs.getLong("idtrabajador"));
							p.add(rs.getLong("cedula"));
							p.add(rs.getString("nombre").trim()+" "+rs.getString("apellido").trim());
							p.add(rs.getString("nombrecargo").trim());
							p.add(rs.getString("apodo").trim());
							p.add(ValidaFormato.cambiarFecha(rs.getString("fechaingreso").trim(), 2));
							data.add(p);
					}
					
					System.out.print("normal");
				}
							
				respuesta.clear();
				respuesta.put("valido", true);
				respuesta.put("data", data);
			}else if(operacion==OPERACION_INCLUIR){				
					//DATOS PERSONALES
				if(permisos.getPermiso(session, MODULO, PERMISO_TIPO_INCLUIR)) {
					String idpersona= request.getParameter("idpersona").toString().trim();
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
					String cmbEstatusPersona= request.getParameter("cmbEstatus").toString().trim();
					//DATOS DE TRABAJADOR
					String idcargo= request.getParameter("idcargo").toString().trim();
					String txtApodo= request.getParameter("txtApodo").toString().trim();
					String txtPantalon= request.getParameter("txtPantalon").toString().trim();
					String txtCamisa= request.getParameter("txtCamisa").toString().trim();
					String txtBotas= request.getParameter("txtBotas").toString().trim();
					String txtTiposangre= request.getParameter("txtTiposangre").toString().trim();
					//String txtLumbosacra= request.getParameter("txtLumbosacra").toString().trim();
					String txtFechaingreso= request.getParameter("txtFechaingreso").toString().trim();
					String txtCantidadhijo= request.getParameter("txtCantidadhijo")=="" ? "0":request.getParameter("txtCantidadhijo").toString().trim();
					String cmbEstatus= request.getParameter("cmbEstatus").toString().trim();
					//DATOS BANCARIOS
					
					String txtNombretitular= request.getParameter("txtNombretitular").toString().trim();
					String txtCedulatitular= request.getParameter("txtCedulatitular")=="" ? "0":request.getParameter("txtCedulatitular").toString().trim();
					String txtBanco= request.getParameter("txtBanco").toString().trim();
					String txtNumerocuenta= request.getParameter("txtNumerocuenta").toString().trim();
					String txtTipocuenta= request.getParameter("txtTipocuenta").toString().trim();
					
					if(idpersona=="") {//SI NO EXISTE LA PERSONA: REGISTRAMOS PRIMERO LA PESONA Y LUEGO EL TRABAJADOR
						String idPersona = "";
						rs = st.executeQuery("SELECT nextval('idpersona') as idpersona"); //CONSULTAMOS EL SIGUIENTE ID DE PERSONA
						if(rs.next()) {
							idPersona = rs.getString("idpersona");
						}
						String cadePersona = "INSERT INTO persona(idpersona,nombre,apellido,cedula,direccion,telefonomovil,telefonohabitacion,estatus,estadocivil,genero,email,fechanacimiento)"
								 + " VALUES("+idPersona+",'"+txtNombre+"', '"+txtApellido+"', "+txtCedula+", '"+txtDireccion+"', '"+txtTelefonomovil+"', '"+txtTelefonohabitacion+"', "+cmbEstatusPersona+", "+cmbEstadocivil+", "+cmbGenero+", '"+txtEmail+"' , "+(txtFechanacimiento.equals("") ? "null":("'"+txtFechanacimiento+"'"))+" )";
						st.execute(cadePersona);
						
						if(idcargo!="") {
							String cadeTrabajador = "INSERT INTO trabajador(idpersona,idcargo,apodo,pantalon,camisa,botas,tiposangre,fechaingreso,cantidadhijo,estatus,cedulatitular,nombretitular,banco,numerocuenta,tipocuenta)"
									 + " VALUES("+idPersona+", "+idcargo+",'"+txtApodo+"','"+txtPantalon+"','"+txtCamisa+"','"+txtBotas+"','"+txtTiposangre+"','"+txtFechaingreso+"',"+txtCantidadhijo+","+cmbEstatus+","+txtCedulatitular+",'"+txtNombretitular+"','"+txtBanco+"','"+txtNumerocuenta+"','"+txtTipocuenta+"')";
							System.out.print(cadeTrabajador);
							st.execute(cadeTrabajador);
						}
						
					}else {//SI EXISTE LA PERSONA ENTONCES REGISTRAMOS SOLO EL TRABAJADOR
						String cadeTrabajador = "INSERT INTO trabajador(idpersona,idcargo,apodo,pantalon,camisa,botas,tiposangre,fechaingreso,cantidadhijo,estatus,cedulatitular,nombretitular,banco,numerocuenta,tipocuenta)"
								 + " VALUES("+idpersona+","+idcargo+",'"+txtApodo+"','"+txtPantalon+"','"+txtCamisa+"','"+txtBotas+"','"+txtTiposangre+"','"+txtFechaingreso+"',"+txtCantidadhijo+","+cmbEstatus+","+txtCedulatitular+",'"+txtNombretitular+"','"+txtBanco+"','"+txtNumerocuenta+"','"+txtTipocuenta+"' )";
						st.execute(cadeTrabajador);
					}
					
					respuesta.put("valido", true);
					respuesta.put("msj", "Registro incluido con exito!");
				}else {
					respuesta.put("valido", false);
					respuesta.put("msj", MSJ_NO_PERMISO);
				}
			}else if(operacion==OPERACION_EDITAR){
				if(permisos.getPermiso(session, MODULO, PERMISO_TIPO_EDITAR)) {
					
					String idtrabajador= request.getParameter("idtrabajador")==null ? "0":request.getParameter("idtrabajador").toString().trim();
					String idpersona= request.getParameter("idpersona").toString().trim();
					String idcargo= request.getParameter("idcargo").toString().trim();
					String idcargoAux = request.getParameter("idcargoAux")==null ? "0":request.getParameter("idcargoAux").toString().trim();
					String txtApodo= request.getParameter("txtApodo").toString().trim();
					String txtPantalon= request.getParameter("txtPantalon").toString().trim();
					String txtCamisa= request.getParameter("txtCamisa").toString().trim();
					String txtBotas= request.getParameter("txtBotas").toString().trim();
					String txtTiposangre= request.getParameter("txtTiposangre").toString().trim();
					//String txtLumbosacra= request.getParameter("txtLumbosacra").toString().trim();
					String txtFechaingreso= request.getParameter("txtFechaingreso").toString().trim();
					String txtCantidadhijo= request.getParameter("txtCantidadhijo").toString().trim();
					String cmbEstatus= request.getParameter("cmbEstatus").toString().trim();
					
					String txtNombretitular= request.getParameter("txtNombretitular").toString().trim();
					String txtCedulatitular= request.getParameter("txtCedulatitular").toString().trim();
					String txtBanco= request.getParameter("txtBanco").toString().trim();
					String txtNumerocuenta= request.getParameter("txtNumerocuenta").toString().trim();
					String txtTipocuenta= request.getParameter("txtTipocuenta").toString().trim();
					
					//PERSONA
					
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
					
					String cade = "UPDATE trabajador SET idpersona = "+idpersona+", idcargo = "+(idcargo.equals("") ? (""+idcargoAux+""):(""+idcargo+""))+", apodo='"+txtApodo+"', pantalon = '"+txtPantalon+"', camisa = '"+txtCamisa+"', "
								 +" botas = '"+txtBotas+"', tiposangre = '"+txtTiposangre+"',  fechaingreso = '"+txtFechaingreso+"' , cantidadhijo = "+txtCantidadhijo+", estatus = "+cmbEstatus+", "
								 +" cedulatitular = "+txtCedulatitular+", nombretitular = '"+txtNombretitular+"', banco = '"+txtBanco+"', numerocuenta = '"+txtNumerocuenta+"', tipocuenta='"+txtTipocuenta+"'"
								 +" WHERE idtrabajador="+idtrabajador;
					System.out.print(cade);
					String cade2 = "UPDATE persona SET nombre = '"+txtNombre+"', apellido = '"+txtApellido+"', cedula = "+txtCedula+", direccion = '"+txtDireccion+"', telefonomovil = '"+txtTelefonomovil+"', "
							 +" telefonohabitacion = '"+txtTelefonohabitacion+"', estatus = "+cmbEstatus+", estadocivil = "+cmbEstadocivil+", genero = "+cmbGenero+", email = '"+txtEmail+"', fechanacimiento = "+(txtFechanacimiento.equals("") ? "null":("'"+txtFechanacimiento+"'"))+" "
							 +" WHERE idpersona = "+idpersona;
					
					st.execute(cade);
					st.execute(cade2);
					respuesta.put("valido", true);
					respuesta.put("msj", "Registro editado con exito!");
				}else {
					respuesta.put("valido", false);
					respuesta.put("msj", MSJ_NO_PERMISO);
				}
			}else if(operacion==OPERACION_ELIMINAR){
				if(permisos.getPermiso(session, MODULO, PERMISO_TIPO_ELIMINAR)) {
					String idtrabajador= request.getParameter("idtrabajador")==null ? "0":request.getParameter("idtrabajador").toString().trim();
					st.execute("DELETE FROM trabajador WHERE idtrabajador = "+idtrabajador);
					respuesta.put("valido", true);
					respuesta.put("msj", "Registro eliminado con exito!");
				}else {
					respuesta.put("valido", false);
					respuesta.put("msj", MSJ_NO_PERMISO);
				}
			}else if(operacion==OPERACION_CONSULTAR){
				if(permisos.getPermiso(session, MODULO, PERMISO_TIPO_CONSULTAR)) {
					String idtrabajador= request.getParameter("idtrabajador")==null ? "0":request.getParameter("idtrabajador").toString().trim();
					String idtrabajadorcuadrilla= request.getParameter("idtrabajadorcuadrilla")==null ? "0":request.getParameter("idtrabajadorcuadrilla").toString().trim();
					String cedula= request.getParameter("cedula")==null ? "0":request.getParameter("cedula").toString().trim();
					int desdeTrabajador = request.getParameter("desdeTrabajador")==null ? 0:(Integer.valueOf(request.getParameter("desdeTrabajador")));
					int desdePago = request.getParameter("desdePago")==null ? 0:(Integer.valueOf(request.getParameter("desdePago")));
					
					if(desdeTrabajador == 1) {
						rs = st.executeQuery("SELECT *, cargo.nombre as nombrecargo, persona.estatus as estatuspersona "
								+ "FROM trabajador inner join persona on persona.idpersona=trabajador.idpersona "
								+ "inner join cargo on cargo.idcargo=trabajador.idcargo where trabajador.idtrabajador = "+idtrabajador);
						respuesta.clear();
						if(rs.next()) {
							//DATOS DE TRABAJO
							respuesta.put("valido", true);
							respuesta.put("idtrabajador", idtrabajador);
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
							respuesta.put("txtFechanacimiento", rs.getString("fechanacimiento") == null ? "" : ValidaFormato.cambiarFecha(rs.getString("fechanacimiento").trim(), 2));
							respuesta.put("txtTelefonomovil", rs.getString("telefonomovil")==null ? "":rs.getString("telefonomovil").trim());
							respuesta.put("txtTelefonohabitacion", rs.getString("telefonohabitacion")==null ? "":rs.getString("telefonohabitacion").trim());
							respuesta.put("txtEmail", rs.getString("email")==null ? "":rs.getString("email").trim());
							respuesta.put("txtDireccion", rs.getString("direccion")==null ? "":rs.getString("direccion").trim());
							respuesta.put("cmbGenero", rs.getInt("genero"));
							respuesta.put("cmbEstadocivil", rs.getInt("estadocivil"));
							respuesta.put("cmbEstatusPersona", rs.getInt("estatuspersona"));
							
						}else {
							respuesta.put("valido", false);
							respuesta.put("msj", "No existe un trabajador con el id="+idtrabajador);
						}
					}else if(desdePago == 1){
						rs = st.executeQuery("SELECT trabajador.banco, trabajador.numerocuenta, trabajador.tipocuenta, trabajador.nombretitular, trabajador.cedulatitular, "+
								"trabajadorcuadrilla.idtrabajadorcuadrilla "+
								"FROM trabajador inner join trabajadorcuadrilla on "+
								"trabajadorcuadrilla.idtrabajador=trabajador.idtrabajador " +
								"where trabajadorcuadrilla.idtrabajadorcuadrilla= "+idtrabajadorcuadrilla);
						respuesta.clear();
						if(rs.next()) {
							//DAROS DE TRABAJO
							respuesta.put("valido", true);
							respuesta.put("banco", rs.getString("banco"));
							respuesta.put("numerocuenta", rs.getString("numerocuenta"));
							respuesta.put("tipocuenta", rs.getString("tipocuenta"));
							respuesta.put("titular", rs.getInt("cedulatitular")+" "+rs.getString("nombretitular"));
							respuesta.put("idtrabajadorcuadrilla", rs.getLong("idtrabajadorcuadrilla"));
							respuesta.put("titularNombreAux", rs.getString("nombretitular"));
							respuesta.put("titularCedulaAux", rs.getString("cedulatitular"));
						}
					}else {
						rs = st.executeQuery("SELECT *, cargo.nombre as nombrecargo, persona.estatus as estatuspersona, cuadrilla.nombre as nombrecuadrilla FROM "
								+ "trabajador inner join persona on persona.idpersona=trabajador.idpersona "
								+ "inner join cargo on cargo.idcargo=trabajador.idcargo "
								+ "inner join cuadrilla on cuadrilla.idtrabajador=trabajador.idtrabajador where persona.cedula = "+cedula);
						respuesta.clear();
						if(rs.next()) {
							//DAROS DE TRABAJO
							respuesta.put("valido", true);
							respuesta.put("idtrabajador", rs.getLong("idtrabajador"));
							respuesta.put("txtCedula", rs.getLong("cedula"));
							respuesta.put("txtNombre", rs.getString("nombre").trim());
							respuesta.put("txtApellido", rs.getString("apellido").trim());
							respuesta.put("txtNombrecuadrilla", rs.getString("nombrecuadrilla").trim());
							respuesta.put("txtCargo", rs.getString("nombrecargo").trim());
						}else {
							respuesta.put("valido", false);
							respuesta.put("msj", "No existe un whats con el id="+idtrabajador);
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
