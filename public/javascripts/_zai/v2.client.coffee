# coffee -wcb *.coffee  # js2coffee v2.client.js > v2.client.coffee
jQuery ($) ->
  "use strict"
  _socket = io.connect()
  _userMap = {}
  _bulletMap = {}
  _ddMap = {}
  _canvasMap = {}
  # canvs add -------------------------#
  canvasHtml = (uid) -> "<div id='user-coord#{uid}'>UserCanvas (ID) #{uid}</div><canvas id='user-canvas#{uid}' class='user-canvas' width='200' height='200'></canvas>"
  mousedown = false
  canvas = document.getElementById("my-canvas")
  coord = document.getElementById("coord")
  mycoord = document.getElementById("mycoord")
  ctx = canvas.getContext("2d")  # get 2D context
  ctx.strokeStyle = "#DE3D9C"    #Fill Color
  ctx.lineWidth = 5
  _isUserCanvas = false
  ctxU = {}  # userCanvas用のオブジェクト
  createCtxU = (uid) ->
    if _isUserCanvas is true
      ctxUid =  document.getElementById("user-canvas#{uid}")
      ctxU = ctxUid.getContext("2d")  # get 2D context
      ctxU.strokeStyle = "#83B14E"    #Fill Color
      ctxU.lineWidth = 5
      return ctxU
    else
      false
  mycoord.innerHTML = "MyCanvas "

  _socket.on "player-update", (data) ->   # userオブジェクト作成/初期化
    # game Engine  -------------------------#
    if _userMap[data.userId] is `undefined`     # なかったら作る
      user =
        x: 0
        y: 0
        v: 0
        rotate: 0
        userId: data.userId
      user.element = $("<img src=\"/images/unit.png\" class=\"player\" />").attr("data-user-id", user.userId)   # 対戦相手のエレメントappend
      $("body").append(user.element)
      _userMap[data.userId] = user        # 対戦相手のobj代入

      bullet =                            # bullet弾 作成/初期化
        x: -100
        y: -100
        v: 0
        rotate: 0
        userId: data.userId
      bullet.element = $("<img src=\"/images/bullet.png\" class=\"bullet\" />").attr("data-user-id", user.userId)
      $("body").append(bullet.element)
      _bulletMap[data.userId] = bullet   # 対戦相手のobj代入

      # dDrop 作成/初期化---------------------#
      dDrop =
        ###dd: 'dd test!'
        ddmess: null
        ddpos: null###
        userId: data.userId
      _ddMap[data.userId] = dDrop        # dragdropのobj代入
      # uCanv 作成/初期化---------------------#
      uCanv =                            # uCanv 作成/初期化
         ###c_x: 0
         c_y: 0###
         userId: data.userId
      uCanv.element = $(canvasHtml(user.userId)).attr("data-user-id", user.userId)
      $("#canvasUser").append(uCanv.element)
      _canvasMap[data.userId] = uCanv    # 対戦相手のobj代入
      _isUserCanvas = true   # flag

    else
      user = _userMap[data.userId]      # もうあったら廻してuserObj更新

    user.x = data.data.x
    user.y = data.data.y
    user.rotate = data.data.rotate
    user.v = data.data.v
    #user.dd = data.data.dd                      # dragdrop add
    #user.ddpos = data.data.ddpos                # dragdrop add
    updateCss(user)  # 相手のplayer

  _socket.on "bullet-create", (data) ->
    bullet = _bulletMap[data.userId]
    if bullet isnt `undefined`
      bullet.x = data.data.x
      bullet.y = data.data.y
      bullet.rotate = data.data.rotate
      bullet.v = data.data.v

  #------------------------ dragdrop add ----------------------------------#
  _socket.on "dd-create", (data) ->
    dDrop = _ddMap[data.userId]
    if dDrop isnt `undefined`
      dDrop.ddid =     data.dd_dt.ddid
      dDrop.ddmess = data.dd_dt.ddmess
      dDrop.ddpos =  data.dd_dt.ddpos
      dDrop.userId = data.userId
      #console.info "Emit!data-id:"+ dDrop.ddid       # log -----------#
      dDelem1 = $("<div class='test'>(´･_･`..drop...userId:#{dDrop.userId}/ddid:#{dDrop.ddid})</div>")
      dDelem2 = $("<div class='test'>(´･_･`..move...userId:#{dDrop.userId}/ddid:#{dDrop.ddid})</div>")
      clone = $("div.toolbar img.tools").attr("data-id=#{dDrop.ddid}")
      #console.info $(clone)   # log -----------#
      switch dDrop.ddmess
        when 'dd-create_toolenter'
          dDrop.element = dDelem1
            .attr("data-user-id", dDrop.userId)
            .css(dDrop.ddpos)
          $("body").append(dDrop.element)
        when 'dd-create_mouseup'
          dDrop.element = dDelem2
            .attr("data-user-id", dDrop.userId)
            .css(dDrop.ddpos)
          $("body").append(dDrop.element)
        when 'dd-create_remove'
          dDelem2.find("[data-id=#{dDrop.ddid}]").remove()
        else null
  #------------------------ dragdrop add ----------------------------------#
  ###
