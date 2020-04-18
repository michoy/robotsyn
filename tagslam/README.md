# Tagslam for ground truth

## How to run

### The example

source tagslam_root and this repo. 

rosparam set use_sim_time true

```
rviz -d tagslam/tagslam_example.rviz & roslaunch tagslam tagslam.launch bag:=tagslam/example.bag
```

### Actual footage

Run offline detection of tags 

```
roslaunch tagslam sync_and_detect.launch bag:=`rospack find tagslam`/example/example.bag
```

feed output bag into tagslam.launch and visualize with rviz

```
rviz -d tagslam/tagslam_example.rviz & roslaunch tagslam tagslam.launch bag:=tagslam/example.bag
```


## Current issues

sync and detect wont play the bag. Works on the default example. 

