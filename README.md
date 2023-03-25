# ci_compilers
Images with compilers and build tools, used for CI by other projects

Each gcc image contains gcc/g++ and corresponding libstdc++.

Each clang image contains clang/clang++ and libc++,libstdc++ with the same version.

All images contain:
* cmake-2.25.2
* ninja
* kcov-v41
* catch2-2.13.10 
* catch2-3.3.2
* fmt-8.1.1
* fmt-9.1.0
* benchmark-v1.7.1

The installed libraries, Catch2-2, Catch2-3, fmt-8 and fmt-9 are located under
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
