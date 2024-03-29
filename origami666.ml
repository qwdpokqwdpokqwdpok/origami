


type point = float * float

type kartka = point -> int

let prostokat (p1 : point) (p2 : point) : kartka =
        fun (x, y) ->
            if fst p1 <= x && x <= fst p2 && snd p1 <= y && y <= snd p2 then 1
            else 0

let square x = x *. x

let kolko (p : point) (r : float) : kartka =
        fun (x, y) ->
            if square (x -. fst p) +. square (y -. snd p) <= square r then 1
            else 0

(* iloczyn skalarny *)
(* punkt odniesienia, wektor, wektor *)
let iloczyn_skalarny (p0 : point) (p1 : point) (p2 : point) : float =
    (fst p1 -. fst p0) *. (fst p2 -. fst p0) +. (snd p1 -. snd p0) *. (snd p2 -. snd p0)

(* iloczyn wektorowy (* tozsamosc Lagrange'a *) *)
(* punkt odniesienia, wektor, wektor *)
let iloczyn_wektorowy (p0 : point) (p1 : point) (p2 : point) : float =
    (fst p2 -. fst p0) *. (snd p1 -. snd p0) -. (snd p2 -. snd p0) *. (fst p1 -. fst p0)

(* kwadrat dlugosci wektora *)
let kwadrat_dlugosci (p1 : point) : float =
    square (fst p1) +. square (snd p1)

(*dodawanie elementow typu point *)
let (++) (p1 : point) (p2 : point) : point = 
    (fst p1 +. fst p2, snd p1 +. snd p2)

(*odejmowanie elementow typu point *)
let (--) (p1 : point) (p2 : point) : point = 
    (fst p1 -. fst p2, snd p1 -. snd p2)

(* mnozenie elementu typu point przez liczbe typu float *)
(* nie da sie (**), nie moge znalezc informacji jak dokladnie dziala ten sposob definiowania funkcji *)
(* czy jest wbudowana funkcja do tego typu operacji? *)
let ($$) (f : float) (p1 : point) : point =
    (f *. (fst p1), f *. (snd p1))

(* dzielenie elementu typu point przez liczbe typu float *)
let (//) (p1 : point) (f : float) : point =
    ((fst p1) /. f, (snd p1) /. f)

(* odbicie punktu wzgledem prostej *)
(* odbicie p2 wzgledem prostej wyznaczonej przez p0 p1 *)
(* p2 - 2 * ((p2 - p0) - (iloczyn_skalarny p0 p1 p2 / dlugosc (p1 - p0)) * ((p1 - p0) / dlugosc (p1 - p0))) *)
let odbicie (p0 : point) (p1 : point) (p2 : point) : point =
    (2. $$ p0) -- p2 ++ (2. $$ (((iloczyn_skalarny p0 p1 p2) $$ (p1 -- p0)) // (kwadrat_dlugosci (p1 -- p0))))

type strona = Lewa | Srodek | Prawa

let zloz (q0 : point) (q1 : point) (k : kartka) =
(* po ktorej stronie wzgledem prostej wyznaczonej przez p0 p1 jest p2 *)
        let ktora_strona (p0 : point) (p1 : point) (p2 : point) =
                let iloczyn_wektorowy = iloczyn_wektorowy p0 p1 p2 in
            if iloczyn_wektorowy < 0. then Lewa else
            if iloczyn_wektorowy > 0. then Prawa else
            Srodek in
    fun q2 -> match ktora_strona q0 q1 q2 with
    | Lewa -> k q2 + k (odbicie q0 q1 q2)
    | Srodek -> k q2
    | Prawa -> 0

let skladaj (l : (point * point) list) (k : kartka) : kartka =
    List.fold_left (fun acc (q0, q1) -> zloz q0 q1 acc) k l



let centr = (0., 0.);;
let info = false;;

if info then if info then print_endline "Correctness tests for zloz function:";;

if info then print_string "Rectangle #1 ";;

let a = prostokat centr (10., 10.);;

assert(a centr = 1);;
assert(a (5., 5.) = 1);;
assert(a (10., 10.) = 1);;
assert(a (10., 0.) = 1);;
assert(a (0., 10.) = 1);;
assert(a (10.1, 0.) = 0);;
assert(a (0., 10.1) = 0);;
assert(a (10.1, 10.1) = 0);;

let a = zloz (5., 0.) (5., 377.) a;;

assert(a centr = 2);;
assert(a (-377., 0.) = 0);;
assert(a (5., 2.5) = 1);;
assert(a (2.5, 3.5) = 2);;
assert(a (5., 5.) = 1);;
assert(a (5.1, 5.) = 0);;
assert(a (5.1, 5.1) = 0);;

let a = zloz (5., 0.) (5., 1.) a;;

assert(a centr = 2);;
assert(a (-377., 0.) = 0);;
assert(a (5., 2.5) = 1);;
assert(a (2.5, 3.5) = 2);;
assert(a (5., 5.) = 1);;
assert(a (5.1, 5.) = 0);;
assert(a (5.1, 5.1) = 0);;

if info then print_endline "OK";;

if info then print_string "Rectangle #2 ";;

let b = zloz (-7., -7.) (300., 300.) a;;

assert(b centr = 2);;
assert(b (0., 5.) = 3);;
assert(b (2.5, 2.5) = 2);;
assert(b (1., 2.) = 4);;
assert(b (2.5, 5.) = 3);;
assert(b (2.5, 6.) = 2);;
assert(b (2.5, 2.) = 0);;
assert(b (5., 5.) = 1);;
assert(b (5., 0.) = 0);;
assert(b (4., 2.) = 0);;
assert(b (7., 9.) = 0);;
assert(b (7., 2.) = 0);;
assert(b (5., 2.5) = 0);;
assert(b (10., 0.) = 0);;
assert(b (10., 10.) = 0);;
assert(b (10., 2.5) = 0);;

if info then print_endline "OK";;

if info then print_string "Rectangle #3 ";;

let c = zloz (-6., -6.) (-6.1, -6.1) a;;

assert(c centr = 2);;
assert(c (0., 5.) = 0);;
assert(c (2.5, 2.5) = 2);;
assert(c (1., 2.) = 0);;
assert(c (2.5, 5.) = 0);;
assert(c (2.5, 6.) = 0);;
assert(c (2.5, 2.) = 4);;
assert(c (5., 5.) = 1);;
assert(c (5., 0.) = 3);;
assert(c (4., 2.) = 4);;
assert(c (7., 9.) = 0);;
assert(c (7., 2.) = 2);;
assert(c (7., 3.8) = 2);;
assert(c (5., 2.5) = 3);;
assert(c (10., 0.) = 2);;
assert(c (10., 10.) = 0);;
assert(c (10., 2.5) = 2);;

if info then print_endline "OK";;

if info then print_string "Rectangle #4 ";;

let d = zloz (9., 5.) (4., 2.) c;;

assert(d centr = 0);;
assert(d (2.9, 1.9) = 0);;
assert(d (5., 5.) = 0);;
assert(d (7., 1.) = 2);;
assert(d (7.1, 1.45) = 2);;
assert(d (7.1, 1.5) = 4);;
assert(d (7., 3.) = 4);;
(* assert(d (7., 3.8) = 2);;
6.1 *. 7. != 42.7 *)
assert(d (7., 3.81) = 0);;
assert(d (5., 0.) = 3);;
assert(d (5., 0.5) = 3);;
assert(d (5., 1.) = 7);;
assert(d (5., 2.) = 7);;
assert(d (5., 3.) = 0);;
assert(d (5., 5.) = 0);;
(* assert(d (9., 5.) = 1);; *)
assert(d (4., 0.) = 4);;
assert(d (3., 0.) = 4);;
assert(d (2., 0.) = 8);;
assert(d (1., 0.) = 8);;
assert(d (0., 0.) = 0);;
assert(d (0.8, -0.2) = 4);;
assert(d (10., 3.) = 2);;
assert(d (4., 1.) = 8);;

if info then print_endline "OK";;

if info then print_string "Circle #1 ";;

let a = kolko (3., 3.) 7.;;

assert(a centr = 1);;
assert(a (3., 3.) = 1);;
assert(a (8., 7.5) = 1);;
assert(a (10., 3.) = 1);;
assert(a (3., 10.) = 1);;
assert(a (-4., 3.) = 1);;
assert(a (3., -4.) = 1);;
assert(a (10.1, 3.) = 0);;
assert(a (10., 3.1) = 0);;
assert(a (-4.1, 3.) = 0);;
assert(a (-3.9, 3.) = 1);;

let a = zloz (5., -10.) (5., 100.) a;;

assert(a centr = 1);;
assert(a (0.67, 0.) = 1);;
assert(a (0.68, 0.) = 2);;
assert(a (0.69, 0.69) = 2);;
assert(a (1., 0.) = 2);;
assert(a (2., 2.) = 2);;
assert(a (3., 0.) = 2);;
assert(a (5., 0.) = 1);;
assert(a (5.1, 0.) = 0);;
assert(a (3., 3.) = 2);;
assert(a (3., 10.) = 1);;
assert(a (-1., -1.) = 1);;
assert(a (7., 7.) = 0);;
assert(a (10., 0.) = 0);;

let a = zloz (5., 0.) (5., 0.01) a;;

assert(a centr = 1);;
assert(a (0.67, 0.) = 1);;
assert(a (0.68, 0.) = 2);;
assert(a (0.69, 0.69) = 2);;
assert(a (1., 0.) = 2);;
assert(a (2., 2.) = 2);;
assert(a (3., 0.) = 2);;
assert(a (5., 0.) = 1);;
assert(a (5.1, 0.) = 0);;
assert(a (3., 3.) = 2);;
assert(a (3., 10.) = 1);;
assert(a (-1., -1.) = 1);;
assert(a (7., 7.) = 0);;
assert(a (10., 0.) = 0);;

if info then print_endline "OK";;

if info then print_string "Circle #2 ";;

let a = zloz (1., 0.) (1., -1.) a;;

assert(a centr = 0);;
assert(a (1., 0.) = 2);;
assert(a (1.1, 0.) = 4);;
assert(a (5., 3.) = 2);;
assert(a (3., 3.) = 3);;
assert(a (7., 2.) = 0);;
assert(a (6., 3.) = 1);;
assert(a (6., 2.9) = 0);;
assert(a (6.1, 3.) = 0);;

if info then print_endline "OK";;

if info then print_string "Circle #3 ";;

let a = zloz (5., 10.) (1., 0.) a;;

assert(a centr = 0);;
assert(a (1., 0.) = 2);;
assert(a (2., 0.) = 3);;
assert(a (5., 0.) = 2);;
assert(a (6., 0.) = 0);;
assert(a (2., 2.) = 7);;
assert(a (3., 3.) = 7);;
assert(a (5., 5.) = 5);;
assert(a (6., 6.) = 2);;
assert(a (8., 8.) = 0);;
assert(a (4., 3.) = 3);;
assert(a (5., 3.) = 2);;
assert(a (6., 3.) = 1);;
assert(a (7., 3.) = 0);;
assert(a (1., -1.) = 1);;
assert(a (1., -3.) = 1);;
assert(a (1., -4.) = 0);;
assert(a (3., -1.) = 3);;
assert(a (3., -2.) = 3);;
assert(a (3., -3.) = 1);;
assert(a (3., -4.) = 1);;
assert(a (3., -5.) = 0);;

if info then print_endline "OK";;

if info then print_string "Circle #4 ";;

let a = zloz (1., 0.) (5., 10.) a;;

assert(a centr = 3);;
assert(a (1., 0.) = 2);;
assert(a (2., 0.) = 0);;
assert(a (5., 0.) = 0);;
assert(a (6., 0.) = 0);;
assert(a (2., 2.) = 0);;
assert(a (3., 3.) = 0);;
assert(a (5., 5.) = 0);;
assert(a (6., 6.) = 0);;
assert(a (8., 8.) = 0);;
assert(a (4., 3.) = 0);;
assert(a (5., 3.) = 0);;
assert(a (6., 3.) = 0);;
assert(a (7., 3.) = 0);;
assert(a (1., -1.) = 0);;
assert(a (1., -3.) = 0);;
assert(a (1., -4.) = 0);;
assert(a (3., -1.) = 0);;
assert(a (3., -2.) = 0);;
assert(a (3., -3.) = 0);;
assert(a (3., -4.) = 0);;
assert(a (3., -5.) = 0);;
assert(a (0., 4.) = 3);;
assert(a (0., 5.) = 1);;
assert(a (0., 6.) = 1);;
assert(a (0., 7.) = 0);;
assert(a (0., -1.) = 2);;
assert(a (0., -2.) = 0);;
assert(a (2., 3.) = 7);;
assert(a (1., 3.) = 5);;
assert(a (0., 3.) = 3);;
assert(a (-1., 3.) = 3);;
assert(a (-2., 3.) = 1);;
assert(a (-3., 3.) = 0);;
assert(a (1., 5.) = 5);;
assert(a (2., 5.) = 6);;
assert(a (3., 5.) = 3);;
assert(a (4., 5.) = 0);;
assert(a (3., 6.) = 6);;
assert(a (3., 4.) = 0);;
assert(a (3., 7.) = 6);;
assert(a (3., 8.) = 3);;
assert(a (3., 9.) = 1);;
assert(a (3., 10.) = 1);;
assert(a (3., 10.1) = 0);;

if info then print_endline "OK";;


if info then print_endline "Correctness tests for skladaj function:";;

if info then print_string "Rectangle ";;

let l = [((5., 0.), (5., 377.)); ((5., 0.), (5., 1.));
	 ((-6., -6.), (-6.1, -6.1)); ((9., 5.), (4., 2.))];;

let a = prostokat centr (10., 10.);;

let a = skladaj l a;;

assert(a centr = 0);;
assert(a (2.9, 1.9) = 0);;
assert(a (5., 5.) = 0);;
assert(a (7., 1.) = 2);;
assert(a (7.1, 1.45) = 2);;
assert(a (7.1, 1.5) = 4);;
assert(a (7., 3.) = 4);;
(* assert(a (7., 3.8) = 2);; *)
assert(a (7., 3.81) = 0);;
assert(a (5., 0.) = 3);;
assert(a (5., 0.5) = 3);;
assert(a (5., 1.) = 7);;
assert(a (5., 2.) = 7);;
assert(a (5., 3.) = 0);;
assert(a (5., 5.) = 0);;
(* assert(a (9., 5.) = 1);; *)
assert(a (4., 0.) = 4);;
assert(a (3., 0.) = 4);;
assert(a (2., 0.) = 8);;
assert(a (1., 0.) = 8);;
assert(a (0., 0.) = 0);;
assert(a (0.8, -0.2) = 4);;
assert(a (10., 3.) = 2);;
assert(a (4., 1.) = 8);;

if info then print_endline "OK";;

if info then print_string "Circle ";;

let l = [((5., -10.), (5., 100.)); ((5., 0.), (5., 0.01));
	 ((1., 0.), (1., -1.)); ((5., 10.), (1., 0.));
	 ((1., 0.), (5., 10.))];;

let a = kolko (3., 3.) 7.;;

let a = skladaj l a;;

assert(a centr = 3);;
assert(a (1., 0.) = 2);;
assert(a (2., 0.) = 0);;
assert(a (5., 0.) = 0);;
assert(a (6., 0.) = 0);;
assert(a (2., 2.) = 0);;
assert(a (3., 3.) = 0);;
assert(a (5., 5.) = 0);;
assert(a (6., 6.) = 0);;
assert(a (8., 8.) = 0);;
assert(a (4., 3.) = 0);;
assert(a (5., 3.) = 0);;
assert(a (6., 3.) = 0);;
assert(a (7., 3.) = 0);;
assert(a (1., -1.) = 0);;
assert(a (1., -3.) = 0);;
assert(a (1., -4.) = 0);;
assert(a (3., -1.) = 0);;
assert(a (3., -2.) = 0);;
assert(a (3., -3.) = 0);;
assert(a (3., -4.) = 0);;
assert(a (3., -5.) = 0);;
assert(a (0., 4.) = 3);;
assert(a (0., 5.) = 1);;
assert(a (0., 6.) = 1);;
assert(a (0., 7.) = 0);;
assert(a (0., -1.) = 2);;
assert(a (0., -2.) = 0);;
assert(a (2., 3.) = 7);;
assert(a (1., 3.) = 5);;
assert(a (0., 3.) = 3);;
assert(a (-1., 3.) = 3);;
assert(a (-2., 3.) = 1);;
assert(a (-3., 3.) = 0);;
assert(a (1., 5.) = 5);;
assert(a (2., 5.) = 6);;
assert(a (3., 5.) = 3);;
assert(a (4., 5.) = 0);;
assert(a (3., 6.) = 6);;
assert(a (3., 4.) = 0);;
assert(a (3., 7.) = 6);;
assert(a (3., 8.) = 3);;
assert(a (3., 9.) = 1);;
assert(a (3., 10.) = 1);;
assert(a (3., 10.1) = 0);;

if info then print_endline "OK";;

if info then print_endline "Performance tests (estimated time: 1 minute):";;

if info then print_endline "Rectangle...";;

let gen n =
  let rec aux acc i =
    if i > n then acc
    else
      aux (((float_of_int(1 lsl i), 0.),
	   (float_of_int(1 lsl i), 1.))::acc) (i + 1)
  in
  aux [] 0;;

let const = 24;;

let l = gen const;;

let a = prostokat ((-.max_float) /. 4., (-.max_float) /. 4.)
                  (max_float /. 4., max_float /. 4.);;

let a = skladaj l a;;

assert(a centr = (1 lsl const) + 1);;
assert(a (1., 1.) = 1 lsl const);;
assert(a (-1., -1.) = 2);;
assert(a ((-.max_float) /. 2., (-.max_float) /. 2.) = 0);;
assert(a (max_float /. 4., max_float /. 4.) = 0);;

for i = -2 downto -100000 do
  assert(a (float_of_int(i), float_of_int(i)) = 2)
done;;

if info then print_endline "OK";;

if info then print_endline "Circle...";;
if info then flush_all ();;

let const = 24;;

let l = gen const;;

let a = kolko centr (max_float /. 4.);;

let a = skladaj l a;;

assert(a centr = (1 lsl const) + 1);;
assert(a (1., 1.) = 1 lsl const);;
assert(a (-1., -1.) = 2);;
(* assert(a ((-.max_float) /. 2., (-.max_float) /. 2.) = 0);; *)
assert(a (max_float /. 4., max_float /. 4.) = 0);;

for i = -2 downto -100000 do
  assert(a (float_of_int(i), float_of_int(i)) = 2)
done;;

if info then print_endline "OK";;

if info then print_endline "All tests OK.";;

