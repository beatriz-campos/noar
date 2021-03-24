class Ar {

  PVector vento_vetor;
  float velocidadeVento, velocidadeBase, indiceVariacao, variacao, ang_indice_var, ang_variacao, ang_base, ang_vento;
  boolean vento;

  Ar() {
    velocidadeVento = 0.2;
    velocidadeBase = 0.5;
    vento = false;
    stroke(0, 0, 255);
    strokeWeight(5);
    vento_vetor = new PVector(velocidadeVento, 0.0);
    indiceVariacao = 0.0;
    variacao = 1.0;
    
    ang_indice_var = 200;
    ang_variacao = radians(-10); 
    ang_base = 0.0;
    ang_vento = 0.0;
  }

  void mostraVetorAr() {
    stroke(#710000);
    strokeWeight(5);
    float valorX = map(vento_vetor.x,velocidadeVento,velocidadeVento+variacao,0,width);
    line(0, height, valorX, height);
    //ellipse(0,0,20,20);
  }

  void soprar() {
    vento = true;
    
    indiceVariacao += .01;
    float n = noise(indiceVariacao) * variacao;
    velocidadeVento = velocidadeBase+n;
    vento_vetor.set(velocidadeVento, 0.0);
    velocidadeVento = velocidadeBase;
    
    //ang_indice_var += .01;
    //float n1 = noise(ang_indice_var) * ang_variacao;
    //ang_vento = ang_base + n1;
    //PVector vento_temp = PVector.fromAngle(ang_vento);
    //vento_temp.setMag(vento_vetor.mag());
    //vento_vetor = vento_temp.copy();
    //ang_vento = ang_base;
  }
  
}
