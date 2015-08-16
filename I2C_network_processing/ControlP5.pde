
////////// Customiz the menu
void customize( DropdownList ddl ) {
  String available_output[];
  int temHeight = 30;

  ddl.setBarHeight( temHeight );
  ddl.setItemHeight( temHeight );
  // ddl.setBackgroundColor( 0 );

  if ( ddl == p1 ) {
    ddl.setCaptionLabel( "USB PORT" );
    for ( int i=0; i<Serial.list().length; i++ ) {
      String portName = Serial.list()[ i ];
      p1.addItem( portName, i );
    }
    //ddl.setSize( 245, Serial.list().length * temHeight );  //
  }

  if ( ddl == p2 ) {
    ddl.setCaptionLabel( "MIDI PORT" );
    available_output = MidiBus.availableOutputs(); //Returns an array of available input devices
    for ( int i=0; i<available_output.length; i++ ) {
      String portName = available_output[ i ];
      p2.addItem( portName, i );
    }
    ddl.setSize( 250, available_output.length * temHeight );  //
  }

  ddl.close();
}

////////// Get the port number 
void controlEvent( ControlEvent theEvent ) {
  int BAUD_RATE = 115200;
  int portValue = 0;
  String USB_PORT = "-1";
  String MIDI_PORT = "-1";

  if ( theEvent.isController() ) {

    //////////////////////////////////////////////////////////// USB PORT
    if ( theEvent.controller().getName() == "usbPort" ) {
      portValue = ( int ) theEvent.controller().getValue();
      USB_PORT = Serial.list()[ portValue ];

      if ( DISPLAY_MENU ) {
        try {
          myPort = new Serial( this, USB_PORT, BAUD_RATE );
          DISPLAY_MENU = false;
          println( "USB_DEVICES : " + DEVICES );
          myPort.write( DEVICES );
          p1.setBackgroundColor( 0 );
          // load( FILE ); // BUGGED
        } 
        catch ( Exception e ) {
          DISPLAY_MENU = true;
          fill( 255, 0, 0 );
          textAlign( CENTER );
          textSize( X_SCREN_SIZE/8 );
          text("WRONG USB", X_SCREN_SIZE/2, Y_SCREN_SIZE/2 );
          println( portValue + " WRONG USB PORT" );
        }
      }
    }

    //////////////////////////////////////////////////////////// MIDI PORT
    if ( theEvent.controller().getName() == "midiPort" ) {
      portValue = ( int ) theEvent.controller().getValue();
      MIDI_PORT = MidiBus.availableOutputs()[ portValue ];

      if ( DISPLAY_MENU ) {
        try {
          myBus = new MidiBus( this, -1, MIDI_PORT ); // Create a new MidiBus with no input device and one output device.
          println( "MIDI_DEVICES : " + DEVICES );
          p2.setBackgroundColor( 0 );
        }
        catch ( Exception e ) {
          fill( 255, 0, 0 );
          textAlign( CENTER );
          textSize( X_SCREN_SIZE/8 );
          text("WRONG MIDI", X_SCREN_SIZE/2, Y_SCREN_SIZE/2 );
          println( portValue + " WRONG MIDI PORT" );
        }
      }
    }
  }
}