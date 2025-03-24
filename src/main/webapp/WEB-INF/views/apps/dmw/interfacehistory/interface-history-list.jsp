<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.studio3s.co.kr/tags" prefix="s" %>
<script>

// if(external && external.getAppData){
// 	alert(1);
// }else{
// 	alert(2);
// }

$(function(){
	window.InterfaceHistoryList = (function($){
		var init = function(){
			$("#interface-history-grid").grid({
				header:[
					[
						{name : "<s:interpret word='명령' abbr='' />"},
						{name : "<s:interpret word='Line번호' abbr='' />"},
						{name : "<s:interpret word='등록일시' abbr='' />"},
						{name : "<s:interpret word='작업' abbr='' />"}
					]
				]
				, addClasses : 'small'
			});
			$(".footer-wrap").pager({"click" : list});
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
// 			$(".btn-reset").click(function() {
// 				$(".function-area select, .function-area input").val("");
// 			});
			$("#interface-history-grid").on("click", ".btn-mod", function() {
				Dialog.open("<c:url value='/apps/dmw/interfacehistory/interface-history-detail.dialog' />",{width: "1200px", heigth : "950px"}, $("#interface-history-grid").grid("getData", this), function(){
					list();
				});
			});
		}
		, list = function(paging){
			var params = $.extend($(".function-area").find("select, input").serializeObject(), paging);
			if(params.recordYmd != null && params.recordYmd != ''){
				params.startDt = params.recordYmd + " 00:00:00";
				params.endDt = params.recordYmd + " 23:59:59";
			}

			SfpAjax.ajax("<c:url value='/apps/dmw/interfacehistory/getInterfaceHistoryPagingList'/>"
				, params
				, function(data) {
					$("#interface-history-grid").grid("draw", data.list, function(row){
						row.delYnTxt = row.delYn == 'Y' ? "<strong>&#10004</<strong>" : '';
						if(Number(row.processSecond) >= 3 && Number(row.processSecond) <= 5){
							row.tdStyle = 'style="color:orange; font-weight: lighter;"';
						}else if(Number(row.processSecond) > 5){
							row.tdStyle = 'style="color:red; font-weight: bold;"';
						}else{
							row.tdStyle = '';
						}
					});
					$(".footer-wrap").pager("setPage", data.paging);
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
		<h2><s:interpret word='PLC 이력' abbr='' /></h2>
	</header>

	<div class="contents-wrap">
		<section>
			<div class="function-area horizontal">
				<div class="align-left">
					<span>
						<label class="label-text"><s:interpret word='명령' abbr='' /></label>
						<select name="interfaceCommand" id="interfaceCommand" class="reset-ignore">
							<option value="order" selected>order</option>
							<option value="gantry">gantry</option>
							<option value="buffer">buffer</option>
						</select>
					</span>

					<span>
						<label class="label-text"><s:interpret word='Line번호' abbr='' /></label>
						<select name="systemId" id="systemId">
							<option value="">Line번호</option>
							<option value="1">1</option>
							<option value="2">2</option>
							<option value="3">3</option>
						</select>
					</span>

					<span>
						<label class="label-text"><s:interpret word='조회일자' abbr='' /></label>
						<input type="text" class="calendar" id="recordYmd" name="recordYmd" placeholder="<s:interpret word='조회일자' abbr='' />" readonly="readonly">
					</span>
					<button class="btn-srch ico"><s:interpret word='조회' abbr='' /></button>
					<button class="btn-reset image"><s:interpret word='초기화' abbr='' /></button>
				</div>
				<div class="align-center"></div>
				<div class="align-right"></div>
			</div>
			<div id="interface-history-grid"></div>
		</section>
		<footer>
			<div class="footer-wrap"></div>
		</footer>
	</div>
</main>

<script type="text/sfp-template" data-model="interface-history-grid">
<tr>
	<td>@{interfaceCommand}</td>
	<td>@{systemId}</td>
	<td>@{regDt}</td>
	<td><button type="button" class="btn-mod"><s:interpret word='상세' abbr='' /></button></td>
</tr>
</script>
