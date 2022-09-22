#include <pthread.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <stdio.h>
#include <string.h>

FILE *lf;

int last_type = 0;

const char *prefix[3] = { "", "#@1@#", "#@2@#" };
const char *suffix[3] = { "", "@#1#@", "@#2#@" };

int closing=0;
int done=0;

struct tis {
  int fd;
  int id;
};

pthread_mutex_t write_mutex = PTHREAD_MUTEX_INITIALIZER;

void *wt(void *arg) {
  struct tis *a = (struct tis*) arg;
  int fd = a->fd;
  int id = a->id;
  char buf[1024];
  buf[1023]=0;

  while (1) {
    struct timeval timv;
    fd_set readfds;
    timv.tv_sec=0;
    timv.tv_usec=200000;
    FD_ZERO(&readfds);
    FD_SET(fd,&readfds);
    select(fd+1,&readfds,0,0,&timv);
    if (FD_ISSET(fd,&readfds)) {
      int n = read(fd, buf, 1023);
      if (n<1) break;
      buf[n]=0;
      {
	char *c = buf;
	while (*c) {
	  int hascr = 0;
	  char *d = c;
	  while (*c && *c!='\r' && *c!='\n') c++;
	  if (*c) hascr=1;
	  *c=0;
	  if (lf) {
	    pthread_mutex_lock(&write_mutex);
	    if (last_type != id) {
	      fprintf(lf, "%s%s", suffix[last_type], prefix[id]);
	      last_type = id;
	    }
	    fprintf(lf, "%s%s", d, hascr?"\n":"");
	    pthread_mutex_unlock(&write_mutex);
	  }
	  if (hascr) c++;
	}
      }
    } else if (closing) break;
  }
  done|=id;
}

static void millisleep(unsigned long tout) {
  struct timeval tv;
  tv.tv_usec = (tout%1000)*1000;
  tv.tv_sec  = tout/1000;
  select(0, 0, 0, 0, &tv);
}

int main(int ac, char **av) {
  int px[2], py[2];
  pthread_attr_t ta;
  pthread_t pt;

  struct tis tx={0,1}, ty={0,2};
  int rv, cwait=0;

  if (ac<3) {
    fprintf(stderr, "\n Usage: consh <command> <logfile> [-a]\n\n");
    return 1;
  }

  lf = fopen(av[2], (ac>3 && !strcmp(av[3],"-a"))?"a":"w");
  if (!lf)
    fprintf(stderr, "*** ERROR: consh unable to create %s, all output will be lost\n", av[2]); 

  pipe(px);
  pipe(py);
  dup2(px[1], STDOUT_FILENO); tx.fd=px[0];
  dup2(py[1], STDERR_FILENO); ty.fd=py[0];
  
  pthread_attr_init(&ta);
  pthread_attr_setdetachstate(&ta, PTHREAD_CREATE_DETACHED);
  pthread_create(&pt, &ta, wt, &tx);
  pthread_create(&pt, &ta, wt, &ty);
  rv=system(av[1]);
  closing=1;
  fflush(stderr);
  fflush(stdout);
  fclose(stderr);
  fclose(stdout);
  while (done!=3 && cwait<50) { /* don't wait more than 5s for flush */
    millisleep(100);
    cwait++;
  }
  if (lf) {
    if (last_type) fprintf(lf, "%s\n", suffix[last_type]);
    fflush(lf);
    fprintf(lf, "[[system return code 0x%x]]\n", rv);
    fclose(lf);
  }
  if (rv != 0) {
    if (rv>0 && rv!=127)
      rv=WEXITSTATUS(rv);
    else
      rv=127;
  }
  return rv;
}
