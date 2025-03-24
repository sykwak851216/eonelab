<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="com.s3s.sfp.settings.accessor.ServerPropertiesAccessor" %>

<link rel="stylesheet" href="<c:url value='/resources/css/dialog.css' />">
<link rel="stylesheet" href="<c:url value='/resources/css/project/dialog.css' />">
<link rel="stylesheet" href="<c:url value='/resources/css/theme/${applicationScope["sfp.theme"]}/dialog.css' />">
<script>
window.sfpAlert = function(msg) {
	alert(msg);
};
</script>