# Tagslam for ground truth

## How to run

### The example

source tagslam_root and this repo. 

rosparam set use_sim_time true

```
rviz -d tagslam/tagslam_example.rviz & roslaunch tagslam tagslam.launch bag:=tagslam/example.bag
```

### Actual footage

source devel/setup.bash & source ~/tagslam_root/devel/setup.bash 

Start a ros core
```
roscore
```

Set ros to use sim time
```
rosparam set use_sim_time true
```

Run offline detection of tags 
```
roslaunch min_test detect.launch bag:=`rospack find min_test`/<bagname>
```

Render tags
```
roslaunch tagslam_viz visualize_tags.launch tag_id_file:=$HOME/.ros/poses.yaml
```

Feed output bag into tagslam.launch and visualize with rviz
```
rviz -d rviz_config.rviz & roslaunch min_test tagslam.launch bag:=`rospack find min_test`/<detections_bag> data_dir:=`rospack find min_test`/<param_folder>
```

Make recording of a tagslam replay
```
rosservice call /tagslam/replay & rosbag record /tagslam/odom/body_rig
```

(optional step: rename bag) 

Make xy-plot of trajectory
```
python plot.py <odom_bag>
```
