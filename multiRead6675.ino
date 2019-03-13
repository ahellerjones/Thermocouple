#include <SPI.h>
#include <Wire.h>

#include "max6675.h"

#define MAXDO4   13
#define MAXCS4   12
#define MAXCLK4  11

#define MAXDO3   10
#define MAXCS3   9
#define MAXCLK3  8

#define MAXDO2   7
#define MAXCS2   6
#define MAXCLK2  5

#define MAXDO1   4
#define MAXCS1   3
#define MAXCLK1  2

// initialize the Thermocouple
MAX6675 thermocouple1(MAXCLK1, MAXCS1, MAXDO1);
MAX6675 thermocouple2(MAXCLK2, MAXCS2, MAXDO2);
MAX6675 thermocouple3(MAXCLK3, MAXCS3, MAXDO3);
MAX6675 thermocouple4(MAXCLK4, MAXCS4, MAXDO4);


void setup() {
  Serial.begin(9600);
 
  while (!Serial) delay(1); // wait for Serial on Leonardo/Zero, etc

  //Serial.println("MAX31855 test");
  // wait for MAX chip to stabilize
  delay(10);
}

void loop() {
  // basic readout test, just print the current temp
   Serial.print(thermocouple1.readCelsius());
   Serial.print("b");
   Serial.print(thermocouple2.readCelsius());
   Serial.print("c");
   Serial.print(thermocouple3.readCelsius());
   Serial.print("d");
   Serial.print(thermocouple4.readCelsius());
   Serial.print("e");
   Serial.println("|");
   delay(200);
}
