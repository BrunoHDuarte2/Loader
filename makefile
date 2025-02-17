# Variáveis
CC = gcc
ASM = nasm
LD = ld

# Flags de compilação
CFLAGS = -m32    # Compilar para 32-bit
ASMFLAGS = -f elf32   # Geração de código ELF 32-bit

# Arquivos fontes
C_SRC = main.c
ASM_SRC = func.asm

# Arquivos objetos
C_OBJ = main.o
ASM_OBJ = func.o

# Executável final
EXEC = carregador

# Alvos
all: $(EXEC)

# Compilando o código C
$(C_OBJ): $(C_SRC)
	$(CC) $(CFLAGS) -c $(C_SRC) -o $(C_OBJ)

# Compilando o código Assembly
$(ASM_OBJ): $(ASM_SRC)
	$(ASM) $(ASMFLAGS) $(ASM_SRC) -o $(ASM_OBJ)

# Ligação dos objetos em um executável
$(EXEC): $(C_OBJ) $(ASM_OBJ)
	$(CC) $(CFLAGS) $(C_OBJ) $(ASM_OBJ) -o $(EXEC)

# Limpeza dos arquivos temporários
clean:
	rm -f $(C_OBJ) $(ASM_OBJ) $(EXEC)
