/*
 * This ESP32 code is created by esp32io.com
 *
 * This ESP32 code is released in the public domain
 *
 * For more detail (instruction and wiring diagram), visit https://esp32io.com/tutorials/esp32-temperature-sensor
 */

//#include <OneWire.h>
//#include <DallasTemperature.h>
//
//#define SENSOR_PIN  21 // ESP32 pin GIOP21 connected to DS18B20 sensor's DQ pin
//
//OneWire oneWire(SENSOR_PIN);
//DallasTemperature DS18B20(&oneWire);
//
//float tempC; // temperature in Celsius
//float tempF; // temperature in Fahrenheit
//
//void setup() {
//  Serial.begin(512000); // initialize serial
//  DS18B20.begin();    // initialize the DS18B20 sensor
//  Serial.println("Started");
//}
//
//void loop() {
//  DS18B20.requestTemperatures();       // send the command to get temperatures
//  tempC = DS18B20.getTempCByIndex(0);  // read temperature in °C
//  tempF = DS18B20.getTempFByIndex(0);
//
//
//   if(tempC != DEVICE_DISCONNECTED_C) 
//  {
//    Serial.print("Temperature for the device 1 (index 0) is: ");
//    Serial.println(tempC);
//    
//  } 
//  else
//  {
//    Serial.println("Error: Could not read temperature data");
//  }
//    
////  Serial.print("Temperature: ");
////  Serial.print(tempC);    // print the temperature in °C
////  Serial.print("°C");
////  Serial.print("  ~  ");  // separator between °C and °F
////  Serial.print(tempF);    // print the temperature in °F
////  Serial.println("°F");
//  delay(500);
//}

#include <CircularBuffer.h>
#include <MAX30100.h>
#include <MAX30100_BeatDetector.h>
#include <MAX30100_Filters.h>
#include <MAX30100_PulseOximeter.h>
#include <MAX30100_Registers.h>
#include <MAX30100_SpO2Calculator.h>
#include <OneWire.h>
#include <DallasTemperature.h>

#define SENSOR_PIN  21


//#pragma once
#include <string>
#include <WiFi.h>
#include <iostream>
#include <PubSubClient.h>
#include <Wire.h>
#include "values.h"

#define DELAY 500

const char *mqtt_broker = "192.168.29.24";
const char *topic = "esp32/test";
const char *mqtt_username = "Chauhan";
const char *mqtt_password = "public";
const int mqtt_port = 1883;

uint32_t tsLastReport = 0;

float tempF; // temperature in Fahrenheit
float tempC; // temperature in Celsius
float BPM, SpO2;

bool temp_res;

OneWire oneWire(SENSOR_PIN);
DallasTemperature DS18B20(&oneWire);
WiFiClient espClient;
PubSubClient client(espClient);
PulseOximeter pulseOxymeter;

void ConnectToWiFi()
{
  WiFi.mode(WIFI_STA);
  WiFi.begin(SSID, PASS);
  Serial.println("Connecting to Wifi...");
  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print("connecting... \n");
    delay(500);
  }
  Serial.print("Connected. My IP address is:");
  Serial.println(WiFi.localIP());
}

void callback(char *topic, byte *payload, unsigned int length) {
 Serial.print("Message arrived in topic: ");
 Serial.println(topic);
 Serial.print("Message:");
 for (int i = 0; i < length; i++) {
     Serial.println((char) payload[i]);
 }
 Serial.println();
 Serial.println("-----------------------");
}

void connecttoMQTT() {
  client.setServer(mqtt_broker, mqtt_port);
  client.setCallback(callback);
  while (!client.connected())
  {
    String client_id = "esp32-client-";
    client_id += String(WiFi.macAddress());
    Serial.printf("The client %s connects to the public mqtt broker\n", client_id.c_str());
    if (client.connect(client_id.c_str(), mqtt_username, mqtt_password)) {
        Serial.println("Public mosquitto mqtt broker connected");
    }
    else
    {
      Serial.print("failed with state ");
      Serial.println(client.state());
      delay(2000);
    }
  }
}

void onBeatDetected() {
    Serial.println("Beat Detected!");
}

void initOxymeter() {
  Wire.begin();
  Serial.println("Testing MAX30100");
  if (!pulseOxymeter.begin()) {
      Serial.println("FAILED");
      for(;;);
  } else {
      Serial.println("SUCCESS");
  }
  pulseOxymeter.setOnBeatDetectedCallback(onBeatDetected);
  pinMode(21, OUTPUT);
}

void setup() {
  Wire.begin();
  Serial.begin(512000);
  while(!Serial);
  ConnectToWiFi();
  connecttoMQTT();
  DS18B20.begin();
//  initOxymeter();
}

void senseTemperature() {
  DS18B20.requestTemperatures();       // send the command to get temperatures
  tempC = DS18B20.getTempCByIndex(0);  // read temperature in °C
  tempF = DS18B20.getTempFByIndex(0);

  if(tempC != DEVICE_DISCONNECTED_C) {
    
    Serial.print("Temperature for the device 1 (index 0) is: ");
    Serial.println(tempC);
    String payload_temp;
    payload_temp += tempC;
    //char* s = (char*) tempC;
    //temp_res = client.publish("Temperature", s);
    temp_res = client.publish("Temperature", (char*) payload_temp.c_str());

    if (temp_res) {
      Serial.println("Published Succesfully.");
    }
  } 
  else {
    Serial.println("Error: Could not read temperature data");
  }
}

void loop() {
//  pulseOxymeter.update();
//  if (millis() - tsLastReport > REPORTING_PERIOD_MS) {
//    Serial.print("Heart rate:");
//    Serial.print(pulseOxymeter.getHeartRate());
//    Serial.print("BPM / SPO2:");
//    Serial.print(pulseOxymeter.getSpO2());
//    Serial.println("%");
// 
//    tsLastReport = millis();
//  }
  senseTemperature();
  delay(DELAY);
}
