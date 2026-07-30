//se eu tenho um alvo
if (alvo)
{
    //fico transparente gradualmente
    image_alpha -= 0.01;
    
    //se estou transparente, me destruo
    if (image_alpha <= 0) instance_destroy();
    
}