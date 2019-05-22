#include "postgres.h"
#include "fmgr.h"

#ifdef PG_MODULE_MAGIC
PG_MODULE_MAGIC;
#endif

/**
 * Return the connection status.
**/
PG_FUNCTION_INFO_V1(nats_status);
extern Datum nats_status(PG_FUNCTION_ARGS);
Datum
nats_status(PG_FUNCTION_ARGS)
{
    printf("Hello, World!");
    return 0;
}

