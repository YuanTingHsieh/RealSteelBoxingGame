// User1 Right 

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdint.h>
#include <string.h>
#include <math.h>
#include "I2Cdev.h"
#include "MPU6050_6Axis_MotionApps20.h"

// CSWu+ Socket Communication for pi and host
//#include<sys/socket.h> 
#include<arpa/inet.h>

// CSWu+ Bluetooth Communication 
#include <errno.h>
#include <fcntl.h>
#include <sys/socket.h>
#include <bluetooth/sdp.h>
#include <bluetooth/rfcomm.h>
#include <bluetooth/sdp_lib.h>
#include <bluetooth/bluetooth.h>
#include <bluetooth/hci.h>
#include <bluetooth/hci_lib.h>
extern "C" {
#include "spp-sdp-register.h"
}

// class default I2C address is 0x68
// specific I2C addresses may be passed as a parameter here
// AD0 low = 0x68 (default for SparkFun breakout and InvenSense evaluation board)
// AD0 high = 0x69
MPU6050 mpu;

// uncomment "OUTPUT_READABLE_QUATERNION" if you want to see the actual
// quaternion components in a [w, x, y, z] format (not best for parsing
// on a remote host such as Processing or something though)
//#define OUTPUT_READABLE_QUATERNION

// uncomment "OUTPUT_READABLE_EULER" if you want to see Euler angles
// (in degrees) calculated from the quaternions coming from the FIFO.
// Note that Euler angles suffer from gimbal lock (for more info, see
// http://en.wikipedia.org/wiki/Gimbal_lock)
// #define OUTPUT_READABLE_EULER

// uncomment "OUTPUT_READABLE_YAWPITCHROLL" if you want to see the yaw/
// pitch/roll angles (in degrees) calculated from the quaternions coming
// from the FIFO. Note this also requires gravity vector calculations.
// Also note that yaw/pitch/roll angles suffer from gimbal lock (for
// more info, see: http://en.wikipedia.org/wiki/Gimbal_lock)
#define OUTPUT_READABLE_YAWPITCHROLL

// uncomment "OUTPUT_READABLE_REALACCEL" if you want to see acceleration
// components with gravity removed. This acceleration reference frame is
// not compensated for orientation, so +X is always +X according to the
// sensor, just without the effects of gravity. If you want acceleration
// compensated for orientation, us OUTPUT_READABLE_WORLDACCEL instead.
#define OUTPUT_READABLE_REALACCEL

// uncomment "OUTPUT_READABLE_WORLDACCEL" if you want to see acceleration
// components with gravity removed and adjusted for the world frame of
// reference (yaw is relative to initial orientation, since no magnetometer
// is present in this case). Could be quite handy in some cases.
//#define OUTPUT_READABLE_WORLDACCEL

// uncomment "OUTPUT_TEAPOT" if you want output that matches the
// format used for the InvenSense teapot demo
//#define OUTPUT_TEAPOT


// CSWu, check for the value variation of real acceleration.
#define CHECK_HIT
//#include <wiringPi.h>



// MPU control/status vars
bool dmpReady = false;  // set true if DMP init was successful
uint8_t mpuIntStatus;   // holds actual interrupt status byte from MPU
uint8_t devStatus;      // return status after each device operation (0 = success, !0 = error)
uint16_t packetSize;    // expected DMP packet size (default is 42 bytes)
uint16_t fifoCount;     // count of all bytes currently in FIFO
uint8_t fifoBuffer[64]; // FIFO storage buffer

// orientation/motion vars
Quaternion q;           // [w, x, y, z]         quaternion container
VectorInt16 aa;         // [x, y, z]            accel sensor measurements
VectorInt16 aaReal;     // [x, y, z]            gravity-free accel sensor measurements
VectorInt16 aaWorld;    // [x, y, z]            world-frame accel sensor measurements

VectorInt16 aaReal_Last;

VectorFloat gravity;    // [x, y, z]            gravity vector
float euler[3];         // [psi, theta, phi]    Euler angle container
float ypr[3];           // [yaw, pitch, roll]   yaw/pitch/roll container and gravity vector

