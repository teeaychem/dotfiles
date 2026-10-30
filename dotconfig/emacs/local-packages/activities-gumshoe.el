;;; activities-gumshoe.el --- Activity-scoped Gumshoe history -*- lexical-binding: t; -*-

;;; Commentary:
;; Set `gumshoe-entry-type' to `activities-gumshoe-context' before enabling
;; tracking.  Entries record the activity name at visit time, so shared
;; buffers retain separate histories.  Older entries remain globally visible.
;; Filtered commands require an activity; global Gumshoe commands are unchanged.

;;; Code:

(require 'activities)
(require 'gumshoe)

(declare-function consult-gumshoe--peruse "consult-gumshoe")

(defun activities-gumshoe--current-name ()
  "Return the current activity name, or nil outside an activity."
  (when-let* ((activity (activities-current)))
    (activities-activity-name activity)))

(defclass activities-gumshoe-context (gumshoe-context)
  ((activity :initform (activities-gumshoe--current-name)
             :documentation "Activity name when this location was recorded."))
  "A Gumshoe location tagged with its originating activity.")

(cl-defmethod gumshoe-context--equal ((self activities-gumshoe-context)
                                    (other gumshoe-context))
  "Compare SELF and OTHER, keeping visits in different activities distinct."
  (and (object-of-class-p other 'activities-gumshoe-context)
       (equal (oref self activity) (oref other activity))
       (cl-call-next-method)))

(cl-defmethod gumshoe--end-of-leash-p ((entry activities-gumshoe-context))
  "Record activity changes even without movement away from ENTRY."
  (or (not (equal (oref entry activity) (activities-gumshoe--current-name)))
      (cl-call-next-method)))

(defun activities-gumshoe--filter ()
  "Return a predicate capturing the current activity for this navigation."
  (let ((activity (or (activities-gumshoe--current-name)
                      (user-error "No current activity"))))
    (lambda (entry)
      (and (object-of-class-p entry 'activities-gumshoe-context)
           (equal activity (oref entry activity))
           (not (gumshoe-context--dead-p entry))))))

(defun activities-gumshoe--backtracker ()
  "Return the active Gumshoe backtracker."
  (unless (and global-gumshoe-mode gumshoe-mode)
    (user-error "Gumshoe tracking is not enabled"))
  (oref gumshoe-mode backtracker))

;;;###autoload
(defun activities-gumshoe-backtrack ()
  "Backtrack through locations recorded in the current activity."
  (interactive)
  (let ((filter (activities-gumshoe--filter))
        (backtracker (activities-gumshoe--backtracker)))
    ;; Gumshoe's automatic cancellation recognises its built-in commands.
    (setq this-command 'gumshoe-backtrack)
    (global-gumshoe-backtracking-mode 1)
    (gumshoe--init-backtracking backtracker filter)
    (gumshoe--backtrack backtracker #'+)))

;;;###autoload
(defun activities-gumshoe-consult ()
  "Browse the current activity's Gumshoe history with Consult previews."
  (interactive)
  (let ((filter (activities-gumshoe--filter))
        (backtracker (activities-gumshoe--backtracker)))
    (require 'consult-gumshoe)
    (gumshoe--clean (oref backtracker backlog))
    (consult-gumshoe--peruse
     (gumshoe--construct-timeline (oref backtracker backlog))
     gumshoe-slot-schema filter)))

(provide 'activities-gumshoe)
;;; activities-gumshoe.el ends here
