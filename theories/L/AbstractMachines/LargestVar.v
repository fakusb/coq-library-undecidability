From Undecidability.L Require Import Util.Subterm.
From Undecidability.L.Datatypes Require Import LProd LNat LTerm.

Fixpoint largestVar (s:term) : nat :=
  match s with
    var n => n
  | app s t => max (largestVar s) (largestVar t)
  | lam s => largestVar s
  end.

Lemma subterm_largestVar s s' :
subterm s s' -> largestVar s <= largestVar s'.
Proof.
  induction 1;cbn;Lia.nia.
Qed.

Lemma largestVar_size s :
  largestVar s <= size s.
Proof.
  induction s;cbn;Lia.lia.
Qed.

Lemma largestVar_prod X Y `{Rx : encodable X} {Ry : encodable Y} (w:X*Y):
  largestVar (enc w) = max (largestVar (enc (fst w))) (largestVar (enc (snd w))).
Proof.
  destruct w.
  unfold enc. destruct Rx,Ry. cbn.  reflexivity.
Qed.
Lemma largestVar_nat (n:nat):
  largestVar (enc n) <= 1.
Proof.
  unfold enc,encodable_nat_enc.
  induction n;cbn in *. all:Lia.lia.
Qed.
Lemma largestVar_term (s:term):
  largestVar (enc s) <= 2.
Proof.
  unfold enc,encodable_term_enc.
  induction s;cbn -[max] in *.
  1:rewrite largestVar_nat.
  all:try Lia.lia.
Qed.

