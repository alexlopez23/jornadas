class BootStrap {

    def init = { servletContext ->
//        def rootRole= jornadas_com_grails.Role.findByAuthority("ROLE_ROOT")?:new jornadas_com_grails.Role(authority: "ROLE_ROOT").save(failOnError: true)
//		def user = jornadas_com_grails.User.findByUsername("user")?:new jornadas_com_grails.User(username: "user",password:"123123",enabled:true).save(failOnError: true)
//		if (!user.authorities.contains(rootRole)) {
//		    jornadas_com_grails.UserRole.create user, rootRole
//		}
    }
    def destroy = {
    }
}
