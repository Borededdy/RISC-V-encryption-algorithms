.data

    myplaintext: .string "AMO ASSEMBLY"
    mychypher: .string "E"
    
    newline: .string "\n"

.text
    
    la s0, mychypher        # puntatore al primo carattere di mycypher
    
cipher_loop:
    lbu s1, 0(s0)           # carico il carattere corrente di mycypher
    beqz s1, end_program

    li t0, 65               # 'A'
    beq s1, t0, call_substitution

    li t0, 66               # 'B'
    beq s1, t0, call_blocks

    li t0, 67               # 'C'
    beq s1, t0, call_occurrences

    li t0, 68               # 'D'
    beq s1, t0, call_dictionary

    li t0, 69               # 'E'
    beq s1, t0, call_inversion

    j next_char

call_substitution:
    la a0, myplaintext
    jal ra, substitution_c
    j print_result

call_blocks:
    la a0, myplaintext
    jal ra, blocks_c
    j print_result

call_occurrences:
    la a0, myplaintext
    jal ra, occurrences_c
    j print_result

call_dictionary:
    la a0, myplaintext
    jal ra, dictionary_c
    j print_result

call_inversion:
    la a0, myplaintext
    jal ra, inversion
    j print_result

print_result:
    li a7, 4
    la a0, myplaintext
    ecall

    li a7, 4
    la a0, newline
    ecall

next_char:
    addi s0, s0, 1         # avanza in mychypher
    j cipher_loop

end_program:
    li a7, 10
    ecall
    
inversion:
    addi sp, sp -4
    sw ra, 0(sp)

    # a0 contiene l'indirizzo base della stringa
    mv t0, a0               # t0 puntatore primo carattere
    mv t1, a0               # t1 puntatore ultimo carattere
    
find_end:
    lbu t2, 0(t1)           # legge il carattere da t1
    beqz t2, found          # se trova '\0' abbiamo trovato la fine
    addi t1, t1, 1          # altrimenti avanza
    j find_end

found:
    addi t1, t1, -1         # torniamo indietro di 1 byte in modo da puntare all'ultimo carattere valido

reverse_loop:
    bge t0, t1, end_inversion   # se inizio >= fine, inversione completata

    # scambio caratteri
    lbu t2, 0(t0)
    lbu t3, 0(t1)

    sb t3, 0(t0)
    sb t2, 0(t1)

    addi t0, t0, 1          # incrementiamo il puntatore di inizio
    addi t1, t1, -1         # decrementiamo il puntatore di fine
    j reverse_loop

end_inversion:
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

substitution_c:
    ret
blocks_c:
    ret
occurrences_c:
    ret
dictionary_c:
    ret