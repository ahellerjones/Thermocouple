/*  Intercept and log Serial transmissions from Arduino.
    This version no longer supports the LCD terminal, requires one or two of the four-way readers 
    Andrew Heller-Jones
    Version 05/15/2019
*/
import processing.serial.*;
Serial newFourWayPort;
Serial fourWayPort;
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

// Change these variables to whatever you need them to be.
final int MAX_READ_COUNT = 300;
float MAX_TIME = 80; // in minutes 
final int SAMPLE_RATE = 500; //in milliseconds
final int SECONDFOURWAYPORTNUM = 0;
final int FOURWAYPORTNUM = 1;
final boolean twoOrOne = false; // Changes the number of units being used. true for 2, false for 1. 
                               // The MAX3655 reader can only be reader one, same with the other reader. 
                               // You cannot use the MAX31855 board as a standalone.

// Initialization of serial ports and data table. 
void setup() { 
  MAX_TIME = MAX_TIME * 60000;
  String newFourWayPortName = Serial.list()[SECONDFOURWAYPORTNUM]; 
  String fourWayPortName = Serial.list()[FOURWAYPORTNUM];
  newFourWayPort = new Serial(this, newFourWayPortName, 9600);
  fourWayPort = new Serial(this, fourWayPortName, 9600);
  dataTable = new Table();
  dataTable.addColumn("id");
  dataTable.addColumn("Temp b");
  dataTable.addColumn("Temp c");
  dataTable.addColumn("Temp d");
  dataTable.addColumn("Temp e");
  if(twoOrOne) {
    dataTable.addColumn("Temp f");
    dataTable.addColumn("Temp g");
    dataTable.addColumn("Temp h");
    dataTable.addColumn("Temp i");
  }
  dataTable.addColumn("Hour");
  dataTable.addColumn("Min");
  dataTable.addColumn("Sec");
  dataTable.addColumn("mSec");
  delay(700); //Give it a second to initialize

}  
// Serial Interception method; Processing uses draw() as its looping main method.
void draw() {
   while (go) { 
     readCount += 1;
      if (fourWayPort.available() > 0) {
        String longString = fourWayPort.readStringUntil('|');
        if (longString == null) {
            // The string must be initialized and therefore is assigned a stub string 
            // in the case of any reader malfunction.
            longString = "0b0c0d0e|"; 
        }

        // The serial data is transmitted in a string that can be seen as in the case 
        // of the null string above @ line 68; these lines pick apart said string and typecast to a float. 
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

    }
    if (twoOrOne) {
      if (newFourWayPort.available() > 0) {
          String newLongString = newFourWayPort.readStringUntil('|');
          if (newLongString == null) {
             newLongString = "0f0g0h0i|";
          }
          readingF = float(newLongString.substring(0, newLongString.indexOf('f')));
          print("TC F: ");
          println(readingF);
          readingG = float(newLongString.substring(newLongString.indexOf('f') + 1, newLongString.indexOf('g')));
          print("TC G: ");
          println(readingG);
          readingH = float(newLongString.substring(newLongString.indexOf('g') + 1, newLongString.indexOf('h')));
          print("TC H: ");
          println(readingH);
          readingI = float(newLongString.substring(newLongString.indexOf('h') + 1, newLongString.length() - 2));
          print("TC I: ");
          println(readingI);
          
        }
    }
    // Report the time that the program has been running.
      print("Time elapsed: ");
          int milliseconds = millis();
          int minutes = milliseconds / 60000;
          int seconds = (milliseconds / 1000) % 60;
          float maxSeconds = MAX_TIME % 1;
          maxSeconds = maxSeconds * 60;
          println(minutes + ":" + seconds + " out of " + (int)MAX_TIME / 60000 + ":" + (int)maxSeconds);
          println("Entry number: " + readCount + " out of " + MAX_READ_COUNT);

    delay(SAMPLE_RATE);

    // Add rows to the dataTable.
    TableRow newRow = dataTable.addRow();
    newRow.setInt("id", readCount);
    newRow.setFloat("Temp b", readingB);
    newRow.setFloat("Temp c", readingC);
    newRow.setFloat("Temp d", readingD);
    newRow.setFloat("Temp e", readingE);
    if(twoOrOne) {
      newRow.setFloat("Temp f", readingF);
      newRow.setFloat("Temp g", readingG);
      newRow.setFloat("Temp h", readingH);
      newRow.setFloat("Temp i", readingI);
    }
    newRow.setInt("Hour", hour());
    newRow.setInt("Min", minute());
    newRow.setInt("Sec", second());
    newRow.setInt("mSec", millis());

    if (readCount == MAX_READ_COUNT || (millis() > MAX_TIME)) {
      fileName = str(year()) + "." + str(month()) + "." + str(day()) + "tempData" + "(" + str(minute()) + ")" + ".csv";
      saveTable(dataTable, fileName);
      println("File Completed: " + fileName);
      // Halts the program by terminating the while loop.
      go = false;
    }
  }
}
