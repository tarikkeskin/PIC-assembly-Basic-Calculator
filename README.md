# PIC-assembly-Basic-Calculator
 PIC18F8722 microcontroller addition and subtraction implementation usin MPLAB X
 
Specifications

Five ports will be used  PORTA, PORTB, PORTC, PORTD, and PORTE. LEDs are connected to the following pins: RB[0-3], RC [0-3], and RD [0-7]. The push buttons are RA4, RE3, and RE4, which must be configured as digital inputs, please look at the relevant section in the datasheet.
At the very beginning of the program, you must turn on the RB[0-3], RC[0-3], RD[0-7] LEDs of all the ports (16 pins in total) for 1 second. (please look at the Coding Rules and Hints sections for time delay implementation.)
After the period of 1-second, the RA4 button assigns the operation to be performed. When this button is pressed and released once, addition operation, when pressed twice, subtraction operation will be selected. You have to press and release the RA4 button to start the process. If you press and release the button three times, the addition operation will be selected again. Each press and release of the RA4 button, the active operation will change (addition-subtraction). After the selection of the operation, the RE3 button will be used for the port selection. In order to select PORTB, RE3 button should be pressed and released once. When the RE3 button is pressed and released again, PORTC is selected. When the RE3 button is pressed and released again, PORTD is selected. Each press and release of the RE3 button will move the active PORTs from PORT C to PORT D. When you select a PORT, you cannot change your operation, in other words, the RA4 button will not be pushed and released during the port selection.

When PORTB or PORTC, respectively, is selected, the RE4 button will be used to enter the value on these PORTs. Each time the RE4 button is pressed and released, the LEDs on these PORTs will turn on respectively from PORT[B-C]0 to PORT[B-C]3. When the RE4 button is pressed more than four times, the LEDs will reset and can be turned on respectively again from PORT[B-C]0 to PORT[B-C]3.

After determining the values of PORTB and PORTC, the PORTD is selected with the RE3 button, the result of the operation will be displayed as follows. For the addition operation, the LEDs should be turned ON as much as the total of the LEDs turned on in PORTB and PORTC. If the subtraction operation is selected, the LEDs should be turned ON as much as the absolute value of the difference of the LEDs turned on in PORTB and PORTC.

For one second, the result (addition or subtraction) is displayed in PORTD, all LEDs will be reset, and the operation selection can be realized by the RA4 button again.
