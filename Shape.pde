class Shape {
  // set this to NULL if you don't want outlines
  public float[] line_colour;

  protected ArrayList<float[]> vertices;
  protected ArrayList<Face> faces;
  
  private float[] scale;
  private Rotator rotator;

  public Shape(float[] scale, Rotator rotator) {
    // you could subclass Shape and override this with your own
    init(scale, rotator);

    // default shape: cube
    vertices.add(new float[] { -1.0f, -1.0f, 1.0f });
    vertices.add(new float[] { 1.0f, -1.0f, 1.0f });
    vertices.add(new float[] { 1.0f, 1.0f, 1.0f });
    vertices.add(new float[] { -1.0f, 1.0f, 1.0f });
    vertices.add(new float[] { -1.0f, -1.0f, -1.0f });
    vertices.add(new float[] { 1.0f, -1.0f, -1.0f });
    vertices.add(new float[] { 1.0f, 1.0f, -1.0f });
    vertices.add(new float[] { -1.0f, 1.0f, -1.0f });

    faces.add(new Face(new int[] { 0, 1, 2, 3 }, new float[] { 1.0f, 0.0f, 0.0f } ));
    faces.add(new Face(new int[] { 0, 3, 7, 4 }, new float[] { 1.0f, 1.0f, 0.0f } ));
    faces.add(new Face(new int[] { 7, 6, 5, 4 }, new float[] { 1.0f, 0.0f, 1.0f } ));
    faces.add(new Face(new int[] { 2, 1, 5, 6 }, new float[] { 0.0f, 1.0f, 0.0f } ));
    faces.add(new Face(new int[] { 3, 2, 6, 7 }, new float[] { 0.0f, 0.0f, 1.0f } ));
    faces.add(new Face(new int[] { 1, 0, 4, 5 }, new float[] { 0.0f, 1.0f, 1.0f } ));
  }

  public Shape(String filename, float[] scale, Rotator rotator) {
    init(scale, rotator);

    // TODO Use as you like
    // NOTE that there is limited error checking, to make this as flexible as possible
    BufferedReader input;
    String line;
    String[] tokens;

    float[] vertex;
    float[] colour;
    String specifyingMaterial = null;
    String selectedMaterial;
    int[] face;

    HashMap<String, float[]> materials = new HashMap<String, float[]>();
    materials.put("default", new float[] {0.5,0.5,0.5});
    selectedMaterial = "default";

    // vertex positions start at 1
    vertices.add(new float[] {0,0,0});

    int currentColourIndex = 0;

    // these are for error checking (which you don't need to do)
    int lineCount = 0;
    int vertexCount = 0, colourCount = 0, faceCount = 0;

    try {
      input = new BufferedReader(new FileReader(dataPath(filename)));

      line = input.readLine();
      while (line != null) {
        lineCount++;
        tokens = line.split("\\s+");

        if (tokens[0].equals("v")) {
          assert tokens.length == 4 : "Invalid vertex specification (line " + lineCount + "): " + line;

          vertex = new float[3];
          try {
            vertex[0] = Float.parseFloat(tokens[1]);
            vertex[1] = Float.parseFloat(tokens[2]);
            vertex[2] = Float.parseFloat(tokens[3]);
          } catch (NumberFormatException nfe) {
            assert false : "Invalid vertex coordinate (line " + lineCount + "): " + line;
          }

          System.out.printf("vertex %d: (%f, %f, %f)\n", vertexCount + 1, vertex[0], vertex[1], vertex[2]);
          vertices.add(vertex);

          vertexCount++;
        } else if (tokens[0].equals("newmtl")) {
          assert tokens.length == 2 : "Invalid material name (line " + lineCount + "): " + line;
          specifyingMaterial = tokens[1];
        } else if (tokens[0].equals("Kd")) {
          assert tokens.length == 4 : "Invalid colour specification (line " + lineCount + "): " + line;
          assert faceCount == 0 && currentColourIndex == 0 : "Unexpected (late) colour (line " + lineCount + "): " + line;

          colour = new float[3];
          try {
            colour[0] = Float.parseFloat(tokens[1]);
            colour[1] = Float.parseFloat(tokens[2]);
            colour[2] = Float.parseFloat(tokens[3]);
          } catch (NumberFormatException nfe) {
            assert false : "Invalid colour value (line " + lineCount + "): " + line;
          }
          for (float colourValue: colour) {
            assert colourValue >= 0.0f && colourValue <= 1.0f : "Colour value out of range (line " + lineCount + "): " + line;
          }

          if (specifyingMaterial == null) {
            System.out.printf("Error: no material name for colour %d: (%f %f %f)\n", colourCount + 1, colour[0], colour[1], colour[2]);
          } else {
            System.out.printf("material %s: (%f %f %f)\n", specifyingMaterial, colour[0], colour[1], colour[2]);
            materials.put(specifyingMaterial, colour);
          }

          colourCount++;
        } else if (tokens[0].equals("usemtl")) {
          assert tokens.length == 2 : "Invalid material selection (line " + lineCount + "): " + line;

          selectedMaterial = tokens[1];
        } else if (tokens[0].equals("f")) {
          assert tokens.length > 1 : "Invalid face specification (line " + lineCount + "): " + line;

          face = new int[tokens.length - 1];
          try {
            for (int i = 1; i < tokens.length; i++) {
              face[i - 1] = Integer.parseInt(tokens[i].split("/")[0]);
            }
          } catch (NumberFormatException nfe) {
            assert false : "Invalid vertex index (line " + lineCount + "): " + line;
          }

          System.out.printf("face %d: [ ", faceCount + 1);
          for (int index: face) {
            System.out.printf("%d ", index);
          }
          System.out.printf("] using material %s\n", selectedMaterial);

          colour = materials.get(selectedMaterial);
          if (colour == null) {
            System.out.println("Error: material " + selectedMaterial + " not found, using default.");
            colour = materials.get("default");
          }
          faces.add(new Face(face, colour));

          faceCount++;
        } else {
          System.out.println("Ignoring: " + line);
        }

        line = input.readLine();
      }
    } catch (IOException ioe) {
      System.out.println(ioe.getMessage());
      assert false : "Error reading input file " + filename;
    }
  }

  protected void init(float[] scale, Rotator rotator) {
    vertices = new ArrayList<float[]>();
    faces = new ArrayList<Face>();

    line_colour = new float[] { 1,1,1 };
    if (null == scale) {
      this.scale = new float[] { 1,1,1 };
    } else {
      this.scale = new float[] { scale[0], scale[1], scale[2] };
    }
    
    this.rotator = rotator;
  }

  public void rotate() {
    if (rotator != null) {
      translate(rotator.origin[0], rotator.origin[1], rotator.origin[2]);
      if (rotator.axis[0] > 0)
        rotateX(radians(rotator.angle));
      else if (rotator.axis[1] > 0)
        rotateY(radians(rotator.angle));
      else
        rotateZ(radians(rotator.angle));
      translate(-rotator.origin[0], -rotator.origin[1], -rotator.origin[2]);
    }
  }
  
  public void draw() {
    pushMatrix();
    scale(scale[0], scale[1], scale[2]);
    if (rotator != null && rotator.orientation != null) {
      rotateX(radians(rotator.orientation[0]));
      rotateY(radians(rotator.orientation[1]));
      rotateZ(radians(rotator.orientation[2]));
    }
    for (Face f: faces) {
      if (line_colour == null) {
        noStroke();
        f.draw(vertices, true);
      } else {
        stroke(line_colour[0], line_colour[1], line_colour[2]);
        f.draw(vertices, true);
      }
    }
    popMatrix();
  }
}
