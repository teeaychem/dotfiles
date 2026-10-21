fundamental-mode ;; Available everywhere

(today (format-time-string "%Y%m%d"))

;; abbreviations

(nbhd "neighbourhood")
(prop "proposition")
(inf "information")
(prob "probability")
(inqu "inquisitive")
(pmods "plausibility models")
(plau "plausibility")
(int "interrogative")
(dec "declarative")
(cond "conditional")
(epi "epistemic")
(dox "doxastic")
(pref "preference")

prog-mode

(fixme (if (derived-mode-p 'emacs-lisp-mode) ";; " comment-start) "FIXME ")
(todo (if (derived-mode-p 'emacs-lisp-mode) ";; " comment-start) "TODO ")
(bug (if (derived-mode-p 'emacs-lisp-mode) ";; " comment-start) "BUG ")
(hack (if (derived-mode-p 'emacs-lisp-mode) ";; " comment-start) "HACK ")
