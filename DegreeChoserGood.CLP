;;;======================================================
;;;   Degree chosing System
;;;
;;;     This system helps the user decide what degree to chose/study at university
;;;
;;;   	!!This is MODIFIED from the code auto.clp!!
;;;
;;;     To execute, load, reset and run.
;;;======================================================

;;****************
;;* DEFFUNCTIONS *
;;****************

(deffunction ask-question (?question $?allowed-values)
   (printout t ?question)
   (bind ?answer (read))
   (if (lexemep ?answer) 
       then (bind ?answer (lowcase ?answer)))
   (while (not (member ?answer ?allowed-values)) do
      (printout t ?question)
      (bind ?answer (read))
      (if (lexemep ?answer) 
          then (bind ?answer (lowcase ?answer))))
   ?answer)

(deffunction yes-or-no-p (?question)
   (bind ?response (ask-question ?question yes no y n))
   (if (or (eq ?response yes) (eq ?response y))
       then TRUE 
       else FALSE))



;;;***************
;;;* RULES *
;;;***************

(defrule determine-ncea-pass  ""
	(not (decided ?))
	=>
	(if (yes-or-no-p "Did u pass NCEA level 3 (yes/no)? ")
		then
		(assert (pass-NCEA))		
		else
		(assert (not-pass-NCEA))))
		
		

(defrule determine-study-desire ""
	(not (decided ?))
	(not-pass-NCEA)
	=>
	(if (yes-or-no-p "Do you even still want to study (yes/no)? ")
	then 
	(assert (decided "Do a Random AUT degree"))
	else	
	(assert (decided "You don't want to do a degree"))))

(defrule determine-job-desire ""
	(pass-NCEA)
	(not (decided ?))
	=>
	(if (yes-or-no-p "Do you want a job after uni (yes/no)? ")
	then 
	(assert (want-job))
	else	
	(assert (dont-want-job))))
	

(defrule determine-essay-skill ""
	(not (decided ?))
	(pass-NCEA)
	(dont-want-job)
	=>
	(if (yes-or-no-p "Can you write essays (yes/no)? ")
	then 
	(assert (decided "Bachelor of Arts"))
	else	
	(assert (decided "Bachelor of Fine Arts"))))	

(defrule determine-first-year-enjoyment ""
	(pass-NCEA)
	(want-job)
	(not (decided ?))
	=>
	(if (yes-or-no-p "Do you want to enjoy your first year (yes/no)? ")
	then 
	(assert (enjoy first-year))
	else	
	(assert (not-enjoy first-year))))

(defrule determine-enjoy-gruesome-things ""
	(not (decided ?))
	(pass-NCEA)
	(want-job)
	(not-enjoy first-year)
	=>
	(if (yes-or-no-p "Do you ejoy gruesome things (yes/no)? ")
	then 
	(assert (decided "Bachelor of Medicine"))
	else	
	(assert (decided "Bachelor of Law"))))	

(defrule determine-success ""
	(pass-NCEA)
	(want-job)
	(enjoy first-year)
	(not (decided ?))
	=>
	(if (yes-or-no-p "Do you want to be a success (yes/no)? ")
	then 
	(assert (yes-success))
	else	
	(assert (no-success))))

(defrule determine-like-design ""
	(pass-NCEA)
	(want-job)
	(enjoy first-year)
	(no-success)
	(not (decided ?))
	=>
	(bind ?response
		(ask-question "Do you like design finance or healthcare best (design/finance/healthcare)?" design finance healthcare))
	(if (eq ?response design)
	then
	(assert (decided "Bachelor of Architecture"))
	else (if (eq ?response finance)
		then (assert (decided "Bachelor of Commerce")))))

(defrule determine-like-healthcare ""
	(pass-NCEA)
	(want-job)
	(enjoy first-year)
	(no-success)
	(not (decided ?))
	=>
	(assert	(decided "Bachelor of Nursing")))

(defrule determine-hard-worker ""
	(pass-NCEA)
	(want-job)
	(enjoy first-year)
	(yes-success)
	(not (decided ?))
	=>
	(if (yes-or-no-p "Are you a hard worker (yes/no)? ")
	then 
	(assert (decided "Bachelor of Engineering"))
	else	
	(assert (not-hard-worker))))

(defrule determine-enjoy-computers ""
	(pass-NCEA)
	(want-job)
	(enjoy first-year)
	(no-success)
	(not-hard-worker)
	(not (decided ?))
	=>
	(if (yes-or-no-p "Do you enjoy staring at a computer (yes/no)? ")
	then 
	(assert (decided "Bachelor of Science"))
	else	
	(assert (decided "Bachelor of Property"))))

;;;****************************
;;;* RULES *
;;;****************************

(defrule system-banner ""
  (declare (salience 10))
  =>
  (printout t crlf crlf)
  (printout t "The Degree Decision Expert System")
  (printout t crlf crlf))

(defrule print-Degree ""
  (declare (salience 10))
  (decided ?item)
  =>
  (printout t crlf crlf)
  (printout t "Suggested Degree/solution:")
  (printout t crlf crlf)
  (format t " %s%n%n%n" ?item))
