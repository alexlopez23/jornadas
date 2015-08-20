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
        <g:set var="entityName" value="${message(code: 'peticion.label', default: 'Petición')}" />
        <title><g:message code="default.edit.label" args="[entityName]" /> - ${peticionInstance}</title>
    </head>
    <body>
        <ol class="breadcrumb">
             <li><a class="home" href="${createLink(controller: 'jornada')}">Jornadas</a></li>
             <li><g:link controller="jornada" action="dashboard" id="${jornadaInstance?.id}">Detalles de ${jornadaInstance?.nombre}</g:link></li>
             <li><g:link controller="peticion" action="listByJornada" id="${jornadaInstance?.id}">Peticiones de ${jornadaInstance?.nombre}</g:link></li>
             <li>Editar petición</li>
        </ol>
        <h1 class="page-header">Editar ${entityName}</h1>
         <g:if test="${flash.message}">
            <bootstrap:alert class="alert-info">${flash.message}</bootstrap:alert>
        </g:if>
        <g:hasErrors bean="${peticionInstance}">
            <bootstrap:alert class="alert-danger">
		<ul>
                    <g:eachError bean="${peticionInstance}" var="error">
                        <li> <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message error="${error}"/></li>
                    </g:eachError>
		</ul>
            </bootstrap:alert>
        </g:hasErrors>
        <div class="panel panel-primary">
            <div class="panel-heading">
                <h3 class="panel-title">${entityName}</h3>
            </div>
            <g:form action="actualizar" >                
                <g:hiddenField name="id" value="${peticionInstance?.id}" />
                <table class="table table-striped table-condensed">
                    <tr class="prop">
                        <td valign="top">
                            <label for="nombre"><g:message code="peticionInstance.nombre.label" default="*Nombre del solicitante" /></label>
                        </td>
                        <td valign="top">
                            <g:textField class="form-control" size="100" name="nombre" value="${peticionInstance.nombre}" />
                        </td>
                    </tr>
                    <tr class="prop">
                        <td valign="top">
                            <label for="apaterno"><g:message code="peticionInstance.paterno.label" default="*Apellido paterno del solicitante" /></label>
                        </td>
                        <td valign="top">
                            <g:textField class="form-control" size="100" name="apaterno" value="${peticionInstance.apaterno}" />
                        </td>
                    </tr>
                    <tr class="prop">
                        <td valign="top">
                            <label for="amaterno"><g:message code="peticionInstance.amaterno.label" default="*Apellido materno del solicitante" /></label>
                        </td>
                        <td valign="top">
                            <g:textField class="form-control" size="100" name="amaterno" value="${peticionInstance.amaterno}" />
                        </td>
                    </tr>
                    <tr class="prop">
                        <td valign="top">
                            <label for="domicilio"><g:message code="peticionInstance.domicilio.label" default="*Domicilio del solicitante" /></label>
                        </td>
                        <td valign="top">
                            <g:textField class="form-control" size="100" name="domicilio" value="${peticionInstance.domicilio}" />
                        </td>
                    </tr>
                    <tr class="prop">
                        <td valign="top">
                            <label for="colonia"><g:message code="peticionInstance.colonia.label" default="*Colonia del solicitante" /></label>
                        </td>
                        <td valign="top">
                            <g:textField class="form-control" size="100" name="colonia" value="${peticionInstance.colonia}" />
                        </td>
                    </tr>
                    <tr class="prop">
                        <td valign="top">
                            <label for="descripcion"><g:message code="peticionInstance.descripcion.label" default="*Descripción solicitud" /></label>
                        </td>
                        <td valign="top">
                            <g:textField class="form-control" size="100" name="descripcion" value="${peticionInstance.descripcion}" />
                        </td>
                    </tr>
                </table>                
        </div>
        <div class="form-actions ui-corner-bottom">
            <g:submitButton name="submit" value="Actualizar" class="btn btn-success" role="button"/>
        </div>
        </g:form>
    </body>
</html>
