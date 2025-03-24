<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){

	window.OrderAdd = (function($){
		var init = function(){
			_setForm();
			_bindEvent();
		}
		, _bindEvent = function(){
			$(".btn-cancel").click(function() {
				Dialog.cancel();
			});
			$(".btn-add").click(function() {
				_addOrder();
			});
		}
		, _setForm = function(){

		}
		, _addOrder = function(){
			var $contents = $(".contents-wrap");
			if($contents.validate()){
				SfpAjax.ajax("<c:url value='/solutions/eone/wmd/order/add'/>", $contents.find("select, input, textarea").serialize(), function(data) {
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
		<h2><s:interpret word='지시 등록' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="register-table">
				<p class="required"><s:interpret word='필수항목' abbr='' /></p>
				<ul>
					<li>
						<div class="title"><s:interpret word='지시번호' abbr='' /><em>*</em></div>
						<div class="cont">
							<div class="line-wrap">
								<span><input type="text" name="orderId" placeholder="<s:interpret word='지시번호' abbr='' />" data-valid-max-size='30' data-required="true"  /></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='지시유형' abbr='' /><em>*</em></div>
						<div class="cont">
							<div class="line-wrap">
								<span><input type="text" name="orderTypeCd" placeholder="<s:interpret word='지시유형' abbr='' />" data-valid-max-size='30' data-required="true"  /></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='지시일자' abbr='' /><em>*</em></div>
						<div class="cont">
							<div class="line-wrap">
								<span><input type="text" name="orderDate" placeholder="<s:interpret word='지시일자' abbr='' />" data-valid-max-size='10' data-required="true"  /></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='지시트레이수' abbr='' /><em>*</em></div>
						<div class="cont">
							<div class="line-wrap">
								<span><input type="text" name="orderTrayQty" placeholder="<s:interpret word='지시트레이수' abbr='' />" data-valid-min='' data-valid-max='' data-required="true" data-valid="number" /></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='처리트레이수' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span><input type="text" name="workTrayQty" placeholder="<s:interpret word='처리트레이수' abbr='' />" data-valid-min='' data-valid-max=''  data-valid="number" /></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='시작일시' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span><input type="text" name="orderStartDt" placeholder="<s:interpret word='시작일시' abbr='' />" data-valid-max-size='23'   /></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='완료일시' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span><input type="text" name="orderEndDt" placeholder="<s:interpret word='완료일시' abbr='' />" data-valid-max-size='23'   /></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='지시상태' abbr='' /><em>*</em></div>
						<div class="cont">
							<div class="line-wrap">
								<span><input type="text" name="orderStatusCd" placeholder="<s:interpret word='지시상태' abbr='' />" data-valid-max-size='30' data-required="true"  /></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='완료유형' abbr='' /><em>*</em></div>
						<div class="cont">
							<div class="line-wrap">
								<span><input type="text" name="orderFinishTypeCd" placeholder="<s:interpret word='완료유형' abbr='' />" data-valid-max-size='30' data-required="true"  /></span>
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