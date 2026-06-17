//me destuo

//direction = point_direction(x, y, obj_player.x, obj_player)

if (alvo == noone)
{
    
    alvo = obj_player.id;
    
    //faço o player ir para o estado de pega power up
    other.pega_powerup(); 
    
    //chamando metodo de movimento
    movimento();
    
    particula_powerup();
    
}