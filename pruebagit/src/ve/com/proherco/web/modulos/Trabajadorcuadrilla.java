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
 * Servlet implementation class Cargo
 */
@WebServlet("/Trabajadorcuadrilla")
public class Trabajadorcuadrilla extends HttpServlet implements Constantes {
	private static final long serialVersionUID = 1L;
	JSONObject respuesta = new JSONObject();
	Connection conexion;
	ConexionWeb conWeb = new ConexionWeb();
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Trabajadorcuadrilla() {
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
			ResultSet rs = null; 
			if(operacion==OPERACION_INCLUIR){//NUEVA OPCION
				String idcuadrilla= request.getParameter("idcuadrilla")==null ? "0":request.getParameter("idcuadrilla").toString().trim();
				String idtrabajador= request.getParameter("idtrabajador").toString().trim();
				String cade = "INSERT INTO trabajadorcuadrilla (idcuadrilla,idtrabajador,estatus) VALUES ("+idcuadrilla+", "+idtrabajador+", 1)";
				st.execute(cade);
				
				respuesta.put("valido", true);
				respuesta.put("msj", "Registro incluido con exito!");
			}else if(operacion==OPERACION_LISTADO) {
				String idcuadrilla= request.getParameter("idcuadrilla")==null ? "0":request.getParameter("idcuadrilla").toString().trim();
				rs = st.executeQuery("SELECT *,cargo.nombre as nombrecargo, persona.nombre as nombrepersona FROM trabajadorcuadrilla inner join trabajador on trabajadorcuadrilla.idtrabajador=trabajador.idtrabajador inner join cargo on cargo.idcargo=trabajador.idcargo inner join persona on persona.idpersona=trabajador.idpersona WHERE idcuadrilla= "+idcuadrilla);
				JSONArray data = new JSONArray();
				
				while (rs.next()) {
						JSONArray p = new JSONArray();
						p.add(rs.getLong("idtrabajador"));
						p.add(rs.getLong("cedula"));
						p.add(rs.getString("nombrepersona")+" "+rs.getString("apellido"));
						p.add(rs.getString("nombrecargo"));
						data.add(p);
				}			
				respuesta.clear();
				respuesta.put("valido", true);
				respuesta.put("data", data);
			}else if(operacion==OPERACION_ELIMINAR){
				String idcuadrilla= request.getParameter("idcuadrilla")==null ? "0":request.getParameter("idcuadrilla").toString().trim();
				String idtrabajador= request.getParameter("idtrabajador")==null ? "0":request.getParameter("idtrabajador").toString().trim();
				st.execute("DELETE FROM trabajadorcuadrilla WHERE idcuadrilla = "+idcuadrilla+" AND idtrabajador="+idtrabajador);
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
