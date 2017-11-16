package ve.com.proherco.web.comun;


import java.lang.annotation.Documented;
import java.sql.Date;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.text.NumberFormat;
import java.util.Locale;

public class ValidaFormato {
	static Locale loc = new Locale("es","VE");	
	public static String[] MESES= {"enero","febrero","marzo","abril","mayo","junio","julio","agosto","septiembre","octubre","noviembre","diciembre"};
	
	public String formato (String n, String f){
		Locale.setDefault(loc);
		NumberFormat nf = NumberFormat.getNumberInstance(loc);
		DecimalFormat df = (DecimalFormat)nf;
		df.applyPattern(f);
		String val = "";
		try {
			val = df.format(Double.parseDouble(n));

		}catch (NumberFormatException e){
			val = "";
		}
		return val;
	}
	
	public static String formato (String n){		
		Locale.setDefault(loc);
		NumberFormat nf = NumberFormat.getNumberInstance(loc);
		DecimalFormat df = (DecimalFormat)nf;
		df.applyPattern("##,###,###,##0.00");
		String val = "";
		try {
			val = df.format(Double.parseDouble(n));
		}catch (NumberFormatException e){
			val = "";
		}
		return val;
	}
	
	public static double round(double val, int places) {
		 long factor = (long)Math.pow(10,places);
		 val = val * factor;
		 long tmp = Math.round(val);
		 return (double)tmp / factor;
	} 
	
	public String mes(int m){
		 String mes = "";
    	 switch(m){
    	 	case 1: mes = "ENERO";
    	 	break;
    	 	case 2: mes = "FEBRERO";
    	 	break;
    	 	case 3: mes = "MARZO";
    	 	break;
    	 	case 4: mes = "ABRIL";
    	 	break;
    	 	case 5: mes = "MAYO";
    	 	break;
    	 	case 6: mes = "JUNIO";
    	 	break;
    	 	case 7: mes = "JULIO";
    	 	break;
    	 	case 8: mes = "AGOSTO";
    	 	break;
    	 	case 9: mes = "SEPTIEMBRE";
    	 	break;
    	 	case 10: mes = "OCTUBRE";
    	 	break;
    	 	case 11: mes = "NOVIEMBRE";
    	 	break;
    	 	case 12: mes = "DICIEMBRE";	 
    	 	break;
    	 }
    	 return mes;
	}
	
	public static String estatus(int m){
		 String estatus = "";
   	 switch(m){
   	 	case 1: estatus = "Activo";
   	 	break;
   	 	case 0: estatus = "Inactivo";
   	 	break;
   	 }
   	 return estatus;
	}
	
	public static String cambiarFecha(String txtFecha, int op){
		String fe = "";
		if(op==1){
			//hacia sql
			fe = txtFecha.substring(6, 10)+"-"+
				 txtFecha.substring(3, 5)+"-"+
				 txtFecha.substring(0, 2);
		}else if(op==2){
			//desde sql
			fe = txtFecha.substring(8, 10)+"/"+
					 txtFecha.substring(5, 7)+"/"+
					 txtFecha.substring(0, 4);
		}
		return fe;
	}
	
	public static String ucFirst(String str) { //TRANSFORMA LA PRIMERA LETRA DEL TEXTO EN MAYUSCULA
	  	  if(str == null || str.isEmpty()) {
	  	    return "";
	  	  }else{
	  	    return  Character.toUpperCase(str.charAt(0)) + str.substring(1, str.length()).toLowerCase();
	  	  }
	}
	
}