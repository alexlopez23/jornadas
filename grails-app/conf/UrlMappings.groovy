class UrlMappings {

	static mappings = {
        "/"(controller:"Jornada",action:"list")//"/panel"(controller:"panelAdministrativo",action:"index")    
        "/$controller/$action?/$id?(.$format)?"{
            constraints {
                // apply constraints here
            }
        }
        "/jornada/index"(controller:"Jornada", action:"list")
//        "/"(view:"/index")
        "500"(view:'/error')
	}
}
