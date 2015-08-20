$.fn.serializeObject = function(){
    var o = {};
    $.each(this.serializeArray(), function() {
        if (o[this.name] !== undefined) {
            if (!o[this.name].push) {
                o[this.name] = [o[this.name]];
            }
            o[this.name].push(this.value || '');
        } else {
            o[this.name] = this.value || '';
        }
    });
    return o;
};
String.prototype.format = function() {
  var args = arguments;
  return this.replace(/{(\d+)}/g, function(match, number) { 
    return typeof args[number] != 'undefined'
      ? args[number]
      : match
    ;
  });
};
var G_conf = {
	confirmMessage:"Are you sure?",
	buttons:{
		ajaxError:{"Accept": function(){$(this).dialog("close");}},
		dialogAccept:{"Accept": function(){$(this).dialog("close");}},
		dialogCancel:{"Cancel": function(){$(this).dialog("close");}},
		dialogSubmit:{"Submit": function(){$("form",$(this)).submit();}},
		dialogCreate:{"Create": function(){$("form",$(this)).submit();}},
		dialogUpdate:{"Update": function(){$("form",$(this)).submit();}},
		dialogDelete:{"Delete": function(){if(confirm("Are you Sure?")){$("form",$(this)).submit();}}},
		defaultDialogClose: function(){$(this).dialog("close");},
		defaultDialogSubmit: function(){$("form",$(this)).submit();},
		defaultDialogSubmitConfirm: function(){if(confirm(G_conf.confirmMessage)){$("form",$(this)).submit();}}
	}
};
//ONLOAD PAGE FUNCTIONS
var ajaxThreadRuning = 0;
$().ready(function(){
	$("form").attr({autocomplete:"off"});//.submit(function(){$("#spinner").show();return true;});
	//$("a[href]:not(.no-loading)").filter(function(){return this.href.match(/^[^#]./);}).click(function(){$("#spinner").show().delay(2000).fadeOut('slow');return true;});
	$(".app").hover(
		function(){$(this).addClass("medium-shadow-all corner-all");},
		function(){$(this).removeClass("medium-shadow-all corner-all");}
	);
	$("#spinner").ajaxStart(function(){
		ajaxThreadRuning++;
		$(this).show();
	})
	.ajaxStop(function(){
		ajaxThreadRuning--;
		if(ajaxThreadRuning < 1){
			$(this).fadeOut('slow');
		}
	});
	$("a.btn-ajax").each(function(i){
		$(this).click(function(e){
			e.preventDefault();
			modalAjax({
				element: this
			});
			//return true;
		});
		
	});
	$("a[data-role='button']").each(function(i){
		var btOpts = {text: !($(this).attr("data-no-text")=="true"),icons:{primary:$(this).attr("data-icon")}};
		$(this).button(btOpts);
	});
});
function ajaxStatus404(jqXHR, textStatus, errorThrown){
	$("<div/>").append(
		$("<div/>").addClass("errors").html('The server responds whith '+textStatus+': '+jqXHR.status+'('+errorThrown+')')
	)
	.dialog({
		show: "drop",
		hide: "drop",
		title: "Page "+errorThrown,
		width: 500,
		modal: true,
		close : function(){$(this).dialog("destroy").remove();},
		buttons : G_conf.buttons.ajaxError
	});
}
function ajaxStatus401(jqXHR, textStatus, errorThrown){
	$(jqXHR.responseText)
	.dialog({
		show: "drop",
		hide: "drop",
		title: "Page "+errorThrown,
		width: 500,
		modal: true,
		close : function(){
			var afterFireFn=$("form",$(this)).data("onAfterSubmit");
			if(!(afterFireFn && typeof afterFireFn=="function")){$(this).dialog("destroy").remove();}
			if(!$(this).attr("skipPageReload")){
				location.reload();
			}
		},
		buttons : G_conf.buttons.ajaxError
	});
}
function ajaxStatus500(jqXHR, textStatus, errorThrown){
	ajaxStatus404(jqXHR, textStatus, errorThrown);
}

/*
Open dialog messages by ajax
*/
function modalAjax(options){
	if(options.element && options.element!=undefined){
		options.element = typeof options.element != 'string' && options.element.jquery ? options.element : $(options.element);
		options.modal= options.modal || {}
		$.ajax({
			type: options.type || "GET",
			url: options.url || options.element.attr("href"),
			data: options.data || {},
			dataType: options.dataType || "html",
			success: function(data, textStatus, jqXHR){
				$("#"+$(data).attr("id"),$("body")).remove();
				var dialogId = "#"+$(data).appendTo($("body")).attr("id");
				$(dialogId).dialog({
					autoOpen: false,
					show: "drop",
					hide: "drop",
					title: options.element.attr("data-dialog-title")|| options.element.attr("title") || "Dialog",
					width: options.element.attr("data-dialog-width")||"auto",
					modal: true,
					open: function(event, ui){
						if($(this).data("afterDialogOpen") && typeof $(this).data("afterDialogOpen")  =="function" ){
							$(this).data("afterDialogOpen")();
						}
					},
					close : function(event, ui){
						var afterFireFn=$("form",$(this)).data("onAfterSubmit");
						if(!(afterFireFn && typeof afterFireFn=="function")){$(this).dialog("destroy").remove();}
					}
				});
				$(dialogId).dialog("open");
			},
			statusCode: {401: ajaxStatus401,404: ajaxStatus404,500: ajaxStatus500}
		});
	}
}

