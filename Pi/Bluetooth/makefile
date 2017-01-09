#The following macros should be defined. 
TARGET1=spp-server
OBJECT1=spp-server.o
OBJECT2=spp-sdp-register.o
CC=gcc
CXX=g++ 
LD=g++ 
LD_FLAGS += -lbluetooth
#LD_FLAGS += -lncurses -pthread
#C_FLAGS= -g -O0 
C_FLAGS= 
# end of user configuration 
#
ALL : $(TARGET1)
$(TARGET1) : $(OBJECT1) $(OBJECT2) 
	$(LD)  $^ $(LD_FLAGS) -o $@ 
%.o : %.c 
	$(CC) $(C_FLAGS) -c $< 
%.o : %.cpp 
	$(CXX) $(C_FLAGS) -c $< 
.PHONY: clean 
clean : 
	-rm -f $(OBJECT1)
