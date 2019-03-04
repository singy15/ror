
(defpackage explosion
	(:use cl cl-user)
	(:export *col-size*
           *term*))
(in-package :explosion)
(in-package :ror)

(setf explosion:*col-size* 50.0)
(setf explosion:*term* 120)

(defclass explosion (smi:actor) ())

(defmethod initialize-instance :around ((this explosion) &key) 
  (call-next-method)
  (setf (smi:duration this) explosion:*term*))

(defmethod blast-radius ((this explosion))
	(* explosion:*col-size* (sin (* PI (lifetime-rate this)))))

(defmethod lifetime-rate ((this explosion))
	(/ (float (smi:rest-duration this)) (float (smi:duration this))))

(defmethod get-rest-duration ((this explosion))
  (/ (smi:rest-duration this) (smi:duration this)))

(defmethod smi:draw ((this explosion))
	(let ((radius (blast-radius this)))
		; (sik:circle (smi:x this) (smi:y this) radius 50 :a (* 0.8 (lifetime-rate this)) :f t)
    ; (sik:image *tex-exp* (smi:x this) (smi:y this) :sx (sin (* PI (lifetime-rate this))) :sy (sin (* PI (lifetime-rate this))) :a (* 0.8 (lifetime-rate this)))

    (gl:enable :blend)
    (gl:blend-func :src-alpha :one)
    (sik:image *tex-exp* (smi:x this) (smi:y this) :a (+ 0.5 (get-rest-duration this)) 
               :sx (* 2.0 (get-rest-duration this)) :sy (* 2.0 (get-rest-duration this))
               :manual-blend t)
    (gl:disable :blend)
    
    ))

(defmethod smi:updt ((this explosion))
  (call-next-method) 
  (setf (smi:radius this) (blast-radius this)))

(defmethod smi:kill ((this explosion))
  (call-next-method))

(defmethod smi:handle-collision ((this explosion) (they missile))
  (smi:kill they))

(defmethod smi:handle-collision ((this explosion) (they bomber))
  (smi:kill they))

(defmethod smi:handle-collision ((this explosion) (they satellite))
  (smi:kill they))

(defmethod smi:handle-collision ((this explosion) (they bomb))
  (smi:kill they))

(in-package :cl-user)


