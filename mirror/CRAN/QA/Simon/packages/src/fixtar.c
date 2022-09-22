#include <stdio.h>
#include <unistd.h>

int main (int argc, char **argv) {
  if (argc<2 || !argv[1][0]) {
    printf("\n Usage: %s <tar-ball>\n\n Requires 1.fixr script\n\n", *argv);
    return 1;
  }
  setgid(80);
  setuid(0);
  return execl("/Builds/packages/1.fixr","1.fixr",argv[1],0);
}
