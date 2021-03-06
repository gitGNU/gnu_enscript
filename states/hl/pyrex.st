/**
 * Name: pyrex
 * Description: Pyrex - a Language for Writing Python Extension Modules
 * Author: Markku Rossi <mtr@iki.fi>
 */

state pyrex extends python
{
  /* Additional keywords.
     (build-re '( NULL as cdef char ctypedef double enum extern float
     include int long private public short signed sizeof struct union
     unsigned void )) */
  /\b(NULL|as|c(def|har|typedef)|double|e(num|xtern)|float|in(clude|t)|long\
|p(rivate|ublic)|s(hort|i(gned|zeof)|truct)|un(ion|signed)|void)\b/ {
    keyword_face(true);
    language_print($0);
    keyword_face(false);
  }
}


/*
Local variables:
mode: c
End:
*/
