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
 * Servlet implementation class Detalleetapa
 */
@WebServlet("/Detalleetapa")
public class Detalleetapa extends HttpServlet implements Constantes {
	private static final long serialVersionUID = 1L;
	JSONObject respuesta = new JSONObject();
	Connection conexion;
	ConexionWeb conWeb = new ConexionWeb();
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Detalleetapa() {
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
			
			if(operacion==OPERACION_LISTADO) {
				int desdeSolicitud = request.getParameter("desdeSolicitud")==null ? 0:(Integer.valueOf(request.getParameter("desdeSolicitud")));
				int desdePrecio= request.getParameter("desdePrecio")==null ? 0:(Integer.valueOf(request.getParameter("desdePrecio")));
				String idetapa= request.getParameter("idetapa")==null ? "0":request.getParameter("idetapa").toString().trim();
				JSONArray data = new JSONArray();
				//JSONArray data2 = new JSONArray();
				if(desdeSolicitud == 1) {
					
					String nombresubetapa= request.getParameter("nombresubetapa").toString().trim();
					String condicionWhere = "";
					if(nombresubetapa != "") {
						condicionWhere = " AND nombre LIKE '%"+nombresubetapa+"%'";
					}
					
					rs = st.executeQuery("SELECT subetapa.idsubetapa, subetapa.nombre, subetapa.descripcion, iddetalleetapa  " + 
							" FROM subetapa inner join detalleetapa on detalleetapa.idsubetapa=subetapa.idsubetapa " + 
							" where idetapa="+idetapa+condicionWhere);
									
					
					while (rs.next()) {
							JSONArray p = new JSONArray();
							
							p.add(rs.getLong("idsubetapa"));
							p.add(rs.getString("nombre"));
							p.add(rs.getString("descripcion"));
							p.add(rs.getLong("iddetalleetapa"));
							data.add(p);
					}	
				}else if(desdePrecio == 1){
					String idproyecto= request.getParameter("idproyecto")==null ? "0":request.getParameter("idproyecto").toString().trim();
					String idtipoobra= request.getParameter("idtipoobra")==null ? "0":request.getParameter("idtipoobra").toString().trim();
					rs = st.executeQuery("select  tmp.*,precio.costo, precio.idprecio from (select proyecto.idproyecto,tipoobra.idtipoobra,detalleetapa.iddetalleetapa, subetapa.nombre from detalleetapa inner join "+
							"subetapa on subetapa.idsubetapa=detalleetapa.idsubetapa inner join " + 
							"materialporobra on materialporobra.iddetalleetapa=detalleetapa.iddetalleetapa inner join tipoobra on tipoobra.idtipoobra=materialporobra.idtipoobra " + 
							"inner join obra on obra.idtipoobra=tipoobra.idtipoobra inner join proyecto on proyecto.idproyecto=obra.idproyecto " + 
							"where detalleetapa.idetapa="+idetapa+" and tipoobra.idtipoobra="+idtipoobra+"  and proyecto.idproyecto="+idproyecto+
							"group by detalleetapa.iddetalleetapa, subetapa.nombre, proyecto.idproyecto,tipoobra.idtipoobra) as tmp left join precio on " + 
							"tmp.idproyecto = precio.idproyecto and  tmp.idtipoobra = precio.idtipoobra and tmp.iddetalleetapa=precio.iddetalleetapa");
					
					while (rs.next()) {
							JSONArray p = new JSONArray();
							p.add(rs.getLong("iddetalleetapa"));
							p.add(rs.getString("nombre"));
							p.add(rs.getDouble("costo"));
							p.add(rs.getLong("idprecio"));
							data.add(p);
					}
					
					/*rs = st.executeQuery("SELECT precio.costo,detalleetapa.iddetalleetapa, subetapa.nombre FROM detalleetapa inner join subetapa on subetapa.idsubetapa=detalleetapa.idsubetapa " + 
							" left join precio on precio.iddetalleetapa=detalleetapa.iddetalleetapa where idetapa="+idetapa+" and precio.iddetalleetapa is null");
					while (rs.next()) {
							JSONArray p = new JSONArray();
							p.add(rs.getLong("iddetalleetapa"));
							p.add(rs.getString("nombre"));
							p.add("0.00");
							data2.add(p);
					}*/
				}else {
					rs = st.executeQuery("SELECT *,subetapa.nombre as nombre, subetapa.descripcion as descripcion FROM detalleetapa inner join subetapa on detalleetapa.idsubetapa=subetapa.idsubetapa where detalleetapa.idetapa="+idetapa);
					
					while (rs.next()) {
							JSONArray p = new JSONArray();							
							p.add(rs.getLong("idsubetapa"));
							p.add(rs.getString("nombre"));
							p.add(rs.getString("descripcion"));
							p.add(rs.getLong("iddetalleetapa"));
							p.add(rs.getLong("idetapa"));
							p.add(rs.getInt("porcentaje"));
							data.add(p);
					}
				}
							
				respuesta.clear();
				respuesta.put("valido", true);
				respuesta.put("data", data);
				//respuesta.put("data2", data2);
			}else if(operacion==OPERACION_INCLUIR){
				String idetapa= request.getParameter("idetapa")==null ? "0":request.getParameter("idetapa").toString().trim();
				String idsubetapa= request.getParameter("idsubetapa")==null ? "0":request.getParameter("idsubetapa").toString().trim();
				String porcentaje= request.getParameter("porcentaje")==null ? "0":request.getParameter("porcentaje").toString().trim();
				
				String cade = "INSERT INTO detalleetapa(idetapa, idsubetapa, porcentaje, estatus)"+
							  " VALUES("+idetapa+","+idsubetapa+", "+porcentaje+",1 )";
				st.execute(cade);
				
				respuesta.put("valido", true);
				respuesta.put("msj", "Registro incluido con exito!");
				
			}else if(operacion==OPERACION_ELIMINAR){
				String iddetalleetapa= request.getParameter("iddetalleetapa")==null ? "0":request.getParameter("iddetalleetapa").toString().trim();
				st.execute("DELETE FROM detalleetapa WHERE iddetalleetapa = "+iddetalleetapa);
				respuesta.put("valido", true);
				respuesta.put("msj", "Registro eliminado con exito!");
				
			}
			//System.out.print(idetapa);
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
