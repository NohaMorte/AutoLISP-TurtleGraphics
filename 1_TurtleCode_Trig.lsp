;O.C. // chatzifoti.olga@gmail.com

;all functions have a prefix of 'turtle:' to avoid clashing with other, local, user functions.
;Feel free to remove en masse or replace with something preferable to you.

; / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / 

    ;Please run this function first to set up the drafting environment. 
(defun turtle:draftingSession_open  ()
    ;loads utility functions
    (turtle:utilitiesLoad)
    ;initializes the turtle.
    (turtle:reset)
    ;creates a drafting layer and sets it as active
    (turtle:draftingLayer 200)
    ;princs available functions in the console to inform the user.
    ;note: I haven't added the commands, as are not very likely to be useful, they are only provisionary.
    (turtle:commandList)
    )

    ;this function should be run when closing the drafting session to return the state to normal.
(defun turtle:draftingSession_close  ()
    ;returns user layer to active
    (vla-put-ActiveLayer doc userLayer)
    ;erases all global variables
    (setq doc nil
          userlayer nil
          currentPoint nil
          previousPoint nil
          orientation nil
          penDownFlag nil
          )
    (gc)
    )

; - - - - - - - - - - - - - - - - - - - - - - -  P R O G R A M___S E T U P - - - - - - - - - - - - - - - - - - - - - - - - - - 


 ;loads utility functions. 
(defun turtle:utilitiesLoad  (/ filename extension variablename)

 ;The 'utilities.lsp' file should be manually placed in the 'Trusted Locations' folder, which can be set in Options->Files.
 ;But since it might not, either by mistake or by intention, I wrote some alternatives by using the (load argument [onfailure]) expression.
 ; - - - - - -

     (setq filename     "4_Utilities"
           extension    "lsp"
           variablename "localfilelocation"
           )

 ; - - - - - - - - - 
 ;try to load the file from the trusted locations (autoload)
     (if (NOT (load (strcat filename "." extension) nil))
 ;if load fails, check if the variable 'fullfilepath' has been assigned value (will NOT have a value at first run) 
          (if (NOT (eval (read variablename)))
 ;if predicate is true, this is either the first run OR the file has been relocated since last run, therefore, do the following:

 ;add a line to this file that stores the filepath in your system
               (localizeFilePath filename) ;for more information on this, see below.
 ;if predicate is false, the utility file is at the following location
               (load (eval (read variablename)))
               ) ;end of nested if
          ) ;end of if
     ) ;end of defun


; / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / 

(defun turtle:draftingLayer  (colour / layers newLayer)
    (vl-load-com)
    (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))
    ;userlayer will stay in memory as a global, I need to access it later to restore it.
    (setq userLayer (vla-get-ActiveLayer doc))
    (setq newLayer (vla-Add (vla-get-Layers doc) "TurtleTrace")) ; I am not tablesearching here.
    (vla-put-color newLayer colour)
    (vla-put-ActiveLayer doc newLayer)
    )

; / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / 


(defun turtle:commandList  ()
    (princ
      "\nThe turtle starts its journey at the current UCS origin and is heading north/upwards.
      It moves forward and backwards by 'turtle:forward' and 'turtle:backwards' respectively.
      Use 'turtle:right' and 'turtle:left' to have the turtle face another direction to move towards to.
      Use 'turtle:reset' to bring the turtle back to its starting position and 'turtle:cleanSlate' to reset and erase all previous traces.
      Use 'turtle:penUp' to travel distances without leaving traces (and 'turtle:penDown' for the opposite).
      Once you are done travelling, use 'turtle:draftingSession_close' to exit Turtle World."
        )
    (princ)
    )


; - - - - - - - - - - - - - - - - - - - - - - -  T_U_R_T_L_E___G_E_O_M_E_T_R_Y - - - - - - - - - - - - - - - - - - - - - - - - - - 


; / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / 

;;;NOTE:
;In this implementation I have decided to use the following variables as global variables to represent the 'turtle' and handle movement with basic trigonometry:
;previousPoint currentPoint orientation penDownFlag
;I could bundle these data up in a list, which should be of fixed size and the data can be accessed and updated by index,
;in essence functioning more like an array than a list, but arrays in VLisp must contain data of a single data type, so are excluded as an option.
;But bundling up with only 1 turtle does not add any higher functionality, therefore I just went with the freely standing variables for now.

    ;initialize global variables
(defun turtle:reset  ()
    (setq previousPoint '(0 0 0)
          currentPoint  previousPoint
          orientation   (deg2rad 90)
          ;*deg2rad is a custom function to convert degrees to radians, found in the utilities file. 
          penDownFlag   T)
    )

 ;erases all elements in the turtle drafting layer and resets the turtle.
