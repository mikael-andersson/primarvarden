
(in-package :primarvarden)

;;; All projects
(defun all-projects (&optional arg)
  "Accepts an argument (passed by dropdown choices) and returns all
available projects."
  (declare (ignore arg))
  (find-persistent-objects *prevalence-store* 'project
			   :order-by (cons 'name :asc)))

;;; Project
(defclass project ()
  ((id :accessor project-id)
   (titel :accessor project-title
	  :initarg :project-title
	  :type string)
   (handledare :accessor project-manager
	       :initarg :project-manager)))

;;; Data View
(defview project-data-view (:type data :inherit-from '(:scaffold project))
  (id :hidep t))

;;; Table View
(defview project-table-view (:type table :inherit-from '(:scaffold project))
  (id :hidep t))

;;; Form View
(defview project-form-view (:type form :inherit-from '(:scaffold project))
  (id :hidep t))

(defun get-projects-titles ()
  (mapcar #'project-title (all-projects)))

(defun project-persons-list (project)
  (let ((project-persons  (project-employees project)))
    (format nil "~{~A~%~}" (mapcar #'person-name project-persons)))) 
