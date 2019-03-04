
(defpackage city
	(:use cl cl-user)
	(:export *col-size*))
(in-package :city)
(in-package :ror)

(setf city:*col-size* 10.0)

(defclass city (smi:actor) ())

(defmethod initialize-instance :around ((this city) &key) 
  (call-next-method)
  (setf (smi:radius this) city:*col-size*))

(defmethod smi:draw ((this city))
  (sik:image *tex-city* (smi:x this) (- (smi:y this) 9.0) :r 1.0 :g 1.0 :b 1.0 :a 1.0)

  (gl:enable :blend)
  (gl:blend-func :src-alpha :one)
  (sik:image *tex-exp* (smi:x this) (smi:y this) :a 0.1 :sx 2.0 :sy 2.0 :manual-blend t)
  (gl:disable :blend)
  )

(defmethod smi:updt ((this city))
  (call-next-method)
  
  ; Spawn bullet.
  (when (equal 0 (random 200))
    (let ((b (make-instance 'bullet)))
      (setf (smi:x b) (smi:x this))
      (setf (smi:y b) (smi:y this))
      (setf (smi:dy b) (- (+ (random 4.0) 2.0)))
      (setf (smi:dx b) (- (random 3.0) 1.5))
      (smi:register (actor-mng *game*) b)))

  (when (equal 0 (random 500))
    (let ((b (make-instance 'spawner-bullet)))
      (setf (smi:x b) (smi:x this))
      (setf (smi:y b) (smi:y this))
      (setf (smi:duration b) (random 180))
      (smi:register (actor-mng *game*) b))))

(defmethod smi:kill ((this city))
	(let ((e (make-instance 'explosion)))
    (setf (smi:x e) (smi:x this))
    (setf (smi:y e) (smi:y this))
    (setf (smi:duration e) 300.0)
		(smi:register (actor-mng *game*) e))
  (call-next-method))

(defmethod smi:handle-collision ((this city) (they boom)))

(in-package :cl-user)


