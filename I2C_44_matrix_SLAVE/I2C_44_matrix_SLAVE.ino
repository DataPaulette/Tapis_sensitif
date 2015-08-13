// Maurin Donneaud : maurin@datapaulette.org
// 4x4 e-textile matrix for Arduino I2C bus based
// I2C bus based A4 (SDA), A5 (SCL)
// licence GPL V2.0
// Arduino Pro or Pro Mini
// ATmega328 (3.3V 8MHz)

#include <Wire.h>

#define  BAUD_RATE         115200
#define  NODE_ADDRESS      0 // Change this unique address for each I2C slave node

#define  ROWS              3
#define  COLS              3
#define  PAYLOAD_SIZE      ROWS*COLS*2 // bytes expected to be received by the master I2C master
#define  LED_PIN           13
#define  I2C_SLAVE_START   33
#define  FRAME_RATE        30
#define  DIL_SWITCH        7


byte incomingByte = 0;
byte nodePayload[ PAYLOAD_SIZE ];

// digital pins array
const int dilSwitch[ DIL_SWITCH ] = {
  10, 11, 12, 2, 3, 4, 5
};

// Dig pins array
const int rowPins[ ROWS ] = {
  6, 7, 8
};

// Analog pins array
const int columnPins[ COLS ] = {
  A1, A2, A3 };

unsigned long lastFrameTime = 0;
int value = 0;

boolean RUN = false;
boolean toggleLed = false;
boolean USB_TRANSMIT = false;

/////////////////////// INITIALISATION
void setup() {

  pinMode( LED_PIN, OUTPUT );          // Set rows pins in high-impedance state

  if ( USB_TRANSMIT ) Serial.begin( BAUD_RATE );              // start serial for output
  if ( !USB_TRANSMIT ) Wire.begin( NODE_ADDRESS );          // join i2c bus with address #8
  if ( !USB_TRANSMIT ) Wire.onRequest( requestEvent );     // register event

  for ( int i = 0; i < ROWS; i++ ) {
    pinMode( rowPins[ i ], INPUT );    // Set rows pins in high-impedance state
  }
  
  for ( int i = 0; i < DIL_SWITCH; i++ ) {
    pinMode( dilSwitch[ i ], INPUT_PULLUP ); // Set dilSwitch pins as input and activate pullUps resistors
  }
  
  blinkBlink( 15 );
}

//////////////////////////////////////////////////////////// BOUCLE PRINCIPALE
void loop() {
  /*
   if ( Wire.available() > 0 ) {
      incomingByte = Wire.read();
     if ( incomingByte == I2C_SLAVE_START );
     digitalWrite( LED_PIN, HIGH );
     RUN = true;
   }
  */

  if ( ( millis() - lastFrameTime ) >= FRAME_RATE ) {
    lastFrameTime = millis();

    for ( int row = 0; row < ROWS; row++ ) {
      // Set row pin as output (+3V)
      pinMode( rowPins[ row ], OUTPUT );
      digitalWrite( rowPins[ row ], HIGH );

      for ( int column = 0; column < COLS; column++ ) {

        int sensorID = row * COLS + column;
        sensorID = sensorID * 2;

        value = analogRead( columnPins[ column ] );
        // value = 1023; // use to DEBUG

        nodePayload[ sensorID ] = value & B01111111;                // lowByte
        nodePayload[ sensorID + 1 ] = ( value >> 7 ) & B00000111;   // highByte

        if ( USB_TRANSMIT ) Serial.print( value ), Serial.print( '\t' );
      }
      // Set row pin in high-impedance state
      pinMode(rowPins[ row ], INPUT);
      if ( USB_TRANSMIT ) Serial.println();
    }
    if ( USB_TRANSMIT ) Serial.println();
  }
}

// function that executes whenever data is requested by master
// this function is registered as an event, see setup()
void requestEvent() {
  Wire.write( nodePayload, PAYLOAD_SIZE );
}

void blinkBlink( int times ) {
  for ( int i = 0; i < times; i++ ) {
    digitalWrite( LED_PIN, toggleLed );
    delay( 80 );
    toggleLed = !toggleLed;
  }
}

