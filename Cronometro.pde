class Cronometro {
  int tempoSalvo, tempoTotal, minTempo, maxTempo;
  boolean sortearDnv;
  MutableDateTime tempoTela;

  // cronômetro que reseta várias vezes
  Cronometro(int tempo, int _minTempo, int _maxTempo) {
    tempoTotal = tempo * 1000;
    minTempo = _minTempo * 1000;
    maxTempo = _maxTempo * 1000;
    sortearDnv = true;
  }

  // cronômetro que apenas registra o tempo
  Cronometro() {
    sortearDnv = false;
  }

  void iniciar() {
    tempoSalvo = millis();
    tempoTela = new MutableDateTime(tempoSalvo, DateTimeZone.UTC);
  }

  void mostrar(int posX, int posY) {
    int tempo = millis() - tempoSalvo;
    tempoTela.setMillis(tempo);
    fill(0);
    escreveTexto(tempoTela.toString().substring(11, 23),32,posX, posY);
  }

  boolean terminou() {
    int tempoDecorrido = millis() - tempoSalvo;
    if (tempoDecorrido > tempoTotal) {

      //altera o tempo do cronômetro a cada vez que o tempo anteriormente definido for completado
      if (sortearDnv) {
        tempoTotal = (int)random(minTempo, maxTempo);
        tempoSalvo = millis();
      }

      return true;
    } else {
      return false;
    }
  }
}
