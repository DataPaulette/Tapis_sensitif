# /Tapis_sensitif/
 - Date : 13/08/2015
 - Project : http://datapaulette.org/Tapis_sensitif/
 - Repository : https://github.com/DataPaulette/Tapis_sensitif/
 
This project is under construction, all codes are work in progress. 

#/Tapis_sensitif/I2C_network_processing/
This folder include à processing sketch allowing mapping to trigger MIDI notes.
https://processing.org/download/
The following contributed libraries are needed
 - theMidiBus
 - controlP5

#/Tapis_sensitif/Eagle_board/
This folder include the Eagle source code of the electronic board made for the project.
http://www.cadsoftusa.com/download-eagle/
An file (7_BIT_ARRAY_COUNT.csv) that list binary codes to configure the dip switch of each board.
This 7 bit dip switch is used to configure the address of each board.

#/Tapis_sensitif/I2C_matrix_MASTER/
https://www.arduino.cc/en/Main/Software
This folder include the Arduino code for the master device plugged on a computer via USB port.

#/Tapis_sensitif/I2C_matrix_SLAVE/
This folder include the Arduino code for each sensitive slab device that communicate  over a four wire I2C bus.
