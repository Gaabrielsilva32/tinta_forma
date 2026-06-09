

//var pra variar a escala do brilho
var _variacao = random_range(0, 0.01);

//mudando o modo do pc renderiar as cores
gpu_set_blendmode(bm_add);

//desenhando o sprite do brilho
draw_sprite_ext(spr_brilho_tocha, 1, x, y, 0.28 + _variacao, 0.28 + _variacao, 0, c_white, 0.2)

//resetando
gpu_set_blendmode(bm_normal);