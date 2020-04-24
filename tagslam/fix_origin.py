
#!/usr/bin/env python2

import rospy, rosbag, tf, sys
from geometry_msgs.msg import Pose, Point
import matplotlib.pyplot as plt
import numpy as np


BAG = str(sys.argv[1])

bag = rosbag.Bag(BAG)
msgs = bag.read_messages('/tagslam/odom/body_rig')

get_pose = lambda bag_msg: bag_msg.message.pose.pose
poses = list(map(get_pose, msgs))

positions = [pose.position for pose in poses]
orientations = [pose.orientation for pose in poses]

positions_tmp = list()
for position in positions:
    x = position.x
    y = position.y
    z = position.z
    positions_tmp.append([x, y, z, 1])
X = np.array(positions_tmp).T

x_init = X[0][0]
y_init = X[0][1]
z_init = X[0][2]

T_translate = np.array([
    [1, 0, 0, -x_init],
    [0, 1, 0, -y_init],
    [0, 0, 1, -z_init],
    [0, 0, 0, 1]
])

X_translated = T_translate.dot(X)

x = [pos[0] for pos in X_translated.T]
y = [pos[1] for pos in X_translated.T]
z = [pos[2] for pos in X_translated.T]

plt.plot(y, x)
plt.show()


orientation_initial = orientations[0]