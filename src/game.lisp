(in-package :ror)

; Class game.
(defclass game () 
  ((ls-actors
     :accessor ls-actor
     :initform (list))
	 (ls-my-missile
		 :accessor ls-my-missile
		 :initform (list))
	 (ls-explosion
		 :accessor ls-explosion
		 :initform (list))
	 (ls-boom
		 :accessor ls-boom
		 :initform (list))
	 (ls-missle
		 :accessor ls-missile
		 :initform (list))
	 (ls-city
		 :accessor ls-city
		 :initform (list))
   (tm
     :accessor tm
     :initform 0)
	 (level
		 :accessor level
		 :initform 1.0)
	 (over
		 :accessor over
		 :initform nil)
	 (score
		 :accessor score
		 :initform 0)
   (actor-mng
     :accessor actor-mng
     :initform (make-instance 'smi:actor-mng))))

; Ctor.
(defmethod initialize-instance :around ((this game) &key) 
	(call-next-method this)
  (defparameter *tex-missile* 
    (make-instance 'sik:texture :src (sik-png:load-png #p"./resource/missile.png")))
  (defparameter *tex-city* 
    (make-instance 'sik:texture :src (sik-png:load-png #p"./resource/city.png")))
  (defparameter *tex-satellite* 
    (make-instance 'sik:texture :src (sik-png:load-png #p"./resource/satellite.png")))
  (defparameter *tex-noise* 
    (make-instance 'sik:texture :src (sik-png:load-png #p"./resource/noise.png")))
  (defparameter *tex-exp* 
    (make-instance 'sik:texture :src (sik-png:load-png #p"./resource/exp.png")))
  (defparameter *tex-scope* 
    (make-instance 'sik:texture :src (sik-png:load-png #p"./resource/scope.png")))
  (defparameter *tex-bomber* 
    (make-instance 'sik:texture :src (sik-png:load-png #p"./resource/bomber_small.png")))
	(create-city this))

; Create city.
(defun create-city (game)
  (loop for i from 0 below 5 do
    (let ((c (make-instance 'city)))
      (setf (smi:x c) (* (+ 1 (* 2 i)) (/ (sik:get-width) 10.0)))
      (setf (smi:y c) (- (sik:get-height) 32.0))
      (smi:register (actor-mng game) c))))

; Load texture.
(defun load-tex (path width height) 
  (make-instance 'sik:texture :path path :width width :height height))

(defmethod register ((this game) (obj explosion))
  (setf (ls-explosion this) (cons obj (ls-explosion this))))

(defmethod register ((this game) (obj missile))
  (setf (ls-missile this) (cons obj (ls-missile this))))

(defmethod register ((this game) (obj my-missile))
  (setf (ls-my-missile this) (cons obj (ls-my-missile this))))

(defmethod register ((this game) (obj boom))
  (setf (ls-boom this) (cons obj (ls-boom this))))

(defmethod register ((this game) (obj city))
  (setf (ls-city this) (cons obj (ls-city this))))

(defmethod cleanup ((this game))
 (setf (ls-city this) (remove-if #'smi:killedp (ls-city this)))
 (setf (ls-boom this) (remove-if #'smi:killedp (ls-boom this)))
 (setf (ls-my-missile this) (remove-if #'smi:killedp (ls-my-missile this)))
 (setf (ls-explosion this) (remove-if #'smi:killedp (ls-explosion this)))
 (setf (ls-missile this) (remove-if #'smi:killedp (ls-missile this))))

; Draw.
(defmethod draw ((this game))
  ; Clear.
  (sik:rect 0.0 0.0 (sik:get-width) (sik:get-height) :r 0.1 :g 0.1 :b 0.1 :a 0.3)

  (let ((am (actor-mng this)))
    ; (sik:image *tex-back* 250.0 220.0 :r 1.0 :g 1.0 :b 1.0 :a 1.0) 
		; (sik:rect 0.0 (- (sik:get-height) 32.0 9.0) (sik:get-width) (sik:get-height) :r 1.0 :g 1.0 :b 1.0)
    (sik:line 0.0 (- (sik:get-height) 32.0) (sik:get-width) (- (sik:get-height) 32.0))
    (smi:draw-all-actors am)
    ; (smi:draw-obj am (ls-my-missile this))
    ; (smi:draw-obj am (ls-explosion this))
    ; (smi:draw-obj am (ls-missile this))
    ; (smi:draw-obj am (ls-city this))
    ; (smi:draw-obj am (ls-boom this))
    ; (sik:image *tex-gnd* 250.0 490.0 :r 1.0 :g 1.0 :b 1.0 :a 1.0) 

    ; Noise.
    (loop for i from 0 to 100 do 
          (sik:point (random (sik:get-width)) (random (sik:get-height)) :r 1.0 :g 1.0 :b 1.0 :a 0.3 :s 2.0))
    
    (loop for i from 0 to 10 do
          (let ((r (random 60))
                (y (random (sik:get-height)))) 
            (when (equal r 0)
              (sik:line 0.0 y (sik:get-width) y :a 0.5 :w (random 1.0)))))
    
    ; Noise.
    (sik:image *tex-noise* (/ (sik:get-width) 2.0) (/ (sik:get-height) 2.0) :a 1.0)
    
    ; Scope
    (sik:image *tex-scope* (/ (sik:get-width) 2.0) (/ (sik:get-height) 2.0) :r 1.0 :g 1.0 :b 1.0 :a 0.2)
    
		(sik:rect 0.0 (- (sik:get-height) 32.0) (sik:get-width) (sik:get-height) :r 0.0 :g 0.0 :b 0.0)
		(sik:texts (format nil "SCORE : ~A" (score this)) 10 485 :sx 0.6 :sy 0.7))
		(when (over this) 
			(sik:texts "GAME OVER" 180.0 200.0 :aa t :a 0.8 :sx 1.5 :sy 0.8)
			(sik:texts "CLICK TO GO MENU" 165.0 250.0 :aa t :a 0.8 :sx 1.0 :sy 0.8)))

(defmethod updt ((this game))
  ; (format t "~A~%" (length (ls-my-missile this)))

  (let ((am (actor-mng this)))
    (incf (tm this))
    
    
    (smi:updt-all-actors am)
    (smi:remove-not-alive am)
    (smi:collide-all-actors am)
    
		(when (and (equal 0 (mod (tm this) 60)) (not (over this)))
			(incf (score this) 10))

    
		; (smi:updt-obj am (ls-my-missile this))
		; (smi:updt-obj am (ls-explosion this))
		; (smi:updt-obj am (ls-missile this))
		; (smi:updt-obj am (ls-boom this))
		; (smi:updt-obj am (ls-city this))

		(when (and (sik:get-mouse-push :left)
							 (< (length (ls-my-missile this)) 5)
               (< (length (remove-if-not (lambda (e) (typep e 'my-missile)) (smi:actors am))) (length (remove-if-not (lambda (e) (typep e 'city)) (smi:actors am))))
               )
      (let* ((mm (make-instance 'my-missile
																; :x (/ (sik:get-width) 2.0)
																; :y (sik:get-height)
                                ))
             theta
             dx
             dy
						 ; (theta (atan (- (sik:get-mouse-y) (smi:y mm)) (- (sik:get-mouse-x) (smi:x mm))))
						 ; (dx (* (cos theta) my-missile:*spd*))
						 ; (dy (* (sin theta) my-missile:*spd*))
             nearest
             fire-x
             )
        (setf nearest 999.0)
        (mapc (lambda (e) 
                (when (< (smi:distance-to-xy e (sik:get-mouse-x) (sik:get-mouse-y)) nearest) 
                  (setf fire-x (smi:x e))
                  (setf nearest (smi:distance-to-xy e (sik:get-mouse-x) (sik:get-mouse-y))))) 
              (remove-if-not (lambda (e) (typep e 'city)) (smi:actors am)))
        
        (setf (tx mm) (sik:get-mouse-x))
        (setf (ty mm) (sik:get-mouse-y))
        
        (setf (smi:x mm) (/ (sik:get-width) 2.0))
        (setf (smi:x mm) fire-x)
        (setf (smi:y mm) (sik:get-height))

        (setf (smi:old-x mm) (smi:x mm))
        (setf (smi:old-y mm) (smi:y mm))
        
        (setf theta (atan (- (sik:get-mouse-y) (smi:y mm)) (- (sik:get-mouse-x) (smi:x mm))))
        (setf (smi:theta mm) theta)
        (setf dx (* (cos theta) my-missile:*spd*))
        (setf dy (* (sin theta) my-missile:*spd*))
				; (setf (smi:duration mm) (floor (/ (dist (sik:get-mouse-x) (sik:get-mouse-y) (smi:x mm) (smi:y mm)) my-missile:*spd*)))
				(setf (smi:duration mm) (floor (/ (smi:distance-to-xy mm (sik:get-mouse-x) (sik:get-mouse-y)) my-missile:*spd*)))
				(setf (smi:dx mm) dx)
				(setf (smi:dy mm) dy)
				(smi:register am mm)))

    ; 3000
    (when (equal 0 (mod (tm this) (- 3000 (ceiling (* (level this) 2.0)))))
      (let ((b (make-instance 'spawner-bomber)))
        (smi:register (actor-mng this) b)))
    
		(when (equal 0 (mod (tm this) (- 60 (ceiling (* (level this) 2.0)))))
			(let* ((x (random (sik:get-width)))
						 (y -10.0)
						 (tx (random (sik:get-width)))
						 (theta (atan (- (- (sik:get-height) 32.0) y) (- tx x)))
						 (dy (* 0.3 (level this) (sin theta)))
						 (dx (* 0.3 (level this) (cos theta)))
						 (m (make-instance 'missile
						 									; :x x
						 									; :y y
						 									; :dx dx
						 									; :dy dy
                              )))
        (setf (smi:theta m) theta)
        (setf (smi:x m) x)
        (setf (smi:y m) y)
        (setf (smi:dx m) dx)
        (setf (smi:dy m) dy)
				(smi:register am m)
        ))

		(when (and (equal 0 (mod (tm this) (- (+ 300 (random 300)) (ceiling (* (level this) 2.0)))))
               (> (length (remove-if-not (lambda (e) (typep e 'city)) (smi:actors am))) 0)
               (equal (length (remove-if-not (lambda (e) (typep e 'satellite)) (smi:actors am))) 0)
               )
			(let* ((s (make-instance 'satellite))
             cities)
        (setf cities (remove-if-not (lambda (e) (typep e 'city)) (smi:actors am)))
        (setf (smi:x s) (smi:x (nth (random (length cities)) cities)))
        ; (setf (smi:x s) (/ (sik:get-width) 2.0))
        (setf (smi:d-dump s) 0.95)
        (setf (smi:y s) -30.0)
				(smi:register am s)))

		(when (equal 0 (mod (tm this) 600))
			(incf (level this) 0.2))

		(when (equal 0 (length (remove-if-not (lambda (e) (typep e 'city)) (smi:actors am))))
			(setf (over this) t))

		(when (and (over this) (sik:get-mouse-push :left))
			(setf *game* (make-instance 'menu)))

    (cleanup this)))

(in-package :cl-user)

