
(in-package :primarvarden)

;;; All projects
(defun all-projects (&optional arg)
  "Accepts an argument (passed by dropdown choices) and returns all
available projects."
  (declare (ignore arg))
;  (find-persistent-objects (*prevalence-store*) 'project
  (find-persistent-objects (sandbox-store) 'project
			   :order-by (cons 'name :asc)))

;;; Project
(defclass project ()
  ((id :accessor project-id)
   (namex :accessor project-namex
	 :initarg :namex
	 :type string))
   (namey :accessor project-namey
	 :initarg :namey
	 :type string))

;;; Table View
(defview project-table-view (:type table :inherit-from '(:scaffold project))
  (id :hidep t))

;;; Form View
(defview project-form-view (:type form :inherit-from '(:scaffold project))
  (id :hidep t))

