(defpackage explosion-small
	(:use cl cl-user)
	(:export *col-size*
           *term*))
(in-package :explosion-small)
(in-package :ror)

(setf explosion-small:*col-size* 10.0)
(setf explosion-small:*term* 120)

(defclass explosion-small (smi:actor) ())

(defmethod initialize-instance :around ((this explosion-small) &key) 
  (call-next-method)
  (setf (smi:duration this) explosion-small:*term*))

(defmethod blast-radius ((this explosion-small))
	(* explosion-small:*col-size* (sin (* PI (lifetime-rate this)))))

(defmethod lifetime-rate ((this explosion-small))
	(/ (float (smi:rest-duration this)) (float (smi:duration this))))

(defmethod get-rest-duration ((this explosion-small))
  (/ (smi:rest-duration this) (smi:duration this)))

(defmethod smi:draw ((this explosion-small))
	(let ((radius (blast-radius this)))
		; (sik:circle (smi:x this) (smi:y this) radius 50 :a (* 0.8 (lifetime-rate this)) :f t)
    ; (sik:image *tex-exp* (smi:x this) (smi:y this) :sx (sin (* PI (lifetime-rate this))) :sy (sin (* PI (lifetime-rate this))) :a (* 0.8 (lifetime-rate this)))

    (gl:enable :blend)
    (gl:blend-func :src-alpha :one)
    (sik:image *tex-exp* (smi:x this) (smi:y this) :a (+ 0.5 (get-rest-duration this)) 
               :sx (* 0.5 (get-rest-duration this)) :sy (* 0.5 (get-rest-duration this))
               :manual-blend t)
    (gl:disable :blend)
    
    ))

(defmethod smi:updt ((this explosion-small))
  (call-next-method) 
  (setf (smi:radius this) (blast-radius this)))

(defmethod smi:kill ((this explosion-small))
  (call-next-method))

(in-package :cl-user)


