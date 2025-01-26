#lang pl 02

;; The function sequence recieves a function 'f' and two values 'first' and
;; 'last'. The function returns a list of values that starts with 'first' and
;; ends with 'last', and for each consecutive pair of values a1, a2 in the list
;; f(a1) results in a2.

(: sequence (All (A) ((A -> A) A A -> (Listof A))))

(define (sequence func af al)
  (cond [(equal? af al) (cons af '())]
        [else (cons af (sequence func (func af) al))]))

(test (sequence add1 1 1) => '(1))
(test (sequence add1 1 5) => '(1 2 3 4 5))
(test (sequence sub1 5 1) => '(5 4 3 2 1))
(test (sequence sqrt 65536 2) => '(65536 256 16 4 2))
(test (sequence not #f #t) => '(#f #t))
(test (sequence add1 0 0) => '(0))
(test (sequence sub1 -1 -1) => '(-1))
(test (sequence sub1 0 -5) => '(0 -1 -2 -3 -4 -5))
(test (sequence add1 1 100) => (build-list 100 add1))
(test (sequence (inst rest Number) (list 1 2 3) null)
      => (list (list 1 2 3) (list 2 3) (list 3) null))

;; Implement a sparse set of integers.
;; A set is represented as one of:
;; - A single integer;
;; - An inclusive range of integers;
;; - A combination of two integer sets.

(define-type INTSET
  [Num Integer]
  [Range Integer Integer]
  [2Sets INTSET INTSET])

;;; Finds the minimum or maximum value in an INTSET, based on a comparator.
;;; Takes an INTSET and a comparator function (`<` for min, `>` for max).
;;; Returns the extreme value according to the comparator.

(: intset-min/max : INTSET (Integer Integer -> Boolean) -> Integer)
(define (intset-min/max set cmpf)
  (cases set
    [(Num n) n]
    [(Range l r) (if (cmpf l r) l r)]
    [(2Sets a b) (let ([x (intset-min/max a cmpf)]
                       [y (intset-min/max b cmpf)])
                   (if (cmpf x y) x y))]))

(test (intset-min/max (Num 1) >) => 1)
(test (intset-min/max (Range 7 10) >) => 10)
(test (intset-min/max (Range 15 5) >) => 15)
(test (intset-min/max (Range 0 10) <) => 0)
(test (intset-min/max (Range 10 2) <) => 2)
(test (intset-min/max (2Sets (Num 5) (Range 10 15)) <) => 5)
(test (intset-min/max (2Sets (Range 10 17) (Range 10 15)) <) => 10)
(test (intset-min/max (2Sets (2Sets (Num 5) (Num 9)) (Range 10 15)) <) => 5)
(test (intset-min/max (2Sets (2Sets (Num 5) (Num 16)) (Range 10 15)) >) => 16)

;; Finds the minimum value in an INTSET.
;; Delegates to `intset-min/max` with `<` as the comparator.

(: intset-min : INTSET -> Integer)
(define (intset-min set) (intset-min/max set <))

;; Finds the maximum value in an INTSET.
;; Delegates to 'intset-min/max` with `>` as the comparator.

(: intset-max : INTSET -> Integer)
(define (intset-max set) (intset-min/max set >))

;; Checks if an INTSET is in normalized form.
;; A normalized INTSET satisfies the following:
;; - No numbers are repeated (singletons and ranges have no overlap);
;; - The left number in all ranges is smaller than the right;
;; - There is some gap between the two subsets in a 2Set value.

(: intset-normalized? : INTSET -> Boolean)
(define (intset-normalized? set)
  (cases set
    [(Num n) #t]
    [(Range l r) (< l r)]
    [(2Sets a b) (< (intset-max a) (intset-min b))]))

(test (intset-normalized? (Num 1)) => #t)                      
(test (intset-normalized? (Range 1 5)) => #t)                   
(test (intset-normalized? (2Sets (Range 1 2) (Range 4 6))) => #t)
(test (intset-normalized? (Range 5 1)) => #f)                 
(test (intset-normalized? (2Sets (Num 2) (Num 2))) => #f)     
(test (intset-normalized? (2Sets (Range 1 3) (Range 2 4))) => #f) 

#|
BNF for the pages language

<pages>  ::= <page>
           | <page> "," <pages>

<page>   ::= <int>
           | <range>

<range>  ::= <int> "-" <int>

<int>    ::= [a sequence of digits]

|#

(define minutes-spent 200)