coffee -wcb *.coffee
  ###

  # canvs add -------------------------#
  _socket.on "canvas-create", (data) ->
    uCanv = _canvasMap[data.userId]
    if uCanv isnt `undefined`
      uCanv.c_x = data.ca_cr.c_x
      uCanv.c_y = data.ca_cr.c_y
      if _isUserCanvas
        createCtxU(data.userId)
        switch data.ca_cr.c_UM   # switch文 sw
          when "onmousedown"
            ctxU.beginPath()
            ctxU.moveTo uCanv.c_x, uCanv.c_y
          when "onmousemove"
            ctxU.lineTo uCanv.c_x, uCanv.c_y
            ctxU.stroke()
          when "onmouseup"
          else null

  _socket.on "disconnect", (data) ->
    user = _userMap[data.userId]
    if user isnt `undefined`
      user.element.remove()
      delete _userMap[data.userId]
      bullet = _bulletMap[data.userId]
      bullet.element.remove()
      delete _bulletMap[data.userId]
       # dragdrop add あとで。
      uCanv = _canvasMap[data.userId]
      uCanv.element.remove()
      delete _canvasMap[data.userId]
      return _isUserCanvas = false   # flag

  # myPlayerの初期値
  _keyMap = []
  _player =  # 自分のplayer
    x: Math.random() * 1000 | 0
    y: Math.random() * 500 | 0
    v: 0
    rotate: 0
    element: $("#my-player")
  _bullet =  # 自分のbullet
    x: -100
    y: -100
    v: 0
    rotate: 0
    element: $("#my-bullet")

  updatePosition = (unit) -> # user用のTween  Class
    unit.x += unit.v * Math.cos(unit.rotate * Math.PI / 180)
    unit.y += unit.v * Math.sin(unit.rotate * Math.PI / 180)

  updateCss = (unit) ->  # CSSで動的アニメート用にアップデート Class
    unit.element.css( #jQ css obj update
      left: unit.x | 0 + "px"
      top: unit.y | 0 + "px"
      transform: "rotate(" + unit.rotate + "deg)" )
  # canvs add -- mouseEV -------------------#
  updatePosCanv = (e, gCanvasEle) ->  # canvasのMousePosを取得
    if e.pageX or e.pageY  # たぶんIE処理だろうな。
      canvasX = e.pageX
      canvasY = e.pageY
    else
      canvasX = e.clientX + document.body.scrollLeft + document.documentElement.scrollLeft
      canvasY = e.clientY + document.body.scrollTop + document.documentElement.scrollTop
    canvasX -= gCanvasEle.offsetLeft
    canvasY -= gCanvasEle.offsetTop
    c_x:canvasX
    c_y:canvasY   # objに代入

  _isSpaceKeyUp = true    # スペースキー用判定

  #メインループ　myPlayer自分の部分
  f = ->
    # handle mouse events on canvas  -------------------------#
    canvas.onmousedown = (e) ->
      pos = updatePosCanv(e, canvas)
      mousedown = true
      ctx.beginPath()
      ctx.moveTo pos.c_x, pos.c_y
      _socket.json.emit "canvas-create",
        c_x:pos.c_x
        c_y:pos.c_y
        c_UM:"onmousedown"   # switch文flag
      false
    canvas.onmousemove = (e) ->
      pos = updatePosCanv(e, canvas)
      coord.innerHTML = "(" + pos.c_x + "," + pos.c_y + ")"
      if mousedown
        _socket.json.emit "canvas-create",
          c_x:pos.c_x
          c_y:pos.c_y
          c_UM:"onmousemove"  # switch文flag
        ctx.lineTo pos.c_x, pos.c_y
        ctx.stroke()
    canvas.onmouseup = (e) ->
      mousedown = false
      _socket.json.emit "canvas-create",
        c_UM:"onmouseup"       # switch文flag
    # handle mouse events on canvas  -------------------------#
    #left
    _player.rotate -= 3  if _keyMap[37] is true
    #up
    _player.v += 0.5  if _keyMap[38] is true
    #right
    _player.rotate += 3  if _keyMap[39] is true
    #down
    _player.v -= 0.5  if _keyMap[40] is true
    if _keyMap[32] is true and _isSpaceKeyUp
      #space  -> bullet
      _isSpaceKeyUp = false
      _bullet.x = _player.x + 20
      _bullet.y = _player.y + 20
      _bullet.rotate = _player.rotate
      _bullet.v = Math.max(_player.v + 3, 3)
      _socket.json.emit "bullet-create",
        x: _bullet.x | 0
        y: _bullet.y | 0
        rotate: _bullet.rotate | 0
        v: _bullet.v
    _player.v *= 0.95
    updatePosition(_player)               # myPlayer自分

    # ここはMapのループ出現処理？
    w_width = $(window).width()
    w_height = $(window).height()
    _player.x = w_width  if _player.x < -50
    _player.y = w_height  if _player.y < -50
    _player.x = -50  if _player.x > w_width
    _player.y = -50  if _player.y > w_height
    updatePosition(_bullet)               # myBullet自分

    # bullet 判定まわし
    for key of _bulletMap
      bullet = _bulletMap[key]
      updatePosition(bullet)
      updateCss(bullet)
                                       # dragdrop add あとで。
      # 衝突判定 jump
      location.href = "/gameover"  if _player.x < bullet.x and bullet.x < _player.x + 50 and _player.y < bullet.y and bullet.y < _player.y + 50
                                       # dragdrop add あとで。

    updateCss(_bullet) # 自分のbullet
    updateCss(_player) # 自分のplayer

    # ここでuser Update!  [emit]
    _socket.json.emit "player-update",
      x: _player.x | 0   # ビット演算子 | or
      y: _player.y | 0
      rotate: _player.rotate | 0
      v: _player.v
    return setTimeout(f, 30)

  setTimeout(f, 30)         # key 押し下げ判定（タイムラグ付）
  $(window).keydown (e) ->
    _keyMap[e.keyCode] = true
  $(window).keyup (e) ->
    _isSpaceKeyUp = true  if e.keyCode is 32
    _keyMap[e.keyCode] = false

  #chat -------------------------#
  #DB入れたから変更　1128
  _socket.on "player-message", (data) ->
    if data.length isnt 0
      $("#list").empty()  # まず空にして
      for name,val of data
        user =    # userのjson make
          userId: val.userId
        user.txt = $("<dt>"+val.date+"</dt><dd>"+val.playmess+":ID"+val.userId+"</dd>")
          .attr("data-user-id", val.userId)
        $("#list").prepend(user.txt)  # DOM挿入

  #サーバーにメッセージを引数にイベントを実行する----- clickEvent
  chat = ->
    msg = $("input#message").val()
    $("input#message").val ""
    _socket.json.emit "player-message",
      playmess:msg
  delId = ->
    del = $("input#delId").val()
    $("input#delId").val ""
    _socket.json.emit 'deleteDB',
      userId:del
     # v0.7.xからは socket.json.send() により明示的にJSONへ
     # 変換するように指定できるようになりました。（省略可）
    #console.info("SW-DelNo:"+del+ ":clicked") # log -----------#
    $("#list dd").each ->
      if  $(this).attr('data-user-id') is del
          $(this).replaceWith($("<dd>(´･_･`)...:ID:#{del}is Deleted</dd>"))
          return
  $("button#btn").click ->
    setTimeout(chat, 19)         # 押し下げ判定（タイムラグ付）
  $("button#btnDbDel").click ->
    setTimeout(delId, 19)         # 押し下げ判定（タイムラグ付）

  # dragdrop -----------------------------------------------------------------------------------#
  # 定義 drag and drop handlers
  $toolbar = $("div.toolbar")   # toolBarパレットの生成元
  $.each tools, (i, tool) ->     #JSONを$()に展開回し〜
    $("<img>", tool).appendTo($toolbar)

  sotoFlag = false    # toolbarから来たか判定
  $("div.toolbar img.tools").draggable
        #appendTo:'div.canvas'
        helper:'clone'
        start:->
          sotoFlag = true  # toolbarから来たか判定

  onDrag = () ->            # handle drag
    $("body").droppable(
      tolerance:'fit'
      deactivate: (ev,ui) ->
        $own = ui.helper.clone()
        if sotoFlag
          $(@).append($own)
          pos = $own.position()
          # dragdrop add -------------------------#
          tes1 = $own.clone()
          #fly1 = $(tes1).html()
          _socket.emit 'dd-create',
            console.info "fly1Drop:"+tes1     # log -----------#
            #ddid: fly1
            ddmess:'dd-create_toolenter'
            ddpos:  pos
        $us = $("body > img.tools")
        $us.on 'mousemove', ()->  #'click'
          $(@).draggable( helper:'original' )
        $us.on 'mouseup', (e) ->
          sotoFlag = false
          pos = $(@).position()
          # dragdrop add -------------------------#
          tes2 = $(@).clone()
          _socket.emit 'dd-create',
            console.info "fly2Move:"+ $(tes2)      # log -----------#
            #ddid: fly2
            ddmess:'dd-create_mouseup'
            ddpos:  pos
          e.preventDefault()

        $us.on 'dblclick', (e)->
          fly3 = $(@).attr("data-id")
          _socket.emit 'dd-create',
            ddid: fly3
            ddmess:'dd-create_remove'
          $(@).remove()
          e.preventDefault()
    )
  onDrag()  # fire



  #---------- onMove -- customEvent --- Add SW- on()off()の勉強でもある ----------#
  #$(".foo button").on("click", function(){ $("#log").append("<div>bind</div>")});
  # ↑旧.bind()
  #$(".foo").on("click", "button", function(){$("#log").append("<div>delegate</div>")});
  # ↑旧.delegate()
  #$(document).on("click",".foo button",function(){$("#log").append("<div>live</div>")});
  # ↑旧.live()
  #---------- onMove -- customEvent --- Add SW- on()off()の勉強でもある ----------#
  # dragdrop -------------#


