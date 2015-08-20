<html>
<head>
	<meta name='layout' content='bootstrapLogin'/>
	<title><g:message code="springSecurity.login.title"/></title>
</head>

<body>
<form action="${postUrl}" method="POST" id="loginForm" class="form-signin" role="form" autocomplete="off">
	<g:if test="${flash.message}">
	<bootstrap:alert class="alert-danger">${flash.message}</bootstrap:alert>
	</g:if>
	<g:if test="${flash.error}">
	<bootstrap:alert class="alert-danger">${flash.error}</bootstrap:alert>
	</g:if>
	<h2 class="form-signin-heading">Iniciar sesión</h2>
	<input type="text" name="j_username" class="form-control" placeholder="${message(code:'springSecurity.login.username.label')}" required autofocus>
	<input type="password" name="j_password" class="form-control" placeholder="${message(code:'springSecurity.login.password.label')}" required>
	<label class="checkbox">
      <input type="checkbox" name="${rememberMeParameter}" <g:if test='${hasCookie}'>checked='checked'</g:if>> <g:message code="springSecurity.login.remember.me.label"/>
    </label>
	<button class="btn btn-lg btn-primary btn-block" type="submit"><g:message code="springSecurity.login.button"/></button>
</form>
<script type='text/javascript'>
	<!--
	(function() {
		document.forms['loginForm'].elements['j_username'].focus();
	})();
	// -->
</script>
</body>
</html>
