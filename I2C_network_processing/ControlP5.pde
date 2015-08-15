
////////// Customiz the menu
void customize( DropdownList ddl, String name ) {
  ddl.setBackgroundColor( 255 );
  ddl.setBarHeight( 25 ); // test
  ddl.setItemHeight( 25 );
  ddl.setCaptionLabel( name );
}

////////// Get the port number 
void controlEvent( ControlEvent theEvent ) {
  int BAUD_RATE = 115200;
  int portValue = 0;
  String USB_PORT = "";

  if ( theEvent.isController() ) {

    if ( theEvent.controller().getName() == "usbPort" ) {
      portValue = ( int ) theEvent.controller().getValue();
      USB_PORT = Serial.list()[ portValue ];

      if ( DISPLAY_MENU ) {
        try {
          myPort = new Serial( this, USB_PORT, BAUD_RATE );
          DISPLAY_MENU = false;
          println( "DEVICES : " + DEVICES );
          myPort.write( DEVICES );
          // load( FILE ); // BUGGED
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
    if ( theEvent.controller().getName() == "midiPort" ) {
    }
  }
}