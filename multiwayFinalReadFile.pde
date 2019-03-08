/*  Intercept and log Serial transmissions from Arduino
    Andrew Heller-Jones
    Version 03/08/2019
*/

/*
  USB end is E 
 */ 
import processing.serial.*;
Serial lcdPort;
Serial fourWayPort;
String val;
float readingB;
float readingC;
float readingD;
float readingE;
Table dataTable;
int readCount = 0;
String fileName;
float value;
boolean go = true;
// Change these variables to whatever you want them to be.
final int MAX_READ_COUNT = 30000; //number of reads you'd like the program to read
float MAX_TIME = 10; // decimal notation for number of minutes
// The program will halt if it either goes past max time, or max entries. If you don't wish to specify one, just 
// enter some absurdly large number to cancel it out. 

final int SAMPLE_RATE = 350; // in milliseconds. alter this to change the number of miliseconds between each serial read
// do not go above 
final int LCD_PORT_NUM = 2;
final int FOURWAY_PORT_NUM = 3;

float DEVIATION_A = 1.57;
float DEVIATION_B = 3.21;
float DEVIATION_C = 2.72;
float DEVIATION_D = 3.25;
float DEVIATION_E = -.76;
boolean useDev = false;
void setup() {
  
  MAX_TIME = MAX_TIME * 60000;
  //change the 0 to a 1 or 2 etc. to match your port for the LCD port
  String lcdPortName = Serial.list()[LCD_PORT_NUM]; 
  String fourWayPortName = Serial.list()[FOURWAY_PORT_NUM];
  lcdPort = new Serial(this, lcdPortName, 9600);
  fourWayPort = new Serial(this, fourWayPortName, 9600);
  //lcdPort.clear();
  fourWayPort.clear();
  dataTable = new Table();
  dataTable.addColumn("id");
  dataTable.addColumn("Temp a");
  dataTable.addColumn("Temp b");
  dataTable.addColumn("Temp c");
  dataTable.addColumn("Temp d");
  dataTable.addColumn("Temp e");
  dataTable.addColumn("Hour");
  dataTable.addColumn("Min");
  dataTable.addColumn("Sec");
  dataTable.addColumn("mSec");
  delay(1500);
  // First trial is generally at 83.1 - 83.0 * C
  //82.3
  // 82.1
  // 81.9
  // 81.8
  // B is on the farthest end 
  // E is the second from the end 
  // C is third from the end 
  // D is first 
  

}  
  
void draw() {
  if (!useDev) {
    DEVIATION_A = 0;
    DEVIATION_B = 0;
    DEVIATION_C = 0;
    DEVIATION_D = 0;
    DEVIATION_E = 0;
  }
  while (go) { 
    readCount += 1;
    if (lcdPort.available() > 0) {  // If data is available,
      val = lcdPort.readStringUntil('a');
      if (val == null) { 
        val = "0";
      }
      print("TC A: ");
      println(val.substring(0, val.indexOf('a') - 1));
    }
    if (fourWayPort.available() > 0) {
      String longString = fourWayPort.readStringUntil('|');
      if (longString == null) {
        longString = "0b0c0d0e|";
         
    }
      readingB = float(longString.substring(0, longString.indexOf('b'))) - DEVIATION_B;
      print("TC B: ");
      println(readingB);
      readingC = float(longString.substring(longString.indexOf('b') + 1, longString.indexOf('c'))) - DEVIATION_C;
      print("TC C: ");
      println(readingC);
      readingD = float(longString.substring(longString.indexOf('c') + 1, longString.indexOf('d'))) - DEVIATION_D;
      print("TC D: ");
      println(readingD);
      readingE = float(longString.substring(longString.indexOf('d') + 1, longString.length() - 2)) + DEVIATION_E;
      print("TC E: ");
      println(readingE);
      print("millis: ");
      println(millis());
} 
    
    
    delay(SAMPLE_RATE);
    if(!(val == null)) { 
      value = float(val.substring(0, val.indexOf('a') - 1)) - DEVIATION_A;
    } else {
      value = 0;
    }
    TableRow newRow = dataTable.addRow();
    newRow.setInt("id", readCount);
    newRow.setFloat("Temp a", value);
    newRow.setFloat("Temp b", readingB);
    newRow.setFloat("Temp c", readingC);
    newRow.setFloat("Temp d", readingD);
    newRow.setFloat("Temp e", readingE);
    newRow.setInt("Hour", hour());
    newRow.setInt("Min", minute());
    newRow.setInt("Sec", second());
    newRow.setInt("mSec", millis());
    
    if (readCount == MAX_READ_COUNT || (millis() > MAX_TIME)) {
      fileName = str(year()) + "." + str(month()) + "." + str(day()) + "tempData" + "(" + str(minute()) + ")" + ".csv";
      saveTable(dataTable, fileName);
      println("File Completed: " + fileName);
      go = false;
    } 
  }
}
