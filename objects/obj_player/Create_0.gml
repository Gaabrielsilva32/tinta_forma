
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
right       = false;
left        = false;
jump        = false;
power_tinta = false;

//janela que mostra os debugs
view_player = noone;

//var que dita a minha direção
dir = 1;


//var pra guardar a colisão do tileset do chão
var _layer = layer_tilemap_get_id("tl_level");

//variavel que quarda as colisões que eu tenho no jogo
colisoes = [obj_parede, _layer]

//iniciando o efeito mola
inicio_ef_mola();

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
    right       = keyboard_check(ord("D"));
    left        = keyboard_check(ord("A"));
    jump        =  keyboard_check_pressed(vk_space);
    power_tinta = keyboard_check_pressed(vk_shift);
}


//metodo pra ajustar escala do player
ajusta_escala = function(){
    
    //se a minha velh for diferente de 0
    //a minha dir vai ser alterada de acordo com a minha velh
    //se ela for positiva, a função sing retorna 1
    //se for negativa -1
    //e como eu disse pra isso só funcionar se a velh for diferente de 0
    //não tenho o problema dele sumir pela img xscale ser 0
    //fiz desse jeito, porque garanto que ele não vai se mexer 
    //quando tiver saindo da tinta, por ex.
    if (velh != 0) dir = sign(velh);
    
    
}


//criando um método para checar se estou no chão
checa_chao = function()
{   
    
    chao = place_meeting(x, y + 1, colisoes);
    
}


