From Coq Require List Vector.

From Undecidability.L Require Import L Datatypes.Lists.
From Undecidability.TM Require Import TM Util.TM_facts.

Import ListNotations Vector.VectorNotations.

Definition encBoolsListTM {Σ : Type} (s b : Σ) (l : list bool) :=
  (map (fun (x : bool) => (if x then s else b)) l).

Definition encBoolsTM {Σ : Type} (s b : Σ) (l : list bool) :=
  @midtape Σ [] b (encBoolsListTM s b l).

  
Definition TM_bool_computable {k} (R : Vector.t (list bool) k -> (list bool) -> Prop) := 
  exists n : nat, exists Σ : finType, exists s b : Σ, s <> b /\ 
  exists M : TM Σ (k + 1 + n),
  forall v : Vector.t (list bool) k, 
  (forall m, R v m <-> exists q t, TM.eval M (start M) ((Vector.map (encBoolsTM s b) v ++ [niltape]) ++ Vector.const niltape n) q t
                                /\ nth_error (Vector.to_list t) k = Some (encBoolsTM s b m)) /\
  (forall q t, TM.eval M (start M) ((Vector.map (encBoolsTM s b) v ++ [niltape]) ++ Vector.const niltape n) q t ->
          exists m, nth_error (Vector.to_list t) k = Some (encBoolsTM s b m)).

Definition TM₁_bool_computable {k} (Σ : finType) (R : Vector.t (list bool) k -> (list bool) -> Prop) := 
  exists s1 s2 b : Σ, s1 <> s2 /\ s1 <> b /\ s2 <> b /\
  exists M : TM Σ 1,
  forall v : Vector.t (list bool) k, 
  (forall m, R v m <-> exists q, TM.eval M (start M) [midtape [] b (Vector.fold_right (fun l s => encBoolsListTM s1 s2 l ++ s)%list v List.nil)] q [encBoolsTM s1 s2 m]) /\
  (forall q t, TM.eval M (start M) [midtape [] b (Vector.fold_right (fun l s => encBoolsListTM s1 s2 l ++ s)%list v List.nil)] q t ->
          exists m, t = [encBoolsTM s1 s2 m]).
      
Definition encL (l : list bool) := list_enc l.

Definition L_bool_computable {k} (R : Vector.t (list bool) k -> (list bool) -> Prop) := 
  exists s, forall v : Vector.t (list bool) k, 
      (forall m, R v m <-> L.eval (Vector.fold_left (fun s n => L.app s (encL n)) s v) (encL m)) /\
      (forall o, L.eval (Vector.fold_left (fun s n => L.app s (encL n)) s v) o -> exists m, o = encL m).