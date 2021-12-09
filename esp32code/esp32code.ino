#include <CircularBuffer.h>
#include <MAX30100.h>
#include <MAX30100_BeatDetector.h>
#include <MAX30100_Filters.h>
#include <MAX30100_PulseOximeter.h>
#include <MAX30100_Registers.h>
#include <MAX30100_SpO2Calculator.h>

//#pragma once
#include <string.h>
#include <WiFi.h>
#include <iostream>
#include <PubSubClient.h>
#include <Wire.h>

const char *mqtt_broker = "192.168.29.24";
const char *topic = "esp32/test";
const char *mqtt_username = "Chauhan";
const char *mqtt_password = "public";
const int mqtt_port = 1883;

uint32_t tsLastReport = 0;
uint32_t REPORTING_PERIOD_MS = 500;

WiFiClient espClient;
PubSubClient client(espClient);
PulseOximeter pulseOxymeter;

//std::string SSID = WIFISSID;
//std::string PASS = WIFIPASS;

void ConnectToWiFi()
{
  WiFi.mode(WIFI_STA);
  WiFi.begin("TAURUS.4G","12345678");
  Serial.print("Connecting to Wifi \n"); 
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

void connecttoMQTT(){
   client.setServer(mqtt_broker,mqtt_port);
  client.setCallback(callback);
  while (!client.connected()) {
    String client_id = "esp32-client-";
    client_id += String(WiFi.macAddress());
    Serial.printf("The client %s connects to the public mqtt broker\n", client_id.c_str());
    if (client.connect(client_id.c_str(), mqtt_username, mqtt_password)) {
        Serial.println("Public mosquitto mqtt broker connected");
    } else {
        Serial.print("failed with state ");
        Serial.println(client.state());
        delay(2000);
    }
}
}

void onBeatDetected() {
  Serial.println("BEEP");
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
  Serial.begin(512000);
  ConnectToWiFi();
  connecttoMQTT();
  initOxymeter();
}

void loop() {
  pulseOxymeter.update();
  if (millis() - tsLastReport > REPORTING_PERIOD_MS) {
    Serial.print("Heart rate:");
    Serial.print(pulseOxymeter.getHeartRate());
    Serial.print("BPM / SPO2:");
    Serial.print(pulseOxymeter.getSpO2());
    Serial.println("%");
 
    tsLastReport = millis();
  }
}
