<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="s" uri="http://www.studio3s.co.kr/tags"%>
<%@ page import="com.s3s.sfp.settings.accessor.ServerPropertiesAccessor" %>
<script type="text/javascript">
function goHome() {
	location.replace("<c:url value='/'/>");
}
</script>
<header>
	<h1><a href="javascript:goHome()" class="txt-logo"><%=ServerPropertiesAccessor.getSiteName()%><em><%=ServerPropertiesAccessor.getSiteVersion()%></em></a></h1>
	<s:menu topLevel="true" menuType="menu"/>
	<script type="text/javascript">
	$(function(){
		$("ul.menu-ul").on("click", "li", function(e) {
			var $this = $(this).find("a");
			var _url = SFPURL.getUrl($this.data("url"));
			if($this.hasClass("dialog-menu")){
				var url = _url + ".dialog";
				var menuId = $this.data("menuid");
				Dialog.open(url, DialogSizer[menuId], null, function(result){
				});
			}else{
				var locationType = "<%=ServerPropertiesAccessor.getViewMenuLocation((HttpServletRequest)pageContext.getRequest())%>";
				SFPURL.locationHref(_url+"."+locationType);
			}
			e.stopPropagation();
		});
	});
	</script>
	<div class="util-menu">
		<ul>
			<c:if test="${ServerPropertiesAccessor.isAuth()}">
				<script type="text/javascript">
					$(function(){
						$("div.util-menu .user").click(function(){
							Dialog.open('<c:url value="/apps/sys/userprivate/user-private.dialog" />',550);
						});
						$(".logout").on("click",function(){
							if(confirm(SfpUtils.getPhrase("msg-005"))){
								document.getElementById("logoutForm").submit();
							}
						});
					});
				</script>
				<li><a href="#" class="user"><span>사용자 정보</span></a></li>
				<li><a href="#" class="logout"><span>로그아웃</span></a></li>
			</c:if>

		</ul>
	</div>
	<form action="<c:url value="/logout"/>" method="post" id="logoutForm">
	</form>
</header>

