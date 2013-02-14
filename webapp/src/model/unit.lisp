
(in-package :primarvarden)

;;; All units
(defun all-units (&optional arg)
  "Accepts an argument (passed by dropdown choices) and returns all
available units."
  (declare (ignore arg))
  (find-persistent-objects *prevalence-store* 'unit
;  (find-persistent-objects (sandbox-store) 'unit
			   :order-by (cons 'name :asc)))

;;; Unit
(defclass unit ()
  ((id :accessor unit-id)
   (title :accessor unit-name
	    :initarg :unit-name)
   (area :accessor unit-hsn
	    :initarg :area-name)
   (street :accessor unit-street
	 :initarg :unit-street)
   (postal-code :accessor unit-postal-code
	 :initarg :unit-postal-code)
   (city :accessor unit-city
	 :initarg :unit-city)
   (company :accessor unit-company
	  :initarg :company)
;	  :type company)
   (unit-type :accessor unit-typ-av-enhet
	     :initarg :typ-av-enhet)))

;;; Table View
(defview unit-table-view (:type table :inherit-from '(:scaffold unit))
  (id :hidep t)
  (street :hidep t)
  (postal-code :hidep t)
  (city :hidep t)
  (company :hidep t))

;;; Data View
(defview unit-data-view (:type data :inherit-from '(:scaffold unit)
			       :caption "Unit")
  (company :reader (compose #'company-name #'unit-company))
  (id :hidep t))

;;; Form View
(defview unit-form-view (:type form :inherit-from '(:scaffold unit)
			       :caption "Unit")
  (id :hidep t)
  (area :present-as (dropdown :choices '(:Hisingen :Väster :Nordost :Södra-södra-Bohuslän :Norra-södra-Bohuslän))
	  :parse-as keyword)
  (company :present-as (dropdown :choices #'all-companies
				 :label-key #'company-name)
	   :parse-as (object-id :class-name 'company)
	   :reader (compose #'object-id #'unit-company)
	   :requiredp t)
  (unit-type :present-as (dropdown :choices '(:health-center :nursing-center :maternity-care-center :rehab :annan))
		:parse-as keyword))
