# Tapis_sensitif

 - Date : 13/08/2015
 - Project : http://datapaulette.org/Tapis_sensitif/
 - Repository : https://github.com/DataPaulette/Tapis_sensitif/
 
This project is under construction, all codes are work in progress. 

#/Tapis_sensitif/I2C_network_processing/
This folder include à processing sketch allowing mapping to trigger MIDI notes.

The following contributed libraries are needed
	- import themidibus.*;
	- import controlP5.*;

#/Tapis_sensitif/Eagle_board/
This folder include thé source code of thé electronic board made for thé project.
	
#/Tapis_sensitif/I2C_44_matrix_MASTER/
This folder include the Arduino code for the master device plugged on a computer via USB port.

#/Tapis_sensitif/I2C_44_matrix_SLAVE/
This folder include the Arduino code for each sensitive slab device that communicate  over a four wire I2C bus.
