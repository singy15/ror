(in-package :ror)

; Package boom.
(defpackage boom
	(:use cl cl-user)
	(:export 
    *col-size*
    *term*))

; Collision size.
(setf boom:*col-size* 30.0)

; Term.
(setf boom:*term* 200)

; Class boom.
(defclass boom (smi:actor) ())

; Ctor.
(defmethod initialize-instance :around ((this boom) &key) 
  (call-next-method)
  (setf (smi:radius this) 0.0)
  (setf (smi:duration this) boom:*term*))

(defmethod blast-radius ((this boom))
	(* boom:*col-size* (sin (* PI (lifetime-rate this)))))

(defmethod lifetime-rate ((this boom))
	(/ (float (smi:rest-duration this)) (float (smi:duration this))))

(defmethod get-rest-duration ((this boom))
  (/ (smi:rest-duration this) (smi:duration this)))

(defmethod smi:draw ((this boom))
	(let ((radius (blast-radius this)))
    (gl:enable :blend)
    (gl:blend-func :src-alpha :one)
    (sik:image *tex-exp* (smi:x this) (smi:y this) :a (+ 0.5 (get-rest-duration this)) 
               :sx (* 2.0 (get-rest-duration this)) :sy (* 2.0 (get-rest-duration this))
               :manual-blend t)
    (gl:disable :blend))
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

