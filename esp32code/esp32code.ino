#include <string>
#include <WiFi.h>
#include <Wire.h>
#include "values.h"
#include "MAX30100_PulseOximeter.h"
#include <iostream>
#include <OneWire.h>
#include <PubSubClient.h>
#include <DallasTemperature.h>

#define DELAY 3000
#define SENSOR_PIN 19
#define REPORTING_PERIOD_MS 1000

uint32_t tsLastReport = 0;
const int mqtt_port = 1883;
const char *topic = "temperature";
const char *mqtt_password = "public";
const char *mqtt_username = "Chauhan";
const char *mqtt_broker = "192.168.0.121";

float tempF; // temperature in Fahrenheit
float tempC; // temperature in Celsius
float BPM, SpO2;

bool temp_res;

WiFiClient espClient;
OneWire oneWire(SENSOR_PIN);
PubSubClient client(espClient);
DallasTemperature DS18B20(&oneWire);
PulseOximeter pox;

void ConnectToWiFi()
{
  WiFi.mode(WIFI_STA);
  WiFi.begin(SSID, PASS);
  Serial.println("Connecting to Wifi...");
  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print("connecting... \n");
    delay(1000);
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

void setup()
{
  Wire.begin();
  Serial.begin(500000);
  while (!Serial);
  ConnectToWiFi();
  connecttoMQTT();
  DS18B20.begin();
  Serial.print("Initializing pulse oximeter..");
 
  if (!pox.begin()) {
    Serial.println("FAILED");
    for(;;);
  } else {
    Serial.println("SUCCESS");
  }

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
    temp_res = client.publish(topic, (char *)payload_temp.c_str());

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
  senseTemperature();
  delay(DELAY);
  pox.update();
  if (millis() - tsLastReport > REPORTING_PERIOD_MS) {
    Serial.print("Heart rate:");
    Serial.print(pox.getHeartRate());
    Serial.print("bpm / SpO2:");
    Serial.print(pox.getSpO2());
    Serial.println("%");
     
    tsLastReport = millis();
  }
}

void onBeatDetected()
{
   Serial.println("Beat!");
}
