<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){
	var params = Dialog.getParams();
	window.OrderModify = (function($){
		var init = function(){
			$(".contents-wrap").setData(params);
			_bindEvent();
		}
		, _bindEvent = function(){
			$(".btn-close").click(function() {
				Dialog.close();
			});
		};
		init();
	})(jQuery);
});
</script>

<main>
	<header>
		<h2><s:interpret word='지시 상세' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="register-table">
				<ul>
					<li>
						<div class="title"><s:interpret word='지시번호' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="orderId"></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='지시유형' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="orderTypeCd"></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='지시일자' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="orderDate"></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='지시트레이수' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="orderTrayQty"></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='처리트레이수' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="workTrayQty"></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='시작일시' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="orderStartDt"></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='완료일시' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="orderEndDt"></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='지시상태' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="orderStatusCd"></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='완료유형' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="orderFinishTypeCd"></span>
							</div>
						</div>
					</li>
				</ul>
			</div>
		</section>
		<footer>
			<div class="align-center">
				<button class="btn-close"><s:interpret word='닫기' abbr='' /></button>
			</div>
		</footer>
	</div>
</main>