<%=packageName%>
<!doctype html>
<html>
	<head>
		<meta name="layout" content="bootstrap">
		<g:set var="entityName" value="\${message(code: '${domainClass.propertyName}.label', default: '${className}')}" />
		<title><g:message code="default.edit.label" args="[entityName]" /></title>
	</head>
	<body>
		<ol class="breadcrumb">
			<li><a href="\${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
			<li><g:link action="index"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
			<li class="active"><g:message code="default.edit.label" args="[entityName]" /></li>
		</ol>
		<section id="edit-${domainClass.propertyName}" class="content scaffold-create" role="main">
			<h1 class="page-header">\${meta(name: 'app.name')} <small><g:message code="default.edit.label" args="[entityName]" /></small></h1>
			<div class="panel panel-primary">
				<div class="panel-heading">
			    	<h3 class="panel-title"><g:message code="default.edit.label" args="[entityName]" /></h3>
			  	</div>
				<div class="panel-body">
					<g:hasErrors bean="\${${propertyName}}">
					<bootstrap:alert class="alert-danger">
					<ul>
						<g:eachError bean="\${${propertyName}}" var="error">
						<li <g:if test="\${error in org.springframework.validation.FieldError}">data-field-id="\${error.field}"</g:if>><g:message error="\${error}"/></li>
						</g:eachError>
					</ul>
					</bootstrap:alert>
					</g:hasErrors>
					<g:form class="form-horizontal" action="edit" id="\${${propertyName}?.id}" method="POST"  <%= multiPart ? ' enctype="multipart/form-data"' : '' %>>
						<g:hiddenField name="version" value="\${${propertyName}?.version}" />
						<fieldset>
							<f:all bean="${propertyName}"/>
						</fieldset>
						<div class="form-actions">
							<g:link class="btn btn-default" action="show" id="\${${propertyName}?.id}" role="button">
								<span class="glyphicon glyphicon-remove"></span>
								<g:message code="default.button.cancel.label" default="Cancel" />
							</g:link>
							<button type="submit" class="btn btn-success">
								<span class="glyphicon glyphicon-floppy-disk"></span>
								<g:message code="default.button.update.label" default="Update" />
							</button>
						</div>
					</g:form>
				</div>	
			</div>
		</section>
	</body>
</html>