function formSubmitAjax(options){
	if(options.element && options.element!=undefined){
		options.element = typeof options.element != 'string' && options.element.jquery ? options.element : $(options.element);
		if(options.element[0].tagName=="FORM" || options.element[0].tagName=="form"){
			if(options.dataType && options.dataType.toLowerCase()=="json" && !(options.data && options.data.format)){
				if(!options.data){options.data={};}
				options.data.format="json";
			}
			$.ajax({
				type: options.type || "POST",
				url: options.url || options.element.attr("action"),
				data: $.extend({}, options.element.serializeObject(), options.data || {}),
				dataType: options.dataType || "json",
				success: options.success && typeof options.success=="function" ? options.success : function(response, textStatus, jqXHR){},
				statusCode: {401: ajaxStatus401,404: ajaxStatus404,500: ajaxStatus500}
			});
		}
	}
}
function defaultEventFormSubmitByAjax(event){
	formSubmitAjax({
		element: event.target,
		success: function(response){
			checkJSONResponse(event,response);
		}
	});
	return false;
}



/*
	{
		errors:[],
		element: "",//selector or an a JQuery objet
	}
*/
function renderErrors(options){
	if(options.errors && $.isArray(options.errors) && options.container && options.container!=undefined){
		options.container = typeof options.container != 'string' && options.container.jquery ? options.container : $(options.container);
		options.container.empty();
		$ul=$("<ul/>").appendTo(options.container);
		options.highlightErrors=false;
		if(options.form){
			options.form = typeof options.form != 'string' && options.form.jquery ? options.form : $(options.form);
			options.highlightErrors= options.form[0].tagName=="FORM" || options.form[0].tagName=="form";
			if(options.highlightErrors){
				$(".errors:not(div)").removeClass("errors");
			}
		}
		$.each(options.errors,function(iError,error){
			$("<li/>").html(eval("error.defaultMessage.format('"+error.arguments.join("','")+"')"))
			.appendTo($ul);
			if(options.highlightErrors){
				$("[name='"+error.field+"'],[name='"+error.field+".id']",options.form).parent().addClass("errors");
			}
		});
	}
}
/*
	{
		element: "",//selector or an a JQuery objet
		url: "",//A string containing the URL to which the request is sent. If the url is not setted, the action for the form will be used
		data: "",//A extra map that is sent to the server with the request.
		success: function(response){} // A callback function that is executed if the request succeeds.
		dataType: "" // The type of data expected from the server. Default: Intelligent Guess (xml, json, script, text, html)
	}
*/
function remoteFunction(options){
	if(options.element && options.element!=undefined){
		options.element = typeof options.element != 'string' && options.element.jquery ? options.element : $(options.element);
		if(options.element[0].tagName=="FORM" || options.element[0].tagName=="form"){
			$.ajax({
				type: "POST",
				url: options.url || options.element.attr("action"),
				data: $.extend({}, options.element.serializeObject(), options.data || {}),
				dataType: options.dataType | "html",
				success: function(response){
					if(options.success && typeof options.success=="function"){
						options.success(response);
					}
				},
				statusCode: {401: ajaxStatus401,404: ajaxStatus404,500: ajaxStatus500}
			});
		}
	}
}
/**
	event: the event that fires de remote function, usually is a form element
	jsonResponse: JSON format argument {success:Boolean,errors:Array,message:String}
	
	The function return a bollean value if success is true
*/
function checkJSONResponse(event,jsonResponse){
	if(!jsonResponse.success && jsonResponse.errors){
		if(event){
			renderErrors({
				container:$("div.errors",$(event.target)).length ? $("div.errors",$(event.target)) : $("<div/>").addClass("errors").prependTo($(event.target)),
				form: event.target,
				errors:jsonResponse.errors
			});
		}
	}else{
		var beforeFireFn = event ? $(event.target).data("onBeforeSubmit"):null;
		var afterFireFn = event ? $(event.target).data("onAfterSubmit"):null;
		$("<div/>").html(jsonResponse.message || "").addClass(jsonResponse.success?"message":"errors")
		.dialog({
			title: jsonResponse.success?"Sucess!!!":"Error",
			width: "auto",
			modal: true,
			close : function(){
				if(!jsonResponse.success && afterFireFn && typeof afterFireFn=="function"){
					afterFireFn();
				}else{
					$(this).dialog("destroy").remove();
					location.reload();
				}
			},
			buttons : G_conf.buttons.dialogAccept
		});
	}
	return jsonResponse.success ? true:false
}
function defaultSubmitByAjax(event){
	remoteFunction({
		element: event.target,
		success: function(response){
			checkJSONResponse(event,response);
		}
	});
	return false;
}
function defaultOpenDialogByAjax(options){
	if(options.element && options.element!=undefined){
		options.element = typeof options.element != 'string' && options.element.jquery ? options.element : $(options.element);
		options.action = options.action || "submit"
		if(!options.buttons){
			options.buttons = $.extend({}, 
				G_conf.buttons.dialogCancel||{}, 
				(options.action=="cancel"? G_conf.buttons.dialogCancel:
					options.action=="create"? G_conf.buttons.dialogCreate:
					options.action=="update"? G_conf.buttons.dialogUpdate:
					options.action=="delete"? G_conf.buttons.dialogDelete:G_conf.buttons.dialogSubmit
				)||{}
			);
		}
		$.post(options.element.attr("href"),{},function(response){
			$(response)
			.dialog({
				title: options.title || "Dialog",
				width: 500,
				modal: true,
				open: function(){
					$(".ui-dialog-buttonpane .ui-dialog-buttonset button",$(this).parent())
					.first().button("option",{icons: {primary: 'ui-icon-cancel'}})
					.next().button("option",{icons: {primary: 'ui-icon-disk'}});
					$("form",$(this)).submit(defaultSubmitByAjax);
				},
				buttons : options.buttons
			});;
		});
	}
}
// options = {element,selectOptions,dependsOn,dependsOnKey,optionKey,optionValue}
function smartSelect(options){
	if(options && options.element){
		options.element.data("smartSelectOptions",options.selectOptions || []);
		options.element.data("smartOptionKey",options.optionKey);
		options.element.data("smartOptionValue",options.optionValue);
		if(options.dependsOn){
			options.element.data("smartDependsOn",options.dependsOn);
			options.element.data("smartDependsOnKey",options.dependsOnKey || options.dependsOn.attr("name"));
			options.element.data("smartDependsOnLastSelectedValue",options.dependsOn.find(":selected").val());
			if(options.dependsOn.data("smartSelectChilds")){
				options.dependsOn.data("smartSelectChilds").push(options.element);
			}else{
				options.dependsOn.data("smartSelectChilds",[options.element]);
			}
			if(options.dependsOn.find(":selected").val()=="null"){
				options.element.attr('disabled', 'disabled');
			}
		}
		//console.log("added event change on");
		//console.log(options.element);
		options.element.change(function(){smartSlectChangeEvent($(this));});
	}
	
}
function smartSlectChangeEvent(element){
	if(element.data("smartDependsOn")){
		//here to show if need to replace for new options
		if(element.data("smartDependsOn").find(":selected").val()!=element.data("smartDependsOnLastSelectedValue")){
			//set the new value
			element.data("smartDependsOnLastSelectedValue",element.data("smartDependsOn").find(":selected").val());
			if(element.data("smartDependsOn").find(":selected").val()=="null"){
				element.html("");
				element.append($("<option/>").val("null").html(""));
				element.attr('disabled', 'disabled');
			}else{
				element.removeAttr('disabled');
				smartSelectReplaceOptions(element);
			}
		}
	}
	//then here fire the childs events
	if(element.data("smartSelectChilds")){
		$.each(element.data("smartSelectChilds"),function(eIndx,eItm){
			smartSlectChangeEvent(eItm);
		});
	}
}
function smartSelectReplaceOptions(element){
	element.html("");
	element.append($("<option/>").val("null").html(""));
	var matchValue = element.data("smartDependsOnLastSelectedValue");
	var optionKeyMatchArray = element.data("smartDependsOnKey").split(".");
	var optionKey = element.data("smartOptionKey");
	var optionValue = element.data("smartOptionValue");
	if(element.data("smartSelectOptions")){
		$.each(element.data("smartSelectOptions"),function(eIndx,eItm){
			var matchKey = eItm;
			for(x in optionKeyMatchArray){
				matchKey = matchKey[optionKeyMatchArray[x]];
			}
			if(matchKey == matchValue){
				var outputText = [];
				$.each(optionValue.split(","),function(opIndx,opItm){
					outputText.push(eItm[opItm]);
				});
				element.append($("<option/>").val(eItm[optionKey]).html(outputText.join(" ")));
			}
		});
	}
}	