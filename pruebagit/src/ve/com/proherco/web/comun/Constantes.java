package ve.com.proherco.web.comun;

public interface Constantes {
	int OPERACION_LISTADO = 0;
	int OPERACION_INCLUIR = 1;
	int OPERACION_EDITAR = 2;
	int OPERACION_ELIMINAR = 3;
	int OPERACION_CONSULTAR = 4;
	int OPERACION_CONSULTAR_CEDULA = 5;
	int OPERACION_LISTADO_SOLO_PERSONAS = 6;
	int OPERACION_LISTADO_MATERIALPOROBRA = 7;
	
	String PERMISO_TIPO_CONSULTAR = "consultar";
	String PERMISO_TIPO_EDITAR = "editar";
	String PERMISO_TIPO_INCLUIR = "incluir";
	String PERMISO_TIPO_ELIMINAR = "eliminar";
	
	String MSJ_NO_PERMISO = "No tiene permiso para ejecutar esta operación";
	
	
	
}
