<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="t" %> 
  <!--         
        PROYECTO REALIZADO POR CORPORACION EUREKA, BAJO LOS ESTANDARES DE CALIDAD
        
                        
                   ##############    #######        
                  ##############    #######         
                 #######           #######    
                #############     #######          
               #############     #######          
              #######           #######    
             #######                            
            ##############    #######        
           ##############    #######          
   
                                                                                                                                                                                             
        
        -->
<!DOCTYPE html>
<html>
<head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="Plataforma web Proherco">
        <meta name="author" content="Corporación Eureka CA">
        
        <script src="Archivos/js/jquery.js"></script>
       
        <script src="Archivos/js/jsmetro/metro.js"></script>
        <link href="Archivos/css/cssmetro/metro-icons.css" rel="stylesheet">
        
        
        <link rel="stylesheet" href="Archivos/css/jquery.mCustomScrollbar.css">
        
        <style type="text/css">
        	@import "Archivos/css/cssmetro/metro.css";
        	@import "Archivos/css/bootstrap.min.css";
        	
        	@import "Archivos/css/variables.less";
			@import "Archivos/css/bootswatch.less";
			
        </style>
        <link href="Archivos/css/dataTables.bootstrap.css" rel="stylesheet">
        <link href="Archivos/css/jquery.dataTables.css" rel="stylesheet">
        <link href="Archivos/css/jquery-ui.css" rel="stylesheet">
        <link rel="shortcut icon" href="Archivos/images/favicon.ico">
		<link href="Archivos/css/fontello/css/fontello.css" rel="stylesheet">
		
		<!-- DATATABLES RESPONSIVE -->
		<link href="Archivos/css/fixedHeader.bootstrap.min.css" rel="stylesheet">
  		<link href="Archivos/css/responsive.bootstrap.min.css" rel="stylesheet">
  		<!-- DATATABLES RESPONSIVE -->	
		
		<script src="Archivos/js/jquery.mCustomScrollbar.concat.min.js"></script>
		
		<script src="Archivos/js/charts/highcharts.js"></script>
		<script src="Archivos/js/charts/highcharts-more.js"></script>
		<script src="Archivos/js/charts/modules/solid-gauge.js"></script>
	
        <script src="Archivos/js/bootstrap.min.js"></script>
        <script src="Archivos/js/jquery-ui.js"></script>
        <script src="Archivos/js/jquery.blockUI.js"></script>
        <script src="Archivos/js/jquery.numeric.js"></script>
        <script src="Archivos/js/jquery.dataTables.min.js"></script>
        <script src="Archivos/js/dataTables.bootstrap.js"></script>
        <script src="Archivos/js/variables.js"></script>
        <script src="Archivos/js/comun.js"></script>
        <script src="Archivos/js/md5.js"></script>
        
        <!-- DATATABLES RESPONSIVE -->
        <script src="Archivos/js/dataTables.fixedHeader.min.js"></script>
  		<script src="Archivos/js/dataTables.responsive.min.js"></script>
  		<script src="Archivos/js/responsive.bootstrap.min.js"></script>
  		<!-- DATATABLES RESPONSIVE -->
        
        <!-- <link href="Archivos/css/cssmyetro/metro.css" rel="stylesheet">-->
        
        
        
        
        <script src="Archivos/js/SweetAlert/dist/sweetalert.min.js"></script>
        <link rel="stylesheet" type="text/css" href="Archivos/js/SweetAlert/dist/sweetalert.css">
        <link rel="stylesheet" type="text/css" href="Archivos/js/SweetAlert/themes/google/google.css">
        <!-- <link rel="stylesheet" type="text/css" href="Archivos/js/SweetAlert/themes/facebook/facebook.css"> -->
        <!-- <link rel="stylesheet" type="text/css" href="Archivos/js/SweetAlert/themes/twitter/twitter.css"> -->
        
        
        <link rel="stylesheet" type="text/css" href="Archivos/css/estilos.css">
        <script>
		      $(document).ready(function() {
		    	  	inputNumerico();
		    	  	soloNumero();
		    	  	
		    	  	
		    	      			
		    	  		
		    			
		    			
		    		
		      });
		      
		      $.datepicker.regional['es'] = {
		    		  closeText: 'Cerrar',
		    		  prevText: '< Ant',
		    		  nextText: 'Sig >',
		    		  currentText: 'Hoy',
		    		  monthNames: ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'],
		    		  monthNamesShort: ['Ene','Feb','Mar','Abr', 'May','Jun','Jul','Ago','Sep', 'Oct','Nov','Dic'],
		    		  dayNames: ['Domingo', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado'],
		    		  dayNamesShort: ['Dom','Lun','Mar','Mié','Juv','Vie','Sáb'],
		    		  dayNamesMin: ['Do','Lu','Ma','Mi','Ju','Vi','Sá'],
		    		  weekHeader: 'Sm',
		    		  dateFormat: 'dd/mm/yy',
		    		  firstDay: 1,
		    		  isRTL: false,
		    		  showMonthAfterYear: false,
		    		  yearSuffix: ''
		    		  };
		    		  $.datepicker.setDefaults($.datepicker.regional['es']);
		    		  
		    		 
		    		  
		</script>
        <style type="text/css">
        	
        	.ajuste {
	        	min-height: 700px;
	        	max-height: auto;
	        	width: 80%;
        	
        	
        	}
     
			.footer {
				  
				  position: fixed;
				  bottom: 0px;
				  width: 100%;
				  height:40px;
				  color: white;
				}
	
        
        </style>
        <title>PROHERCO</title>
       
        
</head>
<body id="base">

<tiles:insertAttribute name="cabecera" ignore="false" />


  
<section class="container ajuste" id="dfsgdfsg" >

  <tiles:insertAttribute name="container" ignore="false" />
  
</section>

 <!-- <footer>
	<span class="footer" style="text-align:center"> <img  src="Archivos/images/iconmenu/logoeurekaG.png" style="width:120px; float:right;"></span>
	</footer> -->

<!--  <div class="" style="background: #222; color: #ccc">
	<div class="" >
		<div class="">
			<div class="">
				<div class="copyright" style="text-align: center">
					© 2017 PROHERCO All right reserved
				</div>
			</div>
		</div>
	</div>
</div>-->


</body>
</html>