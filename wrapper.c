#define CAML_NAME_SPACE
#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/custom.h>
#include <caml/bigarray.h>

#include "stdio_base.h"

CAMLprim value
caml_stdio_write(value v_buf, value v_len)
{
  CAMLparam2(v_buf, v_len);

  void *buf_ptr = Caml_ba_data_val(v_buf);
  ssize_t bytes_written =
    stdio_write (buf_ptr, Int_val(v_len));
  
  CAMLreturn(Val_int(bytes_written));
}