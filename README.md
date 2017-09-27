# Real Steel Fight Game
#### This project is written in Qt, QML, C++ using V-Play Engine for Embedded Systems Lab, NTU, Spring 2017
#### Can run successfully on Windows 10 and Ubuntu 14.04 with Qt 5.7.1 and QtCreator 4.1.0 and latest V-play 2.9.2
#### Demo on Youtube: [Here](https://www.youtube.com/watch?v=jziXI6g9NkU&feature=youtu.be)

![Image of Homepage](https://github.com/YuanTingHsieh/ESL/blob/master/demos/homepage.JPG)

## Description
 - This is a interactive boxing game for two players.
 - One game screen showing the fighting process of two players.
 - Each player have two types of punching, left or right.
 
 ![Image of gamepage](https://github.com/YuanTingHsieh/ESL/blob/master/demos/game.JPG)

## Setup of Qt screen
 1. Install V-Play GameEngine from [their website](https://v-play.net/), it is based on Qt
 2. Make sure your network is working!
 3. Launch your Qt creator
 4. Choose Open project -> open try.pro
 5. Enjoy!
 
## Setup of Pi with MPU6050
 1. The code is included in our [repo](https://github.com/YuanTingHsieh/ESL/tree/master/Pi/MPU6050-Pi-Demo)
 2. It is modified from others code, as specified in the [readme](https://github.com/YuanTingHsieh/ESL/blob/master/Pi/MPU6050-Pi-Demo/README)
 3. [Some useful blogposts](https://blog.gtwang.org/iot/raspberry-pi-read-data-from-mpu6050-using-cpp/) to help identify the connection problem

## Settings
 - Each of the player will have a pair of boxing gloves
 - Each glove is equipped with an Raspberry Pi 2/3 Board or Arduino connect with an MPU-6050 6-DOF sensor

## Equipments
| Device | Number |
| ------ | ------ |
| Raspberry Pi 2/3 Board   | x4 |
| A device with screen and able to run Qt (e.g. Laptop) | x1 |
| MPU-6050 chip    | x4 |

## Credicts
 - This is the final project for the course Embedding System Lab (2016 Fall), at National Taiwan University
 - Arthurs: Yuan-Ting Hsieh, Chien-Sheng Wu

## Disclaimer
 - We don't own the rights of the image or music we used in our project, mostly taken from the film "Real Steel"
 - We won't put those files on this public github repository 
