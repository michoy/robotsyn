
#!/usr/bin/env python2

import rospy, rosbag, sys, tf
from geometry_msgs.msg import Quaternion
import matplotlib.pyplot as plt


BAG = str(sys.argv[1])

bag = rosbag.Bag(BAG)
msgs = bag.read_messages('/tagslam/odom/body_rig')

get_ori = lambda bag_msg: bag_msg.message.pose.pose.orientation
orientations = list(map(get_ori, msgs))

roll = list()
pitch = list()
yaw = list()

for quat in orientations:
	q = (
		quat.x,
		quat.y, 
		quat.z, 
		quat.w
	)
	euler = tf.transformations.euler_from_quaternion(q)
	roll.append(euler[0])
	pitch.append(euler[1])
	yaw.append(euler[2])

plt.plot(roll, label='roll')
plt.plot(pitch, label='pitch')
plt.plot(yaw, label='yaw')
plt.show()
