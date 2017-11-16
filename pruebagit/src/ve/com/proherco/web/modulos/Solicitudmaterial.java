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
 * Servlet implementation class Solicitudmaterial
 */
@WebServlet("/Solicitudmaterial")
public class Solicitudmaterial extends HttpServlet implements Constantes {
	private static final long serialVersionUID = 1L;
	JSONObject respuesta = new JSONObject();
	Connection conexion;
	ConexionWeb conWeb = new ConexionWeb();
	HttpSession session;
	PermisosModulo permisos = new PermisosModulo();
	String MODULO = "solicitudmaterial";
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Solicitudmaterial() {
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
				int desdeDespacho = request.getParameter("desdeDespacho")==null ? 0:(Integer.valueOf(request.getParameter("desdeDespacho")));
				int desdeMaterial = request.getParameter("desdeMaterial")==null ? 0:(Integer.valueOf(request.getParameter("desdeMaterial")));
				JSONArray data = new JSONArray();
				if(desdeMaterial == 1) {
					String idmaterial= request.getParameter("idmaterial")==null ? "0":request.getParameter("idmaterial").toString().trim();
					rs = st.executeQuery("SELECT * FROM detallesolicitud inner join solicitudmaterial on solicitudmaterial.idsolicitudmaterial=detallesolicitud.idsolicitudmaterial WHERE idmaterial="+idmaterial+" AND solicitudmaterial.estatus=1 ORDER BY fechadespacho");
					while (rs.next()) {
							JSONArray p = new JSONArray();
							p.add(ValidaFormato.cambiarFecha(rs.getString("fechadespacho").trim(), 2));
							p.add(rs.getDouble("cantidad"));
							p.add(rs.getLong("idsolicitudmaterial"));
							data.add(p);
					}
				}else {
					if(desdeDespacho==1) {
						rs = st.executeQuery("SELECT solicitudmaterial.estatus,idsolicitudmaterial,obra.nombre as nombreobra,subetapa.nombre as nombresubetapa, persona.nombre as nombrepersona, persona.apellido " + 
								"FROM solicitudmaterial inner join trabajador on trabajador.idtrabajador=solicitudmaterial.idtrabajador inner join  " + 
								"persona on persona.idpersona=trabajador.idpersona inner join subetapa on subetapa.idsubetapa=solicitudmaterial.idsubetapa " + 
								"inner join obra on obra.idobra=solicitudmaterial.idobra where solicitudmaterial.estatus = '0' or solicitudmaterial.estatus = '1' ");
						while (rs.next()) {
								JSONArray p = new JSONArray();
								p.add(rs.getLong("idsolicitudmaterial"));
								p.add(rs.getString("nombrepersona").trim()+" "+rs.getString("apellido").trim());
								p.add(rs.getString("nombreobra").trim());
								p.add(rs.getString("nombresubetapa").trim());
								Integer EstatusI = rs.getInt("estatus");
								String EstatusS = "<span style='color:#FA8258;font-weight:bold;'>Pendiente por despachar</span>";
								if(EstatusI == 1) {
									EstatusS = "Despachado";
								}
								p.add(EstatusS);
								data.add(p);
						}	
					}else {
						rs = st.executeQuery("SELECT solicitudmaterial.observacion,solicitudmaterial.estatus,idsolicitudmaterial,obra.nombre as nombreobra,subetapa.nombre as nombresubetapa, persona.nombre as nombrepersona, persona.apellido " + 
								"FROM solicitudmaterial inner join trabajador on trabajador.idtrabajador=solicitudmaterial.idtrabajador inner join  " + 
								"persona on persona.idpersona=trabajador.idpersona inner join subetapa on subetapa.idsubetapa=solicitudmaterial.idsubetapa " + 
								"inner join obra on obra.idobra=solicitudmaterial.idobra where solicitudmaterial.estatus = '0' or solicitudmaterial.estatus = '2' ");
						while (rs.next()) {
								JSONArray p = new JSONArray();
								p.add(rs.getLong("idsolicitudmaterial"));
								p.add(rs.getString("nombrepersona").trim()+" "+rs.getString("apellido").trim());
								p.add(rs.getString("nombreobra").trim());
								p.add(rs.getString("nombresubetapa").trim());
								Integer EstatusI = rs.getInt("estatus");
								String EstatusS = "<span style='color:#FA8258;font-weight:bold;'>Pendiente por despachar</span>";
								if(EstatusI == 2) {
									EstatusS = "<span style='color:#FA8258;font-weight:bold;' title='"+rs.getString("observacion").trim()+"'>Rechazado</span>";
								}
								p.add(EstatusS);
								data.add(p);
						}
					}
				}
				
						
				respuesta.clear();
				respuesta.put("valido", true);
				respuesta.put("data", data);
			}else if(operacion==OPERACION_INCLUIR){
				if(permisos.getPermiso(session, MODULO, PERMISO_TIPO_INCLUIR)) {
					String idSolicitudmaterial = "";
					rs = st.executeQuery("SELECT nextval('idsolicitudmaterial') as idsolicitudmaterial");
					if(rs.next()) {
						idSolicitudmaterial = rs.getString("idSolicitudmaterial");
					}
					String idobra= request.getParameter("idobra").toString().trim();
					String idtrabajador= request.getParameter("idtrabajador").toString().trim();
					String idsubetapa= request.getParameter("idsubetapa").toString().trim();
					String txtFechasolicitud= request.getParameter("txtFechasolicitud").toString().trim();
					
					String cade = "INSERT INTO solicitudmaterial (idsolicitudmaterial, fechasolicitud, idobra, idsubetapa, idtrabajador, estatus)"
								 + " VALUES("+idSolicitudmaterial+", '"+txtFechasolicitud+"', "+idobra+", "+idsubetapa+", "+idtrabajador+", 0)";
					st.execute(cade);
					
					String listaMaterial= request.getParameter("listaMaterial").toString().trim();
					String listaCantidad= request.getParameter("listaCantidad").toString().trim();
					if(listaMaterial!="") {
						String[] Material = listaMaterial.split(",");
						String[] Cantidad = listaCantidad.split(",");
						for (int i = 0; i < Material.length; i++) {
							String cade2 = "INSERT INTO detallesolicitud (idsolicitudmaterial, idmaterial, cantidad) VALUES ("+idSolicitudmaterial+", "+Material[i]+", "+Cantidad[i]+")";
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
					String idsolicitudmaterial= request.getParameter("idsolicitudmaterial")==null ? "0":request.getParameter("idsolicitudmaterial").toString().trim();
					int condicion = request.getParameter("condicion")==null ? 0:(Integer.valueOf(request.getParameter("condicion")));
					String txtEstatus= request.getParameter("txtEstatus").toString().trim();
					String cade = "";
					
					if(condicion == 1) {
						String txtPlaca= request.getParameter("txtPlaca").toString().trim();
						String txtMarca= request.getParameter("txtMarca").toString().trim();
						String txtModelo= request.getParameter("txtModelo").toString().trim();
						String txtChofer= request.getParameter("txtChofer").toString().trim();
						String txtResponsable= request.getParameter("txtResponsable").toString().trim();
						String txtFechadespacho= request.getParameter("txtFechadespacho").toString().trim();
						
						String listaMaterial= request.getParameter("listaMaterial").toString().trim();
						String listaCantidad= request.getParameter("listaCantidad").toString().trim();
						
						if(listaMaterial!="") {
							String[] Material = listaMaterial.split(",");
							String[] Cantidad = listaCantidad.split(",");
							for (int i = 0; i < Material.length; i++) {
								rs = st.executeQuery("SELECT * FROM material WHERE idmaterial = "+Material[i]);//CONSULTAMOS LA EXISTENCIA ACTUAL DEL MATERIAL
								Integer existencia = 0;
								if(rs.next()) {
									existencia = rs.getInt("existencia");
								}
								Integer resul = existencia-Integer.valueOf(Cantidad[i]);
								String cadeMaterial = "UPDATE material SET existencia = "+resul+" WHERE idmaterial="+Material[i];
								st.execute(cadeMaterial);
							}
						}
						cade = "UPDATE solicitudmaterial SET placa='"+txtPlaca+"', marca='"+txtMarca+"', modelo='"+txtModelo+"', chofer='"+txtChofer+"', retiradopor='"+txtResponsable+"', estatus="+txtEstatus+", fechadespacho='"+txtFechadespacho+"' WHERE idsolicitudmaterial = "+idsolicitudmaterial;
					}
					
					if(condicion == 2) {
						String idobra= request.getParameter("idobra").toString().trim();
						String idtrabajador= request.getParameter("idtrabajador").toString().trim();
						String idsubetapa= request.getParameter("idsubetapa").toString().trim();
						String txtFechasolicitud= request.getParameter("txtFechasolicitud").toString().trim();					
						
						cade = "UPDATE solicitudmaterial SET fechasolicitud='"+txtFechasolicitud+"', idobra="+idobra+", idsubetapa="+idsubetapa+", idtrabajador="+idtrabajador+", estatus="+txtEstatus+", observacion=null WHERE idsolicitudmaterial = "+idsolicitudmaterial;
					}				
					
					if(condicion == 3){
						String txtObservacion= request.getParameter("txtObservacion").toString().trim();
						cade = "UPDATE solicitudmaterial SET placa=null , marca=null, modelo=null, chofer=null, retiradopor=null, estatus="+txtEstatus+", fechadespacho=null, observacion='"+txtObservacion+"' WHERE idsolicitudmaterial = "+idsolicitudmaterial;
					}
					
					if(condicion == 4) {
						String txtPlaca= request.getParameter("txtPlaca").toString().trim();
						String txtMarca= request.getParameter("txtMarca").toString().trim();
						String txtModelo= request.getParameter("txtModelo").toString().trim();
						String txtChofer= request.getParameter("txtChofer").toString().trim();
						String txtResponsable= request.getParameter("txtResponsable").toString().trim();
										
						cade = "UPDATE solicitudmaterial SET placa='"+txtPlaca+"', marca='"+txtMarca+"', modelo='"+txtModelo+"', chofer='"+txtChofer+"', retiradopor='"+txtResponsable+"' WHERE idsolicitudmaterial = "+idsolicitudmaterial;
					}
					
					st.execute(cade);
					respuesta.put("valido", true);
					respuesta.put("msj", "Registro editado con exito!");
				}else {
					respuesta.put("valido", false);
					respuesta.put("msj", MSJ_NO_PERMISO);
				}
			}else if(operacion==OPERACION_ELIMINAR){
				if(permisos.getPermiso(session, MODULO, PERMISO_TIPO_ELIMINAR)) {
					String idsolicitudmaterial= request.getParameter("idsolicitudmaterial")==null ? "0":request.getParameter("idsolicitudmaterial").toString().trim();
					st.execute("DELETE FROM solicitudmaterial WHERE idsolicitudmaterial = "+idsolicitudmaterial);
					respuesta.put("valido", true);
					respuesta.put("msj", "Registro eliminado con exito!");
				}else {
					respuesta.put("valido", false);
					respuesta.put("msj", MSJ_NO_PERMISO);
				}
			}else if(operacion==OPERACION_CONSULTAR){
				if(permisos.getPermiso(session, MODULO, PERMISO_TIPO_CONSULTAR)) {
					String idsolicitudmaterial= request.getParameter("idsolicitudmaterial")==null ? "0":request.getParameter("idsolicitudmaterial").toString().trim();
					rs = st.executeQuery("SELECT proyecto.nombre as nombreproyecto,cuadrilla.nombre as nombrecuadrilla,persona.cedula, obra.nombre as nombreobra,subetapa.nombre as nombresubetapa, etapa.nombre as nombreetapa, etapa.idetapa, " + 
							"persona.nombre as nombrepersona, persona.apellido, idsolicitudmaterial, detalleetapa.iddetalleetapa, tipoobra.idtipoobra,proyecto.idproyecto, cargo.nombre as nombrecargo, " + 
							"fechasolicitud, obra.idobra, subetapa.idsubetapa, trabajador.idtrabajador, fechaprocesada, solicitudmaterial.estatus, placa, marca, modelo, chofer, retiradopor, fechadespacho, observacion " + 
							"FROM solicitudmaterial inner join trabajador on trabajador.idtrabajador=solicitudmaterial.idtrabajador inner join " + 
							"persona on persona.idpersona=trabajador.idpersona inner join subetapa on subetapa.idsubetapa=solicitudmaterial.idsubetapa " + 
							"inner join obra on obra.idobra=solicitudmaterial.idobra inner join detalleetapa on detalleetapa.idsubetapa=subetapa.idsubetapa " + 
							"inner join tipoobra on tipoobra.idtipoobra=obra.idtipoobra inner join cuadrilla on cuadrilla.idtrabajador=trabajador.idtrabajador " + 
							"inner join proyecto on proyecto.idproyecto=obra.idproyecto inner join cargo on cargo.idcargo=trabajador.idcargo inner join etapa on detalleetapa.idetapa=etapa.idetapa where solicitudmaterial.idsolicitudmaterial= "+idsolicitudmaterial);
					respuesta.clear();
					if(rs.next()) {
						respuesta.put("valido", true);
						respuesta.put("idsolicitudmaterial", idsolicitudmaterial);
						respuesta.put("txtCedula", rs.getString("cedula"));
						respuesta.put("txtDatospersonales", rs.getString("nombrepersona").trim()+" "+rs.getString("apellido").trim());
						respuesta.put("txtCargo", rs.getString("nombrecargo"));
						respuesta.put("txtCuadrilla", rs.getString("nombrecuadrilla"));
						respuesta.put("txtProyecto", rs.getString("nombreproyecto"));
						
						respuesta.put("txtObra", rs.getString("nombreobra"));
						respuesta.put("txtEtapa", rs.getString("nombreetapa"));
						respuesta.put("txtSubetapa", rs.getString("nombresubetapa"));
						
						respuesta.put("iddetalleetapa", rs.getLong("iddetalleetapa"));
						respuesta.put("idsubetapa", rs.getLong("idsubetapa"));
						respuesta.put("idetapa", rs.getLong("idetapa"));
						respuesta.put("idobra", rs.getLong("idobra"));
						respuesta.put("idtipoobra", rs.getLong("idtipoobra"));
						respuesta.put("idproyecto", rs.getLong("idproyecto"));
						respuesta.put("idtrabajador", rs.getLong("idtrabajador"));
						respuesta.put("txtFechasolicitud", ValidaFormato.cambiarFecha(rs.getString("fechasolicitud").trim(), 2));
						
						respuesta.put("txtPlaca", rs.getString("placa"));
						respuesta.put("txtMarca", rs.getString("marca"));
						respuesta.put("txtModelo", rs.getString("modelo"));
						respuesta.put("txtChofer", rs.getString("chofer"));
						respuesta.put("txtResponsable", rs.getString("retiradopor"));
						respuesta.put("txtObservacion", rs.getString("observacion"));
						String fechaDespacho = rs.getString("fechadespacho");
						if(fechaDespacho != null) {
							respuesta.put("txtFechadespacho",  ValidaFormato.cambiarFecha(fechaDespacho.trim(), 2));
						}else {
							respuesta.put("txtFechadespacho",  fechaDespacho);
						}
						
						respuesta.put("txtEstatus", rs.getInt("estatus"));
					}else {
						respuesta.put("valido", false);
						respuesta.put("msj", "No existe una compra con el id="+idsolicitudmaterial);
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
