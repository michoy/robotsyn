#!/usr/bin/env python2

'''

The following code converts a video file to a bag file.

Instructions:

1) put this script and videofile in the same folder

2) python make_bag.py <videofile name> <bagname>.bag


Dependencies: 
Jeg brukte ros-kinetic-opencv3, men det funker kanksje ogsa med andre
   
'''

import time, sys, os
import rospy, rosbag, roslib
roslib.load_manifest('sensor_msgs')
from sensor_msgs.msg import Image

from cv_bridge import CvBridge
import cv2

TOPIC = 'camera/image_raw'
prop_fps = 50

def CreateVideoBag(videopath, bagname):
    '''Creates a bag file with a video file'''
    bag = rosbag.Bag(bagname, 'w')
    cap = cv2.VideoCapture(videopath)
    cb = CvBridge()
    ret = True
    frame_id = 0
    while(ret):
        ret, frame = cap.read()
        if not ret:
            break
        stamp = rospy.rostime.Time.from_sec(float(frame_id) / prop_fps + 1)
        frame_id += 1
        image = cb.cv2_to_imgmsg(frame, encoding='bgr8')
        image.header.stamp = stamp
        image.header.frame_id = "camera"
        bag.write(TOPIC, image, stamp)
    cap.release()
    bag.close()

if __name__ == "__main__":
    if len( sys.argv ) == 3:
        CreateVideoBag(*sys.argv[1:])
    else:
        print( "Usage: video2bag videofilename bagfilename")
