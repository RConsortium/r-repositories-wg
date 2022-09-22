#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

#ifndef BASE
#error "BASE must be defined to the base path for security reasons"
#endif

/* RRPATH must be ${BASE}/<dir> where <dir> must not contain any '/' 
   and cannot start with '.' */

int main(int ac, char **av) {
  char *c = getenv("RRPATH"), *d;
  int l = strlen(BASE);
  d=c+l;
  if (!c || strncmp(c,BASE,l) || d[0]!='/' || d[1]=='/' || !d[1] || d[1]=='.') {
    fprintf(stderr, "Invalid environment.\n");
    exit(1);
  }
  d++;
  while (*d) { if (*d=='/') {
    fprintf(stderr, "Invalid environment.\n");
    exit(1);
  }; d++;  }
  
  setgid(80);
  setuid(0);
  return execlp("/bin/rm","rm","-rf",c,0);
}
