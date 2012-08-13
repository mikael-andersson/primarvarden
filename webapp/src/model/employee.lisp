
(in-package :primarvarden)

;;; Employee
(defclass employee (person)
   ((FoUU-roll :accessor employee-contract
	     :initarg :FoUU-roll)
    (emails :accessor employee-emails :initarg :emails)
    (phone-numbers :accessor employee-phone-numbers :initarg :phone-numbers)))

;;; Table View
(defview employee-table-view (:type table :inherit-from 'person-table-view))

(defmethod delete-persistent-object :before (store (object employee)) 
  (flet ((destroy (item)
           (delete-persistent-object *default-store* item)))
    (mapcar #'destroy (find-by-values 'project-person :person object))))

(defmethod delete-persistent-object-by-id :before (store (object (eql 'employee)) id) 
  (let ((item (first-by-values 'employee :id id)))
    (if item 
      (delete-persistent-object *default-store* item))))
