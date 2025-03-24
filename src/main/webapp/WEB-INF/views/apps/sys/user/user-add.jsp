<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){
	window.UserManager = (function($){
		var init = function(){
			_setForm();
			_bindEvent();
		}
		, _bindEvent = function(){
			$(".btn-cancel").click(function() {
				Dialog.close();
			});
			$(".btn-add").click(function() {
				_addUser();
			});
			$(".btn-in-table").click(function() {
				_checkDuplication();
			});

			$(".select").click(function() {
				Dialog.open('<c:url value="/apps/sys/userrole/user-role-search.dialog" />',750, null, function(result){
					_displayRole(result);
				});
			});
		}
		, _displayRole = function(result){
			var roleIds = [], roleNames = [];
			if($.isPlainObject( result )){
				result = [result];
			}
			if(Array.isArray(result)){
				result.forEach(function(o){
					roleIds[roleIds.length] = o.roleId;
					roleNames[roleNames.length] = o.roleName;
				});
				$("#roleIds").val(roleIds.join(","));
				$("#roleNames").val(roleNames.join("/ "));
			}
		}
		, _setForm = function(){
			BoxTag.selectBox.draw([
				{
					selector : "#depart",
					firstTxt : "<s:interpret word='부서' abbr='' />",
					masterCd : "department"
				},
				{
					selector : "#position",
					firstTxt : "<s:interpret word='직책' abbr='' />",
					masterCd : "position"
				}
			]);
		}
		, _addUser = function(){
			var $contents = $(".contents-wrap");
			var obj = $contents.find('select, input').serializeObject();
			var roleIds = $("#roleIds").val();
			var param = _makeParam(obj);
			if(!param){
				alert(SfpUtils.getPhrase("msg-060"));
				return;
			}

			if($contents.validate()){
				SfpAjax.ajaxRequestBody("<c:url value='/apps/sys/user/add'/>", param, function(data) {
					alert(SfpUtils.getPhrase("msg-054"));
					Dialog.close(true);
				});
			}
		}
		, _makeParam = function(param){
			if(!$.isPlainObject(param)){
				return false;
			}
			var userId = $("input[name='userId']").val();
			param.userRoleList = [];
			return param;
		}
		, _checkDuplication = function(){
			if(formValidator("input[name='userId']")){
				SfpAjax.ajax("<c:url value='/apps/sys/user/checkDuplication'/>", $(".contents-wrap").find('select, input').serialize(), function(data) {
					if(data === true){
						alert(SfpUtils.getPhrase("msg-063"));
						$(".contents-wrap input[name='userId']").focus().val("");
					}else if(data === false){
						alert(SfpUtils.getPhrase("msg-062"));
					}
				});
			}
		}
		;
		init();
	})(jQuery);
});
</script>
<style></style>
<main>

	<header>
		<h2><s:interpret word='사용자 등록' abbr='' /></h2>
		<label id="menuNo"></label>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="register-table">
				<p class="required"><s:interpret word='필수항목' abbr='' /></p>
				<ul>
					<li>
						<div class="title required"><s:interpret word='사용자 ID' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span><input type="text" name="userId" data-required="true" placeholder="<s:interpret word='사용자 ID' abbr='' />" data-valid-max-size='30'/></span>
								<span class="no-flex"><button class="btn-in-table"><s:interpret word='중복확인' abbr='' /></button></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title required"><s:interpret word='사용자 명' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span><input type="text" name="userName" data-required="true" data-valid-max-size='100' placeholder="<s:interpret word='사용자 명' abbr='' />" data-valid-max-size='30'/></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='사번' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span><input type="text" name="employeeNum" data-valid-max-size="30" placeholder="<s:interpret word='사번' abbr='' />" /></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='휴대전화번호' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span><input type="text" name="cellPhone" data-valid-max-size='13' placeholder="<s:interpret word='휴대전화번호' abbr='' />" /></span>
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
						<div class="title "><s:interpret word='이메일' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span><input type="text" name="email" id="email" placeholder="<s:interpret word='이메일' abbr='' />" data-valid-max-size='100'></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title required"><s:interpret word='비밀번호' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span><input type="password" name="userPw" autocomplete="new-password"  data-required="true" placeholder="<s:interpret word='비밀번호' abbr='' />" ></span>
							</div>
						</div>
					</li>
				</ul>
			</div>
		</section>
		<footer>
			<div class="align-center">
			<button class="btn-cancel"><s:interpret word='닫기' abbr='' /></button><button class="btn-add"><s:interpret word='등록' abbr='' /></button>
			</div>
		</footer>
	</div>
</main>
