# ci_compilers
Images with compilers and build tools, used for CI by other projects

Each gcc image contains gcc/g++ and corresponding libstdc++.

Each clang image contains clang/clang++ and libc++,libstdc++ with the same version.

All images contain:
* cmake-3.30.0
* ninja
* valgrind
* kcov-v42 for compilers supporting C++17, kcov-v41 otherwise
* catch2-2.13.10 
* catch2-3.7.0
* fmt-8.1.1
* fmt-9.1.0
* fmt-10.2.1
* fmt-11.0.2
* benchmark-v1.8.5

The installed libraries are located under
`/usr/local/lib/c++{11,14,17,20,23}{libc++}` and they all have `CMake` packages,
so for example, to build with C++17 and libc++, run `cmake` for your program
with:
```l
-D CMAKE_PREFIX_PATH=/usr/local/lib/c++17libc++ \
-D CMAKE_CXX_STANDARD=17
```

If your `CMakeLists.txt` then calls, for example `find_package(fmt 9)`,
it will find the C++17 version of `fmt-9` compiled with `libc++`.

Feel free to use for your builds if you wish. However, be warned that they will
be updated at any time without warning. You are probably better off using this
as a starting point when creating your own version that you have control over.
