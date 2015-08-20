<% import grails.persistence.Event %>
<%=packageName%>
<!doctype html>
<html>
	<head>
		<meta name="layout" content="bootstrap">
		<g:set var="entityName" value="\${message(code: '${domainClass.propertyName}.label', default: '${className}')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
	</head>
	<body>
		<ol class="breadcrumb">
			<li><a href="\${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
			<li><g:link action="index">\${entityName}</g:link></li>
			<li class="active"><g:message code="default.list.label" args="[entityName]" /></li>
		</ol>
		<section id="list-${domainClass.propertyName}" class="content scaffold-list" role="main">
			<h1 class="page-header">\${meta(name: 'app.name')} <small><g:message code="default.list.label" args="[entityName]" /></small></h1>
			<p>
                            <g:link action="create" class="btn btn-primary btn-lg " role="button">
                                    <span class="glyphicon glyphicon-plus"></span>
                                    <g:message code="default.create.label" args="[entityName]" />
                            </g:link>
			</p>
                        <g:if test="\${flash.message}">
			<bootstrap:alert class="alert-info">\${flash.message}</bootstrap:alert>
			</g:if>
			<div class="panel panel-primary">
				<div class="panel-heading">
					<h3 class="panel-title"><g:message code="default.list.label" args="[entityName]" /></h3>
				</div>
				<div class="panel-body">
					<g:form action="\${actionName?:'index'}" method="GET" params="\${formParams?:[]}" >
						<div class="form-group">
							<label for="search"><g:message code="default.search.label" default="Buscar" /></label>
							<g:textField class="form-control" size="100" id="search" name="q" value="\${params?.q}" placeholder="\${message(code:'default.search.placeHolder.label', default:'Introduzca búsqueda')}…" />
						</div>
					</g:form>
					<table class="table table-striped">
						<thead>
							<tr>
							<%  excludedProps = Event.allEvents.toList() << 'id' << 'version'
								allowedNames = domainClass.persistentProperties*.name << 'dateCreated' << 'lastUpdated'
								props = domainClass.properties.findAll { allowedNames.contains(it.name) && !excludedProps.contains(it.name) && it.type != null && !Collection.isAssignableFrom(it.type) }
								Collections.sort(props, comparator.constructors[0].newInstance([domainClass] as Object[]))
								props.eachWithIndex { p, i ->
									if (i < 6) {
										if (p.isAssociation()) { %>
								<th class="header"><g:message code="${domainClass.propertyName}.${p.name}.label" default="${p.naturalName}" /></th>
							<%      } else { %>
								<g:sortableColumn property="${p.name}" params="\${params}" title="\${message(code: '${domainClass.propertyName}.${p.name}.label', default: '${p.naturalName}')}" />
							<%  }   }   } %>
								<th></th>
							</tr>
						</thead>
						<tbody>
						<g:each in="\${${propertyName}List}" var="${propertyName}">
							<tr>
							<%  props.eachWithIndex { p, i ->
							        if (i < 6) {
										if (p.type == Boolean || p.type == boolean) { %>
								<td><g:formatBoolean boolean="\${${propertyName}.${p.name}}" /></td>
							<%          } else if (p.type == Date || p.type == java.sql.Date || p.type == java.sql.Time || p.type == Calendar) { %>
								<td><g:formatDate date="\${${propertyName}.${p.name}}" /></td>
							<%          } else { %>
								<td>\${fieldValue(bean: ${propertyName}, field: "${p.name}")}</td>
							<%  }   }   } %>
								<td class="link">
									<div class="btn-group btn-group-xs">
										<g:link action="show" id="\${${propertyName}.id}" class="btn btn-primary btn-sm" role="button">
										  	<span class="glyphicon glyphicon-eye-open"></span>
											<g:message code="default.button.show.label" default="Show" />
										  </g:link>
										  <g:link action="edit" id="\${${propertyName}.id}" class="btn btn-primary btn-sm" role="button">
										  	<span class="glyphicon glyphicon-pencil"></span>
											<g:message code="default.button.edit.label" default="Edit" />
										  </g:link>
									</div>
								</td>
							</tr>
						</g:each>
						</tbody>
					</table>
					<div class="pagination">
						<bootstrap:paginate total="\${${propertyName}Count}" params="\${params}"/>
					</div>
				</div>
			</div>
		</section>
	</body>
</html>
