#include <stdint.h>
#include <stdio.h>
#include <climits>
#include <stdlib.h>

#include "FuzzedDataProvider.h"
#include "treadnumber.h"

extern "C" int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size)
{
    FuzzedDataProvider provider(data, size);

    char* buf = (char*) malloc(sizeof(uint8_t) * 3);
    provider.ConsumeData(buf, sizeof(uint8_t) * 3);
    int cstylesuffixes = provider.ConsumeIntegralInRange(0, 1);
    ReadNumber result;
    treadnumber(buf, &result, cstylesuffixes);
    free(buf);

    return 0;
}