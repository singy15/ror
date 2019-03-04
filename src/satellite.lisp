
(defpackage satellite
  (:export frame-range
           range-rate)
  (:use cl cl-user))
(in-package :satellite)

(defun sec (s) 
  (* s 60))

(defun frame-range (now s e)
  (and (<= (sec s) now) (< now (sec e))))

(defun range-rate (now s e)
  (cond ((frame-range now 0 s) 0.0)
        ((frame-range now s e) (/ (- now (sec s)) (- (sec e) (sec s))))
        ((frame-range now e 999) 1.0)))

(in-package :ror)

(defclass satellite (smi:actor) ())

(defmethod in-frame-range ((this satellite) s e)
  (satellite:frame-range (smi:tm this) s e))

(defmethod draw-charge ((this satellite))
  (sik:circle (- (smi:x this) 0.5) (+ (smi:y this) 13.0) (* 7.0 (satellite:range-rate (smi:tm this) 6 14)) 50 :a 0.8 :f t))

(defmethod draw-pre-fire ((this satellite))
  (sik:line (- (smi:x this) 0.5) (+ (smi:y this) 12.0) (- (smi:x this) 0.5) (- (sik:get-height) 30.0) 
            :r 1.0 :g 1.0 :b 1.0 :a 0.5 :w 1.0))

(defmethod draw-fire ((this satellite))
  (let (rng half)
    (setf rng 40.0)
    (setf half (/ rng 2.0))
    (loop for i from 0 to 30 do 
      (sik:line (- (smi:x this) 0.5) (+ (smi:y this) 12.0) 
                (+ (- (smi:x this) 0.5) (- (random rng) half)) (- (sik:get-height) 30.0) 
                :r 1.0 :g 1.0 :b 1.0 :a 0.5 :w 3.0)))
  (sik:circle (- (smi:x this) 0.5) (+ (smi:y this) 13.0) 7.0 50 :a 0.8 :f t))

(defmethod smi:draw ((this satellite))
  (sik:image *tex-satellite* (- (smi:x this) 3.0) (+ (smi:y this) 3.0) 
             :r 1.0 :g 1.0 :b 1.0 :a 1.0 :sx 0.6 :sy 0.6)
  
  (cond ((in-frame-range this 6 14) 
         (progn
           (draw-pre-fire this)  
           (draw-charge this)))
        ((in-frame-range this 14 19) 
         (progn 
           (when (equal 0 (mod (smi:tm this) 20))
             (let ((e (make-instance 'boom)))
              (setf (smi:x e) (+ (smi:x this) (- (random 30.0) 15.0)))
              (setf (smi:y e) (- (sik:get-height) 30.0))
              (smi:register (actor-mng *game*) e)))    
           (draw-fire this)))))

(defmethod smi:updt ((this satellite))
  (call-next-method)
  (cond ((in-frame-range this 0 4) (setf (smi:dy this) 0.3))
        ((in-frame-range this 20 30) (decf (smi:dy this) 0.03))
        ((in-frame-range this 30 99) (smi:kill this))))

(defmethod smi:kill ((this satellite))
	(let ((e (make-instance 'explosion)))
    (setf (smi:x e) (smi:x this))
    (setf (smi:y e) (smi:y this))
		(smi:register (actor-mng *game*) e))
  (call-next-method))

(in-package :cl-user)

