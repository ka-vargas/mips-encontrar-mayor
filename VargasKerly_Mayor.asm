.data
    msg_cantidad: .asciiz "Ingrese cuántos números desea comparar (Min 3 - Max 5): "  # Pide al usuario que ingrese cuántos números quiere comparar, entre 3 y 5
    msg_ingreso: .asciiz "Ingrese un número: "  # Pide al usuario que ingrese un número
    msg_mayor: .asciiz "El número mayor es: "  # Mensaje para mostrar el número mayor encontrado
    msg_error: .asciiz "Error: Debe ingresar entre 3 y 5 números.\n"  # Mensaje de error si la cantidad no es válida

.text
main:
    # Primero, pedir la cantidad de números que se van a comparar
valida_cantidad:
    li $v0, 4  # Prepara la syscall para imprimir texto
    la $a0, msg_cantidad  # Carga la dirección del mensaje de entrada
    syscall  # Imprime el mensaje

    li $v0, 5  # Prepara la syscall para leer un número
    syscall  # Lee el número ingresado
    move $t1, $v0  # Guarda la cantidad en $t1

    # Comprobamos que la cantidad esté entre 3 y 5
    blt $t1, 3, error  # Si es menor que 3, saltamos a 'error'
    bgt $t1, 5, error  # Si es mayor que 5, saltamos a 'error'

    j iniciar_comparacion  # Si está bien, seguimos con la comparación

error:
    li $v0, 4  # Prepara la syscall para imprimir texto
    la $a0, msg_error  # Carga el mensaje de error
    syscall  # Muestra el mensaje de error
    j valida_cantidad  # Vuelve a pedir la cantidad de números

iniciar_comparacion:
    li $t0, -2147483648  # Inicializa el valor de $t0 con el número más pequeño posible

loop:
    li $v0, 4  # Prepara la syscall para imprimir texto
    la $a0, msg_ingreso  # Carga el mensaje pidiendo un número
    syscall  # Muestra el mensaje

    li $v0, 5  # Prepara la syscall para leer un número
    syscall  # Lee el número ingresado
    move $t2, $v0  # Guarda el número ingresado en $t2

    bgt $t2, $t0, update_max  # Si el número es mayor que el valor en $t0, actualizamos el máximo

    j continue  # Si no es mayor, continuamos con la siguiente iteración

update_max:
    move $t0, $t2  # Actualizamos el valor máximo con el número ingresado

continue:
    sub $t1, $t1, 1  # Restamos 1 a la cantidad de números restantes
    bnez $t1, loop  # Si aún hay números por ingresar, seguimos en el bucle

    # Ahora mostramos el número mayor que encontramos
    li $v0, 4  # Prepara la syscall para imprimir texto
    la $a0, msg_mayor  # Carga el mensaje de "El número mayor es:"
    syscall  # Muestra el mensaje

    li $v0, 1  # Prepara la syscall para imprimir un número
    move $a0, $t0  # Coloca el número mayor en $a0
    syscall  # Muestra el número mayor encontrado

exit:
    li $v0, 10  # Prepara la syscall para terminar el programa
    syscall  # Llama a la syscall para salir

