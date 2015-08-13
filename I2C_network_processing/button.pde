int selectorVal = 1;

///////////////////////////////////////////////////////
class Selector {

  int n;
  int pX;
  int pY;
  int size;
  boolean buttonArray[];

  // INIT
  Selector() {
    n = 6;
    size = 20;
    buttonArray = new boolean [ n ];
    buttonArray[ 1 ] = true;
  }

  void setPos( int posX, int posY ) {
    pX = posX;
    pY = posY;
  }

  void onClic( int mX, int mY ) {
    for (int i=1; i<n; i++) {
      if ( mX > pX+i*size && mX < pX+i*size+size && mY > pY && mY < pY+size ) {
        buttonArray[ i ] = true;
        buttonArray[ selectorVal ] = false;
        selectorVal = i;
        println( selectorVal );
      }
    }
  }

  void display( ) {
    for ( int i=1; i<n; i++ ) {
      if ( buttonArray[ i ] == true ) {
        fill( colors[ i ][ 0 ], colors[ i ][ 1 ], colors[ i ][ 2 ] );
      } else {
        fill( 200 );
      }
      noStroke();
      rect( pX+i*size, pY, size, size, 0 );
    }
  }
}

///////////////////////////////////////////////////////
class sensorMatrix {

  boolean toggle[][];
  int label[][];
  int id;
  int index;
  int pX;
  int pY;

  // INIT
  sensorMatrix( int matrixId ) {
    id = matrixId;
    index = 0;
    toggle = new boolean[ ROWS ][ COLS ];
    label = new int[ ROWS ][ COLS ];
    for ( int idY=0; idY<COLS; idY++ ) {
      for ( int idX=0; idX<ROWS; idX++ ) {
        label[ idX ][ idY ] = -1;
      }
    }
  }

  void update( ) {

    for ( int idY=0; idY<ROWS; idY++ ) {
      for ( int idX=0; idX<COLS; idX++ ) {

        switch ( MODE ) {
        case 'R':
          if ( storedValue[ id ][ idX ][ idY ] >= THRESHOLD && toggle[ idX ][ idY ] == false ) {
            toggle[ idX ][ idY ] = true;
            label[ idX ][ idY ] = selectorVal;
            println ( "REC " + id + " " + idX + " " + idY + " label : " + label[ idX ][ idY ]  );
          }
          if ( storedValue[ id ][ idX ][ idY ] < THRESHOLD && toggle[ idX ][ idY ] == true ) {
            toggle[ idX ][ idY ] = false;
          }
          break;

        case 'P':
          if ( storedValue[ id ][ idX ][ idY ] >= THRESHOLD && toggle[ idX ][ idY ] == false ) {
            toggle[ idX ][ idY ] = true;
            println ( "PLAY " + id + " " + idX + " " + idY + " label : " + label[ idX ][ idY ]  );
          }
          if ( storedValue[ id ][ idX ][ idY ] < THRESHOLD && toggle[ idX ][ idY ] == true ) {
            toggle[ idX ][ idY ] = false;
          }
          break;
        }
      }
    }
  }

  void display( ) {
    // X_MATRIX = 2
    // Y_MATRIX = 2
    // INPUT : 0, 1, 2, 3 ( matrixId )
    // OUTPUT : 0 0, 1 0, 0 1, 1 1
    posX = id % X_MATRIX;
    // println( id + " " + posX + " " + posY );
    for ( int idY=0; idY<ROWS; idY++ ) {
      for ( int idX=0; idX<COLS; idX++ ) {

        switch ( MODE ) {
        case 'R':
          if ( label[ idX ][ idY ] != -1 ) {
            fill( colors[ label[ idX ][ idY ] ][ 0 ], colors[ label[ idX ][ idY ] ][ 1 ], colors[ label[ idX ][ idY ] ][ 2 ] );
          } else {
            fill( 200 );
          }
          break;

        case 'P':
          if ( toggle[ idX ][ idY ] == true ) {
            fill( 255, 0, 0 );
          } else {
            if ( label[ idX ][ idY ] != -1 ) {
              fill( colors[ label[ idX ][ idY ] ][ 0 ], colors[ label[ idX ][ idY ] ][ 1 ], colors[ label[ idX ][ idY ] ][ 2 ] );
            } else {
              fill( 200 );
            }
          }
          break;
        }

        pX = posX*COLS*PIX_SIZE + idX*PIX_SIZE + idX*PADDING + posX*MARGIN + OFFSET;
        pY = posY*ROWS*PIX_SIZE + idY*PIX_SIZE + idY*PADDING + posY*MARGIN + OFFSET;
        rectMode( CORNER );
        rect( pX, pY, PIX_SIZE, PIX_SIZE, 5 );

        // fill( 255, 0, 0 );
        // textSize( PIX_SIZE/2 );
        // text( id, pX+PIX_SIZE/2, pY+PIX_SIZE/2-2 );
        // text( label[ idX ][ idY ], pX+PIX_SIZE/2, pY+PIX_SIZE/2-2 );
      }
    }
    if ( posX == X_MATRIX-1 ) {
      posY++;
      posY = posY % Y_MATRIX;
    }
  }

