package ve.com.proherco.web.action;
import javax.servlet.http.HttpSession; 
import org.apache.struts2.ServletActionContext;
import org.json.simple.JSONObject;

import com.opensymphony.xwork2.ActionSupport;

import ve.com.proherco.web.comun.PermisosModulo;

public class LinkAction extends ActionSupport {

	private static final long serialVersionUID = -2613425890762568273L;
	HttpSession session = ServletActionContext.getRequest().getSession();
	PermisosModulo permisos = new PermisosModulo();
	public String Login(){
		return "Login";
	}
	
	public String login(){
		return "login";		
	}
	
	public String logout(){
		session.removeAttribute("idUsuario");
		session.invalidate();		
		return "login";
	}
	
	public String usuario(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else if(!permisos.getPermiso(session, "usuario", "consultar")) {
			return "noPermiso";		
		}else return "usuario";		
	}
	
	public String addUsuario(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else if(!permisos.getPermiso(session, "usuario", "consultar")) {
			return "noPermiso";		
		}else return "addUsuario";		
	}
	
	public String Usuario(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else return "Usuario";		
	}
	//DASHBOARD
	public String dashboard(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else return "dashboard";		
	}
	
	public String Dashboard(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else return "Dashboard";		
	}
	
	//PERSONA
	public String persona(){		
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else if(!permisos.getPermiso(session, "persona", "consultar")) {
			return "noPermiso";		
		}else return "persona";
	}
	
	public String addPersona(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else if(!permisos.getPermiso(session, "persona", "consultar")) {
			return "noPermiso";		
		}else return "addPersona";		
	}
	
	public String Persona(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else return "Persona";		
	}	
	
	//PROYECTO
	public String addProyecto(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else if(!permisos.getPermiso(session, "proyecto", "consultar")) {
			return "noPermiso";		
		}else  return "addProyecto";		
	}	
	
	public String proyecto(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else if(!permisos.getPermiso(session, "proyecto", "consultar")) {
			return "noPermiso";		
		}else return "proyecto";		
	}	
	
	public String Proyecto(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else return "Proyecto";		
	}
	
	//PROVEEDOR
	public String Proveedor(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else return "Proveedor";		
	}
	
	public String proveedor(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else if(!permisos.getPermiso(session, "proveedor", "consultar")) {
			return "noPermiso";		
		}else  return "proveedor";		
	}
	
	public String addProveedor(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else if(!permisos.getPermiso(session, "proveedor", "consultar")) {
			return "noPermiso";		
		}else return "addProveedor";		
	}
	
	//OBRA
	public String addObra(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else if(!permisos.getPermiso(session, "obras", "consultar")) {
			return "noPermiso";		
		}else  return "addObra";		
	}
	
	public String obra(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else if(!permisos.getPermiso(session, "obras", "consultar")) {
			return "noPermiso";		
		}else  return "obra";		
	}
	
	public String Obra(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else return "Obra";		
	}
	
	//MATERIAL
	public String addMaterial(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else if(!permisos.getPermiso(session, "material", "consultar")) {
			return "noPermiso";		
		}else  return "addMaterial";		
	}
	public String Material(){
		if(session.getAttribute("idusuario")==null){
			return "Material";
		}else return "Material";		
	}	
	public String material(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else if(!permisos.getPermiso(session, "material", "consultar")) {
			return "noPermiso";		
		}else   return "material";		
	}
	
	//COMPRA
	public String addCompra(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else if(!permisos.getPermiso(session, "compra", "consultar")) {
			return "noPermiso";		
		}else return "addCompra";		
	}
	
	public String Compra(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else return "Compra";		
	}
	
	public String compra(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else if(!permisos.getPermiso(session, "compra", "consultar")) {
			return "noPermiso";		
		}else return "compra";		
	}
	
	//SOLICITUD
	public String addSolicitudmaterial(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else if(!permisos.getPermiso(session, "solicitudmaterial", "consultar")) {
			return "noPermiso";		
		}else  return "addSolicitudmaterial";		
	}
	
	public String Solicitudmaterial(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else return "Solicitudmaterial";		
	}
	
	public String solicitudmaterial(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else if(!permisos.getPermiso(session, "solicitudmaterial", "consultar")) {
			return "noPermiso";		
		}else return "solicitudmaterial";
	}
	
	//CUADRILLA
	public String cuadrilla(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else if(!permisos.getPermiso(session, "cuadrilla", "consultar")) {
			return "noPermiso";		
		}else return "cuadrilla";		
	}
	
	public String addCuadrilla(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else if(!permisos.getPermiso(session, "cuadrilla", "consultar")) {
			return "noPermiso";		
		}else  return "addCuadrilla";		
	}
	
	public String Cuadrilla(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else return "Cuadrilla";		
	}
	
	//ETAPA
	public String etapa(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else if(!permisos.getPermiso(session, "etapa", "consultar")) {
			return "noPermiso";		
		}else return "etapa";		
	}
	
