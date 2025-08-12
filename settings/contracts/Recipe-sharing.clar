;; Recipe Sharing Smart Contract
;; Stores and retrieves recipes on the blockchain

;; Map to store recipes: recipe-name -> recipe-description
(define-map recipes
  { name: (string-ascii 50) }
  { description: (string-ascii 280) })

;; Error codes
(define-constant err-recipe-exists (err u100))
(define-constant err-empty-name (err u101))
(define-constant err-empty-description (err u102))

;; Function 1: Add a new recipe
(define-public (add-recipe (name (string-ascii 50)) (description (string-ascii 280)))
  (let
    (
      ;; Trimmed checks to ensure input is safe and warnings are avoided
      (name-len (len name))
      (desc-len (len description))
    )
    (begin
      ;; Ensure name is not empty
      (asserts! (> name-len u0) err-empty-name)
      ;; Ensure description is not empty
      (asserts! (> desc-len u0) err-empty-description)
      ;; Ensure recipe does not already exist
      (asserts! (not (is-some (map-get? recipes { name: name })))
                err-recipe-exists)
      ;; Store recipe
      (map-set recipes { name: name } { description: description })
      (ok true)
    )
  )
)

;; Function 2: Get a recipe description by name
(define-read-only (get-recipe (name (string-ascii 50)))
  (ok (map-get? recipes { name: name })))
