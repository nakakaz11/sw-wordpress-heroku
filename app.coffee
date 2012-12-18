# coffee -wcb *.coffee
# sw-chat-shoot 冗長部分を基底class+extends化 1121
# mongoDB(read/write OK,emit統合,{json}/[obj])化 1128
"use strict"
express = require("express")
routes = require("./routes")
http = require("http")
path = require("path")
app = express()
# settings -------#
app.configure ->
  app.set('port', process.env.PORT || 3000)
  app.set "views", __dirname + "/views"
  app.set "view engine", "ejs"
  app.use express.logger("dev")
  app.use express.favicon()
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use(express["static"](path.join(__dirname, 'public')))
app.configure "development", ->
  app.use express.errorHandler()

app.get "/", routes.index
app.get "/game", routes.game
app.get "/gameover", routes.gameover
# createServer -------#
server = http.createServer(app)
server.listen app.get("port"), ->
  console.info "listening on port " + app.get("port")

io = require("socket.io").listen(server, "log level": 1)
io.configure ->  # heroku Only Use Socket.IO server object
  io.set("transports", ["xhr-polling"])
  io.set("polling duration", 10)
# 基底class -------------------------#
class SwSocket
  #constructor: (@keyname) ->
    # @keyname = keynameと等価
  make: (socket,keyname) ->
    socket.on keyname, (data) ->
      socket.broadcast.emit keyname ,    #.json
        userId: socket.handshake.userId
        data:   data
        #playmess: data
        dd_dt:  data   # dd add
        dd_x:   data
        ca_cr:  data   # canvs add
###class SwSockClient extends SwSocket  # 一応便宜上 extend
  make: (socket,keyname) ->  # chat with mongoose用
    #super(socket,keyname)  # 親make()
    makeMongo = (socket,keyname) ->  # sendDB
      User.find (err,userMGD) -> # DB read  (err,userMGD)
        if err then console.info "swMongoFind:"+err # log
        socket.json.emit keyname, userMGD   # 自分にイベント送
        socket.broadcast.json.emit keyname, userMGD  # 自分以外に送
    makeMongo(socket,keyname)
    socket.on keyname, (data) ->
      # mongoose -------#
      day = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
      date = new Date()
      y = date.getFullYear()
      t = date.getMonth()+1
      d = date.getDate()
      w = date.getDay()
      h = date.getHours()+9
      m = date.getMinutes()
      s = date.getSeconds()
      if(t < 10)then t ="0"+t
      if(d < 10)then d ="0"+d
      if(h < 10)then h ="0"+h
      if(m < 10)then m ="0"+m
      if(s < 10)then s ="0"+s
      jst = y+"/"+t+"/"+d+" ("+day[w]+") "+h+":"+m  # add Time (UTC to JST)
      userMG = new User
      userMG.userId = socket.handshake.userId
      userMG.playmess = data.playmess
      userMG.date = jst
      userMG.save (err) ->       # DB write
        if err then console.log "swMongoSave:"+err # log
      #sanitized = escapeHTML(data) # これobj前にやんなきゃね。
      makeMongo(socket,keyname)###
# override -------#
p_u = new SwSocket
b_c = new SwSocket
d_d = new SwSocket
d_x = new SwSocket
#c_c = new SwSocket
d_u = new SwSocket
#p_m = new SwSockClient
# DO it -------#
_userId = 0
io.sockets.on "connection", (socket) ->
  socket.handshake.userId = _userId
  _userId++
# connection -------------------------#
  p_u.make(socket,'player-update')
  b_c.make(socket,'bullet-create')
  d_d.make(socket,'dd-create')     # dragdrop add
  socket.json.emit 'dd-create',
    userId : socket.handshake.userId
  d_x.make(socket,'dd-x')       # dragdrop myId
  socket.json.emit 'dd-back',
    myId : socket.handshake.userId
  #c_c.make(socket,'canvas-create') # canvs add
  d_u.make(socket,'disconnect')
  #p_m.make(socket,'player-message')
  socket.on 'deleteDB', (delid) ->
    User.find({userId:delid.userId}).remove()
  return

# v0.7.xからは socket.json.send() により明示的にJSONへ
###
coffee -wcb *.coffee

# サニタイズ sanitized = escapeHTML(msg)
escapeHTML = (str) ->
  str.replace(/&/g, "&amp;").replace(/"/g, "&quot;").replace(/>/g, "&gt;")
###
