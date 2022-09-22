#include <unistd.h>

int main(int argc, char **argv) {
  setuid(0);
  system("/usr/sbin/chown -R root:admin /Library/Frameworks/R.framework");
  system("/bin/chmod -R g+w /Library/Frameworks/R.framework");
  return 0;
}
