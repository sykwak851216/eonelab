window.ContextMenu = (function($) {
	var context = {},
	CurrentMenu = null;
	CurrentTarget = null;
	DefaultOptions = {
		positionType : "target" //  value | event | target, 기본 = event
		, xOfTarget : "right" // left | right, 기본= right
		, yOfTarget : "bottom" // top | bottom, 기본=bottom
		, x : 0 // 기본
		, y : 0 // 기본
		, onClose : function(menu){} // menu = 메뉴자신
	};

	var draw = function(html, e, options){

		// 기존에 발생한 Target과 동일한 Target 이면 - 마우스 오른쪽 버튼 연타로 눌렀을때
		// - 기존 이벤트 중지
		// - 기존 Target 반환
		if( e.currentTarget == CurrentTarget) {
			e.preventDefault();
			e.stopPropagation();
			return CurrentTarget;
		}

		CurrentTarget = e.currentTarget; // Current Target 저장

		if( CurrentMenu != null) {
			CurrentMenu.close();
		}

		options = $.extend({}, DefaultOptions, options);

		var $menu = decorateContextMenuPannel(html);
		var $window = $(window);
		var menuX, menuY;

		var $currentTarget = $(e.currentTarget);

		$menu.appendTo("body"); // appendTo 이후에 width, height 값을 조회할 수 있다.

		calPosition(); // 위치 결정

		$menu.css("left", menuX).css("top", menuY).show();

		e.preventDefault();
		e.stopPropagation();

		$menu.on("click", function(e){
			e.stopPropagation();
		});

		// 윈도우 이벤트 발생시 메뉴 자동 닫기
		$window.on("click contextmenu", function(e){
			closeContextMenu();
		});


		function decorateContextMenuPannel(html) {
			var menuPanelHtml = "<div id='' class='imc-contextmenu-panel' style='position:absolute; display:none'>" + html + "</div>";
			var $menu = $(menuPanelHtml);

			return  $menu;
		};

		//
		function calPosition() {
			var baseX = 0;
			var baseY= 0;

			if(options.positionType == "target") {
				if(options.xOfTarget == "right") baseX = $currentTarget.offset().left + $currentTarget.outerWidth();
				else	baseX = $currentTarget.offset().left;

				if(options.yOfTarget == "bottom") baseY = $currentTarget.offset().top + $currentTarget.outerHeight();
				else baseY = $currentTarget.offset().top;
			} else if (options.positionType == "value") {
				baseX = options.x;
				baseY = options.y;
			} else { // event
				baseX = e.pageX;
				baseY = e.pageY;
			}

			if( baseX + $menu.outerWidth() > $window.width()  ) { // 윈도우의 너비를 넘어 갈때
				if(options.positionType=="target" && options.xOfTarget=="right") {
					menuX = baseX - $menu.outerWidth() - $currentTarget.outerWidth();
				} else {
					menuX = baseX - $menu.outerWidth();
				}
			} else {
				menuX = baseX;
			}

			if( baseY + $menu.outerHeight() > $window.height()  ) { // 윈도우의 높이를 넘어 갈때
				if(options.positionType=="target" && options.yOfTarget == "bottom") {
					menuY = baseY - $menu.outerHeight() - $currentTarget.outerHeight();
				} else {
					menuY = baseY - $menu.outerHeight();
				}

			} else {
				menuY = baseY;
			}
		};

		function closeContextMenu() {
			if(typeof(options.onClose) == "function" ) options.onClose(CurrentMenu);
			CurrentMenu = null;
			CurrentTarget = null;
			$menu.remove();
		};

		return CurrentMenu = new function(){
			this.close = function() {
				closeContextMenu();
			};

		};
	}

	, getContext = function(){
		return CurrentMenu;
	};
	return {
		draw : draw,
		getContext : getContext
	}
})(jQuery);