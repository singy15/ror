
(defpackage my-missile
	(:use cl cl-user)
	(:export *col-size*
					 *spd*))
(in-package :my-missile)
(in-package :ror)

(setf my-missile:*col-size* 2.0)
(setf my-missile:*spd* 3.0)

(defclass my-missile (smi:actor) 
  ((tx
     :accessor tx
     :initform 0.0)
   (ty
     :accessor ty
     :initform 0.0)))

(defmethod initialize-instance :around ((this my-missile) &key) 
  (call-next-method)
  (setf (smi:radius this) my-missile:*col-size*))

(defmethod smi:draw ((this my-missile))
  (sik:image *tex-missile* (smi:x this) (smi:y this) 
             :rt (sik:to-deg (smi:theta this)) :sx 0.5 :sy 0.5 :a 1.0 :r 1.0 :g 0.5 :b 0.5)
	(sik:point (tx this) (ty this) 
             :s 4.0 :r 1.0 :g 0.0 :b 0.0 :a 0.4))

(defmethod smi:updt ((this my-missile))
  (call-next-method))

(defmethod smi:kill ((this my-missile))
	(let ((e (make-instance 'explosion)))
    (setf (smi:x e) (smi:x this))
    (setf (smi:y e) (smi:y this))
		(smi:register (actor-mng *game*) e))
  (call-next-method))

(in-package :cl-user)


