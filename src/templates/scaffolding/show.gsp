<% import grails.persistence.Event %>
<%=packageName%>
<!doctype html>
<html>
	<head>
		<meta name="layout" content="bootstrap">
		<g:set var="entityName" value="\${message(code: '${domainClass.propertyName}.label', default: '${className}')}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
	</head>
	<body>
		<ol class="breadcrumb">
			<li><a href="\${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
			<li><g:link controller="pagina">Menú Catálogos</g:link></li>
			<li><g:link action="index"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
			<li class="active"><g:message code="default.show.label" args="[entityName]" /></li>
		</ol>
		<section id="show-${domainClass.propertyName}" class="content content scaffold-show" role="main">
			<h1 class="page-header">\${meta(name: 'app.name')} <small><g:message code="default.show.label" args="[entityName]" /></small></h1>
			<g:link action="create" class="btn btn-primary btn-lg " role="button">
			  	<span class="glyphicon glyphicon-plus"></span>
				<g:message code="default.create.label" args="[entityName]" />
			</g:link>
			<div class="panel panel-primary">
				<div class="panel-heading">
			    	<h3 class="panel-title"><g:message code="default.show.label" args="[entityName]" /></h3>
			  	</div>
				<div class="panel-body">
					<g:if test="\${flash.message}">
					<bootstrap:alert class="alert-info">\${flash.message}</bootstrap:alert>
					</g:if>
					<dl class="dl-horizontal">
					<%  excludedProps = Event.allEvents.toList() << 'id' << 'version'
						allowedNames = domainClass.persistentProperties*.name << 'dateCreated' << 'lastUpdated'
						props = domainClass.properties.findAll { allowedNames.contains(it.name) && !excludedProps.contains(it.name) }
						Collections.sort(props, comparator.constructors[0].newInstance([domainClass] as Object[]))
						props.each { p -> %>
						<g:if test="\${${propertyName}?.${p.name}}">
							<dt><g:message code="${domainClass.propertyName}.${p.name}.label" default="${p.naturalName}" /></dt>
							<%  if (p.isEnum()) { %>
								<dd><g:fieldValue bean="\${${propertyName}}" field="${p.name}"/></dd>
							<%  } else if (p.oneToMany || p.manyToMany) { %>
								<g:each in="\${${propertyName}.${p.name}}" var="${p.name[0]}">
								<dd><g:link controller="${p.referencedDomainClass?.propertyName}" action="show" id="\${${p.name[0]}.id}">\${${p.name[0]}?.encodeAsHTML()}</g:link></dd>
								</g:each>
							<%  } else if (p.manyToOne || p.oneToOne) { %>
								<dd><g:link controller="${p.referencedDomainClass?.propertyName}" action="show" id="\${${propertyName}?.${p.name}?.id}">\${${propertyName}?.${p.name}?.encodeAsHTML()}</g:link></dd>
							<%  } else if (p.type == Boolean || p.type == boolean) { %>
								<dd><g:formatBoolean boolean="\${${propertyName}?.${p.name}}" /></dd>
							<%  } else if (p.type == Date || p.type == java.sql.Date || p.type == java.sql.Time || p.type == Calendar) { %>
								<dd><g:formatDate date="\${${propertyName}?.${p.name}}" /></dd>
							<%  } else if(!p.type.isArray()) { %>
								<dd><g:fieldValue bean="\${${propertyName}}" field="${p.name}"/></dd>
							<%  } %>
						</g:if>
					<%  } %>
					</dl>
					<g:form url="[resource:${propertyName}, action:'delete']" method="DELETE">
						<div class="form-actions">
							<g:link action="index" class="btn btn-default" role="button">
								<span class="glyphicon glyphicon-list"></span>
								<g:message code="default.list.label" args="[entityName]" />
							</g:link>
							<g:link class="btn btn-primary" action="edit" id="\${${propertyName}?.id}" role="button">
								<span class="glyphicon glyphicon-edit"></span>
								<g:message code="default.button.edit.label" default="Edit" />
							</g:link>
							<button class="btn btn-danger" type="submit" name="_action_delete" onclick="return confirm('\${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');">
								<span class="glyphicon glyphicon-trash"></span>
								<g:message code="default.button.delete.label" default="Delete" />
							</button>
						</div>
					</g:form>
					
				</div>	
			</div>
		</section>
	</body>
</html>
