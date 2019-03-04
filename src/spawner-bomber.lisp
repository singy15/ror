(in-package :ror)

; Class spawner-bomber.
(defclass spawner-bomber (spawner) 
  ((tx
     :accessor tx)
   (ty 
     :accessor ty)
   (tdx
     :accessor tdx)
   (tdy
     :accessor tdy)
   (side
     :accessor side)))

(defmethod initialize-instance :around ((this spawner-bomber) &key)
  (call-next-method)
  (setf (side this) (if (equal 0 (random 2)) 1.0 -1.0))
  (setf (smi:x this) (+ (/ (sik:get-width) 2.0) (* 270.0 (* -1.0 (side this)))))
  (setf (smi:y this) (- (+ (/ (sik:get-height) 2.0) 100) (random 100)))
  (setf (smi:duration this) 600)
  )

; Updates.
(defmethod smi:updt ((this spawner-bomber))
  (call-next-method this)
  (when (equal 0 (mod (smi:tm this) 120))
    (let ((b (make-instance 'bomber)))
      (setf (smi:x b) (smi:x this))
      (setf (smi:y b) (+ (smi:y this) (* 15.0 (cos (random PI)))))
      (setf (smi:dx b) (* 0.3 (side this)))
      ; (setf (depth b) (cos (random (/ PI 2.0))))
      (setf (depth b) (+ 1.0 (* 0.2 (cos (random PI)))))
      (smi:register (actor-mng *game*) b))
    
    ; (let ((b (make-instance 'bullet-aaa))
    ;       (theta (atan (- (smi:y this) (ty this)) (- (smi:x this) (tx this)))))
    ;   (setf (smi:x b) (smi:x this))
    ;   (setf (smi:y b) (smi:y this))
    ;   (setf (smi:old-x b) (smi:x this))
    ;   (setf (smi:old-y b) (smi:y this))
    ;   (setf (smi:dx b) (* (spd this) (cos theta)))
    ;   (setf (smi:dy b) (* (spd this) (sin theta)))
    ;   ; (setf (smi:dy b) (- (+ (random 4.0) 2.0)))
    ;   ; (setf (smi:dx b) (- (random 3.0) 1.5))
    ;   (smi:register (actor-mng *game*) b))
    
    )
  )

; Draw.
(defmethod smi:draw ((this spawner-bomber))
  (sik:circle (smi:x this) (smi:y this) 20.0 5.0)
  ; (sik:line (tx this) (ty this) (smi:x this) (smi:y this))
  ; (sik:circle (tx this) (ty this) 10.0 8.0)
  
  )

(in-package :cl-user)

