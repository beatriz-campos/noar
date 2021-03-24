import org.joda.time.*;
import processing.video.*;
Movie abertura;
PImage fundoMenu;
Voadores voadores;

Cronometro contador, apareceVeiculo, menuChuvaDeTrens, tempoChuvaDeTrens;
int tempoCronometro;

Ar ar1;
Pipa pipa;
Carro v1;

PrintWriter output;

int menu;

boolean comecarJogo, chuvaDeTrens, popUpChuvaDeTrens;

void setup() {
  size(1280, 720);
  contador = new Cronometro();
  apareceVeiculo = new Cronometro(3, 6, 25);

  contador.iniciar();
  pipa = new Pipa();
  ar1 = new Ar();
  v1 =  new Carro();

  output = createWriter("console.txt");

  abertura = new Movie(this, "Video Abertura 2.mp4");
  abertura.play();

  fundoMenu = loadImage("tela abertura.png");

  menu = 2;

  comecarJogo = false;

  chuvaDeTrens = false;
  voadores = new Voadores();
  menuChuvaDeTrens = new Cronometro(3, 20, 30);
  tempoChuvaDeTrens = new Cronometro(15);
}


void draw() {
  switch(menu) {
  case 0:
    float abeturaDuracao = abertura.duration();
    float aberturaTempo = abertura.time();
    if (aberturaTempo < abeturaDuracao) {
      if (abertura.available()) {
        abertura.read();
      }
      image(abertura, width/2, height/2);
    } else {
      menu = 1;
    }
    break;

  case 1:
    if (!comecarJogo) {    
      background(255);
      image(fundoMenu, width/2, height/2, 1280, 720);
      int larguraBotao = 200;
      int alturaBotao = 50;
      int cantoBotaoX = 100;
      int cantoBotaoY = height/2;
      noStroke();
      if (mouseX <= cantoBotaoX + larguraBotao && mouseX >= cantoBotaoX && mouseY <= cantoBotaoY + alturaBotao && mouseY >= cantoBotaoY) {
        fill(#E87E35);
      } else {
        fill(#E835A1);
      }
      rectMode(CORNER);
      rect(cantoBotaoX, cantoBotaoY, larguraBotao, alturaBotao, 7);
      textSize(32);
      fill(255);
      text("COMEÇAR", cantoBotaoX + 20, cantoBotaoY + 35);
      if (mousePressed && mouseX <= cantoBotaoX + larguraBotao && mouseX >= cantoBotaoX && mouseY <= cantoBotaoY + alturaBotao && mouseY >= cantoBotaoY) {
        comecarJogo = true;
      }
    } else {
      menu = 2;
    }
    break;

  case 2:
    background(#4B68B8);
    noFill();
    strokeWeight(1);
    stroke(0);
    ellipse(pipa.origem.x, pipa.origem.y, 500, 500);

    contador.mostrar(30, height-50);
    ar1.soprar();
    ar1.mostraVetorAr();

    //PIPA
    pipa.pesar();

    if (pipa.ventoSoprando(ar1)) {
      pipa.sustentar(ar1);
      pipa.arrastar(ar1);
      pipa.tracionar();
    }
    pipa.atualizar();
    //pipa.margens();
    pipa.mostrar(ar1);


    //VEÍCULO
    //if (apareceVeiculo.terminou()) {
    //  v1.andar();
    //  v1.margens();
    //  //println("aparece veiculo terminou. posicao xV veiculo: " + v1.xV + "posição xV-160 do veiculo: " + (v1.xV-160)); 
    //  apareceVeiculo.iniciar();
    //}

    //  if (v1.atravessando()) {
    //    //println("veiculo atravessando, posição xV " + v1.xV + "posição xV-160 do veiculo: " + (v1.xV-160)); 
    //    v1.andar();
    //    v1.margens();
    //  }

    //  if (v1.encontraPipa(pipa)) {
    //    v1.intersecaoPipa();
    //  }

    //v1.mostrar();


    ////CHUVA DE TRENS
    //if(menuChuvaDeTrens.terminou() && chuvaDeTrens == false) {
    //  popUpChuvaDeTrens = true;
    //}
    
    //if (popUpChuvaDeTrens) {
    //  rectMode(CORNER);
    //  noStroke();
    //  fill(#E835A1);
    //  int lX = int(width  * 0.2);
    //  int lY = int(height * 0.3);
    //  rect(lX, lY, 800, 170, 7);
    //  textSize(32);
    //  fill(255);
    //  text("Aceitar participar do desafio Chuva De Trens? \n\n S - sim       N - não", lX+20, lY+50);

    //  if(keyPressed && key == 's') {
    //    chuvaDeTrens = true;
    //    tempoChuvaDeTrens.iniciar();
    //    popUpChuvaDeTrens = false;
    //  }
    //  else if(keyPressed && key == 'n') {
    //    popUpChuvaDeTrens = false;
    //  }
    //}

    ////OBJETOS VOADORES
    //if (chuvaDeTrens) {
    //  voadores.adicionaObjeto();
    //  voadores.atualizaObjetos(pipa);
    //  voadores.debugFlowField();
    //  voadores.gerarFlowField();
    //  if(tempoChuvaDeTrens.terminou()) {
    //    chuvaDeTrens = false;
    //  }
    //}
    break;
  }
}

void keyPressed() {
  if (key == ENTER) {
    output.flush();  // Writes the remaining data to the file
    output.close();  // Finishes the file
    exit();  // Stops the program
  }
  if (key == '5') {
    popUpChuvaDeTrens = true;
  }
  if (key == '0') {
    popUpChuvaDeTrens = false;
  }
}


// Stops the movie playback when the mouse pressed
void mousePressed() {
  abertura.stop();
}

void escreveTexto(String texto, int tamanho, int posicao_x, int posicao_y) {
  //pushMatrix();
  //translate(posicao_x, posicao_y);
  //scale(1, -1);
  textSize(tamanho);
  text(texto, posicao_x, posicao_y);
  //popMatrix();
}
