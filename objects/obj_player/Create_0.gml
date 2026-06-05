
#region Variáveis

//velocidade 
//horizontal e vertical do player
velh     = 0;
max_velh = 2;
velv     = 0;
max_velv = 2;
vel      = 2;

//gavidade do player
grav = 0.5;

//vars do jogo
//verfica se estou no chão
chao = false;


//vars inputs
right = false;
left  = false;
jump  = false;

#endregion



#region Métodos


//metodo de pegar os inputs
pega_inputs = function()
{
    //o keyboard_set_map faz com que tanto a primeira tecla
    //quanto a segunda, respondam da mesma forma
    //ele diz "finja que a key 1 é a key 2"
    //e então elas passam a agir da mesma forma
    //a key 1 deixa de existir para o game maker
    //portanto para chamar a key, tenho que chamar pela key 2
    keyboard_set_map(vk_right, ord("D"));
    keyboard_set_map(vk_left, ord("A"));
   
    //dando os valores 
    //só passo o valor da segunda tecla escolhida no keyboard_set_map
    //porque ela é a principal
    right = keyboard_check(ord("D"));
    left  = keyboard_check(ord("A"));
    jump  =  keyboard_check(vk_space);
}


//criando um método para checar se estou no chão
checa_chao = function()
{   
    
    chao = place_meeting(x, y + 1, obj_parede);
    show_debug_message(chao);
    
}


//método para o player andar 
movimento_player = function()
{
    // o valor da var é boleano
    //ou seja, 0 ou 1
    //se estou apertando é 1, se não estou, é 0*
    //esse código define pra qual direção eu vou
    //e multiplica pela vel
    velh = (right - left) * max_velh;
    
    
    //se estou no chão
    if (chao) velv = 0; //zero a velv
        
    //se não, a velv recebe o valor da gravidade
    else velv = grav;
    
    
    //adiciona essa velocidade ao x
    //faz com que se movimente
    //e colida com os obj
    //4 é o valor padrão da precisão da colisão
    move_and_collide(velh, velv, obj_parede, 4);
    
    
    //aplicando à velv
    move_and_collide(0, velv, obj_parede);
}

#endregion
