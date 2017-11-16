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
 * Servlet implementation class Compra
 */
@WebServlet("/Compra")
public class Compra extends HttpServlet implements Constantes {
	private static final long serialVersionUID = 1L;
	JSONObject respuesta = new JSONObject();
	Connection conexion;
	ConexionWeb conWeb = new ConexionWeb();
	HttpSession session;
	PermisosModulo permisos = new PermisosModulo();
	String MODULO = "compra";
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Compra() {
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
				rs = st.executeQuery("select * from compra inner join proveedor on proveedor.idproveedor=compra.idproveedor");
				while (rs.next()) {
						JSONArray p = new JSONArray();
						p.add(rs.getLong("idcompra"));
						p.add(rs.getString("nombre").trim());
						p.add(rs.getString("numerofactura").trim());
						p.add(ValidaFormato.cambiarFecha(rs.getString("fecha").trim(), 2));
						p.add(ValidaFormato.formato(rs.getString("montofactura"))+" Bs");
						data.add(p);
				}			
				respuesta.clear();
				respuesta.put("valido", true);
				respuesta.put("data", data);
			}else if(operacion==OPERACION_INCLUIR){
				if(permisos.getPermiso(session, MODULO, PERMISO_TIPO_INCLUIR)) {
					String idCompra = "";
					rs = st.executeQuery("SELECT nextval('idcompra') as idcompra");
					if(rs.next()) {
						idCompra = rs.getString("idcompra");
					}
					String idproveedor= request.getParameter("idproveedor").toString().trim();
					String txtFactura= request.getParameter("txtFactura").toString().trim();
					String txtFechacompra= request.getParameter("txtFechacompra").toString().trim();
					String txtMontofactura= request.getParameter("txtMontofactura").toString().trim();
					txtMontofactura = txtMontofactura.replace(".", "").replace(",", ".");
					String txtDescripcion= request.getParameter("txtDescripcion").toString().trim();
					String cmbEstatus= request.getParameter("cmbEstatus").toString().trim();
					String iva = request.getParameter("iva").toString().trim();
					String txttasacambio= request.getParameter("txttasacambio").toString().trim();
					
					String txtTotaliva= request.getParameter("totaliva").toString().trim();
					
					txtTotaliva = txtTotaliva.replace(".", "").replace(",", ".");
					
					//System.out.print(iva);
					String cade = "INSERT INTO compra(idcompra,idproveedor,numerofactura,fecha,descripcion,montofactura,estatus,iva,totaliva)"
								 + " VALUES("+idCompra+","+idproveedor+", '"+txtFactura+"', '"+txtFechacompra+"', '"+txtDescripcion+"', "+txtMontofactura+", "+cmbEstatus+", "+iva+", "+txtTotaliva+")";
					
					st.execute(cade);
					
					String listaMaterial= request.getParameter("listaMaterial").toString().trim();
					String listaCostounitario= request.getParameter("listaCostounitario").toString().trim();
					String listaCantidad= request.getParameter("listaCantidad").toString().trim();
					String listaCostototal= request.getParameter("listaCostototal").toString().trim();
					String listacostoUSD= request.getParameter("listacostoUSD").toString().trim();
					if(listaMaterial!="") {
						String[] Material = listaMaterial.split(",");
						String[] Costounitario = listaCostounitario.split(",");
						String[] Cantidad = listaCantidad.split(",");
						String[] Costototal = listaCostototal.split(",");
						String[] CostoUSD = listacostoUSD.split(",");
						for (int i = 0; i < Material.length; i++) {
							//double punitarioUSD = Double.valueOf(Costounitario[i])/Double.valueOf(txttasacambio);
							String cade2 = "INSERT INTO compramaterial (idcompra, idmaterial, cantidad, costounitario, costototal, tasacambio, costounitariousd) "
									+ "VALUES ("+idCompra+", "+Material[i]+", "+Cantidad[i]+", "+Costounitario[i]+", "+Costototal[i]+", "+txttasacambio+","+CostoUSD[i]+")";
							//System.out.print(Costototal[i]);
							st.execute(cade2);
							
							rs = st.executeQuery("SELECT * FROM detallesolicitud inner join solicitudmaterial on solicitudmaterial.idsolicitudmaterial=detallesolicitud.idsolicitudmaterial WHERE idmaterial="+Material[i]+" AND solicitudmaterial.estatus=1");//CONSULTAMOS LAS CANTIDADES SALIENTES
							Integer cantidadSaliente = 0;
							while(rs.next()) {
								cantidadSaliente += rs.getInt("cantidad");
							}
							
							rs = st.executeQuery("SELECT * FROM compramaterial WHERE idmaterial="+Material[i]);//CONSULTAMOS LAS CANTIDADES ENTRANTES
							Integer cantidadEntrante = 0;
							while(rs.next()) {
								cantidadEntrante += rs.getInt("cantidad");
							}
							
							Integer resultado = 0;
							resultado = cantidadEntrante-cantidadSaliente;
							String cade3 = "UPDATE material SET existencia = "+resultado+" WHERE idmaterial="+Material[i];
							st.execute(cade3);
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
					String idcompra= request.getParameter("idcompra")==null ? "0":request.getParameter("idcompra").toString().trim();
					String idproveedor= request.getParameter("idproveedor").toString().trim();
					String txtFactura= request.getParameter("txtFactura").toString().trim();
					String txtFechacompra= request.getParameter("txtFechacompra").toString().trim();
					String txtMontofactura= request.getParameter("txtMontofactura").toString().trim();
					txtMontofactura = txtMontofactura.replace(".", "").replace(",", ".");
					String txtDescripcion= request.getParameter("txtDescripcion").toString().trim();
					String cmbEstatus= request.getParameter("cmbEstatus").toString().trim();
					String iva =  request.getParameter("iva")==null ? "0":request.getParameter("iva").toString().trim();
					
					String txtTotaliva= request.getParameter("totaliva").toString().trim();
					txtTotaliva = txtTotaliva.replace(".", "").replace(",", ".");
					
					String cade = "UPDATE compra SET idproveedor = "+idproveedor+", numerofactura = '"+txtFactura+"', fecha = '"+txtFechacompra+"', descripcion = '"+txtDescripcion+"', montofactura = "+txtMontofactura+", iva = "+iva+", totaliva= "+txtTotaliva+", "
								 +"  estatus = "+cmbEstatus+" WHERE idcompra = "+idcompra;
					st.execute(cade);
					respuesta.put("valido", true);
					respuesta.put("msj", "Registro editado con exito!");
				}else {
					respuesta.put("valido", false);
					respuesta.put("msj", MSJ_NO_PERMISO);
				}
			}else if(operacion==OPERACION_ELIMINAR){
				if(permisos.getPermiso(session, MODULO, PERMISO_TIPO_ELIMINAR)) {
					String idcompra= request.getParameter("idcompra")==null ? "0":request.getParameter("idcompra").toString().trim();
					st.execute("DELETE FROM compra WHERE idcompra = "+idcompra);
					respuesta.put("valido", true);
					respuesta.put("msj", "Registro eliminado con exito!");
				}else {
					respuesta.put("valido", false);
					respuesta.put("msj", MSJ_NO_PERMISO);
				}
			}else if(operacion==OPERACION_CONSULTAR){
				if(permisos.getPermiso(session, MODULO, PERMISO_TIPO_CONSULTAR)) {
					String idcompra= request.getParameter("idcompra")==null ? "0":request.getParameter("idcompra").toString().trim();
					rs = st.executeQuery("SELECT  *, compra.estatus as estatuscompra,compra.descripcion as descripcioncompra " + 
							"from compra inner join proveedor on proveedor.idproveedor=compra.idproveedor where compra.idcompra= "+idcompra);
					respuesta.clear();
					if(rs.next()) {
						respuesta.put("valido", true);
						respuesta.put("idcompra", idcompra);
						respuesta.put("idproveedor", rs.getLong("idproveedor"));
						respuesta.put("txtFactura", rs.getString("numerofactura").trim());
						respuesta.put("txtFechacompra", ValidaFormato.cambiarFecha(rs.getString("fecha").trim(), 2));
						String montofactura = String.valueOf(rs.getDouble("montofactura"));
						respuesta.put("txtMontofactura", ValidaFormato.formato(montofactura));
						respuesta.put("txtDescripcion", rs.getString("descripcioncompra").trim());
						respuesta.put("cmbEstatus", rs.getInt("estatuscompra"));					
						respuesta.put("txtNombre", rs.getString("nombre").trim());
						respuesta.put("txtRif", rs.getString("rif").trim());
						respuesta.put("txtDireccion", rs.getString("direccion").trim());
						respuesta.put("iva", rs.getInt("iva"));
					}else {
						respuesta.put("valido", false);
						respuesta.put("msj", "No existe una compra con el id="+idcompra);
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
