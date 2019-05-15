
#include <SPI.h>
#include <Wire.h>
#include "Adafruit_MAX31855.h"

// Default connection is using software SPI, but comment and uncomment one of
// the two examples below to switch between software SPI and hardware SPI:

// Example creating a thermocouple instance with software SPI on any three
// digital IO pins.
#define MAXDO4   13
#define MAXCS4   5
#define MAXCLK4  4

#define MAXDO3   2
#define MAXCS3   3
#define MAXCLK3  6

#define MAXDO2   7
#define MAXCS2   8
#define MAXCLK2  9

#define MAXDO1   10
#define MAXCS1   11
#define MAXCLK1  12

// initialize the Thermocouple
Adafruit_MAX31855 thermocouple1(MAXCLK1, MAXCS1, MAXDO1);
Adafruit_MAX31855 thermocouple2(MAXCLK2, MAXCS2, MAXDO2);
Adafruit_MAX31855 thermocouple3(MAXCLK3, MAXCS3, MAXDO3);
Adafruit_MAX31855 thermocouple4(MAXCLK4, MAXCS4, MAXDO4);


// Example creating a thermocouple instance with hardware SPI
// on a given CS pin.
//#define MAXCS   10
//Adafruit_MAX31855 thermocouple(MAXCS);

void setup() {
  Serial.begin(9600);
 
  while (!Serial) delay(1); // wait for Serial on Leonardo/Zero, etc

  Serial.println("MAX31855 test");
  // wait for MAX chip to stabilize
  delay(500);
}

void loop() {
  // basic readout test, just print the current temp
   Serial.print(thermocouple1.readCelsius());
   Serial.print("f");
   Serial.print(thermocouple2.readCelsius());
   Serial.print("g");
   Serial.print(thermocouple3.readCelsius());
   Serial.print("h");
   Serial.print(thermocouple4.readCelsius());
   Serial.print("i");
   Serial.println("|");
   delay(200);
}
