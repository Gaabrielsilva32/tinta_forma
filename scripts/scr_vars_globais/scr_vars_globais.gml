
//modo debug é falso
#macro DEBUG_MODE 0 

//se estou no modo normal é false
#macro modo_normal:DEBUG_MODE 0

//se estou no modo debug é true
#macro modo_debug:DEBUG_MODE 1  

#macro FPS game_get_speed(gamespeed_fps) 

//var de debug
global.debug = false;