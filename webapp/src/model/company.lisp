
(in-package :primarvarden)

;;; All companies
(defun all-companies (&optional arg)
  "Accepts an argument (passed by dropdown choices) and returns all
available companies."
  (declare (ignore arg))
  (find-persistent-objects *prevalence-store* 'company
;  (find-persistent-objects (sandbox-store) 'company
			   :order-by (cons 'name :asc)))

;;; Company
(defclass company ()
  ((id :accessor company-id)
   (name :accessor company-name
	 :initarg :company-name
	 :type string)
   ;; (område :initform nil
   ;; 	     :accessor company-industry
   ;; 	     :initarg :industry)))
   (owner-type :accessor company-type
            :type (member :public :private))))

;;; Table View
(defview company-table-view (:type table :inherit-from '(:scaffold company))
  (id :hidep t))

;;; Form View
(defview company-form-view (:type form :inherit-from '(:scaffold company)
				  :caption "Company")
  (id :hidep t))

