//desenho o player e o efeito molas
//me desenhando
// o xscale e o yscale são as vars que aplicam o efeito mola à minha proporção
//multiplico o xscale por dir (que é a minha direção)
//se ele for positivo, estou pra diretia e se negativo, estou pra esquerda
draw_sprite_ext(sprite_index, image_index, x, y, xscale * dir, yscale, image_angle, image_blend, image_alpha);

//draw_text(x, y -15, array_length(colisoes));