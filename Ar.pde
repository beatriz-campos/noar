class Ar {

  PVector vento_vetor;
  PVector[][] campo;
  int colunas, linhas;
  int resolucao;
  float velocidadeVento, velocidadeBase, indiceVariacao, ang_indice_var, ang_variacao, ang_base, ang_vento;
  boolean vento;

  Ar(int r) {
    velocidadeVento = 0.05;
    velocidadeBase = 0.09;
    vento = false;
    vento_vetor = new PVector(velocidadeVento, 0.0);
    indiceVariacao = 0.0;

    ang_indice_var = 200;
    ang_variacao = radians(-10); 
    ang_base = 0.0;
    ang_vento = 0.0;

    resolucao = r;
    colunas = width/resolucao;
    linhas = height/resolucao;
    campo = new PVector[colunas][linhas];
  }

  PVector achar(PVector achar) {
    int coluna = int(constrain(achar.x/resolucao, 0, colunas-1));
    int linha = int(constrain(achar.y/resolucao, 0, linhas-1));
    return campo[coluna][linha].copy();
  }

  void soprar() {
    vento = true;
    //imprimeVetor(vento_vetor, "vento");
    //ang_indice_var += .01;
    //float n1 = noise(ang_indice_var) * ang_variacao;
    //ang_vento = ang_base + n1;
    //PVector vento_temp = PVector.fromAngle(ang_vento);
    //vento_temp.setMag(vento_vetor.mag());
    //vento_vetor = vento_temp.copy();
    //ang_vento = ang_base;

    PVector vento = PVector.fromAngle(0.0);

    indiceVariacao += .01;

    //1 -  para vento varia entre menor e maior que o peso mais facilmente
    float variacao = 0.02;
    float n = noise(indiceVariacao) * variacao;
    velocidadeVento = velocidadeBase+n;

    //2 -  vento que varia pra maior q o peso mais facilmente
    float variacao2 = 0.09;
    float n2 = noise(indiceVariacao) * variacao2;
    float velocidadeVento2 = velocidadeBase+n2;

    for (int i = 0; i < colunas; i++) {
      for (int j = 0; j < linhas; j++) { //i = 0 e j = 0 é no topo da tela
        if (j < linhas-2 && i < 5) {
          campo[i][j] = vento.copy().setMag(velocidadeVento2);
          //campo[i][j] = new PVector(velocidadeVento2, 0.0);
        } else if (j < linhas-4 && i >=5) { //VERMELHO
          campo[i][j] = vento.copy().setMag(0.1);
          //campo[i][j] = new PVector(0.1, 0.0);
        } else {
          campo[i][j] = vento.copy().setMag(velocidadeVento);
          //campo[i][j] = new PVector(velocidadeVento, 0.0);
        }
      }
    }

    velocidadeVento = velocidadeBase;
    velocidadeVento2 = velocidadeBase;
  }

  void imprimeVetor(PVector v, String nomeV) {
    println(nomeV + ": " + v.mag() + "            " + nomeV + " x: " + v.x + "            " + nomeV + " y: " + v.y);
    output.println(nomeV + ": " + v.mag() + "            " + nomeV + " x: " + v.x + "            " + nomeV + " y: " + v.y);
  }

  // Draw every vector
  void mostraCampo() {
    for (int i = 0; i < colunas; i++) {
      for (int j = 0; j < linhas; j++) {

        if (j < linhas-2 && i < 5) {
          stroke(255, 100);
        } else if (j < linhas-4 && i >=5) { //VERMELHO
          stroke(255, 0, 0, 100);
        } else {
          stroke(0, 100);
        }

        if (debug) drawVector(campo[i][j], i*resolucao, j*resolucao, resolucao-2);
      }
    }
  }

  // Renders a vector object 'v' as an arrow and a position 'x,y'
  void drawVector(PVector v, float x, float y, float scayl) {
    pushMatrix();
    float arrowsize = 4;
    // Translate to position to render vector
    translate(x, y);
    // Call vector heading function to get direction (note that pointing to the right is a heading of 0) and rotate
    rotate(v.heading());
    // Calculate length of vector & scale it to be bigger or smaller if necessary
    float len = v.mag()*scayl;
    // Draw three lines to make an arrow (draw pointing up since we've rotate to the proper direction)
    line(0, 0, len, 0);
    line(len, 0, len-arrowsize, +arrowsize/2);
    line(len, 0, len-arrowsize, -arrowsize/2);
    popMatrix();
  }
}
