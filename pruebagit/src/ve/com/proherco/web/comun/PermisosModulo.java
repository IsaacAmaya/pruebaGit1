package ve.com.proherco.web.comun;

import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;

public class PermisosModulo {

	public PermisosModulo() {
		
	}
	
	public boolean getPermiso(HttpSession session, String modulo, String tipo) {
		boolean p = false;
		if(session.getAttribute("permisosModulo")!=null) {
			JSONObject permisosModulo = (JSONObject)session.getAttribute("permisosModulo");
			JSONObject pModulo = (JSONObject)permisosModulo.get(modulo);
			if(pModulo!=null) {
				p = Boolean.valueOf(pModulo.get(tipo)==null ? "false":pModulo.get(tipo).toString());
			}
			
		}
		return p;
	}
	
	
}
