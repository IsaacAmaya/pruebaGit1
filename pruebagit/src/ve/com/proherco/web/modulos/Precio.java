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
@WebServlet("/Precio")
public class Precio extends HttpServlet implements Constantes {
	private static final long serialVersionUID = 1L;
	JSONObject respuesta = new JSONObject();
	Connection conexion;
	ConexionWeb conWeb = new ConexionWeb();
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Precio() {
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
				String idproyecto= request.getParameter("idproyecto")==null ? "0":request.getParameter("idproyecto").toString().trim();
				JSONArray data = new JSONArray();		
				
				rs = st.executeQuery("SELECT obra.idtipoobra, tipoobra.nombre, proyecto.nombre as nombreproyecto FROM obra inner join proyecto on proyecto.idproyecto=obra.idproyecto inner join tipoobra on tipoobra.idtipoobra=obra.idtipoobra where obra.idproyecto="+idproyecto+" group by obra.idtipoobra, tipoobra.nombre, proyecto.nombre");
				while (rs.next()) {
						JSONArray p = new JSONArray();
						p.add(rs.getLong("idtipoobra"));
						p.add(rs.getString("nombre").trim());
						p.add(rs.getString("nombreproyecto").trim());
						data.add(p);
				}
						
				respuesta.clear();
				respuesta.put("valido", true);
				respuesta.put("data", data);
			}else if(operacion==OPERACION_INCLUIR){
				
				String idproyecto= request.getParameter("idproyecto").toString().trim();
				String idtipoobra= request.getParameter("idtipoobra").toString().trim();
				String iddetalleetapa= request.getParameter("iddetalleetapa").toString().trim();
				String costo= request.getParameter("precio").toString().trim();
				costo = costo.replace(".", "").replace(",", ".");
				
				rs = st.executeQuery("SELECT * FROM precio WHERE idproyecto ="+idproyecto+" and idtipoobra="+idtipoobra+" and iddetalleetapa="+iddetalleetapa);
				respuesta.clear();
				
				if(!rs.next()) {
					String cade = "INSERT INTO precio(idproyecto, idtipoobra, iddetalleetapa, costo)"
							 + " VALUES("+idproyecto+", "+idtipoobra+", "+iddetalleetapa+", "+costo+" )";
					st.execute(cade);
				}
				
				
				
				respuesta.put("valido", true);
				respuesta.put("msj", "Registro incluido con exito!");
			}else if(operacion==OPERACION_EDITAR){
				String idproyecto= request.getParameter("idproyecto").toString().trim();
				String idtipoobra= request.getParameter("idtipoobra").toString().trim();
				String iddetalleetapa= request.getParameter("iddetalleetapa").toString().trim();
				String costo= request.getParameter("precio").toString().trim();
				costo = costo.replace(".", "").replace(",", ".");
				
				String cade = "UPDATE precio SET costo = "+costo+" WHERE idproyecto = "+idproyecto+" and idtipoobra="+idtipoobra+" and iddetalleetapa="+iddetalleetapa;
							 
				st.execute(cade);
				respuesta.put("valido", true);
				respuesta.put("msj", "Registro editado con exito!");
			}else if(operacion==OPERACION_CONSULTAR){
				String idproyecto= request.getParameter("idproyecto").toString().trim();
				String idtipoobra= request.getParameter("idtipoobra").toString().trim();
				String iddetalleetapa= request.getParameter("iddetalleetapa").toString().trim();
				
				rs = st.executeQuery("SELECT * FROM precio WHERE idproyecto ="+idproyecto+" and idtipoobra="+idtipoobra+" and iddetalleetapa="+iddetalleetapa);
				respuesta.clear();
				if(rs.next()) {
					respuesta.put("valido", true);
					respuesta.put("costo", rs.getDouble("costo"));
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
