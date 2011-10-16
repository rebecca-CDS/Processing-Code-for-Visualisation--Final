// started with tutorial Josh Harle: http://vimeo.com/28552079
// to get movie maker the code on this website was used: http://processing.org/reference/libraries/video/MovieMaker.html

// for visualisation by Rebecca Penn 3333620 for module 2 submission arch1391 2011

import processing.serial.*;
import cc.arduino.*;

import eeml.*;

Arduino arduino;
float lastUpdate;

DataOut dOut;

import processing.video.*;


MovieMaker mm;  // Declare MovieMaker object

void setup()
{
size(800, 400);  // size of visualisation window
  
  mm = new MovieMaker (this, 800, 400, "drawing2.mov", 30, MovieMaker.H263, MovieMaker.HIGH);
  
  println(Arduino.list());
arduino = new Arduino(this, Arduino.list()[0], 57600);

dOut = new DataOut(this, "http://www.pachube.com/api/35136.xml", "OfWHirEnR3GNFpiATo0O9TDuv5pLcSLBDHO3Y5fOlaE");

dOut.addData(0,"Light Sensor, Photoresistor, Light Level");
dOut.addData(1, "Timer");

}

void draw()
{
    // get value for reference number
    float reference = arduino.analogRead(0);
    println("reference: " + reference);
    
    // values for circle 1
    float value1 = arduino.analogRead(1);
    println("value1: " + value1);
    float openState1 = arduino.analogRead(2);
    println("open1: " + openState1);
    
    // values for circle 2
    float value2 = arduino.analogRead(3);
    println("value2: " + value2);
    float openState2 = arduino.analogRead(4);
    println("open2: " + openState2);
    
    // values for circle 3
    float value3 = arduino.analogRead(5);
    println("value3: " + value3);
    float openState3 = arduino.analogRead(6);
    println("open3: " + openState3);
    
  if ((millis() - lastUpdate) > 15000){
    reference = arduino.analogRead(0);
    println(reference);
        println("ready to PUT: ");
        dOut.update(0, reference);
       dOut.update(1, millis());
       int response = dOut.updatePachube();
        println(response);
       lastUpdate = millis();
  }  
  background(255);
  
  float relativeValue1 = value1 - reference;
  relativeValue1 = map(relativeValue1, -100, 100, 150, 50);
  relativeValue1 = constrain(relativeValue1, 50, 150);
  
  float relativeValue2 = value2 - reference;
  relativeValue2 = map(relativeValue2, -100, 100, 150, 50);
  relativeValue2 = constrain(relativeValue2, 50, 150);
  
  float relativeValue3 = value3 - reference;
  relativeValue3 = map(relativeValue3, -100, 100, 150, 50);
  relativeValue3 = constrain(relativeValue3, 50, 150);
  
  color c1 = color(255, 248, 58);  // yellow for big circles as tunnel
  color c2 = color(0, 44, 255);  // dark blue for photoresistor covered, less light
  color c3 = color(0, 167, 255);  // pale blue for photoresistor light
  noStroke();
  fill(c1);
  ellipse(150, 200, relativeValue1, relativeValue1);  // position of circle on left
  fill (c1);
  ellipse(400, 200, relativeValue2, relativeValue2);  // position of circle in middle
  fill (c1);
  ellipse(650, 200, relativeValue3, relativeValue3);  // position of circle on right
  
  //SERVO 1 - small circle
    if (value1 > reference + 5) {  // if light is high, create the pale blue circle
    fill(c3);
    ellipse(150, 200 + (relativeValue1 *= 0.5) - 10, 20, 20);
  }
  else {  // otherwise create a dark blue circle
    fill(c2);
    ellipse(150, 200 + (relativeValue1 *= 0.5) - 10, 20, 20);
  }
  
  //SERVO 2 - small circle
  if (value2 > reference + 5) {  // if light is high, create the pale blue circle
    fill(c3);
    ellipse(400, 200 + (relativeValue2 *= 0.5) - 10, 20, 20);
  }
  else {  // otherwise create a dark blue circle
    fill(c2);
    ellipse(400, 200 + (relativeValue2 *= 0.5) - 10, 20, 20);
  }
  
  //SERVO 3 - small circle
   if (value3 > reference + 5) {  // if light is high, create the pale blue circle
   fill(c3);
    ellipse(650, 200 + (relativeValue3 *= 0.5) - 10, 20, 20);
  }
  else {  // otherwise create a dark blue circle
    fill(c2);
    ellipse(650, 200 + (relativeValue3 *= 0.5) - 10, 20, 20);
    
  }
  mm.addFrame(); // add window's pixels to movie
}

void keyPressed() {
  if (key == ' ') {
    mm.finish(); //finish the movie if space bar is pressed
  }
}
