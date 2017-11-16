  <%@page import="java.util.ArrayList"%>
<%@ page language="java"%>
<%@ page import="java.io.IOException"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.Statement"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="java.sql.SQLException"%>

<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="org.json.simple.JSONObject"%>

<%@ page import="ve.com.proherco.web.comun.ConexionWeb"%>
<%
	JSONObject respuesta = new JSONObject();
	Connection conexion;
	ConexionWeb conWeb = new ConexionWeb();

	response.setContentType("application/json; charset=UTF-8");
	response.setCharacterEncoding("UTF-8");

	conexion = conWeb.abrirConn();
	Statement st = conexion.createStatement();
	Statement st2 = conexion.createStatement();
	Statement st3 = conexion.createStatement();
	ResultSet rs = null;
	ResultSet rs2 = null;
	ResultSet rs3 = null;

	%>
  
  <!-- ### INICIO DEL CONTENEDOR DEL GRAFICO -->
      <div class="col-sm-6 col-md-4 col-xs-12">
      <div class="orden grafico6 col-md-12 col-sm-12 col-xs-12" style="border: solid 0px red;padding-right:0px;padding-left:0px">
    		<div class="panel panel-default " >
    				<div class="panel-heading" > 
    				<ul class="panel-opcion" style="margin-top:-5px;">
                                        <li><a href="#" class=""  data-toggle="modal" data-target=".charts-grafico5"><span class="glyphicon glyphicon-fullscreen"></span></a></li>
                                       
                    </ul>
               <h3 class="panel-title" style="font-size: 18px; ">Material Disponible</h3>
                    </div>
    		    <div class="panel panel-body" style="padding:0px;">
			    <div  class="chart-holder" style=" height:260px;overflow:auto;" id="scrollbar3">
			    <table class="table-bordered tab" style="box-sizing: border-box; width:100%;" >
           <thead >
              <tr >
                
                <th >MATERIAL</th>
                <th >ESTADO</th>
                <th >DISPONIBLE</th>
              </tr>
            </thead>
            <tbody>
            <%
           
            rs = st.executeQuery("select idmaterial, nombre, existencia from material order by nombre asc");
        	while (rs.next()) {
        	%>
			<tr >               
                <td>&nbsp;&nbsp;&nbsp;&nbsp;<%=rs.getString("nombre")%></td>
                
                <td style="text-align:center">
                
               <%
               	if (rs.getDouble("existencia")<=0){
					%>
					<span class="label label-danger">AGOTADO</span></td>
					<%	
               	}else {
               		%>
               		<span class="label label-success">DISPONIBLE</span></td>
               		
               		<%
               		
               	}
               	
               %>
                
                <td class="progress">
  				<div  style="text-align:center;"><b>
    			<%=rs.getInt("existencia")%></b></div>
    			</td>
                              
              </tr>
			<%	}	
				respuesta.clear();
				if (rs != null)
				rs.close();
				st.close();
				
			%>  
            </tbody>
          </table>
			    				    	
			    	</div>
			   </div>
    			</div>
    			
    			
    	</div>
      </div>
      
      
      <!-- ### FIN DEL CONTENEDOR DEL GRAFICO -->
      
     <!-- INICIO DEL MODAL DEL GRAFICO -->
