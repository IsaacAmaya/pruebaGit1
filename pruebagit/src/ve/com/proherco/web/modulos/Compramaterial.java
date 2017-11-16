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

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import ve.com.proherco.web.comun.ConexionWeb;
import ve.com.proherco.web.comun.Constantes;
import ve.com.proherco.web.comun.ValidaFormato;

/**
 * Servlet implementation class Compramaterial
 */
@WebServlet("/Compramaterial")
public class Compramaterial extends HttpServlet implements Constantes {
	private static final long serialVersionUID = 1L;
	JSONObject respuesta = new JSONObject();
	Connection conexion;
	ConexionWeb conWeb = new ConexionWeb();
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Compramaterial() {
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
			
			if(operacion==OPERACION_LISTADO) {
				String idmaterial= request.getParameter("idmaterial")==null ? "0":request.getParameter("idmaterial").toString().trim();
				String idcompra= request.getParameter("idcompra")==null ? "0":request.getParameter("idcompra").toString().trim();
				int desdeMaterial = request.getParameter("desdeMaterial")==null ? 0:(Integer.valueOf(request.getParameter("desdeMaterial")));
				JSONArray data = new JSONArray();
				
				if(desdeMaterial == 1) {
					rs = st.executeQuery("SELECT *,compra.fecha as fechacompra FROM compramaterial inner join compra on compra.idcompra=compramaterial.idcompra " + 
							" inner join material on material.idmaterial=compramaterial.idmaterial where material.idmaterial="+idmaterial+" ORDER BY fechacompra");
					while (rs.next()) {
							JSONArray p = new JSONArray();
							p.add(ValidaFormato.cambiarFecha(rs.getString("fechacompra").trim(), 2));
							p.add(rs.getDouble("cantidad"));
							p.add(rs.getString("numerofactura"));
							p.add(rs.getLong("idcompra"));
							data.add(p);
					}
				}else {
					rs = st.executeQuery("SELECT * FROM compramaterial inner join compra on compra.idcompra=compramaterial.idcompra " + 
							" inner join material on material.idmaterial=compramaterial.idmaterial where compra.idcompra="+idcompra);
					while (rs.next()) {
							JSONArray p = new JSONArray();
							p.add(rs.getLong("idcompra"));
							p.add(rs.getLong("idmaterial"));
							p.add(rs.getString("nombre").toString());
							p.add(rs.getDouble("cantidad"));
							p.add(rs.getDouble("costototal"));
							//String costounitario = String.valueOf(rs.getDouble("costounitario"));
							p.add(rs.getDouble("costounitario"));
							p.add(rs.getDouble("tasacambio"));
							p.add(rs.getDouble("costounitariousd"));
							data.add(p);
					}
				}
				
				respuesta.clear();
				respuesta.put("valido", true);
				respuesta.put("data", data);
			}else if(operacion==OPERACION_INCLUIR){
				String idcompra= request.getParameter("idcompra").toString().trim();
				String idmaterial= request.getParameter("idmaterial").toString().trim();
				String costounitario= request.getParameter("costounitario").toString().trim();
				costounitario = costounitario.replace(".", "").replace(",", ".");
				String costototal= request.getParameter("costototal").toString().trim();
				costototal = costototal.replace(".", "").replace(",", ".");
				String cantidad= request.getParameter("cantidad").toString().trim();
				
				String preciodolar= request.getParameter("preciodolar").toString().trim();
				//preciodolar = preciodolar.replace(".", "").replace(",", ".");
				
				String costounitarioSD = request.getParameter("costounitarioSD").toString().trim();
				costounitarioSD = costounitarioSD.replace(".", "").replace(",", ".");
				
				String cade = "INSERT INTO compramaterial (idcompra, idmaterial, cantidad, costounitario, costototal, tasacambio, costounitariousd)"
							 + " VALUES("+idcompra+", "+idmaterial+", "+cantidad+", "+costounitario+", "+costototal+", "+preciodolar+", "+costounitarioSD+")";
				
				rs = st.executeQuery("SELECT * FROM detallesolicitud inner join solicitudmaterial " + 
						"on solicitudmaterial.idsolicitudmaterial=detallesolicitud.idsolicitudmaterial WHERE idmaterial="+idmaterial+" AND solicitudmaterial.estatus=1");//CONSULTAMOS LAS CANTIDADES SALIENTES
				
				Integer cantidadSaliente = 0;
				while(rs.next()) {
					cantidadSaliente += rs.getInt("cantidad");
				}
				
				rs = st.executeQuery("SELECT * FROM compramaterial WHERE idmaterial="+idmaterial);//CONSULTAMOS LAS CANTIDADES ENTRANTES
				Integer cantidadEntrante = 0;
				while(rs.next()) {
					//System.out.print(rs.getInt("cantidad"));
					cantidadEntrante += rs.getInt("cantidad");
					
				}
				
				cantidadEntrante += Integer.valueOf(cantidad);
				
				Integer resultado = cantidadEntrante-cantidadSaliente;
				String cade2 = "UPDATE material SET existencia = "+resultado+" WHERE idmaterial="+idmaterial;
				//System.out.print(cade2);
				
				st.execute(cade);
				st.execute(cade2);
				respuesta.put("valido", true);
				respuesta.put("msj", "Registro incluido con exito!");
			}else if(operacion==OPERACION_EDITAR){
				String idcompra= request.getParameter("idcompra")==null ? "0":request.getParameter("idcompra").toString().trim();
				String idmaterial= request.getParameter("idmaterial").toString().trim();
				String cantidad= request.getParameter("cantidad").toString().trim();
				String costounitario= request.getParameter("costounitario").toString().trim();
				costounitario = costounitario.replace(".", "").replace(",", ".");
				String costototal= request.getParameter("costototal").toString().trim();
				costototal = costototal.replace(".", "").replace(",", ".");	
				
				String txttasacambio= request.getParameter("txttasacambio").toString().trim();
				double punitarioUSD = Double.valueOf(costounitario)/Double.valueOf(txttasacambio);
				String cade = "UPDATE compramaterial SET costounitariousd = "+punitarioUSD+", cantidad = "+cantidad+", costounitario = "+costounitario+", costototal = "+costototal
							 +" WHERE idcompra = "+idcompra+" and idmaterial="+idmaterial;
				
				rs = st.executeQuery("SELECT * FROM detallesolicitud inner join solicitudmaterial " + 
						"on solicitudmaterial.idsolicitudmaterial=detallesolicitud.idsolicitudmaterial WHERE idmaterial="+idmaterial+" AND solicitudmaterial.estatus=1");//CONSULTAMOS LAS CANTIDADES SALIENTES
				Integer cantidadSaliente = 0;
				while(rs.next()) {
					cantidadSaliente += rs.getInt("cantidad");
				}
				
				rs = st.executeQuery("SELECT * FROM compramaterial WHERE idmaterial="+idmaterial);//CONSULTAMOS LAS CANTIDADES ENTRANTES
				Integer cantidadEntrante = 0;
				while(rs.next()) {
					cantidadEntrante += rs.getInt("cantidad");
				}
				
				Integer resultado = cantidadEntrante-cantidadSaliente;
				String cade2 = "UPDATE material SET existencia = "+resultado+" WHERE idmaterial="+idmaterial;
				
				st.execute(cade);
				st.execute(cade2);
				respuesta.put("valido", true);
				respuesta.put("msj", "Registro editado con exito!");
			}else if(operacion==OPERACION_ELIMINAR){
				String idcompra= request.getParameter("idcompra")==null ? "0":request.getParameter("idcompra").toString().trim();
				String idmaterial= request.getParameter("idmaterial")==null ? "0":request.getParameter("idmaterial").toString().trim();
				st.execute("DELETE FROM compramaterial WHERE idcompra = "+idcompra+" and idmaterial="+idmaterial);
				
				rs = st.executeQuery("SELECT * FROM detallesolicitud inner join solicitudmaterial " + 
						"on solicitudmaterial.idsolicitudmaterial=detallesolicitud.idsolicitudmaterial WHERE idmaterial="+idmaterial+" AND solicitudmaterial.estatus=1");//CONSULTAMOS LAS CANTIDADES SALIENTES
				Integer cantidadSaliente = 0;
				while(rs.next()) {
					cantidadSaliente += rs.getInt("cantidad");
				}
				
				rs = st.executeQuery("SELECT * FROM compramaterial WHERE idmaterial="+idmaterial);//CONSULTAMOS LAS CANTIDADES ENTRANTES
				Integer cantidadEntrante = 0;
				while(rs.next()) {
					cantidadEntrante += rs.getInt("cantidad");
				}
				
				Integer resultado = cantidadEntrante-cantidadSaliente;
				String cade2 = "UPDATE material SET existencia = "+resultado+" WHERE idmaterial="+idmaterial;
				st.execute(cade2);
				
				respuesta.put("valido", true);
				respuesta.put("msj", "Registro eliminado con exito!");
			}else if(operacion==OPERACION_CONSULTAR){
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
					
				}else {
					respuesta.put("valido", false);
					respuesta.put("msj", "No existe una compra con el id="+idcompra);
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
