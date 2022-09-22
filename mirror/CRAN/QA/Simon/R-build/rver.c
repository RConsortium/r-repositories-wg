#include <stdio.h>
#include "rver.h"

int main(int ac, char **av) {
    puts(R_MAJOR "." R_MINOR " " R_STATUS "<br>(" R_YEAR "/" R_MONTH "/" R_DAY ", r" R_SVN_REVISION ")");
    return 0;
}
