let _ =
  let test str rst =
    assert (Helper.run_str str = rst)
  in

  let test_time str time rst =
    let start_time = Unix.gettimeofday () in
      test str rst;
      let end_time = Unix.gettimeofday () in
      let run_time = end_time -. start_time in
        assert (run_time >= time)
  in

  test "(go (write 1))" "1";
  test "(define ch (make-chan)) (go (write (receive ch)) (send ch 42))" "42";

  test_time
    "(define ch (make-chan))
     (go (write (receive ch))
         (begin
           (sleep 200)
           (send ch 42)))"
    0.2
    "42";
  test_time
    "(define ch (make-chan))
     (go (begin
           (sleep 100)
           (write (receive ch)))
         (begin
           (send ch 42)
           (sleep 100)))"
    0.2
    "42";
  test_time
    "(define ch (make-chan))
     (go (begin
           (sleep 200)
           (write (receive ch)))
         (send ch 42))"
    0.2
    "42";

  prerr_string "All passed!\n"