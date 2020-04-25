% Init
close all
clear all
clc

% Get data and making odom martices


fileID       = fopen('odom2.txt','r');
data_dso     = fscanf(fileID,'%f');
fclose(fileID);
matrix_dso   = make_matrix_dso_style(data_dso);

bag = rosbag('litenRunde-badkalib.bag');
bSel = select(bag,'Topic','/tagslam/odom/body_rig');
msgStructs = readMessages(bSel,'DataFormat','struct');
% I dont know how to get timestamp from odom
[x, y, z, quat1, quat2, quat3, quat4, t_tagslam] = extract_from_odomstruct(msgStructs);
matrix_tagslam = make_matrix(x, y, z, quat1, quat2, quat3, quat4);


% Setting referance frame
%matrix_orb     = set_referance_frame(matrix_orb,matrix_orb{1});
matrix_dso     = reset_referance_frame(matrix_dso,matrix_dso{1});
matrix_tagslam = reset_referance_frame(matrix_tagslam,matrix_tagslam{1});

% Accessing data for plotting
%[x_orb, y_orb, z_orb, yaw_orb, pitch_orb, roll_orb] = extract_from_matrix(matrix_orb);
x_orb      = 0;
y_orb      = 0;
z_orb      = 0;
yaw_orb    = 0;
pitch_orb  = 0;
roll_orb   = 0;
t_orb      = 0;
label_orb  = 'ORB-SLAM';
color_orb  = [0, 0.4470, 0.7410];

[x_dso, y_dso, z_dso, roll_dso, pitch_dso, yaw_dso] = extract_from_matrix(matrix_dso);
t_dso      = data_dso(1:13:end);
label_dso  = 'DSO';
color_dso  = [0.8500, 0.3250, 0.0980];


[x_tagslam, y_tagslam, z_tagslam, roll_tagslam, pitch_tagslam, yaw_tagslam] = extract_from_matrix(matrix_tagslam);
t_tagslam      = t_tagslam;
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
legend(label_orb,label_dso,label_tagslam,'Location', 'Best')
title('Trajectories along the x-axis')
xlabel('t')
ylabel('meters')

subplot(3,1,2)
plot(t_dso,y_orb,'Color',color_orb)
hold on
plot(t_dso,y_dso,'Color',color_dso)
plot(t_tagslam,y_tagslam,'Color',color_tagslam)
title('Trajectories along the y-axis')
xlabel('t')
ylabel('meters')

subplot(3,1,3)
plot(t_orb,z_orb,'Color',color_orb)
hold on
plot(t_dso,z_dso,'Color',color_dso)
plot(t_tagslam,z_tagslam,'Color',color_tagslam)
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
legend(label_orb,label_dso,label_tagslam,'Location', 'Best')
title('Roll')
xlabel('t')
ylabel('radians')

subplot(3,1,2)
plot(t_dso,pitch_orb,'Color',color_orb)
hold on
plot(t_dso,pitch_dso,'Color',color_dso)
plot(t_tagslam,pitch_tagslam,'Color',color_tagslam)
title('Pitch')
xlabel('t')
ylabel('radians')

subplot(3,1,3)
plot(t_orb,yaw_orb)
hold on
plot(t_dso,yaw_dso)
plot(t_tagslam,yaw_tagslam)
title('Yaw')
xlabel('t')
ylabel('radians')

%===== FIGURE 4 =======================%
% 3D plot of the trajectories
figure(4)

plot3(x_orb,y_orb,z_orb)
hold on
plot3(x_dso,y_dso,z_dso)
plot3(x_tagslam,y_tagslam,z_tagslam)

function [x, y, z, roll, pitch, yaw] = extract_from_matrix(matrix);
    % Function for extracting this from a 3x4 matrix
    N     = length(matrix);
    x     = 1:N;
    y     = 1:N;
    z     = 1:N;
    roll  = 1:N;
    pitch = 1:N;
    yaw   = 1:N;
    for i = 1:N
        x(i) = matrix{i}(1,4);
        y(i) = matrix{i}(2,4);
        z(i) = matrix{i}(3,4);
        eulZYZ = rotm2eul(matrix{i}(:,1:3),'ZYZ');
        roll(i)  = eulZYZ(1);
        pitch(i) = eulZYZ(2);
        yaw(i)   = eulZYZ(3);
    end
end

function [x, y, z, quat1, quat2, quat3, quat4, t] = extract_from_odomstruct(struct)
    % Function for extracting this from a 3x4 matrix
    N     = length(struct);
    x     = 1:N;
    y     = 1:N;
    z     = 1:N;
    quat1   = 1:N;
    quat2   = 1:N;
    quat3   = 1:N;
    quat4   = 1:N;
    t       = 1:N;
    for i = 1:N
        x(i) = struct{i}.Pose.Pose.Position.X;
        y(i) = struct{i}.Pose.Pose.Position.Y;
        z(i) = struct{i}.Pose.Pose.Position.Z;
        quat1(i) = struct{i}.Pose.Pose.Orientation.X;
        quat2(i) = struct{i}.Pose.Pose.Orientation.Y;
        quat3(i) = struct{i}.Pose.Pose.Orientation.Z;
        quat4(i) = struct{i}.Pose.Pose.Orientation.W;
        t(i)     = 0;
    end
end

function matrix = reset_referance_frame(matrix,matrix2)
    N = length(matrix);
    for i = 1:N
    matrix{i}(:,1:3) = matrix{i}(:,1:3)*inv(matrix2(:,1:3));
    matrix{i}(:,4) = matrix{i}(:,4)-matrix2(:,4);
    end
end

function matrix = make_matrix(x, y, z, quat1, quat2, quat3, quat4)
    N = length(x);
    matrix{1} = zeros(3,4);
    for i = 1:N
        quat     = [quat1(i) quat2(i) quat3(i) quat4(i)];
        matrix{i}(:,1:3) = quat2rotm(quat);
        matrix{i}(:,4)   = [x(i);y(i);z(i)];
    end
end

function matrix_dso = make_matrix_dso_style(data_dso)
i = 1;
k = 1;
    while i < length(data_dso)
       matrix_dso{k} = [data_dso(i+1) data_dso(i+2) data_dso(i+3) data_dso(i+4);
                        data_dso(i+5) data_dso(i+6) data_dso(i+7) data_dso(i+8);
                        data_dso(i+9) data_dso(i+10) data_dso(i+11) data_dso(i+12)];
       i = i + 13;
       k = k + 1;
    end
end

