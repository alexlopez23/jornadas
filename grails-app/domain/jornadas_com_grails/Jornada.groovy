package jornadas_com_grails

class Jornada {

    String nombre
    String sede    
    Date dateCreated
    Date lastUpdated
    static hasMany =[peticiones:Peticion]
    static constraints = {
        nombre(blank:false)
        sede(blank:false)
    }
    
    String toString(){nombre}
}
