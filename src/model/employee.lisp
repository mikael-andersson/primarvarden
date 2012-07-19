
(in-package :primarvarden)

;;; Employee
(defclass employee (person)
   ((FoUU-roll :accessor employee-contract
	     :initarg :FoUU-roll)))

;;; Table View
(defview employee-table-view (:type table :inherit-from 'person-table-view))
