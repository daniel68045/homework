;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname |PL HW 1|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define I-will-behave #t)


;; A Bit is either:
;; - 0 or
;; - 1

;; A Natural is a non-negative Integer,
;; including 0. 

;; A SLoN is a [List of Number] where the numbers
;; are sorted in the list in ascending order. 


;; bin4-to-num: Bit Bit Bit Bit -> Natural
;; Given four bits converted to their
;; decimal equivalaent.

(define (bin4-to-num b0 b1 b2 b3)
  (+ (* b0 1)
     (* b1 2)
     (* b2 4)
     (* b3 8 )))

(equal? (bin4-to-num 0 0 0 0) 0)
(equal? (bin4-to-num 1 0 0 0) 1)
(equal? (bin4-to-num 0 1 0 0) 2)
(equal? (bin4-to-num 0 0 1 0) 4)
(equal? (bin4-to-num 0 1 1 0) 6)
(equal? (bin4-to-num 0 0 0 1) 8)
(equal? (bin4-to-num 1 1 0 1) 11)
(equal? (bin4-to-num 1 0 1 1) 13)


;; gcd2: Natural Natural -> Natural
;; Calculate the greatest common divisor of two non-negative
;; ints (Naturals) using the Binary GCD algorithm.

(define (gcd2 a b)
  (cond
    [(= a 0) b]                       
    [(= b 0) a]                               
    [(and (even? a) (even? b))         
     (* 2 (gcd2 (/ a 2) (/ b 2)))]
    [(and (even? a) (odd? b))          
     (gcd2 (/ a 2) b)]
    [(and (odd? a) (even? b))          
     (gcd2 a (/ b 2))]
    [(and (odd? a) (odd? b) (>= a b))          
     (gcd2 (/ (- a b) 2) b)]
    [(and (odd? a) (odd? b) (< a b))            
     (gcd2 (/ (- b a) 2) a)]))

(equal? 0 (gcd2 0 0))
(equal? 1 (gcd2 1 8))
(equal? 1 (gcd2 13 7)) 
(equal? 1 (gcd2 17 19))
(equal? 3 (gcd2 9 15)) 
(equal? 4 (gcd2 8 12))
(equal? 7 (gcd2 7 0))
(equal? 7 (gcd2 35 21))
(equal? 12 (gcd2 0 12))
(equal? 18 (gcd2 378 144))
(equal? 27 (gcd2 54 81))
(equal? 32 (gcd2 32 96))
(equal? 36 (gcd2 216 612))


;; all-even?: [List-of-Integer] -> Boolean
;; Returns true when all integers in the input list are even.

(define (all-even? lst)
  (cond
    [(empty? lst) #t]                   
    [(even? (first lst)) (all-even? (rest lst))] 
    [else #f]))                        

(all-even? '())                       
(all-even? '(2 4 6 8))
(all-even? '(0 2 4 6))
(all-even? '(8))                     
(not (all-even? '(1 3 5 7)))       
(not (all-even? '(2 4 6 7)))         
(not (all-even? '(7)))


;; merge-lists: SLoN SLoN-> SLoN
;; Merges two sorted lists of numbers into a single sorted list.

(define (merge-lists lst1 lst2)
  (cond
    [(empty? lst1) lst2]                       
    [(empty? lst2) lst1]                                
    [(<= (first lst1) (first lst2))                       
     (cons (first lst1) (merge-lists (rest lst1) lst2))] 
    [else
     (cons (first lst2) (merge-lists lst1 (rest lst2)))])) 

(equal? (merge-lists '() '()) '())      
(equal? (merge-lists '(5) '(3)) '(3 5))               
(equal? (merge-lists '(1 3 5) '()) '(1 3 5))            
(equal? (merge-lists '() '(2 4 6)) '(2 4 6))     
(equal? (merge-lists '(2 2 2) '(2 2)) '(2 2 2 2 2))    
(equal? (merge-lists '(1 3 5) '(2 4 6)) '(1 2 3 4 5 6)) 
(equal? (merge-lists '(1 2 3) '(4 5 6)) '(1 2 3 4 5 6)) 
(equal? (merge-lists '(1 5 9) '(2 4 8)) '(1 2 4 5 8 9)) 
(equal? (merge-lists '(1 3 7) '(2 2 6 8)) '(1 2 2 3 6 7 8)) 


(define minutes-spent 150)
