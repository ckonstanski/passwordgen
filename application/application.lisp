;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10 -*-
(declaim (optimize (speed 0) (safety 3) (debug 3)))

(defpackage #:passwordgen
  (:use #:cl)
  (:export #:passwordgen))

(in-package #:passwordgen)

;; ========================================================================== ;;

(defun generate-password (numchars)
  (let (result
        (rndstring (make-array '(0) :element-type 'base-char :fill-pointer 0 :adjustable t)))
    (with-open-file (urandom-file "/dev/urandom" :direction :input :element-type '(unsigned-byte 8))
      (with-output-to-string (stream rndstring)
        (dotimes (i 128)
          (let ((octet (read-byte urandom-file)))
            (if (< octet 16)
                (setf octet (format nil "0~x" octet))
                (setf octet (format nil "~x" octet)))
            (format stream "~a" octet)))))
    (let ((digest (ironclad:make-digest 'ironclad:sha512)))
      (ironclad:update-digest digest (ironclad:hex-string-to-byte-array rndstring))
      (setf result (cl-base64:usb8-array-to-base64-string (ironclad:produce-digest digest))))
    (subseq result 0 (if (> numchars 80) 80 numchars))))
