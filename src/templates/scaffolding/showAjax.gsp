<% import grails.persistence.Event %>
<g:set var="entityName" value="\${message(code: '${domainClass.propertyName}.label', default: '${className}').replaceAll(' ','_')}" />
<div class="modal fade" id="\${entityName}-show-\${${propertyName}?.id}">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
				<h4 class="modal-title">
					<g:message code="default.show.label" args="[message(code:'${domainClass.propertyName}.label', default:'${className}')]"/>
				</h4>
			</div>
			<div class="modal-body">
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
							<%  if (p.type == Date || p.type == java.sql.Date || p.type == java.sql.Time || p.type == Calendar) { %>
								<f:display bean="${propertyName}" property="${p.name}">
								    <g:formatDate date="\${value}" type="datetime" style="MEDIUM"/>
								</f:display>
							<%  } else {%>
								<f:display bean="${propertyName}" property="${p.name}"/>
							<%  } %>
						</g:if>
					<%  } %>
				</dl>
			</div>
			<div class="modal-footer">
				<button type="button" class="cancel btn btn-default" data-dismiss="modal">
					<span class="glyphicon glyphicon-remove"></span>
					<g:message code="default.button.close.label" default="Close" />
				</button>
			</div>
		</div>
	</div>
	<script type="text/javascript">
		\$(function(){
			var modalSelector="#\${entityName}-show-\${${propertyName}?.id}";
			if(!\$(modalSelector).attr("initializedOnLoad")){
				\$(modalSelector).attr("initializedOnLoad",true);
				\$(modalSelector+" button.cancel").click(function(){
					\$(modalSelector).modal("hide");
				});
			}
		});
	</script>
</div>


