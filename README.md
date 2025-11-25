# Brainfuck

## Run the interpreter

You can run the interpreter this way,

```bash
zig build run -- example.b
```

or according to this.

```bash
zig build --release=fast
./zig-out/bin/brainfuck example.b
```

## Example

```bash
$ zig build run -- example/hello.b

Hello, World!
```
