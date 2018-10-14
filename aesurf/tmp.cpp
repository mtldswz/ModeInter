
#include <cstdio>

int a[] = {153, 153, 225, 425, 425, 969, 513, 969, 425, 225, 425, 153, 153, 225, 225, 153, 153, 225, 513, 225, 2793};

int main()
{
    int len = 21;

    int ans = 0;
    for (int i = 0; i < len; i++)
    {
        ans += a[i];
    }

    printf("%d\n", ans);
}
