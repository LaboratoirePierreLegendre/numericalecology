/*******************************************************************
 Generic calls to R_registerRoutines and R_useDynamicSymbols
 Guillaume Guénard - Université de Montréal - 2008-2019
*******************************************************************/

#include <R.h>
#include <Rinternals.h>
#include <R_ext/Rdynload.h>

void R_init_constr_hclust(DllInfo* info) {
  R_registerRoutines(info, NULL, NULL, NULL, NULL);
  R_useDynamicSymbols(info, TRUE);
}
