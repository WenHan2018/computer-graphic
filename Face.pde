class Face {
  private int[] indices;
  private float[] colour;

  public Face(int[] indices, float[] colour) {
    this.indices = new int[indices.length];
    this.colour = new float[colour.length];
    System.arraycopy(indices, 0, this.indices, 0, indices.length);
    System.arraycopy(colour, 0, this.colour, 0, colour.length);
  }

  public void draw(ArrayList<float[]> vertices, boolean useColour) {
    if (useColour) {
      if (colour.length == 3)
        fill(colour[0], colour[1], colour[2]);
      else
        fill(colour[0], colour[1], colour[2], colour[3]);
    }

    if (indices.length == 1) {
      beginShape(POINTS);
    } else if (indices.length == 2) {
      beginShape(LINES);
    } else if (indices.length == 3) {
      beginShape(TRIANGLES);
    } else if (indices.length == 4) {
      beginShape(QUADS);
    } else {
      beginShape(POLYGON);
    }

    for (int i: indices) {
      vertex(vertices.get(i)[0], vertices.get(i)[1], vertices.get(i)[2]);
    }

    endShape();
  }
}
