<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){
	var params = Dialog.getParams();
	window.WorkPlanTrayModify = (function($){
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
		<h2><s:interpret word='작업 계획 트레이 상세' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="register-table">
				<ul>
					<li>
						<div class="title"><s:interpret word='계획번호' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="planNo"></span>
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
						<div class="title"><s:interpret word='지시유형' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="orderTypeCd"></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='지시순서' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="trayOrderSort"></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='긴급여부' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="emergencyYn"></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='입고일자' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="inputDate"></span>
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
						<div class="title"><s:interpret word='실행여부' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="excuteYn"></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='트레이상태' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="trayStatusCd"></span>
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
					<li>
						<div class="title"><s:interpret word='수정일시' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="modDt"></span>
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