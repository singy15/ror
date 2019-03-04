(in-package :ror)

; Class spawner-bullet.
(defclass spawner-bullet (spawner) 
  ((tx
     :accessor tx)
   (ty 
     :accessor ty)
   (tdx
     :accessor tdx)
   (tdy
     :accessor tdy)
   (spd
     :accessor spd)
   (rate
     :accessor rate)))

(defmethod initialize-instance :around ((this spawner-bullet) &key)
  (call-next-method)
  (setf (tx this) (random (sik:get-width)))
  (setf (ty this) (- (/ (sik:get-height) 2.0) (random 200)))
  (let ((theta (random (* 2.0 PI)))
        (spd (+ 0.3 (random 2.0))))
    (setf (tdx this) (* spd (cos theta)))
    (setf (tdy this) (* spd (sin theta))))
  (setf (spd this) (- (+ (random 4.0) 2.0)))
  (setf (rate this) (+ 10 (random 30))))

; Updates.
(defmethod smi:updt ((this spawner-bullet))
  (call-next-method this)
  (when (equal 0 (mod (smi:tm this) (rate this)))
    (let ((b (make-instance 'bullet-aaa))
          (theta (atan (- (smi:y this) (ty this)) (- (smi:x this) (tx this)))))
      (setf (smi:x b) (smi:x this))
      (setf (smi:y b) (smi:y this))
      (setf (smi:old-x b) (smi:x this))
      (setf (smi:old-y b) (smi:y this))
      (setf (smi:dx b) (* (spd this) (cos theta)))
      (setf (smi:dy b) (* (spd this) (sin theta)))
      ; (setf (smi:dy b) (- (+ (random 4.0) 2.0)))
      ; (setf (smi:dx b) (- (random 3.0) 1.5))
      (smi:register (actor-mng *game*) b)))
  
  (incf (tx this) (tdx this))
  (incf (ty this) (tdy this))
  )

; Draw.
(defmethod smi:draw ((this spawner-bullet))
  ; (sik:circle (smi:x this) (smi:y this) 20.0 5.0)
  ; (sik:line (tx this) (ty this) (smi:x this) (smi:y this))
  ; (sik:circle (tx this) (ty this) 10.0 8.0)
  
  )

(in-package :cl-user)

