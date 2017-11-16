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
 * Servlet implementation class Pago
 */
@WebServlet("/Pago")
public class Pago extends HttpServlet implements Constantes {
	private static final long serialVersionUID = 1L;
	JSONObject respuesta = new JSONObject();
	Connection conexion;
	ConexionWeb conWeb = new ConexionWeb();
	HttpSession session;
	PermisosModulo permisos = new PermisosModulo();	
	String MODULO = "pago";
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Pago() {
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
		//----------------------------------------------------------
		int operacion = request.getParameter("operacion")==null ? 0:(Integer.valueOf(request.getParameter("operacion")));
		try {
			conexion = conWeb.abrirConn();
			Statement st = conexion.createStatement();
			ResultSet rs =null;
			Statement st2 = conexion.createStatement();
			ResultSet rs2 =null;
			
			if(operacion==OPERACION_LISTADO) {
				
				int cargarConsultaPorRango = request.getParameter("cargarConsultaPorRango")==null ? 0:(Integer.valueOf(request.getParameter("cargarConsultaPorRango")));
				int listadoPrincipal = request.getParameter("listadoPrincipal")==null ? 0:(Integer.valueOf(request.getParameter("listadoPrincipal")));
				int listadoDetalle= request.getParameter("listadoDetalle")==null ? 0:(Integer.valueOf(request.getParameter("listadoDetalle")));
				JSONArray data = new JSONArray();
				JSONArray dataCuadrilla = new JSONArray();
				
				if(cargarConsultaPorRango == 1) {
					String fechaDesde= request.getParameter("fechaDesde")==null ? "0":request.getParameter("fechaDesde").toString().trim();
					String fechaHasta= request.getParameter("fechaHasta")==null ? "0":request.getParameter("fechaHasta").toString().trim();
					String idcuadrilla= request.getParameter("idcuadrilla")==null ? "0":request.getParameter("idcuadrilla").toString().trim();
					rs = st.executeQuery("SELECT inspeccion.idinspeccion, obra.nombre as obra, etapa.nombre as etapa, subetapa.nombre as subetapa, inspeccion.porcentaje, " + 
							"inspeccion.idproyecto, obra.idtipoobra, detalleetapa.iddetalleetapa, cuadrilla.nombre as nombrecuadrilla " + 
							"FROM inspeccion inner join cuadrilla on cuadrilla.idcuadrilla=inspeccion.idcuadrilla " + 
							"inner join obra on obra.idobra=inspeccion.idobra inner join detalleetapa on detalleetapa.iddetalleetapa=inspeccion.iddetalleetapa " +
							"inner join etapa on etapa.idetapa=detalleetapa.idetapa inner join subetapa on subetapa.idsubetapa=detalleetapa.idsubetapa " + 
							"left join detallepagoinspeccion on detallepagoinspeccion.idinspeccion=inspeccion.idinspeccion " + 
							"where detallepagoinspeccion.idinspeccion is null and cuadrilla.idcuadrilla="+idcuadrilla+" AND inspeccion.fechainspeccion BETWEEN '"+fechaDesde+"' AND '"+fechaHasta+"' order by inspeccion.idinspeccion");
					while (rs.next()) {
							JSONArray p = new JSONArray();
							p.add(rs.getLong("idinspeccion"));
							p.add(rs.getString("obra"));
							p.add(rs.getString("etapa"));
							p.add(rs.getString("subetapa"));
							p.add(rs.getInt("porcentaje"));
							p.add(rs.getLong("idproyecto"));
							p.add(rs.getLong("idtipoobra"));
							p.add(rs.getLong("iddetalleetapa"));
							p.add(rs.getString("nombrecuadrilla"));
							p.add("Desde: "+fechaDesde+" Hasta: "+fechaHasta);
							data.add(p);
					}
					
					rs2 = st2.executeQuery("select * from trabajadorcuadrilla where idcuadrilla="+idcuadrilla);
					while (rs2.next()) {
							JSONArray p = new JSONArray();
							p.add(rs2.getLong("idtrabajadorcuadrilla"));
							dataCuadrilla.add(p);
					}
				}
				
				if(listadoPrincipal == 1) {
					
					rs = st.executeQuery("select pago.estatus,pago.idpago, cuadrilla.nombre as nombrecuadrilla, proyecto.nombre as nombreproyecto, pago.montototal, pago.fecharegistro " + 
							"from pago inner join detallepagoinspeccion on detallepagoinspeccion.idpago=pago.idpago " + 
							"inner join inspeccion on inspeccion.idinspeccion=detallepagoinspeccion.idinspeccion inner join cuadrilla on " + 
							"cuadrilla.idcuadrilla=detallepagoinspeccion.idcuadrilla inner join proyecto on proyecto.idproyecto=inspeccion.idproyecto " + 
							"group by pago.idpago, cuadrilla.nombre, proyecto.nombre, pago.montototal, pago.fecharegistro");
					while (rs.next()) {
							JSONArray p = new JSONArray();
							String Estatus = "<span style='color:#FA8258;font-weight:bold;'>Pendiente por Pagar</span>";
							p.add(rs.getLong("idpago"));
							p.add(rs.getString("nombrecuadrilla"));
							p.add(rs.getString("nombreproyecto"));
							String monto = String.valueOf(rs.getDouble("montototal"));
							p.add(ValidaFormato.formato(monto));
							p.add(ValidaFormato.cambiarFecha(rs.getString("fecharegistro").trim(), 2));
							if(rs.getInt("estatus") == 0) {
								Estatus = "Pagado";
							}
							p.add(Estatus);
							data.add(p);
					}
				}
				
				if(listadoDetalle == 1) {
					String idpago= request.getParameter("idpago")==null ? "0":request.getParameter("idpago").toString().trim();
					rs = st.executeQuery("SELECT obra.nombre as nombreobra, etapa.nombre as nombreetapa, subetapa.nombre as nombresubetapa,inspeccion.porcentaje, " + 
							"detallepagoinspeccion.montoinspeccion " + 
							"FROM detallepagoinspeccion inner join pago on pago.idpago=detallepagoinspeccion.idpago inner join inspeccion on " + 
							"inspeccion.idinspeccion=detallepagoinspeccion.idinspeccion inner join proyecto on proyecto.idproyecto=inspeccion.idproyecto " + 
							"inner join cuadrilla on cuadrilla.idcuadrilla=detallepagoinspeccion.idcuadrilla inner join detalleetapa on " + 
							"detalleetapa.iddetalleetapa=inspeccion.iddetalleetapa inner join etapa on etapa.idetapa=detalleetapa.idetapa " + 
							"inner join subetapa on subetapa.idsubetapa=detalleetapa.idsubetapa " + 
							"inner join obra on obra.idobra=inspeccion.idobra where pago.idpago="+idpago);
					while (rs.next()) {
							JSONArray p = new JSONArray();
							p.add(rs.getString("nombreobra"));
							p.add(rs.getString("nombreetapa"));
							p.add(rs.getString("nombresubetapa"));
							p.add(rs.getInt("porcentaje"));
							String monto = String.valueOf(rs.getDouble("montoinspeccion"));
							p.add(ValidaFormato.formato(monto));
							data.add(p);
					}
				}else if(listadoDetalle == 2) {
					String idpago= request.getParameter("idpago")==null ? "0":request.getParameter("idpago").toString().trim();
					rs = st.executeQuery("SELECT persona.nombre, persona.apellido,detallepagotrabajador.monto, " + 
							"detallepagotrabajador.modopago, detallepagotrabajador.referencia, detallepagotrabajador.iddetallepagotrabajador, " + 
							"detallepagotrabajador.banco, detallepagotrabajador.cedulatitular, detallepagotrabajador.nombretitular " + 
							"FROM trabajadorcuadrilla inner join cuadrilla on cuadrilla.idcuadrilla=trabajadorcuadrilla.idcuadrilla " + 
							"inner join trabajador on trabajador.idtrabajador=trabajadorcuadrilla.idtrabajador inner join persona " + 
							"on persona.idpersona=trabajador.idpersona " + 
							"inner join detallepagotrabajador on detallepagotrabajador.idtrabajadorcuadrilla=trabajadorcuadrilla.idtrabajadorcuadrilla " + 
							"where detallepagotrabajador.idpago="+idpago);
					while (rs.next()) {
							JSONArray p = new JSONArray();
							p.add(rs.getString("nombre")+" "+rs.getString("apellido"));
							String monto = String.valueOf(rs.getDouble("monto"));
							p.add(ValidaFormato.formato(monto));
							p.add(rs.getString("modopago"));
							p.add(rs.getString("banco"));
							p.add(rs.getString("cedulatitular")+" "+rs.getString("nombretitular"));
							p.add(rs.getString("referencia"));
							data.add(p);
					}
				}
				
						
				respuesta.clear();
				respuesta.put("valido", true);
				respuesta.put("data", data);
				respuesta.put("dataCuadrilla", dataCuadrilla);
				
			}else if(operacion==OPERACION_INCLUIR){
				int condicion = request.getParameter("condicion")==null ? 0:(Integer.valueOf(request.getParameter("condicion")));
				
				String fechaSistema= request.getParameter("fechaSistema").toString().trim();
				String montoTotal= request.getParameter("montoTotal")==null ? "0":request.getParameter("montoTotal").toString().trim();
				montoTotal = montoTotal.replace(".", "").replace(",", ".");
				String idcuadrilla= request.getParameter("cuadrilla")==null ? "0":request.getParameter("cuadrilla").toString().trim();
				String idPago= "";	
				
				rs = st.executeQuery("SELECT nextval('idpago') as idpago");
				if(rs.next()) {
					idPago = rs.getString("idpago");
				}
				
				if(condicion == 1) {
					
					String ListaInspeccion= request.getParameter("ListaInspeccion").toString().trim();
					String ListaInspeccionPago= request.getParameter("ListaMontoinspeccion").toString().trim();
					String ListaTrabajadores= request.getParameter("ListaTrabajadores").toString().trim();
					String cade = "INSERT INTO pago(idpago,fecharegistro, montototal, estatus) VALUES ("+idPago+",'"+fechaSistema+"',"+montoTotal+", 1)";
					st.execute(cade);
					if(ListaInspeccion!="") {
						String[] Inspeccion = ListaInspeccion.split(",");
						String[] MontoPago = ListaInspeccionPago.split(",");
						String[] Trabajadores = ListaTrabajadores.split(",");
						for (int i = 0; i < Inspeccion.length; i++) {
							String cade2 = "INSERT INTO detallepagoinspeccion(idpago,idinspeccion,idcuadrilla,montoinspeccion) VALUES ("+idPago+", "+Inspeccion[i]+","+idcuadrilla+", "+MontoPago[i]+")";
							st.execute(cade2);
						}
						
						for (int i = 0; i < Trabajadores.length; i++) {
							String cade3 = "INSERT INTO detallepagotrabajador(idpago,idtrabajadorcuadrilla) VALUES ("+idPago+", "+Trabajadores[i]+")";
							st.execute(cade3);
						}
					}
				}/*else if(condicion == 2) {
					String idpago= request.getParameter("idpago")==null ? "0":request.getParameter("idpago").toString().trim();
					String txtFechaSistema= request.getParameter("fechaSistema")==null ? "0":request.getParameter("fechaSistema").toString().trim();					
					String idtrabajadorcuadrilla= request.getParameter("idtrabajadorcuadrilla")==null ? "0":request.getParameter("idtrabajadorcuadrilla").toString().trim();
					String txtMontoCancelar= request.getParameter("monto")==null ? "0":request.getParameter("monto").toString().trim();
					txtMontoCancelar = txtMontoCancelar.replace(".", "").replace(",", ".");			
					
					String txtBanco= request.getParameter("banco")==null ? "0":request.getParameter("banco").toString().trim();
					String txtNroreferencia= request.getParameter("referencia")==null ? "0":request.getParameter("referencia").toString().trim();
					String txtNrocuenta= request.getParameter("nrocuenta")==null ? "0":request.getParameter("nrocuenta").toString().trim();
					String txtModoPago= request.getParameter("modopago")==null ? "0":request.getParameter("modopago").toString().trim();
					String txtCedulaTitularAux= request.getParameter("cedulatitular")==null ? "0":request.getParameter("cedulatitular").toString().trim();
					String txtNombreTitularAux= request.getParameter("nombretitular")==null ? "0":request.getParameter("nombretitular").toString().trim();
					
					String cade = "INSERT INTO detallepagotrabajador(" + 
							" idpago, idtrabajadorcuadrilla, fecha, monto, banco, referencia, nrocuenta, modopago, cedulatitular, nombretitular) " + 
							" VALUES ("+idpago+", "+idtrabajadorcuadrilla+", '"+txtFechaSistema+"', "+txtMontoCancelar+", '"+txtBanco+"', '"+txtNroreferencia+"', '"+txtNrocuenta+"','"+txtModoPago+"', '"+txtCedulaTitularAux+"', '"+txtNombreTitularAux+"')";
					st.execute(cade);
				}*/
				
				respuesta.put("valido", true);
				respuesta.put("pagoGenerado", idPago);
				respuesta.put("msj", "Registro incluido con exito!");
			}else if(operacion==OPERACION_EDITAR){
				int condicion = request.getParameter("condicion")==null ? 0:(Integer.valueOf(request.getParameter("condicion")));
				int anular = request.getParameter("anular")==null ? 0:(Integer.valueOf(request.getParameter("anular")));
				if(condicion == 1) {
					String idpago= request.getParameter("idpago")==null ? "0":request.getParameter("idpago").toString().trim();
					String txtFechaSistema= request.getParameter("fechaSistema")==null ? "0":request.getParameter("fechaSistema").toString().trim();					
					String idtrabajadorcuadrilla= request.getParameter("idtrabajadorcuadrilla")==null ? "0":request.getParameter("idtrabajadorcuadrilla").toString().trim();
					String txtMontoCancelar= request.getParameter("monto")==null ? "0":request.getParameter("monto").toString().trim();
					txtMontoCancelar = txtMontoCancelar.replace(".", "").replace(",", ".");			
					
					String txtBanco= request.getParameter("banco")==null ? "0":request.getParameter("banco").toString().trim();
					String txtNroreferencia= request.getParameter("referencia")==null ? "0":request.getParameter("referencia").toString().trim();
					String txtNrocuenta= request.getParameter("nrocuenta")==null ? "0":request.getParameter("nrocuenta").toString().trim();
					String txtModoPago= request.getParameter("modopago")==null ? "0":request.getParameter("modopago").toString().trim();
					String txtCedulaTitularAux= request.getParameter("cedulatitular")==null ? "0":request.getParameter("cedulatitular").toString().trim();
					String txtNombreTitularAux= request.getParameter("nombretitular")==null ? "0":request.getParameter("nombretitular").toString().trim();
					String txtObservacion= request.getParameter("observacion")==null ? "":request.getParameter("observacion").toString().trim();
					
					String cade = "UPDATE detallepagotrabajador SET fecha='"+txtFechaSistema+"', monto="+txtMontoCancelar+", banco='"+txtBanco+"', "+
					"referencia='"+txtNroreferencia+"', nrocuenta='"+txtNrocuenta+"', modopago='"+txtModoPago+"', cedulatitular='"+txtCedulaTitularAux+"', "+
					"nombretitular='"+txtNombreTitularAux+"', observacion='"+txtObservacion+"'  WHERE idpago = "+idpago+" AND idtrabajadorcuadrilla="+idtrabajadorcuadrilla;
					st.execute(cade);
				}else if(anular == 1) {
					String idpago= request.getParameter("idpago")==null ? "0":request.getParameter("idpago").toString().trim();					
					String iddetallepagotrabajador= request.getParameter("iddetallepagotrabajador")==null ? "0":request.getParameter("iddetallepagotrabajador").toString().trim();
					String cade = "UPDATE detallepagotrabajador SET fecha=null, monto=0, banco=null, "+
					"referencia=null, nrocuenta=null, modopago=null, cedulatitular=null, "+
					"nombretitular=null  WHERE idpago = "+idpago+" AND iddetallepagotrabajador="+iddetallepagotrabajador;
					st.execute(cade);
				}else {
					String fechaSistema= request.getParameter("fechasistema")==null ? "0":request.getParameter("fechasistema").toString().trim();
					String idpago= request.getParameter("idpago")==null ? "0":request.getParameter("idpago").toString().trim();
					String cade = "UPDATE pago SET estatus = 0, fechapago='"+fechaSistema+"' WHERE idpago = "+idpago;
					st.execute(cade);
				}
				
				
				
				respuesta.put("valido", true);
				respuesta.put("msj", "Registro editado con exito!");
			}else if(operacion==OPERACION_CONSULTAR){
				int condicion = request.getParameter("condicion")==null ? 0:(Integer.valueOf(request.getParameter("condicion")));
				String idtipoobra= request.getParameter("tipoobra")==null ? "0":request.getParameter("tipoobra").toString().trim();
				String iddetalleetapa= request.getParameter("detalleetapa")==null ? "0":request.getParameter("detalleetapa").toString().trim();
				String idproyecto= request.getParameter("proyecto")==null ? "0":request.getParameter("proyecto").toString().trim();

				
				if(condicion == 1) {
					rs = st.executeQuery("select * from precio where idproyecto="+idproyecto+" and idtipoobra="+idtipoobra+" and iddetalleetapa="+iddetalleetapa);
					respuesta.clear();
					if(rs.next()) {
						respuesta.put("valido", true);
						respuesta.put("costo", rs.getDouble("costo"));
					}else {
						respuesta.put("valido", true);
						respuesta.put("costo", 0);
					}
				}else if(condicion == 2) {
					String idpago= request.getParameter("idpago").toString().trim();
					rs = st.executeQuery("SELECT pago.idpago,proyecto.nombre as nombreproyecto, pago.montototal, cuadrilla.nombre as nombrecuadrilla,  " + 
							"cuadrilla.idcuadrilla, persona.nombre as nombrepersona, persona.apellido, pago.fechapago " + 
							"FROM detallepagoinspeccion inner join " + 
							"pago on pago.idpago=detallepagoinspeccion.idpago inner join inspeccion on " + 
							"inspeccion.idinspeccion=detallepagoinspeccion.idinspeccion inner join proyecto on proyecto.idproyecto=inspeccion.idproyecto " + 
							"inner join cuadrilla on cuadrilla.idcuadrilla=inspeccion.idcuadrilla " + 
							"inner join trabajador on trabajador.idtrabajador=cuadrilla.idtrabajador inner join " + 
							"persona on persona.idpersona=trabajador.idpersona where pago.idpago="+idpago+"  group by pago.idpago,proyecto.nombre, pago.montototal, "+
							"cuadrilla.nombre, cuadrilla.idcuadrilla, persona.nombre, persona.apellido, pago.fechapago");
					respuesta.clear();
					if(rs.next()) {
						respuesta.put("valido", true);
						respuesta.put("idpago", idpago);
						respuesta.put("txtProyecto", rs.getString("nombreproyecto"));
						String monto = String.valueOf(rs.getDouble("montototal"));
						respuesta.put("txtMontototal", ValidaFormato.formato(monto));
						respuesta.put("txtNombrecuadrilla", rs.getString("nombrecuadrilla"));
						respuesta.put("idcuadrilla", rs.getLong("idcuadrilla"));
						respuesta.put("jefecuadrilla", rs.getString("nombrepersona")+" "+rs.getString("apellido"));
						String fechaPago = rs.getString("fechapago") == null ? "0": ValidaFormato.cambiarFecha(rs.getString("fechapago").trim(), 2);
						respuesta.put("fechapago", fechaPago);
					}
				}else if(condicion == 3) {
					String iddetallepagotrabajador= request.getParameter("iddetallepagotrabajador")==null ? "0":request.getParameter("iddetallepagotrabajador").toString().trim();
					rs = st.executeQuery("SELECT * FROM detallepagotrabajador inner join trabajadorcuadrilla on trabajadorcuadrilla.idtrabajadorcuadrilla=detallepagotrabajador.idtrabajadorcuadrilla " + 
							"inner join trabajador on trabajador.idtrabajador=trabajadorcuadrilla.idtrabajador inner join persona on " + 
							"persona.idpersona=trabajador.idpersona where iddetallepagotrabajador="+iddetallepagotrabajador);
					respuesta.clear();
					if(rs.next()) {
						respuesta.put("valido", true);
						respuesta.put("iddetallepagotrabajador", iddetallepagotrabajador);
						respuesta.put("banco", rs.getString("banco"));
						String monto = String.valueOf(rs.getDouble("monto"));
						respuesta.put("txtMontototal", ValidaFormato.formato(monto));
						respuesta.put("referencia", rs.getString("referencia"));
						respuesta.put("nrocuenta", rs.getString("nrocuenta"));
						respuesta.put("modopago", rs.getString("modopago"));
						respuesta.put("titular", rs.getString("cedulatitular")+" "+rs.getString("nombretitular"));
						respuesta.put("nombretrabajador", rs.getString("nombre")+" "+rs.getString("apellido"));
						respuesta.put("nombrecheque", rs.getString("nombretitular"));
						respuesta.put("cedulacheque", rs.getString("cedulatitular"));
						respuesta.put("observacion", rs.getString("observacion"));
					}
				}
			}else if(operacion==OPERACION_ELIMINAR){
				String idpago= request.getParameter("idpago")==null ? "0":request.getParameter("idpago").toString().trim();
				
				st.execute("DELETE FROM detallepagoinspeccion WHERE idpago = "+idpago);
				st.execute("DELETE FROM detallepagotrabajador WHERE idpago = "+idpago);
				st.execute("DELETE FROM pago WHERE idpago = "+idpago);
							
					
				respuesta.put("valido", true);
				respuesta.put("msj", "Registro anulado con exito!");
				
			}
			
			if(rs!=null) rs.close();
			st.close();
			
			if(rs2!=null) rs2.close();
			st2.close();
			
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
