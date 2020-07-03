In the zipped folder are 4 files: 
-2 different implementations (see below) for the basic, 2D turtle commands 
-1 file with utility functions to be placed in the 'Trusted Location' of your installed version. [Options->Files]
&
-1 file showcasing some drawing functions, that are directly transcribed from the book "Turtle Geometry - The Computer as a Medium for Exploring Mathematics" and (should) work with any of the two implementations. 

ABOUT THE SOURCE CODE:
1) The chronologically first, but hierarchically second implementation ('2_Turtle Code_UCS') is more of a mental experiment, since it tries to express the core concepts of turtle geometry in terms of code structure, but at the cost of efficiency. More specifically, a basic demand in turtle geometry is the lack of a Cartesian coordinate system. In the implementation, this was simulated by equating the origin point and orientation of the coordinate system with the turtle's position and heading. In effect, the UCS is being constantly reset during execution to match the turtle's movement. This way we also achieve the second axiom, namely that the mode of locomotion of the turtle is only on a single axis (I chose the Y-axis). The downside of this is that all of pre-existing geometry needs to be re-calculated at every reset leading to bleeding processing power. Furthermore, I noticed rounding errors crept in more frequently. 

2) The main implementation ('1_TurtleCode_Trig') is much more efficient and more robust, since it works behind the scenes much more in tune with the normal mode of operation of AutoCAD. For this reason, it is also more developed.

->In effect: The '1_TurtleCode_Trig' version should be the go-to choice!

