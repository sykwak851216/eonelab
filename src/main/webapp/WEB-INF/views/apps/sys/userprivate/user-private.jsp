<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<style></style>
<script>
$(function(){

	window.UserManager = (function($){
		var init = function(){
			_setForm();
			_list();
			_bindEvent();
		}
		, _bindEvent = function(){
			$(".btn-cancel").click(function() {
				Dialog.close();
			});
			$(".btn-mod").click(function() {
				modifyUser();
			});
		}
		, _setForm = function(){
		}
		, modifyUser = function(){
			var $contents = $(".contents-wrap");
			if($contents.validate()){
				SfpAjax.ajax("<c:url value='/apps/sys/userprivate/modify'/>", $contents.find('select, input').serialize(), function(data) {
// 					if($("input[name='userPw']").val() === '-9999'){
// 						$("input[name='userPw']").val("");
// 					}
					if(!data){
						alert(SfpUtils.getPhrase("msg-065"));
						return;
					}
					alert(SfpUtils.getPhrase("msg-054"));
					Dialog.close(true);
				});
			}
		}, _list = function(){
			SfpAjax.ajax("<c:url value='/apps/sys/userprivate/userPrivate'/>", {}, function(data) {
				data.userPw = "";
				$(".contents-wrap").setData(data);
			});
		}
		init();
	})(jQuery);
});
</script>




<main>
	<header>
		<h2><s:interpret word='개인정보 설정' abbr='' /></h2>
		<label id="menuNo"></label>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="register-table">
				<p class="required"><s:interpret word='필수항목' abbr='' /></p>
				<ul>
					<li>
						<div class="title"><s:interpret word='사용자 ID' abbr='' /><em>*</em></div>
						<div class="cont">
							<div class="line-wrap">
								<span><input type="text" name="userId" id="userId" data-required="true" placeholder="<s:interpret word='사용자 ID' abbr='' />" readonly="readonly"/></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='사용자 명' abbr='' /><em>*</em></div>
						<div class="cont">
							<div class="line-wrap">
								<span><input type="text" name="userName" data-required="true" placeholder="<s:interpret word='사용자 명' abbr='' />" /></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='기존비밀번호' abbr='' /><em>*</em></div>
						<div class="cont">
							<div class="line-wrap">
								<span><input type="password" name="userPw" autocomplete="new-password" data-required="true" placeholder="<s:interpret word='기존비밀번호' abbr='' />" /></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='변경비밀번호' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span><input type="password" name="changeUserPw" autocomplete="new-password" placeholder="<s:interpret word='변경비밀번호' abbr='' />" /></span>
							</div>
						</div>
					</li>
				</ul>
			</div>
		</section>
		<footer><div class="align-center"><button class="btn-cancel"><s:interpret word='닫기' abbr='' /></button><button class="btn-mod blue"><s:interpret word='수정' abbr='' /></button></div></footer>
	</div>
</main>
