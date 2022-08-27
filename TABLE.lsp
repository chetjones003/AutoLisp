; Set the global variables, you can freely edit them
(setq ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
       x_distance     10
       y_distance     2
       text_height    1
       text_style     "complex.shx"
       text_align     "ml"     
) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun c:tbl(/ txt txt_lst x y)
 (setvar "cmdecho" 0)
 (setvar "blipmode" 0)
 (command "style" "txt_style" text_style text_height "1.0" "" "" "" "") 
 (setq data_file (getfiled "Select a data file" "" "CSV" 0))
 (setq start_pt (getpoint "\nPick the left-upper corner for the table: "))
 (setq y (cadr start_pt))
 (setq fp (open data_file "r"))
 ;; read data
 (while (setq txt (read-line fp))
      (setq txt_lst (parse txt))
      (setq x (car start_pt))
      (print_lst txt_lst)
      (setq y (- y y_distance))
  )
 (close fp)
)

(defun parse(txt / n count word lst in_quart)
 (setq n (strlen txt) count 1  word "" in_quart nil lst nil)
 (while (<= count n)
  (setq char (substr txt count 1))

  (if (= char "\"")
     (if in_quart 
        (setq in_quart nil)
        (setq in_quart T)
     )
  )

  (if (and (= char ",")(= in_quart nil)) 
   (progn
      (setq lst (append lst (list word)))
      (setq word "")
   )
   (progn
       (if (/= char "\"")
           (setq word (strcat word char))
       )
       (if (= count n)
          (setq lst (append lst (list word)))
       )
   )
  )
  (setq count (1+ count))
 )
 (setq lst lst)
)

(defun print_lst (lst / txt txt_pt)
  (foreach txt lst
    (setq txt_pt (list x y))
    (command ".text" "s" "txt_style" "j" text_align txt_pt "0" txt )
    (setq x (+ x x_distance))
  )
)

(princ "\nType tbl to run")(princ)
