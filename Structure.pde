class Structure extends Shape {
  // this array can include other structures...
  private Shape[] contents;
  private float[][] positions;

  public Structure(Shape[] contents, float[][] positions, float[] scale, Rotator rotator) {
    super(scale, rotator);
    init(contents, positions);
  }

  public Structure(String filename, Shape[] contents, float[][] positions, float[] scale, Rotator rotator) {
    super(filename, scale, rotator);
    init(contents, positions);
  }

  private void init(Shape[] contents, float[][] positions) {
    this.contents = new Shape[contents.length];
    this.positions = new float[positions.length][3];
    System.arraycopy(contents, 0, this.contents, 0, contents.length);
    for (int i = 0; i < positions.length; i++) {
      System.arraycopy(positions[i], 0, this.positions[i], 0, 3);
    }
  }

  public void draw() {
    super.draw();
    for (int i = 0; i < contents.length; i++) {
      pushMatrix();
      translate(positions[i][0], positions[i][1], positions[i][2]);
      contents[i].rotate();
      contents[i].draw();
      popMatrix();
    }
  }
}
