package jornadas_com_grails

import grails.plugin.springsecurity.annotation.Secured
import grails.converters.XML
import grails.converters.JSON

@Secured(['isFullyAuthenticated()'])
class JornadaController {    
    def list= {
              // TODO: Mus be filtered the list by privileged relationed
                //println "LISTADO DE JORNADAS"
		params.max = Math.min(params.max ? params.int('max') : 20, 100)
		def model = [jornadaInstanceList: [], productInstanceTotal:0]
		def queryLike = params.q?:params.remove("q") 
		if(queryLike){
			queryLike = "%"+params.q.split(" ").join("%")+"%"
		}
		model.jornadaInstanceList=Jornada.createCriteria().list(params){
			if(params.q){
				like(params.field?:"nombre",queryLike)
			}
		}
		def queryCriteriaClosure = {
			if(params.q){
				like(params.field?:"nombre",queryLike)
			}			
		}
		model.jornadaInstanceList = Jornada.createCriteria().list(params,queryCriteriaClosure)
		model.jornadaInstanceTotal=Jornada.createCriteria().count(queryCriteriaClosure)
		withFormat {
                    html model
		    xml { render model as XML }
		    json {render model as JSON}
		} 
    }
    def crear(){
        println "crear"
        def jornadaInstance = new Jornada()
        jornadaInstance.properties = params
        [jornadaInstance: jornadaInstance]        
    }
    def guardar(){
        def jornadaInstance = new Jornada()
        jornadaInstance.properties =  params
        println "entrando a guardar"
        if (jornadaInstance.save(flush: true)) {
            println "correctamente guardado"
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'jornada.label', default: 'Jornada'), '['+jornadaInstance+']'])}"
	    redirect(action: "dashboard", id: jornadaInstance.id)
	}
	else {
           render(view: "crear", model: [jornadaInstance: jornadaInstance])
	}
    }
    def dashboard(){
        def renderParams = [view:"dashboard", model:[jornadaInstance:Jornada.get(params.id)]]
	def responseReturn = [success:false]
	def redirectParams = [controller:"jornada",action:"list"]
	if (!renderParams.model.jornadaInstance) {
            if(!renderParams.model.jornadaInstance){
                responseReturn.message = message(code: "default.not.found.message", args: [message(code: "jornada.label", default: "Jornada"), params.id])
            }
        }else{
            responseReturn.success = true            
            responseReturn.jornada = renderParams.model.jornadaInstance
	}
	withFormat {
            html {
                if(!responseReturn.success){
                    if(request.xhr){
                        render view:"/messageAjax", model:responseReturn
                    }else{
			flash.message = responseReturn.message
			redirect redirectParams
                    }
                }else{
                    renderParams.view = renderParams.view+(request.xhr?"Ajax":"")
                    render renderParams
		}
            }
            json {render renderParams.model as JSON}
            js   {render renderParams.model as JSON}
            xml  {render renderParams.model as XML}
	}        
    }
    def editar(){
        def jornadaInstance = Jornada.get(params.id)
        if (!jornadaInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'jornada.label', default: 'Jornada'), params.id])}"
	    redirect(controller:"jornada",action: "list")			
        }else{
            [jornadaInstance: jornadaInstance]
        }        
    }
    def actualizar(){
            def jornadaInstance = Jornada.get(params.id)
            if (jornadaInstance) {
                if (params.version) {
                    def version = params.version.toLong()
                    if (jornadaInstance.version > version) {
                        jornadaInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'jornada.label', default: 'Jornada')] as Object[], "Another user has updated this Eje Temático while you were editing")
                        render(view: "editar", model: [jornadaInstance: jornadaInstance])
                        return
                    }
                }
                jornadaInstance.properties = params
                if (!jornadaInstance.hasErrors() && jornadaInstance.save(flush: true)) {
                    flash.message = "${message(code: 'default.updated.message', args: [message(code: 'jornada.label', default: 'Jornada'),'['+jornadaInstance+']'])}"
                    redirect(action: "dashboard", id: jornadaInstance.id)
                }
                else {
                    println "TIENE ERRORES"
                    render(view: "editar", model: [jornadaInstance: jornadaInstance])
                }
            }
            else {
                if(!jornadaInstance){
                    flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'jornada.label', default: 'Jornada'), params.id])}"
                    redirect(controller:"jornada",action: "list")
                }
            }
	}
    
}
