package jornadas_com_grails

class Peticion {
    
    String nombre
    String apaterno
    String amaterno
    String domicilio
    String colonia
    String descripcion
    static belongsTo = [jornada:Jornada]
    static constraints = {
        nombre(blank:false)
        apaterno(blank:false)
        amaterno(blank:false)
        domicilio(blank:false)
        colonia(blank:false)        
    }
}
