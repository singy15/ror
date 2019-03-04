(in-package :ror)

; Package menu.
(defpackage menu
  (:use cl)
  (:export 
    *str-title*
    *str-menu-start*
    *str-menu-exit*))

; String for title.
(defparameter menu:*str-title* "Radiation")

; String for menu start.
(defparameter menu:*str-menu-start* "Start")

; String for menu exit.
(defparameter menu:*str-menu-exit* "Exit")

; Class menu.
(defclass menu () ())

; Ctor.
(defmethod initialize-instance :around ((this menu) &key) 
	(call-next-method))

; Draw.
(defmethod draw ((this menu))
  ; Clear.
  (sik:clear :r 0.2 :g 0.2 :b 0.2)
  
  ; Draw title.
  (sik:texts menu:*str-title* 180.0 203.0 :sx 1.5 :sy 4.0 :w 2.0 :r 0.0 :g 0.0 :b 0.0)
  (sik:texts menu:*str-title* 180.0 200.0 :sx 1.5 :sy 4.0 :w 2.0)
  
  ; Draw menu.
  (sik:texts menu:*str-menu-start* 220.0 270.0 :sy 2.0 :w 2.0)
  (sik:texts menu:*str-menu-exit* 225.0 300.0 :sy 2.0 :w 2.0)
  
  ; Draw selected.
  (if (< (sik:get-mouse-y) 270.0)
      (sik:texts ">>" 190.0 270.0 :sy 2.0 :w 2.0)
      (sik:texts ">>" 195.0 300.0 :sy 2.0 :w 2.0)))

; Update.
(defmethod updt ((this menu))
  ; Start or Exit.
	(when (sik:get-mouse-push :left)
		(if (< (sik:get-mouse-y) 270.0) 
			(setf *game* (make-instance 'game))
			(cl-user::exit))))

(in-package :cl-user)

