format PE
entry start

include 'win32ax.inc'

section '.data' data readable writeable
Input rb 16
stringlen db ?
basic_stringlen rd 32
keyword_table db "if", "extif", "while", "func", "ret", "break", "continue", "switch", "case", "default", "goto"     ; Rename keyword_table to conditional_list
data_types db "int", "float", "char", "double", "boolean", "string", "long"
operator_list db "+", "-", "*", "/", "%", "++", "--", "=", "==", "!=", "<", ">", "<=", ">=", "&&"
focus_setter_1 db "[", 0
focus_setter_2 db "]", 0
focus_variables db "vectorize", "matrix", "graphical", "data", "system"
set_focus_variable db 0
condition db "vectorize", "matrix", "graphical", "data", "system"
scan2 rb 200
file 'C:\Users\Adi\Downloads\fasmw17332\SOURCE\IDE\FASMW\test.txt'
sizer_point rb 20
Check_num db 16
run db 16
size_count rd 32
storage rd 32
lexeme_storage dd 255
control_flow_storage dd 0
array dd ?
temp dd 32
temper dd 32 ; Fix this
timer db 10
word_array dd 32 dup ?
word_array_dup dd 32 dup ?
word_len dd 32 dup ?
word_array_count dd 32
ebx_dup db 12
edi_dup dd 32
fresh_array dd 32 dup ?
focus_opcode db 0
line_count db 0
function_set db 0

section '.idata' import data readable

library msvcrt, 'msvcrt.dll', kernel32, 'kernel32.dll'
import msvcrt, printf, 'printf', scanf, 'scanf', getch, '_getch'

section '.code' code readable writeable executable
start:
        cinvoke printf, 'Enter string.'
        cinvoke scanf, '%s', eax         ; Only takes a single line
        jmp reg_set                      ; Change later to accept a file

reg_set:
        mov ecx, 0        ; Fix below two lines
        ;mov al, temp
        ;mov ax, temper
        mov ebx, 0
        mov esi, 0        ; Set registers
        mov [word_array], 0
        mov [word_array_count], 0
        mov edi, keyword_table
        jmp strlen
strlen:
        inc ecx
        bsf eax, ebp ; Replace eax and ebx with temp and temper later
        ;mov temp, eax
        cmp ebp, 0
        je temp_reg_reset
        cmp ebp, 32h             ; Separate words from Input
        je new_word_strlen
        jne strlen         ; Fix this
        cmp ebp, 10h           ; Newline character
        je new_line_count
        add [word_array], ebp
        xor ebp,ebp
        shr eax, 1
        jmp temp_reg_reset
        ; Change jump location
new_line_set:
        mov line_count, 0
        xor ebp, ebp
        jmp new_line_count
new_line_count:
        inc line_count
        jmp temp_reg_reset
temp_reg_reset:                ;Test solution
        mov eax, temp
        mov ebp, temper  ; In case temper is needed
        jmp comparison_engine
        ; Set a jump location

new_word_strlen:
        inc [word_array]
        add [word_array_count], 1
        mov [word_len], ecx           ; Stores strlen
        inc [word_len]
        xor ecx, ecx
        jmp strlen
reset_word_array:
        dec [word_array]                   ; Sets array to default
        dec [word_array_count]              ; Set jump location
comparison_engine:                       ; Take word_array as input
        inc ebx
        cmp ebx, 20             ; Check for infinite loop
        je error
        cmp edi, 0
        je ebx_restore    ; Treat null string
        cmp edi,10
        je secondary_comparison_engine
        cmp edi, temp            ; See if this doesn't work
        ;cmp eax, word_array
        jne remove_from_array
        cmp edi, temp            ; Check for similarity
        je array_storage
        inc edi
        inc [edi_dup]
        jmp comparison_engine
ebx_restore:
        dec ebx
        dec edi
        inc [ebx_dup]
        cmp ebx, 0
        je treat_string_num_start
        jmp ebx_restore
treat_string_num_start:
        cmp edi, 10
        je incer
        inc edi                             ; Makes new list without all the removed values
        mov [fresh_array], edi
        inc [fresh_array]
        cmp edi, 0                           ;MAKE CONDITION WORK!!!
        je set_fresh_array
        jmp treat_string_num_start
check_final_array:
        cmp edi, 1
        je lex_store_control                  ; Check for final array
        jmp comparison_engine
set_fresh_array:
        mov edi, fresh_array                  ; Replaces new list with edi
        jmp check_final_array
incer:
        inc edi
        jmp treat_string_num_start              ; Skips empty array point
        ;dec ebx
        ;mov timer, 0
        ;jmp treat_string_num

remove_from_array:
        mov edi, 10                            ; Sets empty array point keyword
        inc edi
        inc [edi_dup]; Sets index skip value
        jmp comparison_engine
secondary_comparison_engine:
        inc edi                      ;Skips empty index
        jmp comparison_engine
array_storage:
        inc ecx
        add [array], edi
        cmp ecx, 14
        je move_array_word
        inc [array]      ; Possible point of failure
        inc edi
        jmp comparison_engine
set_run:                                ; LIKELY IRRELEVANT!!!
        add [run], 1                    ; Sets run
        jmp move_array_word
move_array_word:
        cmp ecx, 0
        je comparison_engine
        shr [keyword_table],1        ; Resets tables.
        dec ecx
        dec [keyword_table]
        jmp move_array_word

lex_store_control:                  ; Don't delete
        add [lexeme_storage], "cf "   ;Implement Check lookup table for lexer return
                                      ; Add Check lookup opcodes
        jmp comparison_engine


error:
        ;mov ExitProcess,0


parser:
        cmp lexeme_storage, focus_setter_1  ; Go to lexer.asm to fix the code testing
        jne error
focus_settings:                            ; [<focus>]
        cmp lexeme_storage, focus_setter_1
        jne error
        cmp lexeme_storage, focus_setter_2