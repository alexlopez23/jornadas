package jornadas

class FooterTagLib {
	def thisYear = {
		out << new Date().format("yyyy")
	}
	def copyright = {attrs, body->
		out << "&copy; " + attrs.startYear + " - "
		out << thisYear() + " " + body()
	}
	def logoutUrl = {
		out << grails.plugin.springsecurity.SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
	}
}
