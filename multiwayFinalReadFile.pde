/*  Intercept and log Serial transmissions from Arduino
    Andrew Heller-Jones
    Version 01/27/2019
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
// Change these variables to whatever you want them to be.
final int MAX_READ_COUNT = 200;
final int SAMPLE_RATE = 500;

void setup() { 
  //change the 0 to a 1 or 2 etc. to match your port for the LCD port
  String lcdPortName = Serial.list()[2]; 
  String fourWayPortName = Serial.list()[3];
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
}  
  
void draw() {
  boolean go = true;
  while (go) { 
    readCount += 1;
    if (lcdPort.available() > 0) {  // If data is available,
      val = lcdPort.readStringUntil('a');
      if (val == null) { 
        val = "0";
      }
      //println(val);
    }
    if (fourWayPort.available() > 0) {
      String longString = fourWayPort.readStringUntil('|');
      print("longString: ");
      println(longString);
      if (longString == null) {
        longString = "0b0c0d0e|";
      }
      readingB = float(longString.substring(0, longString.indexOf('b')));
      readingC = float(longString.substring(longString.indexOf('b') + 1, longString.indexOf('c')));
      readingD = float(longString.substring(longString.indexOf('c') + 1, longString.indexOf('d')));
      
      readingE = float(longString.substring(longString.indexOf('d') + 1, longString.length() - 2));
      print("eRaw: ");
      println(longString.substring(longString.indexOf('d') + 1, longString.length() - 2));
      
  } 
    
    
    delay(SAMPLE_RATE);
    float value = float(val.substring(0, val.indexOf('a') - 1));
    print("val: ");
    println(value);
    print("readingE: ");
    println(readingE);
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
    
    if (readCount == MAX_READ_COUNT) {
      fileName = str(year()) + "." + str(month()) + "." + str(day()) + "tempData.csv";
      saveTable(dataTable, fileName);
      println("File Completed: " + fileName);
      go = false;
    } 
  }
}
