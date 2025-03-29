#ifndef __LIBL2FWD_H__
#define __LIBL2FWD_H__

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

int libl2fwd_init(int argc, char** argv);
void libl2fwd_cleanup(void);
int libl2fwd_start(void);
void libl2fwd_stop(void);

#ifdef __cplusplus
}
#endif

#endif /* __LIBL2FWD_H__ */
