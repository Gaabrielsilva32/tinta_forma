if (!alvo) exit;
    
//a particula cresce de acordo com a velocidade
image_xscale = lerp(image_xscale, speed * 3, 0.1);

//mudando a minha direção
image_angle = direction;

//se a minha velocidade ainda não foi zerada
if (!voltar)
{ 
    //diminuo a velocidade
    speed -= 0.07
    
    //se a minha velocidade for zerada
    if (speed <= 0) 
    {
        //eu volto
        voltar = true;
        
        var _x = alvo.x + random_range(-5, 5);
        var _y = alvo.y - 12 - random_range(-5, 5);
        
        direction = point_direction(x, y, _x, _y);
    }
    
}

else //se ela foi zerada
{
    //ganho velocidade
    speed += .1;
    
    var _player = instance_place(x, y, obj_player);
    
    if (_player)
    {
        instance_destroy();
        
        with (_player) 
        {
        	var _xscale = random_range(-.1, 0.1);
        	var _yscale = random_range(-.1, 0.1);
            
            ef_mola(1 + _xscale, 1 + _yscale);
            
        }
    }
}

