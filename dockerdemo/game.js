// game.js file
var canvas  = document.getElementById('myCanvas');
canvas.width  = window.innerWidth;
canvas.height  = window.innerHeight;
var ctx  = canvas.getContext('2d');

var ballx = 0;
var bally = 100;
var xvel = 5;
var yvel = 5;
var rad = 10;

// Draw a green circle in the middle of the screen with a radius of 10 pixels
ctx.beginPath();
ctx.arc(ballx, bally, rad, 0, Math.PI * 2);
ctx.fillStyle = "#00ff00";
ctx.fill();


canvas.onclick = function() {
  var xpos = (Math.random()*canvas.width)/5;
  var ypos = (Math.random()*canvas.height)/5;
  ctx.beginPath();
  ctx.arc(xpos,ypos, rad, 0, Math.PI * 2);
  ctx.fillStyle = "#00ff00";
  ctx.fill();
}

setInterval(() => {
  ctx.clearRect(0,0,canvas.width, canvas.height)

  ballx += xvel;
  bally += yvel;

  if (ballx > canvas.width-rad || ballx < rad){
    xvel *= -1;
  }

  if (bally > canvas.height-rad || bally < rad){
    yvel *= -1;
  }

  ctx.beginPath();
  ctx.arc(ballx, bally, rad, 0, Math.PI * 2);
  ctx.fillStyle = "#00ff00";
  ctx.fill();
}, 50)
