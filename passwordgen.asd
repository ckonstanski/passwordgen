;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10 -*-
(declaim (optimize (speed 0) (safety 3) (debug 3)))

(in-package #:cl)

;; ========================================================================== ;;

(defpackage #:passwordgen-system (:use #:cl #:asdf))
(in-package #:passwordgen-system)

;; ========================================================================== ;;

(defmacro do-defsystem (&key name version maintainer author description long-description depends-on components)
  `(defsystem ,name
       :name ,name
       :version ,version
       :maintainer ,maintainer
       :author ,author
       :description ,description
       :long-description ,long-description
       :depends-on ,(eval depends-on)
       :components ,components))

;; ========================================================================== ;;

(defparameter *asdf-packages* '(ironclad cl-base64))

;; ========================================================================== ;;

(loop for pkg in *asdf-packages* do
     (ql:quickload (symbol-name pkg)))

;; ========================================================================== ;;

(do-defsystem :name "passwordgen"
              :version "20171026.0"
              :maintainer "Carlos Konstanski <carlos.konstanski@verizonwireless.com>"
              :author "Carlos Konstanski <carlos.konstanski@verizonwireless.com>"
              :description "Password Generator"
              :long-description "A fun password generator written in Common Lisp."
              :depends-on *asdf-packages*
              :components ((:module application
                            :components ((:file "application")))))
