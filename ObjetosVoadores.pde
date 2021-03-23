class Voadores {
  FlowField f;
  ArrayList<Vehicle> objetosVoadores;
  Cronometro novoObjeto;

  // Using this variable to decide whether to draw all the stuff
  boolean debug;

  Voadores() {
    f = new FlowField(20);
    objetosVoadores = new ArrayList<Vehicle>();
    novoObjeto = new Cronometro(0, 1, 5);
    debug = true;
  }

  void adicionaObjeto() {
    if (novoObjeto.terminou()) {
      objetosVoadores.add(new Vehicle(width, random(height*0.5, height*0.9)));
    }
  }

  void atualizaObjetos() {
    for (int i = 0; i < objetosVoadores.size(); i++) {
      Vehicle part = objetosVoadores.get(i);
      part.follow(f);
      part.update();
      part.display();

      if (part.saiuDeTela()) {
        objetosVoadores.remove(i);
      }
    }
  }

  void debugFlowField() {
    if (keyPressed && key == ' ') {
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
