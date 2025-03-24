<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<style></style>
<script>
$(function(){

	var params = Dialog.getParams();
	window.UserManager = (function($){
		var _init = function(){
			params.userPw = "-9999";

			$(".contents-wrap").setData(params);
			_setForm();
			_bindEvent();
		}
		, _bindEvent = function(){
			$(".btn-close").click(function() {
				Dialog.close();
			});
			$(".btn-del").click(function() {
				_deleteUser();
			});
			$(".btn-mod").click(function() {
				_modifyUser();
			});
		}
		, _setForm = function(){
			BoxTag.selectBox.draw([
				{
					selector : "#depart",
					firstTxt : "<s:interpret word='부서' abbr='' />",
					masterCd : "department",
					selectedValue : params.depart

				},
				{
					selector : "#position",
					firstTxt : "<s:interpret word='직책' abbr='' />",
					masterCd : "position",
					selectedValue : params.position
				},
				{
					selector : "#delYn",
					firstTxt : "<s:interpret word='삭제여부' abbr='' />",
					masterCd : "del_yn",
					selectedValue : params.delYn
				}
			]);
		}
		, _modifyUser = function(){
			var $contents = $(".contents-wrap");
			var obj = $contents.find('select, input').serializeObject();
			var roleIds = $("#roleIds").val();
			var param = _makeParam(obj);
			if(!param){
				alert(SfpUtils.getPhrase("msg-060"));
				return;
			}

			if($contents.validate()){
				if($("input[name='userPw']").val() === '-9999'){
					$("input[name='userPw']").val("");
				}
				SfpAjax.ajaxRequestBody("<c:url value='/apps/sys/user/modify'/>", param, function(data) {
					alert(SfpUtils.getPhrase("msg-054"));
					Dialog.close(true);
				});
			}
		}
		, _deleteUser = function(){
			if(confirm(SfpUtils.getPhrase("msg-003")) == true){
				SfpAjax.ajax("<c:url value='/apps/sys/user/delete'/>", $(".contents-wrap").find("select, input, textarea").serialize(), function(data) {
					alert(SfpUtils.getPhrase("msg-055"));
					Dialog.close();
				});
			}
		}
		, _makeParam = function(param){
			if(!$.isPlainObject(param)){
				return false;
			}
			var userId = $("input[name='userId']").val();
			param.userRoleList = [];

			if(param.userPw === '-9999'){
				param.userPw = null;
			}
			return param;
		};
		_init();
	})(jQuery);
});
</script>
<main>

	<header>
		<h2><s:interpret word='사용자 수정' abbr='' /></h2>
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
								<span><input type="text" name="userId" data-required="true" placeholder="<s:interpret word='사용자 ID' abbr='' />" data-valid-max-size='30'></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='사용자 명' abbr='' /><em>*</em></div>
						<div class="cont">
							<div class="line-wrap">
								<span><input type="text" name="userName" data-required="true" placeholder="<s:interpret word='사용자 명' abbr='' />" data-valid-max-size='100'/></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='사번' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span><input type="text" name="employeeNum" placeholder="<s:interpret word='사번' abbr='' />" data-valid-max-size='30'/></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='휴대전화번호' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span><input type="text" name="cellPhone" placeholder="<s:interpret word='휴대전화번호' abbr='' />" data-valid-max-size='13'/></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='직급' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<select id="position" name="position"> </select>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='부서' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<select id="depart" name="depart"> </select>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='이메일' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span><input type="text" name="email" id="email"  placeholder="<s:interpret word='이메일' abbr='' />" data-valid-max-size='100'/></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='비밀번호' abbr='' /><em>*</em></div>
						<div class="cont">
							<div class="line-wrap">
								<span><input type="password" name="userPw" autocomplete="new-password" data-required="true" placeholder="<s:interpret word='비밀번호' abbr='' />" /></span>
							</div>
						</div>
					</li>
				</ul>
			</div>
		</section>
		<footer>
			<div class="align-center">
					<button class="btn-close"><s:interpret word='닫기' abbr='' /></button>
					<button class="btn-del red"><s:interpret word='삭제' abbr='' /></button>
					<button class="btn-mod blue"><s:interpret word='수정' abbr='' /></button>
			</div>
		</footer>
	</div>
</main>
