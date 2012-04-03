
(in-package :primarvarden)

;;; All units
(defun all-units (&optional arg)
  "Accepts an argument (passed by dropdown choices) and returns all
available units."
  (declare (ignore arg))
;  (find-persistent-objects (*prevalence-store*) 'unit
  (find-persistent-objects (sandbox-store) 'unit
			   :order-by (cons 'name :asc)))

;;; Unit
(defclass unit ()
  ((id :accessor unit-id)
   (gata :accessor unit-street
	 :initarg :unit-strett)
   (postnummer :accessor unit-postal-code
	 :initarg :unit-postal-code)
   (ort :accessor unit-city
	 :initarg :unit-city)
   (Typ-av-enhet :accessor unit-type
	 :initarg :unit-type)))

;;; Table View
(defview unit-table-view (:type table :inherit-from '(:scaffold unit))
  (id :hidep t))

;;; Form View
(defview unit-form-view (:type form :inherit-from '(:scaffold unit))
  (id :hidep t))

