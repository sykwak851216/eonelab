<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){
	var params = Dialog.getParams();
	window.TrayLocationChangeHistoryModify = (function($){
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
		<h2><s:interpret word='트레이 위치 변경 이력 상세' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="register-table">
				<ul>
					<li>
						<div class="title"><s:interpret word='이력SEQ' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="historySeq"></span>
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
						<div class="title"><s:interpret word='출발위치유형' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="fromLocTypeCd"></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='도착위치유형' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="toLocTypeCd"></span>
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
						<div class="title"><s:interpret word='렉셀ID' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="rackCellId"></span>
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
						<div class="title"><s:interpret word='랙셀X축' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="rackCellXAxis"></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='랙셀Y축' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="rackCellYAxis"></span>
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
						<div class="title"><s:interpret word='지시그룹ID' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="orderGroupId"></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='변경일시' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="changeDt"></span>
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