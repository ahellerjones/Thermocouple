/*  Intercept and log Serial transmissions from Arduino
    Andrew Heller-Jones
    Version 03/26/2019
*/
import processing.serial.*;
Serial newFourWayPort;
Serial fourWayPort;
String val;
float readingB;
float readingC;
float readingD;
float readingE;
float readingF;
float readingG;
float readingH;
float readingI;
Table dataTable;
int readCount = 0;
String fileName;
float value;
boolean go = true;
// Change these variables to whatever you want them to be.
final int MAX_READ_COUNT = 300;
float MAX_TIME = .2; // in minutes 
final int SAMPLE_RATE = 500;
final int SECONDFOURWAYPORTNUM = 1;
final int FOURWAYPORTNUM = 0;

void setup() { 
  MAX_TIME = MAX_TIME * 60000;
  //change the 0 to a 1 or 2 etc. to match your port for the LCD port
  String newFourWayPortName = Serial.list()[SECONDFOURWAYPORTNUM]; 
  String fourWayPortName = Serial.list()[FOURWAYPORTNUM];
  newFourWayPort = new Serial(this, newFourWayPortName, 9600);
  fourWayPort = new Serial(this, fourWayPortName, 9600);
  //newFourWayPort.clear();
  fourWayPort.clear();
  dataTable = new Table();
  dataTable.addColumn("id");
  dataTable.addColumn("Temp b");
  dataTable.addColumn("Temp c");
  dataTable.addColumn("Temp d");
  dataTable.addColumn("Temp e");
  dataTable.addColumn("Temp f");
  dataTable.addColumn("Temp g");
  dataTable.addColumn("Temp h");
  dataTable.addColumn("Temp i");
  dataTable.addColumn("Hour");
  dataTable.addColumn("Min");
  dataTable.addColumn("Sec");
  dataTable.addColumn("mSec");
  delay(700);

}  
  
void draw() {
  while (go) { 
    readCount += 1;
      if (fourWayPort.available() > 0) {
        String longString = fourWayPort.readStringUntil('|');
      if (longString == null) {
        longString = "0b0c0d0e|";
      }
      readingB = float(longString.substring(0, longString.indexOf('b')));
      print("TC B: ");
      println(readingB);
      readingC = float(longString.substring(longString.indexOf('b') + 1, longString.indexOf('c')));
      print("TC C: ");
      println(readingC);
      readingD = float(longString.substring(longString.indexOf('c') + 1, longString.indexOf('d')));
      print("TC D: ");
      println(readingD);
      readingE = float(longString.substring(longString.indexOf('d') + 1, longString.length() - 2));
      print("TC E: ");
      println(readingE);
      print("millis: ");
      println(millis());
} 
    
    
    
    if (newFourWayPort.available() > 0) {
      String newLongString = newFourWayPort.readStringUntil('|');
      if (newLongString == null) {
        newLongString = "0f0g0h0i|";
      }
        readingF = float(newLongString.substring(0, newLongString.indexOf('f')));
        print("TC F: ");
        println(readingF);
        readingC = float(newLongString.substring(newLongString.indexOf('f') + 1, newLongString.indexOf('g')));
        print("TC G: ");
        println(readingG);
        readingH = float(newLongString.substring(newLongString.indexOf('f') + 1, newLongString.indexOf('h')));
        print("TC H: ");
        println(readingH);
        readingI = float(newLongString.substring(newLongString.indexOf('h') + 1, newLongString.length() - 2));
        print("TC I: ");
        println(readingI);
        
        print("millis: ");
        println(millis());
    }
 
    delay(SAMPLE_RATE);
    TableRow newRow = dataTable.addRow();
    newRow.setInt("id", readCount);
    newRow.setFloat("Temp b", readingB);
    newRow.setFloat("Temp c", readingC);
    newRow.setFloat("Temp d", readingD);
    newRow.setFloat("Temp e", readingE);
    newRow.setFloat("Temp f", readingF);
    newRow.setFloat("Temp g", readingG);
    newRow.setFloat("Temp h", readingH);
    newRow.setFloat("Temp i", readingI);
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
