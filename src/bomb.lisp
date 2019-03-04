(in-package :ror)

; Package bomb.
(defpackage bomb
	(:use cl)
	(:export 
    *col-size*
    *spd*))

; Collision size.
(setf bomb:*col-size* 1.0)

; Speed.
(setf bomb:*spd* 0.2)

; Class bomb.
(defclass bomb (smi:actor) ())

; Ctor.
(defmethod initialize-instance :around ((this bomb) &key) 
  (call-next-method)
  (setf (smi:radius this) bomb:*col-size*)
  (setf (smi:dy this) bomb:*spd*))

; Draw.
(defmethod smi:draw ((this bomb))
  ; Draw point.
  (sik:point (smi:x this) (smi:y this) :s 2.0)

  ; Draw halo.
  ; Manual blending control.
  (gl:enable :blend)
  (gl:blend-func :src-alpha :one)
  (sik:image *tex-exp* 
             (smi:x this) (smi:y this) 
             :a (if (< (smi:tm this) 200) (* 0.2 (/ (smi:tm this) 200)) 0.2) 
             :sx 0.2 :sy 0.2 
             :manual-blend t)
  (gl:disable :blend))

; Update.
(defmethod smi:updt ((this bomb))
  ; Kill when reach ground.
	(when (> (smi:y this) (- (sik:get-height) 32.0))
			(kill-boom this))
  (call-next-method))

; Kill-boom.
(defmethod kill-boom ((this bomb))
  ; Spawn boom-small.
	(let ((e (make-instance 'boom-small)))
    (setf (smi:x e) (smi:x this))
    (setf (smi:y e) (smi:y this))
    (smi:register (actor-mng *game*) e))

  ; Kill this bomb.
	(setf (smi:is-alive this) nil))

(in-package :cl-user)

