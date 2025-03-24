<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>

<script>
$(function(){
	var params = Dialog.getParams();

	if(params.requestData == null || params.requestData == 'null'){
		params.requestData = '';
	}

	if(params.responseData == null || params.responseData == 'null'){
		params.responseData = '';
	}

	window.InterfaceHistoryModify = (function($){
		var init = function(){
			$(".contents-wrap").setData(params);
			if(Number(params.processSecond) >= 10){
				$('input[name="processTime"]').css("color","red");
			}
			_setForm();
			_bindEvent();
		}
		, _bindEvent = function(){
			$(".btn-cancel").click(function() {
				Dialog.cancel();
			});
		}
		, _setForm = function(){
		};
		init();
	})(jQuery);
});

</script>

<main>
	<header>
		<h2><s:interpret word='PLC 이력 상세' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="register-table">
				<ul>
					<li class="vertical">
						<div class="title"><s:interpret word='인터페이스명령' abbr='' /></div>
						<div class="title"><s:interpret word='Line' abbr='' /></div>
						<div class="title"><s:interpret word='등록일시' abbr='' /></div>
					</li>
					<li class="vertical">
						<div class="cont">
							<div class="line-wrap">
								<span><input type="text" name="interfaceCommand" placeholder="<s:interpret word='인터페이스명령' abbr='' />" readonly="readonly" /></span>
							</div>
						</div>
						<div class="cont">
							<div class="line-wrap">
								<span><input type="text" name="systemId" placeholder="<s:interpret word='Line' abbr='' />" readonly="readonly" /></span>
							</div>
						</div>
						<div class="cont">
							<div class="line-wrap">
								<span><input type="text" name="regDt" placeholder="<s:interpret word='등록일시' abbr='' />" readonly="readonly" /></span>
							</div>
						</div>
					</li>
				</ul>
				<ul style="margin-top:15px;">
					<li class="vertical">
						<div class="title"><s:interpret word='요청데이터' abbr='' /></div>
					</li>
					<li class="vertical">
						<div class="cont">
							<div class="line-wrap">
								<span><textarea name="responseData" id="responseData" style="height:600px;" readonly="readonly"></textarea></span>
							</div>
						</div>
					</li>
				</ul>
			</div>
		</section>
		<footer>
			<div class="align-center">
				<button class="btn-cancel"><s:interpret word='닫기' abbr='' /></button>
			</div>
		</footer>
	</div>
</main>