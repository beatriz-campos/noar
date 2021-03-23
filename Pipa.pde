class Pipa {
  PVector posicao, velocidade, aceleracao, gravidade, sustentacao, arrasto, tracao, sustentacao_sem_peso;
  float x1L, x2L, y1L, y2L;
  float maxLinha, compLinha, multVetor;
  PImage pipafoto;
  float massa;
  float cSustentacao, cArrasto;
  float indiceVar;
  float variacaotracao;
  boolean teclaLiberada;

  Pipa() {
    //Linha
    x1L = 1; // 0
    y1L = 1; //0
    x2L = 100;  // 0 
    y2L = 100; // 0
    maxLinha = 0.0;
    compLinha = 0;

    //Arrasto
    cArrasto = 0.1;
    arrasto = new PVector(0.0, 0.0);

    //Sustentacao
    cSustentacao = 0.1;
    sustentacao = new PVector(0.0, 0.0);
    sustentacao_sem_peso = new PVector(.0,.0);

    //tracao
    tracao = new PVector(0.0, 0.0);
    variacaotracao = 1;
    teclaLiberada = false;
    indiceVar = 0.0;

    //Outros Vetores
    posicao = new PVector(x2L, y2L);
    velocidade = new PVector(0.0, 0.0);
    gravidade = new PVector(0.0, -0.2); //(0, -0.2)
    aceleracao = new PVector(0.0, 0.0); 

    //Imagem da pipa
    imageMode(CENTER);
    pipafoto = loadImage("pipa.png");
    pipafoto.resize(100, 100);

    massa = 1.0;

    multVetor = 20;
  }

  void aplicarForca(PVector forca) {
    PVector f = forca.copy();
    f.div(massa);
    aceleracao.add(f);
  }

  void pesar() {
    gravidade.mult(massa);
    aplicarForca(gravidade);
  }

  void sustentar(Ar a) {
    //90 graus = pi/2 radianos HALF_PI

    //DIREÇÃO
    sustentacao = a.vento_vetor.copy();
    sustentacao.rotate(radians(90.0));
    sustentacao.normalize();

    //DIMENSÃO
    float velocidadeEscalar = a.vento_vetor.mag();
    float magnitudeSustentacao = cSustentacao * sq(velocidadeEscalar);
    sustentacao.mult(magnitudeSustentacao);
    //sustentacao_sem_peso = sustentacao.copy();
    sustentacao.setMag(sustentacao.mag()+gravidade.mag());

    //OSCILAÇÃO
    //sustentacao.setMag(variar(sustentacao, 4));

    aplicarForca(sustentacao);
  }

  void arrastar(Ar a) {
    //DIREÇÃO
    arrasto = a.vento_vetor.copy();
    arrasto.normalize();

    //DIMENSÃO
    float velocidadeEscalar = a.vento_vetor.mag();
    float magnitudeArrasto = cArrasto * sq(velocidadeEscalar);
    arrasto.mult(magnitudeArrasto);

    //OSCILAÇÃO
    //arrasto.setMag(variar(arrasto, 2));

    aplicarForca(arrasto);
  }

  void tracionar() {
    //DIREÇÃO
    tracao = posicao.copy();
    tracao.normalize();
    tracao.mult(-1);

    //DIMENSÃO
    //PVector tracao_dim = PVector.add(sustentacao_sem_peso.copy(), arrasto.copy());
    PVector tracao_dim = PVector.add(sustentacao.copy(), arrasto.copy());
    //tracao_dim.add(gravidade.copy());
    tracao.mult(tracao_dim.mag());

    if (keyPressed && keyCode == DOWN) {
      println("tecla BAIXO");
      output.println("tecla BAIXO");
      tracao.setMag(tracao.mag()+variacaotracao);
      aplicarForca(tracao);
    } else if (keyPressed && keyCode == UP) {
      println("tecla CIMA");
      output.println("tecla CIMA");
      tracao.setMag(tracao.mag()-variacaotracao);
      aplicarForca(tracao);
    } else {
      println("tracao aplicada");
      output.println("tracao aplicada");
      aplicarForca(tracao);
    }
  }

  float variar(PVector f, float var) {
    indiceVar += 0.1;
    float n = noise(indiceVar) * var;
    f.setMag(f.mag()+n);
    return f.mag();
  }

  void atualizar() {
    //if (teclaLiberada) {
    //  if (velocidade.mag() > 0.2) {
    //    velocidade.setMag(lerp(velocidade.mag(), 0.0, 0.05));
    //  } else {
    //    velocidade.setMag(0.0);
    //  }
    //} else {
      velocidade.add(aceleracao);
    //}

    //if (velocidade.mag() == 0) {
    //  teclaLiberada = false;
    //}
    posicao.add(velocidade);
    mostraVetores();
    imprimeVetores();
    aceleracao.mult(0.0);
  }

  //mostra vetor preto e com valor da magnitude
  void mostraVetor(String nomeVetor, int pixelX, int pixelY, PVector v, int tamanhoTexto) {
    PVector vetorTemp = v.copy();
    strokeWeight(2);
    stroke(0);
    line(pixelX, pixelY, (pixelX+(vetorTemp.x)*multVetor), (pixelY+(vetorTemp.y)*multVetor));
    fill(255, 0, 0);
    ellipse(pixelX, pixelY, 2, 2);
    fill(0);
    escreveTexto(nomeVetor + " " + v.mag(), tamanhoTexto, pixelX, pixelY-40);
  }

  //mostra vetor colorido e sem valor da magnitude
  void mostraVetor(String nomeVetor, int pixelX, int pixelY, PVector v, color c, int tamanhoTexto) {
    PVector vetorTemp = v.copy();
    strokeWeight(2);
    stroke(c);
    line(pixelX, pixelY, (pixelX+(vetorTemp.x)*multVetor), (pixelY+(vetorTemp.y)*multVetor));
    escreveTexto(nomeVetor, tamanhoTexto, pixelX, pixelY-40);
  }

  void mostraVetores() {
    mostraVetor("", width/2, height/2-200, posicao, #FF0000, 10);
    mostraVetor("", width/2, height/2-200, velocidade, #00ff00, 10);
    mostraVetor("aceleracao (preto) \nposicao (vermelho) \nvelocidade (verde)", width/2, height/2-200, aceleracao, 10);

    mostraVetor("gravidade", width/2, height/2, gravidade, 20);

    mostraVetor("sustentacao", width/2, height/2+200, sustentacao, 20);

    mostraVetor("arrasto", width/2+300, height/2+200, arrasto, 20);

    mostraVetor("tracao", width/2+300, height/2, tracao, 20);
  }

  void imprimeVetores() {
    imprimeVetor(sustentacao, "sustentacao");
    imprimeVetor(gravidade, "peso");
    imprimeVetor(arrasto, "arrasto");
    imprimeVetor(tracao, "tracao");
    imprimeVetor(posicao, "posicao");
    imprimeVetor(velocidade, "velocidade");
    imprimeVetor(aceleracao, "aceleracao");
    println("\n");
    output.println("\n");
  }

  void imprimeVetor(PVector v, String nomeV) {
    println(nomeV + ": " + v.mag() + "            " + nomeV + " x: " + v.x + "            " + nomeV + " y: " + v.y);
    output.println(nomeV + ": " + v.mag() + "            " + nomeV + " x: " + v.x + "            " + nomeV + " y: " + v.y);
  }

  void margens() {
    if (posicao.x >= width) posicao.x = width;
    if (posicao.x <= 0) posicao.x = 0;
    if (posicao.y >= height) posicao.y = height;
    if (posicao.y <= 0) posicao.y = 0;
  }

  void mostrar(Ar a) {  
    strokeWeight(1);
    noFill();
    stroke(0);
    line(x1L, y1L, posicao.x, posicao.y);

    pushMatrix();
    translate(posicao.x, posicao.y);
    rotate(a.vento_vetor.heading());
    int tamanhoImg = int(posicao.y);
    tamanhoImg = int(map(tamanhoImg,0,height,100,50));
    tamanhoImg = constrain(tamanhoImg, 50, 100);
    image(pipafoto, 0, 0,tamanhoImg,tamanhoImg);
    popMatrix();
  }

  boolean ventoSoprando(Ar a) {
    if (a.vento) {
      return true;
    } else {
      return false;
    }
  }
}