<div class="modal fade charts-grafico5" role="dialog" tabindex=-1 aria-labelledby="myLargeModalLabel">
 <div class="modal-dialog modal-lg" role="document">
  <div class="modal-content"> <div class="modal-header"> 
 		<button type="button" class="close" data-dismiss="modal" aria-label="Close">
 		<span aria-hidden=true>&times;</span>
 		</button>
  <h4 class="modal-title" id="myLargeModalLabel" style="text-align:center;"> Estado de Materiales <%=session.getAttribute("nombreproyecto") %></h4>
   </div> 
   <div class="modal-body" style="min-height:300px;margin-top:-20px;"> 
   	<div class="row">
	   		
	   			<div id="" class="col-md-6" style="max-height:500px;overflow:auto;">
	 			
			    	<table class="table-bordered tab" style="box-sizing: border-box; width:100%;" >
           <thead >
              <tr >
                
                <th >MATERIAL</th>
                <th >ESTADO</th>
                <th >DESPACHADO</th>
                
              </tr>
            </thead>
            <tbody>
            <%
            
            rs2 = st2.executeQuery("select detallesolicitud.idmaterial, material.nombre as nombrematerial, solicitudmaterial.estatus, sum(detallesolicitud.cantidad) as cantidad " 
					+ "from detallesolicitud " 
					+ "inner join solicitudmaterial on solicitudmaterial.idsolicitudmaterial=detallesolicitud.idsolicitudmaterial " 
					+ "inner join material on material.idmaterial=detallesolicitud.idmaterial "
					+ "inner join obra on obra.idobra=solicitudmaterial.idobra " 
					+ "where solicitudmaterial.estatus=1 and obra.idproyecto="+session.getAttribute("idproyecto")+" "
					+ "group by detallesolicitud.idmaterial, material.nombre, solicitudmaterial.estatus " 
					+ "order by material.nombre asc");
        	while (rs2.next()) {
        	%>
			<tr >               
                <td>&nbsp;&nbsp;&nbsp;&nbsp;<%=rs2.getString("nombrematerial")%></td>
                <td style="text-align:center"><span class="label label-primary">DESPACHADO</span></td>
                <td class="progress">
  				<div  style="text-align:center ;color:#337ab7"><b>
    			<%=rs2.getString("cantidad")%></b></div>
    			</td>
                              
              </tr>
			<%	}	
				respuesta.clear();
				if (rs2 != null)
				rs2.close();
				st2.close();
			%>  
            </tbody>
          </table>
			    </div>	
			    	
			    	
	   
	   
		   		<div id="" class="col-md-6" style="max-height:500px;overflow:auto;">
	 			
			    	<table class="table-bordered tab" style="box-sizing: border-box; width:100%;" >
           <thead >
              <tr >
                
                <th >MATERIAL</th>
                <th >ESTADO</th>
                <th >CANTIDAD</th>
              </tr>
            </thead>
            <tbody>
            <%
            
            rs3 = st3.executeQuery("select detallesolicitud.idmaterial, material.nombre as nombrematerial, solicitudmaterial.estatus, sum(detallesolicitud.cantidad) as cantidaddespachada " 
					+ "from detallesolicitud " 
					+ "inner join solicitudmaterial on solicitudmaterial.idsolicitudmaterial=detallesolicitud.idsolicitudmaterial " 
					+ "inner join material on material.idmaterial=detallesolicitud.idmaterial " 
					+ "inner join obra on obra.idobra=solicitudmaterial.idobra "
					+ "where solicitudmaterial.estatus=0 and obra.idproyecto="+session.getAttribute("idproyecto")+" "
					+ "group by detallesolicitud.idmaterial, material.nombre, solicitudmaterial.estatus " 
					+ "order by material.nombre asc");
        	while (rs3.next()) {
        	%>
			<tr >               
                <td>&nbsp;&nbsp;&nbsp;&nbsp;<%=rs3.getString("nombrematerial")%></td>
                <td style="text-align:center"><span class="label label-warning" >POR DESPACHAR</span></td>
                
                <td class="progress">
  				<div  style="text-align:center;color:#f0ad4e"><b>
    			<%=rs3.getString("cantidaddespachada")%></b></div>
    			</td>
                              
              </tr>
			<%	}	
				respuesta.clear();
				if (rs3 != null)
				rs3.close();
				st3.close();
				conexion.close();
			%>  
            </tbody>
          </table>
			    </div>
		   		
   			</div>
   </div>
   
   </div> 
   </div> 
   </div> 
   
    	<!-- FIN DEL MODAL DEL GRAFICO --> 
     
  
     
     
   