tools = [  #------------- define toolset (JSON, e.g. from database)... ------------#
  "data-id": 1
  class: "tools"
  alt: "sun"
  title: "sun"
  src: "http://cdn4.iconfinder.com/data/icons/iconsland-weather/PNG/48x48/Sunny.png"
  "data-description": "sun in photo"
,
  "data-id": 2
  class: "tools"
  alt: "snow"
  title: "snow"
  src: "http://cdn4.iconfinder.com/data/icons/iconsland-weather/PNG/48x48/Thermometer_Snowflake.png"
  "data-description": "snow in photo"
,
  "data-id": 3
  class: "tools"
  alt: "cloud"
  title: "cloud"
  src: "http://cdn4.iconfinder.com/data/icons/iconsland-weather/PNG/48x48/Overcast.png"
  "data-description": "cloud in photo"
,
  "data-id": 4
  class: "tools"
  alt: "rain"
  title: "rain"
  src: "http://cdn4.iconfinder.com/data/icons/iconsland-weather/PNG/48x48/Night_Rain.png"
  "data-description": "rain in photo"
,
  "data-id": 5
  class: "tools"
  alt: "rainbow"
  title: "rainbow"
  src: "http://cdn1.iconfinder.com/data/icons/iconsland-weather/PNG/48x48/Rainbow.png"
  "data-description": "rainbow in photo"
]

# coffee -wcb *.coffee

