;O.C. // chatzifoti.olga@gmail.com

;all functions have a prefix of 'turtle:' to avoid clashing with other local user functions and a suffix of '_UCS' to distinguish from the other implementation.

; / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / 

;In this implementation, I am equating the turtle with the UCS to "simulate" the transition from the cartesian coordinate system to the turtle coordinate system.

    ;teleports the immaterial turtle to the given point, i.e. changes UCS origin to given point 
(defun turtle:setPosition_UCS  (point)
    ;(setvar "ucsorg" point) is not an option, because 'ucsorg' is a read only system variable.
    ; therefore, I need AutoCAD command. . .
    ;executes the command based on supplied input without passing control to the user.
    (command-s "_.ucs" "origin" point)
    )

    ;changes heading of the turtle, i.e. the orientation of the UCS.
(defun turtle:setOrientation_UCS  (ang)
    ;again, I must use AutoCAD commands.
    (command "_.ucs" "Z" ang) ; this angle is provided in degrees.
    )

    ;resets the turtle to starting position and heading
(defun turtle:reset_UCS  ()
    (command-s "_.ucs" "world")
    )


; / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / 

(defun turtle:turn_UCS  (way ang /) 

  (cond
    ((or (= way "RIGHT") (= way "r") (= way "R"))
     (turtle:setOrientation_UCS (- 0 ang))
     )

    ((or (= way "LEFT") (= way "l") (= way "L"))
     (turtle:setOrientation_UCS ang)
     )
    )
  )

(defun turtle:right_UCS  (ang) 
  (turtle:turn_UCS "r" ang)
  )

(defun turtle:left_UCS  (ang)
  (tuturtle:turn_UCS "l" ang)
  )

;; - - - --

 ;the turtle can move forward or backwards.
(defun
      turtle:go_UCS  (floatValue / pointA pointB)
     (setq pointA '(0 0 0))
     (setq pointB (list 0 floatValue 0))
     (command-s "_.pline" pointA pointB "c")
 ;resets the turtle position to match the new state
     (turtle:setPosition_UCS pointB)
     )

; - - - -
;these are the Go calls. I could use the same functions in both implementations, since the end user functions are identical, but let's keep things separate and self-containing.

(defun turle:forward_UCS  (dist)
    (turtle:go_UCS dist)
    )

(defun turtle:backward_UCS  (dist)
    (turtle:go_UCS (- dist))
    )

; - - - -

(defun turtle:draftingLayer  (colour / layers newLayer)
    (vl-load-com)
    (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))
    ;userlayer will stay in memory as a global, I need to access it later to restore it.
    (setq userLayer (vla-get-ActiveLayer doc))
    (setq newLayer (vla-Add (vla-get-Layers doc) "turtlePath")) ; I am not tablesearching here.
    (vla-put-color newLayer colour)
    (vla-put-ActiveLayer doc newLayer)
    )


(defun turtle:penUp ()
  (setq penDownFlag nil)
)

(defun turtle:penDown ()
  (setq penDownFlag T)
)

; - - - -

(defun turtle:draftingSession_open_UCS  ()
     ;GLOBAL VARIABLE
  (setq penDownflag T)
     ;set drafting layer
  (turtle:draftingLayer 200)
  )

(defun turtle:draftingSession_close_UCS  ()
     ;return user layer to active
     (vla-put-ActiveLayer doc userLayer)
  )
