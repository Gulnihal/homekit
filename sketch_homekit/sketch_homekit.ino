#include <WiFi.h>
#include <WebServer.h>
#include <DHT.h>
#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_TSL2561_U.h>
#include <Adafruit_NeoPixel.h>
#include "pitches.h"

#define DHTPIN 4
#define DHTTYPE DHT11
#define LED_PIN 14
#define NUM_LEDS 8
#define buzzer 27
#define HEARTBEAT_PIN 16
#define gaz_sensor 33
#define MAX_ENTRIES 50  // Bellek siniri

String dataLog[MAX_ENTRIES];
int logIndex = 0;

DHT dht(DHTPIN, DHTTYPE);
Adafruit_NeoPixel strip = Adafruit_NeoPixel(NUM_LEDS, LED_PIN, NEO_GRB + NEO_KHZ800);

volatile int pulseCount = 0;
int pulseRate = 0;
unsigned long lastPulseTime = 0;
const unsigned long measureInterval = 10000;  // 10 saniye

const char* ssid = "HONOR";
const char* password = "misio1234";
WebServer server(80);

// Statik IP ayarlari 
IPAddress local_IP(192, 168, 111, 226);
IPAddress gateway(192, 168, 111, 202);
IPAddress subnet(255, 255, 255, 0);
IPAddress primaryDNS(8, 8, 8, 8);   //optional
IPAddress secondaryDNS(8, 8, 4, 4); //optional

void IRAM_ATTR detectHeartbeat() {
  pulseCount++;
}

void addDataToLog(float temp, float hum, int pulse, int gas) {
  String entry = "{";
  entry += "\"temp\":" + String(temp, 1) + ",";
  entry += "\"hum\":" + String(hum, 1) + ",";
  entry += "\"pulse\":" + String(pulse) + ",";
  entry += "\"gas\":" + String(gas);
  entry += "}";

  // FIFO mantığı: doluysa en eskiyi kaydır
  if (logIndex < MAX_ENTRIES) {
    dataLog[logIndex++] = entry;
  } else {
    for (int i = 1; i < MAX_ENTRIES; i++) {
      dataLog[i - 1] = dataLog[i];
    }
    dataLog[MAX_ENTRIES - 1] = entry;
  }
}

void setup() {
  Serial.begin(115200);
  WiFi.disconnect(true);// Önceki WiFi yapılandırmasını temizle
  delay(1000);  // Seri haberleşme açılması için küçük bekleme
  Serial.println("=== Cihaz Basladi ===");

  // Statik IP ayarla
  if (!WiFi.config(local_IP, gateway, subnet, primaryDNS, secondaryDNS)) {
    Serial.println("⚠️ IP konfigurasyonu basarisiz.");
  } else {
    Serial.println("✅ IP konfigurasyonu basarili!");
  }

  //Wifi agina baglan
  WiFi.begin(ssid, password);
  Serial.println("📶 Wi-Fi baglantisi deneniyor...");

  int attempt = 0;
  while (WiFi.status() != WL_CONNECTED && attempt < 20) {
    delay(500);
    Serial.print(".");
    attempt++;
  }

  //SONUC
  if (WiFi.status() == WL_CONNECTED) {
    Serial.println("\n✅ Wi-Fi baglantisi kuruldu!");
  } else {
    Serial.println("\n❌ Baglanti basarisiz!");
  }
  Serial.print("IP adresi: ");
  Serial.println(WiFi.localIP());

  dht.begin();
  pinMode(buzzer, OUTPUT);
  pinMode(HEARTBEAT_PIN, INPUT_PULLUP);
  pinMode(gaz_sensor, INPUT);
  strip.begin();
  strip.show();

  attachInterrupt(digitalPinToInterrupt(HEARTBEAT_PIN), detectHeartbeat, RISING);

  // Web Server endpointleri
  server.on("/data", HTTP_GET, []() {
    String json = "[";
    for (int i = 0; i < logIndex; i++) {
      json += dataLog[i];
      if (i < logIndex - 1) json += ",";
    }
    json += "]";
    server.send(200, "application/json", json);
  });

  server.on("/led/on", HTTP_GET, []() {
    setColor(0, 0, 255);
    server.send(200, "text/plain", "LED ON");
  });

  server.on("/led/off", HTTP_GET, []() {
    setColor(0, 0, 0);
    server.send(200, "text/plain", "LED OFF");
  });

  server.begin();
}

void loop() {
  server.handleClient();

  unsigned long currentTime = millis();
  if (currentTime - lastPulseTime >= measureInterval) {
    lastPulseTime = currentTime;
    pulseRate = pulseCount * (60000 / measureInterval);
    pulseCount = 0;
  }

  float temperature = dht.readTemperature();
  float humidity = dht.readHumidity();
  int gaz = analogRead(gaz_sensor);

  addDataToLog(temperature, humidity, pulseRate, gaz);

  if (temperature >= 30 || gaz >= 150) {
    Serial.print("Alarm aktif. ");
    Serial.print("-> Sicaklik: ");
    Serial.print(temperature);
    Serial.print(", Gaz: ");
    Serial.print(gaz);
    Serial.print(", Nem: ");
    Serial.print(humidity);
    Serial.print(", Nabiz: ");
    Serial.println(pulseRate);
    playMelody();
    delay(5000);
  }

  delay(1000);
}

// WS2812 LED kontrol fonksiyonu
void setColor(int r, int g, int b) {
  for (int i = 0; i < NUM_LEDS; i++) {
    strip.setPixelColor(i, strip.Color(r, g, b));
  }
  strip.show();
}

// Buzzer melodisi
void playMelody() {
  int melody[] = {NOTE_E5, NOTE_E5, REST, NOTE_E5};
  int durations[] = {8, 8, 8, 8};
  int size = sizeof(durations) / sizeof(int);

  for (int i = 0; i < size; i++) {
    int duration = 1000 / durations[i];
    tone(buzzer, melody[i], duration);
    delay(duration * 1.3);
  }
  noTone(buzzer);
} 
