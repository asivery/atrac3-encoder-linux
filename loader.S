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

_start:
    mov eax, dword [esp]      ; argc
    mov ebx, esp              ; argv
    add ebx, 4
    
    push ebx
    push eax
    
    mov esi, dword [entry]
    call esi
    
    mov ebx, 0
    mov eax,1
    int 0x80

entry: dd 0x004012f0


section .redir
_fix_fseek_redir_0: ;MSVCR71.DLL::fseek
jmp fix_fseek
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
__stub_redir_7: ;MSVCR71.DLL::_ftol
jmp __ftol
_floor_redir_8: ;MSVCR71.DLL::floor
jmp floor wrt ..plt
_pow_redir_9: ;MSVCR71.DLL::_CIpow
jmp pow wrt ..plt
_memcpy_redir_10: ;MSVCR71.DLL::memcpy
jmp memcpy wrt ..plt
_calloc_redir_11: ;MSVCR71.DLL::calloc
jmp calloc wrt ..plt
_asin_redir_12: ;MSVCR71.DLL::_CIasin
jmp asin wrt ..plt
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

fix_fseek:
    push ebx
    push edx
    ; File size now on stack
    ; Args are now shifted by 8, because of the pushes above
    mov eax, dword [esp + 0xc]
    mov ebx, dword [esp + 0x10]
    mov edx, dword [esp + 0x14]
    push edx
    push ebx
    push eax
    call fseek wrt ..plt
    add esp, 0xc
    pop edx
    ; File is now at the correct position
    ; Call ftell - get total file size
    mov eax, dword [esp + 8]
    push eax
    call ftell wrt ..plt
    add esp, 0x4
    push eax
    ; Our new file position is on the stack
    ; Seek to the file end, check the position, args offset by 4
    mov eax, dword [esp + 0xc]
    push 0x2
    push 0x0
    push eax
    call fseek wrt ..plt
    add esp, 0xc
    ; Run ftell again
    ; args offset by 4
    mov eax, dword [esp + 0xc]
    push eax
    call ftell wrt ..plt
    add esp, 0x4
    ; Now the file size is in eax
    pop ebx
    push ebx
    push eax
    ; Seek again, to the correct position
    mov eax, dword [esp + 0x10]
    push 0x0
    push ebx
    push eax
    call fseek wrt ..plt
    add esp, 0xc
    
    ; Now at the correct position, ready to return
    ; Compare and set the flags adequately
    pop eax
    pop ebx
    cmp eax, ebx
    jne .ret
    
    ; We're at EOF. Update the FILE*'s flags
    mov eax, dword [esp + 8]
    or dword [eax], 0x10
    
    .ret:
      pop ebx
      mov eax, 0
      ret
