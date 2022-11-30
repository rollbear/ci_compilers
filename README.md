# ci_compilers
Images with compilers and build tools, used for CI by other projects

Each gcc image contains gcc/g++ and corresponding libstdc++.

Each clang image contains clang/clang++ and libc++,libstdc++ with the same version.

All images contain:
* cmake-2.25.0
* ninja
* kcov-v40
* catch2-2.13.10 
* catch2-3.2.0
* fmt-8.1.1
* fmt-9.1.0

Catch2 is prebuilt, including a catch2 v2.x and the libraries are installed in separate directories depending on C++ standard and stdlib used.

*Catch2 v2.x*

| directory prefix                           | content                   |
|--------------------------------------------|---------------------------|
|/usr/local/catch2-2-c++{11,14,17,20}{libc++}| /include/catch2/catch.hpp |
|                                            | /lib/libCatch2Main.a      |

*Catch2 v3.x*

| directory prefix                          | content              |
|-------------------------------------------|----------------------|
| /usr/local/catch2-3-c++{14,17,20}{libc++} | /include/catch2/*    |
|                                           | /lib/libCatch2.a     |
|                                           | /lib/libCatch2Main.a |

*fmt-8.x*

| directory | content |
|-----------|---------|
| /usr/local/fmt-8-c++{11,14,17,20}{libc++} | /include/fmt/* |
|                                           | /lib/libfmt.a  |

*fmt-9.x*

| directory                                 | content        |
|-------------------------------------------|----------------|
| /usr/local/fmt-9-c++{11,14,17,20}{libc++} | /include/fmt/* |
|                                           | /lib/libfmt.a  |

Feel free to use for your builds if you wish. However, be warned that they will
be updated at any time without warning.
  