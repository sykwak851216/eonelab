<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){
	window.TrayCurrent = (function($){
		var mcId = Dialog.getParams();
		var init = function(){

			$("#left-grid").grid({
				header:[
					[
						{name : "-", colspan : 3}
					]
					,
					[
						{name : "<s:interpret word='Column' abbr='' />"},
						{name : "<s:interpret word='Rack 번호' abbr='' />"},
						{name : "<s:interpret word='보관일' abbr='' />"},
					]
				]
				, height : "640px"
				, addClasses : "small"
			});

			$("#right-grid").grid({
				header:[
					[
						{name : "-", colspan : 3}
					]
					,
					[
						{name : "<s:interpret word='Column' abbr='' />"},
						{name : "<s:interpret word='Rack 번호' abbr='' />"},
						{name : "<s:interpret word='보관일' abbr='' />"}
					]
				]
				, height : "640px"
				, addClasses : "small"
			});

			_setForm();
			_bindEvent();
			setInterval(list, 2000);
		}
		, _bindEvent = function(){
			$(".btn-close").on("touchend click", function(e){
				Dialog.close();
			});

			$(".btn-gantry").on("touchend click", function(e){
				e.preventDefault();
				$(".btn-gantry").removeClass("on");
				$(this).addClass("on");
				list();
			});

			$("#rackCellYAxis").change(function(e){
				e.preventDefault();
				list();
			})
		}
		, _setForm = function(){
			$("#mcId").val(mcId);
		}
		, list = function(){
			SfpAjax.ajax("<c:url value='/solutions/eone/pop/getCellListByGantry'/>"
				, $(".function-area").find("select, input").serializeObject()
				, function(list) {
					console.dir(list);
					$("#left-grid").grid("draw", list[0].rackCellList, function(row){
					});
					$("#right-grid").grid("draw", list[1].rackCellList, function(row){
				});

				setTimeout(function(){
					$("#left-grid .sfp-grid-header-panel tr:eq(0) th").text(list[0].rackName);
					$("#right-grid .sfp-grid-header-panel tr:eq(0) th").text(list[1].rackName);
				}, 100);

			});
		}
		;
		init();
		return {
			list : list
		}
	})(jQuery);
});
</script>
<style>
.sfp-grid tbody tr.warning td{ background-color: #F5ACAF; }
.grid-title.big{ font-size: 30px; text-align: center;}
button[class*="btn"] { width: 100px; height: 45px; }
button[class*="on"] {
	background-color: #F89406 !important;
	color: #fff;
	border: 0 !important;
}
select, input{ margin-left:2px; height: 45px !important; }
</style>

<main class="pop-view">
	<header>
		<h2><s:interpret word='Shelf 현황' abbr='' /></h2>
	</header>
	<div class="contents-wrap">
		<section>
			<div class="function-area  horizontal">
				<input type="hidden" id="mcId" name="mcId" value=""/>
				<div class="align-left">
					<select name="rackCellYAxis" id="rackCellYAxis">
						<option value="1">1층</option>
						<option value="2">2층</option>
						<option value="3">3층</option>
						<option value="4">4층</option>
						<option value="5">5층</option>
						<option value="6">6층</option>
						<option value="7">7층</option>
						<option value="8">8층</option>
						<option value="9">9층</option>
						<option value="10">10층</option>
						<option value="11">11층</option>
						<option value="12">12층</option>
						<option value="13">13층</option>
						<option value="14">14층</option>
						<option value="15">15층</option>
						<option value="16">16층</option>
					</select>
				</div>
				<div class="align-center">
				</div>
				<div class="align-right">
					<h3 class="grid-title big" id="selectedInfo"></h3>
				</div>
			</div>
			<div class="col-2-wrap mgt20">
				<div id="left-grid"></div>
				<div id="right-grid"></div>
			</div>
		</section>
		<footer>
			<div class="align-center">
				<button class="btn-close"><s:interpret word='닫기' abbr='' /></button>
			</div>
		</footer>
	</div>
</main>
<script type="text/sfp-template" data-model="left-grid">
<tr class="@{expirationDayOver}">
	<td>@{rackCellXAxis}</td>
	<td>@{trayId}</td>
	<td>@{storageDay}</td>
</tr>
</script>
<script type="text/sfp-template" data-model="right-grid">
<tr class="@{expirationDayOver}">
	<td>@{rackCellXAxis}</td>
	<td>@{trayId}</td>
	<td>@{storageDay}</td>
</tr>
</script>
