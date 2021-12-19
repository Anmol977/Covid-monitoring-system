#include <string>
#include <WiFi.h>
#include <Wire.h>
#include "values.h"
#include <iostream>
#include <OneWire.h>
#include <MAX30100.h>
#include <PubSubClient.h>
#include <CircularBuffer.h>
#include <MAX30100_Filters.h>
#include <DallasTemperature.h>
#include <MAX30100_Registers.h>
#include <MAX30100_BeatDetector.h>
#include <MAX30100_PulseOximeter.h>
#include <MAX30100_SpO2Calculator.h>

#define DELAY 500
#define SENSOR_PIN 21

uint32_t tsLastReport = 0;
const int mqtt_port = 1883;
const char *topic = "esp32/test";
const char *mqtt_password = "public";
const char *mqtt_username = "Chauhan";
const char *mqtt_broker = "192.168.29.24";

float tempF; // temperature in Fahrenheit
float tempC; // temperature in Celsius
float BPM, SpO2;

bool temp_res;

WiFiClient espClient;
OneWire oneWire(SENSOR_PIN);
PulseOximeter pulseOxymeter;
PubSubClient client(espClient);
DallasTemperature DS18B20(&oneWire);

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

void callback(char *topic, byte *payload, unsigned int length)
{
  Serial.print("Message arrived in topic: ");
  Serial.println(topic);
  Serial.print("Message:");
  for (int i = 0; i < length; i++)
  {
    Serial.println((char)payload[i]);
  }
  Serial.println();
  Serial.println("-----------------------");
}

void connecttoMQTT()
{
  client.setServer(mqtt_broker, mqtt_port);
  client.setCallback(callback);
  while (!client.connected())
  {
    String client_id = "esp32-client-";
    client_id += String(WiFi.macAddress());
    Serial.printf("The client %s connects to the public mqtt broker\n", client_id.c_str());
    if (client.connect(client_id.c_str(), mqtt_username, mqtt_password))
    {
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

void onBeatDetected()
{
  Serial.println("Beat Detected!");
}

void initOxymeter()
{
  Wire.begin();
  Serial.println("Testing MAX30100");
  if (!pulseOxymeter.begin())
  {
    Serial.println("FAILED");
    for (;;)
      ;
  }
  else
  {
    Serial.println("SUCCESS");
  }
  pulseOxymeter.setOnBeatDetectedCallback(onBeatDetected);
  pinMode(21, OUTPUT);
}

void setup()
{
  Wire.begin();
  Serial.begin(512000);
  while (!Serial)
    ;
  ConnectToWiFi();
  connecttoMQTT();
  DS18B20.begin();
}

void senseTemperature()
{
  DS18B20.requestTemperatures();
  tempC = DS18B20.getTempCByIndex(0);
  tempF = DS18B20.getTempFByIndex(0);

  if (tempC != DEVICE_DISCONNECTED_C)
  {

    Serial.print("Temperature for the device 1 (index 0) is: ");
    Serial.println(tempC);
    String payload_temp;
    payload_temp += tempC;
    temp_res = client.publish("Temperature", (char *)payload_temp.c_str());

    if (temp_res)
    {
      Serial.println("Published Succesfully.");
    }
  }
  else
  {
    Serial.println("Error: Could not read temperature data");
  }
}

void loop()
{
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
