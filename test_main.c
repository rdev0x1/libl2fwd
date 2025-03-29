#include <stdio.h>
#include "libl2fwd.h"

int
main(int argc, char** argv)
{
	if (libl2fwd_init(argc, argv) != 0) {
		fprintf(stderr, "libl2fwd_init failed\n");
		return -1;
	}

	printf("Press Enter to start packet processing...\n");
	getchar();

	if (libl2fwd_start() != 0) {
		fprintf(stderr, "libl2fwd_start failed\n");
		libl2fwd_cleanup();
		return -1;
	}

	printf("Press Enter to stop packet processing...\n");
	getchar();

	libl2fwd_stop();
	libl2fwd_cleanup();
	return 0;
}
