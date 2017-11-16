package ve.com.proherco.web.comun;
import java.sql.Connection;
import java.sql.SQLException;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;


public class ConexionWeb {
	
	//public ConexionWeb() {
		//super();		
	//}

	private static Connection conexion = null; 
	
	public Connection abrirConn(){
		Context initCtx = null;;
		Context envCtx = null;
		try {
			initCtx = new InitialContext();
			envCtx = (Context) initCtx.lookup("java:comp/env");
			DataSource ds = (DataSource) envCtx.lookup( "jdbc/obras" );
			if ( ds == null ) {
				try {
				   throw new Exception("Data source not found!");
				} catch (Exception e) {						
					e.printStackTrace();
				}					
			}
				
			try {
				conexion = ds.getConnection();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		} catch (NamingException e) {
			e.printStackTrace();
		}
		return conexion;
	}
	
	public void cierraConn(){
		try {
			conexion.commit();
			conexion.close();
		} catch (SQLException e) {			
			e.printStackTrace();
		}
		
	}

}
