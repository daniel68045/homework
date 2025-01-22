#|
  CS 2800 Fall 2024
  Homework 3.

  - You can work in groups consisting of 1-3 people. Make sure you are
    in exactly 1 group!  Use the piazza "search for teammates" post to
    find teammates. Please give students who don't have a team a
    home. If you can't find a team, ask for help on Piazza.

  - Submit the homework file (this file) on Gradescope. After clicking
    on "Upload", you must add your group members to the submission by
    clicking on "Add Group Member" and then filling their names. Every
    group member can submit the homework and we will only grade the
    last submission. You are responsible for making sure that your
    group submits the right version of the homework for your final
    submission. We suggest you submit early and often.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  For this homework you will need to use ACL2s.

  Technical instructions:

  - Open this file in ACL2s.

  - Make sure you are in ACL2s "session mode," *not* "Compatible" ACL2
    mode. This is essential! Note that you can only change the mode
    when the session is not running, so set the correct mode before
    starting the session.

  - Insert your solutions into this file where indicated (usually as "XXX")

  - Only add to the file. Do not remove or comment out anything pre-existing.

  - Make sure the entire file is accepted by ACL2s. In particular, there must
    be no "XXX" left in the code. If you don't finish all problems, comment
    the unfinished ones out. Comments should also be used for any English
    text that you may add. This file already contains many comments, so you
    can see what the syntax is.

  - When done, save your file and submit it without changing the name
    of the file.

  - Do not submit the session file (which shows your interaction with
    the theorem prover). This is not part of your solution. Only submit
    the lisp file.

  Instructions for programming problems:

  For all function definitions you must:

  (1) Perform contract-based testing (see Lecture Notes) by adding
      appropriate check=/check tests.  You only have to do this for
      functions where you are responsible for at least some part of the
      definition.  This should be done before you define the function,
      as it is intended to make sure you understand the spec.

      We will use ACL2s' check= function for tests. This is a
      two-argument function that rejects two inputs that do not
      evaluate equal. You can think of check= roughly as defined like
      this:

      (definec check= (x :all y :all) :bool
        :input-contract (equal x y)
        :output-contract (== (check= x y) t)
        t)

      That is, check= only accepts two inputs with equal value. For
      such inputs, t (or "pass") is returned. For other inputs, you get
      an error. If any check= test in your file does not pass, your
      file will be rejected.

      We will also use ACL2's check function, which is a version of
      check= that checks if a single form evalutes to t, so you can
      think of

      (check X)

      as being equivalent to

      (check= X t)

  (2) For all functions you define, provide enough check= tests so that
      you have 100% expression coverage (read the Lecture Notes).  You
      can use whatever tests we provide and your contract-based tests
      to achieve expression coverage, e.g., if the union of the tests
      we gave you and your contract-based tests provide 100% expression
      coverage, there is nothing left to do.

  (3) Contract-based testing and expression coverage are the minimal
      testing requirements.  Feel free to add other tests as you see
      fit that capture interesing aspects of the function.

  (4) For all functions where you are responsible for at least some
      part of the definition, add at least two interesting property
      forms. The intent here is to reinforce property-based testing.

  You can use any types, functions and macros listed on the ACL2s
  Language Reference (from class Webpage, click on "Lectures and Notes"
  and then on "ACL2s Language Reference").

  Since we don't know how to control the theorem prover, we will allow
  you to simplify the interaction with ACL2s somewhat.

  Instead of requiring ACL2s to prove termination and contracts, we
  allow ACL2s to proceed even if a proof fails.  However, if a
  counterexample is found, ACL2s will report it.  See the lecture notes
  for more information.  This is achieved using the following
  directives. (do not remove them):

|#

(in-package "ACL2S")
(set-defunc-termination-strictp nil)
(set-defunc-function-contract-strictp nil)
(set-defunc-body-contracts-strictp nil)
(set-defunc-generalize-contract-thm nil)
(set-acl2s-property-table-proofs? nil)
(set-acl2s-property-table-check-contracts? nil)

; Part 1
; These are some warmup exercises.

; Exercise 2.11
(check= (+ 1 1) 2)

; Exercise 2.13
"Property 2.13"
; checks whether doubling a natural number x and then halving it 
; gives back the original number.
(definec double (x :nat) :nat (* 2 x))

