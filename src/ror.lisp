
(defpackage ror
  (:use cl cl-user)
  (:export main))
(in-package :ror)

(defclass window (sik:window) ())

(defmethod sik:user-initialize ((this window))
	(defparameter *game* (make-instance 'menu)))

(defmethod sik:user-display ((this window))
	(updt *game*)
	(draw *game*))

(defun main ()
  (sik:display-window 
		(make-instance 'window 
									 :title "ror" 
									 :width 500
									 :height 500
									 :keys (list #\w #\s #\a #\d)
                   :mode '(:double :rgb :depth :multisample)
									 :fps 60)))

(in-package :cl-user)

