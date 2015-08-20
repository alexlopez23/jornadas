// This is a manifest file that'll be compiled into application.js.
//
// Any JavaScript file within this directory can be referenced here using a relative path.
//
// You're free to add application-wide JavaScript to this file, but it's generally better 
// to create separate JavaScript files as needed.
//
//= require jquery
//= require bootstrap
//= require_self
if (typeof jQuery !== 'undefined') {
	(function($) {
		$('#spinner').ajaxStart(function() {
			$(this).fadeIn();
		}).ajaxStop(function() {
			$(this).fadeOut();
		});
	})(jQuery);
}

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
var loadingModal;
loadingModal = loadingModal || (function () {
    var pleaseWaitDiv = $('																			\
		<div class="modal" id="pleaseWaitDialog" data-backdrop="static" data-keyboard="false" style="display:none" >	\
			<div class="modal-dialog">																\
				<div class="modal-content">															\
					<div class="modal-header">														\
						<h1 class="modal-title">Procesando...</h1>									\
					</div>																			\
					<div class="modal-body">														\
						<div class="progress">														\
							<div class="progress-bar progress-bar-info progress-bar-striped active" role="progressbar" style="width: 100%;"></div> 							\																	\
						</div>																		\
					</div>																			\
				</div>																				\
			</div>																					\
		</div>');
	var pleaseWaitDivCallBack = null;
    return {
        showPleaseWait: function(message) {
			message = message || "Procesando...";
			$(".modal-header .modal-title",pleaseWaitDiv).html(message);
            pleaseWaitDiv//.addClass("fade")
			.modal("show")
			.on("hidden.bs.modal",function(){
				if(pleaseWaitDivCallBack && typeof pleaseWaitDivCallBack=="function"){
					pleaseWaitDivCallBack();
				}
				pleaseWaitDivCallBack = undefined;
			});
        },
        hidePleaseWait: function (callBack) {
			pleaseWaitDivCallBack = callBack;
            pleaseWaitDiv.removeClass("fade").modal('hide');
        },

    };
})();
//ONLOAD PAGE FUNCTIONS
$().ready(function(){
	$('[data-toggle="tooltip"]').tooltip();
	$("a.btn-ajax").each(function(i){
		$(this).click(function(e){
			e.preventDefault();
			modalAjax({
				element: this
			});
			//return true;
		});
		
	});
});
function modalMessage(message,options){
	options = options || {} ;
	options.title = options.title  || "Message";
	$("body.modal-open div.modal.fade.in").modal("hide");
	$("#modalMessage .modal-header .modal-title").html(options.title);
	$("#modalMessage .modal-body").html(
		$("<div/>").addClass("alert "+(options.alert || "alert-info"))
		.html(
			message
		)
	);
	$("#modalMessage").modal();
}
function ajaxStatus403(jqXHR, textStatus, errorThrown){
	ajaxStatus500(jqXHR, textStatus, errorThrown);
}
function ajaxStatus404(jqXHR, textStatus, errorThrown){
	loadingModal.hidePleaseWait();
	$("body.modal-open div.modal.fade.in").modal("hide");
	$("#modalMessage .modal-header .modal-title").html("Page "+errorThrown);
	$("#modalMessage .modal-body").html($("<div/>")
	.addClass("alert alert-error").html('The server responds whith '+textStatus+': '+jqXHR.status+'('+errorThrown+')'));
	$("#modalMessage").modal();
}
function ajaxStatus401(jqXHR, textStatus, errorThrown){
	loadingModal.hidePleaseWait();
	var dataModal = $(jqXHR.responseText).hide();
	$("#"+dataModal.attr("id")+".modal",$("body")).modal("hide").remove();
	dataModal.appendTo($("body"))
	.modal({}).on("hidden",function(){
		var afterFireFn=$("form",$(this)).data("onAfterSubmit");
		if(!(afterFireFn && typeof afterFireFn=="function")){$(this).remove();}
		if(!$(this).attr("skipPageReload")){
			location.reload();
		}
	}).on("shown",function(){$("body > .modal-backdrop.in:not(.fade)").remove();});
}
function ajaxStatus500(jqXHR, textStatus, errorThrown){
	loadingModal.hidePleaseWait();
	var modalText = 'The server responds whith '+textStatus+': '+jqXHR.status+'('+errorThrown+')';
	var ct = jqXHR.getResponseHeader("content-type") || "";
	if (ct.indexOf('json') > -1) {
		var jsonResponse = $.parseJSON(jqXHR.responseText);
		modalText = "Error: " + jsonResponse.error;
	}else{
		var matchBodyText = jqXHR.responseText.match(/<body[^>]*>([\s\S]*?)<\/body>/ig);
		if(matchBodyText){
			modalText = $(matchBodyText[0].split("<body")[1].split(">").slice(1).join(">").split("</body>")[0]);
		}else{
			modalText = $(jqXHR.responseText);
		}
	}
	$("body.modal-open div.modal.fade.in").modal("hide");
	$("#modalMessage .modal-header .modal-title").html(textStatus+": "+errorThrown);
	$("#modalMessage .modal-body").html(
		$("<div/>").addClass("alert alert-danger")
		.html(modalText)
	);
	$("#modalMessage").modal();
}