(definec half (x :nat) :nat (/ x 2))

; property-based testing: for any natural number x, half(double(x)) should be equal to x.
(check (equal (half (double 3)) 3))
(check (equal (half (double 7)) 7))

; generalize the property
(defproperty double-half-property (x :nat)
  (equal (half (double x)) x))
 
; Exercise 2.14
"Property 2.14"
; checks if squaring a natural number is always greater than or equal to that number.
(definec square (x :nat) :nat (* x x))


; Exercise 2.15
; To get you started, here is the definition of foo from the lecture notes.
(definec foo (x y :nat z :tl) :int
   (cond ((zp x) (* y 2))
         ((zp y) (* x 2))
         ((< x y) (foo y x z))
         ((oddp (len z)) (* y 4))
         ((< y x) (* x 4))
         ((oddp (- x y)) -15)
         ((evenp (- x y)) 24)
         (t 43)))

; Now define an alternative version, as per the exercise
(definec my-foo (x y :nat z :tl) :int
   (cond ((zp x) (* y 2))
         ((zp y) (* x 2))
         ((< x y) (my-foo y x z))
         ((oddp (len z)) (* y 4))
         ((< y x) (* x 4))
         ((oddp (- x y)) -15)
         ((evenp (- x y)) 24)
         (t 43)))

