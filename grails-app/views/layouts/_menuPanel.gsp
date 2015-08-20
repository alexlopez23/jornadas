<!-- header -->
<header id="header" class="navbar navbar-inverse navbar-sm bg bg-black transparent navbar-fixed-top" role="navigation">
	<div class="container-fluid">
        <div class="navbar-header">
          	<button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
            	<span class="sr-only">Toggle navigation</span>
            	<span class="icon-bar"></span>
            	<span class="icon-bar"></span>
            	<span class="icon-bar"></span>
          	</button>
			<a class="navbar-brand" href="${createLink(uri: '/')}">${meta(name: 'app.name').toUpperCase()}
			
			</a>
        </div>
        <div class="navbar-collapse collapse">
			<sec:ifLoggedIn>
			<!-- left navbar -->
			<ul class="nav navbar-nav">
				<li<%= request.forwardURI == "${createLink(uri: '/')}" ? ' class="active"' : '' %>>
					<a href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a>
				</li>
                        </ul>
			<!--/.left navbar -->
			<!-- right navbar -->
			
			<ul class="nav navbar-nav navbar-right navbar-avatar">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle" data-toggle="dropdown">      
						<span class="hidden-sm-only profile"><sec:loggedInUserInfo field="username"/></span>
						<span class="thumb-small avatar inline">
							<g:if test="${user?.email}">
								<avatar:gravatar cssClass="img-small img-circle"  email="${user?.email}" size="36"/>
							</g:if>
							<g:else>
								<img class="img-small img-circle" src="http://www.gravatar.com/avatar/00000000000000000000000000000000?d=mm"/>
							</g:else>
						</span>
						<span class="caret hidden-sm-only profile"></span>
					</a>
					<ul class="dropdown-menu" role="menu">
						<sec:ifAllGranted roles="ROLE_ROOT">
							<li class="dropdown-header">Administracion</li>
<!--							<li>
								<g:link action="index" controller="SCUser">
									<span class="glyphicon glyphicon-cog pull-right"></span>
									Usuarios
								</g:link>
							</li>
							<li>
								<g:link action="index" controller="Cuenta">
									<span class="glyphicon glyphicon-cog pull-right"></span>
									Catalogos
								</g:link>
							</li>-->
							<li class="divider"/>
						</sec:ifAllGranted>
                                                <li>
							<g:link class="" uri="${g.logoutUrl()}">
								<span class="glyphicon glyphicon-log-out pull-right"></span>
								<g:message code="springSecurity.logout.button" default="Logout" />
							</g:link>
						</li>
					</ul>
				</li>
                            </ul>	
			</sec:ifLoggedIn>
			<!--/.right navbar -->
        </div><!--/.navbar-collapse -->
    </div>
</header><!-- / header -->