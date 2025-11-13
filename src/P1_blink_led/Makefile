all: clean main.elf

OBJS = main.o

%.o: %.s
	arm-none-eabi-as -g -o $@ $<

main.elf: $(OBJS)
	arm-none-eabi-ld -Ttext=0x08000000 -o $@ $^

.PHONY: clean
clean:
	rm main.elf *.o