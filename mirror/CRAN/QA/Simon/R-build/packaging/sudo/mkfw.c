#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

#ifndef BASE
#error "BASE must be defined to the base path for security reasons"
#endif

int main(int ac, char **av) {
  char buf[512], *rr = getenv("RRPATH");
  buf[511]=0;

  if (!getenv("FWPATH") || !rr || strncmp(rr, BASE, strlen(BASE))) {
    fprintf(stderr, "Invalid environment.\n");
    exit(1);
  }
  setgid(80);
  setuid(0);
  snprintf(buf, 511, "tar fc - \"%s\"|tar fx - -C  \"%s/R-fw/cont\"; chmod 41775 \"%s/R-fw/cont/Library\"",
	   getenv("FWPATH"), rr, rr);
  return execlp("/bin/sh","sh","-c",buf,0);
}
