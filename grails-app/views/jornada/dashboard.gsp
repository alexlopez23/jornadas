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
        <title><g:message code="default.show.label" args="[entityName]" /> - ${jornadaInstance}</title>
    </head>
    <body>
        <ol class="breadcrumb">
           <li><a class="home" href="${createLink(controller: 'jornada')}">Jornadas</a></li>            
            <li>Detalles de ${jornadaInstance}</li>
        </ol>
        <h1 class="page-header"><g:message code="default.show.label" args="[entityName]" /></h1>
        <p>
            <g:link class="btn btn-primary btn-lg" controller="jornada" action="editar" id="${jornadaInstance?.id}">
                <span class="glyphicon glyphicon-pencil"></span>
                <g:message code="default.edit.label" args="['Jornada']" />
           </g:link>
           <g:link class="btn btn-primary btn-lg" controller="peticion" action="listByJornada" id="${jornadaInstance?.id}">
                <span class="glyphicon glyphicon-th-list"></span>
                <g:message code="default.list.label" args="['Peticiones']" />
           </g:link>           
        </p>
        
        <g:if test="${flash.message}">
            <bootstrap:alert class="alert-info">${flash.message}</bootstrap:alert>
        </g:if>
        
        <div class="panel panel-primary">
            <div class="panel-heading">${entityName}</div>
            <table class="table table-striped">
                    <tbody>
					
                    	<tr class="prop">
                            <td valign="top" class="name"><g:message code="jornada.id.label" default="Id" /></td>
                            <td valign="top" class="value">${fieldValue(bean: jornadaInstance, field: "id")}</td>
                        </tr>

                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="jornadaInstance.nombre.label" default="Nombre" /></td>
                            <td valign="top" class="value"><g:link controller="jornada" action="editar" id="${jornadaInstance?.id}">${jornadaInstance?.nombre?.encodeAsHTML()}</g:link></td>
                        </tr>

			<tr class="prop">
                            <td valign="top" class="name"><g:message code="jornadaInstance.sede.label" default="Sede" /></td>
                            <td valign="top" class="value">${fieldValue(bean: jornadaInstance, field: "sede")}</td>
                        </tr>
                    </tbody>
                </table>
        </div>                
    </body>   
</html>
