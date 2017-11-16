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

import net.sf.json.JSON;
import ve.com.proherco.web.comun.ConexionWeb;

/**
 * Servlet implementation class Login
 */
@WebServlet("/Login")
public class Login extends HttpServlet {
	private static final long serialVersionUID = 1L;
	JSONObject respuesta = new JSONObject();
	Connection conexion;
	ConexionWeb conWeb = new ConexionWeb();
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Login() {
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
		HttpSession session = request.getSession();
		//----------------------------------------------------------
		try {
			conexion = conWeb.abrirConn();
			Statement st = conexion.createStatement();
			
			String txtUsuario = request.getParameter("txtUsuario").toString().trim();
			String txtClave = request.getParameter("txtClave").toString().trim();
			boolean app = request.getParameter("app")==null ? false:Boolean.valueOf(request.getParameter("app").toString().trim());
			session.invalidate();
			session = request.getSession(true);
			
			ResultSet rs = st.executeQuery("SELECT u.idpersona as idp, * FROM usuarios as u left join persona as p on u.idpersona=p.idpersona WHERE u.usuario = '"+txtUsuario+"' AND u.clave = '"+txtClave+"'");
			if(rs.next()) {
				
				Long idusuario = rs.getLong("idusuario");
				Long idpersona = rs.getLong("idp");
				session.setAttribute("idusuario", idusuario);
				session.setAttribute("idpersona", idpersona);
				session.setAttribute("nombre", rs.getString("apellido").trim()+" "+rs.getString("nombre").trim());
				
				Statement stPer = conexion.createStatement();
				ResultSet rsPer = stPer.executeQuery("SELECT * FROM permisos WHERE idusuario = "+idusuario);
				JSONObject permisosModulo = new JSONObject();
				while (rsPer.next()) {
					JSONObject p = new JSONObject();
					p.put("incluir",rsPer.getBoolean("incluir"));
					p.put("editar",rsPer.getBoolean("editar"));
					p.put("eliminar",rsPer.getBoolean("eliminar"));
					p.put("consultar",rsPer.getBoolean("consultar"));
					permisosModulo.put(rsPer.getString("modulo").trim(), p);
				}
				session.setAttribute("permisosModulo", permisosModulo);
				respuesta.clear();
				respuesta.put("valido", true);
				if(app) {
					respuesta.put("nombre", rs.getString("apellido").trim()+" "+rs.getString("nombre").trim());
					respuesta.put("idusuario", idusuario);
					respuesta.put("appacceso", rs.getBoolean("appacceso"));
					respuesta.put("appfulldash", rs.getBoolean("appfulldash"));
					respuesta.put("appinspecciones", rs.getBoolean("appinspecciones"));
					respuesta.put("appmateriales", rs.getBoolean("appmateriales"));
					
					Statement st_Proyectos = conexion.createStatement();
					ResultSet rs_Proyectos = st_Proyectos.executeQuery("SELECT * FROM proyecto");
					JSONArray proyectos =  new JSONArray();
					
					while (rs.next()) {			
						JSONObject p = new JSONObject();
						p.put("id",rs_Proyectos.getLong("idproyecto"));
						p.put("text",rs_Proyectos.getString("nombre").trim());
						proyectos.add(p);
					}
					if(proyectos.size()>0) {
						respuesta.put("proyectos",proyectos);
					}
				}
			}else {
				respuesta.clear();
				respuesta.put("valido", false);
				respuesta.put("msj", "Nombre de usuario o Clave Incorrecto.");
			}
					
			
			if(rs!=null) rs.close();
			st.close();
		
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			respuesta.clear();
			respuesta.put("valido", false);
			respuesta.put("msj", "Error interno de conexión");
			
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
