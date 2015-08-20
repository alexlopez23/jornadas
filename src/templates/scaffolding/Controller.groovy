<%=packageName ? "package ${packageName}\n\n" : ''%>import org.springframework.dao.DataIntegrityViolationException
import grails.converters.XML
import grails.converters.JSON

class ${className}Controller {
    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
		def queryLike = params.q?:params.remove("q") 
		if(queryLike){
			queryLike = "%"+params.q.split(" ").join("%")+"%"
		}
		def queryCriteriaClosure = {
			if(params.q){
				like(params.field?:"name",queryLike)
			}
		}
		def renderParams = [model:[${propertyName}List: ${className}.createCriteria().list(params,queryCriteriaClosure), ${propertyName}Count: ${className}.createCriteria().count(queryCriteriaClosure)]]
		withFormat {
			html renderParams.model
		    xml { render renderParams.model as XML }
		    json {render renderParams.model as JSON}
		}
    }

    def create() {
		def renderParams = [view:actionName, model:[${propertyName}: new ${className}(params)]]
		def responseReturn = [success:false]
		def redirectParams = [action:"show", params:[:]]
		if(request.method=="POST"){
			if (renderParams.model.${propertyName}.save(flush: true)) {
				responseReturn.success = true
				responseReturn.message = message(code: "default.created.message", args: [message(code: "${domainClass.propertyName}.label", default: "${className}"), renderParams.model.${propertyName}])
	            responseReturn.put("${propertyName}",renderParams.model.${propertyName})
				redirectParams.id = renderParams.model.${propertyName}.id
	        }else{
				responseReturn.errors = renderParams.model.${propertyName}.errors.allErrors
			}
		}
		withFormat {
			html {
				if(request.method=="GET" || !responseReturn.success){
					if(request.xhr){renderParams.view = renderParams.view+"Ajax"}
					render renderParams
				}else{//the method is by POST and domain instance saved
					flash.message = responseReturn.message
					redirect redirectParams
				}
			}
		    json {render responseReturn as JSON}
			js   {render responseReturn as JSON}
		    xml  {render responseReturn as XML}
		}
    }

    def show() {
		def renderParams = [view:actionName, model:[${propertyName}:${className}.get(params.id)]]
		def responseReturn = [success:false]
		def redirectParams = [action:"index", params:[:]]
        if (!renderParams.model.${propertyName}) {
			responseReturn.message = message(code: "default.not.found.message", args: [message(code: "${domainClass.propertyName}.label", default: "${className}"), params.id])
        }else{
			responseReturn.success = true
			responseReturn.${propertyName} = renderParams.model.${propertyName}
		}
		withFormat {
			html {
				if(responseReturn.success){
					if(request.xhr){renderParams.view = renderParams.view+"Ajax"}
					render renderParams
				}else{
					flash.message = responseReturn.message
					redirect redirectParams
				}
			}
		    json {render responseReturn as JSON}
			js   {render responseReturn as JSON}
		    xml  {render responseReturn as XML}
		}
    }

    def edit() {
		def renderParams = [view:actionName, model:[${propertyName}:${className}.get(params.id)]]
		def responseReturn = [success:false]
		def redirectParams = [action:"index", params:[:]]
		if (!renderParams.model.${propertyName}) {
			responseReturn.message = message(code: "default.not.found.message", args: [message(code: "${domainClass.propertyName}.label", default: "${className}"), params.id])
        }else{
			responseReturn.${propertyName} = renderParams.model.${propertyName}
			if(request.method=="POST"){
				if (params.version && renderParams.model.${propertyName}.version > params.version.toLong()) {
		             renderParams.model.${propertyName}.errors.rejectValue("version", "default.optimistic.locking.failure",
		             	[message(code: "${domainClass.propertyName}.label", default: "${className}")] as Object[],
		                "Another user has updated this ${className} while you were editing")
					responseReturn.${propertyName} = renderParams.model.${propertyName}
		        }else{
					renderParams.model.${propertyName}.properties = params
					if (!renderParams.model.${propertyName}.save(flush: true)) {
			            responseReturn.errors = renderParams.model.${propertyName}.errors.allErrors
			        }else{
						responseReturn.success = true
						responseReturn.message = message(code: "default.updated.message", args: [message(code: "${domainClass.propertyName}.label", default: "${className}"), renderParams.model.${propertyName}])
						redirectParams.action = "show"
						redirectParams.id = renderParams.model.${propertyName}.id
					}
				}
			}
		}
		withFormat {
			html {
				if(request.xhr){renderParams.view = renderParams.view+"Ajax"}
				if(!renderParams.model.${propertyName} || responseReturn.success){
					if(responseReturn.message){flash.message = responseReturn.message}
					redirect redirectParams
				}else{
					render renderParams
				}
			}
			json {render responseReturn as JSON}
			js   {render responseReturn as JSON}
		    xml  {render responseReturn as XML}
		}
    }

    def delete() {
		def renderParams = [view:actionName, model:[${propertyName}:${className}.get(params.id)]]
		def responseReturn = [success:false]
		def redirectParams = [action:"index", params:[:]]
		if (!renderParams.model.${propertyName}) {
			responseReturn.message = message(code: "default.not.found.message", args: [message(code: "${domainClass.propertyName}.label", default: "${className}"), params.id])
        }else{
			responseReturn.${propertyName} = renderParams.model.${propertyName}
			if(request.method=="POST"){
				 try {
						renderParams.model.${propertyName}.delete(flush: true)
						responseReturn.success = true
						responseReturn.message = message(code: "default.deleted.message", args: [message(code: "${domainClass.propertyName}.label", default: "${className}"), renderParams.model.${propertyName}])
			     }
			     catch (DataIntegrityViolationException e) {
						responseReturn.message = message(code: "default.not.deleted.message", args: [message(code: "${domainClass.propertyName}.label", default: "${className}"), renderParams.model.${propertyName}])
			            redirectParams.action = "show"
						redirectParams.id = renderParams.model.${propertyName}.id
		         }
			}else{
				if(!request.xhr){
					response.sendError(404)
					return
				}
			}
		}
		withFormat {
			html {
				if(request.xhr){
					render renderParams
				}else{
					flash.message = responseReturn.message
					redirect redirectParams
				}
			}
	    	json {render responseReturn as JSON}
			js   {render responseReturn as JSON}
			xml  {render responseReturn as XML}
		}
    }
}
