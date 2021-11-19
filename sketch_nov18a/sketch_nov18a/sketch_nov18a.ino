#pragma once
#include<WiFi.h>
#include<iostream>
#include"values.h"
#include <PubSubClient.h>

const char *mqtt_broker = "192.168.0.104";
const char *topic = "esp32/test";
const char *mqtt_username = "Chauhan";
const char *mqtt_password = "public";
const int mqtt_port = 1883;

IPAddress server(192, 168, 1, 200);

WiFiClient espClient;
PubSubClient client(espClient);

char *SSID = WIFISSID;
char *PASS = WIFIPASS;

void ConnectToWiFi()
{
  WiFi.mode(WIFI_STA);
  WiFi.begin(SSID,PASS);
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
     Serial.print((char) payload[i]);
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
        Serial.print(client.state());
        delay(2000);
    }
}
}

void setup() {
  Serial.begin(512000);
  ConnectToWiFi();
  connecttoMQTT();
}

void loop() {

}
