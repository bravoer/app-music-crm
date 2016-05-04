(in-package :mu-cl-resources)

;;;; define the resource

(define-resource score ()
  :class (s-prefix "music:Score")
  :properties `((:title :string ,(s-prefix "nie:title"))
                (:description :string ,(s-prefix "nie:description"))
                (:composer :string ,(s-prefix "music:composer"))
                (:arranger :string ,(s-prefix "music:arranger"))
                (:duration :string ,(s-prefix "dcterms:extent"))
                (:genre :string ,(s-prefix "music:genre"))
                (:publisher :string ,(s-prefix "nco:publisher"))
                (:status :string ,(s-prefix "bravoer:status"))
		(:created :date ,(s-prefix "dcterms:created"))
		(:modified :date ,(s-prefix "dcterms:modified")))
  :resource-base (s-url "http://data.bravoer.be/id/scores/")
  :has-many `((part :via ,(s-prefix "nie:isLogicalPartOf")
			   :inverse t
			   :as "parts"))
  :authorization (list :show (s-prefix "auth:show")
                       :update (s-prefix "auth:update")
                       :create (s-prefix "auth:create")
                       :delete (s-prefix "auth:delete"))
  :on-path "scores")

(define-resource part ()
  :class (s-prefix "music:Part")
  :properties `((:instrument :string ,(s-prefix "music:instrument"))
                (:instrument-part :string ,(s-prefix "music:instrumentPart"))
                (:key :string ,(s-prefix "music:key"))
                (:clef :string ,(s-prefix "music:clef"))
                (:file :string ,(s-prefix "nfo:fileUrl"))
		(:name :string ,(s-prefix "nie:title"))
		(:created :date ,(s-prefix "dcterms:created"))
		(:modified :date ,(s-prefix "dcterms:modified")))
  :resource-base (s-url "http://data.bravoer.be/id/parts/")
  :has-one `((score :via ,(s-prefix "nie:isLogicalPartOf")
                            :as "score"))
  :authorization (list :show (s-prefix "auth:show")
                       :update (s-prefix "auth:update")
                       :create (s-prefix "auth:create")
                       :delete (s-prefix "auth:delete"))
  :on-path "parts")

(define-resource musician ()
  :class (s-prefix "bravoer:Musician")
  :properties `((:prefix :string ,(s-prefix "vcard:hasHonorificPrefix"))
		(:first-name :string ,(s-prefix "vcard:hasGivenName"))
		(:last-name :string ,(s-prefix "vcard:hasFamilyName"))
		(:instrument :string ,(s-prefix "music:instrument"))
		(:email :url ,(s-prefix "vcard:hasEmail"))
		(:birthdate :date ,(s-prefix "vcard:bday"))
		(:created :date ,(s-prefix "dcterms:created"))
		(:modified :date ,(s-prefix "dcterms:modified")))
  :resource-base (s-url "http://data.bravoer.be/id/contacts/")
  :has-one `((address :via ,(s-prefix "locn:address")
		      :as "address")
	     (user :via ,(s-prefix "bravoer:hasUser")
		      :as "user"))
  :has-many `((telephone :via ,(s-prefix "vcard:hasTelephone")
                            :as "telephones"))
  :authorization (list :show (s-prefix "auth:show")
                       :update (s-prefix "auth:update")
                       :create (s-prefix "auth:create")
                       :delete (s-prefix "auth:delete"))
  :on-path "musicians")

(define-resource sympathizer ()
  :class (s-prefix "bravoer:Sympathizer")
  :properties `((:prefix :string ,(s-prefix "vcard:hasHonorificPrefix"))
		(:first-name :string ,(s-prefix "vcard:hasGivenName"))
		(:last-name :string ,(s-prefix "vcard:hasFamilyName"))
		(:email :url ,(s-prefix "vcard:hasEmail"))
		(:birthdate :date ,(s-prefix "vcard:bday"))
		(:created :date ,(s-prefix "dcterms:created"))
		(:modified :date ,(s-prefix "dcterms:modified")))
  :resource-base (s-url "http://data.bravoer.be/id/contacts/")
  :has-one `((address :via ,(s-prefix "locn:address")
		      :as "address"))
  :has-many `((telephone :via ,(s-prefix "vcard:hasTelephone")
                            :as "telephones"))
  :authorization (list :show (s-prefix "auth:show")
                       :update (s-prefix "auth:update")
                       :create (s-prefix "auth:create")
                       :delete (s-prefix "auth:delete"))
  :on-path "sympathizers")

