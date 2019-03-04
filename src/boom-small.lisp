(in-package :ror)

; Package boom-small.
(defpackage boom-small
	(:use cl)
	(:export 
    *col-size*
    *term*))

; Collision.
(setf boom-small:*col-size* 10.0)

; Term.
(setf boom-small:*term* 200)

; Class boom-small.
(defclass boom-small (smi:actor) ())

; Ctor.
(defmethod initialize-instance :around ((this boom-small) &key) 
  (call-next-method)
  (setf (smi:radius this) 0.0)
  (setf (smi:duration this) boom-small:*term*))

; Calc blast radius.
(defmethod blast-radius ((this boom-small))
	(* boom-small:*col-size* (sin (* PI (lifetime-rate this)))))

(defmethod lifetime-rate ((this boom-small))
	(/ (float (smi:rest-duration this)) (float (smi:duration this))))

; Calc rest duration.
; TODO: maybe replasable with that of senmei.
(defmethod get-rest-duration ((this boom-small))
  (/ (smi:rest-duration this) (smi:duration this)))

; Draw.
(defmethod smi:draw ((this boom-small))
	(let ((radius (blast-radius this)))
    (gl:enable :blend)
    (gl:blend-func :src-alpha :one)
    (sik:image *tex-exp* 
               (smi:x this) (smi:y this) 
               :a (+ 0.5 (get-rest-duration this)) 
               :sx (* 0.5 (get-rest-duration this)) :sy (* 0.5 (get-rest-duration this))
               :manual-blend t)
    (gl:disable :blend))
	(call-next-method))

; Update.
(defmethod smi:updt ((this boom-small))
  (setf (smi:radius this) (blast-radius this))
  (call-next-method))

; Kill.
(defmethod smi:kill ((this boom-small))
  (call-next-method))

; Collision handler boom-small vs city.
(defmethod smi:handle-collision ((this boom-small) (they city))
  (smi:kill they))

(in-package :cl-user)

