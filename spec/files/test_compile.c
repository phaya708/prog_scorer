#include <stdio.h>

int main(void)
{
    scanf("%d", &n);
    for (int i = 1; i <= n; i++)
    {
        if (i % 3 == 0 || i % 10 == 3)
        {
            printf("%d\n",i);
        }
    }

    return 0;
}