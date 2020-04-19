# Tagslam for ground truth

## How to run

### The example

source tagslam_root and this repo. 

rosparam set use_sim_time true

```
rviz -d tagslam/tagslam_example.rviz & roslaunch tagslam tagslam.launch bag:=tagslam/example.bag
```

### Actual footage

Set ros to use sim time
```rosparam set use_sim_time true```


Run offline detection of tags 

```roslaunch min_test detect.launch bag:=`rospack find min_test`/<bagname>```


Feed output bag into tagslam.launch and visualize with rviz

```rviz -d rviz_config.rviz & roslaunch min_test tagslam.launch bag:=`rospack find min_test`/<detections_bag>```


If tags are not rendered

```roslaunch tagslam_viz visualize_tags.launch tag_id_file:=$HOME/.ros/poses.yaml```


Make recording of tagslam estimate (and then rename and reindex)

```rosbag record /tagslam/odom/body_rig & roslaunch min_test tagslam.launch bag:=`rospack find min_test`/<detections_bag>```

Rename bag recording to <odom_bag>, and reindex it

```rosbag reindex <odom_bag>```


Make xy-plot of trajectory

```python plot.py <odom_bag>```



## Current issues

