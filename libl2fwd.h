#ifndef __LIBL2FWD_H__
#define __LIBL2FWD_H__

#include <stdint.h>
#include <rte_ethdev.h>
#include <rte_ether.h>

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

// Statistics structure
typedef struct {
	uint64_t rx_packets;
	uint64_t tx_packets;
	uint64_t dropped_packets;
} libl2fwd_stats_t;

int libl2fwd_init(const libl2fwd_config_t* config, int argc, char** argv);
void libl2fwd_cleanup(void);
int libl2fwd_get_stats(uint16_t port_id, libl2fwd_stats_t* stats);
uint16_t libl2fwd_get_nb_ports(void);
uint16_t libl2fwd_get_port_ids(uint16_t* ports, uint16_t max_ports);
int libl2fwd_get_mac_addr(uint16_t port_id, struct rte_ether_addr* mac_addr);
int libl2fwd_start(void);
void libl2fwd_stop(void);

#ifdef __cplusplus
}
#endif

#endif /* __LIBL2FWD_H__ */
