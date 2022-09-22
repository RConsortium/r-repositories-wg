#include <stdlib.h>
#include <sys/stat.h>
#include <stdio.h>
#include <dirent.h>
#include <errno.h>
#include <string.h>

#define XP 2048

static char path[XP];
static unsigned int pt = 0, inner_dir = 0;
static FILE *fout;

void dump(const char *name) {
	unsigned int np = pt, nl = strlen(name);
	struct stat st;

	if (!*path) { /* no path specified - use name and split it to path and name */
		char *c = path, *ls = 0;
		if (nl > XP - 256) {
			fprintf(stderr, "ERROR: %s - path is too long\n", path);
			exit(1);
		}
		strcpy(path, name);
		while (*c) { if (*c == '/') ls = c; c++; }
		if (!ls) {
			fprintf(stderr, "ERROR: %s - the path must be absolute\n", name);
			exit(1);
		}
		pt = np = ls - path;
		name += np + 1;
		nl -= np + 1;
	}

	if (nl > 254) {
		fprintf(stderr, "ERROR: %s/%s - name too long\n", path, name);
		return;
	}
	
	path[np] = '/';
	memcpy(path + np + 1, name, nl + 1);
	pt += nl + 1;

	if (pt > XP - 256)
		fprintf(stderr, "ERROR: %s/%s - path is too long\n", path, name);
	else {
		if (lstat(path, &st))
			fprintf(stderr, "ERROR: %s - cannot stat (%s)\n", path, strerror(errno));
		else {
			mode_t m = st.st_mode;
			if (m & S_IFDIR) {
				DIR *d;
				if (inner_dir)
					fprintf(fout, "<f n=\"%s\" o=\"root\" g=\"admin\" p=\"%u\">", name, (unsigned int) m);
				else {
					path[np] = 0;
					fprintf(fout, "<f n=\"%s\" o=\"root\" g=\"admin\" p=\"%u\" pt=\"%s/%s\" m=\"false\" t=\"file\">", name, (unsigned int) m, path, name);
					path[np] = '/';
					inner_dir = 1;
				}
				d = opendir(path);
				if (!d)
					fprintf(stderr, "ERROR: %s - cannot access directory\n", path);
				else {
					struct dirent *de;
					while ((de = readdir(d))) {
						const char *dn = de->d_name;
						if (dn[0] == '.' && ((dn[1] == '.' && dn[2] == 0) || dn[1] == 0)) /* skip .. and . */
							continue;
						dump(dn);
					}
					closedir(d);
				}
				fprintf(fout, "</f>");
			} else
				fprintf(fout, "<f n=\"%s\" o=\"root\" g=\"admin\" p=\"%u\"/>", name, (unsigned int) m);
		}
	}

	path[pt = np] = 0;
}

int main(int ac, char **av) {
	if (ac < 2) {
		fprintf(stderr, "Missing path.\n\n Usage: %s <path>\n\n", av[0]);
		return 1;
	}
	fout = stdout;
	fprintf(fout, "<pkg-contents spec=\"1.12\">");
	dump(av[1]);
	fprintf(fout, "</pkg-contents>");
	return 0;
}
