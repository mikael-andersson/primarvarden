
(in-package :primarvarden)

;;; Employee
(defclass employee (person)
   ((FoUU-roll :accessor employee-contract
	     :initarg :FoUU-roll)))

;;; Table View
(defview employee-table-view (:type table :inherit-from 'person-table-view))

;;; Form View
(defview employee-form-view (:type form :inherit-from 'person-form-view
				   :caption "Person")
  (FoUU-roll :present-as (radio :choices '(:kontaktperson :projektledare :verksamhetschef))
	    :parse-as keyword))
