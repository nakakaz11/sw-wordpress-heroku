/* GET home page. */
var title = 'SW Shooting+Canvas+Chat:App';
var h2 = ' (node.js+express+socket.io+ejs+mongoHQ:coffee)';
var day = new Array("Sun","Mon","Tue","Wed","Thu","Fri","Sat");
var date = new Date();
y = date.getFullYear();
t = date.getMonth()+1;
d = date.getDate();
w = date.getDay();
h = date.getHours()+9;
m = date.getMinutes();
s = date.getSeconds();
if(t < 10) t ="0"+t;
if(d < 10) d ="0"+d;
if(h < 10) h ="0"+h;
if(m < 10) m ="0"+m;
if(s < 10) s ="0"+s;
var jst = y+"/"+t+"/"+d+" ("+day[w]+") "+(h)+":"+m ;  //add Time (UTC to JST)
var desc = '>SW App Test:'+jst;
exports.index = function(req, res){
  res.render('index',{
      title:  title,
      desc:   desc+h2 }
)};
exports.game = function(req, res){
  res.render('game',{
      title:  title,
      desc:   desc+h2 }
)};
exports.gameover = function(req, res){
	res.render('gameover',{
      title:  title,
      desc:   desc+h2 }
)};