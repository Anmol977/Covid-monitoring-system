#pragma once
#include <WiFi.h>
#include <iostream>
#include "values.h"
#include <PubSubClient.h>
#include <Wire.h>
#include "MAX30100_PulseOximeter.h"

const char *mqtt_broker = "192.168.0.104";
const char *topic = "esp32/test";
const char *mqtt_username = "Chauhan";
const char *mqtt_password = "public";
const int mqtt_port = 1883;

#define REPORTING_PERIOD_MS 1000
float BPM, SpO2;

PulseOximeter pox;
uint32_t tsLastReport = 0;

WiFiClient espClient;
PubSubClient client(espClient);

char *SSID = WIFISSID;
char *PASS = WIFIPASS;

void ConnectToWiFi()
{
  WiFi.mode(WIFI_STA);
  WiFi.begin(SSID, PASS);
  Serial.print("Connecting to Wifi \n");
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
    Serial.print((char)payload[i]);
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
      Serial.println("Public mosquitto mqtt broker connected \n");
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

void setup()
{
  Wire.begin();
  Serial.begin(512000);
  while(!Serial);
  ConnectToWiFi();
  connecttoMQTT();
  if (!pox.begin())
    {
         Serial.println("FAILED");
         for(;;);
    }
    else
    {
         Serial.println("SUCCESS");
         pox.setOnBeatDetectedCallback(onBeatDetected);
    }
}

void loop()
{
   pox.update();
   BPM = pox.getHeartRate();
    if (millis() - tsLastReport > REPORTING_PERIOD_MS)
    {
        Serial.print("Heart rate:");
        Serial.print(BPM);
        Serial.print(" bpm / SpO2:");
        Serial.print(SpO2);
        Serial.println(" %");
        tsLastReport = millis();
    }
}
