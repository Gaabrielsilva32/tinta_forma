//velocidade 
//horizontal e vertical do player
velh     = 0;
max_velh = 2;

velv     = 0;
max_velv = 2;

vel      = 2;



//metodo para o player andar 
movimento_player = function()
{
    //vars para armazenar os comandos
    var _direita, _esquerda;
    
    //armazenando a checagem de apertar as teclas
    _direita = keyboard_check_direct(ord("D")) or keyboard_check_direct(vk_right);
    _esquerda = keyboard_check_direct(ord("A")) or keyboard_check_direct(vk_left);
 
    // o valor da var é boleano
    //ou seja, 0 ou 1
    //se estou apertando é 1, se não estou, é 0*
    //esse código define pra qual direção eu vou
    //e multiplica pela vel
    velh = (_direita - _esquerda) * max_velh;
    
    //adiciona essa velocidade ao x
    //faz com que se movimente
    x += velh;  
}

