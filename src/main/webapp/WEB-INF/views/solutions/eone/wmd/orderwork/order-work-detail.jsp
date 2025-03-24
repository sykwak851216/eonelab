<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){
	var params = Dialog.getParams();
	window.OrderWorkModify = (function($){
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
		<h2><s:interpret word='지시별 작업 내역 상세' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="register-table">
				<ul>
					<li>
						<div class="title"><s:interpret word='작업번호' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="workId"></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='지시번호' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="orderId"></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='버퍼번호' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="bufferId"></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='입출유형' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="inOutTypeCd"></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='트레이번호' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="trayId"></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='랙ID' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="rackId"></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='랙셀x축' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="rackCellXAxis"></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='랙셀y축' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="rackCellYAxis"></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='등록일시' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="regDt"></span>
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