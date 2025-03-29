#include <stdio.h>
#include "libl2fwd.h"

// Packet handler callback
static void
my_packet_handler(const uint8_t* packet, uint16_t len, uint16_t port_id, void* userdata)
{
	printf("Received packet of length %u on port %u\n", len, port_id);
}

int
main(int argc, char** argv)
{
	libl2fwd_config_t config = { .packet_handler = my_packet_handler,
				     .packet_handler_userdata = NULL,
				     .enabled_port_mask = 0x01, // adjust as needed
				     .promiscuous_mode = 1,
				     .mac_updating = 1 };

	if (libl2fwd_init(&config, argc, argv) != 0) {
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
