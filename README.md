# arm-32bit-assembler

This repository contains small programs I wrote to get familiar with ARM 32-bit assembly.

Code was made following the [ARM Assembly By Example](https://armasm.com/); it was primarily used for its exercises and reference correction (in last resort), but the
explanations, although high-level, were very valuable to understand what I was doing.

See [Resources](#resources) for a full list of the resources I used to learn about ARM 32-bit assembly.

## Requirements

To be able to assemble, link and run the code, one should have a 32-bit or 64-bit ARM processor and a machine with 
the binutils toolchain for target arm-linux-gnueabihf.

## Compile

A single `build.sh` file is provided to compile every program listed in `src`. Running `./build.sh -h` will yield :

```text
Usage: ./build.sh -p <program-number> [-d] [-h]
   -p <program-number>  Program number to build (mandatory)
   -d                   Enable debug symbols for the assembler
   -h                   Show this help message
```

I am currently switching to a build system relying on `make` and `Makefile`s which is a lot more powerful and fun to learn.

## Resources

* [ARM Assembly By Example](https://armasm.com/)
* [Compiling to assembly from scratch - Chapter 7](https://keleshev.com/compiling-to-assembly-from-scratch/07-arm-assembly-programming)
* [ARM documentation](https://developer.arm.com/documentation/ddi0406/cb/Application-Level-Architecture/Instruction-Details/Alphabetical-list-of-instructions)
* [Procedure Call Standard for Arm Architecture - AAPCS](https://github.com/ARM-software/abi-aa/blob/main/aapcs32/aapcs32.rst#the-base-procedure-call-standard)

## License

See `LICENSE`.
