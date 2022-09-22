#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/types.h>

/* sched <directory> <action> */

#define maxs 16

struct sync_s {
  pid_t pid;
};

struct syncf_s {
  int maxjobs;
  struct sync_s job[maxs];
} s;

static int launch(const char *cmd) {
  fprintf(stderr, "launching: %s\n", cmd);
  return execl("/bin/sh","/bin/sh","-c",cmd,0);
}

int main(int ac, char **av) {
  const char *sfn, *cmd;
  int trying = 1, is_add = 0, is_close = 0, is_flush = 0;
  if (ac<3) {
    printf("\n Usage: %s <sync-file> <action>\n\n Actions: create <num jobs>\n          add <command>\n          check\n          close\n\n", *av);
    return 0;
  }
  sfn = av[1];
  cmd = av[2];
  if (strcmp(cmd, "create") && strcmp(cmd, "close") && strcmp(cmd, "add") && strcmp(cmd, "flush") && strcmp(cmd, "check")) {
    fprintf(stderr,"ERROR: invalid command\n");
    return 1;
  }
 
  while (trying) {
    int fd = open(sfn, O_RDWR|O_CREAT|O_EXLOCK, 0660);
    if (fd == -1) {
      fprintf(stderr, "ERROR: unable to access sync file\n");
      return 2;
    }
    
    if(!strcmp(cmd, "create")) {
      int pj = 4;
      if (ac>3) pj = atoi(av[3]);
      if (pj<1) pj = 4;
      s.maxjobs = pj;
      if (write(fd, &s, sizeof(s)) != sizeof(s)) {
	fprintf(stderr,"ERROR: unable to write sync file\n");
	close(fd);
	return 3;
      }
      close(fd);
      return 0;
    }
    is_add = !strcmp(cmd, "add");
    is_close = !strcmp(cmd, "close");
    is_flush = !strcmp(cmd, "flush");
    if (is_add && ac<4) {
      fprintf(stderr,"ERROR: no command to add, ignoring.\n");
      close(fd);
      return 0;
    }
    if (read(fd, &s, sizeof(s))<4 || s.maxjobs < 1) {
      fprintf(stderr, "ERROR: invalid sync file contents\n");
      close(fd);
      return 4;
    }
    {
      int i = 0, n = 0, modified = 0;
      while (i < s.maxjobs) {
	pid_t p = s.job[i].pid;
	if (p) {
	  if (kill(p, 0) == -1) {
	    p = s.job[i].pid = 0;
	    modified = 1;
	  }
	}
	if (is_add && p == 0) {
	  pid_t cp = fork();
	  if (cp == 0) {
	    close(fd);
	    return launch(av[3]);
	  }
	  s.job[i].pid = cp;
	  lseek(fd, SEEK_SET, 0);
	  if (write(fd, &s, sizeof(s))<sizeof(s)) {
	    fprintf(stderr, "ERROR: unable to write sync file\n");
	    return 5;
	  }
	  close(fd);
	  return 0;
	}
	if (p) n++;
	i++;
      }
      if (modified) {
	lseek(fd, SEEK_SET, 0);
	if (write(fd, &s, sizeof(s))<sizeof(s)) {
	  fprintf(stderr, "ERROR: unable to write sync file\n");
	  return 5;
	}
      }
      close(fd);
      if (is_add || ((is_flush || is_close) && n > 0))
	sleep(1);
      else {
	if (is_close) unlink(sfn);
	return n;
      }
    }
  }
  return 0;
}
