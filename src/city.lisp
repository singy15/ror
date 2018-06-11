
(defpackage city
	(:use cl cl-user)
	(:export *col-size*))
(in-package :city)
(in-package :ror)

(setf city:*col-size* 10.0)

(defclass city (smi:actor) ())

(defmethod initialize-instance :around ((this city) &key) 
  (call-next-method)
  (setf (smi:radius this) city:*col-size*))

(defmethod smi:draw ((this city))
  (sik:image *tex-city* (smi:x this) (- (smi:y this) 7.0) :r 0.5 :g 0.5 :b 1.0 :a 0.8))

(defmethod smi:updt ((this city))
  (call-next-method))

(defmethod smi:kill ((this city))
	(let ((e (make-instance 'explosion)))
    (setf (smi:x e) (smi:x this))
    (setf (smi:y e) (smi:y this))
    (setf (smi:duration e) 300.0)
		(smi:register (actor-mng *game*) e))
  (call-next-method))

(defmethod smi:handle-collision ((this city) (they boom)))

(in-package :cl-user)