// packet structure for InvenSense teapot demo
uint8_t teapotPacket[14] = { '$', 0x02, 0,0, 0,0, 0,0, 0,0, 0x00, 0x00, '\r', '\n' };


// ================================================================
// ===                      INITIAL SETUP                       ===
// ================================================================

void setup() {
    // initialize device
    printf("Initializing I2C devices...\n");
    mpu.initialize();

    // verify connection
    printf("Testing device connections...\n");
    printf(mpu.testConnection() ? "MPU6050 connection successful\n" : "MPU6050 connection failed\n");

    // load and configure the DMP
    printf("Initializing DMP...\n");
    devStatus = mpu.dmpInitialize();
    
    // make sure it worked (returns 0 if so)
    if (devStatus == 0) {
        // turn on the DMP, now that it's ready
        printf("Enabling DMP...\n");
        mpu.setDMPEnabled(true);

        // enable Arduino interrupt detection
        //Serial.println(F("Enabling interrupt detection (Arduino external interrupt 0)..."));
        //attachInterrupt(0, dmpDataReady, RISING);
        mpuIntStatus = mpu.getIntStatus();

        // set our DMP Ready flag so the main loop() function knows it's okay to use it
        printf("DMP ready!\n");
        dmpReady = true;

        // get expected DMP packet size for later comparison
        packetSize = mpu.dmpGetFIFOPacketSize();
    } else {
        // ERROR!
        // 1 = initial memory load failed
        // 2 = DMP configuration updates failed
        // (if it's going to break, usually the code will be 1)
        printf("DMP Initialization failed (code %d)\n", devStatus);
    }
}


// ================================================================
// ===                    MAIN PROGRAM LOOP                     ===
// ================================================================

