// Generated by CoffeeScript 1.4.0
/* OLD SMP UA判定 coffee暫定 jqMのfixedToolbar.jsより抜粋
*/

var supportBlacklist,
  __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

supportBlacklist = function() {
  var ffmatch, ffversion, omversion, operammobilematch, platform, ua, w, wkmatch, wkversion;
  w = window;
  ua = navigator.userAgent;
  platform = navigator.platform;
  wkmatch = ua.match(/AppleWebKit\/([0-9]+)/);
  wkversion = !!wkmatch && wkmatch[1];
  ffmatch = ua.match(/Fennec\/([0-9]+)/);
  ffversion = !!ffmatch && ffmatch[1];
  operammobilematch = ua.match(/Opera Mobi\/([0-9]+)/);
  omversion = !!operammobilematch && operammobilematch[1];
  if (((platform.indexOf("iPhone") > -1 || platform.indexOf("iPad") > -1 || platform.indexOf("iPod") > -1) && wkversion && wkversion < 534) || (w.operamini && {}.toString.call(w.operamini) === "[object OperaMini]") || (operammobilematch && omversion < 7458) || (ua.indexOf("Android") > -1 && wkversion && wkversion < 533) || (ffversion && ffversion < 6) || (__indexOf.call(window, "palmGetResource") >= 0 && wkversion && wkversion < 534) || (ua.indexOf("MeeGo") > -1 && ua.indexOf("NokiaBrowser/8.5.0") > -1)) {
    return true;
  } else {
    return false;
  }
};

/* jQuery WP All Pages from coffee---------------------------------
*/


/*<![CDATA[
*/


jQuery(function($) {
  var funcTimeout, jMenu, menuTop, plusHei, _this;
  $("body").append("<p id=\"goto-top\"></p>");
  $("#goto-top").hide();
  funcTimeout = function() {
    return $("#goto-top").fadeOut();
  };
  $.timeout = function(time) {
    return $.Deferred(function(dfd) {
      return setTimeout(dfd.resolve, time);
    }).promise();
  };
  $(window).scroll(function() {
    var that;
    that = this;
    if ($(this).scrollTop() > 111) {
      return $("#goto-top").stop(true, true).fadeIn();
    } else {
      return $("#goto-top").fadeOut();
    }
  });
  $("#goto-top").click(function(e) {
    $("body,html").animate({
      scrollTop: 0
    }, 200);
    return e.preventDefault();
  });
  _this = this;
  if (supportBlacklist() === true) {
    jMenu = $("#goto-top");
    menuTop = jMenu.position().top;
    plusHei = $(window).height();
    return $(window).scroll(function() {
      return jMenu.css("top", $(_this).scrollTop() + menuTop + plusHei + "px");
    });
  }
  $.fn.extend({
    swLink: function() {
      var $_that, bkfire, fire, i, nodes, supports3DTransforms, val, _i, _len;
      $_that = $("#secondary a,footer.entry-meta a");
      supports3DTransforms = document.body.style['webkitPerspective'] !== void 0 || document.body.style['MozPerspective'] !== void 0;
      if (supports3DTransforms) {
        nodes = $($_that);
        for (i = _i = 0, _len = nodes.length; _i < _len; i = ++_i) {
          val = nodes[i];
          $(nodes[i]).addClass("roll").wrapInner("<span data-title='" + $(val).text() + "'/>");
        }
        return;
      }
      fire = function(ev) {
        return $($_that).addClass("hover");
      };
      bkfire = function(ev) {
        return $($_that).removeClass("hover");
      };
      return $($_that).on('touchstart', fire).off('touchend', bkfire);
    }
  });
  return $("#main").swLink();
});

/*]]>
*/

