BufferedReader reader;
PrintWriter output;
String highscore;

void setup() {
  size(100, 100);
  reader = createReader("highscore.txt");
  try {
    highscore = reader.readLine();
  } catch (IOException e) {
    e.printStackTrace();
    highscore = "0";
  }
  output = createWriter("highscore.txt");
  output.println(highscore);
  output.flush();
  output.close();
  exit();
}