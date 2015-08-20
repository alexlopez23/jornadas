package jornadas_com_grails
import grails.plugin.springsecurity.annotation.Secured

@Secured(['isRememberMe()'])
class UsuarioController {
	def springSecurityService
    def personal(){
        // TODO Requires current user
        def user = params.username ? Usuario.findByUsername(params.username) : currentUser
        user.attach()

        // If we can't find the user, it's a 404
        if (!user) {
            response.sendError(404)
            return
        }
        [ person: user ]
    }
	@Secured(['isRememberMe'])
	def editar(){
		def usuarioInstance = currentUser
		if(!usuarioInstance){
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'usuario.label', default: 'Usuario'), params.username])}"
            redirect(action: "personal")
		}
		[usuarioInstance:usuarioInstance]
	}
	@Secured(['isRememberMe'])
	def actualizar(){
		def usuarioInstance = currentUser
        if (usuarioInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (usuarioInstance.version > version) {
                    usuarioInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'usuario.label', default: 'Usuario')] as Object[], "Another user has updated this Usuario while you were editing")
                    render(view: "editar", model: [usuarioInstance: usuarioInstance])
                    return
                }
            }
			params.remove("username")
			params.remove("enabled")
			params.remove("accountExpired")
			params.remove("accountLocked")
			params.remove("passwordExpired")
            usuarioInstance.properties = params
            if (!usuarioInstance.hasErrors() && usuarioInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'usuario.label', default: 'Usuario'),'['+usuarioInstance+']'])}"
                redirect(action: "personal")
            }
            else {
                render(view: "editar", model: [usuarioInstance: usuarioInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'usuario.label', default: 'Usuario'), params.username])}"
            redirect(action: "personal")
        }
	}
    private getCurrentUser() {return Usuario.get(springSecurityService.principal.id)}
}
