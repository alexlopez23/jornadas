<!--
  To change this license header, choose License Headers in Project Properties.
  To change this template file, choose Tools | Templates
  and open the template in the editor.
-->

<%@ page contentType="text/html;charset=UTF-8" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="masterBootstrap" />
	<g:set var="entityName" value="Crear jornada" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
    </head>
    <body>
        <ol class="breadcrumb">
             <li><a class="home" href="${createLink(controller: 'jornada')}">Jornadas</a></li>
             <li>${entityName}</li>
        </ol>
        <h1 class="page-header">${entityName}</h1>
        <g:if test="${flash.message}">
            <bootstrap:alert class="alert-info">${flash.message}</bootstrap:alert>
        </g:if>
        <g:hasErrors bean="${jornadaInstance}">
            <bootstrap:alert class="alert-danger">
		<ul>
                    <g:eachError bean="${jornadaInstance}" var="error">
                    <li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message error="${error}"/></li>
                    </g:eachError>
		</ul>
            </bootstrap:alert>
        </g:hasErrors>
        <div class="panel panel-primary">
        <div class="panel-heading">
            <h3 class="panel-title">${entityName}</h3>
        </div>    
        <g:form name="form_jornada" action="guardar" >
                <div class="dialog">
                    <table class="table table-hover">
                        <tbody>
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="nombre"><g:message code="jornada.nombre.label" default="Nombre" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: jornadaInstance, field: 'nombre', 'errors')}">
                                    <g:textField class="form-control" size="100" name="nombre" />
                                </td>
                            </tr>
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="sede"><g:message code="sede.nombre.label" default="Sede" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: jornadaInstance, field: 'sede', 'errors')}">
                                    <g:textField class="form-control" size="100" name="sede" />
                                </td>
                            </tr>                            
                        </tbody>
                    </table>
                </div>                
        </div>
        <div class="form-actions ui-corner-bottom">
            <g:submitButton name="submit" value="Guardar" class="btn btn-success" role="button"/>
        </div>
        </g:form>        
            
            <!--<div class="form-actions ui-corner-bottom">
                <g:link action="guardar" class="btn btn-success" role="button">
                    <span class="glyphicon glyphicon-floppy-disk"></span>
                    <g:message code="default.button.create.label" default="Create" />
                </g:link>
            </div>-->
            <!--<g:javascript>
		$().ready(function(){
			$(".btn-success").click(function(){
				$("formulario_jornada").submit();
				return false;
			});
		});
            </g:javascript>-->
    </body>
</html>
