cmake_minimum_required(VERSION 3.14)
project(brainfuck VERSION 1.0 LANGUAGES C CXX)

add_executable(bf)
target_compile_features(bf PRIVATE cxx_std_20)

target_sources(bf PRIVATE
  src/main.cc
  src/brainfuck.cc
)
