<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){
	var params = Dialog.getParams();
	window.OrderGroupModify = (function($){
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
		<h2><s:interpret word='지시그룹 상세' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="register-table">
				<ul>
					<li>
						<div class="title"><s:interpret word='지시그룹번호' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="orderGroupId"></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='지시그룹유형' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="orderGroupTypeCd"></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='지시그룹일자' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="orderGroupDate"></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='지시그룹시작일시' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="orderGroupStartDt"></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='지시그룹완료일시' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="orderGroupEndDt"></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='지시그룹상태코드' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="orderGroupStatusCd"></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='지시그룹완료유형' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="orderGroupFinishTypeCd"></span>
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