void loop(int& sock, int* deBounce, int& side, int& sideLeftPi, int& sideState, int& defense, int& actLeftPi, int& actState, int& rfcommsock) {
    // if programming failed, don't try to do anything
    if (!dmpReady) return;
    // get current FIFO count
    fifoCount = mpu.getFIFOCount();
    
    deBounce[0] += 1;
    deBounce[1] += 1;
    
    if (fifoCount == 1024) {
        // reset so we can continue cleanly
        mpu.resetFIFO();
        printf("FIFO overflow!\n");

    // otherwise, check for DMP data ready interrupt (this should happen frequently)
    } else if (fifoCount >= 42) {
        // read a packet from FIFO
        mpu.getFIFOBytes(fifoBuffer, packetSize);
        
        #ifdef OUTPUT_READABLE_QUATERNION
            // display quaternion values in easy matrix form: w x y z
            mpu.dmpGetQuaternion(&q, fifoBuffer);
            printf("quat %7.2f %7.2f %7.2f %7.2f    ", q.w,q.x,q.y,q.z);
        #endif

        #ifdef OUTPUT_READABLE_EULER
            // display Euler angles in degrees
            mpu.dmpGetQuaternion(&q, fifoBuffer);
            mpu.dmpGetEuler(euler, &q);
            printf("euler %7.2f %7.2f %7.2f    ", euler[0] * 180/M_PI, euler[1] * 180/M_PI, euler[2] * 180/M_PI);
        #endif

        #ifdef OUTPUT_READABLE_YAWPITCHROLL
            // display Euler angles in degrees
            mpu.dmpGetQuaternion(&q, fifoBuffer);
            mpu.dmpGetGravity(&gravity, &q);
            mpu.dmpGetYawPitchRoll(ypr, &q, &gravity);
            printf("ypr  %7.2f %7.2f %7.2f    ", ypr[0] * 180/M_PI, ypr[1] * 180/M_PI, ypr[2] * 180/M_PI);
            // detect side, left = =1 , right = 1
	    float yprUse = ypr[1]*180/M_PI;
	    float sideDeg = 15.0;
	    //printf("\n yprUse = %7.2f \n", yprUse);
	    if (yprUse < -sideDeg) {
		//printf("\n left side add 1, sideCounter[0]=%d \n", sideCounter[0])
		/*if (side != -1) {
			char message[100] = "Side=left";
			if ( send(sock, message, strlen(message), 0) < 0 ) {
				puts("Send Failed!");
			}
			printf("\n change side to left!");
			//sleep(0.1);//delay(100);
		}*/
		side = -1;
		//printf("\n side = -1\n");
	    } else if (yprUse > sideDeg){
		//printf("\n right side add 1, sideCounter[1]=%d \n", sideCounter[1]);
		/*if (side != 1) {
			char message[100] = "Side=right";
			if ( send(sock, message, strlen(message), 0) < 0 ) {
				puts("Send Failed!");
			}
			printf("\n change side to right!");
			//sleep(0.1);//delay(100);
		}*/
		side = 1;
		//printf("\n side = 1\n");
	    } else {
		/*if (side != 0) {
			char message[100] = "Side=middle";
			if ( send(sock, message, strlen(message), 0) < 0 ) {
				puts("Send Failed!");
			}
			printf("\n change side to middle!");
			//sleep(0.1);//delay(100);
		}*/
		side = 0;	
	    }
	    
	    if (side * sideLeftPi == 1 || (side == 0 && sideLeftPi == 0) ) {
		if ( side==1 && sideLeftPi == 1) {
			if (sideState != 1) {
				char message[100] = "Side=right";
				if ( send(sock, message, strlen(message), 0) < 0 ) {
					puts("Send Failed!");
				}
				printf("\n change side to right! \n");	
			}
			sideState = 1;
		} else if (side == -1 && sideLeftPi == -1) {
			if (sideState != -1) {
				char message[100] = "Side=left";
				if ( send(sock, message, strlen(message), 0) < 0 ) {
					puts("Send Failed!");
				}
				printf("\n change side to left! \n");	
			}
			sideState = -1;
		} else {
			if (sideState != 0) {
				char message[100] = "Side=middle";
				if ( send(sock, message, strlen(message), 0) < 0 ) {
					puts("Send Failed!");
				}
				printf("\n change side to middle! \n");	
			}
			sideState = 0;
		}
	    }

	    // detect attack or defense, 0 for attack and 1 for defense
	    float yprAction = ypr[2]*180/M_PI;
	    int ActionDeg = -45;
	    if ( yprAction < ActionDeg) {
		/*if (defense != 1) {
			char message[100] = "Action=defense";
			if ( send(sock, message, strlen(message), 0) < 0 ) {
				puts("Send Failed!");
			}
			printf("\n change action to defense!");
			//sleep(0.1);//delay(100);
		}*/
		defense = 1;	
	    } else {
		/*if (defense != 0) {
			char message[100] = "Action=attack";
			if ( send(sock, message, strlen(message), 0) < 0 ) {
				puts("Send Failed!");
			}
			printf("\n change action to attack!");
			//sleep(0.1);//delay(100);
		}*/
		defense = 0;
	    }

	    if (defense == 1 && actLeftPi == 1) {
		if (actState != 1) {
			char message[100] = "Action=defense";
			if ( send(sock, message, strlen(message), 0) < 0 ) {
				puts("Send Failed!");
			}
			printf("\n change action to defense! \n");	
		}
		actState = 1;	
	    } else {
		if (actState != 0) {
			char message[100] = "Action=attack";
			if ( send(sock, message, strlen(message), 0) < 0 ) {
				puts("Send Failed!");
			}
			printf("\n change action to attack! \n");	
		}
		actState = 0;	
	    }
	#endif

        #ifdef OUTPUT_READABLE_REALACCEL
            // display real acceleration, adjusted to remove gravity
            mpu.dmpGetQuaternion(&q, fifoBuffer);
            mpu.dmpGetAccel(&aa, fifoBuffer);
            mpu.dmpGetGravity(&gravity, &q);
            mpu.dmpGetLinearAccel(&aaReal, &aa, &gravity);
            printf("areal %6d %6d %6d ", aaReal.x, aaReal.y, aaReal.z);
	    
	    #ifdef CHECK_HIT
		int threshold = 5000;
	    	//char message[2000];
		if ( abs(aaReal.x-aaReal_Last.x)>threshold || abs(aaReal.y-aaReal_Last.y)>threshold || abs(aaReal.z-aaReal_Last.z)>threshold ) {
			//printf("\n %d, %d \n", deBounce[0], deBounce[2]);
			if(deBounce[0] > deBounce[2]+500) {
				if (actState == 0 && defense == 0) { 
					printf("\n @@@ Right Hand HIT!");
					char message[100] = "Right";
					if ( send(sock, message, strlen(message), 0) < 0 ) {
						puts("Send Failed!");
					}
					sleep(0.1);//delay(100);
				}
				deBounce[2] = deBounce[0];	
			}
		}
		
		char rfcommbuffer[255];
		int len = recv(rfcommsock, rfcommbuffer, 255, 0);
		if (len < 0 && errno != EWOULDBLOCK) {
			perror("ERROR rfcomm recv ");
			//break;
		} else if (len > 0)
		{
			rfcommbuffer[len] = '\0';
			//printf("\n rfcommbuffer=%s \n", &rfcommbuffer);
			if ( rfcommbuffer[0] == 'h' && rfcommbuffer[1]=='i' && rfcommbuffer[2]=='t') {
				if (actState == 0 && actLeftPi == 0) {
					printf("\n @@@ Left Hand HIT!"); //  %s", rfcommbuffer);
					char message[100] = "Left";
					if ( send(sock, message, strlen(message), 0) < 0 ){
						puts("Send FAILED");
					}		
					sleep(0.1);
				}
			} else if ( rfcommbuffer[0] == 's' && rfcommbuffer[1]=='i' && rfcommbuffer[2]=='d' && rfcommbuffer[3]=='e') {
				if ( rfcommbuffer[5] == 'r' ) {
					sideLeftPi = 1; 
				} else if (  rfcommbuffer[5]=='l') {
					sideLeftPi = -1;
				} else {
					sideLeftPi = 0;
				}
			} else if ( rfcommbuffer[0] == 'a' && rfcommbuffer[1]=='c' && rfcommbuffer[2]=='t') {
				if (rfcommbuffer[4] == 'd') {
					actLeftPi = 1;
				} else {
					actLeftPi = 0;
				}
			} 
			//send(rfcommsock, "ATOK\r\n", 6, 0);
		}
// Part for wire connect between two mobile devices using WiringPi Library
/*
	  	if (wiringPiSetup () == -1){
    			printf("@@@@@@@@@@@@@@@@@@@@@@@@@@ WiringPi Setup Failed!!");	
		}
		int ARDUINO_PIN = 5;
  		pinMode (ARDUINO_PIN, INPUT) ;         // 0 aka BCM_GPIO pin 17, 5 aka BCM_GPIO pin 24
  		pullUpDnControl(ARDUINO_PIN, PUD_UP);
		if (digitalRead(ARDUINO_PIN) == 1) {
			if(deBounce[1] > deBounce[3]+500) {
				printf("\n @@@ Left Hand HIT!");

				char message[1000] = "Left";
				if ( send(sock, message, strlen(message), 0) < 0 ){
					puts("Send FAILED");
				}		

				delay(100);
				deBounce[3] = deBounce[1];	
			}
		}
*/
	    #endif
	    
	    aaReal_Last = aaReal;
	#endif

        #ifdef OUTPUT_READABLE_WORLDACCEL
            // display initial world-frame acceleration, adjusted to remove gravity
            // and rotated based on known orientation from quaternion
            mpu.dmpGetQuaternion(&q, fifoBuffer);
            mpu.dmpGetAccel(&aa, fifoBuffer);
            mpu.dmpGetGravity(&gravity, &q);
            mpu.dmpGetLinearAccelInWorld(&aaWorld, &aaReal, &q);
            printf("aworld %6d %6d %6d    ", aaWorld.x, aaWorld.y, aaWorld.z);
	#endif
    
        #ifdef OUTPUT_TEAPOT
            // display quaternion values in InvenSense Teapot demo format:
            teapotPacket[2] = fifoBuffer[0];
            teapotPacket[3] = fifoBuffer[1];
            teapotPacket[4] = fifoBuffer[4];
            teapotPacket[5] = fifoBuffer[5];
            teapotPacket[6] = fifoBuffer[8];
            teapotPacket[7] = fifoBuffer[9];
            teapotPacket[8] = fifoBuffer[12];
            teapotPacket[9] = fifoBuffer[13];
            Serial.write(teapotPacket, 14);
            teapotPacket[11]++; // packetCount, loops at 0xFF on purpose
        #endif
        printf("\n");
    }
}

