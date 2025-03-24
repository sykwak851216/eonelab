<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){

	window.TrayLocationChangeHistoryAdd = (function($){
		var init = function(){
			_setForm();
			_bindEvent();
		}
		, _bindEvent = function(){
			$(".btn-cancel").click(function() {
				Dialog.cancel();
			});
			$(".btn-add").click(function() {
				_addTrayLocationChangeHistory();
			});
		}
		, _setForm = function(){

		}
		, _addTrayLocationChangeHistory = function(){
			var $contents = $(".contents-wrap");
			if($contents.validate()){
				SfpAjax.ajax("<c:url value='/solutions/eone/wmd/traylocationchangehistory/add'/>", $contents.find("select, input, textarea").serialize(), function(data) {
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
		<h2><s:interpret word='트레이 위치 변경 이력 등록' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="register-table">
				<p class="required"><s:interpret word='필수항목' abbr='' /></p>
				<ul>
					<li>
						<div class="title"><s:interpret word='이력SEQ' abbr='' /><em>*</em></div>
						<div class="cont">
							<div class="line-wrap">
								<span><input type="text" name="historySeq" placeholder="<s:interpret word='이력SEQ' abbr='' />" data-valid-max-size='30' data-required="true"  /></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='트레이번호' abbr='' /><em>*</em></div>
						<div class="cont">
							<div class="line-wrap">
								<span><input type="text" name="trayId" placeholder="<s:interpret word='트레이번호' abbr='' />" data-valid-max-size='100' data-required="true"  /></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='출발위치유형' abbr='' /><em>*</em></div>
						<div class="cont">
							<div class="line-wrap">
								<span><input type="text" name="fromLocTypeCd" placeholder="<s:interpret word='출발위치유형' abbr='' />" data-valid-max-size='30' data-required="true"  /></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='도착위치유형' abbr='' /><em>*</em></div>
						<div class="cont">
							<div class="line-wrap">
								<span><input type="text" name="toLocTypeCd" placeholder="<s:interpret word='도착위치유형' abbr='' />" data-valid-max-size='30' data-required="true"  /></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='버퍼번호' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span><input type="text" name="bufferId" placeholder="<s:interpret word='버퍼번호' abbr='' />" data-valid-max-size='30'   /></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='렉셀ID' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span><input type="text" name="rackCellId" placeholder="<s:interpret word='렉셀ID' abbr='' />" data-valid-max-size='30'   /></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='랙ID' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span><input type="text" name="rackId" placeholder="<s:interpret word='랙ID' abbr='' />" data-valid-max-size='30'   /></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='랙셀X축' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span><input type="text" name="rackCellXAxis" placeholder="<s:interpret word='랙셀X축' abbr='' />" data-valid-min='' data-valid-max=''  data-valid="number" /></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='랙셀Y축' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span><input type="text" name="rackCellYAxis" placeholder="<s:interpret word='랙셀Y축' abbr='' />" data-valid-min='' data-valid-max=''  data-valid="number" /></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='지시번호' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span><input type="text" name="orderId" placeholder="<s:interpret word='지시번호' abbr='' />" data-valid-max-size='30'   /></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='지시그룹ID' abbr='' /></div>
						<div class="cont">
							<div class="line-wrap">
								<span><input type="text" name="orderGroupId" placeholder="<s:interpret word='지시그룹ID' abbr='' />" data-valid-max-size='30'   /></span>
							</div>
						</div>
					</li>
					<li>
						<div class="title"><s:interpret word='변경일시' abbr='' /><em>*</em></div>
						<div class="cont">
							<div class="line-wrap">
								<span><input type="text" name="changeDt" placeholder="<s:interpret word='변경일시' abbr='' />" data-valid-max-size='23' data-required="true"  /></span>
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