
(defpackage missile
	(:use cl cl-user)
	(:export *col-size*))
(in-package :missile)
(in-package :ror)

(setf missile:*col-size* 2.0)

(defclass missile (smi:actor) ())

(defmethod initialize-instance :around ((this missile) &key) 
  (call-next-method)
  (setf (smi:radius this) missile:*col-size*))

(defmethod smi:draw ((this missile))
  (sik:image *tex-missile* (smi:x this) (smi:y this) :rt (sik:to-deg (smi:theta this)) 
             :sx 0.5 :sy 0.5 :a 1.0 :r 1.0 :g 1.0 :b 1.0))

(defmethod smi:updt ((this missile))
	(when (> (smi:y this) (- (sik:get-height) 32.0))
			(kill-boom this))
  (call-next-method))

(defmethod kill-boom ((this missile))
	(let ((e (make-instance 'boom)))
    (setf (smi:x e) (smi:x this))
    (setf (smi:y e) (smi:y this))
    (smi:register (actor-mng *game*) e))
	(setf (smi:is-alive this) nil))

(defmethod smi:kill ((this missile))
	(let ((e (make-instance 'explosion)))
    (setf (smi:x e) (smi:x this))
    (setf (smi:y e) (smi:y this))
		(smi:register (actor-mng *game*) e))
  (call-next-method))

(in-package :cl-user)