// Functions for Bluetooth
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

int rfcomm_listen(uint8_t channel)
{
	int sock;						// socket descriptor for local listener
	int client;						// socket descriptor for remote client
	unsigned int len = sizeof(struct sockaddr_rc);
	struct sockaddr_rc remote;		// local rfcomm socket address
	struct sockaddr_rc local;		// remote rfcomm socket addres
	char pszremote[18];
	// 藍牙 socket 初始化
	sock = socket(AF_BLUETOOTH, SOCK_STREAM, BTPROTO_RFCOMM);
	local.rc_family = AF_BLUETOOTH;
	// 如果使用 Bluetooth USB Dongle 的位址已知，可直接在 rd_bdaddr 輸入位址
	// 不然就輸入 *BDADDR_ANY ( 由系統自己選擇 )
	bdaddr_t temp = {0,0,0,0,0,0};//{0xB8,0x27,0xEB,0xC6,0xD3,0xEE};
	local.rc_bdaddr = temp; //*BDADDR_ANY;
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


int main(int argc, char *argv[]) {
    setup();
// Setup for Socket Programming
    //printf("%s, %s \n", argv[0], argv[1]);
 
    if (argc != 2){
    	printf("ERROR! Need <ip of server>!");
	return 1;
    }
    //char testvar[128];
    //testvar = malloc(strlen(argv[1])+ 1);
    //strcpy(testvar, argv[1]);
    //printf("%s", testvar);
    //string testvar(argv[1]);
    // Setup TCP client
  	int sock;
	struct sockaddr_in server;
	//char message[1000];
	// Create socket
	sock = socket(AF_INET, SOCK_STREAM, 0);
	if (sock == -1)	{
		printf("Could not create socket");
		return 1;
	} 
	puts("Socket Created \n");
	server.sin_addr.s_addr = inet_addr(argv[1]);  //inet_addr("192.168.1.179");
	server.sin_family = AF_INET;
	server.sin_port = htons(8888);
	// Connect to remote server
	if ( connect(sock, (struct sockaddr *)&server , sizeof(server)) < 0 ){
		perror("connect failed. ERROR");
		return 1;
	}
	puts("Connected \n");	  

// Setup for Bluetooth Communication: Server
    	unsigned int cls = 0x1f00;  // Serial Port Profile
    	int timeout = 1000;
    	uint8_t channel = 10; 
    	int rfcommsock;
	int scosock;
	if (set_class(cls, timeout) < 0) {
		perror("set_class ");
	}
	if (register_sdp(channel) < 0) {
		perror("register_sdp ");
		return -1;
	}
	if ((rfcommsock = rfcomm_listen(channel)) < 0) {
		perror("rfcomm_listen ");
		return -1;
	}
 	//handle_connection(rfcommsock, scosock);
		
    // send message to host
    char mess2host[100] = "user1 both ready";
    if (send(sock, mess2host, strlen(mess2host), 0) < 0)
	puts("ERROR Send to host FAILED");

    usleep(100000);
    int deBounce[4] = {0,0,0,0};
    //int sideCounter[2] = {0,0};
    int side = 0;
    int sideLeftPi = 0;
    int sideState = 0;
    int defense = 0;
    int actLeftPi = 0;
    int actState = 0;
    for (;;)
        loop(sock, deBounce, side, sideLeftPi, sideState, defense, actLeftPi, actState, rfcommsock);

    return 0;
}

