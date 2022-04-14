run: main.out
	./main.out

main.out: main.o
	ld main.o -o main.out

main.o: main.asm
	nasm -f elf64 main.asm -Iansi -Iio -Iutil -Iarch -o main.o

clean:
	rm *.out

