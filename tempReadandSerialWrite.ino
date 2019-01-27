/*  Thermocouple reading + writing to Serial connection
 *  Andrew Heller-Jones 
    Version 01/27/2019
*/ 
#include "max6675.h"

// Pin assignments
int thermoDO = 4;
int thermoCS = 5;
int thermoCLK = 6;

MAX6675 thermocouple(thermoCLK, thermoCS, thermoDO);
int vccPin = 3;
int gndPin = 2;
  
void setup() {
  Serial.begin(9600);
  // use Arduino pins 
  pinMode(vccPin, OUTPUT); digitalWrite(vccPin, HIGH);
  pinMode(gndPin, OUTPUT); digitalWrite(gndPin, LOW);
  // wait for MAX chip to stabilize
  delay(500);
}

void loop() {
  // prints the temperature in Celsius to Serial communication
  
   Serial.print(thermocouple.readCelsius());
   Serial.print(" ");
 
   delay(300);
}
