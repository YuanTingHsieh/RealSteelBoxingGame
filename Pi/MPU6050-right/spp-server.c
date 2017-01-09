/*******************************************************************************
 * spp-server.c
 *  SPP server
 * 
 * Compile: sudo gcc spp-server.c spp-sdp-register.o -lbluetooth -o spp-server
 * 
 * Description:
 *  依照 SPP_SPEC_V1.2 的 SDP Interoperability requirements 完成 Serial Port 
 *  Profile 的 SDP 登錄，並等待與遠端 Client 的連線。步驟如下：
 * 
 *  1.) 設定裝置的 UUID, CoD ( Set the class ) 
 *  2.) 將裝置提供的服務註冊到( Register with the SDP Server )
 *  3.) 等待客戶端的連接 ( Listen for RFCOMM connections )
 *  4.) 來自客戶的的資料處理 ( Process data from the connections ) * 
 * 
 * How to test:
 *   Raspberry Pi + USB Bluetooth Dongle ( Slave ) <--> Android phone ( Server )
 *  1. 樹莓派先與手機配對成功 ( 使用 VNC 開啟 Bluetooth Manager 配對 )
 *      KEY: 1234
 *  2. 先執行 sudo ./spp-server
 *  3. 開啟手機 APP ( 藍牙串口助手或是 BTSCmode @ client mode )
 *  4. 點擊樹莓派上面的藍牙進行連接
 *      連接成功後就可以輸入字串傳輸
 *  
 * Result: OK !!!
 * 
 * 兩個手機 APP (藍牙串口助手) 都可以接收與傳送字串到樹莓派。
 * 手機成功傳送字串之後，樹莓派會回傳 ATOK 字串。
 *
 * ****************************************************************************/
#include <stdio.h>
#include <errno.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/socket.h>
#include <bluetooth/sdp.h>
#include <bluetooth/rfcomm.h>
#include <bluetooth/sdp_lib.h>
#include <bluetooth/bluetooth.h>
#include "spp-sdp-register.h"

/***********************************************************************/

int set_class(unsigned int cls, int timeout)
{
    int id;
    int fh;
    bdaddr_t btaddr;
    char pszaddr[18];

	// 取得裝置 ID
	// 使用 NULL 作為參數，函式成功回傳的
	// 所取得的 ID，就是第一個藍牙裝置 ID 
	if ((id = hci_get_route(NULL)) < 0)
		return -1;

	// 轉換藍牙裝置 ID 為 6-byte 藍牙位址
	if (hci_devba(id, &btaddr) < 0)
		return -1;

	// 轉換 6-byte 藍牙位址為一般以 '\0' 作結尾的字串
	if (ba2str(&btaddr, pszaddr) < 0)
		return -1;

	// 取得 HCI 的 file handle
	if ((fh = hci_open_dev(id)) < 0)
		return -1;

	// 設定藍牙裝置的 Class ( CoD )
	if (hci_write_class_of_dev(fh, cls, timeout) != 0)
	{
		perror("hci_write_class ");
		return -1;
	}

	// 關閉 file handle
	hci_close_dev(fh);

	printf("set device %s to class: 0x%06x\n", pszaddr, cls);

	return 0;
}

/***********************************************************************/

int rfcomm_listen(uint8_t channel)
{
	int sock;						// socket descriptor for local listener
	int client;						// socket descriptor for remote client
	unsigned int len = sizeof(struct sockaddr_rc);

	struct sockaddr_rc remote;		// local rfcomm socket address
	struct sockaddr_rc local;		// remote rfcomm socket address
	char pszremote[18];

	// 藍牙 socket 初始化
	sock = socket(AF_BLUETOOTH, SOCK_STREAM, BTPROTO_RFCOMM);

	local.rc_family = AF_BLUETOOTH;

	// 如果使用 Bluetooth USB Dongle 的位址已知，可直接在 rd_bdaddr 輸入位址
	// 不然就輸入 *BDADDR_ANY ( 由系統自己選擇 )
	local.rc_bdaddr = *BDADDR_ANY;
	local.rc_channel = channel;

	// 綁定 socket 到藍牙裝置 ( 這裡指的是 Bluetooth USB Dongle )
	if (bind(sock, (struct sockaddr *)&local, sizeof(struct sockaddr_rc)) < 0)
		return -1;

	// 設定 listen 序列的長度 ( 通常設為 1 就可以了 )
	if (listen(sock, 1) < 0)
		return -1;

	printf("accepting connections on channel: %d\n", channel);

	// 接受接入的連線；此連線是一個阻絕式呼叫 ( a blocking call )
	client = accept(sock, (struct sockaddr *)&remote, &len);

	ba2str(&remote.rc_bdaddr, pszremote);

	printf("received connection from: %s\n", pszremote);

	// 關掉阻絕式呼叫
	if (fcntl(client, F_SETFL, O_NONBLOCK) < 0)
		return -1;

	// 返回 client 端的 sccket descriptor
	return client;
}

/***********************************************************************/

int handle_connection(int rfcommsock, int scosock)
{
    char hello_str[] = "SPP Server: Hello, Client !!";
	char rfcommbuffer[255];
	int len;
    
    // Server 端傳送 hello 字串到 Client 端
    len = send(rfcommsock, hello_str, sizeof(hello_str), 0);
    if( len < 0 )
    {
        perror("rfcomm send ");
        return -1;
    }
    
    
	while (1)
	{
		// 從 RFCOMM socket 讀取資料
		// 此 socket 已經關掉阻絕式呼叫，所以即使沒有可用數據也不會被阻絕
		len = recv(rfcommsock, rfcommbuffer, 255, 0);

		// EWOULDBLOCK indicates the socket would block if we had a
		// blocking socket.  we'll safely continue if we receive that
		// error.  treat all other errors as fatal
		if (len < 0 && errno != EWOULDBLOCK)
		{
			perror("rfcomm recv ");
			break;
		}
		else if (len > 0)
		{
			// 將接收到的文字訊息最後面加上 '\0' 結束字元
			// 並將其列印到螢幕上，並回傳 ATOK 給 Client 端
			rfcommbuffer[len] = '\0';

			printf("rfcomm received: %s\n", rfcommbuffer);
			send(rfcommsock, "ATOK\r\n", 6, 0);
		}

	}

	close(rfcommsock);

	printf("client disconnected\n");

	return 0;
}

/***********************************************************************/

unsigned int cls = 0x1f00;  // Serial Port Profile
int timeout = 1000;
uint8_t channel = 10;       // 開啟的 SPP Server 通道號碼

int main()
{
	int rfcommsock;
	int scosock;

	if (set_class(cls, timeout) < 0)
	{
		perror("set_class ");
	}

	if (register_sdp(channel) < 0)
	{
		perror("register_sdp ");
		return -1;
	}

	if ((rfcommsock = rfcomm_listen(channel)) < 0)
	{
		perror("rfcomm_listen ");
		return -1;
	}

 	handle_connection(rfcommsock, scosock);

	return 0;
}
