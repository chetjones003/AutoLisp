; Reload function
(defun c:RELOAD () (load "ColorPicker.lsp") (alert "Loaded"))
; -------------------------------------------------------------

; Error Handler
(defun cj::Error (st)
  (if (not (member st (list "Function cancelled" "quit / exit abort")))
    (vl-bt)
  ); if

  (princ)
); defun

; DFX Helper Function
(defun dxf (i l) (cdr (assoc i l)) )

; Color Picker
(defun c:colorp (/ *error* esel ent layer objectLayer oldColor newColor)
                         ; esel - stored selection of object
                         ; ent - gets the values associated with selected object
                         ; layer - gets the string value of the layer of the selected object
                         ; objectLayer - object of the layer
                         ; color - gets the color of the selected object's layer
                         ; newColor - prompt user for new color

  (setq *error* cj::Error)

  ; select an object and change its layer color
  (if
    (and
      ; slect the object 
      (setq esel (entsel))
      (setq ent (entget (car esel)))

      ; get its layer
      (setq layer (dxf 8 ent))

      ; get the layers color
      (setq objectLayer (entget (tblobjname "LAYER" layer)))
      (setq oldColor (dxf 62 objectLayer))

      ; get a color
      (setq newColor (acad_colordlg oldColor))

      ; update that layer
      (setq objectLayer (subst (cons 62 newColor) (assoc 62 objectLayer) objectLayer))
    ); and

    ; if all the above are true modify layer color
    (progn
      (entmod objectLayer)
      (command "REGEN")
    ); progn

    ; otherwise just exit

  ); if

(princ)
); colorp
