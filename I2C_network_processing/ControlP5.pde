
////////// Setup the menu
void setupMenu( ScrollableList ddl ) {
  String available_output[];
  int itemHeight = 30;
  int itemWidth = 250;

  ddl.setBarHeight( itemHeight );
  ddl.setItemHeight( itemHeight );

  if ( ddl == p1 ) {
    ddl.setPosition( 0, 0); ////////////////////////////////////////////// ERROR
    ddl.setCaptionLabel( "USB PORT" );
    for ( int i=0; i<Serial.list ().length; i++ ) {
      String portName = Serial.list()[ i ];
      p1.addItem( portName, i );
    }  
    ddl.setSize( itemWidth, Serial.list().length/2 * itemHeight );  //
  }

  if ( ddl == p2 ) {
    ddl.setPosition( X_SCREN_SIZE - menuXsize, 0); ////////////////////////////////////////////// ERROR
    ddl.setCaptionLabel( "MIDI PORT" );
    available_output = outgoing.availableOutputs(); // Returns an array of available output devices
    for ( int i=0; i<available_output.length; i++ ) {
      String portName = available_output[ i ];
      p2.addItem( portName, i );
    }
    ddl.setSize( itemWidth, available_output.length * itemHeight + itemHeight );  //
  }
  ddl.setBackgroundColor( color(10, 15, 0) );
  ddl.setColorBackground( color(100, 105, 100) );
  ddl.close();
}

////////// Get the port number 
void controlEvent( ControlEvent theEvent ) {
  int BAUD_RATE = 115200;
  int portValue = 0;
  String USB_PORT = "none";
  String MIDI_PORT = "none";

  if ( theEvent.isController() ) {

    //////////////////////////////////////////////////////////// USB PORT
    if ( theEvent.controller().getName() == "usbPort" ) {
      portValue = ( int ) theEvent.controller().getValue();
      USB_PORT = Serial.list()[ portValue ];

      try {
        myPort = new Serial( this, USB_PORT, BAUD_RATE );
        println( "USB_DEVICES : " + USB_PORT );
        myPort.write( DEVICES );
        p1.setColorBackground( color( 10, 255, 0 ) );
        load( FILE ); // BUGGED
      }
      catch ( Exception e ) {
        fill( 255, 0, 0 );
        textAlign( CENTER );
        textSize( X_SCREN_SIZE/8 );
        text("WRONG USB", X_SCREN_SIZE/2, Y_SCREN_SIZE/2 );
        println( "WRONG USB PORT : " + USB_PORT );
        p1.setColorBackground( color( 255, 105, 100 ) );
      }
    }

    //////////////////////////////////////////////////////////// MIDI PORT
    if ( theEvent.controller().getName() == "midiPort" ) {
      portValue = ( int ) theEvent.controller().getValue();
      MIDI_PORT = outgoing.availableOutputs()[ portValue ];

      try {
        outgoing = new MidiBus( this, -1, MIDI_PORT ); // Create a new MidiBus with no input device and one output device.
        println( "MIDI_DEVICES : " + MIDI_PORT );
        p2.setColorBackground( color( 10, 255, 0 ) );
      }
      catch ( Exception e ) { ///////////////////////// FIXME
        fill( 255, 0, 0 );
        textAlign( CENTER );
        textSize( X_SCREN_SIZE/8 );
        text( "WRONG MIDI", X_SCREN_SIZE/2, Y_SCREN_SIZE/2 );
        println( "WRONG MIDI PORT : " + MIDI_PORT );
        p2.setColorBackground( color( 255, 105, 100 ) );
      }
    }
  }
}