
(in-package :primarvarden)

;;; All companies
(defun all-companies (&optional arg)
  "Accepts an argument (passed by dropdown choices) and returns all
available companies."
  (declare (ignore arg))
  (find-persistent-objects (*prevalence-store*) 'company
;  (find-persistent-objects (sandbox-store) 'company
			   :order-by (cons 'name :asc)))

;;; Company
(defclass company ()
  ((id :accessor company-id)
   (namn :accessor company-name
	 :initarg :company-name
	 :type string)
   ;; (område :initform nil
   ;; 	     :accessor company-industry
   ;; 	     :initarg :industry)))
   (ägartyp :accessor company-type
            :type (member :offentlig :privat))))

;;; Table View
(defview company-table-view (:type table :inherit-from '(:scaffold company))
  (id :hidep t))

;;; Form View
(defview company-form-view (:type form :inherit-from '(:scaffold company)
				  :caption "Ägare")
  (id :hidep t))

