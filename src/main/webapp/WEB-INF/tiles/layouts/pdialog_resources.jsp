<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="com.s3s.sfp.settings.accessor.ServerPropertiesAccessor" %>
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<link rel="stylesheet" href="<c:url value='/resources/css/sfp/sfp-ui-touch.css' />">
<link rel="stylesheet" href="<c:url value='/resources/css/sfp/sfp-ui-messagebox.css' />">
<link rel="stylesheet" href="<c:url value='/resources/css/dialog_pop.css' />">

<script src="<c:url value='/resources/js/sfp/sfp-ui-messagebox.js' />"></script>
<script src="<c:url value='/resources/js/sfp/sfp-ui-touch.js' />"></script>

<script>
document.addEventListener('touchstart', function(e){
	if(e.touches.length > 1){
		e.preventDefault();
	}
}, {passive:false});

$(document).on("contextmenu dragstart selectstart",function(e){
	return false;
});
window.sfpAlert = function(msg) {
	MessageBox.alarm(msg);
};
</script>