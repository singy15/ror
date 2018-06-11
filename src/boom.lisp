
(defpackage boom
	(:use cl cl-user)
	(:export *col-size*
           *term*))
(in-package :boom)
(in-package :ror)

(setf boom:*col-size* 30.0)
(setf boom:*term* 200)

(defclass boom (smi:actor) ())

(defmethod initialize-instance :around ((this boom) &key) 
  (call-next-method)
  (setf (smi:radius this) 0.0)
  (setf (smi:duration this) boom:*term*))

(defmethod blast-radius ((this boom))
	(* boom:*col-size* (sin (* PI (lifetime-rate this)))))

(defmethod lifetime-rate ((this boom))
	(/ (float (smi:rest-duration this)) (float (smi:duration this))))

(defmethod smi:draw ((this boom))
	(let ((radius (blast-radius this)))
		(sik:circle (smi:x this) (smi:y this) radius 50 :a (* 0.8 (lifetime-rate this)) :f t))
	(sik:rect 0.0 0.0 (sik:get-width) (sik:get-height) :a (* (lifetime-rate this) 0.1))
	(call-next-method))

(defmethod smi:updt ((this boom))
  (setf (smi:radius this) (blast-radius this))
  (call-next-method))

(defmethod smi:kill ((this boom))
  (call-next-method))

(defmethod smi:handle-collision ((this boom) (they city))
  (smi:kill they))

(in-package :cl-user)


