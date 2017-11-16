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
 * Servlet implementation class Detallesolicitud
 */
@WebServlet("/Detallesolicitud")
public class Detallesolicitud extends HttpServlet implements Constantes {
	private static final long serialVersionUID = 1L;
	JSONObject respuesta = new JSONObject();
	Connection conexion;
	ConexionWeb conWeb = new ConexionWeb();
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Detallesolicitud() {
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
				String idsolicitudmaterial= request.getParameter("idsolicitudmaterial")==null ? "0":request.getParameter("idsolicitudmaterial").toString().trim();
				JSONArray data = new JSONArray();
				rs = st.executeQuery("SELECT * FROM detallesolicitud inner join solicitudmaterial on solicitudmaterial.idsolicitudmaterial=detallesolicitud.idsolicitudmaterial " + 
						" inner join material on material.idmaterial=detallesolicitud.idmaterial where detallesolicitud.idsolicitudmaterial="+idsolicitudmaterial);
				while (rs.next()) {
						JSONArray p = new JSONArray();
						p.add(rs.getLong("idsolicitudmaterial"));
						p.add(rs.getLong("idmaterial"));
						p.add(rs.getString("nombre").toString());
						p.add(rs.getDouble("cantidad"));
						data.add(p);
				}
				respuesta.clear();
				respuesta.put("valido", true);
				respuesta.put("data", data);
			}else if(operacion==OPERACION_INCLUIR){
				String idsolicitudmaterial= request.getParameter("idsolicitudmaterial").toString().trim();
				String idmaterial= request.getParameter("idmaterial").toString().trim();
				String txtCantidad= request.getParameter("cantidad").toString().trim();
				
				String cade = "INSERT INTO detallesolicitud (idsolicitudmaterial, idmaterial, cantidad)"
							 + " VALUES("+idsolicitudmaterial+", "+idmaterial+", "+txtCantidad+")";
				st.execute(cade);
				
				respuesta.put("valido", true);
				respuesta.put("msj", "Registro incluido con exito!");
			}else if(operacion==OPERACION_EDITAR){
				
				String idsolicitudmaterial= request.getParameter("idsolicitudmaterial")==null ? "0":request.getParameter("idsolicitudmaterial").toString().trim();
				String idmaterial= request.getParameter("idmaterial")==null ? "0":request.getParameter("idmaterial").toString().trim();
				String cantidad= request.getParameter("cantidad").toString().trim();
				String cade = "UPDATE detallesolicitud SET cantidad = "+cantidad
							 +" WHERE idsolicitudmaterial = "+idsolicitudmaterial+" and idmaterial="+idmaterial;
				st.execute(cade);
				respuesta.put("valido", true);
				respuesta.put("msj", "Registro editado con exito!");
			}else if(operacion==OPERACION_ELIMINAR){
				String idsolicitudmaterial= request.getParameter("idsolicitudmaterial")==null ? "0":request.getParameter("idsolicitudmaterial").toString().trim();
				String idmaterial= request.getParameter("idmaterial")==null ? "0":request.getParameter("idmaterial").toString().trim();
				st.execute("DELETE FROM detallesolicitud WHERE idsolicitudmaterial = "+idsolicitudmaterial+" and idmaterial="+idmaterial);
				respuesta.put("valido", true);
				respuesta.put("msj", "Registro eliminado con exito!");
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
