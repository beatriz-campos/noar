class Cronometro {
  int tempoSalvo, tempoTotal;
  boolean sortearDnv;
  MutableDateTime tempoTela;
  
  // construtor com tempo pré-determinado
  Cronometro() {
    tempoTotal = 3000;
    sortearDnv = true;
  }

  // construtor com tempo definido na inicialização do objeto
  Cronometro(int xtempoTotal) {
    tempoTotal = xtempoTotal;
    sortearDnv = false;
  }

  void iniciar() {
    tempoSalvo = millis();
    tempoTela = new MutableDateTime(tempoSalvo, DateTimeZone.UTC);
  }
  
  void mostrar(float posX, float posY) {
    int tempo = millis() - tempoSalvo;
    tempoTela.setMillis(tempo);
    fill(0);
    textSize(32);
    text(tempoTela.toString().substring(11,23), posX, posY);
  }

  boolean terminou() {
    int tempoDecorrido = millis() - tempoSalvo;
    if (tempoDecorrido > tempoTotal) {

      // no caso do construtor pré-determinado, altera o tempo do cronômetro a cada vez que o tempo anteriormente definido for completado
      if (sortearDnv) {
        tempoTotal = (int)random(6000, 25000);
      }

      return true;
    } else {
      return false;
    }
  }
}