(defun turtle:cleanSlate  (/ mspace)
 ;I will use activeX for this
     (setq mspace (vla-get-ModelSpace (vla-get-ActiveDocument (vlax-get-acad-object))))

     (vlax-map-collection
          mspace
          '(lambda (x)
                (if (= "TurtleTrace" (vla-get-Layer x))
                     (vla-Delete x))))
     (turtle:reset)
     )


; / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / 


;1) This is the GO mechanic:
(defun turtle:go (dist / nextPoint x-increment y-increment)

     (setq x-increment (* (cos orientation) dist)
           y-increment  (* (sin orientation) dist)
	  )

     (setq nextPoint (list (+ (car currentPoint) x-increment)
		     (+ (cadr currentPoint) y-increment)
		     (last currentPoint))
           )
     
     (if penDownflag (MK_LINE currentPoint nextPoint)) ;*utility function. Creates a 'LINE' object based on two points. Can be substituted with LWPolyline. 

    ;updates values for global variables to match new state 
     (setq previousPoint currentPoint
  	currentPoint nextPoint
	orientation (angle previousPoint currentPoint)
	)
)

;These are the GO calls: 

(defun turtle:forward (dist)
( turtle:go dist)
  )

(defun turtle:backwards (dist)
( turtle:go (- dist) )
  )

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

;2) This is the turn mechanic

(defun turtle:turn  (way ang /)

  (cond
    ((or (= way "RIGHT") (= way "r") (= way "R")) ;to cater for alternative calls
     (setq orientation (rem (- orientation (deg2rad ang)) (* 2 pi) ) ) ;rem is used to limit values to 2pi
     )

    ((or (= way "LEFT") (= way "l") (= way "L"))  ;---||---
     (setq orientation (rem (+ orientation (deg2rad ang)) (* 2 pi)) ) ;---||---
     )
    )
  )

;These are the turn calls:

(defun turtle:right  (ang)
  (turtle:turn "r" ang)
  )

(defun turtle:left  (ang)
  (turtle:turn "l" ang)
  )

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(defun turtle:penUp ()
  (setq penDownFlag nil)
)

(defun turtle:penDown ()
  (setq penDownFlag T)
)

; / / / / / / / / / / / / / / / / / / / / / / / / C / O / M / M / A / N / D / S / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / 

;Implemented as commands for use in AutoCAD drafting environment - just in case:

(defun c:forward  ()
  (initget 0)
     (turtle:forward
          (getdist "\nPlease choose the distance you want to cover: "))
     )

(defun c:backwards  ()
     (turtle:backwards
          (getdist "\nPlease choose the distance you want to cover: "))
     )

(defun c:right  ()
     (turtle:right (getangle "\nPlease choose a angle: "))
     )


(defun c:left  ()
     (turtle:left (getangle "\nPlease choose a angle: "))
     )


; / / / / / / / / / / / / / / / / / / / / / / / / L / O / C / A / L / I / S / E / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / 


;to avoid spawning more global variable

       
    ;O: file system path
(defun whereAmI  (filename) ;I: filename as string
    (getfiled "Please indicate the location of this file:" filename "lsp" 8)
    )


    ; O: returns a new expression in string format, which binds the location of the argument file to a variable.
(defun storeLocation  (filename) ;I: filename as string
    (strcat
    ;I draw the value of variablename from the context at call time. 
        "(setq "
        variablename
        " "
        (VL-PRIN1-TO-STRING (whereAmI filename))
        ")"
        )
    )

    ;O: returns nil. Adds the supplied data to an existing file. 
(defun patchFile  (filelocation stringdata / filepointer addedLine)
    ;input check for access
    (if (not (findfile filelocation))
        (setq filelocation (whereamI filelocation))
        )

    (setq addedLine
             (strcat
                 "\n;This is a line that the program added to its source-code.\n"
                 stringdata))
    ;add text
    (setq filepointer (open filelocation "a"))
    (write-line addedLine filepointer)
    (close filepointer)
    )


(defun Self-Patch (stringdata / filename)

    ;this file. I have no way of reading these data automatically. :(
    (setq filename "1_TurtleCode_Trig.lsp")

     (patchFile filename stringdata)
    )


(defun localizeFilePath  (filename)
    (Self-Patch (storeLocation filename))
    )


    ; - - - - - -

;This is a line that the program added to its source-code.
(setq localfilelocation "D:\\Dropbox\\0_The Architect\\___Olga_Projects B\\Turtle Graphics in LISP\\Turtle Geometry\\4_Utilities.lsp")
