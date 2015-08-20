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
        <g:set var="entityName" value="${message(code: 'jornada.label', default: 'Jornada')}" />
        <title><g:message code="default.edit.label" args="[entityName]" /> - ${jornadaInstance}</title>
    </head>
    <body>
        <ol class="breadcrumb">
             <li><a class="home" href="${createLink(controller: 'jornada')}">Jornadas</a></li>
             <li><g:link class="" controller="jornada" action="dashboard" id="${jornadaInstance?.id}">Detalles de ${jornadaInstance?.nombre}</g:link></li>
             <li>Editar ${jornadaInstance.nombre}</li>
        </ol>
        <h1 class="page-header">Editar ${jornadaInstance?.nombre}</h1>
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
            <h3 class="panel-title"><g:message code="default.edit.label" args="[entityName]" /></h3>
        </div>    
        <g:form action="actualizar" >
            <g:hiddenField name="id" value="${jornadaInstance?.id}" />
                <div class="dialog">
                    <table class="table table-hover">
                        <tbody>
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="nombre"><g:message code="jornada.nombre.label" default="Nombre" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: jornadaInstance, field: 'nombre', 'errors')}">
                                    <g:textField class="form-control" size="100" name="nombre" value="${jornadaInstance?.nombre}" />
                                </td>
                            </tr>
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="sede"><g:message code="sede.nombre.label" default="Sede" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: jornadaInstance, field: 'sede', 'errors')}">
                                    <g:textField class="form-control" size="100" name="sede" value="${jornadaInstance?.sede}" />
                                </td>
                            </tr>                            
                        </tbody>
                    </table>
                </div>
                <div class="form-actions ui-corner-bottom">
                   <g:submitButton name="submit" value="Actualizar" class="btn btn-success" role="button"/>
                </div>
            </g:form>
            </div>           
    </body>
</html>
