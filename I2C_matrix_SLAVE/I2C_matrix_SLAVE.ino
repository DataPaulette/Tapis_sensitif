// Maurin Donneaud : maurin@datapaulette.org
// 4x4 e-textile matrix for Arduino I2C bus based
// I2C bus based A4 (SDA), A5 (SCL)
// licence GPL V2.0
// Arduino Pro or Pro Mini
// ATmega328 (5V - 16MHz)

#include <elapsedMillis.h>
#include <Wire.h>

elapsedMillis elapsedTime; // declare global if you don't want it reset every time loop runs

#define  BAUD_RATE         115200

#define  ROWS              3           // define how many rows on the matrix sensor
#define  COLS              3           // define how many columns on the matrix sensor
#define  PAYLOAD_SIZE      ROWS*COLS*2 // bytes expected to be received by the master I2C master
#define  LED_PIN           13          // define the LED pin
#define  FRAME_RATE        5           // elapsed time between each sensor reading
#define  DIL_SWITCH        7           // number of switchis on the DIL-switch

byte  NODE_ADDRESS  =      0;          // set a unique address for each I2C slave node
byte incomingByte = 0;
byte nodePayload[ PAYLOAD_SIZE ];

// digital pins array
const int dilSwitch[ DIL_SWITCH ] = {
  10, 11, 12, 2, 3, 4, 5
};

// Dig pins array
const int rowPins[ ROWS ] = {
  8, 7, 6
  // 6, 7, 8
};

// Analog pins array
const int columnPins[ COLS ] = {
  A1, A2, A3
  // A3, A2, A1
};

unsigned long lastFrameTime = 0;
int value = 0;

boolean toggleLed = false;
boolean USB_TRANSMIT = false;
boolean DEBUG_NODE_ADDRESS = false;

/////////////////////// INITIALISATION
void setup() {

  pinMode( LED_PIN, OUTPUT );          // Set rows pins in high-impedance state
  if ( USB_TRANSMIT ) Serial.begin( BAUD_RATE );            // start serial for output

  for ( int i = 0; i < DIL_SWITCH; i++ ) {
    pinMode( dilSwitch[ i ], INPUT_PULLUP ); // Set dilSwitch pins as input and activate pullUps resistors
  }
  setNodeID();

  if ( !USB_TRANSMIT ) Wire.begin( NODE_ADDRESS );          // join i2c bus with address #8
  if ( !USB_TRANSMIT ) Wire.onRequest( requestEvent );      // register event

  for ( int i = 0; i < ROWS; i++ ) {
    pinMode( rowPins[ i ], INPUT );    // Set rows pins in high-impedance state
  }

  blinkBlink( 21 );
}

//////////////////////////////////////////////////////////// BOUCLE PRINCIPALE
void loop() {

  for ( int row = 0; row < ROWS; row++ ) {
    // Set row pin as output (+3V)
    pinMode( rowPins[ row ], OUTPUT );
    digitalWrite( rowPins[ row ], HIGH );

    for ( int column = 0; column < COLS; column++ ) {

      if ( elapsedTime >= FRAME_RATE ) {
        elapsedTime = 0;              // reset the counter to 0 so the counting starts over...

        // int sensorID = row * COLS + column;
        // sensorID = sensorID * 2;

        int sensorID = column * ROWS + row;
        sensorID = sensorID * 2;

        value = analogRead( columnPins[ column ] );

        nodePayload[ sensorID ] = value & B01111111;                // lowByte
        nodePayload[ sensorID + 1 ] = ( value >> 7 ) & B00000111;   // highByte

        if ( USB_TRANSMIT ) Serial.print( value ), Serial.print( '\t' );
      }
    }
    // Set row pin in high-impedance state
    pinMode( rowPins[ row ], INPUT );
    if ( USB_TRANSMIT ) Serial.println();
  }
  if ( USB_TRANSMIT ) Serial.println();
}

// function that executes whenever data is requested by master
// this function is registered as an event, see setup()
void requestEvent() {
  Wire.write( nodePayload, PAYLOAD_SIZE );
}

void blinkBlink( int times ) {
  for ( int i = 0; i < times; i++ ) {
    digitalWrite( LED_PIN, toggleLed );
    delay( 60 );
    toggleLed = !toggleLed;
  }
}

void setNodeID() {

  for ( int i = 0; i < DIL_SWITCH; i++) {

    int bitVal = digitalRead( dilSwitch[ i ] );

    if ( bitVal == HIGH) {
      bitClear( NODE_ADDRESS, i );
    } else {
      bitSet( NODE_ADDRESS, i );
    }
  }
  if ( DEBUG_NODE_ADDRESS ) Serial.println( NODE_ADDRESS );
}

