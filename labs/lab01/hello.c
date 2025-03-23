#include <stdio.h>

void welcome(){
    printf("Welcome to gdb!");
    return ;
}

int main(int argc, char *argv[]) {
    int i;
    int count = 0;
    int *p = &count;

    for (i = 0; i < 10; i++) {
        (*p)++; // Do you understand this line of code and all the other permutations of the operators? ;)
    }
    
    welcome();

    printf("Thanks for waddling through this program. Have a nice day.");
    return 0;
}
