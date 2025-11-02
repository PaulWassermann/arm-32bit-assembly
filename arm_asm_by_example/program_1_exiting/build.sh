mkdir -p obj bin
arm-linux-gnueabihf-as -o obj/main.o main.s

if [ $? -eq 0 ]; then
    arm-linux-gnueabihf-ld -o bin/main obj/main.o
fi
