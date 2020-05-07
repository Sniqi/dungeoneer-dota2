"use strict";

function debug(data) {
	$.Msg(data.msg);
}

(function () {
  GameEvents.Subscribe( "debug_msg", debug );
})();
