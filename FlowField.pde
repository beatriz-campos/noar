class FlowField {
  PVector[][] field;

  int cols, rows;
  int resolution;
  float moff;

  FlowField(int r) {
    resolution = r;
    cols = width/resolution;
    rows = height/resolution;

    field = new PVector[cols][rows];
    init();
    moff = 20000;
  }

  void init() {
    float xoff = random(10000);
    for (int i = 0; i < cols; i++) {
      float yoff = 0;
      for (int j = 0; j < rows; j++) {
        if(j == 0) {
          field[i][j] = new PVector(-1,0);
        }
        else if (j < rows/2) {
          float theta = map(noise(xoff, yoff), 0, 1, 0, TWO_PI);
          field[i][j] = new PVector(cos(theta), sin(theta));
        } else {
          field[i][j] = new PVector(0,1);
        }
        yoff += .1;
      }
      xoff += .05;
    }
  }

  void moving() {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        if (j < rows/2) {
          float theta = map(noise(moff), 0, 1, -PI/100, PI/100);
          field[i][j].rotate(theta);
        }
      }
    }
    moff += .01;
  }

  PVector lookup(PVector lookup) {
    int column = int(constrain(lookup.x/resolution, 0, cols-1));
    int row = int(constrain(lookup.y/resolution, 0, rows-1));
    return field[column][row].copy();
  }

  // Draw every vector
  void display() {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        drawVector(field[i][j], i*resolution, j*resolution, resolution-2);
      }
    }
  }

  // Renders a vector object 'v' as an arrow and a position 'x,y'
  void drawVector(PVector v, float x, float y, float scayl) {
    pushMatrix();
    float arrowsize = 4;
    // Translate to position to render vector
    translate(x, y);
    //scale(1, -1);
    stroke(0, 100);
    // Call vector heading function to get direction (note that pointing to the right is a heading of 0) and rotate
    rotate(v.heading());
    // Calculate length of vector & scale it to be bigger or smaller if necessary
    float len = v.mag()*scayl;
    // Draw three lines to make an arrow (draw pointing up since we've rotate to the proper direction)
    line(0, 0, len, 0);
    line(len,0,len-arrowsize,+arrowsize/2);
    line(len,0,len-arrowsize,-arrowsize/2);
    popMatrix();
  }
}
