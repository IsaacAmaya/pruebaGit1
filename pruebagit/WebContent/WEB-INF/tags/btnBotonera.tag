<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ attribute name="accionguardar" required="true"%>
<%@ attribute name="accionlimpiar" required="true"%>
<%@ attribute name="accioncancelar" required="true"%>

<button onclick="${accionguardar}" class="btn btn-success"><span class="glyphicon glyphicon-ok" aria-hidden="true"></span> Guardar</button>

<button onclick="${accionlimpiar}" class="btn btn-default"><span class="glyphicon glyphicon-repeat" aria-hidden="true"></span> Limpiar</button>

<button onclick="${accioncancelar}" class="btn btn-danger"><span class="glyphicon glyphicon-remove" aria-hidden="true"></span> Cancelar</button>