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
@WebServlet("/Materialporobra")
public class Materialporobra extends HttpServlet implements Constantes {
	private static final long serialVersionUID = 1L;
	JSONObject respuesta = new JSONObject();
	Connection conexion;
	ConexionWeb conWeb = new ConexionWeb();
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Materialporobra() {
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
			
			if(operacion==OPERACION_INCLUIR){
				String idtipoobra= request.getParameter("idtipoobra").toString().trim();
				String iddetalleetapa= request.getParameter("iddetalleetapa").toString().trim();
				String idmaterial= request.getParameter("idmaterial").toString().trim();
				String cantidadestimada= request.getParameter("cantidadestimada").toString().trim();

				String cade = "INSERT INTO materialporobra (idtipoobra,iddetalleetapa,idmaterial,cantidadestimada,estatus) "
							 + " VALUES("+idtipoobra+","+iddetalleetapa+","+idmaterial+","+cantidadestimada+",1)";
				st.execute(cade);
				respuesta.put("valido", true);
				respuesta.put("msj", "Registro incluido con exito!");
				
			}else if(operacion==OPERACION_LISTADO) {
				String idtipoobra= request.getParameter("idtipoobra")==null ? "0":request.getParameter("idtipoobra").toString().trim();
				String iddetalleetapa= request.getParameter("iddetalleetapa")==null ? "0":request.getParameter("iddetalleetapa").toString().trim();
				int desdePrecio = request.getParameter("desdePrecio")==null ? 0:(Integer.valueOf(request.getParameter("desdePrecio")));
				JSONArray data = new JSONArray();
				
				if(desdePrecio == 1) {
					rs = st.executeQuery("SELECT etapa.idetapa, etapa.nombre FROM materialporobra inner join detalleetapa on " + 
							"detalleetapa.iddetalleetapa=materialporobra.iddetalleetapa inner join etapa on etapa.idetapa=detalleetapa.idetapa " + 
							"where idtipoobra= "+idtipoobra+" group by etapa.idetapa, etapa.nombre");
									
					
					while (rs.next()) {
							JSONArray p = new JSONArray();
							
							p.add(rs.getLong("idetapa"));
							p.add(rs.getString("nombre"));
							data.add(p);
					}
				}else {
					rs = st.executeQuery("SELECT idmaterialporobra, material.idmaterial, detalleetapa.iddetalleetapa, cantidadestimada, idtipoobra,material.nombre as nombrematerial, subetapa.nombre as nombresubetapa" + 
							"	FROM public.materialporobra inner join material on material.idmaterial=materialporobra.idmaterial" + 
							"    inner join detalleetapa on detalleetapa.iddetalleetapa=materialporobra.iddetalleetapa inner join" + 
							"    subetapa on subetapa.idsubetapa=detalleetapa.idsubetapa where materialporobra.idtipoobra="+idtipoobra+" and materialporobra.iddetalleetapa="+iddetalleetapa);
									
					
					while (rs.next()) {
							JSONArray p = new JSONArray();
							
							p.add(rs.getLong("iddetalleetapa"));
							p.add(rs.getString("nombrematerial"));
							p.add(rs.getInt("cantidadestimada"));
							p.add(rs.getLong("idmaterialporobra"));
							p.add(rs.getString("nombresubetapa"));
							p.add(rs.getLong("idmaterial"));
							data.add(p);
					}
				}
							
				respuesta.clear();
				respuesta.put("valido", true);
				respuesta.put("data", data);
			}else if(operacion==OPERACION_LISTADO_MATERIALPOROBRA) {
				String idtipoobra= request.getParameter("idtipoobra")==null ? "0":request.getParameter("idtipoobra").toString().trim();
				String idetapa= request.getParameter("idetapa")==null ? "0":request.getParameter("idetapa").toString().trim();
				
				rs = st.executeQuery("SELECT count(*) as contador " + 
						"	FROM etapa inner join detalleetapa on detalleetapa.idetapa=etapa.idetapa inner join materialporobra on " + 
						"    materialporobra.iddetalleetapa=detalleetapa.iddetalleetapa inner join tipoobra on  " + 
						"    tipoobra.idtipoobra=materialporobra.idtipoobra where tipoobra.idtipoobra="+idtipoobra+" and etapa.idetapa="+idetapa);
				respuesta.clear();
				if(rs.next()) {
					respuesta.put("valido", true);
					respuesta.put("contador", rs.getInt("contador"));
					
				}else {
					respuesta.put("valido", false);
					respuesta.put("msj", "No existe el tipo de obra con el id="+idtipoobra);
				}
			}else if(operacion==OPERACION_CONSULTAR){
				String idtipoobra= request.getParameter("idtipoobra")==null ? "0":request.getParameter("idtipoobra").toString().trim();
				rs = st.executeQuery("SELECT etapa.idetapa,etapa.nombre,tipoobra.idtipoobra from etapa inner join detalleetapa on detalleetapa.idetapa=etapa.idetapa " + 
						"inner join materialporobra on materialporobra.iddetalleetapa=detalleetapa.iddetalleetapa " + 
						"inner join tipoobra on tipoobra.idtipoobra=materialporobra.idtipoobra "+
						"where materialporobra.idtipoobra="+idtipoobra+" group by etapa.idetapa,tipoobra.idtipoobra");
				JSONArray data = new JSONArray();
				while (rs.next()) {
					JSONArray p = new JSONArray();
					
					//p.add(rs.getLong("iddetalleetapa"));
					p.add(rs.getLong("idetapa"));
					p.add(rs.getString("nombre"));
					p.add(rs.getLong("idtipoobra"));
					data.add(p);
				}
				respuesta.clear();
				respuesta.put("valido", true);
				respuesta.put("data", data);
			}else if(operacion==OPERACION_ELIMINAR){
				String idmaterial= request.getParameter("idmaterial")==null ? "0":request.getParameter("idmaterial").toString().trim();
				String iddetalleetapa= request.getParameter("iddetalleetapa")==null ? "0":request.getParameter("iddetalleetapa").toString().trim();
				st.execute("DELETE FROM materialporobra WHERE idmaterial = "+idmaterial+" and iddetalleetapa="+iddetalleetapa);
				respuesta.put("valido", true);
				respuesta.put("msj", "Registro eliminado con exito!");
			}else if(operacion==OPERACION_EDITAR){
				String idmaterial= request.getParameter("idmaterial")==null ? "0":request.getParameter("idmaterial").toString().trim();
				String iddetalleetapa= request.getParameter("iddetalleetapa")==null ? "0":request.getParameter("iddetalleetapa").toString().trim();
				String cantidad= request.getParameter("cantidad").toString().trim();
				
				String cade = "UPDATE materialporobra SET cantidadestimada = "+cantidad+" WHERE iddetalleetapa = "+iddetalleetapa+" and idmaterial="+idmaterial;
				st.execute(cade);
				respuesta.put("valido", true);
				respuesta.put("msj", "Registro editado con exito!");
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
