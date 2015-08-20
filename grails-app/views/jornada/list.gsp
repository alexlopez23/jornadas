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
	<g:set var="entityName" value="Listado de jornadas" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
    </head>
    <ol class="breadcrumb">
            <li><a class="home" href="${createLink(controller: 'jornada')}">Jornadas</a></li>
        </ol>
        <h1 class="page-header">${entityName}</h1>
            <p>
                <g:link class="btn btn-primary btn-lg" controller="jornada" action="crear" role="button">
                    <span class="glyphicon glyphicon-plus"></span>
                    <g:message code="default.create.label" args="['Jornada']" />
                </g:link>
            </p>
        <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
        </g:if>
        <div class="panel panel-primary">
            <div class="panel-heading">
                <h3 class="panel-title">${entityName}</h3>
            </div>
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <g:sortableColumn params="[id:jornadaInstance?.id]" property="nombre" title="${message(code: 'jornada.nombre.label', default: 'Nombre')}" />
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${jornadaInstanceList}" status="i" var="jornadaInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                            <td><g:link action="dashboard" id="${jornadaInstance.id}">${fieldValue(bean: jornadaInstance, field: "nombre")}</g:link></td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
                <div class="paginateButtons">
                    <bootstrap:paginate total="${jornadaInstanceTotal}" params="${params}"/>
		</div>                
        </div>                
    </body>
</html>