(define-resource address ()
  :class (s-prefix "locn:Address")
  :properties `((:street :string ,(s-prefix "locn:thoroughfare"))
		(:number :string ,(s-prefix "locn:poBox"))
		(:postCode :string ,(s-prefix "locn:postCode"))
		(:city :string ,(s-prefix "locn:postName"))
		(:created :date ,(s-prefix "dcterms:created"))
		(:modified :date ,(s-prefix "dcterms:modified")))
  :authorization (list :show (s-prefix "auth:show")
                       :update (s-prefix "auth:update")
                       :create (s-prefix "auth:create")
                       :delete (s-prefix "auth:delete"))
  :resource-base (s-url "http://data.bravoer.be/id/addresses/")
  :on-path "addresses")

(define-resource telephone ()
  :class (s-prefix "vcard:Voice")
  :properties `((:value :url,(s-prefix "rdf:value")))
  :authorization (list :show (s-prefix "auth:show")
                       :update (s-prefix "auth:update")
                       :create (s-prefix "auth:create")
                       :delete (s-prefix "auth:delete"))
  :resource-base (s-url "http://data.bravoer.be/id/telephones/")
  :on-path "telephones")


;; definition of a user
;;
;; a user has a name
;;        has relations to user groups
;;        has access-tokens which give it rights to resources
(define-resource user ()
  :class (s-prefix "foaf:Person")
  :resource-base (s-url "http://mu.semte.ch/services/authorization-service/users/")
  :properties `((:name :string ,(s-prefix "foaf:name")))
  :has-many `((grant :via ,(s-prefix "auth:hasRight")
			       :as "grants")
	      )
  :on-path "users")

;; definition of a user-group
;;
;; a user-group can contain other user-groups
;;              can contain users
;;              has authorization types on objects
(define-resource user-group ()
  :class (s-prefix "foaf:Group")
  :resource-base (s-url "http://mu.semte.ch/services/authorization-service/groups/")
  :properties `((:name :string ,(s-prefix "foaf:name")))
  :has-many `((user :via ,(s-prefix "auth:belongsToActorGroup")
		    :inverse t
                    :as "users")
	      (user-group :via, (s-prefix "auth:belongsToGroup")
			  :inverse t
			  :as "sub-groups")
	      (user-group :via, (s-prefix "auth:belongsToGroup")
			  :as "parent-groups")
	      (grant :via ,(s-prefix "auth:hasRight")
			       :as "grants"))
  :on-path "user-groups")

;; authenticatable
;; an authenticatable is something on which rights can be given to either users
;; or user groups, it has a name and a uuid

(define-resource authenticatable ()
  :class (s-prefix "auth:authenticatable")
  :resource-base (s-url "http://mu.semte.ch/services/authorization-service/authenticatables/")
  :properties `((:title :string, (s-prefix "dcterms:title")))
  :on-path "authenticatables")

;; access-token
;; describes a certain type of access token
;; we assume there to be 4 basic access token types that should
;; be present to make mu-cl-resources handle the access token stuff
;; correctly (show, update, create, delete)
(define-resource access-token ()
  :class (s-prefix "auth:accessToken")
  :resource-base (s-url "http://mu.semte.ch/services/authorization-service/accessTokens/")
  :properties `((:title :string ,(s-prefix "dcterms:title"))
		(:description :string ,(s-prefix "dcterms:description"))
		)
  :on-path "access-tokens")


;; grant
;; a grant is used to determine whether or not a user can
;; access a certain resource.
;; It is an instance of an access token definition and thus maps
;; to exactly 1 authenticatable
(define-resource grant ()
  :class (s-prefix "auth:grant")
  :resource-base (s-url "http://mu.semte.ch/services/authorization-service/grants/")
  :has-many `((access-token :via, (s-prefix "auth:hasToken")
			    :as "access-tokens")
	      (authenticatable :via, (s-prefix "auth:operatesOn")
				:as "authenticatables"))
  :on-path "grants")
