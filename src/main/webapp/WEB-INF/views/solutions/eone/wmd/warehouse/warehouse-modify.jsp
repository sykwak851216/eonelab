<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){
	var params = Dialog.getParams();
	window.WarehouseModify = (function($){
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
				_modifyWarehouse();
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
		, _modifyWarehouse = function(){
			var $contents = $(".contents-wrap");
			if($contents.validate()){
				SfpAjax.ajax("<c:url value='/solutions/eone/wmd/warehouse/modify'/>", $contents.find("select, input, textarea").serialize(), function(data) {
					alert(SfpUtils.getPhrase("msg-054"));
					Dialog.close(true);
				});
			}
		}
		, _deleteWarehouse = function(){
			if(confirm(SfpUtils.getPhrase("msg-003")) == true){
				SfpAjax.ajax("<c:url value='/solutions/eone/wmd/warehouse/delete'/>", $(".contents-wrap").find("select, input, textarea").serialize(), function(data) {
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
		<h2><s:interpret word='창고 수정' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="register-table">
				<p class="required"><s:interpret word='필수항목' abbr='' /></p>
				<ul>
					<li>
						<div class="title"><s:interpret word='창고ID' abbr='' /><em>*</em></div>
						<div class="cont">
							<div class="line-wrap">
								<span><input type="text" name="warehouseId" placeholder="<s:interpret word='창고ID' abbr='' />" data-valid-max-size='30' data-required="true"  /></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='창고명' abbr='' /><em>*</em></div>
						<div class="cont">
							<div class="line-wrap">
								<span><input type="text" name="warehouseName" placeholder="<s:interpret word='창고명' abbr='' />" data-valid-max-size='10' data-required="true"  /></span>
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