let _ =

  let test_exn str expected =
    try (ignore (Helper.repl_str str); assert false)
    with catched -> assert (catched = expected)
  in

  let test str rst =
    Runtime_conf.enable_tco := false;
    test_exn str Stack_overflow;
    Runtime_conf.enable_tco := true;
    assert (Helper.repl_str str = rst)
  in

  test "(define (f x) (if (= x 0) 0 (f (- x 1)))) (f 1024)" "0";
  test "(define (f x) (if (/= x 0) (f (- x 1)) 0)) (f 1024)" "0";
  (* TODO cond, case, and, or *)
  test "(define (f x) (if (= x 0) 0 (let ((y (- x 1))) (f y)))) (f 1024)" "0";
  test "(define (f x) (if (= x 0) 0 (let* ((y (- x 1))) (f y)))) (f 1024)" "0";
  test "(define (f x) (if (= x 0) 0 (letrec ((y (- x 1))) (f y)))) (f 1024)" "0";
  test "(letrec ((even?
                  (lambda (n)
                    (if (eq? 0 n)
                        #t
                        (odd? (- n 1)))))
                 (odd?
                  (lambda (n)
                    (if (eq? 0 n)
                        #f
                        (even? (- n 1))))))
           (even? 1024))" "#t";
  (* TODO let-syntax, letrec-syntax *)
  test "(define (f x) (if (= x 0) 0 (begin (define y (- x 1)) (f y)))) (f 1024)" "0";
  (* TODO do *)

  Printf.printf "All passed!\n";

;;