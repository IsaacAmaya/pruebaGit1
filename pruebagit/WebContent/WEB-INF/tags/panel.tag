<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ attribute name="titulo" required="true"%>



<div class="panel panel-primary" style="width: 100%">
    <div class="panel-heading">
         <h3 class="panel-title">${titulo}</h3>
    </div>
    
    
    <div class="panel panel-body">
       <jsp:doBody></jsp:doBody>
    </div>
</div>