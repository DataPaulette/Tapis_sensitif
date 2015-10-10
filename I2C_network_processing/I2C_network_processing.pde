// Maurin Donneaud : maurin@datapaulette.org

import processing.serial.*;
import controlP5.*;
import themidibus.*;

Serial               myPort;        // Create object from menu class
ControlP5            cp5;           // Create object from menu class
DropdownList         p1;            // Create object from menu class
DropdownList         p2;            // Create object from menu class
MidiBus              outgoing;      // Create object from menu class

int X_SCREN_SIZE =   0;
int Y_SCREN_SIZE =   0;

int X_MATRIX =       0;
int Y_MATRIX =       0;
int PIX_SIZE =       0;
int PADDING =        0;  // space between each button
int MARGIN =         0;  // space between each matrix
int OFFSET =         0;
int THRESHOLD =      0;

int ROWS =           3;  // DO NOT CHANGE
int COLS =           3;  // DO NOT CHANGE
int DEVICES =        0;
int posX =           0;  // X matrix position
int posY =           0;  // Y matrix position
int menuXsize =      256;

PFont font;
Table table;
String FILE = "saved.csv";

Selector selector = new Selector( );

int[][] colors = {
 { 250, 250, 250 }, 
 { 0, 150, 150 }, 
 { 100, 10, 180 }, 
 { 0, 220, 50 }, 
 { 255, 250, 0 }, 
 { 255, 0, 200 }
};
 
sensorMatrix sMatrix[];

char MODE = 'H';
boolean DISPLAY_MATRIX = false;
boolean DEBUG_SENSOR_VALUES = false;
boolean DEBUG_SENSOR_ID = false;
boolean DEBUG_SENSOR_POS = false;
boolean DEBUG_SWITCH = false;
boolean DEBUG_CONFIG = false;
// boolean MIDI = true;

/////////////////////////////////////////////// SETUP
void setup() {

  surface.setTitle( "Tapis Sensitif - V1.2 - Design dy DATAPAULETTE" );
  codeSetup(); // Read values from XML config file  

  X_SCREN_SIZE = X_MATRIX*COLS*PIX_SIZE + X_MATRIX*( COLS-1 )*PADDING + ( X_MATRIX-1 )*MARGIN + OFFSET;
  Y_SCREN_SIZE = Y_MATRIX*ROWS*PIX_SIZE + Y_MATRIX*( ROWS-1 )*PADDING + ( Y_MATRIX-1 )*MARGIN + OFFSET;
  size( 800, 600 );
  // surface.setSize( X_SCREN_SIZE, Y_SCREN_SIZE );

  selector.setPos( 10, 3 );

  // Setup the save file
  table = new Table();
  table.addColumn( "id" );
  table.addColumn( "idX" );
  table.addColumn( "idY" );
  table.addColumn( "Value" );

  DEVICES = X_MATRIX * Y_MATRIX;

  font = createFont( "arial", PIX_SIZE/2 );
  frameRate( 20 );
  textFont( font );

  cp5 = new ControlP5( this );
  p1 = cp5.addDropdownList( "usbPort" );
  setupMenu( p1 );
  p2 = cp5.addDropdownList( "midiPort" );
  setupMenu( p2 );

  sMatrix = new sensorMatrix[ DEVICES ]; // Tableau de matrices de capteurs

  for ( int id=0; id<DEVICES; id++ ) {
    sMatrix[ id ] = new sensorMatrix( id );
  }
  outgoing.list();
}

/////////////////// LOOP
void draw() {
  
  if ( MODE == 'R' ) background( 150, 10, 100 );
  if ( MODE == 'P' ) background( 10, 189, 60 );
  
  for ( int id=0; id<DEVICES; id++ ) {
    sMatrix[ id ].update();
    sMatrix[ id ].display();
  }
  selector.display();
  
  if ( MODE == 'H' ) howTo();
}

void mousePressed() {

  int mX = mouseX;
  int mY = mouseY;

  if ( DISPLAY_MATRIX ) {
    for ( int id=0; id<DEVICES; id++ ) {
      sMatrix[ id ].onClic( mX, mY );
    }
    selector.onClic( mX, mY );
  }
}

void keyPressed() {

  if ( key == 'H' ) { // Display the help menu
    MODE = 'H';
    DISPLAY_MATRIX = false;
    p1.show();
    p2.show();
    println( "HELP MODE" );
  }
  if ( key == 'R' ) { // Record mode for the mapping
    MODE = 'R';
    DISPLAY_MATRIX = true;
    p1.hide();
    p2.hide();
    selector.show();
    rec();
  }
  if ( key == 'P' ) { // Set play mode
    MODE = 'P';
    DISPLAY_MATRIX = true;
    p1.hide();
    p2.hide();
    selector.hide();
    play();
  }
  if ( key == 'L' ) { // Lode saved file
    load( FILE );
  }
  if ( key == 'S' ) { // Save the mapping
    save( FILE );
  }
}