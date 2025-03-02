format PE
entry start

include 'win32ax.inc'
include 'macro/if.inc'

section '.data' data readable writeable
        Check_num db 0
        Input db 'zzz', 0
        Monkey rb 20
        Mankey rb 20
        keyword_table db ?

section '.idata' import data readable

library msvcrt, 'msvcrt.dll', kernel32, 'kernel32.dll'
import msvcrt, printf, 'printf', scanf, 'scanf', getch, '_getch'

section '.text' code readable writeable executable




        ;start:
               ; cinvoke printf, 'Enter a character.'   ; will become outdated
               ; cinvoke scanf, '%c', Monkey
               ; cinvoke printf, 'Enter a string.'
               ; cinvoke scanf, '%s', Mankey
               ; cinvoke printf, Monkey
               ; cinvoke printf, Mankey
                ;invoke getch

                ;jmp Inputer
        ;Inputer:
                mov eax, 'zzz'
                jmp help
        help:
                mov eax, 'zzz'
                mov ecx, 0
                inc ecx
                add [Check_num], 1
                cmp eax, 'a'
                je set_compare
                add [Check_num], 1
                cmp eax, 'b'
                je set_compare
                add [Check_num], 1
                cmp eax, 'c'
                je set_compare
                add [Check_num], 1
                cmp eax, 'd'
                je set_compare
                add [Check_num], 1
                cmp eax, 'e'
                je set_compare
                add [Check_num], 1
                cmp eax, 'f'
                je set_compare
                add [Check_num], 1
                cmp eax, 'g'
                je set_compare
                add [Check_num], 1
                cmp eax, 'h'
                je set_compare
                add [Check_num], 1
                cmp eax, 'i'
                je set_compare
                add [Check_num], 1
                cmp eax, 'j'
                je set_compare
                add [Check_num],1
                cmp eax, 'k'
                je set_compare
                add [Check_num],1
                cmp eax, 'l'
                je set_compare
                add [Check_num],1
                cmp eax, 'm'
                je set_compare
                add [Check_num],1
                cmp eax, 'n'
                je set_compare
                add [Check_num],1
                cmp eax, 'o'
                je set_compare
                add [Check_num],1
                cmp eax, 'p'
                je set_compare
                add [Check_num],1
                cmp eax, 'q'
                je set_compare
                add [Check_num],1
                cmp eax, 'r'
                je set_compare
                add [Check_num],1
                cmp eax, 's'
                je set_compare
                add [Check_num],1
                cmp eax, 't'
                je set_compare
                add [Check_num],1
                cmp eax, 'u'
                je set_compare
                add [Check_num],1
                cmp eax, 'v'
                je set_compare
                add [Check_num],1
                cmp eax, 'w'
                je set_compare
                add [Check_num],1
                cmp eax, 'x'
                je set_compare
                add [Check_num],1
                cmp eax, 'y'
                je set_compare
                add [Check_num],1
                cmp eax, 'z'
                je set_compare
                mov edx, ['S-e']
                cinvoke printf, '%s', edx
        set_compare:
                mov edx, ['S-' + ecx]
                cmp edx, ['S-e']
                je getcher
                cinvoke printf, '%s', edx  ; May fail. Does not work with multiple characters
                jmp help
        getcher:
                invoke getch
        array:                               ; Fix this
                virtual at keyword_table
                        keyword_operator db ?
                        keyword_keyword db ?
                end virtual



; Start from top and look for a focus.
start:                                     ; THIS CODE WILL NOT WORK!!!
        mov eax, "Temp input"
        jmp handling
handling:
        bsf eax, edx
        cmp edx, 32h
        je space_handling
        add [word_array], edx

        ;call the comparison engine
        ;Check for focus settings
space_handling:
        inc [word_array]
        shr eax, 1
        jmp handling
focus_check_line:
        mov ecx, 0      ;Allocate if necessary
        cmp lexeme_storage, focus_setter_1 ; FIX THIS. LOAD PROPER ARRAY LOCATION!!!
        je focus_settings
focus_input:
        mov eax, temporary    ; Replace eax with word array in actual script
        bsf eax, ebx
        add set_focus_variable, ebx
        shr ebx, 1
        cmp ecx, 10
        je focus_error ; Likely will need a different error code
        xor ecx, ecx
        jmp focus_settings
focus_settings:
        inc ecx
        cmp ecx, 6
        je focus_error
        cmp focus_variable, set_focus_variable
        je focus_confirm

focus_error:
        ; Implement error code for focus not defined in compiler
focus_confirm:
        mov focus_opcode, ecx
        xor ecx, ecx
        xor eax, eax
        xor ebx, ebx
        cmp lexeme_storage, focus_setter_2
        jne error
        cmp lexeme_storage, 10h
        ; jump to the next array point
func_check_line:
        mov eax, temporary
        cmp lexeme_storage, "func"; This will likely be replaced with some other variable
        je func_param_set
func_param_set:
        inc lexeme_storage
        cmp eax,32h
        je func_condition_check
        bsf eax,edx
        add [function_var_storage], edx
        shr eax,1
        xor edx,edx
func_condition_check:
        shr eax,1
        cmp eax,":"
        jne error    ;Function Condition start err
        cmp eax,10h
        je next_line_ready
        mov [func_condition], eax
next_line_ready:
        inc lexeme_storage  ;Fix code
        mov eax, word_array
        shl eax,1; Account for shr on condition check
        jmp func_condition_check