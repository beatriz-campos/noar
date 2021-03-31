class Voadores {
  FlowField f;
  ArrayList<Vehicle> objetosVoadores;
  Cronometro novoObjeto;

  Voadores() {
    f = new FlowField(20);
    objetosVoadores = new ArrayList<Vehicle>();
    novoObjeto = new Cronometro(0, 1, 5);
  }

  void adicionaObjeto() {
    if (novoObjeto.terminou()) {
      objetosVoadores.add(new Vehicle(width, random(height*0.1, height*0.5)));
    }
  }

  void atualizaObjetos(Pipa p) {
    for (int i = 0; i < objetosVoadores.size(); i++) {
      Vehicle part = objetosVoadores.get(i);
      part.follow(f);
      part.update();
      part.display();

      if (part.saiuDeTela()) {
        objetosVoadores.remove(i);
      }
      
      if(part.pipaIntersec(p)) {
        objetosVoadores.remove(i);
        p.vidas++;
      }
      
    }
  }

  void debugFlowField() {
    if (keyPressed && key == 'd') {
      debug = !debug;
    }

    // Display the flowfield in "debug" mode
    if (debug) f.display();
  }

  void gerarFlowField() {
    if (mousePressed) {
      f.init();
    }
  }
}
