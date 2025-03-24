<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){

	window.TrayLocationSearch = (function($){
		var init = function(){
			$("#tray-location-grid").grid({
				header:[
					[
						{name : "<s:interpret word='트레이번호' abbr='' />"},
						{name : "<s:interpret word='입고일자' abbr='' />"},
						{name : "<s:interpret word='위치유형' abbr='' />"},
						{name : "<s:interpret word='버퍼번호' abbr='' />"},
						{name : "<s:interpret word='랙셀ID' abbr='' />"},
						{name : "<s:interpret word='랙ID' abbr='' />"},
						{name : "<s:interpret word='렉셀X축' abbr='' />"},
						{name : "<s:interpret word='렉셀Y축' abbr='' />"},
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
			$("#tray-location-grid").on("click", ".btn-select", function() {
				var data = $("#tray-location-grid").grid("getData", this);
				Dialog.close(data);
			});
			$(".btn-close").click(function() {
				Dialog.cancel();
			});
		}
		, list = function(paging){
			SfpAjax.ajax("<c:url value='/solutions/eone/wmd/traylocation/getList'/>",
				$.extend($(".function-area").find("select, input").serializeObject(), { delYn : "N" })
				, function(data) {
					$("#tray-location-grid").grid("draw", data);
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
		<h2><s:interpret word='트레이 위치' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="function-area">
				<div class="align-left">
					<span>
						<label class="label-text"><s:interpret word='트레이번호' abbr='' /></label>
						<input type="text" name="trayId" placeholder="<s:interpret word='트레이번호' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='입고일자' abbr='' /></label>
						<input type="text" name="inputDate" placeholder="<s:interpret word='입고일자' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='위치유형' abbr='' /></label>
						<input type="text" name="locTypeCd" placeholder="<s:interpret word='위치유형' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='버퍼번호' abbr='' /></label>
						<input type="text" name="bufferId" placeholder="<s:interpret word='버퍼번호' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='랙셀ID' abbr='' /></label>
						<input type="text" name="rackCellId" placeholder="<s:interpret word='랙셀ID' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='랙ID' abbr='' /></label>
						<input type="text" name="rackId" placeholder="<s:interpret word='랙ID' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='렉셀X축' abbr='' /></label>
						<input type="text" name="rackCellXAxis" placeholder="<s:interpret word='렉셀X축' abbr='' />">
					</span>
					<span>
						<label class="label-text"><s:interpret word='렉셀Y축' abbr='' /></label>
						<input type="text" name="rackCellYAxis" placeholder="<s:interpret word='렉셀Y축' abbr='' />">
					</span>
					<button class="btn-srch ico"><s:interpret word='조회' abbr='' /></button>
					<button class="btn-reset image"><s:interpret word='초기화' abbr='' /></button>
				</div>
				<div class="align-center"></div>
				<div class="align-right"></div>
			</div>
			<div id="tray-location-grid"></div>
		</section>
		<footer>
			<div class="align-center">
				<button class="btn-close"><s:interpret word='닫기' abbr='' /></button>
			</div>
		</footer>
	</div>
</main>

<script type="text/sfp-template" data-model="tray-location-grid">
<tr>
	<td>@{trayId}</td>
	<td>@{inputDate}</td>
	<td>@{locTypeCd}</td>
	<td>@{bufferId}</td>
	<td>@{rackCellId}</td>
	<td>@{rackId}</td>
	<td>@{rackCellXAxis}</td>
	<td>@{rackCellYAxis}</td>
	<td><button type="button" class="btn-select"><s:interpret word='선택' abbr='' /></button></td>
</tr>
</script>
</body>
</html>