# coffee -wcb *.coffee
# js2coffee client.js > client.coffee
# http://www.atmarkit.co.jp/ait/articles/1210/10/news115_2.html

jQuery ($) ->
  "use strict"
  _socket = io.connect()
  _userMap = {}
  _bulletMap = {}
  # canvs add -- Like f -------------------#
  fixPosition = (e, gCanvasElement) ->
    if e.pageX or e.pageY
      canvasX = e.pageX
      canvasY = e.pageY
    else
      canvasX = e.clientX + document.body.scrollLeft + document.documentElement.scrollLeft
      canvasY = e.clientY + document.body.scrollTop + document.documentElement.scrollTop
    canvasX -= gCanvasElement.offsetLeft
    canvasY -= gCanvasElement.offsetTop
    return { c_x:canvasX, c_y:canvasY }

  canvas = document.getElementById("my-canvas")
  coord = document.getElementById("coord")
  ctx = canvas.getContext("2d")  # get 2D context

  #_socket.on "canvas-create", (data) ->
  #  canvasPos = _canvasMap[data.userId]
  # handle mouse events on canvas
  mousedown = false
  ctx.strokeStyle = "#00B7FF"    #Fill Color
  ctx.lineWidth = 5
  canvas.onmousedown = (e) ->
    pos = fixPosition(e, canvas)
    mousedown = true
    ctx.beginPath()
    ctx.moveTo pos.c_x, pos.c_y
    false
  canvas.onmousemove = (e) ->
    pos = fixPosition(e, canvas)
    coord.innerHTML = "(" + pos.c_x + "," + pos.c_y + ")"
    if mousedown
      ctx.lineTo pos.c_x, pos.c_y
      ctx.stroke()
  canvas.onmouseup = (e) ->
    mousedown = false

  # /canvs add -------------------------#
  _socket.on "player-update", (data) ->   # userオブジェクト作成/初期化
    # game Engine  -------------------------#
    if _userMap[data.userId] is `undefined`     # なかったら作る
      user =
        x: 0
        y: 0
        v: 0
        rotate: 0
        c_x: 0  # canvs add
        c_y: 0  # canvs add
        userId: data.userId
      user.element = $("<img src=\"/images/unit.png\" class=\"player\" />").attr("data-user-id", user.userId)
      $("body").append(user.element)
      _userMap[data.userId] = user
      bullet =                            # bullet弾 作成/初期化
        x: -100
        y: -100
        v: 0
        rotate: 0
        userId: data.userId
      bullet.element = $("<img src=\"/images/bullet.png\" class=\"bullet\" />").attr("data-user-id", user.userId)
      $("body").append(bullet.element)
      _bulletMap[data.userId] = bullet
      # canvs add -------------------------#
      ###userCanvas =                        # userCanvas 作成/初期化
         c_x: 0  # canvs add
         c_y: 0  # canvs add
         userId: data.userId
      userCanvas.canvases =  $(_canvasHtml).attr("data-user-id", user.userId)
      $("body").append(userCanvas.userCanvas)
      _canvasMap[data.userId] = userCanvas###
    else                                   # あったらoverride更新
      user = _userMap[data.userId]

    user.x = data.data.x
    user.y = data.data.y
    user.rotate = data.data.rotate
    user.v = data.data.v
    user.c_x = data.data.c_x
    user.c_y = data.data.c_y
    updateCss(user)

  _socket.on "bullet-create", (data) ->
    bullet = _bulletMap[data.userId]
    if bullet isnt `undefined`
      bullet.x = data.data.x
      bullet.y = data.data.y
      bullet.rotate = data.data.rotate
      bullet.v = data.data.v

  # canvs add -------------------------#
  ###
  _socket.on "canvas-create", (data) ->
    userCanvas = _canvasMap[data.userId]
    if userCanvas isnt `undefined`
      userCanvas.c_x = data.data.c_x
      userCanvas.c_y = data.data.c_y
  ###

  _socket.on "disconnect", (data) ->
    user = _userMap[data.userId]
    if user isnt `undefined`
      user.element.remove()
      delete _userMap[data.userId]

      bullet = _bulletMap[data.userId]
      bullet.element.remove()
      delete _bulletMap[data.userId]

      # あとでcanvas消去処理

  # myの初期値
  _keyMap = []
  _player =
    x: Math.random() * 1000 | 0
    y: Math.random() * 500 | 0
    v: 0
    rotate: 0
    element: $("#my-player")
  _bullet =
    x: -100
    y: -100
    v: 0
    rotate: 0
    element: $("#my-bullet")

  updatePosition = (unit) -> # user用のTween
    unit.x += unit.v * Math.cos(unit.rotate * Math.PI / 180)
    unit.y += unit.v * Math.sin(unit.rotate * Math.PI / 180)

  updateCss = (unit) ->  # CSSで動的アニメート用にアップデート
    unit.element.css
      left: unit.x | 0 + "px"
      top: unit.y | 0 + "px"
      transform: "rotate(" + unit.rotate + "deg)"

  _isSpaceKeyUp = true    # スペースキー用判定
  #メインループ
  f = ->                  # key判定
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
      _socket.emit "bullet-create",
        x: _bullet.x | 0
        y: _bullet.y | 0
        rotate: _bullet.rotate | 0
        v: _bullet.v

    _player.v *= 0.95
    # ここはMapのループ出現処理？
    updatePosition(_player)
    w_width = $(window).width()
    w_height = $(window).height()
    _player.x = w_width  if _player.x < -50
    _player.y = w_height  if _player.y < -50
    _player.x = -50  if _player.x > w_width
    _player.y = -50  if _player.y > w_height
    updatePosition(_bullet)
    # 衝突判定まわし
    for key of _bulletMap
      bullet = _bulletMap[key]
      updatePosition(bullet)
      updateCss(bullet)
      # 衝突判定
      location.href = "/gameover"  if _player.x < bullet.x and bullet.x < _player.x + 50 and _player.y < bullet.y and bullet.y < _player.y + 50

    updateCss(_bullet)
    updateCss(_player)

    # ここでuser Update!
    _socket.emit "player-update",
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
  #サーバーが受け取ったメッセージを返して実行する
  _socket.on "player-message", (data) ->
    console.log("SW-UserLog:"+data.userId+ ":" +data.message) # log -----------#
    date = new Date()
    if _userMap[data.userId] is `undefined`     # なかったら作る
      user =    # userのjson make
        userId: data.userId
      user.txt = $("<dt>" + date + "</dt><dd>" + data.message + "</dd>")
        .attr("data-user-id", user.userId)
      $("#list").prepend(user.txt)  # リストDOM挿入
    else                                        # あったらoverride
      user = _userMap[data.userId]
      user.txt = $("<dt>" + date + "</dt><dd>" + data.message + "</dd>")
        .attr("data-user-id", user.userId)
      $("#list").prepend(user.txt)  # リストDOM挿入

  ###  DB仕込むときにはfs使って入れるかな〜
  _socket.on "data-updateDB", (data) ->
    console.log data
  ###
  # セッション切断時
  _socket.on "disconnect", (data) ->
    user = _userMap[data.userId]
    if user isnt `undefined`
      user.element.remove()
      delete _bulletMap[data.userId]

  #サーバーにメッセージを引数にイベントを実行する----- clickEvent
  chat = ->
    msg = $("input#message").val()
    $("input#message").val ""
    #_socket.emit('message:send', { message: msg });
    _socket.emit "player-message", msg
  $("button#btn").click ->
    setTimeout(chat, 30)         # 押し下げ判定（タイムラグ付）