; And check your definition using a property (check functional
; equivalence between foo and my-foo.
"Property 2.15"
(defproperty foo-equivalence (x :nat y :nat z :tl)
  (equal (foo x y z) (my-foo x y z)))
  
; test equivalence property with specific inputs.
(check= (foo 3 4 '(1 2 3)) (my-foo 3 4 '(1 2 3)))
(check= (foo 0 4 '(1 2 3)) (my-foo 0 4 '(1 2 3)))
(check= (foo 2 0 '(1 2 3)) (my-foo 2 0 '(1 2 3)))

; Exercise 2.19
"Property 2.19"
(definec reverse (lst :tl) :tl
  (cond ((endp lst) nil)
        (t (append (reverse (cdr lst)) (list (car lst))))))
        
; property based test for reversing list twice. 
(defproperty reverse-twice (lst :tl)
  (equal (reverse (reverse lst)) lst))
  
; test reverse-twice property.  
(check= (reverse (reverse '(1 2 3))) '(1 2 3))
(check= (reverse (reverse '(a b c))) '(a b c))
        
; Exercise 2.20
((definec foo-witness (x :nat y :nat z :tl) :int
  (my-foo x y z))

"Property 2.20"
(defproperty foo-witness-property (x :nat y :nat z :tl)
  (equal (foo x y z) (foo-witness x y z)))
  
; property test.
(check= (foo 5 3 '(1 2 3)) (foo-witness 5 3 '(1 2 3)))
(check= (foo 0 7 '(a b)) (foo-witness 0 7 '(a b)))


#|

  In part 2 of this homework, we will design a simple arithmetic
  expression language and will implement an interpreter for it. This is
  the kind of thing that you will do in a compiler class, but for
  programming languages.  In addition, we will specify properties about
  expressions in the language and properties about the language
  itself. This allows us to better understand a fundamental distinction
  in logic between meta and object languages.

  Here is a little story to set the context. In class, we reviewed the
  syntax and semantics of the ACL2s language. What language did we use
  to do that? English. Technically, we would say that English is the
  metalanguage used to study the object language ACL2s. Notice "object"
  here has nothing to do with objects from object-oriented
  languages. More accurately, we might say mathematical English or CS
  English is the metalanguage, as fields such as mathematics and CS use
  a version of English better suited for their purposes, eg, in CS
  English, words like "implies," "tree," "induction" and "reasoning"
  have special meanings.

  Mathematical English is not a formal language, hence, just like
  English, it is ambiguous (though not to the same extent) and one can
  take many shortcuts in describing things that require appropriate
  context or even guessing to understand.

  What we're going to do in this homework is to use a formal language,
  ACL2s, as the metalanguage to define another language, an arithmetic
  expression language that includes errors.

  This involves both defining the syntax, i.e., what constitutes a
  well-formed expression in the language (the grammar of the
  language). It also involves defining the semantics of the language,
  i.e., the meaning of syntactically valid expressions.

  By using ACL2s to define the syntax and semantics, we will get code
  that does this for us, e.g,. we will get a parser and an interpreter
  for the language. This means that we can test if an expression is
  syntactically valid and if it is, we can run it. This is exactly what
  you would do in a compiler class, but there you start with a
  high-level programming language and generate machine code. That
  increases the complexity, but the idea is the same.

  Designing languages like this is a very common thing that happens in
  industry all the time. Look up "domain-specific languages" to see
  some examples where it makes sense to define custom languages that
  help to simplify certain computational problems. There are examples
  from finance to biology to AI to manufacturing and so on.

  But defining a simple expression language is not all we're going to
  do.  We are also going to reason about the arithmetic language we
  defined using ACL2s by stating and validating properties. This will
  bring up some interesting questions about the difference between
  object-level and meta-level reasoning.

  We are going to do this using a gradual verification methodology
  supported by ACL2s. This is ongoing, early-stage work that allows us
  to design systems that get verified gradually.

  One final note. We will see how to use ACL2s as both the metalanguage
  and the object language, in the extra credit problems, which we
  encourage you to do.

|#

#|

  Here is a short overview of gradual verification. ACL2s supports the
  design, development and verification of computational systems by
  allowing you to set certain parameters. There are four built-in
  configurations we are going to consider. In order of most to least
  permissive, they are:

  (modeling-start): This is the configuration you will start with. In
  this configuration, ACL2s will accept anything you tell it, unless it
  can very quickly find a counterexample. ACL2s will not prove
  termination, nor will it prove function and body contracts nor will
  it prove named properties.

  (modeling-validate-defs): In this configuration, ACL2s will now try
  proving termination and function/ body contracts, but if it can't it
  will accept your definitions anyway. It will also give itself a bit
  more time for testing.

  (modeling-admit-defs): In this configuration, ACL2s will require
  proofs of termination and function/body contracts. It will also give
  itself more time for testing.

  (modeling-admit-all): In this configuration, ACL2s will require
  proofs of properties. You can enable/disable proofs locally. More on
  that below.

  Remember that ACL2s is going to be doing a lot of theorem proving and
  counterexample generation when admitting definitions and checking
  properties. When using the gradual verification methodology, you get
  some default settings that control how much time ACL2s spends on
  various tasks and you will find yourself in a situation where you
  want to adjust those settings. Here is a summary of some of the more
  common ways in which you may want to adjust what ACL2s does. There
  are global and local settings.

  Global settings:

  1. To turn testing/counterexample generation on/off (t/nil):
     (acl2s-defaults :set testing-enabled t/nil) ; use t or nil, not t/nil

  2. To skip function admissibility proofs (testing can still find
     problems for any of the skip forms):
     (set-defunc-skip-admissibilityp t/nil)

  3. To skip function contract proofs:
     (set-defunc-skip-function-contractp t/nil)

  4. To skip body contract proofs:
     (set-defunc-skip-body-contractsp t/nil)

  5. To set strictness of termination. For all strict forms: If
     strictness is t, then termination (or whatever) is required. If
     strictness is nil, ACL2s will try proving it, but OK if it fails.
     (set-defunc-termination-strictp t/nil)

  6. To set strictness of function contract proofs.
     (set-defunc-function-contract-strictp t/nil)

  7. To set set strictness of body contract proofs.
     (set-defunc-body-contracts-strictp t/nil)

  8. Do properties need to be proved to be accepted?
     (set-acl2s-property-table-proofs? t/nil)

  9. Should properties be tested?
     (set-acl2s-property-table-testing? t)

  10. Set timeouts for:
        cgen: total time counterexample generation gets
        cgen-local: time cgen gets for individual subgoals.
        defunc: time defunc/definec get
        table: time for property testing/ proving

      (modeling-set-parms cgen cgen-local defunc table)

  Local settings: You can add keyword arguments to specific
  properties. For example

  (property (x :tl)
    :proof-timeout 10
    :proofs? t
    (== x x))

  1. Timeout after n seconds when doing a proof
     :proof-timeout n

  2. Timeout after n seconds when testings.
     :testing? n

  3. Whether to require proofs
     :proofs? t/nil

  4. Whether to require testing
     :testing? t/nil

|#

; Start with this configuration and once you are done with the
; homework, go to the next configuration, cranking up the rigor as far
; as you can. You must get to at least (modeling-validate-defs), but
; (modeling-admit-defs) is better and (modeling-admit-all) is the
; best.

(modeling-start)

#|

  We will define the syntax and semantics for SAEL, the Simple
  Arithmetic Expression Language. SAEL is our object language. The
  metalanguage we (well, you) will use to define SAEL is ACL2s. The
  meta-metalanguage we (well, us -- Ferdinand & Olin, in this
  assignment) use to discuss all of this is Mathematical English.

  Here's a "Fundies 1" style data definition.
  A simple arithmetic expression, saexpr, is one of the following:

  - a rational number (we use the builtin ACL2s type rational)

  - a variable (we use the builtin ACL2s type var)

  - a unary expression, which is a list of the form

    (- <saexpr>) ; Negation
    (/ <saexpr>) ; Reciprocal

    where <saexpr> is an arithmetic expression

  - a binary expression, which is a list of the form

    (<saexpr> <oper> <saexpr>)

    where <oper> is one of +, -, *, / or ^
    and both <saexpr>'s are simple arithmetic expressions.

|#

; It really isn't important to know the exact definition of varp,
; although you can query ACL2s with ":pe varp". Just notice that none
; of the operators are vars, but symbols such as x, y, z, etc are
; vars.

(check= (varp '-) nil)
(check= (varp '+) nil)
(check= (varp '*) nil)
(check= (varp '/) nil)
(check= (varp '^) nil)
(check  (varp 'x))

;; Q1
;; Use defdata to define the unary operators. Fill in the XXXs
;; below. If you have questions, ask on Piazza.
(defdata uoper (enum '- '/))

;; Q2
;; Use defdata to define boper the binary operators

(defdata boper (enum '+ '- '* '/ '^))

(check  (boperp '*))
(check  (boperp '^))
(check= (boperp '!) nil)

;; Q3
;; Use defdata to define saexpr. We will want names for all the
;; subtypes, so use the following template. Note that data definitions
;; can be mutually recursive.

(defdata
   (saexpr (or rational  ; or is the same as oneof
               var
               usaexpr   ; unary sael expression
               bsaexpr)) ; binary sael expression
   (usaexpr (list uoper saexpr))  ; unary operator followed by saexpr
   (bsaexpr (list saexpr boper saexpr)))  ; saexpr, binary operator, saexpr

;; We now have a formal definition of the SAEL language!  That is, we
;; have a recognizer saexprp, which is defined in our metalanguage,
;; ACL2s, and which recognizes expressions in the object language,
;; SAEL. We formalized the syntax of SAEL expressions! Notice that
;; defdata made this very easy to do.

;; In short, a SAEL expression can now be represented as a
;; piece of ACL2 data, so we can operate on one with ACL2 code.

(check (saexprp '((x + y) - (/ z))))
(check= (saexprp '(x + y + z)) nil)

;; We are now going to define the semantics of SAEL expressions.

;; First, some helper definitions.
;; An assignment is an alist from vars to rationals.
;; An alist is just a list of conses.
;; In the RAP notes, the term "valuation" is also used instead of assignment.

(defdata assignment (alistof var rational))

(check (assignmentp '((x . 1) (y . 1/2))))

;; This is nil because (1), (1/2) are not rationals.
(check= (assignmentp '((x 1) (y 1/2))) nil)

;; Now, on to the semantics.

;; How do we assign semantics to SAEL expressions such as
;; (x + y)?

;; We will define saeval (below), a function that given an saexpr and
;; an assignment evaluates the expression, using the assignment to
;; specify the values of var's.

;; If a var appears in the saexpr but is not in the assignment, then
;; the value of the var should be 1.

;; Q4
;; Use the following helper function to lookup the value of v in a.
;; (Remember return 1 if v isn't in a.)

(definec lookup (v :var a :assignment) :rational
  (if (member v (map car a))  ; check if variable is in the assignment
      (cdr (assoc v a))  ; return the value associated with the variable
      1))  ; return 1 if the variable is not found

;; What happens when we divide by 0? We are going to throw an
;; error. We will model that as follows.

;; A singleton type
(defdata er 'error)

;; *er* is defined using the enumerator for er, which always retuns
;; 'error; if we change er, we will not have to change *er*. Instead
;; of using the symbol 'error, use the constant *er* in the code you
;; write.
(defconst *er* (nth-er-builtin 0))

;; Since the evaluation of arithmetic expressions can yield errors, we
;; will define the type that evaluation can return to include errors.
(defdata rat-err (oneof rational er))

;; There are some decisions to be made.

;; First: if an error occurs during evaluation, then you must return
;; the error; there is no mechanism for masking errors.

;; Second: If you divide by 0, that is an error.

;; Third: How do we define exponentiation? For example, do we allow
;; (-1 ^ 1/2) or (2 ^ 1/2) or (0 ^ -1)? All three are problematic, for
;; different reasons. In the first case, the result is i, but we only
;; allow rationals, not complex numbers. In the second case, we get an
;; irrational. In the third case, ^ is undefined, as it would require
;; us to divide by 0.

;; To stay in the realm of rationals, given an expression of the form
;; (x ^ y), we return an error if (1) y is not an integer or (2) x=0
;; and y<0.

;; By the way, the builtin exponentiation function in ACL2s is expt.

;; Feel free to define helper functions as needed.

;; Q5
;; Define the semantics of SAEL by defining the following function, as
;; per the discussion above.

(definec saeval (e :saexpr a :assignment) :rat-err
   (match e
     (:rational e)  ; if e is a rational, return it
     e
     (:var (lookup e a))  ; if e is a variable, lookup its value
     (:usaexpr
      (match e
        (('- x) (let ((val (saeval x a)))  ; handle negation
                  (if (er-p val) *er* (- val))))
        ('(/ x) (let ((val (saeval x a)))  ; handle reciprocal
                  (if (or (er-p val) (equal val 0)) *er* (/ val))))))
     (:bsaexpr
      (match e
        ((x '+ y) (let ((vx (saeval x a))
                        (vy (saeval y a)))
                    (if (or (er-p vx) (er-p vy)) *er* (+ vx vy))))
        ((x '- y) (let ((vx (saeval x a))
                        (vy (saeval y a)))
                    (if (or (er-p vx) (er-p vy)) *er* (- vx vy))))
        ((x '* y) (let ((vx (saeval x a))
                        (vy (saeval y a)))
                    (if (or (er-p vx) (er-p vy)) *er* (* vx vy))))
        ((x '/ y) (let ((vx (saeval x a))
                        (vy (saeval y a)))
                    (if (or (er-p vx) (er-p vy) (equal vy 0)) *er* (/ vx vy))))
        ((x '^ y) (let ((vx (saeval x a))
                        (vy (saeval y a)))
                    (if (or (er-p vx) (er-p vy) 
                            (not (integerp vy))
                            (and (equal vx 0) (< vy 0)))
                        *er*
                        (expt vx vy))))))))

;; OK, all of the above we could have done in Racket. Or Java, Kotlin or
;; C, for that matter. But let's take advantage of working in ACL2, which
;; lets us state and prove properties about the object language.

;; For example, let's specify the property
;;   For (SAEL) variable x, x=x
;; That is, evaluating the SAEL variable x multiple times always
;; gives the same result.

;; Here is the answer.

(property (a :assignment)
   (== (saeval 'x a)
       (saeval 'x a)))

;; In the above statement, I used Mathematical English (our
;; meta-metalanguage) to request that you specify a property
;; (x=x). What we are asking you to do is to use ACL2s, the
;; metalanguage, to state a property of SAEL, the object language.
;; Notice that x=x means that x=x always, which means for every
;; possible assignment, the evaluation of x = the evaluation of x.
;; (This is not the most fascinating property, but bear with us...)
;; Also notice that x is a specific SAEL variable; it is not an ACL2s
;; variable ranging over SAEL variables. How would you write that?

;; We will stop being so pedantic about what is going on in the
;; following exercises.

;; Next topic. Notice the property form, above, which is relatively
;; new for most of you.  It is similar to definec in that you identify
;; the variables and their types first and then you have the body of
;; the property. How ACL2s handles properties depends on the
;; configuration, so as you crank up the rigor, ACL2s will demand
;; more. You can override configuration parameters. Here is a silly
;; example showing some of the parameters.

(property (a :assignment)
   :testing? t
   :testing-timeout 20
   :proofs? t
   :proof-timeout 1
   (== (saeval 'x a)
       (saeval 'x a)))

;; What if we had instead asked you to specify:

;; For all (SAEL) variables x, x=x
;; (That is, x is an ACL2 meta-variable that ranges over the
;; infinite set of SAEL variables a, b, q, fred, foo, x, ...)

;; As discussed above this is different than what we originally
;; asked. Make sure you understand why.

;; Here is the answer.

(property (x :var a :assignment)
   (== (saeval x a)
       (saeval x a)))

;; Notice that we can instantiate the above property to get y=y, for
;; SAEL variable y, but we can't do that with the original property.
;; The above form will showcase the way in which the conjecture is
;; true. Look at those cases to see that ACL2s tests the above
;; property with different object variables substituted for x.

;; Specify the following properties about SAEL. Are they valid? If
;; not, make them valid in the least restrictive way. Feel free to
;; define helper functions, if that helps.

;; Q6. -x = -(-(-x)), for var x
"Property 6"

(property (x :var a :assignment)
  (== (saeval `(- ,x) a)
      (saeval `(- (- (- ,x))) a)))

;; Q7. (x - y) = (x + (- y)), for *any* vars x, y
;; Hint: the backquote/comma combo can be your friend.
"Property 7"

(property (x :var y :var a :assignment)
  (== (saeval `(,x - ,y) a)
      (saeval `(,x + (- ,y)) a)))

;; Q8. (x * (y + z)) = ((x * y) + (x * z)), for saexpr's x, y, z
;; Note! x, y, z are saexpr's not vars!
"Property 8"

(property (x :saexpr y :saexpr z :saexpr a :assignment)
  (== (saeval `(,x * (,y + ,z)) a)
      (saeval `((,x * ,y) + (,x * ,z)) a)))

;; Notice that the following is true because error = error.

(check= (saeval '(/ 0) nil)
         (saeval '(1 / 0) nil))

;; Q9. (1 / (x / y)) = (y / x), for saexpr's x, y,
"Property 9"

(property (x :saexpr y :saexpr a :assignment)
  (== (saeval `(1 / (,x / ,y)) a)
      (saeval `(,y / ,x) a)))

;; Q10. (0 ^ x) = 0, for saexpr x
"Property 10"

(property (x :saexpr a :assignment)
  (== (saeval `(0 ^ ,x) a) 0))

;; Q11. (x ^ ((2 * y) / y)) = (x ^ 2), for saexpr's x, y
"Property 11"

(property (x :saexpr y :saexpr a :assignment)
  (== (saeval `(,x ^ ((2 * ,y) / ,y)) a)
      (saeval `(,x ^ 2) a)))

;; Extra credit (50 points, all or nothing)

;; This part is intentially vague in places. That's an opportunity for
;; you to learn. If there is confusion, ask!

;; Define the notion of an ACL2s arithmetic expression over rationals
;; that has the same operators as SAEL, but uses ACL2s prefix syntax
;; and ACL2s function names; the only name you have to change is ^ to
;; expt.  Use defdata and call such expressions aaexpr's. Feel free to
;; use previous data definitions.

;; XXX

;; Define functions sael->aa and aa->sael that transform SAEL
;; and ACL2s arithmetic expressions to each other.

;; XXX

;; State the two properties that the above functions are inverses of
;; each other.

;; XXX

;; Define an evaluator, aaeval, for ACL2s arithmetic expressions
;; (similar to saeval). What is interesting here is that we are using
;; the metalanguage to study itself, i.e., we are defining the syntax
;; and semantics of ACL2s in ACL2s.

;; In the definition of aaeval, if there is a divide by 0, aaeval will
;; return 0. For (expt x y) where y=0 or not an integer, aaeval will
;; return 1; otherwise, if x=0, aaeval will return 0. So aaeval always
;; returns a rational. Now, this may not seem like ACL2s, but it
;; actually is what ACL2s does in the "core" logic, which you can
;; experiment with by issuing the command (set-guard-checking nil).

;; XXX

;; State properites relating aaeval to saeval. Make them as general as
;; possible. Start with: if we have an SAEL expression and we convert it
;; to an ACL2s arithmetic expression, then for any assignment, the
;; corresponding evaluations agree. And the other way around (start
;; with ACL2s arithmetic expression). This won't work, so figure out
;; what does work and make it as general as possible. These two
;; properties are enough. Notice that this allows us to use the
;; metalanguage to prove theorems establishing a correspondence
;; between object language theorems and metalanguage theorems.

;; XXX
