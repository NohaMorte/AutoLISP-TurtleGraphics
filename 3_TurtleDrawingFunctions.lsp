
(defun turtle:square  (side)
 (setq group (ssadd))
     (repeat 4
    (turtle:forward side)
           (ssadd (entlast) group)
    (turtle:right 90)
          (ssadd (entlast) group)
    )
   (command-s "_.zoom" "object"  group "")     
  )


(defun turtle:fullCircle  (radius fineness)
  (setq	an	  (/ 360.0 fineness)
	perimeter (* 2 pi radius)
	step	  (/ perimeter fineness)
	)
  (repeat fineness
    (turtle:forward step)
    (turtle:right an)
    )
  )

(defun turtle:arcr (step deg)
  (repeat deg
    (turtle:forward step)
    (turtle:left 1)
    )
)

(defun turtle:circles ()
(repeat 9
  (turtle:arcr 1 360)
  (turtle:right 40)
  )
  )

  (defun turtle:petal (size)
    (turtle:arcr size 60)
    (turtle:left (- 180 60))
    (turtle:arcr size 60)
    (turtle:left (- 180 60))
    )

(defun turtle:flower  (n size)
  (setq an (/ 360.0 n))
  (repeat n
    (turtle:petal size)
    (turtle:right an)
    )
  )

;this is an infinite loop -> the turtle got lost in a maze!!!
(defun turtle:poly (side ang)
  (turtle:forward side)
  (turtle:right ang)
  (turtle:poly side ang)
)