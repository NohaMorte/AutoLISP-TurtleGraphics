;-----------------------------RAD<->DEG-----------------------------------------------------
;O:real, corresponding degrees 
(defun rad2deg (rad / ) (/ (* rad 180) pi)) ;I: real, radians to be converted
;O: real, corresponding radians
(defun deg2rad (deg) 	(/ (* deg pi) 180))	;I: real, degrees to be converted
;;; NOTE: 
;One can use the built-in 'angtof' and 'angtos' functions and convert the from string to real.
;Personally, I prefered to just write a new one, which would be easier to remember (for me).

;O: entity list of created "LINE"
(defun mk_line (pointA pointB / ) ;I: 2 lists of coordinates, can be 2D or 3D
     (entmake (list '(0 . "LINE") (cons 10 pointA) (cons 11 pointB)))
	 (entget (entlast))
)