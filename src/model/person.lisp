
(in-package :primarvarden)

;;; Person
(defclass person ()
  ((id :accessor person-id)
   (förnamn :accessor person-first-name
	       :initarg :first-name)
   (efternamn :accessor person-last-name
	      :initarg :last-name
	      :type string)
   ;; (ålder :accessor person-age
   ;; 	:initarg :age
   ;; 	:type (or null integer))
   (address :initform (make-instance 'address)
	    :accessor person-address
	    :initarg :address)))

(defmethod person-name ((person person))
  (format nil "~A ~A" (person-first-name person) (person-last-name person)))

;;; Table View
(defview person-table-view (:type table :inherit-from '(:scaffold person))
  (id :hidep t)
  (address :type mixin
	   :view '(table address))
  (street :hidep t)
  (city :hidep t))

;;; Data View
(defview person-data-view (:type data :inherit-from '(:scaffold person))
  (id :hidep t)
  (address :type mixin
	   :view '(data address)))

;;; Form View
(defview person-form-view (:type form :inherit-from '(:scaffold person))
  (id :hidep t)
  (address :type mixin
	   :view 'address-form-view))

