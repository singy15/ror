(in-package :ror)

; Package bomber.
(defpackage bomber
  (:use cl)
  (:export
    *radius*
    *spd*))

; Radius.
(defparameter bomber:*radius* 10.0)

; Speed.
(defparameter bomber:*spd* 0.3)

; Class bomber.
(defclass bomber (smi:actor) 
  ((depth
     :accessor depth)))

; Ctor.
(defmethod initialize-instance :around ((this bomber) &key) 
  (call-next-method)
  (setf (smi:radius this) bomber:*radius*)
  (setf (smi:duration this) (/ (+ (sik:get-width) 200.0) bomber:*spd*))) 

; Draw.
(defmethod smi:draw ((this bomber))
  ; Draw bomber.
  (gl:enable :blend)
  (gl:blend-func :src-alpha :one-minus-src-alpha)
  (sik:image *tex-bomber* 
             (smi:x this) (smi:y this) 
             :a 0.6 
             :sx (if (> (smi:dx this) 0.0) (* -0.7 (depth this)) (* 0.7 (depth this))) 
             :sy (* 0.7 (depth this)) 
             :manual-blend t)
  (gl:disable :blend))

; Update.
(defmethod smi:updt ((this bomber))
  (call-next-method)
 
  ; Spawn bomb.
  (when (equal 0 (random 360))
    (let ((b (make-instance 'bomb)))
      (setf (smi:x b) (smi:x this))
      (setf (smi:y b) (smi:y this))
      (smi:register (actor-mng *game*) b))))

; Collision handler bomber vs bullet.
(defmethod smi:handle-collision ((this bomber) (they bullet))
  (smi:kill they)
  (smi:kill this))
  
; Collision handler bomber vs bullet-aaa.
(defmethod smi:handle-collision ((this bomber) (they bullet-aaa))
  (smi:kill they)
  (smi:kill this))

; Kill.
(defmethod smi:kill ((this bomber))
  ; Spawn explosion-small.
	(let ((e (make-instance 'explosion-small)))
    (setf (smi:x e) (smi:x this))
    (setf (smi:y e) (smi:y this))
		(smi:register (actor-mng *game*) e))

  (call-next-method))

(in-package :cl-user)

