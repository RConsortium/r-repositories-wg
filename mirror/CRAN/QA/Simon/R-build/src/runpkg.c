#include <unistd.h>

int main (int argc, char **argv) {
  char *arg = 0;
  setuid(0);
  setgid(80);
  if (argc > 1) arg = argv[1];
  return execl("/Builds/nightly/pkg", "pkg", arg, 0);
}
