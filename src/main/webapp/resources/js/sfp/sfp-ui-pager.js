/*
 * SFP 의 장비 가동상태바 를 도시하기 위한 플러그인
 * by MHD
 */
$.widget( "sfp.pager", {
	// default options
	options: {
		"prevTxt" : "이전"
		, "nextTxt" : "다음"
		, "paging" :{
			"number" : 0
			, "size" : 20
			, "countPerPages" : 5
			, "totalElements" : 0
			, "totalPages" : 0
		}
		, click : null
		, btnSearch : null
	},
	_create: function() {
		this.prev = $("<a href='#' class='prev'>", this.options.prevTxt, "</a>");
		this.next = $("<a href='#' class='next'>", this.options.nextTxt, "</a>");
		this.total = $("<div class=\"footer-title\">Total <strong>-</strong></div>");
		this.paging = $("<div class=\"paging-wrap\">");

		this.element.append(this.total).append(this.paging).on("click", ".paging-wrap a:not([disabled='disabled'])", $.proxy(function(e){
				if($.isFunction(this.options.click)){
					var number = parseInt(this.paging.find("a.on").not(".prev, .next").text()) -1;
					var $this = $(e.target);
					if($this.hasClass("prev")){
						number = ~~((number-2) / this.options.paging.countPerPages) * this.options.paging.countPerPages;
					}else if($this.hasClass("next")){
						number = ~~(number / this.options.paging.countPerPages) * this.options.paging.countPerPages + this.options.paging.countPerPages;
					}else{
						number = parseInt($this.text())-1;
					}
					this.options.click.call(this, {
						"number" : number
						, "size" : this.options.paging.size
					});
				}
			}, this));
		if(this.options.btnSearch != null){
			$(this.options.btnSearch).on("touchend click", $.proxy(function(e){
				this._onClick();
			}, this));
		}
		this._onClick();
	},
	_onClick : function(){
		if($.isFunction(this.options.click)){
			this.options.click.call(this, this.options.paging);
		}
	},

	setPage : function(paging){
		var pageTag = [];
		var paging = $.extend({}, this.options.paging, paging)
		var last = ~~(paging.number / paging.countPerPages) * paging.countPerPages + paging.countPerPages;

		paging.totalPages <= last && (last = paging.totalPages);

		for(var i = ~~(paging.number / paging.countPerPages) * paging.countPerPages
				, len = last ; i < len ; i++){
			pageTag.push(paging.number == i ? "<a href='#' class='on'>" : "<a href='#'>", i+1, "</a>");
		}
		paging.number < paging.countPerPages ? this.prev.attr( "disabled", "disabled" ) : this.prev.removeAttr( "disabled" );
		paging.totalPages == last ? this.next.attr( "disabled", "disabled" ) : this.next.removeAttr( "disabled" );
		this.paging.empty().append(this.prev).append(pageTag.join("")).append(this.next);
		this.total.find("strong").text(SfpUtils.numberWithCommas(paging.totalElements));
	},

	_refresh: function() {
	},

	redraw : function(){
	},
	_destroy: function() {
		this.element.empty();
	},

	_setOptions: function() {
		this._superApply( arguments );
		this._refresh();
	},

	_setOption: function( key, value ) {
		this._super( key, value );
	}
});