
(in-package :primarvarden)

;;; All units
(defun all-units (&optional arg)
  "Accepts an argument (passed by dropdown choices) and returns all
available units."
  (declare (ignore arg))
  (find-persistent-objects (*prevalence-store*) 'unit
;  (find-persistent-objects (sandbox-store) 'unit
			   :order-by (cons 'name :asc)))

;;; Unit
(defclass unit ()
  ((id :accessor unit-id)
  (område :accessor unit-hsn
	    :initarg :area-name
	    :type (or hsn null))
   (gata :accessor unit-street
	 :initarg :unit-street)
   (postnummer :accessor unit-postal-code
	 :initarg :unit-postal-code)
   (ort :accessor unit-city
	 :initarg :unit-city)
   (typ-av-enhet :accessor unit-typ-av-enhet
	     :initarg :typ-av-enhet)))

;;; Table View
(defview unit-table-view (:type table :inherit-from '(:scaffold unit))
;  (hsn :reader (compose #'company-name #'unit-hsn))
  (id :hidep t))

;;; Data View
(defview unit-data-view (:type data :inherit-from '(:scaffold unit))
  (id :hidep t)
;  (company :reader (compose #'company-name #'unit-hsn))
  (typ-av-enhet))

;;; Form View
(defview unit-form-view (:type form :inherit-from '(:scaffold unit)
			       :caption "Enhet")
 ; (hsn :present-as (dropdown :choices #'all-companies
;				 :label-key #'company-name)
;	   :parse-as (object-id :class-name 'company)
;	   :reader (compose #'object-id #'unit-hsn)
;	   :requiredp t)
  (id :hidep t)
  (typ-av-enhet :present-as (radio :choices '(:vårdcentral :barnavårdcentral :mödravårdcentral :annan))
		:parse-as keyword))
