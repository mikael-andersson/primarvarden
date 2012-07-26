
(in-package :primarvarden)

;;; Address
(defclass address ()
  ((gata :initform nil
	   :accessor address-street
	   :initarg :street)
   (stad :initform nil
	 :accessor address-city
	 :initarg :city)))

;;; Form View
(defview address-form-view (:type form
			    :inherit-from '(:scaffold address)
			    :persistp nil))

