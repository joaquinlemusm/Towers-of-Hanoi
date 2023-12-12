  .globl __start
  
  .data
msg1: .asciiz "mueva el disco de la torre: "
msg2: .asciiz " hacia la torre: "
msg3: .asciiz "\n"

  .text

  __start:
  # llamando a hanoi(3, 1, 2, 3)
  # 3 discos, torre origen = 1, torre destino = 2, torre alterna = 3
  
  # Paso 1 (caller): preparar los argumentos en un lugar conocido
  li a0 3
  li a1 1
  li a2 2
  li a3 3
  
  # Paso 2 (caller pasa a callee): saltamos usando jal
  jal hanoi

# terminando el programa
li a0 10
ecall


hanoi:
  # Paso 3 (callee): prólogo, proteja los registros que considere necesarios
  addi sp sp -20
  sw s0 0(sp)
  sw s1 4(sp)
  sw s2 8(sp)
  sw s3 12(sp)
  sw ra 16(sp)
  
  mv s0 a0 ; numeroDeDiscos
  mv s1 a1 ; T_origen
  mv s2 a2 ; T_destino
  mv s3 a3 ; T_alterna
  
  li t1 1
  
  # Paso 4 (callee): cuerpo de la función
  test:
  beq a0 t1 BaseCase ; if numeroDeDiscos != 1
    # hanoi(numeroDeDiscos - 1, T_origen, T_alterna, T_destino);
    addi a0 s0 -1
    mv a1 s1
    mv a2 s3
    mv a3 s2
    jal hanoi
    
    # hanoi(1, T_origen, T_destino, T_alterna);
    li a0 1 ; set a0  1
    mv a1 s1 ; T_origen
    mv a2 s2 ; T_destino
    mv a3 s3 ; T_alterna
    jal hanoi
    
    # hanoi(numeroDeDiscos - 1, T_alterna, T_destino, T_origen);
    addi a0 s0 -1
    mv a1 s3 ; T_alterna
    mv a2 s2 ; T_destino
    mv a3 s1 ; T_origen
    jal hanoi
    j endIf
    
  BaseCase:
    mv a0 s1
    mv a1 s2
    jal hanoiPrint ; hanoiPrint(T_origen, T_destino)
  endIf:
    
  # Paso 5 (callee): epílogo, restauro lo que protegí; si voy a devolver algo, me aseguro de colocarlo en un lugar conocido
  lw s0 0(sp)
  lw s1 4(sp)
  lw s2 8(sp)
  lw s3 12(sp)
  lw ra 16(sp)
  addi sp sp 20
    
  # Paso 6 (callee regresa a caller): regresamos usando jr      
  jr ra


# recibe dos argumentos: origen y destino
  hanoiPrint:
addi sp sp -8
sw s0 0(sp)
sw s1 4(sp)
mv s0 a0
mv s1 a1
li a0 4
la a1 msg1
ecall
li a0 1
mv a1 s0
ecall
li a0 4
la a1 msg2
ecall
li a0 1
mv a1 s1
ecall
li a0 4
la a1 msg3
ecall
lw s0 0(sp)
lw s1 4(sp)
addi sp sp 8
jr ra
