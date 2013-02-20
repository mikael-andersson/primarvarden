
(in-package :primarvarden)

;;; All companies
(defun all-employees (&optional arg)
  "Accepts an argument (passed by dropdown choices) and returns all
available employees."
  (declare (ignore arg))
  (find-persistent-objects *prevalence-store* 'employee
			   :order-by (cons 'name :asc)))

;;; Employee
(defclass employee ()
  ((id :accessor person-id)
   (first-name :accessor person-first-name
            :initarg :first-name)
   (last-name :accessor person-last-name
              :initarg :last-name
              :type string)
   (academic-grade :accessor person-academic-grade
                   :initarg :academic-grade)
   (profession :accessor person-profession
         :initarg :profession)
   (address :initform (make-instance 'address)
            :accessor person-address
            :initarg :address)
   (emails :accessor employee-emails :initarg :emails)
   (phone-numbers :accessor employee-phone-numbers :initarg :phone-numbers)))

;;; Table View
(defview employee-table-view (:type table :inherit-from 'person-table-view))

(defmethod delete-persistent-object :before (store (object employee)) 
  (flet ((destroy (item)
           (delete-persistent-object *default-store* item)))
    (mapcar #'destroy (find-by-values 'project-person :person object))))

(defmethod delete-persistent-object-by-id :before (store (object (eql 'employee)) id) 
  (let ((item (first-by-values 'employee :id id)))
    (if item 
      (delete-persistent-object *default-store* item))))

(defmethod person-name ((person employee))
  (format nil "~A ~A" (person-first-name person) (person-last-name person)))

;;; Table View
(defview person-table-view (:type table :inherit-from '(:scaffold employee))
  (id :hidep t)
  (academic-grade :hidep t)
  (profession :hidep t)
  (address :hidep t)
  (street :hidep t)
  (city :hidep t))

;;; Data View
(defview person-data-view (:type data :inherit-from '(:scaffold employee))
  (id :hidep t)
  (address :type mixin
	   :view '(data address)))

;;; Form View
(defview person-form-view (:type form :inherit-from '(:scaffold employee))
  (id :hidep t)
  (address :type mixin
	   :view 'address-form-view)
  (academic-grade :present-as (dropdown :choices '(:PhD :associate-Professor :Professor :PhD-student :graduate))
	  :parse-as keyword)
  (profession :present-as (checkboxes :choices '(:occupational-therapist :midwife :district-nurse :doctor :psychologist  :physiotherapist :nurse :social-worker/counselor :specialist nurse :other))
	  :parse-as checkboxes))

