<% import grails.persistence.Event %>
<g:set var="entityName" value="\${message(code: '${domainClass.propertyName}.label', default: '${className}').replaceAll(' ','_')}" />
<div class="modal fade" id="\${entityName}-edit-\${${propertyName}?.id}">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
				<h4 class="modal-title">
					<g:message code="default.update.label" args="[message(code:'${domainClass.propertyName}.label', default:'${className}')]"/>
				</h4>
			</div>
			<div class="modal-body">
				<g:if test="\${flash.message}">
				<bootstrap:alert class="alert-info">\${flash.message}</bootstrap:alert>
				</g:if>
				<g:hasErrors bean="\${${propertyName}}">
				<bootstrap:alert class="alert-danger">
				<ul>
					<g:eachError bean="\${${propertyName}}" var="error">
					<li <g:if test="\${error in org.springframework.validation.FieldError}">data-field-id="\${error.field}"</g:if>><g:message error="\${error}"/></li>
					</g:eachError>
				</ul>
				</bootstrap:alert>
				</g:hasErrors>
				<g:form class="form-horizontal" controller="\${controllerName}" action="\${actionName}" id="\${${propertyName}?.id}">
					<g:hiddenField name="version" value="\${${propertyName}?.version}" />
					<fieldset>
						<f:all bean="${propertyName}"/>
					</fieldset>
				</g:form>
			</div>
			<div class="modal-footer">
				<button type="button" class="cancel btn btn-default" data-dismiss="modal">
					<span class="glyphicon glyphicon-remove"></span>
					<g:message code="default.button.cancel.label" default="Cancel" />
				</button>
				<button type="button" class="submit btn btn-primary">
					<span class="glyphicon glyphicon-floppy-disk"></span>
					<g:message code="default.button.update.label" default="Update" />
				</button>
			</div>
		</div>
	</div>
	<script type="text/javascript">
		\$(function(){
			var modalSelector="#\${entityName}-edit-\${${propertyName}?.id}";
			if(!\$(modalSelector).attr("initializedOnLoad")){
				\$(modalSelector).attr("initializedOnLoad",true);
				\$(modalSelector+" form").submit(defaultEventFormSubmitByAjax)
				.data("onBeforeSubmit",function(){\$(modalSelector).modal("hide");})
				.data("onAfterSubmit",function(){\$(modalSelector).modal("show");});
				\$(modalSelector+" button.cancel").click(function(){
					\$(modalSelector+" form").data("onAfterSubmit",null);
					\$(modalSelector).modal("hide");
				});
				\$(modalSelector+" button.submit").click(function(){\$(modalSelector+" form").submit();});
			}
		});
	</script>
</div>



