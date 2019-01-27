/*  Intercept and log Serial transmissions from Arduino
    Andrew Heller-Jones
    Version 01/27/2019
*/
import processing.serial.*;
Serial myPort;
String val;
Table dataTable;
int readCount = 0;
String fileName;
void setup() { 
  String portName = Serial.list()[2]; //change the 0 to a 1 or 2 etc. to match your port
  myPort = new Serial(this, portName, 9600);
  dataTable = new Table();
  dataTable.addColumn("id");
  dataTable.addColumn("Temp");
  dataTable.addColumn("Hour");
  dataTable.addColumn("Min");
  dataTable.addColumn("Sec");
}  
  
void draw() {
  readCount += 1;
  if ( myPort.available() > 0) {  // If data is available,
    val = myPort.readStringUntil(' ');
    if (val == null) { 
      val = "0";
    }
    println(val);
  }
  
  delay(300);
  float value = float(val);
  println(value);
  TableRow newRow = dataTable.addRow();
  newRow.setInt("id", readCount);
  newRow.setFloat("Temp", value);
  newRow.setInt("Hour", hour());
  newRow.setInt("Min", minute());
  newRow.setInt("Sec", second());
  if (readCount == 50) { // Reads 50 values. 
    fileName = str(year()) + "." + str(month()) + "." + str(day()) + "tempData.csv";
    saveTable(dataTable, fileName);
    println("File Completed: " + fileName);
  } 
}
