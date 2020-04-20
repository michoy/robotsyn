% Init
close all
clear all
clc

% Get data
data_orb      = 0;
data_dso      = 0;
data_tagslam  = 0;

% Processing of data
x_orb      = 0;
y_orb      = 0;
z_orb      = 0;
yaw_orb    = 0;
pitch_orb  = 0;
roll_orb   = 0;
t_orb      = 0;
label_orb  = 'ORB-SLAM';
color_orb  = [0, 0.4470, 0.7410];

x_dso      = 0;
y_dso      = 0;
z_dso      = 0;
yaw_dso    = 0;
pitch_dso  = 0;
roll_dso   = 0;
t_dso      = 0;
label_dso  = 'DSO';
color_dso  = [0.8500, 0.3250, 0.0980];

x_tagslam      = 0;
y_tagslam      = 0;
z_tagslam      = 0;
yaw_tagslam    = 0;
pitch_tagslam  = 0;
roll_tagslam   = 0;
t_tagslam      = 0;
label_tagslam  = 'TagSLAM';
color_tagslam  = [0.9290, 0.6940, 0.1250];

%===== FIGURE 1 =======================%
% Plot of trajectories seen from above (x,y)
figure(1)
plot(y_orb,x_orb,'Color',color_orb)
hold on
plot(y_dso,x_dso,'Color',color_dso)
plot(y_tagslam,x_tagslam,'Color', color_tagslam)
legend(label_orb,label_dso,label_tagslam)
title('Trajectories seen from above')
xlabel('y [m]')
ylabel('x [m]')

%===== FIGURE 2 =======================%
% Plot of the trajectories
figure(2)

subplot(3,1,1)
plot(t_orb,x_orb,'Color',color_orb)
hold on
plot(t_dso,x_dso,'Color',color_dso)
plot(t_tagslam,x_tagslam,'Color',color_tagslam)
legend(label_orb,label_dso,label_tagslam)
title('Trajectories along the x-axis')
xlabel('t')
ylabel('meters')

subplot(3,1,2)
plot(t_dso,y_orb,'Color',color_orb)
hold on
plot(t_dso,y_dso,'Color',color_dso)
plot(t_tagslam,y_tagslam,'Color',color_tagslam)
legend(label_orb,label_dso,label_tagslam)
title('Trajectories along the y-axis')
xlabel('t')
ylabel('meters')

subplot(3,1,3)
plot(t_orb,z_orb,'Color',color_orb)
hold on
plot(t_dso,z_dso,'Color',color_dso)
plot(t_tagslam,z_tagslam,'Color',color_tagslam)
legend(label_orb,label_dso,label_tagslam)
title('Trajectories along the z-axis')
xlabel('t')
ylabel('meters')

%===== FIGURE 3 =======================%
% Plot of the rotation of the trajectories
figure(3)

subplot(3,1,1)
plot(t_orb,roll_orb,'Color',color_orb)
hold on
plot(t_dso,roll_dso,'Color',color_dso)
plot(t_tagslam,roll_tagslam,'Color',color_tagslam)
legend(label_orb,label_dso,label_tagslam)
title('Roll')
xlabel('t')
ylabel('radians')

subplot(3,1,2)
plot(t_dso,pitch_orb,'Color',color_orb)
hold on
plot(t_dso,pitch_dso,'Color',color_dso)
plot(t_tagslam,pitch_tagslam,'Color',color_tagslam)
legend(label_orb,label_dso,label_tagslam)
title('Pitch')
xlabel('t')
ylabel('radians')

subplot(3,1,3)
plot(t_orb,yaw_orb)
hold on
plot(t_dso,yaw_dso)
plot(t_tagslam,yaw_tagslam)
legend(label_orb,label_dso,label_tagslam)
title('Yaw')
xlabel('t')
ylabel('radians')
