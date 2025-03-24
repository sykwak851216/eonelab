<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){
	var params = Dialog.getParams();
	window.SystemOperationModeStepModify = (function($){
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
		<h2><s:interpret word='시스템 동작 모드 단계 상세' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="register-table">
				<ul>
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
						<div class="title"><s:interpret word='시스템동작모드단계명' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="systemOperationModeStepName"></span>
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
						<div class="title"><s:interpret word='시스템동작모드단계설명' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="systemOperationModeStepDesc"></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='병행처리여부' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="parallelProcessYn"></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='삭제여부' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="delYn"></span>
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
						<div class="title"><s:interpret word='등록자' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="regId"></span>
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
					<li>
						<div class="title"><s:interpret word='수정자' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span id="modId"></span>
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