	public String Etapa(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else return "Etapa";		
	}
	
	public String addEtapa(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else if(!permisos.getPermiso(session, "etapa", "consultar")) {
			return "noPermiso";		
		}else  return "addEtapa";		
	}
	
	//SUBETAPA
	public String subetapa(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else if(!permisos.getPermiso(session, "subetapa", "consultar")) {
			return "noPermiso";		
		}else return "subetapa";		
	}
	
	public String Subetapa(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else return "Subetapa";		
	}
	
	public String addSubetapa(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else if(!permisos.getPermiso(session, "subetapa", "consultar")) {
			return "noPermiso";		
		}else return "addSubetapa";		
	}
	
	//TIPOOBRA
	public String addTipoobra(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else if(!permisos.getPermiso(session, "tipoobra", "consultar")) {
			return "noPermiso";		
		}else return "addTipoobra";		
	}
	
	public String tipoobra(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else if(!permisos.getPermiso(session, "tipoobra", "consultar")) {
			return "noPermiso";		
		}else return "tipoobra";		
	}
	
	public String Tipoobra(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else return "Tipoobra";		
	}
	
	//CARGO
	public String cargo(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else if(!permisos.getPermiso(session, "cargo", "consultar")) {
			return "noPermiso";		
		}else return "cargo";		
	}
	
	public String Cargo(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else return "Cargo";		
	}
	
	public String addCargo(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else if(!permisos.getPermiso(session, "cargo", "consultar")) {
			return "noPermiso";		
		}else return "addCargo";		
	}	
	
	//TRABAJADOR
	public String addTrabajador(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else if(!permisos.getPermiso(session, "trabajador", "consultar")) {
			return "noPermiso";		
		}else return "addTrabajador";		
	}
	
	public String Trabajador(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else return "Trabajador";		
	}
	
	public String trabajador(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else if(!permisos.getPermiso(session, "trabajador", "consultar")) {
			return "noPermiso";		
		}else return "trabajador";		
	}
	
	//DETALLEETAPA
	public String Detalleetapa(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else return "Detalleetapa";		
	}
	
	public String Detallesolicitud(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else return "Detallesolicitud";
	}
	
	public String Compramaterial(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else return "Compramaterial";
	}
	
	public String Materialporobra(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else return "Materialporobra";		
	}
	
	//TRABAJADORCUADRILLA
	public String addTrabajadorcuadrilla(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else return "addTrabajadorcuadrilla";		
	}
	
	public String Trabajadorcuadrilla(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else return "Trabajadorcuadrilla";		
	}
	
	public String trabajadorcuadrilla(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else return "trabajadorcuadrilla";		
	}
	
	public String menu(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else return "menu";	
	}
	
	public String despachomaterial(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else if(!permisos.getPermiso(session, "despachomaterial", "consultar")) {
			return "noPermiso";		
		}else return "despachomaterial";		
	}
	
	public String Despachomaterial(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else return "Despachomaterial";		
	}
	
	public String addDespachomaterial(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else if(!permisos.getPermiso(session, "despachomaterial", "consultar")) {
			return "noPermiso";		
		}else  return "addDespachomaterial";		
	}
	
	
	//PRECIO
	public String precio(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else if(!permisos.getPermiso(session, "precio", "consultar")) {
			return "noPermiso";		
		}else return "precio";		
	}
	
	public String Precio(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else return "Precio";		
	}
	
	public String addPrecio(){
		if(session.getAttribute("idusuario")==null){
			return "login";
		}else if(!permisos.getPermiso(session, "precio", "consultar")) {
			return "noPermiso";		
		}else  return "addPrecio";		
	}
	
	//PRECIO
		public String inspeccion(){
			if(session.getAttribute("idusuario")==null){
				return "login";
			}else if(!permisos.getPermiso(session, "inspeccion", "consultar")) {
				return "noPermiso";		
			}else return "inspeccion";		
		}
		
		public String Inspeccion(){
			if(session.getAttribute("idusuario")==null){
				return "Inspeccion";
			}else return "Inspeccion";		
		}
		
		public String addInspeccion(){
			if(session.getAttribute("idusuario")==null){
				return "login";
			}else if(!permisos.getPermiso(session, "inspeccion", "consultar")) {
				return "noPermiso";		
			}else  return "addInspeccion";		
		}
	
		//PAGO
		
		public String pago(){
			if(session.getAttribute("idusuario")==null){
				return "login";
			}else if(!permisos.getPermiso(session, "pago", "consultar")) {
				return "noPermiso";		
			}else return "pago";		
		}
		
		public String addPago(){
			if(session.getAttribute("idusuario")==null){
				return "login";
			}else if(!permisos.getPermiso(session, "pago", "consultar")) {
				return "noPermiso";		
			}else return "addPago";
		}
		
		public String Pago(){
			if(session.getAttribute("idusuario")==null){
				return "login";
			}else return "Pago";
		}
	
		
}
	
