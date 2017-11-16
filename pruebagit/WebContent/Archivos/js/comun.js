function isValidEmailAddress(emailAddress) {
	   var pattern = new RegExp(/^(("[\w-\s]+")|([\w-]+(?:\.[\w-]+)*)|("[\w-\s]+")([\w-]+(?:\.[\w-]+)*))(@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$)|(@\[?((25[0-5]\.|2[0-4][0-9]\.|1[0-9]{2}\.|[0-9]{1,2}\.))((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\.){2}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\]?$)/i);
	   return pattern.test(emailAddress);
}

function isDate(txtDate)
{
    var currVal = txtDate;
    if(currVal == '')
        return false;
    
    var rxDatePattern = /^(\d{1,2})(\/|-)(\d{1,2})(\/|-)(\d{4})$/; //Declare Regex
    var dtArray = currVal.match(rxDatePattern); // is format OK?
    
    if (dtArray == null) 
        return false;
    
    //Checks for mm/dd/yyyy format.
    dtDay= dtArray[1];
    dtMonth = dtArray[3];
    dtYear = dtArray[5];        
    
    if (dtMonth < 1 || dtMonth > 12) 
        return false;
    else if (dtDay < 1 || dtDay> 31) 
        return false;
    else if ((dtMonth==4 || dtMonth==6 || dtMonth==9 || dtMonth==11) && dtDay ==31) 
        return false;
    else if (dtMonth == 2) 
    {
        var isleap = (dtYear % 4 == 0 && (dtYear % 100 != 0 || dtYear % 400 == 0));
        if (dtDay> 29 || (dtDay ==29 && !isleap)) 
                return false;
    }
    return true;
}

function formatMoneda(num, decSep, thousandSep, decLength)
{
    if(num == '') return '';
    var arg, entero, decLengthpow, sign = true;cents = '';
    if(typeof(num) == 'undefined') return;
    if(typeof(decLength) == 'undefined') decLength = 2;
    if(typeof(decSep) == 'undefined') decSep = ',';
    if(typeof(thousandSep) == 'undefined') thousandSep = '.';
    if(thousandSep == '.') arg=/\./g;
    else if(thousandSep == ',') arg=/\,/g;
    if(typeof(arg) != 'undefined') num = num.toString().replace(arg, '');
    num = num.toString().replace(/,/g,'.');
    if(num.indexOf('.') != -1)
        entero = num.substring(0, num.indexOf('.'));
    else
        entero = num;
    if(isNaN(num))
        return "0";
    if(decLength > 0)
    {
        decLengthpow = Math.pow(10, decLength);
        sign = (num == (num = Math.abs(num)));
        num = Math.round(num * decLengthpow);
        cents = num % decLengthpow;
        num = Math.floor(num / decLengthpow).toString();
        if(cents < 10)
            cents = "0" + cents;
    }
    if(thousandSep != '')
        for(var i = 0; i < Math.floor((num.length - (1 + i)) / 3); i++)
            num = num.substring(0, num.length - (4 * i + 3)) + thousandSep + num.substring(num.length - (4 * i + 3));
    else
        for(var i = 0; i < Math.floor((num.length - (1 + i)) / 3); i++)
            num = num.substring(0, num.length - (4 * i + 3)) + num.substring(num.length - (4 * i + 3));
    if(decLength > 0)
        return (((sign) ? '' : '-') + num + decSep + cents);
    else
        return (((sign) ? '' : '-') + num);
}

function inputNumerico(){
	$('.inputNumerico').keypress(function(e){
		if(e.which == 13){
			$(this).val(formatMoneda($(this).val(),',','.',2));
	      return false; 
	    }else if(e.which == 46){
			return false;
	    }else if(e.which>=48 && e.which<=57){
	        return true;
	    }else if(e.which==8 || e.which==0 || e.which==44){
	    	 return true;
	    } else return false;//alert(e.which); 
		
	 });
	$('.inputNumerico').focusout(function(e){
			if($(this).val()==''){
				$(this).val("0,00");  
			}else $(this).val(formatMoneda($(this).val(),',','.',2));  
	 });
	
}

jQuery.fn.validarCampos = function (){
	var validoC = true;
	jQuery(this).each( function (){
			if($(this).is( "select" )){
				if($(this).val()=='.'){	
					if($(this).data("placeholder")!="null"){
						swal("Error!", $(this).data( "placeholder" ), "error");
				       	return validoC = false;
					}       	
			    }
			}else if($(this).is( "input" )){
				if($(this).attr('required') && $(this).val()==''){		       	
			       	swal("Error!", $(this).attr('placeholder'), "error");
			       	return validoC = false;
			    }
			}
			        
    });
	
	return validoC;
};

function soloNumero(){
	$('.soloNumero').numeric({decimal:true,negative:false});
}

function bloquearContainer(){
	$( "#formulario" ).block({ 
        message: '<img src="Archivos/images/loading-image.gif" />', 
        css: { border: '0px', backgroundColor: 'transparent'},
        overlayCSS:  { 
            backgroundColor: '#fff', 
            opacity:         0.4, 
            cursor:          'wait' 
        }
    });
}

function desbloquearContainer(){
	$( "#formulario" ).unblock();
}

function validarBotones(modulo,usuario,vista){
	$.post("./Cargo",{
		operacion : OPERACION_LISTADO,
		menuInicio : 2,
		idusuario : usuario,
		modulo : modulo
	},
	function (json){
		if(json.valido){
			var valor = json.data;
			
			for(var i=0 ; i < valor.length ; i++){
				var separado = valor[i].toString().split(",");
				if(vista == "1"){
					if(separado[0]=='true'){//INCLUIR
						$(".btn-success").css("display", "inline-block");
					}else{
						$(".incluir").attr("disabled", true);
					}
					
					if(separado[2]=='true'){//ELIMINAR
						$(".btn-danger").css("display", "inline-block");
					}else{
						$(".eliminar").css("display", "none");
					}
					
					if(separado[3]=='true'){//CONSULTAR
						$(".btn-primary").css("display", "inline-block");
					}else{
						$(".consultar").css("display", "none");
					}
				}else{
					if(separado[0]=='false'){//INCLUIR						
						$(".incluir").attr("disabled", true);
					}
					
					if(separado[1]=='false'){//MODIFICAR
						//alert("no modificar");
						$(".modificar").attr("disabled", true);
					}
					
					if(separado[2]=='false'){//ELIMINAR						
						$(".eliminar").css("display", "none");
					}
				}
				
				
			}
        }
	});
}
