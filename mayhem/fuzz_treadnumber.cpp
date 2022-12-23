#include <stdint.h>
#include <stdio.h>
#include <climits>
#include <stdlib.h>
#include <cstring>

#include "treadnumber.h"

extern "C" int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size)
{

    if (size < sizeof(uint8_t) * 3) {
        return 0;
    }
    char* buf = (char*) malloc(sizeof(uint8_t) * 3);
    memcpy(buf, data, sizeof(uint8_t) * 3);
    int cstylesuffixes = 0;
    ReadNumber result;
    treadnumber(buf, &result, cstylesuffixes);
    free(buf);

    return 0;
}