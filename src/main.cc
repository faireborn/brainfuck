#include "brainfuck.h"
#include <fstream>
#include <iostream>
#include <sys/stat.h>
#include <unistd.h>

void usage() {
  std::cout << "Compile a string or file of Brainfuck code." << std::endl
            << std::endl;
  std::cout << "Usage: brainfuck -h | -e <string> | filename" << std::endl
            << std::endl;

  std::cout << "    <filename>   Compile and run a source file." << std::endl;
  std::cout << "    -e <string>  Directly evaluate a string as Brainfuck code."
            << std::endl;
  std::cout << "    -h           Print this usage." << std::endl << std::endl;
}

int main(int argc, char **argv) {
  std::ifstream file;
  int length;
  int opt;
  char *filename;
  char *buffer = nullptr;
  struct stat stats;

  opterr = 0;
  while ((opt = getopt(argc, argv, "he:")) != -1) {
    switch (opt) {
    case 'h':
      usage();
      exit(0);

    case 'e':
      buffer = (char *)optarg;
      break;

    case '?':
      if (optopt == 'e')
        fprintf(stderr, "Option '-%c' requires an argument.\n", optopt);
      else
        fprintf(stderr, "Unknown option '-%c'.\n", optopt);
      exit(1);

    default:
      exit(2);
    }
  }

  if (!buffer) {
    exit(2);
    // not run with -e, lets look for a file
    filename = (char *)argv[optind];

    if (stat(filename, &stats) == 0) {
      file.open(filename);
      file.seekg(0, std::ios::end);
      length = file.tellg();
      file.seekg(0, std::ios::beg);
      buffer = new char[length];
      file.read(buffer, length);
      file.close();
    } else {
      fprintf(stderr, "Cannot open file %s.\n", filename);
      exit(2);
    }
  }

  brainfuck::Brainfuck interpreter = brainfuck::Brainfuck(buffer);
  interpreter.evaluate();
  return 0;
}
