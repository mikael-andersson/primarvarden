
(in-package :primarvarden)

;;; Person
(defclass person ()
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
	    :initarg :address)))

(defmethod person-name ((person person))
  (format nil "~A ~A" (person-first-name person) (person-last-name person)))

;;; Table View
(defview person-table-view (:type table :inherit-from '(:scaffold person))
  (id :hidep t)
  (akademisk-grad :hidep t)
  (yrke :hidep t)
  (address :hidep t)
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
	   :view 'address-form-view)
  (akademisk-grad :present-as (dropdown :choices '(:Disputerad :Docent :Professor :Doktorand :Predoktorand :Kandidat))
	  :parse-as keyword)
  (yrke :present-as (checkboxes :choices '(:arbetsterapeut :barnmorska :distriktssköterska :läkare :psykolog  :sjukgymnast :sjuksköterska :socionom/kurator :specialistsjuksköterska :annan))
	  :parse-as keyword))

