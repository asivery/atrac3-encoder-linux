cpu 386

global _start
section .bstext

extern fseek
extern fwrite
extern free
extern malloc
extern fprintf
extern memmove
extern floor
extern memcpy
extern calloc
extern ftell
extern exit
extern fread
extern fgetc
extern fopen
extern fclose
extern atoi
extern printf
extern pow
extern asin

; The Windows code seems to trip up if the stack is greater than 0xfff00000
; The _repair_stack method triggers only when that condition is met, and
; sets the stack pointer to $esp - ($esp & ~0xfff00000) - 1
; Because the x86 stack grows downwards, this is equal to allocating a bunch
; garbage data on the stack.

_start:
    mov ecx, dword [esp]      ; argc
    mov ebx, esp              ; argv
    add ebx, 4
    
    mov eax, esp
    cmp eax, 0xfff00000
    jnl _repair_stack

.call_main:
    push ebx
    push ecx
    
    mov eax, dword [entry]
    call eax
    
    mov ebx, 0
    mov eax,1
    int 0x80

_repair_stack:
    mov esp, 0xffefffff
    jmp _start.call_main

entry: dd 0x004012f0


section .redir
_fix_fseek_redir_0: ;MSVCR71.DLL::fseek
jmp fseek wrt ..plt
_fwrite_redir_1: ;MSVCR71.DLL::fwrite
jmp fwrite wrt ..plt
_free_redir_2: ;MSVCR71.DLL::free
jmp free wrt ..plt
_malloc_redir_3: ;MSVCR71.DLL::malloc
jmp malloc wrt ..plt
_fprintf_redir_4: ;MSVCR71.DLL::fprintf
jmp fprintf wrt ..plt
__stub_redir_5: ;MSVCR71.DLL::_iob
jmp _stub
_memmove_redir_6: ;MSVCR71.DLL::memmove
jmp memmove wrt ..plt
__ftol_redir_7: ;MSVCR71.DLL::_ftol
jmp __ftol
_floor_redir_8: ;MSVCR71.DLL::floor
jmp floor wrt ..plt
_pow_redir_9: ;MSVCR71.DLL::_CIpow
jmp cipow
_memcpy_redir_10: ;MSVCR71.DLL::memcpy
jmp memcpy wrt ..plt
_calloc_redir_11: ;MSVCR71.DLL::calloc
jmp calloc wrt ..plt
_asin_redir_12: ;MSVCR71.DLL::_CIasin
jmp ciasin
__stub_redir_13: ;MSVCR71.DLL::__security_error_handler
jmp _stub
__stub_redir_14: ;MSVCR71.DLL::_except_handler3
jmp _stub
_ftell_redir_15: ;MSVCR71.DLL::ftell
jmp ftell wrt ..plt
_exit_redir_16: ;MSVCR71.DLL::_exit
jmp exit wrt ..plt
__stub_redir_17: ;MSVCR71.DLL::_XcptFilter
jmp _stub
_exit_redir_18: ;MSVCR71.DLL::_cexit
jmp exit wrt ..plt
__stub_redir_19: ;MSVCR71.DLL::__p___initenv
jmp _stub
__stub_redir_20: ;MSVCR71.DLL::_amsg_exit
jmp _stub
__stub_redir_21: ;MSVCR71.DLL::__getmainargs
jmp _stub
__stub_redir_22: ;MSVCR71.DLL::_initterm
jmp _stub
__stub_redir_23: ;MSVCR71.DLL::__setusermatherr
jmp _stub
__stub_redir_24: ;MSVCR71.DLL::_adjust_fdiv
jmp _stub
__stub_redir_25: ;MSVCR71.DLL::__p__commode
jmp _stub
__stub_redir_26: ;MSVCR71.DLL::__p__fmode
jmp _stub
__stub_redir_27: ;MSVCR71.DLL::__set_app_type
jmp _stub
__stub_redir_28: ;MSVCR71.DLL::__dllonexit
jmp _stub
__stub_redir_29: ;MSVCR71.DLL::_onexit
jmp _stub
__stub_redir_30: ;MSVCR71.DLL::_controlfp
jmp _stub
_fread_redir_31: ;MSVCR71.DLL::fread
jmp fread wrt ..plt
_fgetc_redir_32: ;MSVCR71.DLL::fgetc
jmp fgetc wrt ..plt
_fopen_redir_33: ;MSVCR71.DLL::fopen
jmp fopen wrt ..plt
_fclose_redir_34: ;MSVCR71.DLL::fclose
jmp fclose wrt ..plt
_exit_redir_35: ;MSVCR71.DLL::exit
jmp exit wrt ..plt
_atoi_redir_36: ;MSVCR71.DLL::atoi
jmp atoi wrt ..plt
_exit_redir_37: ;MSVCR71.DLL::_c_exit
jmp exit wrt ..plt
_printf_redir_38: ;MSVCR71.DLL::printf
jmp printf wrt ..plt

_stub: ret

cipow:
    push ebp
    mov ebp, esp
    sub esp, 68
    fstp qword [esp + 8]
    fwait
    fstp qword [esp]
    fwait
    mov ecx, 2
    .1:
    fxam
    fstsw ax
    and ax, 0x4500
    cmp ax, 0x4100
    je .2
    fstp qword [esp + ecx * 8]
    fwait
    inc ecx
    jmp .1
    .2:
    mov dword [ebp - 4], ecx
    call pow wrt ..plt
    mov ecx, [ebp - 4]
    fstp qword [esp + 8]
    .3:
    dec ecx
    fld qword [esp + ecx * 8]
    cmp ecx, 1
    jne .3
    leave
    ret

    ciasin:
    push ebp
    mov ebp, esp
    sub esp, 68
    fstp qword [esp + 8]
    fwait
    fstp qword [esp]
    fwait
    mov ecx, 2
    .1:
    fxam
    fstsw ax
    and ax, 0x4500
    cmp ax, 0x4100
    je .2
    fstp qword [esp + ecx * 8]
    fwait
    inc ecx
    jmp .1
    .2:
    mov dword [ebp - 4], ecx
    call asin wrt ..plt
    mov ecx, [ebp - 4]
    fstp qword [esp + 8]
    .3:
    dec ecx
    fld qword [esp + ecx * 8]
    cmp ecx, 1
    jne .3
    leave
    ret


__ftol:
    fnstcw  word [esp-2]
    mov     ax, word [esp-2]
    or      ax, 0C00h
    mov     word [esp-4], ax
    fldcw   word [esp-4]
    fistp   qword [esp-12]
    fldcw   word [esp-2]
    mov     eax, dword [esp-12]
    mov     edx, dword [esp-8]
    ret
