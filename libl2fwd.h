#ifndef __LIBL2FWD_H__
#define __LIBL2FWD_H__

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

// Callback invoked per received packet
typedef void (*libl2fwd_packet_handler_t)(const uint8_t* packet, uint16_t len, uint16_t port_id,
					  void* userdata);

// Initialization configuration struct
typedef struct {
	libl2fwd_packet_handler_t packet_handler;
	void* packet_handler_userdata;
	uint32_t enabled_port_mask;
	int promiscuous_mode;
	int mac_updating;
} libl2fwd_config_t;

int libl2fwd_init(const libl2fwd_config_t* config, int argc, char** argv);
void libl2fwd_cleanup(void);
int libl2fwd_start(void);
void libl2fwd_stop(void);

#ifdef __cplusplus
}
#endif

#endif /* __LIBL2FWD_H__ */
