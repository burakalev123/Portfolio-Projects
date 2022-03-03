
REPORT zpa_delete_delta.   

update zpa_dagitim
     set zzdelta = space
   where zzdelta eq 'D'.
  if sy-subrc eq 0.
    commit work and wait.
  endif. 