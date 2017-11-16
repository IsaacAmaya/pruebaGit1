function login(){
	if(!$("#btnLogin").is(':disabled')){
		
		if($("#txtUsuario").val()==""){
			swal("Error!", "El usuario no debe estar en blanco.", "error");
		}else if($("#txtClave").val()==""){
			swal("Error!", "La clave no debe estar en blanco.", "error");
		}else {
			$("#progressBar").css( "visibility", "visible" );
			$("#btnLogin").attr('disabled', 'disabled');
			$("#btnLogin").html("Validando...");
			
			$.post("./Login",
					{
						txtUsuario	:$("#txtUsuario").val(),
						txtClave 	: hex_md5($("#txtClave").val())
					},
			        function FuncionRecepcion(respuesta) {
						if(respuesta.valido){
							window.location.href = './menu';							
						}else {
							swal("Error!", respuesta.msj, "error");	
							$("#progressBar").css( "visibility", "hidden" );
							$("#btnLogin").removeAttr('disabled');
							$("#btnLogin").html("Entrar");
						}
			        }
			).fail(function(response) {
				swal("Error!", "Error en el servidor, no hay respuesta valida.", "error");
				$("#progressBar").css( "visibility", "hidden" );
				$("#btnLogin").removeAttr('disabled');
				$("#btnLogin").html("Entrar");
			});			
		}
	}
		
	//$("#progressBar").css( "visibility", "hidden" );
}