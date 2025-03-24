<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>
$(function(){

	var params = Dialog.getParams();
	window.TrayCurrent = (function($){
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
				, height : "660px"
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
						{name : "<s:interpret word='보관일' abbr='' />"},
					]
				]
				, height : "660px"
				, addClasses : "small"
			});
			_setForm();
			_bindEvent();
			list();
		}
		, _bindEvent = function(){
			$(".btn-srch").on("touchend click", function(e){
				list();
			});
			/*
			$("#rackCellYAxis").change(function(e){
				e.preventDefault();
				list();
			})
			*/
		}
		, _setForm = function(){
			
		}
		, list = function(){
			SfpAjax.ajax("<c:url value='/solutions/eone/pop/getCellListByLineNo'/>", $(".function-area").find("select, input").serializeObject(), function(list) {
				var totalCount = list[0].existCount + list[1].existCount;
				$("#totalCount").text(totalCount);
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
/*
.sfp-grid tbody tr.warning td{ background-color: #F5ACAF; }
*/
.sfp-grid tbody tr.warning td{ background-color: #F5ACAF; }
.col-2-wrap{font-size:0;}
.col-2-wrap > div{display:inline-block;width:50%;box-sizing:border-box;vertical-align:top}
.col-2-wrap > div + div{padding-left:20px}

.function-area {
    padding: 0px 0px 0px 10px;
    margin-bottom: 10px;
}
.mgt20 {
    margin-top: 15px;
}

</style>

<main>
	<header>
		<h2><s:interpret word='현황 - Shelf 현황' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="function-area  horizontal">
				<div class="align-left">
					<span>
						<label class="label-text"><s:interpret word='Line번호' abbr='' /></label>
						<select name="lineNo" id="lineNo">
							<option value="1">1</option>
							<option value="2">2</option>
							<option value="3">3</option>
						</select>
					</span>
					<span>
						<label class="label-text"><s:interpret word='Floor' abbr='' /></label>
						<select name="rackCellYAxis" id="rackCellYAxis">
							<option value="1">1</option>
							<option value="2">2</option>
							<option value="3">3</option>
							<option value="4">4</option>
							<option value="5">5</option>
							<option value="6">6</option>
							<option value="7">7</option>
							<option value="8">8</option>
							<option value="9">9</option>
							<option value="10">10</option>
							<option value="11">11</option>
							<option value="12">12</option>
							<option value="13">13</option>
							<option value="14">14</option>
							<option value="15">15</option>
							<option value="16">16</option>
						</select>
					</span>
					<button class="btn-srch ico"><s:interpret word='조회' abbr='' /></button>
				</div>
				<div class="align-center">
				</div>
				<div class="align-right">
				</div>
			</div>
			<div class="col-2-wrap mgt20">
				<div id="left-grid"></div>
				<div id="right-grid"></div>
			</div>
		</section>
		<footer>
			<div class="align-center">
				총 <span id="totalCount"></span>건
			</div>
		</footer>
	</div>
</main>
<script type="text/sfp-template" data-model="left-grid">
<tr class="@{expirationDayOver}"><td>@{rackCellXAxis}</td><td>@{trayId}</td><td>@{storageDay}</td></tr>
</script>
<script type="text/sfp-template" data-model="right-grid">
<tr class="@{expirationDayOver}"><td>@{rackCellXAxis}</td><td>@{trayId}</td><td>@{storageDay}</td></tr>
</script>
