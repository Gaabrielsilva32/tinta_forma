
#region Variáveis

//velocidade 
//horizontal e vertical do player
velh     = 0;
max_velh = 2;
velv     = 0;
max_velv = 3.6;
vel      = 2;

//gavidade do player
grav = 0.25;

//vars do jogo
//verfica se estou no chão
chao = false;


//vars inputs
right = false;
left  = false;
jump  = false;


//janela que mostra os debugs
view_player = noone;

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
    
}


//método para aplicar a velocidade à variaveis 
aplica_velocidade_player = function()
{
    // o valor da var é boleano
    //ou seja, 0 ou 1
    //se estou apertando é 1, se não estou, é 0*
    //esse código define pra qual direção eu vou
    //e multiplica pela vel
    velh = (right - left) * max_velh;
    
    
    //se não estou no chão
    if (!chao) 
    { 
        //a velv recebe o valor da gravidade
        velv += grav;
    }
    
    //se não, se estou no chão
    else 
    {
        velv = 0; //zero a velv
        
        //aredondando o y
        y = round(y)
        
        //se estou no chão e pulei
        if (jump)
        {
            //eu subo;
            velv -= max_velv;            
            
        }   
        
    }
    
}

//método de movimento
//o anterior apenas atribui um valor às variaveis
//esse aplica o movimento
movimento = function(){
    
    //adiciona essa velocidade ao x
    //faz com que se movimente
    //e colida com os obj
    //4 é o valor padrão da precisão da colisão
    move_and_collide(velh, velv, obj_parede, 4);
    
    //aplicando à velv
    move_and_collide(0, velv, obj_parede, 12);
}



//método de trocar sprite
troca_sprite = function(_sprite_atual = sprite_index){
    
    //se a sprite que eu tô usando no momento (sprite index)
    //for diferente da que eu quero colocar (_sprite_atual)
    //eu atualizo a minha sprite e zero o imagem index
    //assim eu faço a animação sempre começar do inicio
    // já que esse código roda só uma vez, antes da troca de sprites
    if (sprite_index != _sprite_atual)
    {
        
        sprite_index = _sprite_atual;
        
        image_index = 0;
        
    }
    
}


//metodos de estado
//metodo do estado parado
estado_parado = function(){
    
    velh = 0;
    
    //definindo a sprite player
    troca_sprite(spr_player_idle);
    //se estou apertando pra dirteita ou esquerda
    //diferente de, porque não posso apertar os 2 ao mesmo tempo
    //se são diferentes, estou me movendo
    if (right != left)
    {
        //mudo o estado para movendo
        estado = estado_movendo;
        
    }
    
    //se eu apertei espaço, vou para o estado de pulando
    if (jump)
    {
        estado = estado_pulando;
        
    }
    
    //se eu não estou no chão, vou para o estado de pulando
    if (!chao)
    {
        estado = estado_pulando;
        
    }
    
}

//método do estado movendo
estado_movendo = function(){
    
    //passando o aplica velocidade
    //para pegar a velocidade certa
    aplica_velocidade_player();
    
    //denifinindo a sprite
    troca_sprite(spr_player_move);
    
    
    //se a minha velh é zero
    //ou seja, se estou parado
    if (velh == 0)
    {
        //vou para o estado parado
        estado = estado_parado;
        
    }
    
    //se estou me movendo e apertei pra pular
    if (jump)
    {
        estado = estado_pulando;
    }
}


//método do estado pulando
estado_pulando = function(){
    
    //passando o aplica velocidade
    //para pegar a velocidade certa
    aplica_velocidade_player();
    
    //se estou indo pra cima
    //a minha velv é negativa
    if (velv < 0)
    {
        //troco o sprite
        troca_sprite(spr_player_jump_cima);
    }
    else //se estou caindo, a minha velv é positiva 
    {
    	troca_sprite(spr_player_jump_baixo);
    }
    
    //se estou no chão
    if (chao)
    {
        //vou para o estado de parado
        estado = estado_parado;
        
    }
}


//estado de inicio da animação de pegando powerup
estado_pegando_powerup_inicio = function(){
    
    //mudando a sprite dele
    troca_sprite(spr_player_powerup_inicio);
    
}

//estado do meio da animação de pegando powerup
estado_pegando_powerup_meio = function(){
    
    //mudando a sprite dele
    troca_sprite(spr_player_powerup_meio);
    
}

//estado do fim da animação de pegando powerup
estado_pegando_powerup_fim = function(){
    
    //mudando a sprite dele
    troca_sprite(spr_player_powerup_fim);
    
}



#endregion

#region debug

//método dos roda os debugs
roda_debug = function(){
    
  
    
    //criando os debugs dentro de uma view
    view_player = dbg_view("View_player", 1, 40, 100, 200, 300);
    
    //dbg da velv
    dbg_watch(ref_create(self, "velv"), "velv");
     
     
    //dbg que dá pra alterar o valor
    //da max_velv
    dbg_slider(ref_create(self, "max_velv"), 0, 5, "Max_velv", .1);
     
     
    //dbg que dá pra alterar o valor
    //da gravidade
    dbg_slider(ref_create(self, "grav"), 0, 2, "Gravidade", .1);
}

//metodo para ativar o debug
ativa_debug = function(){
    
    
    //Se não estou no modo debug
    //ele não faz nada
    if (!DEBUG_MODE) return;
        
    //se eu apertar tab
    if (keyboard_check_pressed(vk_tab))
    { 
        
        //vira falso ou true
        global.debug = !global.debug;
        
        
        //se estou no modo debug
         if (global.debug)
         {
             //eu rodo o debug
             roda_debug();
         }
         else //se não
         {
             //se minha view existe
             if (dbg_view_exists(view_player)) 
             {
                 //eu deleto ela
                 dbg_view_delete(view_player);
             }
         
             
         }
        
    }
}


#endregion


//aqui ficam as últimas coisas do meu create
//a var estado, armazena o estado atual do player
estado = estado_pegando_powerup_fim;