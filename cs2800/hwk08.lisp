#|

 CS 2800 Homework 8 - Fall 2024

 - Due on Tuesday, Nov. 12 by 11:00 PM.

 - You will have to work in groups. Groups should consist of 2-3
   people. Make sure you are in exactly 1 group!  Use the
   piazza "search for teammates" post to find teammates. Please give
   students who don't have a team a home. If you can't find a team ask
   Ankit for help on Piazza. 

 - You will submit your hwk via gradescope. Instructions on how to
   do that are below and on Canvas. If you need help, ask on Piazza.

 - Submit hwk08.proof -- NOT THIS FILE! -- on Gradescope. After clicking
   on "Upload", you must add your group members to the submission by
   clicking on "Add Group Member" and then filling their names. Every
   group member can submit the homework and we will only grade the
   last submission. You are responsible for making sure that your
   group submits the right version of the homework for your final
   submission. We suggest you submit early and often. Also, you will
   get feedback on some problems when you submit. However, this
   feedback does not determine your final grade, as we will manually
   review submissions. Submission will be enabled a few days after the
   homework is released, but well before the deadline.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 For this homework you will need to use the ACL2s proof checker.
 Make sure you have hwk08.proof. This function hwk08.lisp does not
 need to be submitted!

|#

#|

 You landed a great coop, congrats.
 
 Your mentor (a polite term for "boss") is a compiler wizard. During
 one of your onboarding meetings, she mentions that she is supporting
 a compiler that other teams are using. However, they generate code
 using some fancy AI techniques, but the code is sometimes very
 inefficient. Instead of having someone go through and optimize it by
 hand, she really wants to write an optimizing compiler for it. The
 application is really critical and she wants to make sure that if
 there are bugs, it won't be due to her compiler, i.e., it will be the
 AI team's fault (isn't it always?). Therefore, she made the only
 reasonable choice and is learning to use ACL2s.

 You ask for more details, given your exprience with ACL2s, and she
 says that the first step is to optimize the list manipulations
 peformed.

 After some discussion, she provides this example of generated code,
 expressed in ACL2s.
 
 (in el 
     (rem-dups (rv (rem-dups (rv (ap (rv (ap (rv (ap a b))
                                             (ap a c)))
                                     d))))))

 Her insight is that the above is equivalent to the more efficient

 (v (in el a) (in el b) (in el c) (in el d))

 Here are the relevant definitions of in, ap, rv & rem-dups:

|#

(definec in (a :all x :tl) :bool
  (and (consp x)
       (or (== a (car x))
           (in a (cdr x)))))

(definec ap (x y :tl) :tl
  (if (endp x) y
      (cons (car x) (ap (cdr x) y))))

(definec rv (x :tl) :tl
  (if (endp x) x
      (ap (rv (cdr x))
	  (list (car x)))))

(definec rem-dups (x :tl) :tl
  (cond ((endp x)              x)
        ((in (car x) (cdr x))  (rem-dups (cdr x)))
        (t                     (cons (car x)
				     (rem-dups (cdr x))))))

#|

 Your mentor is going to write the compiler, but she needs to know
 that all of her optimizations are valid. This is right up your alley,
 and being the enterprising NU student you are, you volunteer to do
 the proofs in ACL2s.

 Your first goal is to determine what to prove and you come up with
 the following properties using ACL2s.

|#

(property in-ap (a :all x y :tl)
  (== (in a (ap x y))
      (v (in a x)
	 (in a y))))

(property in-rv (a :all x :tl)
  (== (in a (rv x))
      (in a x)))

(property in-rem-dups (a :all x :tl)
  (== (in a (rem-dups x))
      (in a x)))

#|

 A few observations.

 1. When you have named properties like the ones above, the *order of
    arguments* to equalities matters -- a lot. Why? Because ACL2s uses
    a rewrite engine that tries to convert the left hand side (LHS) to
    the right hand side (RHS), so you have to put the more complex
    thing on the LHS.

 2. You don't really have to worry too much about that here, since
    your mentor is writing the compiler and she'll figure out how to
    apply the theorems we prove.

 3. We can use ACL2s to see if these lemmas are enough to prove the
    motivating exampale, as shown below. You want to check that no
    inductions were performed. 
|#

(property (el :all a b c d :tl)
  (== (in el (rem-dups (rv (rem-dups (rv (ap (rv (ap (rv (ap a b))
                                                     (ap a c))) 
                                             d))))))
      (v (in el a) (in el b) (in el c) (in el d))))

#|

 You show this to your mentor and she is happy with your progress.
 She wants you to prove some more theorems that correspond to compiler
 transformations she wants to perform. See hwk08.proof for the actual
 work of this homework assignment...

|#

