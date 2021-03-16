import org.joda.time.*;
import processing.video.*;
Movie abertura;

Cronometro contador;
Cronometro apareceVeiculo;
int tempoCronometro;

Ar ar1;
Pipa pipa;
Veiculo v1;

PrintWriter output;

void setup() {
  size(1280, 720);
  contador = new Cronometro();

  //tempoCronometro = 5000;
  apareceVeiculo = new Cronometro();

  contador.iniciar();
  pipa = new Pipa();
  ar1 = new Ar();
  v1 =  new Veiculo();

  output = createWriter("console.txt");
  
  abertura = new Movie(this, "Video Abertura.mp4");
  abertura.play();
}


void draw() {
  translate(0, height);
  scale(1, -1);
  background(#4B68B8);
  noFill();
  strokeWeight(1);
  stroke(0);
  ellipse(0, 0, 500, 500);

  //contador.mostrar(30, 50);
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
  image(abertura, 0, height);
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


void escreveTexto(String texto, int tamanho, int posicao_x, int posicao_y) {
  pushMatrix();
  translate(posicao_x,posicao_y);
  scale(1,-1);
  textSize(tamanho);
  text(texto, 0, 0);
  popMatrix();
}
