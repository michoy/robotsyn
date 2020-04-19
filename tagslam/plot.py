#!/usr/bin/env python2

import rospy, rosbag, json, sys
import matplotlib.pyplot as plt


BAG = str(sys.argv[1])

bag = rosbag.Bag(BAG)
msgs = bag.read_messages('/tagslam/odom/body_rig')

get_pos = lambda bag_msg: bag_msg.message.pose.pose.position
positions = list(map(get_pos, msgs))

x = [pos.x for pos in positions]
y = [pos.y for pos in positions]
z = [pos.z for pos in positions]

plt.plot(y, x)
plt.show()

def save_to_file():
    with open('position_log.json', 'w') as log:
        data = {"x": x, "y": y, "z": z}
        json.dump(data, log)


save_to_file()