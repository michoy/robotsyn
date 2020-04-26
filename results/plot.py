#!/usr/bin/env python2

"""
Usage: python plot.py tagslam.bag orbslam.bag

"""

import rospy, rosbag, sys, tf
from geometry_msgs.msg import Quaternion
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import numpy as np
from tf.transformations import euler_from_quaternion, rotation_matrix


TAGSLAM_BAG = str(sys.argv[1])
ORBSLAM_BAG = str(sys.argv[2])


def plot_orientations(orientations):
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
		euler = euler_from_quaternion(q)
		roll.append(euler[0])
		pitch.append(euler[1])
		yaw.append(euler[2])

	plt.plot(roll, label='roll')
	plt.plot(pitch, label='pitch')
	plt.plot(yaw, label='yaw')
	plt.show()


def plot_positions(tagslam_pos, orbslam_pos):
	fig = plt.figure()
	ax = plt.axes(projection="3d")

	x_tag = list()
	y_tag = list()
	z_tag = list()
	for pos in tagslam_pos:
		x_tag.append(pos[0])
		y_tag.append(pos[1])
		z_tag.append(pos[2])

	ax.plot3D(x_tag, y_tag, z_tag, label='tagslam')
	
	x_orb = [pos.x for pos in orbslam_pos]
	y_orb = [pos.y for pos in orbslam_pos]
	z_orb = [pos.z for pos in orbslam_pos]
	ax.plot3D(x_orb, y_orb, z_orb, label='orbslam')
    
	ax.legend()
	plt.grid()
	plt.show()


""" Extract data from bags """

tagslam_msgs = rosbag.Bag(TAGSLAM_BAG).read_messages('/tagslam/odom/body_rig')
orbslam_msgs = rosbag.Bag(ORBSLAM_BAG).read_messages('/orb_slam2_mono/pose')

get_tagslam_pose = lambda bag_msg: bag_msg.message.pose.pose
tagslam_poses = list(map(get_tagslam_pose, tagslam_msgs))

get_orbslam_pose = lambda bag_msg: bag_msg.message.pose
orbslam_poses = list(map(get_orbslam_pose, orbslam_msgs))

orbslam_positions = [pose.position for pose in orbslam_poses]


""" Change origo of tagslam """

offset = tagslam_poses[0]

T_translate = np.array([
	[1, 0, 0, -offset.position.x],
    [0, 1, 0, -offset.position.y],
    [0, 0, 1, -offset.position.z],
    [0, 0, 0, 1]
])

q = (offset.orientation.x, offset.orientation.y, offset.orientation.z, offset.orientation.w)
euler = euler_from_quaternion(q)

Rx = rotation_matrix(-euler[0], [1, 0, 0])
Ry = rotation_matrix(-euler[1], [0, 1, 0])
Rz = rotation_matrix(-euler[2], [0, 0, 1])

positions_tmp = list()
for pose in tagslam_poses:
    x = pose.position.x
    y = pose.position.y
    z = pose.position.z
    positions_tmp.append([x, y, z, 1])
tagslam_positions_offset = np.array(positions_tmp).T

tagslam_positions = Rx.dot(Ry).dot(Rz).dot(T_translate).dot(tagslam_positions_offset).T


""" Plot results """

plot_positions(tagslam_positions, orbslam_positions)

