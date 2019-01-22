chapter \<open>Generated by Lem from \<open>../../src/gen_lib/sail2_state_lifting.lem\<close>.\<close>

theory "Sail2_state_lifting" 

imports
  Main
  "LEM.Lem_pervasives_extra"
  "Sail2_values"
  "Sail2_prompt_monad"
  "Sail2_prompt"
  "Sail2_state_monad"
  "Sail2_state_monad_lemmas"

begin 

(*open import Pervasives_extra*)
(*open import Sail2_values*)
(*open import Sail2_prompt_monad*)
(*open import Sail2_prompt*)
(*open import Sail2_state_monad*)
(*open import {isabelle} `Sail2_state_monad_lemmas`*)

(* State monad wrapper around prompt monad *)

(*val liftState : forall 'regval 'regs 'a 'e. register_accessors 'regs 'regval -> monad 'regval 'a 'e -> monadS 'regs 'a 'e*)
function (sequential,domintros)  liftState  :: "(string \<Rightarrow> 'regs \<Rightarrow> 'regval option)*(string \<Rightarrow> 'regval \<Rightarrow> 'regs \<Rightarrow> 'regs option)\<Rightarrow>('regval,'a,'e)monad \<Rightarrow> 'regs sequential_state \<Rightarrow>(('a,'e)result*'regs sequential_state)set "  where 
     " liftState ra (Done a) = ( returnS a )"
|" liftState ra (Read_mem rk a sz k) = ( bindS (read_mem_bytesS 
  (instance_Sail2_values_Bitvector_list_dict
     instance_Sail2_values_BitU_Sail2_values_bitU_dict) rk a sz) (\<lambda> v .  liftState ra (k v)))"
|" liftState ra (Read_tag t k) = ( bindS (read_tagS 
  (instance_Sail2_values_Bitvector_list_dict
     instance_Sail2_values_BitU_Sail2_values_bitU_dict) t)             (\<lambda> v .  liftState ra (k v)))"
|" liftState ra (Write_memv a k) = ( bindS (write_mem_bytesS a)      (\<lambda> v .  liftState ra (k v)))"
|" liftState ra (Write_tag a t k) = ( bindS (write_tagS 
  (instance_Sail2_values_Bitvector_list_dict
     instance_Sail2_values_BitU_Sail2_values_bitU_dict) a t)          (\<lambda> v .  liftState ra (k v)))"
|" liftState ra (Read_reg r k) = ( bindS (read_regvalS ra r)       (\<lambda> v .  liftState ra (k v)))"
|" liftState ra (Excl_res k) = ( bindS (excl_resultS () )         (\<lambda> v .  liftState ra (k v)))"
|" liftState ra (Undefined k) = ( bindS (undefined_boolS () )      (\<lambda> v .  liftState ra (k v)))"
|" liftState ra (Write_ea wk a sz k) = ( seqS (write_mem_eaS 
  (instance_Sail2_values_Bitvector_list_dict
     instance_Sail2_values_BitU_Sail2_values_bitU_dict) wk a sz)    (liftState ra k))"
|" liftState ra (Write_reg r v k) = ( seqS (write_regvalS ra r v)     (liftState ra k))"
|" liftState ra (Footprint k) = ( liftState ra k )"
|" liftState ra (Barrier _ k) = ( liftState ra k )"
|" liftState ra (Print _ k) = ( liftState ra k )"
|" liftState ra (Fail descr) = ( failS descr )"
|" liftState ra (Exception e) = ( throwS e )" 
by pat_completeness auto

end