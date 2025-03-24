<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){

	window.SystemSetting = (function($){
		var lineNo = Dialog.getParams();
		var init = function(){
			_setForm();
			_bindEvent();
			list();
		}
		, _bindEvent = function(){
			$(".btn-close").on("touchend click", function(e){
				Dialog.close();
			});
			$(".btn-save").on("touchend click", function(e){
				e.preventDefault();
				_saveData();
			});
		}
		, _setForm = function(){
		}
		, _saveData = function(){
			var $contents = $(".contents-wrap");
			if($contents.validate()){
				var jArray = new Array();
				jArray.push({ crudMode : 'U', variableId : $("#variableId0").val(), variableValue : $("#maxExpirationDay").val() });
				SfpAjax.ajax("<c:url value='/apps/sys/variable/saveList'/>", jArray, function(data) {
					MessageBox.message(SfpUtils.getPhrase("msg-054"), { isAutoHide : true });
					Dialog.close();
				});
			}
		}
		, list = function(){
			var mParam = { variableGroupCd : 'system_setting_line'+lineNo, delYn : 'N' }
			SfpAjax.ajax("<c:url value='/apps/sys/variable/getList'/>", mParam, function(list) {
				console.log("list", list);
				for(var i = 0, len= list.length; i < len ; i++){
					var _data = list[i];
					$("#variableId"+i).val(_data.variableId);
					if(_data.variableCd === 'max_expiration_day'){
						$("#maxExpirationDay").val(_data.variableValue);
					}
				}
			});
		};
		init();
		return {
			list : list
		}
	})(jQuery);
});
</script>
<style>
.round-box{ width: 80px; height: 40px; line-height: 40px; border-radius: 10px; background-color: gray; text-align: center; color: #fff; cursor: pointer; }
.round-box:nth-of-type(2){ margin-left: 20px; }
.round-box.y.on{ background-color: #016936; }
.round-box.n.on{ background-color: #B03060; }
</style>
<main class="pop-view">
	<header>
		<h2><s:interpret word='설정' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="register-table big">
				<ul>
					<li>
						<input type="hidden" name="variableId0" id="variableId0" />
						<div class="title"><s:interpret word='최대 보관일' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span><input type="text" name="maxExpirationDay" id="maxExpirationDay" placeholder="<s:interpret word='최대 보관일' abbr='' />" data-valid='number' data-valid-min="1" data-required="true" /></span>
								<span class="no-flex">일</span>
							</div>
						</div>
					</li>
				</ul>
			</div>
		</section>
		<footer>
			<div class="align-center">
				<button class="btn-close"><s:interpret word='닫기' abbr='' /></button>
				<button class="btn-save blue"><s:interpret word='저장' abbr='' /></button>
			</div>
		</footer>
	</div>
</main>