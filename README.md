# Brainfuck

## Build

```bash
git clone https://github.com/faireborn/brainfuck.git
cd brainfuck
mkdir build
cd build
cmake ..
make -j $(nproc)
```

## Usage

```bash
./bf -e ">++++++++[<+++++++++>-]<.>>+>+>++>[-]+<[>[->+<<++++>]<<]>.+++++++..+++.>>+++++++.<<<[[-]<[-]>]<+++++++++++++++.>>.+++.------.--------.>>+.>++++."

Hello World!
```
