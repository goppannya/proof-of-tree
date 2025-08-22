;; Proof-of-Tree: Reward system for planting trees 🌳

(define-constant contract-admin 'ST3PF13W7Z0RRM42A8VZRVFQ75SV1K26RXEP8YGKJ)

(define-map tree-proofs principal (buff 32)) ;; user → proof (image/IPFS hash)
(define-map balances principal uint)         ;; user → token balance

;; Submit proof of planting a tree
(define-public (submit-proof (proof-hash (buff 32)))
  (begin
    (map-set tree-proofs tx-sender proof-hash)
    (ok true)
  )
)

;; Admin issues green rewards
(define-public (issue-reward (recipient principal))
  (if (is-eq tx-sender contract-admin)
    (let (
      (current (default-to u0 (map-get? balances recipient)))
      (new (+ current u50)) ;; reward = 50 tokens
    )
      (begin
        (map-set balances recipient new)
        (ok true)
      )
    )
    (err "Not authorized")
  )
)

;; Check token balance
(define-read-only (get-balance (owner principal))
  (default-to u0 (map-get? balances owner))
)
