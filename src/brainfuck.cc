#include "brainfuck.h"
#include <iostream>

namespace brainfuck {

Brainfuck::Brainfuck(const char prog[]) {
  data = new char[3000];
  d = data;
  p = prog;
}

Brainfuck::~Brainfuck() { delete[] data; }

void Brainfuck::pincr(void) { d++; }
void Brainfuck::pdecr(void) { d--; }
void Brainfuck::bincr(void) { (*d)++; }
void Brainfuck::bdecr(void) { (*d)--; }
void Brainfuck::puts(void) { std::cout << *d; }
void Brainfuck::gets(void) { std::cin >> *d; }
void Brainfuck::bropen(void) {
  int bal = 1;
  if (*d == '\0') {
    do {
      p++;
      if (*p == '[')
        bal++;
      else if (*p == ']')
        bal--;
    } while (bal != 0);
  }
}
void Brainfuck::brclose(void) {
  int bal = 0;
  do {
    if (*p == '[')
      bal++;
    else if (*p == ']')
      bal--;
    p--;
  } while (bal != 0);
}
void Brainfuck::evaluate(void) {
  while (*p) {
    switch (*p) {
    case '>':
      pincr();
      break;
    case '<':
      pdecr();
      break;
    case '+':
      bincr();
      break;
    case '-':
      bdecr();
      break;
    case '.':
      puts();
      break;
    case ',':
      gets();
      break;
    case '[':
      bropen();
      break;
    case ']':
      brclose();
      break;
    }
    p++;
  }
}
} // namespace brainfuck
