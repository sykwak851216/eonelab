<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="com.s3s.sfp.settings.accessor.ServerPropertiesAccessor" %>
<META name="viewport" content="width=1920, height=1080">
<meta charset="UTF-8">
<title><%=ServerPropertiesAccessor.getSiteName()%> <%=ServerPropertiesAccessor.getSiteVersion()%></title>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<link rel="shortcut icon" href="<c:url value='/resources/images/favicon.ico' />">

<link rel="stylesheet" href="<c:url value='/resources/css/button.css' />">
<link rel="stylesheet" href="<c:url value='/resources/css/common.css' />">
<link rel="stylesheet" href="<c:url value='/resources/css/form.css' />">
<link rel="stylesheet" href="<c:url value='/resources/css/grid.css' />">
<link rel="stylesheet" href="<c:url value='/resources/css/sfp/sfp-dialog.css' />">
<link rel="stylesheet" href="<c:url value='/resources/css/sfp/sfp-ui-grid.css' />">

<link rel="stylesheet" href="<c:url value='/resources/css/bower/jquery-flexdatalist/jquery.flexdatalist.min.css' />">
<link rel="stylesheet" href="<c:url value='/resources/css/bower/jquery-timepicker/jquery.ui.timepicker.css' />">

<link rel="stylesheet" href="<c:url value='/resources/css/theme/${applicationScope["sfp.theme"]}/button.css' />">
<link rel="stylesheet" href="<c:url value='/resources/css/theme/${applicationScope["sfp.theme"]}/common.css' />">
<link rel="stylesheet" href="<c:url value='/resources/css/theme/${applicationScope["sfp.theme"]}/form.css' />">
<link rel="stylesheet" href="<c:url value='/resources/css/theme/${applicationScope["sfp.theme"]}/grid.css' />">

<link rel="stylesheet" href="<c:url value='/resources/css/project/button.css' />">
<link rel="stylesheet" href="<c:url value='/resources/css/project/common.css' />">
<link rel="stylesheet" href="<c:url value='/resources/css/project/form.css' />">
<link rel="stylesheet" href="<c:url value='/resources/css/project/grid.css' />">

<script src="<c:url value='/resources/js/bower/jquery/jquery.min.js' />"></script>
<script src="<c:url value='/resources/js/bower/jquery.cookie/jquery.cookie.js' />"></script>
<script src="<c:url value='/resources/js/bower/jquery-ui/jquery-ui.min.js' />"></script>
<script src="<c:url value='/resources/js/bower/moment/moment.min.js' />"></script>
<script src="<c:url value='/resources/js/bower/moment/moment-with-locales.min.js' />"></script>
<script src="<c:url value='/resources/js/bower/jquery-flexdatalist/jquery.flexdatalist.min.js' />"></script>
<script src="<c:url value='/resources/js/bower/sockjs-client/sockjs.min.js' />"></script>
<script src="<c:url value='/resources/js/bower/stompjs/stomp.min.js' />"></script>

<script src="<c:url value='/resources/js/bower/jquery-timepicker/jquery.ui.timepicker.js' />"></script>

<script src="<c:url value='/resources/js/sfp/sfp-utils.js' />"></script>

<script src="<c:url value='/resources/js/sfp/sfp-ajax.js' />"></script>
<script src="<c:url value='/resources/js/sfp/sfp-dialog.js' />"></script>
<script src="<c:url value='/resources/js/sfp/sfp-dialog-sizer.js' />"></script>
<script src="<c:url value='/resources/js/sfp/sfp-ui-template.js' />"></script>
<script src="<c:url value='/resources/js/sfp/sfp-ui-grid.js' />"></script>
<script src="<c:url value='/resources/js/sfp/sfp-ui-box.js' />"></script>
<script src="<c:url value='/resources/js/sfp/sfp-ui-pager.js' />"></script>
<script src="<c:url value='/resources/js/sfp/sfp-datepicker.js' />"></script>
<script src="<c:url value='/resources/js/sfp/sfp-ui-autocomplete.js' />"></script>
<script src="<c:url value='/resources/js/sfp/sfp-ui-oee.barchart.js' />"></script>
<script src="<c:url value='/resources/js/sfp/sfp-dateutils.js' />"></script>
<script src="<c:url value='/resources/js/sfp/sfp-ui-excel.template.js' />"></script>
<script src="<c:url value='/resources/js/sfp/sfp-websocket.js' />"></script>

<script src="<c:url value='/resources/js/phrase.js' />"></script>
<script src="<c:url value='/resources/js/interpreter.js' />"></script>

<script src="<c:url value='/resources/js/project/dialog-sizer.js' />"></script>

<script type="text/javascript">
$(function(){
	SFPURL.setContextUrl("${pageContext.request.contextPath}");
	SFPURL.setMenuUrl();
// 	SFPURL.setMenuUrl($(location).attr('pathname'));

	$(".btn-reset").on("click", function() {
		$(this).closest(".function-area").find("select, input:not([type=hidden])").each(function(){
			var $this = $(this);
			if($this.hasClass("reset-ignore") == false){
				$this.val("");
				$( ".calendar" ).datepicker( "option", { "minDate" : null , "maxDate" : null });
			}
		});
	});

});

function showProgress(){
	var $window = $(window);
	var $loaderPanel = $("#loader-panel");
	var $loader = $("#loader");
	var windowWidth = $window.width();
	var windowHeight = $window.height();
	var loaderWidth = $loader.width();
	var loaderHeight = $loader.height();

	$loaderPanel.css("width", windowWidth).css("height", windowHeight);
	$loader.css("left", (windowWidth/2)-(loaderWidth/2));
	$loader.css("top", (windowHeight/2)-(loaderHeight/2));

	$loaderPanel.fadeIn(100);
// 	$("#loader-panel").show();
}
function closeProgress(){
	var $loaderPanel = $("#loader-panel");
	$loaderPanel.fadeOut(100);
// 	$("#loader-panel").hide();
}

window.sfpAlert = function(msg) {
	alert(msg);
};
</script>
<style>
#loader-panel { position:absolute; top:0; left:0; width:100%; height:100%; z-index:1000; text-align:center; vertical-align:middle; background:#fff; opacity:0.5; display:none;}
#loader { position:absolute; z-index:1001; width:50px; height:50px;}
</style>
<div id="loader-panel">
	<img id="loader" src="<c:url value='/resources/images/progress-bar.gif'/>" alt="">
</div>
