
(in-package :primarvarden)

;;; Employee
(defclass employee (person)
  ((id :accessor person-id)
   (förnamn :accessor person-first-name
            :initarg :first-name)
   (efternamn :accessor person-last-name
              :initarg :last-name
              :type string)
   (akademisk-grad :accessor person-academic-grade
                   :initarg :academic-grade)
   (yrke :accessor person-profession
         :initarg :profession)
   (address :initform (make-instance 'address)
            :accessor person-address
            :initarg :address)
   (FoUU-roll :accessor employee-contract
              :initarg :FoUU-roll)
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
  (akademisk-grad :hidep t)
  (yrke :hidep t)
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
  (akademisk-grad :present-as (dropdown :choices '(:Disputerad :Docent :Professor :Doktorand :Predoktorand :Kandidat))
	  :parse-as keyword)
  (yrke :present-as (checkboxes :choices '(:arbetsterapeut :barnmorska :distriktssköterska :läkare :psykolog  :sjukgymnast :sjuksköterska :socionom/kurator :specialistsjuksköterska :annan))
	  :parse-as keyword))

