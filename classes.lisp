;;;; -*- Mode: Lisp; indent-tabs-mode: nil -*-
;;;; ==========================================================================
;;;; parse-xsd.lisp --- This file is used to parse X3D xsd file
;;;;
;;;; Copyright (c) 2011, Nikhil Shetty <nikhil.j.shetty@gmail.com>
;;;;   All rights reserved.
;;;;
;;;; Redistribution and use in source and binary forms, with or without
;;;; modification, are permitted provided that the following conditions
;;;; are met:
;;;;
;;;;  o Redistributions of source code must retain the above copyright
;;;;    notice, this list of conditions and the following disclaimer.
;;;;  o Redistributions in binary form must reproduce the above copyright
;;;;    notice, this list of conditions and the following disclaimer in the
;;;;    documentation and/or other materials provided with the distribution.
;;;;  o Neither the name of the author nor the names of the contributors may
;;;;    be used to endorse or promote products derived from this software
;;;;    without specific prior written permission.
;;;;
;;;; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
;;;; "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
;;;; LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
;;;; A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT
;;;; OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
;;;; SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
;;;; LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
;;;; DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
;;;; THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
;;;; (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
;;;; OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
;;;; ==========================================================================

(in-package :xs)
;; (in-package :xml)

;; ----------------------------------------------------------------------------
(defclass  x3d (xml-serializer)
  ()
  (:documentation "x3d"))

;; ----------------------------------------------------------------------------
(defclass schema (x3d)
  ((id :initarg :id
         :initform ""
         :documentation "Optional. Specifies a unique id for the element")
   (attributeFormDefault :initarg :attributeFormDefault
         :initform ""
         :accessor attributeFormDefault
         :documentation "attribute form default = qualified|unqualified")
   (elementFormDefault :initarg :elementFormDefault
         :initform ""
         :accessor elementFormDefault
         :documentation "element form default")
   (version :initarg :version
         :initform ""
         :accessor version
         :documentation "version string")
   (xs :initarg :xs
       :initform ""
       :accessor :xs
       :documentation "Hack making another xmlns alias to get xmlns:xs")
   (annotation :initarg :annotation
         :initform nil
         :accessor annotation
         :type annotation
         :documentation "annotation")
   (includes
         :initform nil
         :accessor includes
         :documentation "include schema location")
   (simpleTypes
         :initform nil
         :accessor simpleTypes
         :documentation "A list of all Simple Types")
   (complexTypes
         :initform nil
         :accessor complexTypes
         :documentation "List of Complex types")
   (groups
         :initform nil
         :accessor groups
         :documentation "List of group")
   (attributeGroups
         :initform nil
         :accessor attributeGroups
         :documentation "List of attribute groups")
   (elements
         :initform nil
         :accessor elements
         :documentation "List of elements"))
  (:documentation "The main schema object"))

;; ----------------------------------------------------------------------------
(defclass include (x3d)
  ((schemaLocation :initarg :schemaLocation
         :initform ""
         :accessor schemaLocation
         :documentation "gives the location of the schema"))
  (:documentation "include object"))

(with-packages-unlocked (cl)
;; ----------------------------------------------------------------------------
  (defclass simpleType (x3d)
    ((name :initarg :name
           :initform ""
           :accessor name
           :documentation "name of the simple type")
     (restriction :initarg :restriction
                  :initform nil
                  :accessor restriction
                  :documentation "restriction")
     (list :initarg :list
           :initform nil
           :accessor list
           :documentation "list of stuff")
     (annotation :initarg :annotation
                 :initform nil
                 :accessor annotation
                 :type annotation
                 :documentation "annotation for simple type"))
    (:documentation "doc"))

;; ----------------------------------------------------------------------------
  (defclass list (x3d)
    ((itemType :initarg :itemType
               :initform nil
               :accessor itemType
               :documentation "lists item type"))
    (:documentation "xs:list contains a list of stuff"))

  t)

;; ----------------------------------------------------------------------------
(defclass  complexType (x3d)
  ((name :initarg :name
         :initform nil
         :accessor name
         :documentation "complex type name")
   (abstract :initarg :abstract
         :initform nil
         :accessor abstract
         :documentation "complex type Abstract")
   (mixed :initarg :mixed
         :initform nil
         :accessor mixed
         :documentation "comlplex type mixed")
   (annotation :initarg :annotation
         :initform nil
         :accessor annotation
         :type annotation
         :documentation "annotation")
   (complexContent :initarg :complexContent
         :initform nil
         :accessor complexContent
         :documentation "complexType:complexContent")
   (attributes
         :initform nil
         :accessor attributes
         :documentation "extension:attributes")
   (sequence-cl :initarg :sequence-cl
         :initform nil
         :accessor sequence-cl
         :documentation "complexType:sequence")
   (attributeGroups
         :initform nil
         :accessor attributeGroups
         :documentation "complexType:attributeGroups")
   (all-instances
         :initform (make-hash-table :test 'equal)
         :accessor all-instances
         :allocation :class
         :documentation "Specially added to capture all instances of
         this class. This is a map which maps the name to the
         object"))
  (:documentation "complex types"))

;; ----------------------------------------------------------------------------
;; (defmethod initialize-instance :after ((self complexType) &key)
;;   "We are simply capturing all the instances of this particular class"
;;   (with-slots (name all-instances) self
;;     (setf (gethash name all-instances) self)))
  
;; ----------------------------------------------------------------------------
(defclass  complexContent (x3d)
  ((extension :initarg :extension
         :initform nil
         :accessor extension
         :documentation "complexContent:extension"))
  (:documentation "complexContent"))

;; ----------------------------------------------------------------------------
(defclass  extension (x3d)
  ((base :initarg :base
         :initform nil
         :accessor base
         :documentation "extension:base")
   (group :initarg :group
         :initform nil
         :accessor group
         :documentation "extension:group")
   (attributes
         :initform nil
         :accessor attributes
         :documentation "extension:attributes")
   (sequence-cl :initarg :sequence
         :initform nil
         :accessor sequence-cl
         :documentation "extension:sequence")
   (attributeGroups
         :initform nil
         :accessor attributeGroups
         :documentation "extension:attributeGroups")
   (choices
         :initform nil
         :accessor choices
         :documentation "extension:choices")
   (annotation :initarg :annotation
         :initform nil
         :accessor annotation
         :documentation "sequence:annotation"))
  (:documentation "doc"))

;; ----------------------------------------------------------------------------
(defclass sequence-cl (x3d)
  ((minOccurs :initarg :minOccurs
         :initform nil
         :accessor minOccurs
         :documentation "sequence:minOccurs")
   (maxOccurs :initarg :maxOccurs
         :initform nil
         :accessor maxOccurs
         :documentation "sequence::maxOccurs")
   (groups
         :initform nil
         :accessor groups
         :documentation "sequence:groups")
   (elements
         :initform nil
         :accessor elements
         :documentation "sequence:elements")
   (choices
         :initform nil
         :accessor choices
         :documentation "sequence:choice")
   (sequence-cls
         :initform nil
         :accessor sequence-cls
         :documentation "sequence:sequence")
   (annotation :initarg :annotation
         :initform nil
         :accessor annotation
         :documentation "sequence:annotation"))
  (:documentation "doc"))

;; ----------------------------------------------------------------------------
(defclass element (x3d)
  ((name :initarg :name
         :initform nil
         :accessor name
         :documentation "element:name")
   (ref :initarg :ref
         :initform nil
         :accessor ref
         :documentation "element:ref")
   (minOccurs :initarg :minOccurs
         :initform nil
         :accessor minOccurs
         :documentation "element:minOccurs")
   (maxOccurs :initarg :maxOccurs
         :initform nil
         :accessor maxOccurs
         :documentation "element:maxOccurs")
   (annotation :initarg :annotation
         :initform nil
         :accessor annotation
         :documentation "element:annotation")
   (complexType :initarg :complexType
         :initform nil
         :accessor complexType
         :documentation "element:complexType"))
  (:documentation "element"))

;; ----------------------------------------------------------------------------
(defclass  group  (x3d)
  ((name :initarg :name
         :initform nil
         :accessor name
         :documentation "group:name")
   (ref :initarg :ref
         :initform nil
         :accessor ref
         :documentation "group:ref")
   (minOccurs :initarg :minOccurs
         :initform nil
         :accessor minOccurs
         :documentation "group:minOccurs")
   (maxOccurs :initarg :maxOccurs
         :initform nil
         :accessor maxOccurs
         :documentation "group:maxOccurs")
   (choice :initarg :choice
         :initform nil
         :accessor choice
         :documentation "group:choice")
   (sequence-cls
         :initform nil
         :accessor sequence-cls
         :documentation "choice:sequences")
   (annotation :initarg :annotation
         :initform nil
         :accessor annotation
         :documentation "group:annotation"))
  (:documentation "group"))

;; ----------------------------------------------------------------------------
(defclass  choice (x3d)
  ((minOccurs :initarg :minOccurs
         :initform nil
         :accessor minOccurs
         :documentation "choice:minOccurs")
   (maxOccurs :initarg :maxOccurs
         :initform nil
         :accessor maxOccurs
         :documentation "choice:maxOccurs")
   (groups
         :initform nil
         :accessor groups
         :documentation "choice:groups")
   (choices
         :initform nil
         :accessor choices
         :documentation "group:choice")
   (elements :initarg :elements
         :initform nil
         :accessor elements
         :documentation "choice:elements")
   (sequence-cls
         :initform nil
         :accessor sequence-cls
         :documentation "choice:sequences")
  (annotation :initarg :annotation
         :initform nil
         :accessor annotation
         :documentation "group:annotation"))
  (:documentation "choice"))

;; ----------------------------------------------------------------------------
(defclass  attributeGroup  (x3d)
  ((name :initarg :name
         :initform nil
         :accessor name
         :documentation "attribute group name")
   (annotation  :initarg :annotation
         :initform nil
         :accessor annotation
         :documentation "attribute Group Annotation")
   (attributes
         :initform nil
         :accessor attributes
         :documentation "attribute group attributes")
   (ref :initarg :ref
         :initform nil
         :accessor ref
         :documentation "attributeGroup:ref"))
  (:documentation "Attribute group"))

(with-packages-unlocked (cl)
;; ----------------------------------------------------------------------------
(defclass  attribute (x3d)
  ((name :initarg :name
         :initform nil
         :accessor name
         :documentation "name of attribute")
   (type  :initarg :type
         :initform nil
         :accessor type
         :documentation "attribute Type")
   (default :initarg :default
         :initform nil
         :accessor default
         :documentation "attribute:default")
   (fixed :initarg :fixed
         :initform nil
         :accessor fixed
         :documentation "attribute:fixed")
   (use :initarg :use
         :initform nil
         :accessor use
         :documentation "attribute:use")
   (annotation  :initarg :annotation
         :initform nil
         :accessor annotation
         :documentation "attribute Annotation")
   (simpleType :initarg :simpleType
         :initform nil
         :accessor simpleType
         :documentation "attribute:simpleType"))
  (:documentation "attribute class"))
t)

;; ----------------------------------------------------------------------------
(defclass annotation  (x3d)
  ((id :initarg :id
         :initform ""
         :accessor id
         :documentation "Optional. Specifies a unique id for the element")
   (appInfo :initarg :appInfo
         :initform ""
         :accessor appInfo
         :documentation "appInfo")
   (documentation :initarg :documentation
         :initform ""
         :accessor documentation
         :documentation "documentation"))
  (:documentation "okay"))

;; ----------------------------------------------------------------------------
(defclass restriction (x3d)
  ((base :initarg :base
         :initform nil
         :accessor base
         :documentation "about-slot")
   (minInclusive :initarg :minInclusive
         :initform nil
         :accessor minInclusive
         :type minInclusive
         :documentation "minInclusive")
   (maxInclusive :initarg :maxInclusive
         :initform nil
         :accessor maxInclusive
         :type maxInclusive
         :documentation "maxInclusive")
   (minExclusive :initarg :minExclusive
         :initform nil
         :accessor minExclusive
         :type minExclusive
         :documentation "minExclusive")
   (maxExclusive :initarg :maxExclusive
         :initform nil
         :accessor maxExclusive
         :type maxExclusive
         :documentation "maxExclusive")
   (whiteSpace :initarg :whiteSpace
         :initform nil
         :accessor whiteSpace
         :documentation "restriction attribute whitespace")
   (pattern :initarg :pattern
         :initform nil
         :accessor pattern
         :documentation "restriction attribute pattern")
   (minLength :initarg :minLength
         :initform nil
         :accessor minLength
         :documentation "restriction attribute minLength")
   (enumerations
         :initform nil
         :accessor enumerations
         :documentation "restriction attribute enumerations"))
  (:documentation "doc"))

;; ----------------------------------------------------------------------------
(defclass  restriction-attribute (x3d)
  ((value :initarg :value
         :initform nil
         :accessor value
         :documentation "value"))
  (:documentation "Base of all restriction types like minInclusive, maxInclusive etc"))

;; ----------------------------------------------------------------------------
(defclass  minInclusive (restriction-attribute)
  ()
  (:documentation "minInclusive"))

;; ----------------------------------------------------------------------------
(defclass  maxInclusive (restriction-attribute)
  ()
  (:documentation "maxInclusive"))

;; ----------------------------------------------------------------------------
(defclass  minExclusive (restriction-attribute)
  ()
  (:documentation "minExclusive"))

;; ----------------------------------------------------------------------------
(defclass  maxExclusive (restriction-attribute)
  ()
  (:documentation "maxExclusive"))

;; ----------------------------------------------------------------------------
(defclass whiteSpace (restriction-attribute)
  ()
  (:documentation "whiteSpace"))

;; ----------------------------------------------------------------------------
(defclass  pattern (restriction-attribute)
  ()
  (:documentation "pattern"))

;; ----------------------------------------------------------------------------
(defclass minLength (restriction-attribute)
  ()
  (:documentation "minLength"))

;; ----------------------------------------------------------------------------
(defclass enumeration (restriction-attribute)
  ((annotation :initarg :annotation
         :initform nil
         :accessor annotation
         :documentation "enumeration annotation"))
  (:documentation "maxInclusive"))

;; ----------------------------------------------------------------------------
(defclass appinfo (x3d)
  ((attribute :initarg :attribute
         :initform nil
         :accessor attribute
         :documentation "appinfo:attribute"))
  (:documentation "appinfo"))

(with-packages-unlocked (cl)
;; ----------------------------------------------------------------------------
  (defclass documentation (x3d)
    ((source :initarg :source
             :initform nil
             :accessor source
             :documentation "source of the documentation"))
    (:documentation "documentation"))
  t)

;; ----------------------------------------------------------------------------
(defclass  NMTOKEN (x3d)
  ()
  (:documentation ""))

(defun NMTOKEN ())
