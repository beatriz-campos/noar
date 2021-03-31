class Pipa {
  PVector origem, posicao, velocidade, aceleracao, gravidade, sustentacao, arrasto, tracaoV, tracaoH, forcaTotal, torque, origemPos;
  float maxLinha, compLinha, multVetorGlobal;
  float angulo, aVelocidade, aAceleracao;
  PImage pipafoto;
  float massa;
  int vidas;

  Pipa() {
    //Linha
    maxLinha = 2.0;
    compLinha = 50.0;
    angulo = radians(90);

    //Arrasto
    arrasto = new PVector(0.0, 0.0);

    //Sustentacao
    sustentacao = new PVector(0.0, 0.0);

    //tracao
    tracaoH = new PVector(0.0, 0.0);
    tracaoV = new PVector(0.0, 0.0);

    //Outros Vetores
    origem = new PVector(50, height);
    posicao = origem.copy();
    velocidade = new PVector(0.0, 0.0);
    gravidade = new PVector(0.0, 0.1); //(0, 0.2)
    aceleracao = new PVector(0.0, 0.0); 

    //Imagem da pipa
    imageMode(CENTER);
    pipafoto = loadImage("pipaPraCima.png");
    pipafoto.resize(100, 100);

    massa = 1.0;

    multVetorGlobal = 100;
    posicao.add(origem);

    forcaTotal = new PVector(0.0, 0.0);
    torque = new PVector(0.0, 0.0);
    origemPos = new PVector(0.0, 0.0);
    
    vidas = 3;
  }


  void aplicarForca(PVector forca) {
    forcaTotal.add(forca);
    //PVector f = PVector.div(forca, massa);
    //aceleracao.add(f);
  }

  void pesar() {
    gravidade.mult(massa);

    if (posicao.y >= origem.y) {
    } else {
      aplicarForca(gravidade);
    }
  }

  void sustentar(Ar a) {
    //90 graus = pi/2 radianos HALF_PI, o processing originalmente faz a rotação assim: sentido horário é positivo, sentido anti horario é negativo
    sustentacao.set(0, -1);
    sustentacao.setMag(a.achar(posicao).copy().mag());

    ////MAGNITUDE
    //sustentacao = a.achar(posicao).copy();
    //imprimeVetor(sustentacao,"vento achado"                                                                                                                                                                                     );

    ////DIREÇÃO
    //sustentacao.rotate(-HALF_PI);

    aplicarForca(sustentacao);
  }

  void arrastar(Ar a) {
    //MAGNITUDE E DIREÇÃO
    arrasto = a.achar(posicao).copy();
    aplicarForca(arrasto);
  }

  void tracionar() {
    //MAGNITUDE
    tracaoH = arrasto.copy();

    //DIREÇAO
    tracaoH.mult(-1);

    float varCompLinha = 1;

    if (keyPressed && keyCode == DOWN) {
      if (compLinha > 50) compLinha-=varCompLinha;
    } else if (keyPressed && key == ' ') {
    } else if (!(keyPressed && key == ' ')) {
      compLinha+=varCompLinha;
    }
  }

  void atualizar() {  
    String sentido = "";
    origemPos = PVector.sub(posicao, origem);

    //vetor penperdicular a origem e a posicao
    PVector pop = origemPos.copy().rotate(radians(90.0));

    //angulo entre pop e forca total
    float angForcaTotalPop = PVector.angleBetween(pop, forcaTotal);


    //Direção do torque
    //negativo é horário, positivo anti horario
    float fatorHorario = 0.0;
    if (angForcaTotalPop == radians(90.0)) {
      torque.setMag(0.0);
      fatorHorario = 0.0;
    } else {
      if (angForcaTotalPop > radians(90.0)) { //fatorHorario = POSITIVO, torque no sentido ANTI HORARIO
        torque = pop.rotate(radians(180));
        sentido = "SENTIDO ANTI HORARIO";
        //escreveTexto("SENTIDO ANTI HORARIO", 20, 50, 50);
        fatorHorario = +1;
      } else if (angForcaTotalPop < radians(90.0) ) { //fatorHorario = NEGATIVO, torque no sentido HORARIO
        torque = pop;
        sentido = "SENTIDO HORARIO";
        //escreveTexto("SENTIDO HORARIO", 20, 50, 50);
        fatorHorario = -1;
      }

      //Magnitude do torque      
      torque.setMag(sin(PVector.angleBetween(origemPos, forcaTotal))*forcaTotal.mag()/compLinha);
    }

    //Física linear
    //aceleracao.add(torque);
    //velocidade.add(aceleracao);
    //posicao.add(velocidade);

    //Física angular (?)

    //gambiarra pra simular a resistencia do ar e a pipa parando
    if (forcaTotal.mag() == 0) {
      aVelocidade = lerp(aVelocidade, 0.0, 0.05);
    } else {
      aAceleracao = torque.mag()*fatorHorario;
      aVelocidade += aAceleracao;
    }

    angulo+=aVelocidade;

    //atualizando posicao
    posicao.set(compLinha * sin(angulo), compLinha*cos(angulo), 0);
    posicao.add(origem);


    //DEBUG
    if (debug) {
      escreveTexto(sentido, 20, 50, 50);
      mostraVetor("torque", width/2+300, height/2, torque, 20, 300000000);
      mostraVetor("forca total", width/2+300, height/2-200, forcaTotal, 20, 3000);
      mostraVetores();
      escreveTexto(str(aAceleracao), 20, 100, 100);

      if (aAceleracao > 0) {
        escreveTexto("aAcel positica", 20, 300, 100);
      } else if (aAceleracao < 0) {
        escreveTexto("aAcel negativa", 20, 300, 100);
      }
      imprimeVetores();

      if (gravidade.mag() > sustentacao.mag()) {
        escreveTexto("PESO VENCE", 20, 100, 200);
      } else if (gravidade.mag() < sustentacao.mag()) {
        escreveTexto("SUSTENTACAO VENCE", 20, 100, 200);
      }

      float magnitudeTorque = sin(PVector.angleBetween(origemPos, forcaTotal))*forcaTotal.mag()/compLinha;
      if (magnitudeTorque > 0) {
        escreveTexto("Mag torque positiva", 20, 100, 250);
      } else if (magnitudeTorque < 0) {
        escreveTexto("Mag torque negativa", 20, 100, 250);
      }
      escreveTexto(str(degrees(angulo)), 20, 100, 300);
    }


    //limpando aceleracao
    aceleracao.mult(0.0);
    forcaTotal.mult(0.0);
  }

  void mostrar(Ar a) {  
    strokeWeight(1);
    noFill();
    stroke(0);

    int tamanhoImg = int(posicao.y);
    tamanhoImg = int(map(tamanhoImg, 0, -height, 50, 100));
    tamanhoImg = constrain(tamanhoImg, 50, 100);

    line(origem.x, origem.y, posicao.x, posicao.y);
    //rotate(a.vento_vetor.heading());
    imageMode(CENTER);
    image(pipafoto, posicao.x, posicao.y, tamanhoImg, tamanhoImg);
    
    for (int h = 0; h < vidas; h++) {
      fill(255,0,0);
      ellipse (1100 + 20*h, 60, 10, 10);
    }
  }


  float variar(PVector f, float var, float indiceVar) {
    indiceVar += 0.1;
    float n = noise(indiceVar) * var;
    f.setMag(f.mag()+n);
    return f.mag();
  }

  //mostra vetor preto e com valor da magnitude
  void mostraVetor(String nomeVetor, int pixelX, int pixelY, PVector v, int tamanhoTexto, float multVetor) {
    PVector vetorTemp = v.copy();
    strokeWeight(1);
    stroke(0);
    line(pixelX, pixelY, (pixelX+(vetorTemp.x)*multVetor), (pixelY+(vetorTemp.y)*multVetor));
    fill(255, 0, 0);
    ellipse(pixelX, pixelY, 2, 2);
    fill(0);
    escreveTexto(nomeVetor + " " + v.mag(), tamanhoTexto, pixelX, pixelY-40);
  }

  //mostra vetor colorido e sem valor da magnitude
  void mostraVetor(String nomeVetor, int pixelX, int pixelY, PVector v, color c, int tamanhoTexto, float multVetor) {
    PVector vetorTemp = v.copy();
    strokeWeight(1 );
    stroke(c);
    line(pixelX, pixelY, (pixelX+(vetorTemp.x)*multVetor), (pixelY+(vetorTemp.y)*multVetor));
    escreveTexto(nomeVetor, tamanhoTexto, pixelX, pixelY-40);
  }

  void mostraVetores() {
    mostraVetor("", width/2, height/2-200, posicao, #FF0000, 10, multVetorGlobal);
    mostraVetor("", width/2, height/2-200, velocidade, #00ff00, 10, multVetorGlobal);
    mostraVetor("aceleracao (preto) \nposicao (vermelho) \nvelocidade (verde)", width/2, height/2-200, aceleracao, 10, multVetorGlobal);

    mostraVetor("gravidade", width/2, height/2, gravidade, 20, multVetorGlobal);

    mostraVetor("sustentacao", width/2, height/2+200, sustentacao, 20, multVetorGlobal);

    mostraVetor("arrasto", width/2+300, height/2+200, arrasto, 20, multVetorGlobal);

    mostraVetor("tracao", width/2+300, height/2-100, tracaoH, 20, multVetorGlobal);
  }

  void imprimeVetores() {
    imprimeVetor(sustentacao, "sustentacao");
    imprimeVetor(gravidade, "peso");
    imprimeVetor(arrasto, "arrasto");
    //imprimeVetor(tracaoH, "tracao");
    imprimeVetor(posicao, "posicao");
    println("velocidade: " + aVelocidade);
    //imprimeVetor(velocidade, "velocidade");
    //imprimeVetor(aceleracao, "aceleracao");
    println("maxLinha: " + " " + maxLinha);
    println("compLinha: " + " " + compLinha);
    println("\n");
    output.println("\n");
  }

  void imprimeVetor(PVector v, String nomeV) {
    println(nomeV + ": " + v.mag() + "            " + nomeV + " x: " + v.x + "            " + nomeV + " y: " + v.y);
    output.println(nomeV + ": " + v.mag() + "            " + nomeV + " x: " + v.x + "            " + nomeV + " y: " + v.y);
  }

  void margens() {
    //if (posicao.x >= width) posicao.x = width;
    //if (posicao.x <= 0) posicao.x = 0;
    if (posicao.y >= origem.y) posicao.y = origem.y;
    //if (posicao.y <= 0) posica o.y = 0;
  }

  boolean ventoSoprando(Ar a) {
    if (a.vento) {
      return true;
    } else {
      return false;
    }
  }
}
