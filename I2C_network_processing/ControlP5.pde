
////////// Customiz the menu
void customize( DropdownList ddl ) {
  ddl.setBackgroundColor( 255 );
  ddl.setBarHeight( 25 ); // test
  ddl.setItemHeight( 25 );
  ddl.setCaptionLabel( " USB Port " );

  // ddl.captionLabel().style().marginTop = 3; // bug with processing 3.*
  // ddl.captionLabel().style().marginLeft = 3; // bug with processing 3.*
  // ddl.valueLabel().style().marginTop = 3; // bug with processing 3.*
  
  for ( int i=0; i<Serial.list ().length; i++ ) {
    String portName = Serial.list()[ i ];
    ddl.addItem( portName, i );
  }
  // ddl.setColorBackground( 50 );
  // ddl.setColorActive( color( 255 ) );
}

////////// Get the port number 
void controlEvent( ControlEvent theEvent ) {
  int BAUD_RATE = 115200;
  int portValue = 0;
  String USB_PORT = "";

  if ( theEvent.isController() ) {
    portValue = ( int ) theEvent.controller().getValue();
    USB_PORT = Serial.list()[ portValue ];

    if ( DISPLAY_MENU ) {
      try {
        myPort = new Serial( this, USB_PORT, BAUD_RATE );
        DISPLAY_MENU = false;
        println( "DEVICES : " + DEVICES );
        myPort.write( DEVICES );
        // load( FILE );
      } 
      catch ( Exception e ) {
        DISPLAY_MENU = true;
        fill( 255, 0, 0 );
        textAlign( CENTER );
        textSize( X_SCREN_SIZE/8 );
        text("WRONG USB", X_SCREN_SIZE/2, Y_SCREN_SIZE/2 );
        println( portValue + " WRONG USB" );
      }
    }
  }
}