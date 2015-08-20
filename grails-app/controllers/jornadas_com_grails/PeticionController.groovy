package jornadas_com_grails

import grails.plugin.springsecurity.annotation.Secured
import grails.converters.JSON
import grails.converters.XML

@Secured(['isFullyAuthenticated()'])
class PeticionController {

    def listByJornada={
        def renderParams = [view:"listByJornada", model:[jornadaInstance:Jornada.get(params.id)]]
        def responseReturn = [success:false]
        def redirectParams = [controller:"jornada", action:"list"]
        if (!renderParams.model.jornadaInstance) {
            responseReturn.message = message(code: "default.not.found.message", args: [message(code: "jornada.label", default: "Jornada"), params.id])
        }else{
            responseReturn.success=true
            params.max = Math.min(params.max ? params.int('max') : 20, 100)
            responseReturn.peticionInstanceList = renderParams.model.peticionInstanceList = Peticion.createCriteria().list(params){
                eq("jornada",renderParams.model.jornadaInstance)
            }
            responseReturn.peticionInstanceTotal = renderParams.model.peticionInstanceTotal = Peticion.createCriteria().count{
                eq("jornada",renderParams.model.jornadaInstance)
            }
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
		json {render responseReturn as JSON}
		js   {render responseReturn as JSON}
		xml  {render responseReturn as XML}
        }
    }
    def crear = {
        def jornadaInstance = Jornada.get(params.id)
        if(!jornadaInstance){
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'jornada.label', default: 'Jornada'), params.id])}"
            redirect(controller:"jornada",action: "list")
        }else{            
            params.remove("id")
	    jornadaInstance.properties = params
            [jornadaInstance: jornadaInstance]
        }        
    }
    @Secured(["hasAnyRole('ROLE_ROOT','ROLE_ADMIN','ROLE_ENLACE','ROLE_TITULAR') and isFullyAuthenticated()"])
    def guardar(){
        def jornadaInstance = Jornada.get(params.remove("id"))
        if(!jornadaInstance){
            println "no se encontro jornada"
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'jornada.label', default: 'Jornada'), params.id])}"
            redirect(controller:"jornada",action: "list")
        }else{            
            def peticionInstance = new Peticion(params)
            peticionInstance.jornada = jornadaInstance
            if (peticionInstance.save(flush: true)) {
                println "peticion creada correctamente"
                flash.message = "${message(code: 'default.created.message', args: [message(code: 'Peticion.nombre', default: 'Petición'), '[Folio no. '+peticionInstance.id+']'])}"
	        redirect(action: "listByJornada", id: jornadaInstance.id)
            }
            else {
                println "error al crear peticion"
                render(view: "crear", model: [peticionInstance: peticionInstance, jornadaInstance:jornadaInstance])
            }            
        }     
    }
    def edit(){
        def peticionInstance = Peticion.get(params.remove("id"))
        def jornadaInstance = Jornada.get(peticionInstance.get(jornada_id))
        if(!peticionInstance){
              println "no se encontro peticion"
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'peticion.label', default: 'Peticion'), params.id])}"
            redirect(controller:"jornada",action: "list")
        }else{            
            [peticionInstance:peticionInstance, jornadaInstance:jornadaInstance]
            
        }
    }
}
