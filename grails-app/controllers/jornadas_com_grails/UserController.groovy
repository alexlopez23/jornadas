package jornadas_com_grails
import grails.plugin.springsecurity.annotation.Secured

@Secured(['ROLE_ROOT','IS_AUTHENTICATED_FULLY'])
class UserController {
    def scaffold = Usuario
}
