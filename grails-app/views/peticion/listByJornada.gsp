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
        <g:set var="entityName" value="${message(code: 'peticion.label', default: 'Peticiones')}" />
        <title><g:message code="default.list.label" args="[entityName]" /> - ${peticionInstance}</title>
    </head>
    <body>
        <ol class="breadcrumb">
             <li><a class="home" href="${createLink(controller: 'jornada')}">Jornadas</a></li>
             <li><g:link controller="jornada" action="dashboard" id="${jornadaInstance?.id}">Detalles de ${jornadaInstance?.nombre}</g:link></li>
             <li>Peticiones de ${jornadaInstance?.nombre} </li>
        </ol> 
        <h1 class="page-header">${jornadaInstance?.nombre} - ${entityName}</h1>
    
        <p>
            <g:link class="btn btn-primary btn-lg" controller="peticion" action="crear" id="${jornadaInstance?.id}">
                <span class="glyphicon glyphicon-plus"></span>
                <g:message code="default.create.label" args="['Petición']" />
            </g:link>
        </p>
        <g:if test="${flash.message}">
             <bootstrap:alert class="alert-info">${flash.message}</bootstrap:alert>
        </g:if>
        <div class="panel panel-primary">
            <div class="panel-heading">
                <h3 class="panel-title">${entityName}</h3>
            </div>
            <table class="table table-striped">
                <thead>
                        <tr>
                            <th>
                                <!--<g:sortableColumn params="[id:jornadaInstance?.id]" property="id" title="${message(code: 'peticion.id.label', default: 'Id')}" />-->
                                Folio
                            </th>
                            <th>
                                Solicitante
                                <!--<g:sortableColumn params="[id:jornadaInstance?.id]" property="id" title="${message(code: 'peticion.solicitante.label', default: 'Solicitante')}" />-->
                            </th>
                            <th>
                                Domicilio
                            </th>
                            <th>
                                Colonia
                            </th>
                            <th>
                                Descripción
                            </th>
                            <th>
                                Acciones
                            </th>
                        </tr>
                        
                </thead>
                <tbody>
                    <g:each in="${peticionInstanceList}" status="i" var="peticionInstance">
                        <!--<tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                            <td>
                                <g:link action="editar" id="${peticionInstance.id}">${fieldValue(bean: peticionInstance, field: "id")}</g:link>
                            </td>
                            <td>
                                ${fieldValue(bean: peticionInstance, field: "nombre")} ${fieldValue(bean: peticionInstance, field: "apaterno")}  ${fieldValue(bean: peticionInstance, field: "amaterno")}
                            </td>
                            <td>
                                ${fieldValue(bean: peticionInstance, field: "domicilio")}
                            </td>
                            <td>
                                ${fieldValue(bean: peticionInstance, field: "colonia")}
                            </td>
                            <td>
                                ${fieldValue(bean: peticionInstance, field: "descripcion")}
                            </td>
                            <td>
                                
                            </td>
                        </tr>-->
                        <tr>
                            <td>
                                <g:link action="editar" id="${peticionInstance.id}">${peticionInstance.id}</g:link>
                            </td>
                            <td>
                                ${peticionInstance.nombre} ${peticionInstance.apaterno} ${peticionInstance.amaterno}
                            </td>
                            <td>
                                ${peticionInstance.domicilio}
                            </td>
                            <td>
                                ${peticionInstance.colonia}
                            </td>
                            <td>
                                ${peticionInstance.descripcion}
                            </td>
                            <td>
                                <div class="btn-group btn-group-xs">
                                    <g:link action="edit" id="${peticionInstance.id}" class="btn btn-link btn-sm" role="button">
					<span class="glyphicon glyphicon-pencil"></span>
                                        <g:message code="default.edit.label" args="['petición']" />
                                    </g:link>
                                </div>
                            </td>
                        </tr>
                    </g:each>
                </tbody>
            </table>
            <div class="paginateButtons">
                <bootstrap:paginate total="${peticionInstanceTotal}" params="${params}"/>
            </div>                
        </div>
    </body>
</html>
