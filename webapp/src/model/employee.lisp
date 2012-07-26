
(in-package :primarvarden)

;;; Employee
(defclass employee (person)
   ((FoUU-roll :accessor employee-contract
	     :initarg :FoUU-roll)
    (emails :accessor employee-emails :initarg :emails)
    (phone-numbers :accessor employee-phone-numbers :initarg :phone-numbers)))

;;; Table View
(defview employee-table-view (:type table :inherit-from 'person-table-view))
