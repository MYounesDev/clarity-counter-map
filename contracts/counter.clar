

(define-constant MAX-COUNT u100)


(define-map counters principal uint)


(define-data-var total-ops uint u0)


(define-read-only (get-count (who principal))
  (default-to u0 (map-get? counters who))
)


(define-read-only (get-total-operations)
  (var-get total-ops)
)


(define-private (update-total-ops)
  (var-set total-ops (+ (var-get total-ops) u1))
)


(define-public (count-up)
  (let ((current-count (get-count tx-sender)))
    (begin
      (asserts! (< current-count MAX-COUNT) (err u1))
      (update-total-ops)
      (ok (map-set counters tx-sender (+ current-count u1)))
    )
  )
)


(define-public (count-down)
  (let ((current-count (get-count tx-sender)))
    (begin
      (asserts! (> current-count u0) (err u2))
      (update-total-ops)
      (ok (map-set counters tx-sender (- current-count u1)))
    )
  )
)

(define-public (reset-count)
  (begin
    (update-total-ops)
    (ok (map-set counters tx-sender u0))
  )
)


(define-public (set-count (new-count uint))
  (begin
    (asserts! (<= new-count MAX-COUNT) (err u1))
    (update-total-ops)
    (ok (map-set counters tx-sender new-count))
  )
)


(define-read-only (get-count-for (user principal))
  (default-to u0 (map-get? counters user))
)


(define-read-only (is-max?)
  (let ((count (get-count tx-sender)))
    (ok (is-eq count MAX-COUNT))
  )
)


(define-read-only (remaining-count)
  (let ((count (get-count tx-sender)))
    (ok (- MAX-COUNT count))
  )
)
