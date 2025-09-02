#pragma once

namespace brainfuck {
class Brainfuck {
public:
  char *data;
  char *d;
  const char *p;

  Brainfuck(const char prog[]);
  ~Brainfuck();

  void pincr(void);
  void pdecr(void);
  void bincr(void);
  void bdecr(void);
  void puts(void);
  void gets(void);
  void bropen(void);
  void brclose(void);
  void evaluate(void);
};
} // namespace brainfuck
