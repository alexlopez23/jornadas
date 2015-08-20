package jornadas_com_grails

class Usuario extends User{
	String nombre
	String apellidos
	String email
	Date dateCreated
	Date lastUpdated
    static constraints = {
		nombre nullable:false, blank:false
		apellidos nullable:false, blank:false
		email email:true, unique:true , blank:false, nullable:false
    }
	String toString(){username}
	def getFullName(){nombre+" "+apellidos}
}