/*
Open dialog messages by ajax
*/
function modalAjax(options){
	if(options.element && options.element!=undefined){
		options.element = typeof options.element != 'string' && options.element.jquery ? options.element : $(options.element);
		options.modal= options.modal || {};
		loadingModal.showPleaseWait("Cargando...");
		$.ajax({
			type: options.type || "GET",
			url: options.url || options.element.attr("href"),
			data: options.data || {},
			dataType: options.dataType || "html",
			success: function(data, textStatus, jqXHR){
				loadingModal.hidePleaseWait();
				var dataModal = $(data).hide();
				$("#"+dataModal.attr("id")+".modal",$("body")).modal("hide").remove();
				dataModal.appendTo($("body"));
				//$("script",dataModal).remove();
				//console.log("inited jq");
				dataModal//.hide().appendTo($("body"))
				.modal(options.modal).on("hidden.bs.modal",function(){
					var afterFireFn=$("form",$(this)).data("onAfterSubmit");
					if(!(afterFireFn && typeof afterFireFn=="function")){$(this).remove();}
				}).on("shown.bs.modal",function(){$("body > .modal-backdrop.in:not(.fade)").remove();});
			},
			statusCode: {401:ajaxStatus401, 403:ajaxStatus403, 404:ajaxStatus404, 500:ajaxStatus500}
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
function formSubmitAjax(options){
	if(options.element && options.element!=undefined){
		options.element = typeof options.element != 'string' && options.element.jquery ? options.element : $(options.element);
		if(options.element[0].tagName=="FORM" || options.element[0].tagName=="form"){
			//console.log("Posting: "+(options.url || options.element.attr("action")));
			options.dataType = options.dataType || "json"
			options.type = options.type || "POST";
			options.url = options.url || options.element.attr("action");
			//console.log(options.url);
			if(!options.url.match(/.+\.([^?]+)(\?|$)/)){
				//console.log("match..");
				options.url = options.url + "."+options.dataType.toLowerCase();
			}
			loadingModal.showPleaseWait("Procesando...");
			$.ajax({
				type: options.type,
				url: options.url,
				data: $.extend({}, options.element.serializeObject(), options.data || {}),
				dataType: options.dataType,
				success: options.success && typeof options.success=="function" ? options.success : function(response, textStatus, jqXHR){loadingModal.hidePleaseWait();},
				statusCode: {401:ajaxStatus401, 403:ajaxStatus403, 404:ajaxStatus404, 500:ajaxStatus500}
			});
		}
	}
}
function defaultEventFormSubmitByAjax(event){
	var beforeFireFn=$(event.target).data("onBeforeSubmit");
	if(beforeFireFn && typeof beforeFireFn=="function"){
		beforeFireFn(event,{});
	}
	formSubmitAjax({
		element: event.target,
		type: $(event.target).attr("method"),
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
		options.container.empty()
		.append(	
			$("<button/>").addClass("close").attr({type:"button", "data-dismiss":"alert", "aria-label":"Close"})
			.append($("<span/>").attr({"aria-hidden":"true"}).html("&times;"))
		).alert();
		$ul=$("<ul/>").appendTo(options.container);
		options.highlightErrors=false;
		if(options.form){
			options.form = typeof options.form != 'string' && options.form.jquery ? options.form : $(options.form);
			options.highlightErrors= options.form[0].tagName=="FORM" || options.form[0].tagName=="form";
			if(options.highlightErrors){
				$("div.form-group.has-error",options.form).removeClass("has-error");
			}
			var afterFireFn=$(options.form).data("onAfterSubmit");
			if(afterFireFn && typeof afterFireFn=="function"){
				afterFireFn(options.form,{});
			}
		}
		$.each(options.errors,function(iError,error){
			$("<li/>").attr("data-field-id",error.field)
			.html(eval("error.defaultMessage.format('"+(error.arguments || []).join("','")+"')"))
			.appendTo($ul);
			if(options.highlightErrors){
				//console.log($("div.control-group:has([name='"+error.field+"'],[name='"+error.field+".id'])",options.form));
				$("div.form-group:has([name='"+error.field+"'],[name='"+error.field+".id'])",options.form).addClass("has-error");
			}
		});
		options.container.alert();
	}
}
/**
	event: the event that fires de remote function, usually is a form element
	jsonResponse: JSON format argument {success:Boolean,errors:Array,message:String}
	
	The function return a bollean value if success is true
*/
function checkJSONResponse(event,jsonResponse,skipHideModal){
	
	//console.log(event);
	//console.log(jsonResponse);
	if(!skipHideModal){
		//console.log("primera");
		loadingModal.hidePleaseWait(function(){
			checkJSONResponse(event,jsonResponse,true);
		});
		return;
	}
	//console.log("segunda");
	//return;
	if(!jsonResponse.success && jsonResponse.errors){
		var container = $("div.alert.alert-danger",$(event.target))
		if(!container.length){
			container = $("<div/>").addClass("alert alert-danger").prependTo($("div.modal-body",$(event.target)).length ? $("div.modal-body",$(event.target)) : $("div.page-header",$(event.target)).length ? $("div.page-header",$(event.target)) : $(event.target));			
		}
		renderErrors({
			container: container,
			form: event.target,
			errors:jsonResponse.errors
		});
		var onHasErrorsFn = $(event.target).data("onHasErrors");
		if(onHasErrorsFn && typeof onHasErrorsFn=="function"){
			//console.log("has error function");
			onHasErrorsFn();
		}
	}else{
		var beforeFireFn=$(event.target).data("onBeforeSubmit");
		var afterFireFn=$(event.target).data("onAfterSubmit");
		var afterSuccessFireFn=$(event.target).data("onAfterSuccessSubmit");
		//console.log("hereee");
		//console.log(beforeFireFn);
		if(beforeFireFn && typeof beforeFireFn=="function"){beforeFireFn(event,jsonResponse);}
		$("#modalMessage .modal-header h3").html(jsonResponse.success?"Sucess!!!":"Error");
		$("#modalMessage .modal-body")
		.html(
			$("<div/>").addClass("alert alert-"+(jsonResponse.success?"success":"danger")).html(jsonResponse.message)
		);
		$("#modalMessage")
		.modal("show")
		.on("hidden.bs.modal",function(){
			if(!jsonResponse.success && afterFireFn && typeof afterFireFn=="function"){
				afterFireFn(event,jsonResponse);
			}else{
				if(jsonResponse.success && afterSuccessFireFn && typeof afterSuccessFireFn=="function"){
					afterSuccessFireFn(event,jsonResponse)
				}else{
					if($("form[role-update]").length){
						$("form[role-update]").submit();
					}else{
						location.reload();
					}
				}
			}
		});
		
	}
	return jsonResponse.success ? true:false
}
// options = {element,selectOptions,dependsOn,dependsOnKey,optionKey,optionValue}
function smartSelect(options){
	if(options && options.element){
		options.element.data("smartSelectOptions",options.selectOptions || []);
		options.element.data("smartOptionKey",options.optionKey);
		options.element.data("smartOptionValue",options.optionValue);
		options.element.data("smartOptionNoSelection",options.optionNoSelection || "Seleccionar");
		options.element.data("smartAjaxURL",options.ajaxURL || false);
		if(options.ajaxURL){
			options.element.data("smartAjaxDataPath",options.ajaxDataPath || false);
		}
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
	var matchValue = element.data("smartDependsOnLastSelectedValue");
	if(element.data("smartAjaxURL")){
		if(!element.data("smartAjaxLoadDone")){
			$.ajax({
				type: "GET",
				url: element.data("smartAjaxURL") + "/"+matchValue+".json",
				data: {},
				dataType: "json",
				success: function(response, textStatus, jqXHR){
					element.data("smartAjaxLoadDone",true);
					//console.log(response);
					if(response){
						if(element.data("smartAjaxDataPath")){
							element.data("smartSelectOptions",response[element.data("smartAjaxDataPath")] || []);
						}else{
							element.data("smartSelectOptions",response || []);
						}
						smartSelectReplaceOptions(element);
					}
				},
				statusCode: {401:ajaxStatus401, 403:ajaxStatus403, 404:ajaxStatus404, 500:ajaxStatus500}
			});
		}
		if(!element.data("smartAjaxLoadDone")){
			return true;
		}
	}
	element.data("smartAjaxLoadDone",false);
	element.html("");
	
	//console.log(element);
	var innerNoSelectionText = element.data("smartOptionNoSelection") || "";
	element.append($("<option/>").val("null").html(innerNoSelectionText));
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
