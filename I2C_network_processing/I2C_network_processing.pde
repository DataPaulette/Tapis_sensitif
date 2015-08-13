import processing.serial.*;
import themidibus.*;
import controlP5.*;

Serial               myPort;        // Create object from menu class
ControlP5            cp5;           // Create object from menu class
DropdownList         p1;            // Create object from menu class
MidiBus              myBus;         // Create object from menu class

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
String FILE = "saved_00.csv";

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

char MODE = 'P';
boolean DISPLAY_MENU = true;
boolean DEBUG_SENSOR_VALUES = false;
boolean DEBUG_SENSOR_ID = false;
boolean DEBUG_SENSOR_POS = false;
boolean DEBUG_SWITCH = false;
boolean DEBUG_CONFIG = true;
boolean MIDI = true;

/////////////////////////////////////////////// SETUP
void setup() {
  
  surface.setTitle( "Tapis Sensitif by DATAPAULETTE" );
  codeSetup();
  
  X_SCREN_SIZE = X_MATRIX*COLS*PIX_SIZE + X_MATRIX*( COLS-1 )*PADDING + ( X_MATRIX-1 )*MARGIN + OFFSET;
  Y_SCREN_SIZE = Y_MATRIX*ROWS*PIX_SIZE + Y_MATRIX*( ROWS-1 )*PADDING + ( Y_MATRIX-1 )*MARGIN + OFFSET;
  
  selector.setPos( 10, 3 );

  // Setup the save file
  table = new Table();
  table.addColumn( "id" );
  table.addColumn( "idX" );
  table.addColumn( "idY" );
  table.addColumn( "Value" );

  DEVICES = X_MATRIX * Y_MATRIX;

  // size( X_SCREN_SIZE, Y_SCREN_SIZE );
  size( 800, 600 );

  font = createFont( "arial", PIX_SIZE/2 );
  frameRate( 20 );
  textFont( font );

  cp5 = new ControlP5( this );
  
  p1 = cp5.addDropdownList( "myList-p1", X_SCREN_SIZE - menuXsize, 24, menuXsize, 127 );
  
  customize( p1 );

  sMatrix = new sensorMatrix[ DEVICES ]; // Tableau de matrices de capteurs

  for ( int id=0; id<DEVICES; id++ ) {
    sMatrix[ id ] = new sensorMatrix( id );
  }
  
  if ( MIDI ) MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  // if ( MIDI ) myBus = new MidiBus(this, -1, "Java Sound Synthesizer"); // Create a new MidiBus with no input device and the default Java Sound Synthesizer as the output device.

}

/////////////////// LOOP
void draw() {

  if ( DISPLAY_MENU ) {
    background( 200 );
    howTo();
  } else {
    p1.hide();
    
    if ( MODE == 'R' ) background( 10, 0, 0 );
    if ( MODE == 'P' ) background( 10, 255, 30 );

    for ( int id=0; id<DEVICES; id++ ) {
      sMatrix[ id ].update();
      sMatrix[ id ].display();
    }
    selector.display();
  }
}

void mousePressed() {
  
  int mX = mouseX;
  int mY = mouseY;

  if ( !DISPLAY_MENU ) {
    for ( int id=0; id<DEVICES; id++ ) {
      sMatrix[ id ].onClic( mX, mY );
    }
    selector.onClic( mX, mY );
  }
}

void keyPressed() {
  
  if ( key == 'H' ) { // Display the help menu
    DISPLAY_MENU = !DISPLAY_MENU;
  }
  if ( key == 'R' ) { // Record mode for the mapping
    rec();
  }
  if ( key == 'P' ) { // Set play mode
    play();
  }
  if ( key == 'L' ) { // Lode saved file
    load( FILE );
  }
  if ( key == 'S' ) { // Save the mapping
    save( FILE );
  }
}