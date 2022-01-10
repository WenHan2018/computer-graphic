class Rotator {
  public float[] orientation;
  public float[] origin;
  public float[] axis;
  public float angle, startAngle, endAngle, vAngle;
  boolean up;
  
  public Rotator(float[] orientation, float[] origin, float[] axis, float angle, float startAngle, float endAngle, float vAngle) {
    this.orientation = new float[] {orientation[0], orientation[1], orientation[2]};
    this.origin = new float[] {origin[0], origin[1], origin[2]};
    this.axis = new float[] {axis[0], axis[1], axis[2]};
    this.angle = angle;
    this.startAngle = startAngle;
    this.endAngle = endAngle;
    this.vAngle = vAngle;
    this.up = true;
  }
  
  public void update(float elapsed) {
    if (up) {
      angle += elapsed * vAngle;
      if (angle > endAngle) {
        angle = endAngle - Math.abs(angle - endAngle);
        up = false;
      }
    } else {
      angle -= elapsed * vAngle;
      if (angle < startAngle) {
        angle = startAngle + Math.abs(angle - startAngle);
        up = true;
      }
    }
  }
}
