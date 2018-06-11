
(defpackage menu
  (:use cl cl-user)
  (:export :updt
					 :draw))
(in-package :menu)

(in-package :ror)

(defclass menu () 
	((selected
		 :accessor selected
		 :initform 0)))

(defmethod initialize-instance :around ((this menu) &key) 
	(call-next-method this))

(defmethod draw ((this menu))
	(sik:texts "RAIN OF RADIATION" 70.0 220.0 :aa t :a 0.8 :sx 2.0 :sy 0.8)
	(sik:texts "START" 210.0 280.0 :aa t :a 0.8 :sx 1.5 :sy 0.8)
	(sik:texts "EXIT" 215.0 300.0 :aa t :a 0.8 :sx 1.5 :sy 0.8)
	(sik:rect 100.0 (+ (* (selected this) 20.0) 270.0) (- (sik:get-width) 100.0) (+ (* (selected this) 20.0) (+ 270.0 12.0)) :a 0.5))

(defmethod updt ((this menu))
	(when (sik:get-key-push #\w)
		(setf (selected this) (mod (- 1 (selected this)) 2)))
	(when (sik:get-key-push #\s)
		(setf (selected this) (mod (+ 1 (selected this)) 2)))
	
	(when (sik:get-key-push #\a)
		(if (equal (selected this) 0) 
			(setf *game* (make-instance 'game))
			(cl-user::exit))))


(in-package :cl-user)