//método para aplicar a velocidade à variaveis 
aplica_velocidade_player = function()
{
    
    //checo se estou no chão
    checa_chao();
    
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
            
            //faço a particula
            //instance_create_depth(x, y, depth, obj_player_pulo_particula);
            
            //efeito mola
            ef_mola(0.6, 1.2)
            
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
    move_and_collide(velh, velv, colisoes, 4);
    
    //aplicando à velv
    move_and_collide(0, velv, colisoes, 24);
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

//método para ver se a animação acabou
acabou_animacao = function(){
    
    //ela pega a velocidade (fps) do meu sprite atual
    //que é 10
    //e divide pelo fps do jogo
    //que é 60
    var _spd = sprite_get_speed(sprite_index) / FPS;
    
    //se a minha animação correu todos os frames
    //o image_index é o frame que eu tô no momento
    //e o image_number é o total de frames da minha animação
    //se o image index passar o image number, eu terminei a animação, certo?
    //mais ou menos
    //o imagem index vai subindo com numero que quebrado
    //mas da onde vem esse numero? vem do calculo feito na _spd, a vel do sprite
    // dividido pelo fps do jogo
    //e como esse número é quebrado, nem sempre ele vai parar num número inteiro
    //então ele pode "comer" alguns frames. Se esse frame "comido" for o ultimo
    //a função não retorna true, que por sua vez -futuramente- não avança para o
    //próximo estado da animação. Ele chega muito perto do último, mas aí
    //ele reinicia. Como resolver?
    //simples: somando o número quebrado ao sprite index.
    //assim, eu compenso o número quebrado e ele não vai mais comer o último frame.
    if (image_index + _spd >= image_number)
    {
       
        //a função retorna true 
       return true;
    }    
    
    
    
}



//metodos de estado
//metodo do estado parado
estado_parado = function(){
    
    //zerando as vars de mov pra garantir que o estado incie com elas zeradas
    //se estou parado, não tenho velocidade vertical
    velh = 0;
    velv = 0;
    
    //aplico a velocidade
    //nesse estado eu não vou me mover
    //só aplico pra conseguir pular
    aplica_velocidade_player();
    
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
    if (jump and estado)
    {
        estado = estado_pulando;
        
        //faço a particula
        instance_create_depth(x, y, depth, obj_player_pulo_particula);
        
    }
    
    //se eu não estou no chão, vou para o estado de pulando
    if (!chao)
    {
        estado = estado_pulando;
        
    }
    
    //se apertei shift
    if (power_tinta)
    {
        //vou para o estado de entrar na tinta
        estado = estado_player_tinta_entrar;
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
        
        //faço a particula
        instance_create_depth(x, y, depth, obj_player_pulo_particula);
    }
    
    //se apertar shift
    if (power_tinta)
    {
        //vou pro estado de entrar na tinta
        estado = estado_player_tinta_entrar;
        
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
    
    
    
    //se toquei no chão
    if (chao)
    {
        //vou para o estado de parado
        estado = estado_parado;
        
        //faço a particula
        instance_create_depth(x, y, depth, obj_player_pouso_particula);
        
        //efeito mola
        ef_mola(1.2, 0.6);
    }
}


//estado de inicio da animação de pegando powerup
estado_pegando_powerup_inicio = function(){
    
    //começo a animação de pegando powerup
    troca_sprite(spr_player_powerup_inicio);
    
    //se a animação acabou
    //e aqui eu uso parenteses, 
    //pq quero o retorno da função
    if (acabou_animacao())
    {
        //vou para o próximo estado
        estado = estado_pegando_powerup_meio;
        
    }
    
}

//estado do meio da animação de pegando powerup
estado_pegando_powerup_meio = function(){
    
    //vou para o outra parte da animação
    troca_sprite(spr_player_powerup_meio);
    
    //se a animação acabou
    if (acabou_animacao())
    {
        
        //vou para o próximo estado
        estado = estado_pegando_powerup_fim;
        
    }
    
}

//estado do fim da animação de pegando powerup
estado_pegando_powerup_fim = function(){
    
    //última parte da animação de pegar powerup
    troca_sprite(spr_player_powerup_fim);
    
     //se a animação acabou
    if (acabou_animacao())
    {
        //volto para o esto de parado
        estado = estado_parado;
        
    }
    
}


//estado de entrar na tinta
estado_player_tinta_entrar = function(){
    
    //troco a sprite
    troca_sprite(spr_player_tinta_entrar);
    
    //zero o velh
    velh = 0;
    
    //se o obj não existe
    if (!instance_exists(obj_entrar_tinta_particula))
    {
        //crio a particula de entrar na tinta 
        instance_create_depth(x, y, depth -1, obj_entrar_tinta_particula);
    }
    
    //vejo se a animação acabou
    if (acabou_animacao())
    {
        //vou pra o estado de loop
        estado = estado_player_tinta_loop;
        
    }
}

//estado de loop na tinta/o player tá na tinta
estado_player_tinta_loop = function(){
    
    //troco a sprite
    troca_sprite(spr_player_tinta_loop);
    
    aplica_velocidade_player();
    
    velv = 0;
    
        
    
    //var que vê se na minha frente - embaixo de mim, não tem chão
    //obs: coloquei o meu velh no lugar do dir, porque o velh vira 0
    //o dir não. Ao virar 0, fica 0 * 19, que é 0, ou seja,
    //ele verifica em baixo da sprite, que tem chão
    //ent eu posso andar de novo
    var _pare = !place_meeting(x + (velh * 9), y + 1, colisoes);
     
    
    //zero a velh
    if (_pare)
    {
        velh = 0;
    }    

    
    //se apertei shift
    if (power_tinta)
    {
        //vou para o estado de sair da tinta
        estado = estado_player_tinta_sair;
        
        //crio a particula de sair da tinta
        instance_create_depth(x, y, depth, obj_sair_tinta_particula);
    }
    
    
}

//estado de sair da tinta
estado_player_tinta_sair = function(){
    
    //troco a sprite
    troca_sprite(spr_player_tinta_sair);
    
    velh = 0;
    
    //vejo se a animação acabou
    if (acabou_animacao())
    {
        estado = estado_parado;   
        
        
    }
    
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
estado = estado_parado;