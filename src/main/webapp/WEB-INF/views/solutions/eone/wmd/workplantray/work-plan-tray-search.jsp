<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){

	window.WorkPlanTraySearch = (function($){
		var init = function(){
			$("#work-plan-tray-grid").grid({
				header:[
					[
						{name : "<s:interpret word='계획번호' abbr='' />"},
						{name : "<s:interpret word='트레이번호' abbr='' />"},
						{name : "<s:interpret word='지시유형' abbr='' />"},
						{name : "<s:interpret word='지시순서' abbr='' />"},
						{name : "<s:interpret word='긴급여부' abbr='' />"},
						{name : "<s:interpret word='입고일자' abbr='' />"},
						{name : "<s:interpret word='랙ID' abbr='' />"},
						{name : "<s:interpret word='랙셀x축' abbr='' />"},
						{name : "<s:interpret word='랙셀y축' abbr='' />"},
						{name : "<s:interpret word='실행여부' abbr='' />"},
						{name : "<s:interpret word='트레이상태' abbr='' />"},
						{name : "<s:interpret word='작업' abbr='' />", width : "120px"}
					]
				]
				, addClasses : "small"
				, height : "300px"
			});
			_setForm();
			_bindEvent();
			list();
		}
		, _setForm = function(){

		}
		, _bindEvent = function(){
			$(".btn-srch").click(function() {
				list();
			});
			$("#work-plan-tray-grid").on("click", ".btn-select", function() {
				var data = $("#work-plan-tray-grid").grid("getData", this);
				Dialog.close(data);
			});
			$(".btn-close").click(function() {
				Dialog.cancel();
			});
		}
		, list = function(paging){
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/workplantray/getList'/>",
				$.extend($(".function-area").find("select, input").serializeObject(), { delYn : "N" })
				, function(data) {
					$("#work-plan-tray-grid").grid("draw", data);
			});
		};
		init();
		return {
			list : list
		}
	})(jQuery);
});

</script>
<style></style>

<main>
	<header>
		<h2><s:interpret word='작업 계획 트레이' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="function-area">
				<div class="align-left">
					<span>
						<label class="label-text"><s:interpret word='계획번호' abbr='' /></label>
						<input type="text" name="planNo" placeholder="<s:interpret word='계획번호' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='트레이번호' abbr='' /></label>
						<input type="text" name="trayId" placeholder="<s:interpret word='트레이번호' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='지시유형' abbr='' /></label>
						<input type="text" name="orderTypeCd" placeholder="<s:interpret word='지시유형' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='지시순서' abbr='' /></label>
						<input type="text" name="trayOrderSort" placeholder="<s:interpret word='지시순서' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='긴급여부' abbr='' /></label>
						<input type="text" name="emergencyYn" placeholder="<s:interpret word='긴급여부' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='입고일자' abbr='' /></label>
						<input type="text" name="inputDate" placeholder="<s:interpret word='입고일자' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='랙ID' abbr='' /></label>
						<input type="text" name="rackId" placeholder="<s:interpret word='랙ID' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='랙셀x축' abbr='' /></label>
						<input type="text" name="rackCellXAxis" placeholder="<s:interpret word='랙셀x축' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='랙셀y축' abbr='' /></label>
						<input type="text" name="rackCellYAxis" placeholder="<s:interpret word='랙셀y축' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='실행여부' abbr='' /></label>
						<input type="text" name="excuteYn" placeholder="<s:interpret word='실행여부' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='트레이상태' abbr='' /></label>
						<input type="text" name="trayStatusCd" placeholder="<s:interpret word='트레이상태' abbr='' />">
					</span>
					<button class="btn-srch ico"><s:interpret word='조회' abbr='' /></button>
					<button class="btn-reset image"><s:interpret word='초기화' abbr='' /></button>
				</div>
				<div class="align-center"></div>
				<div class="align-right"></div>
			</div>
			<div id="work-plan-tray-grid"></div>
		</section>
		<footer>
			<div class="align-center">
				<button class="btn-close"><s:interpret word='닫기' abbr='' /></button>
			</div>
		</footer>
	</div>
</main>

<script type="text/sfp-template" data-model="work-plan-tray-grid">
<tr>
	<td>@{planNo}</td>
	<td>@{trayId}</td>
	<td>@{orderTypeCd}</td>
	<td>@{trayOrderSort}</td>
	<td>@{emergencyYn}</td>
	<td>@{inputDate}</td>
	<td>@{rackId}</td>
	<td>@{rackCellXAxis}</td>
	<td>@{rackCellYAxis}</td>
	<td>@{excuteYn}</td>
	<td>@{trayStatusCd}</td>
	<td><button type="button" class="btn-select"><s:interpret word='선택' abbr='' /></button></td>
</tr>
</script>
</body>
</html>