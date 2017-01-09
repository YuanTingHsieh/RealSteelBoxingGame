# You need to "sudo apt-get install libgtkmm-3.0-dev" to build the demo_3d binary

all: demo_dmp

HDRS = helper_3dmath.h I2Cdev.h MPU6050_6Axis_MotionApps20.h MPU6050.h spp-sdp-register.h
CMN_OBJS = I2Cdev.o MPU6050.o
DMP_OBJS = demo_dmp.o

LD=g++
LD_FLAGS+= -lbluetooth
CC=gcc
CXX=g++
C_FLAGS=
# Set DMP FIFO rate to 20Hz to avoid overflows on 3d demo.  See comments in
# MPU6050_6Axis_MotionApps20.h for details.

CXXFLAGS = -DDMP_FIFO_RATE=9 -Wall -g -O2 `pkg-config gtkmm-3.0 --cflags --libs`

$(CMN_OBJS) $(DMP_OBJS) : $(HDRS)

demo_dmp: $(CMN_OBJS) $(DMP_OBJS) spp-sdp-register.o
	$(CXX) -o $@ $^ -lbluetooth
#	$(LD) $^ $(LD_FLAGS) -o $@
#%.o: %.c
#	$(CC) -c $<
#%.o: %.cpp
#	$(CXX) $(C_FLAGS) -c $<
	#$(CXX) -o $@ $^ -lm -lbluetooth

clean:
	rm -f $(CMN_OBJS) $(DMP_OBJS) $(D3D_OBJS) $(RAW_OBJS) demo_raw demo_dmp demo_3d test_3d

