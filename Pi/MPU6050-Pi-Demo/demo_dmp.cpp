#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdint.h>
#include <string.h>
#include <math.h>
#include "I2Cdev.h"
#include "MPU6050_6Axis_MotionApps20.h"

#include<sys/socket.h> 
#include<arpa/inet.h>

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
#include <wiringPi.h>



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

void loop(int& sock, int* deBounce, int* sideCounter, int& side) {
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
            float yprUse = ypr[1]*180/M_PI;
	    int sideThreshold = 3;
	    //printf("\n yprUse = %7.2f \n", yprUse);
	    if (yprUse < -15.0) {
		sideCounter[1] = 0;
		sideCounter[0] += 1;
		//printf("\n left side add 1, sideCounter[0]=%d \n", sideCounter[0]);
		if (sideCounter[0] > sideThreshold) {
			side = -1;
			printf("\n side = -1\n");
		}
	    } else if (yprUse > 15.0){
	    	sideCounter[0] = 0;
		sideCounter[1] += 1;
		//printf("\n right side add 1, sideCounter[1]=%d \n", sideCounter[1]);
		if (sideCounter[1] > sideThreshold) {
			side = 1;
			printf("\n side = 1\n");
		}
	    } else {
		sideCounter[0] = 0;
		sideCounter[1] = 0;
		side = 0;
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
				printf("\n @@@ Right Hand HIT!");
				char message[1000] = "Right";
				if ( send(sock, message, strlen(message), 0) < 0 ){
					puts("Send FAILED");
				}	
				delay(100);
				deBounce[2] = deBounce[0];	
			}
		}
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

int main(int argc, char *argv[]) {
    setup();
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
    usleep(100000);
    int deBounce[4] = {0,0,0,0};
    int sideCounter[2] = {0,0};
    int side = 0;
    for (;;)
        loop(sock, deBounce, sideCounter, side);

    return 0;
}

