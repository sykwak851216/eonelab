<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){
	var params = Dialog.getParams();
	window.OrderOperationHistoryModify = (function($){
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
		<h2><s:interpret word='지시별 동작 히스토리 상세' abbr='' /></h2>
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
						<div class="title"><s:interpret word='시스템동작모드ID' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="systemOperationModeId"></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='시스템동작모드단계ID' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="systemOperationModeStepId"></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='시스템동작모드단계순서' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="systemOperationModeStepSort"></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='시작일시' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="operationStartDt"></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='완료일시' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="operationEndDt"></span>
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