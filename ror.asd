
(in-package :cl-user)
(defpackage ror-asd
  (:use :cl :asdf))
(in-package :ror-asd)

(defsystem ror
  :depends-on (:sikisai :senmei :cl-singleton-mixin)
  :components (
    (:module "src"
			:around-compile
				(lambda (thunk)
          ; dev
          (declaim (optimize (speed 0) (debug 3) (safety 3)))
          ; release
          ; (declaim (optimize (speed 3) (debug 0) (safety 0)))
					(funcall thunk))
      :components (
				(:file "package")
				(:file "prototype")
				(:file "satellite")
				(:file "explosion")
				(:file "boom")
				(:file "missile")
				(:file "my-missile")
				(:file "city")
				(:file "game")
				(:file "menu")
        (:file "ror")))))

