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

import ve.com.proherco.web.comun.ConexionWeb;
import ve.com.proherco.web.comun.Constantes;
import ve.com.proherco.web.comun.PermisosModulo;
import ve.com.proherco.web.comun.ValidaFormato;

/**
 * Servlet implementation class Usuario
 */
@WebServlet("/Usuario")
public class Usuario extends HttpServlet implements Constantes {
	private static final long serialVersionUID = 1L;
	JSONObject respuesta = new JSONObject();
	Connection conexion;
	ConexionWeb conWeb = new ConexionWeb();
	HttpSession session;
	PermisosModulo permisos = new PermisosModulo();
	String MODULO = "usuario";
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Usuario() {
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
		session = request.getSession();							
		//----------------------------------------------------------
		
		int operacion = request.getParameter("operacion")==null ? 0:(Integer.valueOf(request.getParameter("operacion")));		
		try {
			conexion = conWeb.abrirConn();
			Statement st = conexion.createStatement();
			ResultSet rs =null; 
			
			if(operacion==OPERACION_LISTADO) {
				JSONArray data = new JSONArray();
				rs = st.executeQuery("SELECT * FROM usuarios as u left join persona as p on u.idpersona=p.idpersona");
				while (rs.next()) {
						JSONArray p = new JSONArray();
						p.add(rs.getLong("idusuario"));
						p.add(rs.getString("usuario").trim());
						p.add(rs.getString("apellido").trim()+" "+rs.getString("nombre").trim());
						p.add(rs.getInt("estatus")==0 ? "Activo":"Inactivo");
						data.add(p);
				}			
				respuesta.clear();
				respuesta.put("valido", true);
				respuesta.put("data", data);
			}else if(operacion==OPERACION_INCLUIR){
				if(permisos.getPermiso(session, MODULO, PERMISO_TIPO_INCLUIR)) {
					String idpersona= request.getParameter("idpersona").toString().trim();
					String txtUsuario= request.getParameter("txtUsuario").toString().trim();
					String txtClave= request.getParameter("txtClave").toString().trim();
					
					boolean app_acceso= request.getParameter("app_acceso")==null ? false:(Boolean.valueOf(request.getParameter("app_acceso").trim()));
					boolean cambiarClave= request.getParameter("cambiarClave")==null ? false:(Boolean.valueOf(request.getParameter("cambiarClave").trim()));
					boolean app_fullDash= request.getParameter("app_fullDash")==null ? false:(Boolean.valueOf(request.getParameter("app_fullDash").trim()));
					boolean app_Inspecciones= request.getParameter("app_Inspecciones")==null ? false:(Boolean.valueOf(request.getParameter("app_Inspecciones").trim()));
					boolean app_Materiales= request.getParameter("app_Materiales")==null ? false:(Boolean.valueOf(request.getParameter("app_Materiales").trim()));

					
					
					String permisos_modulo= request.getParameter("permisosmodulo")==null ? "":request.getParameter("permisosmodulo").toString().trim();
					JSONObject p = new JSONObject();
					String permisosModulos[] = permisos_modulo.split("&"); 
					for (int i = 0; i < permisosModulos.length; i++) {
						String key = permisosModulos[i].substring(0, permisosModulos[i].indexOf("="));
						p.put(key, true);
					}
					
					Long idUsuario = new Long(0);
					Statement stId = conexion.createStatement();
					ResultSet rsId = stId.executeQuery("select nextval('idusuario') as idusuario");
					if(rsId.next()) {
						idUsuario = rsId.getLong("idusuario");
					}
					
					String cade = "INSERT INTO usuarios(idusuario, idpersona, usuario, clave, appacceso, appfulldash, appinspecciones, appmateriales)"
								 + " VALUES("+idUsuario+","+idpersona+",'"+txtUsuario+"','"+txtClave+"', "+app_acceso+", "+app_fullDash+" , "+app_Inspecciones+", "+app_Materiales+")";	
					st.execute(cade);					
					String cadePermisoPersona = "INSERT INTO permisos(idusuario,modulo,incluir,editar,eliminar,consultar) "
							+ "VALUES("+idUsuario+",'persona',"+(p.get("PersonaChkIncluir")==null ? false:true)+","+
																(p.get("PersonaChkModificar")==null ? false:true)+","+
																(p.get("PersonaChkEliminar")==null ? false:true)+","+
																(p.get("PersonaChkConsultar")==null ? false:true)+")";
					st.execute(cadePermisoPersona);					
					String cadePermisoCargo = "INSERT INTO permisos(idusuario,modulo,incluir,editar,eliminar,consultar) "
							+ "VALUES("+idUsuario+",'cargo',"+(p.get("CargoChkIncluir")==null ? false:true)+","+
																(p.get("CargoChkModificar")==null ? false:true)+","+
																(p.get("CargoChkEliminar")==null ? false:true)+","+
																(p.get("CargoChkConsultar")==null ? false:true)+")";
					st.execute(cadePermisoCargo);					
					String cadePermisoTrabajador = "INSERT INTO permisos(idusuario,modulo,incluir,editar,eliminar,consultar) "
							+ "VALUES("+idUsuario+",'trabajador',"+(p.get("TrabajadorChkIncluir")==null ? false:true)+","+
																(p.get("TrabajadorChkModificar")==null ? false:true)+","+
																(p.get("TrabajadorChkEliminar")==null ? false:true)+","+
																(p.get("TrabajadorChkConsultar")==null ? false:true)+")";
					st.execute(cadePermisoTrabajador);
					String cadePermisoCuadrilla = "INSERT INTO permisos(idusuario,modulo,incluir,editar,eliminar,consultar) "
							+ "VALUES("+idUsuario+",'cuadrilla',"+(p.get("CuadrillaChkIncluir")==null ? false:true)+","+
																(p.get("CuadrillaChkModificar")==null ? false:true)+","+
																(p.get("CuadrillaChkEliminar")==null ? false:true)+","+
																(p.get("CuadrillaChkConsultar")==null ? false:true)+")";
					st.execute(cadePermisoCuadrilla);
					String cadePermisoMaterial = "INSERT INTO permisos(idusuario,modulo,incluir,editar,eliminar,consultar) "
							+ "VALUES("+idUsuario+",'material',"+(p.get("MaterialChkIncluir")==null ? false:true)+","+
																(p.get("MaterialChkModificar")==null ? false:true)+","+
																(p.get("MaterialChkEliminar")==null ? false:true)+","+
																(p.get("MaterialChkConsultar")==null ? false:true)+")";
					st.execute(cadePermisoMaterial);
					String cadePermisoProveedor = "INSERT INTO permisos(idusuario,modulo,incluir,editar,eliminar,consultar) "
							+ "VALUES("+idUsuario+",'proveedor',"+(p.get("ProveedorChkIncluir")==null ? false:true)+","+
																(p.get("ProveedorChkModificar")==null ? false:true)+","+
																(p.get("ProveedorChkEliminar")==null ? false:true)+","+
																(p.get("ProveedorChkConsultar")==null ? false:true)+")";
					st.execute(cadePermisoProveedor);					
					String cadePermisoCompra = "INSERT INTO permisos(idusuario,modulo,incluir,editar,eliminar,consultar) "
							+ "VALUES("+idUsuario+",'compra',"+(p.get("CompraChkIncluir")==null ? false:true)+","+
																(p.get("CompraChkModificar")==null ? false:true)+","+
																(p.get("CompraChkEliminar")==null ? false:true)+","+
																(p.get("CompraChkConsultar")==null ? false:true)+")";
					st.execute(cadePermisoCompra);
					String cadePermisoProyecto = "INSERT INTO permisos(idusuario,modulo,incluir,editar,eliminar,consultar) "
							+ "VALUES("+idUsuario+",'proyecto',"+(p.get("ProyectoChkIncluir")==null ? false:true)+","+
																(p.get("ProyectoChkModificar")==null ? false:true)+","+
																(p.get("ProyectoChkEliminar")==null ? false:true)+","+
																(p.get("ProyectoChkConsultar")==null ? false:true)+")";
					st.execute(cadePermisoProyecto);
					String cadePermisoEtapa = "INSERT INTO permisos(idusuario,modulo,incluir,editar,eliminar,consultar) "
							+ "VALUES("+idUsuario+",'etapa',"+(p.get("EtapaChkIncluir")==null ? false:true)+","+
																(p.get("EtapaChkModificar")==null ? false:true)+","+
																(p.get("EtapaChkEliminar")==null ? false:true)+","+
																(p.get("EtapaChkConsultar")==null ? false:true)+")";
					st.execute(cadePermisoEtapa);
					String cadePermisoSubEtapa = "INSERT INTO permisos(idusuario,modulo,incluir,editar,eliminar,consultar) "
							+ "VALUES("+idUsuario+",'subetapa',"+(p.get("SubEtapaChkIncluir")==null ? false:true)+","+
																(p.get("SubEtapaChkModificar")==null ? false:true)+","+
																(p.get("SubEtapaChkEliminar")==null ? false:true)+","+
																(p.get("SubEtapaChkConsultar")==null ? false:true)+")";
					st.execute(cadePermisoSubEtapa);
					String cadePermisoObras = "INSERT INTO permisos(idusuario,modulo,incluir,editar,eliminar,consultar) "
							+ "VALUES("+idUsuario+",'obras',"+(p.get("ObrasChkIncluir")==null ? false:true)+","+
																(p.get("ObrasChkModificar")==null ? false:true)+","+
																(p.get("ObrasChkEliminar")==null ? false:true)+","+
																(p.get("ObrasChkConsultar")==null ? false:true)+")";
					st.execute(cadePermisoObras);
					String cadePermisoTipoObras = "INSERT INTO permisos(idusuario,modulo,incluir,editar,eliminar,consultar) "
							+ "VALUES("+idUsuario+",'tipoobra',"+(p.get("TipoOChkIncluir")==null ? false:true)+","+
																(p.get("TipoOChkModificar")==null ? false:true)+","+
																(p.get("TipoOChkEliminar")==null ? false:true)+","+
																(p.get("TipoOChkConsultar")==null ? false:true)+")";
					st.execute(cadePermisoTipoObras);
					String cadePermisoSolicitudMaterial = "INSERT INTO permisos(idusuario,modulo,incluir,editar,eliminar,consultar) "
							+ "VALUES("+idUsuario+",'solicitudmaterial',"+(p.get("SolicitudMChkIncluir")==null ? false:true)+","+
																(p.get("SolicitudMChkModificar")==null ? false:true)+","+
																(p.get("SolicitudMChkEliminar")==null ? false:true)+","+
																(p.get("SolicitudMChkConsultar")==null ? false:true)+")";
					st.execute(cadePermisoSolicitudMaterial);
					String cadePermisoDespacho = "INSERT INTO permisos(idusuario,modulo,incluir,editar,eliminar,consultar) "
							+ "VALUES("+idUsuario+",'despachomaterial',"+(p.get("DespachoChkIncluir")==null ? false:true)+","+
																(p.get("DespachoChkModificar")==null ? false:true)+","+
																(p.get("DespachoChkEliminar")==null ? false:true)+","+
																(p.get("DespachoChkConsultar")==null ? false:true)+")";
					st.execute(cadePermisoDespacho);
					String cadePermisoInspecci = "INSERT INTO permisos(idusuario,modulo,incluir,editar,eliminar,consultar) "
							+ "VALUES("+idUsuario+",'inspeccion',"+(p.get("InspecciChkIncluir")==null ? false:true)+","+
																(p.get("InspecciChkModificar")==null ? false:true)+","+
																(p.get("InspecciChkEliminar")==null ? false:true)+","+
																(p.get("InspecciChkConsultar")==null ? false:true)+")";
					st.execute(cadePermisoInspecci);
					String cadePermisoAsignaci = "INSERT INTO permisos(idusuario,modulo,incluir,editar,eliminar,consultar) "
							+ "VALUES("+idUsuario+",'pago',"+(p.get("AsignaciPChkIncluir")==null ? false:true)+","+
																(p.get("AsignaciPChkModificar")==null ? false:true)+","+
																(p.get("AsignaciPChkEliminar")==null ? false:true)+","+
																(p.get("AsignaciPChkConsultar")==null ? false:true)+")";
					st.execute(cadePermisoAsignaci);
					
					String cadePermisoUsuarios = "INSERT INTO permisos(idusuario,modulo,incluir,editar,eliminar,consultar) "
							+ "VALUES("+idUsuario+",'usuario',"+(p.get("UsuariosChkIncluir")==null ? false:true)+","+
																(p.get("UsuariosChkModificar")==null ? false:true)+","+
																(p.get("UsuariosChkEliminar")==null ? false:true)+","+
																(p.get("UsuariosChkConsultar")==null ? false:true)+")";
					st.execute(cadePermisoUsuarios);
					
					String cadePermisoPrecio = "INSERT INTO permisos(idusuario,modulo,incluir,editar,eliminar,consultar) "
							+ "VALUES("+idUsuario+",'precio',"+(p.get("PrecioChkIncluir")==null ? false:true)+","+
																(p.get("PrecioChkModificar")==null ? false:true)+","+
																(p.get("PrecioChkEliminar")==null ? false:true)+","+
																(p.get("PrecioChkConsultar")==null ? false:true)+")";
					
					st.execute(cadePermisoPrecio);
					
					
					
					//permisos Dash
					String permisodash= request.getParameter("permisodash")==null ? "":request.getParameter("permisodash").toString().trim();
					JSONObject pd = new JSONObject();
					String permisosDash[] = permisodash.split("&"); 
					for (int i = 0; i < permisosDash.length; i++) {
						String key = permisosDash[i].substring(0, permisosDash[i].indexOf("="));
						pd.put(key, true);
					}
					
					String GInversionG = "INSERT INTO permisosdash(idusuario,grafica,disponible) "
							+ "VALUES("+idUsuario+",'GInversionG',"+(pd.get("GInversionG")==null ? false:true)+")";
					st.execute(GInversionG);
					
					String GAvancePro = "INSERT INTO permisosdash(idusuario,grafica,disponible) "
							+ "VALUES("+idUsuario+",'GAvancePro',"+(pd.get("GAvancePro")==null ? false:true)+")";
					st.execute(GAvancePro);
					
					
					String GEstadoObra = "INSERT INTO permisosdash(idusuario,grafica,disponible) "
							+ "VALUES("+idUsuario+",'GEstadoObra',"+(pd.get("GEstadoObra")==null ? false:true)+")";
					st.execute(GEstadoObra);
					
					String GEstadoObraEtapa = "INSERT INTO permisosdash(idusuario,grafica,disponible) "
							+ "VALUES("+idUsuario+",'GEstadoObraEtapa',"+(pd.get("GEstadoObraEtapa")==null ? false:true)+")";
					st.execute(GEstadoObraEtapa);
					
					String GMaterialE = "INSERT INTO permisosdash(idusuario,grafica,disponible) "
							+ "VALUES("+idUsuario+",'GMaterialE',"+(pd.get("GMaterialE")==null ? false:true)+")";
					st.execute(GMaterialE);
					
					String GMaterialD = "INSERT INTO permisosdash(idusuario,grafica,disponible) "
							+ "VALUES("+idUsuario+",'GMaterialD',"+(pd.get("GMaterialD")==null ? false:true)+")";
					st.execute(GMaterialD);
					
					String GPagoObra = "INSERT INTO permisosdash(idusuario,grafica,disponible) "
							+ "VALUES("+idUsuario+",'GPagoObra',"+(pd.get("GPagoObra")==null ? false:true)+")";
					st.execute(GPagoObra);
					
					String GPagoCuadrilla = "INSERT INTO permisosdash(idusuario,grafica,disponible) "
							+ "VALUES("+idUsuario+",'GPagoCuadrilla',"+(pd.get("GPagoCuadrilla")==null ? false:true)+")";
					st.execute(GPagoCuadrilla);
					
					String GPrecioMaterial = "INSERT INTO permisosdash(idusuario,grafica,disponible) "
							+ "VALUES("+idUsuario+",'GPrecioMaterial',"+(pd.get("GPrecioMaterial")==null ? false:true)+")";
					st.execute(GPrecioMaterial);
					
					
					
					respuesta.put("valido", true);
					respuesta.put("msj", "Registro incluido con exito!");
				}else {
					respuesta.put("valido", false);
					respuesta.put("msj", MSJ_NO_PERMISO);
				}
			}else if(operacion==OPERACION_EDITAR){
				if(permisos.getPermiso(session, MODULO, PERMISO_TIPO_EDITAR)) {
					String idpersona= request.getParameter("idpersona").toString().trim();
					String idUsuario = request.getParameter("idusuario").toString().trim();
					String txtUsuario= request.getParameter("txtUsuario").toString().trim();
					String txtClave= request.getParameter("txtClave").toString().trim();
					boolean app_acceso= request.getParameter("app_acceso")==null ? false:(Boolean.valueOf(request.getParameter("app_acceso").trim()));
					boolean cambiarClave= request.getParameter("cambiarClave")==null ? false:(Boolean.valueOf(request.getParameter("cambiarClave").trim()));
					boolean app_fullDash= request.getParameter("app_fullDash")==null ? false:(Boolean.valueOf(request.getParameter("app_fullDash").trim()));
					boolean app_Inspecciones= request.getParameter("app_Inspecciones")==null ? false:(Boolean.valueOf(request.getParameter("app_Inspecciones").trim()));
					boolean app_Materiales= request.getParameter("app_Materiales")==null ? false:(Boolean.valueOf(request.getParameter("app_Materiales").trim()));

					String permisos_modulo= request.getParameter("permisosmodulo")==null ? "":request.getParameter("permisosmodulo").toString().trim();
					JSONObject p = new JSONObject();
					String permisosModulos[] = permisos_modulo.split("&"); 
					for (int i = 0; i < permisosModulos.length; i++) {
						String key = permisosModulos[i].substring(0, permisosModulos[i].indexOf("="));
						p.put(key, true);
					}
					
					
					
					String cade = "UPDATE usuarios SET "+(cambiarClave ? ("clave = '"+txtClave+"', "):"")+" usuario = '"+txtUsuario+"', appacceso = "+app_acceso+", appfulldash = "+app_fullDash+", appinspecciones ="+app_Inspecciones+",  appmateriales="+app_Materiales+"  WHERE idusuario= "+idUsuario;	
					st.execute(cade);	
					
					st.execute("DELETE FROM permisos WHERE idusuario = "+idUsuario);
					
					String cadePermisoPersona = "INSERT INTO permisos(idusuario,modulo,incluir,editar,eliminar,consultar) "
							+ "VALUES("+idUsuario+",'persona',"+(p.get("PersonaChkIncluir")==null ? false:true)+","+
																(p.get("PersonaChkModificar")==null ? false:true)+","+
																(p.get("PersonaChkEliminar")==null ? false:true)+","+
																(p.get("PersonaChkConsultar")==null ? false:true)+")";
					st.execute(cadePermisoPersona);					
					String cadePermisoCargo = "INSERT INTO permisos(idusuario,modulo,incluir,editar,eliminar,consultar) "
							+ "VALUES("+idUsuario+",'cargo',"+(p.get("CargoChkIncluir")==null ? false:true)+","+
																(p.get("CargoChkModificar")==null ? false:true)+","+
																(p.get("CargoChkEliminar")==null ? false:true)+","+
																(p.get("CargoChkConsultar")==null ? false:true)+")";
					st.execute(cadePermisoCargo);					
					String cadePermisoTrabajador = "INSERT INTO permisos(idusuario,modulo,incluir,editar,eliminar,consultar) "
							+ "VALUES("+idUsuario+",'trabajador',"+(p.get("TrabajadorChkIncluir")==null ? false:true)+","+
																(p.get("TrabajadorChkModificar")==null ? false:true)+","+
																(p.get("TrabajadorChkEliminar")==null ? false:true)+","+
																(p.get("TrabajadorChkConsultar")==null ? false:true)+")";
					st.execute(cadePermisoTrabajador);
					String cadePermisoCuadrilla = "INSERT INTO permisos(idusuario,modulo,incluir,editar,eliminar,consultar) "
							+ "VALUES("+idUsuario+",'cuadrilla',"+(p.get("CuadrillaChkIncluir")==null ? false:true)+","+
																(p.get("CuadrillaChkModificar")==null ? false:true)+","+
																(p.get("CuadrillaChkEliminar")==null ? false:true)+","+
																(p.get("CuadrillaChkConsultar")==null ? false:true)+")";
					st.execute(cadePermisoCuadrilla);
					String cadePermisoMaterial = "INSERT INTO permisos(idusuario,modulo,incluir,editar,eliminar,consultar) "
							+ "VALUES("+idUsuario+",'material',"+(p.get("MaterialChkIncluir")==null ? false:true)+","+
																(p.get("MaterialChkModificar")==null ? false:true)+","+
																(p.get("MaterialChkEliminar")==null ? false:true)+","+
																(p.get("MaterialChkConsultar")==null ? false:true)+")";
					st.execute(cadePermisoMaterial);
					String cadePermisoProveedor = "INSERT INTO permisos(idusuario,modulo,incluir,editar,eliminar,consultar) "
							+ "VALUES("+idUsuario+",'proveedor',"+(p.get("ProveedorChkIncluir")==null ? false:true)+","+
																(p.get("ProveedorChkModificar")==null ? false:true)+","+
																(p.get("ProveedorChkEliminar")==null ? false:true)+","+
																(p.get("ProveedorChkConsultar")==null ? false:true)+")";
					st.execute(cadePermisoProveedor);					
					String cadePermisoCompra = "INSERT INTO permisos(idusuario,modulo,incluir,editar,eliminar,consultar) "
							+ "VALUES("+idUsuario+",'compra',"+(p.get("CompraChkIncluir")==null ? false:true)+","+
																(p.get("CompraChkModificar")==null ? false:true)+","+
																(p.get("CompraChkEliminar")==null ? false:true)+","+
																(p.get("CompraChkConsultar")==null ? false:true)+")";
					st.execute(cadePermisoCompra);
					String cadePermisoProyecto = "INSERT INTO permisos(idusuario,modulo,incluir,editar,eliminar,consultar) "
							+ "VALUES("+idUsuario+",'proyecto',"+(p.get("ProyectoChkIncluir")==null ? false:true)+","+
																(p.get("ProyectoChkModificar")==null ? false:true)+","+
																(p.get("ProyectoChkEliminar")==null ? false:true)+","+
																(p.get("ProyectoChkConsultar")==null ? false:true)+")";
					st.execute(cadePermisoProyecto);
					String cadePermisoEtapa = "INSERT INTO permisos(idusuario,modulo,incluir,editar,eliminar,consultar) "
							+ "VALUES("+idUsuario+",'etapa',"+(p.get("EtapaChkIncluir")==null ? false:true)+","+
																(p.get("EtapaChkModificar")==null ? false:true)+","+
																(p.get("EtapaChkEliminar")==null ? false:true)+","+
																(p.get("EtapaChkConsultar")==null ? false:true)+")";
					st.execute(cadePermisoEtapa);
					String cadePermisoSubEtapa = "INSERT INTO permisos(idusuario,modulo,incluir,editar,eliminar,consultar) "
							+ "VALUES("+idUsuario+",'subetapa',"+(p.get("SubEtapaChkIncluir")==null ? false:true)+","+
																(p.get("SubEtapaChkModificar")==null ? false:true)+","+
																(p.get("SubEtapaChkEliminar")==null ? false:true)+","+
																(p.get("SubEtapaChkConsultar")==null ? false:true)+")";
					st.execute(cadePermisoSubEtapa);
					String cadePermisoObras = "INSERT INTO permisos(idusuario,modulo,incluir,editar,eliminar,consultar) "
							+ "VALUES("+idUsuario+",'obras',"+(p.get("ObrasChkIncluir")==null ? false:true)+","+
																(p.get("ObrasChkModificar")==null ? false:true)+","+
																(p.get("ObrasChkEliminar")==null ? false:true)+","+
																(p.get("ObrasChkConsultar")==null ? false:true)+")";
					st.execute(cadePermisoObras);
					String cadePermisoTipoObras = "INSERT INTO permisos(idusuario,modulo,incluir,editar,eliminar,consultar) "
							+ "VALUES("+idUsuario+",'tipoobra',"+(p.get("TipoOChkIncluir")==null ? false:true)+","+
																(p.get("TipoOChkModificar")==null ? false:true)+","+
																(p.get("TipoOChkEliminar")==null ? false:true)+","+
																(p.get("TipoOChkConsultar")==null ? false:true)+")";
					st.execute(cadePermisoTipoObras);
					String cadePermisoSolicitudMaterial = "INSERT INTO permisos(idusuario,modulo,incluir,editar,eliminar,consultar) "
							+ "VALUES("+idUsuario+",'solicitudmaterial',"+(p.get("SolicitudMChkIncluir")==null ? false:true)+","+
																(p.get("SolicitudMChkModificar")==null ? false:true)+","+
																(p.get("SolicitudMChkEliminar")==null ? false:true)+","+
																(p.get("SolicitudMChkConsultar")==null ? false:true)+")";
					st.execute(cadePermisoSolicitudMaterial);
					String cadePermisoDespacho = "INSERT INTO permisos(idusuario,modulo,incluir,editar,eliminar,consultar) "
							+ "VALUES("+idUsuario+",'despachomaterial',"+(p.get("DespachoChkIncluir")==null ? false:true)+","+
																(p.get("DespachoChkModificar")==null ? false:true)+","+
																(p.get("DespachoChkEliminar")==null ? false:true)+","+
																(p.get("DespachoChkConsultar")==null ? false:true)+")";
					st.execute(cadePermisoDespacho);
					String cadePermisoInspecci = "INSERT INTO permisos(idusuario,modulo,incluir,editar,eliminar,consultar) "
							+ "VALUES("+idUsuario+",'inspeccion',"+(p.get("InspecciChkIncluir")==null ? false:true)+","+
																(p.get("InspecciChkModificar")==null ? false:true)+","+
																(p.get("InspecciChkEliminar")==null ? false:true)+","+
																(p.get("InspecciChkConsultar")==null ? false:true)+")";
					st.execute(cadePermisoInspecci);
					String cadePermisoAsignaci = "INSERT INTO permisos(idusuario,modulo,incluir,editar,eliminar,consultar) "
							+ "VALUES("+idUsuario+",'pago',"+(p.get("AsignaciPChkIncluir")==null ? false:true)+","+
																(p.get("AsignaciPChkModificar")==null ? false:true)+","+
																(p.get("AsignaciPChkEliminar")==null ? false:true)+","+
																(p.get("AsignaciPChkConsultar")==null ? false:true)+")";
					st.execute(cadePermisoAsignaci);
					String cadePermisoUsuarios = "INSERT INTO permisos(idusuario,modulo,incluir,editar,eliminar,consultar) "
							+ "VALUES("+idUsuario+",'usuario',"+(p.get("UsuariosChkIncluir")==null ? false:true)+","+
																(p.get("UsuariosChkModificar")==null ? false:true)+","+
																(p.get("UsuariosChkEliminar")==null ? false:true)+","+
																(p.get("UsuariosChkConsultar")==null ? false:true)+")";
					st.execute(cadePermisoUsuarios);
					
					String cadePermisoPrecio = "INSERT INTO permisos(idusuario,modulo,incluir,editar,eliminar,consultar) "
							+ "VALUES("+idUsuario+",'precio',"+(p.get("PrecioChkIncluir")==null ? false:true)+","+
																(p.get("PrecioChkModificar")==null ? false:true)+","+
																(p.get("PrecioChkEliminar")==null ? false:true)+","+
																(p.get("PrecioChkConsultar")==null ? false:true)+")";
					//System.out.print(cadePermisoPrecio);
					st.execute(cadePermisoPrecio);
					
					
					st.execute("DELETE FROM permisosdash WHERE idusuario = "+idUsuario);
					
					//permisos Dash
					String permisodash= request.getParameter("permisodash")==null ? "":request.getParameter("permisodash").toString().trim();
					JSONObject pd = new JSONObject();
					String permisosDash[] = permisodash.split("&"); 
					for (int i = 0; i < permisosDash.length; i++) {
						String key = permisosDash[i].substring(0, permisosDash[i].indexOf("="));
						pd.put(key, true);
					}
					
					String GInversionG = "INSERT INTO permisosdash(idusuario,grafica,disponible) "
							+ "VALUES("+idUsuario+",'GInversionG',"+(pd.get("GInversionG")==null ? false:true)+")";
					st.execute(GInversionG);
					
					String GAvancePro = "INSERT INTO permisosdash(idusuario,grafica,disponible) "
							+ "VALUES("+idUsuario+",'GAvancePro',"+(pd.get("GAvancePro")==null ? false:true)+")";
					st.execute(GAvancePro);
					
					
					String GEstadoObra = "INSERT INTO permisosdash(idusuario,grafica,disponible) "
							+ "VALUES("+idUsuario+",'GEstadoObra',"+(pd.get("GEstadoObra")==null ? false:true)+")";
					st.execute(GEstadoObra);
					
					String GEstadoObraEtapa = "INSERT INTO permisosdash(idusuario,grafica,disponible) "
							+ "VALUES("+idUsuario+",'GEstadoObraEtapa',"+(pd.get("GEstadoObraEtapa")==null ? false:true)+")";
					st.execute(GEstadoObraEtapa);
					
					String GMaterialE = "INSERT INTO permisosdash(idusuario,grafica,disponible) "
							+ "VALUES("+idUsuario+",'GMaterialE',"+(pd.get("GMaterialE")==null ? false:true)+")";
					st.execute(GMaterialE);
					
					String GMaterialD = "INSERT INTO permisosdash(idusuario,grafica,disponible) "
							+ "VALUES("+idUsuario+",'GMaterialD',"+(pd.get("GMaterialD")==null ? false:true)+")";
					st.execute(GMaterialD);
					
					String GPagoObra = "INSERT INTO permisosdash(idusuario,grafica,disponible) "
							+ "VALUES("+idUsuario+",'GPagoObra',"+(pd.get("GPagoObra")==null ? false:true)+")";
					st.execute(GPagoObra);
					
					String GPagoCuadrilla = "INSERT INTO permisosdash(idusuario,grafica,disponible) "
							+ "VALUES("+idUsuario+",'GPagoCuadrilla',"+(pd.get("GPagoCuadrilla")==null ? false:true)+")";
					st.execute(GPagoCuadrilla);
					
					String GPrecioMaterial = "INSERT INTO permisosdash(idusuario,grafica,disponible) "
							+ "VALUES("+idUsuario+",'GPrecioMaterial',"+(pd.get("GPrecioMaterial")==null ? false:true)+")";
					st.execute(GPrecioMaterial);
					
					
					respuesta.put("valido", true);
					respuesta.put("msj", "Registro editado con exito!");
					
				}else {
					respuesta.put("valido", false);
					respuesta.put("msj", MSJ_NO_PERMISO);
				}
			}else if(operacion==OPERACION_ELIMINAR){
				if(permisos.getPermiso(session, MODULO, PERMISO_TIPO_ELIMINAR)) {
					String idusuario= request.getParameter("idusuario")==null ? "0":request.getParameter("idusuario").toString().trim();
					st.execute("UPDATE usuario SET estatus=3 WHERE idusuario = "+idusuario);
					respuesta.put("valido", true);
					respuesta.put("msj", "Registro eliminado con exito!");
				}else {
					respuesta.put("valido", false);
					respuesta.put("msj", MSJ_NO_PERMISO);
				}
			}else if(operacion==OPERACION_CONSULTAR){
				if(permisos.getPermiso(session, MODULO, PERMISO_TIPO_CONSULTAR)) {
					String idusuario= request.getParameter("idusuario")==null ? "0":request.getParameter("idusuario").toString().trim();
					rs = st.executeQuery("SELECT *, u.idpersona as idp FROM usuarios as u left join persona as p on u.idpersona=p.idpersona where idusuario = "+idusuario);
					respuesta.clear();
					if(rs.next()) {
						respuesta.put("valido", true);
						respuesta.put("idusuario", idusuario);
						respuesta.put("idpersona", rs.getInt("idp"));
						respuesta.put("txtUsuario", rs.getString("usuario").trim());
						respuesta.put("txtCedula", rs.getInt("cedula"));
						respuesta.put("txtNombre", rs.getString("apellido").trim()+" "+rs.getString("nombre").trim());
						//respuesta.put("txtApellido", rs.getString("apellido").trim());
						//respuesta.put("cmbEstatus", rs.getInt("estatus"));
						respuesta.put("app_acceso", rs.getBoolean("appacceso"));
						respuesta.put("app_fullDash", rs.getBoolean("appfulldash"));
						respuesta.put("app_Inspecciones",rs.getBoolean("appinspecciones") );

						respuesta.put("app_Materiales",rs.getBoolean("appmateriales") );
						
						Statement stPer = conexion.createStatement();
						ResultSet rsPer = stPer.executeQuery("SELECT * FROM permisos WHERE idusuario = "+idusuario);
						while (rsPer.next()) {
							String m = rsPer.getString("modulo").trim();
							if(m.equals("persona")) {
								respuesta.put("PersonaChkConsultar", rsPer.getBoolean("consultar"));
								respuesta.put("PersonaChkIncluir", rsPer.getBoolean("incluir"));
								respuesta.put("PersonaChkModificar", rsPer.getBoolean("editar"));
								respuesta.put("PersonaChkEliminar", rsPer.getBoolean("eliminar"));
							}else if(m.equals("cargo")) {
								respuesta.put("CargoChkConsultar", rsPer.getBoolean("consultar"));
								respuesta.put("CargoChkIncluir", rsPer.getBoolean("incluir"));
								respuesta.put("CargoChkModificar", rsPer.getBoolean("editar"));
								respuesta.put("CargoChkEliminar", rsPer.getBoolean("eliminar"));								
							}else if(m.equals("trabajador")) {
								respuesta.put("TrabajadorChkConsultar", rsPer.getBoolean("consultar"));
								respuesta.put("TrabajadorChkIncluir", rsPer.getBoolean("incluir"));
								respuesta.put("TrabajadorChkModificar", rsPer.getBoolean("editar"));
								respuesta.put("TrabajadorChkEliminar", rsPer.getBoolean("eliminar"));								
							}else if(m.equals("cuadrilla")) {
								respuesta.put("CuadrillaChkConsultar", rsPer.getBoolean("consultar"));
								respuesta.put("CuadrillaChkIncluir", rsPer.getBoolean("incluir"));
								respuesta.put("CuadrillaChkModificar", rsPer.getBoolean("editar"));
								respuesta.put("CuadrillaChkEliminar", rsPer.getBoolean("eliminar"));								
							}else if(m.equals("material")) {
								respuesta.put("MaterialChkConsultar", rsPer.getBoolean("consultar"));
								respuesta.put("MaterialChkIncluir", rsPer.getBoolean("incluir"));
								respuesta.put("MaterialChkModificar", rsPer.getBoolean("editar"));
								respuesta.put("MaterialChkEliminar", rsPer.getBoolean("eliminar"));								
							}else if(m.equals("proveedor")) {
								respuesta.put("ProveedorChkConsultar", rsPer.getBoolean("consultar"));
								respuesta.put("ProveedorChkIncluir", rsPer.getBoolean("incluir"));
								respuesta.put("ProveedorChkModificar", rsPer.getBoolean("editar"));
								respuesta.put("ProveedorChkEliminar", rsPer.getBoolean("eliminar"));								
							}else if(m.equals("compra")) {
								respuesta.put("CompraChkConsultar", rsPer.getBoolean("consultar"));
								respuesta.put("CompraChkIncluir", rsPer.getBoolean("incluir"));
								respuesta.put("CompraChkModificar", rsPer.getBoolean("editar"));
								respuesta.put("CompraChkEliminar", rsPer.getBoolean("eliminar"));								
							}else if(m.equals("proyecto")) {
								respuesta.put("ProyectoChkConsultar", rsPer.getBoolean("consultar"));
								respuesta.put("ProyectoChkIncluir", rsPer.getBoolean("incluir"));
								respuesta.put("ProyectoChkModificar", rsPer.getBoolean("editar"));
								respuesta.put("ProyectoChkEliminar", rsPer.getBoolean("eliminar"));								
							}else if(m.equals("etapa")) {
								respuesta.put("EtapaChkConsultar", rsPer.getBoolean("consultar"));
								respuesta.put("EtapaChkIncluir", rsPer.getBoolean("incluir"));
								respuesta.put("EtapaChkModificar", rsPer.getBoolean("editar"));
								respuesta.put("EtapaChkEliminar", rsPer.getBoolean("eliminar"));								
							}else if(m.equals("subetapa")) {
								respuesta.put("SubEtapaChkConsultar", rsPer.getBoolean("consultar"));
								respuesta.put("SubEtapaChkIncluir", rsPer.getBoolean("incluir"));
								respuesta.put("SubEtapaChkModificar", rsPer.getBoolean("editar"));
								respuesta.put("SubEtapaChkEliminar", rsPer.getBoolean("eliminar"));								
							}else if(m.equals("obras")) {
								respuesta.put("ObrasChkConsultar", rsPer.getBoolean("consultar"));
								respuesta.put("ObrasChkIncluir", rsPer.getBoolean("incluir"));
								respuesta.put("ObrasChkModificar", rsPer.getBoolean("editar"));
								respuesta.put("ObrasChkEliminar", rsPer.getBoolean("eliminar"));								
							}else if(m.equals("tipoobra")) {
								respuesta.put("TipoOChkConsultar", rsPer.getBoolean("consultar"));
								respuesta.put("TipoOChkIncluir", rsPer.getBoolean("incluir"));
								respuesta.put("TipoOChkModificar", rsPer.getBoolean("editar"));
								respuesta.put("TipoOChkEliminar", rsPer.getBoolean("eliminar"));								
							}else if(m.equals("solicitudmaterial")) {
								respuesta.put("SolicitudMChkConsultar", rsPer.getBoolean("consultar"));
								respuesta.put("SolicitudMChkIncluir", rsPer.getBoolean("incluir"));
								respuesta.put("SolicitudMChkModificar", rsPer.getBoolean("editar"));
								respuesta.put("SolicitudMChkEliminar", rsPer.getBoolean("eliminar"));								
							}else if(m.equals("despachomaterial")) {
								respuesta.put("DespachoChkConsultar", rsPer.getBoolean("consultar"));
								respuesta.put("DespachoChkIncluir", rsPer.getBoolean("incluir"));
								respuesta.put("DespachoChkModificar", rsPer.getBoolean("editar"));
								respuesta.put("DespachoChkEliminar", rsPer.getBoolean("eliminar"));								
							}else if(m.equals("inspeccion")) {
								respuesta.put("InspecciChkConsultar", rsPer.getBoolean("consultar"));
								respuesta.put("InspecciChkIncluir", rsPer.getBoolean("incluir"));
								respuesta.put("InspecciChkModificar", rsPer.getBoolean("editar"));
								respuesta.put("InspecciChkEliminar", rsPer.getBoolean("eliminar"));								
							}else if(m.equals("pago")) {
								respuesta.put("AsignaciPChkConsultar", rsPer.getBoolean("consultar"));
								respuesta.put("AsignaciPChkIncluir", rsPer.getBoolean("incluir"));
								respuesta.put("AsignaciPChkModificar", rsPer.getBoolean("editar"));
								respuesta.put("AsignaciPChkEliminar", rsPer.getBoolean("eliminar"));								
							}else if(m.equals("usuario")) {
								respuesta.put("UsuariosChkConsultar", rsPer.getBoolean("consultar"));
								respuesta.put("UsuariosChkIncluir", rsPer.getBoolean("incluir"));
								respuesta.put("UsuariosChkModificar", rsPer.getBoolean("editar"));
								respuesta.put("UsuariosChkEliminar", rsPer.getBoolean("eliminar"));								
							}else if(m.equals("precio")) {
								respuesta.put("PrecioChkConsultar", rsPer.getBoolean("consultar"));
								respuesta.put("PrecioChkIncluir", rsPer.getBoolean("incluir"));
								respuesta.put("PrecioChkModificar", rsPer.getBoolean("editar"));
								respuesta.put("PrecioChkEliminar", rsPer.getBoolean("eliminar"));
							}
							
						}
						
						
						Statement stPerDash = conexion.createStatement();
						ResultSet rsPerDash = stPerDash.executeQuery("SELECT * FROM permisosdash WHERE idusuario = "+idusuario);
						while (rsPerDash.next()) {							
								respuesta.put(rsPerDash.getString("grafica").trim(), rsPerDash.getBoolean("disponible"));
						}
						
					}else {
						respuesta.put("valido", false);
						respuesta.put("msj", "No existe un usuario con el id="+idusuario);
					}
				}else {
					respuesta.put("valido", false);
					respuesta.put("msj", MSJ_NO_PERMISO);
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

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
