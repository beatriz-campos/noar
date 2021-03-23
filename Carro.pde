class Carro {
  PImage caminhaoFoto;
  int xV, yV;

  Carro() {
    //Imagem do caminhão
    imageMode(CENTER);
    caminhaoFoto = loadImage("caminhao.png");
    caminhaoFoto.resize(1600/5, 1210/5); //320 por 242 _ 160 por 121
    
    xV = -160;
    yV = height-121;
  }


  void mostrar() {
    image(caminhaoFoto,xV,yV);
  }
  
  void margens() {
    if(xV-160 >= width) xV = -160;
  }

  void andar() {
    xV+=10;
  }
  
  boolean encontraPipa(Pipa p) {
    if(dist(p.posicao.x,p.posicao.y,xV,yV) < 171) return true;
    else return false;
  }
  
  boolean atravessando() {
    if(xV-160 < width && xV > -160) return true;
    else return false;
  }
  
  void intersecaoPipa() {
    textSize(32);
    fill(0);
    text("Veiculo Encontra Pipa",30,100);
  }
}
