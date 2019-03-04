(in-package :ror)

; Class bullet.
(defclass bullet (smi:actor) ())

; Ctor.
(defmethod initialize-instance :around ((this bullet) &key) 
  (call-next-method)
  (setf (smi:duration this) 100.0)
  (setf (smi:d-dump this) 0.99)
  (setf (smi:ddy this) 0.01)
  (setf (smi:radius this) 5.0)
  )

(defmethod get-rest-duration ((this bullet))
  (/ (smi:rest-duration this) (smi:duration this)))

; Draw.
(defmethod smi:draw ((this bullet))
  (sik:point (smi:x this) (smi:y this) :s 2.0 :a 1.0)
  
  (gl:enable :blend)
  (gl:blend-func :src-alpha :one)
  (sik:image *tex-exp* (smi:x this) (smi:y this) :a (get-rest-duration this) 
             :sx (* 0.5 (get-rest-duration this)) :sy (* 0.5 (get-rest-duration this))
             :manual-blend t)
  (gl:disable :blend)
  
  )

; Update.
(defmethod smi:updt ((this bullet))
  (call-next-method))

(in-package :cl-user)

