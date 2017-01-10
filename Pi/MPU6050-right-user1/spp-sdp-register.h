#ifndef SPP_SDP_REGISTER_H_
#define SPP_SDP_REGISTER_H_

typedef unsigned char uint8_t;

// 
// channel：SPP server 開啟的 Port Number
// 
// return: 0 表示成功；-1 表示有錯誤發生
//
int register_sdp(uint8_t channel);

#endif // SPP_SDP_REGISTER_H_