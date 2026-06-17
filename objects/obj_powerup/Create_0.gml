
//var pra verificar se o alvo é o player
alvo = noone;


//metodo pra fazer o powerup ir pra direção do player
movimento = function()
{
    
    //se o alvo não existe, não rodo o código
    if (!alvo) return;
        
    
    x = alvo.x;
    
    y = alvo.y -34;
}

//particula
particula_powerup = function()
{
    repeat (20) 
    {
    	var _part = instance_create_layer(x, y, "enfeites", obj_particula_powerup)
        
        var _vel  = random_range(0.5, 2);
        
        var _dir  = random_range(0, 359);
        
        _part.speed     = _vel;
        
        _part.direction = _dir;
        
    }
    
}