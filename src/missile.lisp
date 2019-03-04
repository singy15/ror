
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
             :sx 0.5 :sy 0.5 :a 1.0 :r 1.0 :g 1.0 :b 1.0)
  
  (gl:enable :blend)
  (gl:blend-func :src-alpha :one)
  (sik:image *tex-exp* (smi:x this) (smi:y this) :a (if (< (smi:tm this) 200) (* 0.2 (/ (smi:tm this) 200)) 0.2) :sx 0.2 :sy 0.2 :manual-blend t)
  (gl:disable :blend))

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

(defmethod smi:handle-collision ((this missile) (they bullet))
  (smi:kill they)
  (smi:kill this))
  
(defmethod smi:handle-collision ((this missile) (they bullet-aaa))
  (smi:kill they)
  (smi:kill this))

(in-package :cl-user)


