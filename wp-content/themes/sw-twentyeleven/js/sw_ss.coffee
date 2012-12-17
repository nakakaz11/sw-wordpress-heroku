# Samuraieorks JS (baseSW)
# js2coffee sw_ss.js > sw_ss.coffee
# coffee -wcb *.coffee

### OLD SMP UA判定 coffee暫定 jqMのfixedToolbar.jsより抜粋 ###
supportBlacklist = ->
  w = window
  ua = navigator.userAgent
  platform = navigator.platform
  # Rendering engine is Webkit, and capture major version
  wkmatch = ua.match( /AppleWebKit\/([0-9]+)/ )
  wkversion = !!wkmatch && wkmatch[ 1 ]
  ffmatch = ua.match( /Fennec\/([0-9]+)/ )
  ffversion = !!ffmatch && ffmatch[ 1 ]
  operammobilematch = ua.match( /Opera Mobi\/([0-9]+)/ )
  omversion = !!operammobilematch && operammobilematch[ 1 ]

  # iOS 4.3 and older : Platform is iPhone/Pad/Touch and Webkit version is less than 534 (ios5)
  if ( ( platform.indexOf( "iPhone" ) > -1 || platform.indexOf( "iPad" ) > -1  || platform.indexOf( "iPod" ) > -1 ) && wkversion && wkversion < 534 ) or
  # Opera Mini
  ( w.operamini && ({}).toString.call( w.operamini ) is "[object OperaMini]" ) or
  ( operammobilematch && omversion < 7458 ) or
  #Android lte 2.1: Platform is Android and Webkit version is less than 533 (Android 2.2)
  ( ua.indexOf( "Android" ) > -1 && wkversion && wkversion < 533 ) or
  # Firefox Mobile before 6.0 -
  ( ffversion && ffversion < 6 ) or
  # WebOS less than 3
  ( "palmGetResource" in window && wkversion && wkversion < 534 ) or
  # MeeGo
  ( ua.indexOf( "MeeGo" ) > -1 && ua.indexOf( "NokiaBrowser/8.5.0" ) > -1 )
    return true
  else
    return false

#console.log supportBlacklist()

### jQuery WP All Pages from coffee--------------------------------- ###
# 各ページDRF読み込み用
###<![CDATA[###
jQuery ($) ->


  # GoToTop by http://hijiriworld.com/web/goto-top-link/
  $("body").append "<p id=\"goto-top\"></p>"
  $("#goto-top").hide()
  
  #少したったら消したいから。
  funcTimeout = ->
    $("#goto-top").fadeOut()

  $.timeout = (time) ->
    $.Deferred((dfd) ->
      setTimeout dfd.resolve, time
    ).promise()

  $(window).scroll ->
    that = this
    if $(this).scrollTop() > 111
      $("#goto-top").stop(true, true).fadeIn()
    else
      $("#goto-top").fadeOut()

  $("#goto-top").click (e) ->
    $("body,html").animate
      scrollTop: 0
    , 200
    e.preventDefault()

  # Fixed Position for OLD SMP
  _this = this
  if supportBlacklist() is true
    jMenu = $("#goto-top")
    menuTop = jMenu.position().top
    plusHei = $(window).height()
    return $(window).scroll(->
      jMenu.css "top", $(_this).scrollTop() + menuTop + plusHei + "px"
    )
  
  # supports3DTransforms
  $.fn.extend
    swLink : () ->
      $_that = $("#secondary a,footer.entry-meta a")
      supports3DTransforms =  document.body.style['webkitPerspective'] isnt undefined or
                              document.body.style['MozPerspective'] isnt undefined #サポート判定
      if( supports3DTransforms )
            nodes = $($_that)
            for val,i in nodes
              #console.info $(val).text()
              $(nodes[i]).addClass("roll")
                         .wrapInner( "<span data-title='"+$(val).text()+"'/>" )
                         #.wrapInner( "<span data-title='"+val.innerHTML+"'/>" )
            return
      fire = (ev) ->
        $($_that).addClass("hover")
      bkfire = (ev) ->
        $($_that).removeClass("hover")
      $($_that).on('touchstart',fire)
               .off('touchend', bkfire)

  # supports3DTransforms
  $("#main").swLink()


###]]>###

# coffee -wcb *.coffee
