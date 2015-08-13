XML xml;

/////////////////// Read values from XML config file  
void codeSetup() {

  xml = loadXML( "config.xml" );
  XML[] children = xml.getChildren( "code" );

  for (int i=0; i<children.length; i++) {
    switch( i ) {
    case 0: 
      X_MATRIX = children[ i ].getInt( "X_MATRIX" );
      if ( DEBUG_CONFIG ) println( "X_MATRIX : " + X_MATRIX );
      break;
    case 1: 
      Y_MATRIX = children[ i ].getInt( "Y_MATRIX" );
      if ( DEBUG_CONFIG ) println( "Y_MATRIX : " + Y_MATRIX );
      break;
    case 2: 
      PIX_SIZE = children[ i ].getInt( "PIX_SIZE" );
      if ( DEBUG_CONFIG ) println( "PIX_SIZE : " + PIX_SIZE );
      break;
    case 3: 
      PADDING = children[ i ].getInt( "PADDING" );
      if ( DEBUG_CONFIG ) println( "PADDING : " + PADDING );
      break;
    case 4: 
      MARGIN = children[ i ].getInt( "MARGIN" );
      if ( DEBUG_CONFIG ) println( "MARGIN : " + MARGIN );
      break;
    case 5: 
      OFFSET = children[ i ].getInt( "OFFSET" );
      if ( DEBUG_CONFIG ) println( "OFFSET : " + OFFSET );
      break;
    case 6: 
      THRESHOLD = children[ i ].getInt( "THRESHOLD" );
      if ( DEBUG_CONFIG ) println( "THRESHOLD : " + THRESHOLD );
      break;
    case 7: 
      FILE = children[ i ].getString( "FILE" );
      if ( DEBUG_CONFIG ) println( "FILE : " + FILE );
      break;
      /*
    case 8: 
       X_SCREN_SIZE = children[ i ].getInt( "X_SCREN_SIZE" );
       if ( DEBUG_CONFIG ) println( "X_SCREN_SIZE : " + X_SCREN_SIZE );
       break;
       case 9: 
       Y_SCREN_SIZE = children[ i ].getInt( "Y_SCREN_SIZE" );
       if ( DEBUG_CONFIG ) println( "Y_SCREN_SIZE : " + Y_SCREN_SIZE );
       break;
       */
    }
  }
}

