//Arduino 1.0+ Only

#include <SD.h>
#include "Wire.h"

#include <SoftwareSerial.h>    // For Arduino 1.0
SoftwareSerial mySerial(7, 8); // For Arduino 1.0


#define DS1307_ADDRESS 0x68
byte zero = 0x00; //workaround for issue #527

// capteur vibration:  - 10 Mohms  doré / bleu / noir / marron
// photorésistance http://wiki.t-o-f.info/Arduino/Photo-r%C3%A9sistance

const int pinLumiere = 0;    
const int pinTemp = 1;  
const int pinMicro = 2;  
const int pinLed = 4;  

// set up variables using the SD utility library functions:
Sd2Card card;
SdVolume volume;
SdFile root;

// change this to match your SD shield or module;
// Arduino Ethernet shield: pin 4
// Adafruit SD shields and modules: pin 10
// Sparkfun SD shield: pin 8
const int chipSelect = 10;    

File dataFile;

bool bWriteCard = false; 

byte decToBcd(byte val){
// Convert normal decimal numbers to binary coded decimal
  return ( (val/10*16) + (val%10) );
}

byte bcdToDec(byte val)  {
// Convert binary coded decimal to normal decimal numbers
  return ( (val/16*10) + (val%16) );
}


String getDate() {

  // Reset the register pointer
  Wire.beginTransmission(DS1307_ADDRESS);
  Wire.write(zero);
  Wire.endTransmission();

  Wire.requestFrom(DS1307_ADDRESS, 7);

  int second = bcdToDec(Wire.read());
  int minute = bcdToDec(Wire.read());
  int hour = bcdToDec(Wire.read() & 0b111111); //24 hour time
  int weekDay = bcdToDec(Wire.read()); //0-6 -> sunday - Saturday
  int monthDay = bcdToDec(Wire.read());
  int month = bcdToDec(Wire.read());
  int year = bcdToDec(Wire.read());

  String out = "";
  
  out += String(year); 
  out += '-'; 
  out += String(month); 
  out += '-'; 
  out += String(monthDay); 
  out += ' '; 
  out += String(hour); 
  out += ':'; 
  out += String(minute); 
  out += ':'; 
  out += String(second);
  
  return out;
}

void setup()
{

  Wire.begin();

  pinMode(pinLed, OUTPUT);

  mySerial.begin(19200); 

  // Open serial communications and wait for port to open:
  Serial.begin(19200);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for Leonardo only
  }


  Serial.print("\nInitializing SD card...");
  // On the Ethernet Shield, CS is pin 4. It's set as an output by default.
  // Note that even if it's not used as the CS pin, the hardware SS pin 
  // (10 on most Arduino boards, 53 on the Mega) must be left as an output 
  // or the SD library functions will not work. 
  pinMode(10, OUTPUT);     // change this to 53 on a mega

  // see if the card is present and can be initialized:
  if (!SD.begin(chipSelect)) 
  {
    Serial.println("Card failed, or not present");
    //return;
  }
  else
  {
    bWriteCard = true;
    Serial.println("card initialized.");
  }

}

void loop(void) {

  String date = getDate();

  int sensorLumiere = analogRead(pinLumiere);

  
  int sensorTemp = analogRead(pinTemp);

  float voltage = sensorTemp * 5.0 / 1024;
  float temperatureC = voltage  * 100;

  int temperatureEntier = int(temperatureC);
  int temperatureDec = int((temperatureC  - temperatureEntier) * 10);
  
  int sensorMicro = analogRead(pinMicro);

  String out;
  out += date;
  out += ';';
  out += String(sensorLumiere);
  out += ';';
  out += String(temperatureEntier);
  out += '.';
  out += String(temperatureDec);
  out += ';';
  out += String(sensorMicro);


  if (!SD.exists("DUINODV.TXT")){ 
    File dataFile = SD.open("DUINODV.TXT", FILE_WRITE);
    dataFile.println("datetime;lumiere;temperature");
    dataFile.close();
  }

  dataFile = SD.open("DUINODV.TXT", FILE_WRITE);

  // if the file is available, write to it:
  if (dataFile) {
    dataFile.println(out);

    dataFile.close();
    // print to the serial port too:
    Serial.println(out);

  }  
  // if the file isn't open, pop up an error:
  else {
    Serial.println("error opening DUINODV.TXT");
  } 

  digitalWrite(pinLed, HIGH);   // turn the LED on (HIGH is the voltage level)
  delay(200);               // wait for a second
  digitalWrite(pinLed, LOW);    // turn the LED off by making the voltage LOW
  delay(500);    
}
