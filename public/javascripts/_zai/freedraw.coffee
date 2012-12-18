# coffee -wcb *.coffee
# js2coffee freedraw.js > freedraw.coffee
# utils # Thanks to http://stackoverflow.com/questions/55677/how-do-i-get-the-coordinates-of-a-mouse-click-on-a-canvas-element/4430498#4430498
fixPosition = (e, gCanvasElement) ->
  x = undefined
  y = undefined
  if e.pageX or e.pageY
    x = e.pageX
    y = e.pageY
  else
    x = e.clientX + document.body.scrollLeft + document.documentElement.scrollLeft
    y = e.clientY + document.body.scrollTop + document.documentElement.scrollTop
  x -= gCanvasElement.offsetLeft
  y -= gCanvasElement.offsetTop
  return {x:x, y:y}

canvas = document.getElementById("canvas")
coord = document.getElementById("coord")
ctx = canvas.getContext("2d")  # get 2D context

###
# draw image
imgCat = new Image()
imgCat.src = "backgroundThis.png"
# wait for image load
imgCat.onload = ->
  # draw imgCat on (0, 0)
  ctx.drawImage imgCat, 0, 0
###

# handle mouse events on canvas
mousedown = false
ctx.strokeStyle = "#00B7FF"    #Fill Color
ctx.lineWidth = 5
canvas.onmousedown = (e) ->
  pos = fixPosition(e, canvas)
  mousedown = true
  ctx.beginPath()
  ctx.moveTo pos.x, pos.y
  false

canvas.onmousemove = (e) ->
  pos = fixPosition(e, canvas)
  coord.innerHTML = "(" + pos.x + "," + pos.y + ")"
  if mousedown
    ctx.lineTo pos.x, pos.y
    ctx.stroke()

canvas.onmouseup = (e) ->
  mousedown = false
