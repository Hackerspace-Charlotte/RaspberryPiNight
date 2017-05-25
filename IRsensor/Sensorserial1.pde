import processing.serial.*;
Serial port;

float brightness = 0;
float val = 0;
int index = 0;

void setup()
{
  size(500,500);
  port = new Serial(this, "/dev/ttyACM0",9600);
  port.bufferUntil('\n');
 textFont(createFont("bold", 66));
}

void draw()
{
  background(8,138,250);
  text("word",50,100);
  fill(46,209,2);
  text(val,80,175);
  fill(46,209,2);
  delay(300);
}
 void serialEvent (Serial port)
 {
   val = float(port.readStringUntil('\n'));
 }