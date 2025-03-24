<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){
	var params = Dialog.getParams();
	window.SystemOperationModeModify = (function($){
		var init = function(){
			_setForm();
			_bindEvent();
			$(".contents-wrap").setData(params);
		}
		, _bindEvent = function(){
			$(".btn-cancel").click(function() {
				Dialog.cancel();
			});
			$(".btn-mod").click(function() {
				_modifySystemOperationMode();
			});
		}
		, _setForm = function(){
			BoxTag.selectBox.draw([
				{
					selector : "#delYn",
					firstTxt : "<s:interpret word='삭제여부' abbr='' />",
					masterCd : "del_yn",
					selectedValue : params.delYn
				}
			]);
		}
		, _modifySystemOperationMode = function(){
			var $contents = $(".contents-wrap");
			if($contents.validate()){
				SfpAjax.ajax("<c:url value='/solutions/eone/wmd/systemoperationmode/modify'/>", $contents.find("select, input, textarea").serialize(), function(data) {
					alert(SfpUtils.getPhrase("msg-054"));
					Dialog.close(true);
				});
			}
		}
		, _deleteSystemOperationMode = function(){
			if(confirm(SfpUtils.getPhrase("msg-003")) == true){
				SfpAjax.ajax("<c:url value='/solutions/eone/wmd/systemoperationmode/delete'/>", $(".contents-wrap").find("select, input, textarea").serialize(), function(data) {
					alert(SfpUtils.getPhrase("msg-055"));
					Dialog.close();
				});
			}
		};
		init();
	})(jQuery);
});
</script>

<main>
	<header>
		<h2><s:interpret word='시스템 동작 모드 수정' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="register-table">
				<p class="required"><s:interpret word='필수항목' abbr='' /></p>
				<ul>
					<li>
						<div class="title"><s:interpret word='시스템동작모드ID' abbr='' /><em>*</em></div>
						<div class="cont">
							<div class="line-wrap">
								<span><input type="text" name="systemOperationModeId" placeholder="<s:interpret word='시스템동작모드ID' abbr='' />" data-valid-max-size='30' data-required="true"  /></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='시스템동작모드명' abbr='' /><em>*</em></div>
						<div class="cont">
							<div class="line-wrap">
								<span><input type="text" name="systemOperationModeName" placeholder="<s:interpret word='시스템동작모드명' abbr='' />" data-valid-max-size='100' data-required="true"  /></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='시스템동작모드설명' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span><input type="text" name="systemOperationModeDesc" placeholder="<s:interpret word='시스템동작모드설명' abbr='' />" data-valid-max-size='4000'   /></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='상태' abbr='*' /><em>*</em></div>
						<div class="cont">
							<div class="line-wrap">
								<select id="delYn" name="delYn"></select>
							</div>
						</div>
					</li>
				</ul>
			</div>
		</section>
		<footer>
			<div class="align-center">
				<button class="btn-cancel"><s:interpret word='닫기' abbr='' /></button>
				<button class="btn-del red"><s:interpret word='삭제' abbr='' /></button>
				<button class="btn-mod blue"><s:interpret word='수정' abbr='' /></button>
			</div>
		</footer>
	</div>
</main>