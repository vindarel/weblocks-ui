(defpackage #:weblocks.ui.core
  (:use #:cl)
  (:import-from #:weblocks
                #:deftemplate)
  (:export
   #:widget))
(in-package weblocks.ui.core)


(weblocks:defwidget widget (weblocks:widget)
  ()
  (:documentation "Use this class as a parent for all widgets, who use UI."))


(defmethod weblocks.dependencies:get-dependencies ((widget widget))
  (log:debug "Returning new-style dependencies for UI widget.")
  
  (append (list (weblocks.dependencies:make-dependency
                 "https://cdnjs.cloudflare.com/ajax/libs/foundation/6.4.3/js/foundation.min.js"
                 :integrity "sha256-Nd2xznOkrE9HkrAMi4xWy/hXkQraXioBg9iYsBrcFrs=")
                (weblocks.dependencies:make-dependency
                 "https://cdnjs.cloudflare.com/ajax/libs/foundation/6.4.3/css/foundation.min.css"
                 :integrity "sha256-itWEYdFWzZPBG78bJOOiQIn06QCgN/F0wMDcC4nOhxY="))
          
          (call-next-method)))


(defun button-wt (&key value name id class disabledp submitp)
  (with-html-to-string
    (:input :name name
            :type "submit"
            :id id
            :class (format nil "btn ~A ~A"
                           class
                           (when submitp "btn-primary"))
            :value value
            :disabled (when disabledp "disabled")
            :onclick "disableIrrelevantButtons(this);")))

(deftemplate :button-wt 'button-wt 
             :application-class 'weblocks::twitter-bootstrap-webapp)


(defun render-button (name  &key (value (weblocks::translate (weblocks::humanize-name name)))
                                 id
                                 (class "submit")
                                 disabledp)
  "Renders a button in a form.

   'name' - name of the html control. The name is attributized before
   being rendered.
   'value' - a value on html control. Humanized name is default.
   'id' - id of the html control. Default is nil.
   'class' - a class used for styling. By default, \"submit\".
   'disabledp' - button is disabled if true."
    (weblocks::render-wt 
      :button-wt
      nil
      :value value
      :name (weblocks::attributize-name name)
      :id id
      :class class 
      :disabledp disabledp 
      :submitp (string= name "submit")))


