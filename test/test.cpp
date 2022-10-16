#include <iostream>
int main(int argc, char *argv[])
{
  auto p = (int*)(void*)argv[0];
  std::cout << "hullo " << *p << "\n";
}
