<%@ page contentType="application/pdf; charset=utf-8" language="java" import="java.sql.*" errorPage="" 
import="javax.naming.Context"
import="javax.naming.InitialContext"
import="javax.naming.NamingException"
import="javax.sql.DataSource"
import="javax.servlet.http.HttpSession"
import="net.sf.jasperreports.engine.*" 
import="net.sf.jasperreports.engine.design.*" 
import="net.sf.jasperreports.engine.data.*"
import="net.sf.jasperreports.engine.export.*"
import="net.sf.jasperreports.engine.util.*"
import="net.sf.jasperreports.view.*"
import="net.sf.jasperreports.view.save.*"
import="java.sql.*"
import="java.util.*" 
import="java.io.*" 

%>
  <%@ page import="ve.com.proherco.web.comun.ValidaFormato"%>
  <%@ page import ="ve.com.proherco.web.comun.ConexionWeb"%>

<%
Connection conn = null;
ConexionWeb c = new ConexionWeb();
		try{
			
				conn = c.abrirConn();
				
				Map parameters = new HashMap();
				
				String idcompra= request.getParameter("idcompra")==null ? "0":request.getParameter("idcompra").toString().trim();
				String fechaDesde= request.getParameter("in")==null || request.getParameter("in")==""  ? "01/01/2017":request.getParameter("in").toString().trim();
				String fechaHasta= request.getParameter("fn")==null || request.getParameter("fn")=="" ? "":request.getParameter("fn").toString().trim();
				String proveedor= request.getParameter("p")==null ? "":request.getParameter("p").toString().trim();
				
				String categoria= request.getParameter("c")==null || request.getParameter("c")=="" ? "":request.getParameter("c").toString().trim();
				String material= request.getParameter("m")==null || request.getParameter("m")=="" ? "":request.getParameter("m").toString().trim();
				String tReporte = request.getParameter("tr")==null || request.getParameter("tr")=="" ? "":request.getParameter("tr").toString().trim();
				
				String tipoReporte = "compra.jasper";
				String condicion = "compra.idcompra="+idcompra;
				
				parameters.put("LOGO",application.getRealPath("/Archivos/images/logo_reportes.png"));
				
				String cProveedor = "";
				String cCategoria = "";
				String cMaterial = "";
				
				if(!proveedor.equals("")){
					cProveedor = " AND compra.idproveedor="+proveedor;
				}
				
				if(!categoria.equals("")){
					cCategoria = " AND material.categoria='"+categoria+"'";
				}
				
				if(!material.equals("")){
					cMaterial = " AND material.idmaterial="+material;
				}

				if(tReporte.equals("1")){
					condicion = " compra.fecha BETWEEN '"+ValidaFormato.cambiarFecha(fechaDesde, 1)+"' AND '"+ValidaFormato.cambiarFecha(fechaHasta, 1)+"' "+cProveedor;
					tipoReporte = "listadoCompra.jasper";
				}else if(tReporte.equals("2")){
					condicion = " compra.fecha BETWEEN '"+ValidaFormato.cambiarFecha(fechaDesde, 1)+"' AND '"+ValidaFormato.cambiarFecha(fechaHasta, 1)+"' "+cProveedor+cCategoria+cMaterial;
					System.out.print(condicion);
					tipoReporte = "compra.jasper";
				}
				
				parameters.put("condicion",condicion);
				
				if(fechaDesde == "01/01/2017"){
					parameters.put("contenido", "Compras realizadas hasta la fecha "+fechaHasta);
				}else{
					parameters.put("contenido", "Compras realizadas desde "+fechaDesde+" hasta "+fechaHasta);
				}
				
				parameters.put("hasta",fechaHasta);
				byte[] bytes = JasperRunManager.runReportToPdf(application.getRealPath("/Archivos/Reportes/jasper/"+tipoReporte), parameters, conn);
				
				response.setContentType("application/pdf");
				response.setContentLength(bytes.length);
				ServletOutputStream ouputStream = response.getOutputStream();
				ouputStream.write(bytes);
				ouputStream.flush();
				ouputStream.close();
				
				conn.commit();
				conn.close();
          	
      }catch (JRException e){
    	  e.printStackTrace();
    	    System.out.println(e.getMessage()); 
    	  	/* session.setAttribute("mensaje", "Error interno del servidor, por favor intente mas tarde.");
			String nextJSP = "/mensaje.jsp?op=false";
			RequestDispatcher dispatcher = getServletContext().getRequestDispatcher(nextJSP);
			dispatcher.forward(request,response); */
			
      }catch (Exception e){	
    	  e.printStackTrace();
    	  System.out.println(e.getMessage()); 
    	 	/* session.setAttribute("mensaje", "Error interno del servidor, por favor intente mas tarde.");
			String nextJSP = "/mensaje.jsp?op=false";
			RequestDispatcher dispatcher = getServletContext().getRequestDispatcher(nextJSP);
			dispatcher.forward(request,response);         */
	
      }         

%>