  void onClic( int Mx, int My ) {
    // X_MATRIX = 2
    // Y_MATRIX = 2        
    // INPUT : 1, 2, 3, 4 (id)
    // OUTPUT : 0 0, 1 0, 0 1, 1 1
    posX = id % X_MATRIX;
    // println( id + " " + posX + " " + posY );
    for ( int idY=0; idY<ROWS; idY++ ) {
      for ( int idX=0; idX<COLS; idX++ ) {

        pX = posX*COLS*PIX_SIZE + idX*PIX_SIZE + idX*PADDING + posX*MARGIN + OFFSET;
        pY = posY*ROWS*PIX_SIZE + idY*PIX_SIZE + idY*PADDING + posY*MARGIN + OFFSET;

        if ( Mx > pX && Mx < pX+PIX_SIZE && My > pY && My < pY+PIX_SIZE ) {
          switch ( MODE ) {
          case 'R':
            label[ idX ][ idY ]++;
            label[ idX ][ idY ] = label[ idX ][ idY ] % 6;
            println ( "REC " + id + " " + idX + " " + idY + " label : " + label[ idX ][ idY ]  );
            break;
          case 'P':
            toggle[ idX ][ idY ] = true;
            println ( "PLAY " + id + " " + idX + " " + idY + " label : " + label[ idX ][ idY ]  );
          }
        }
      }
    }
    if ( posX == X_MATRIX-1 ) {
      posY++;
      posY = posY % Y_MATRIX;
    }
  }

  void load( String name ) {
    table = loadTable( "data/" + name, "header" );
    for ( int i=id*ROWS*COLS; i<id*ROWS*COLS+ROWS*COLS; i++ ) {
      int idX = table.getInt( i, 1 );
      int idY = table.getInt( i, 2 );
      int Value = table.getInt( i, 3 );
      label[ idX ][ idY ] = Value;
    }
  }

  void save( String name ) {
    for ( int idY=0; idY<COLS; idY++ ) {
      for ( int idX=0; idX<ROWS; idX++ ) {
        TableRow newRow = table.addRow();
        newRow.setInt( "id", id );
        newRow.setInt( "idX", idX );
        newRow.setInt( "idY", idY );
        newRow.setInt( "Value", label[ idX ][ idY ] );
      }
    }
    saveTable(table, "data/" + name );
  }
}

/////////////////////////////////////////////////////////
void load( String file ) {
  for ( int id=0; id<DEVICES; id++ ) {
    sMatrix[ id ].load( file );
  }
  fill( 255, 0, 0 );
  textSize( X_SCREN_SIZE/4 );
  textAlign( CENTER );
  text( "LOAD", X_SCREN_SIZE/2, Y_SCREN_SIZE/2 );
  println( "LOADED ./data/" + file );
}
/////////////////////////////////////////////////////////
void save(  String file ) {
  table.clearRows();
  for ( int id=0; id<DEVICES; id++ ) {
    sMatrix[ id ].save( file );
  }
  fill( 255, 0, 0 );
  textSize( X_SCREN_SIZE/4 );
  textAlign( CENTER );
  text( "SAVED", X_SCREN_SIZE/2, Y_SCREN_SIZE/2 );
  println( "SAVED ./data/" + file );
}
/////////////////////////////////////////////////////////
void rec() {
  MODE = 'R';
  fill( 255, 0, 0 );
  textSize( X_SCREN_SIZE/4 );
  textAlign( CENTER );
  text( "REC", X_SCREN_SIZE/2, Y_SCREN_SIZE/2 );
  println( "REC MODE");
}
/////////////////////////////////////////////////////////
void play() {
  MODE = 'P';
  fill( 255, 0, 0 );
  textSize( X_SCREN_SIZE/4 );
  textAlign( CENTER );
  text( "PLAY", X_SCREN_SIZE/2, Y_SCREN_SIZE/2 );
  println( "PLAY MODE");
}
/////////////////////////////////////////////////////////
void howTo() {
  int Xpos = X_SCREN_SIZE/4;
  int Ypos = Y_SCREN_SIZE/3;
  int vSpace = 25;

  noStroke();
  rectMode( CENTER );
  fill( 255, 255, 255, 50 );
  rect( X_SCREN_SIZE/2, Y_SCREN_SIZE/2, 300, 300, 10 );

  fill( 100 );
  textSize( 16 );
  textAlign( LEFT );
  text( "Select the USB port", Xpos, Ypos + 0*vSpace );
  text( "Display this help : shift + H", Xpos, Ypos + 1*vSpace );
  text( "Record mode : shift + R", Xpos, Ypos + 2*vSpace );
  text( "Play mode : shift + P", Xpos, Ypos + 3*vSpace );
  text( "Save topography : shift + S", Xpos, Ypos + 4*vSpace );
  text( "Load topography : shift + L", Xpos, Ypos + 5*vSpace );
}

