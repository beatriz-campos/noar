import org.joda.time.*;
import processing.video.*;
Movie abertura;
PImage fundoMenu;
Voadores voadores;

Cronometro contador;
Cronometro apareceVeiculo;
int tempoCronometro;

Ar ar1;
Pipa pipa;
Carro v1;

PrintWriter output;

int menu;

boolean comecarJogo;

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
  voadores = new Voadores();
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
    

    //OBJETOS VOADORES
    voadores.adicionaObjeto();
    voadores.atualizaObjetos();
    voadores.debugFlowField();
    voadores.gerarFlowField();
    break;
  }
}

void keyReleased() {
  if (keyCode == UP || keyCode == DOWN) {
    pipa.teclaLiberada = true;
  }
}

void keyPressed() {
  if (key == ENTER) {
    output.flush();  // Writes the remaining data to the file
    output.close();  // Finishes the file
    exit();  // Stops the program
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
