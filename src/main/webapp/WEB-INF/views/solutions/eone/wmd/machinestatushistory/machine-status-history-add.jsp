<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){

	window.MachineStatusHistoryAdd = (function($){
		var init = function(){
			_setForm();
			_bindEvent();
		}
		, _bindEvent = function(){
			$(".btn-cancel").click(function() {
				Dialog.cancel();
			});
			$(".btn-add").click(function() {
				_addMachineStatusHistory();
			});
		}
		, _setForm = function(){

		}
		, _addMachineStatusHistory = function(){
			var $contents = $(".contents-wrap");
			if($contents.validate()){
				SfpAjax.ajax("<c:url value='/solutions/eone/wmd/machinestatushistory/add'/>", $contents.find("select, input, textarea").serialize(), function(data) {
					alert("저장에 성공하였습니다.");
					Dialog.close(true);
				});
			}
		};
		init();
	})(jQuery);
});
</script>
<style></style>

<main>
	<header>
		<h2><s:interpret word='설비 상태 이력 등록' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="register-table">
				<p class="required"><s:interpret word='필수항목' abbr='' /></p>
				<ul>
					<li>
						<div class="title"><s:interpret word='이력번호' abbr='' /><em>*</em></div>
						<div class="cont">
							<div class="line-wrap">
								<span><input type="text" name="historySeq" placeholder="<s:interpret word='이력번호' abbr='' />" data-valid-max-size='30' data-required="true"  /></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='설비ID' abbr='' /><em>*</em></div>
						<div class="cont">
							<div class="line-wrap">
								<span><input type="text" name="mcId" placeholder="<s:interpret word='설비ID' abbr='' />" data-valid-max-size='30' data-required="true"  /></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='설비상태코드' abbr='' /><em>*</em></div>
						<div class="cont">
							<div class="line-wrap">
								<span><input type="text" name="mcStatusCd" placeholder="<s:interpret word='설비상태코드' abbr='' />" data-valid-max-size='30' data-required="true"  /></span>
							</div>
						</div>
					</li>
				</ul>
			</div>
		</section>
		<footer>
			<div class="align-center">
				<button class="btn-cancel"><s:interpret word='닫기' abbr='' /></button>
				<button class="btn-add blue"><s:interpret word='등록' abbr='' /></button>
			</div>
		</footer>
	</div>
</main>