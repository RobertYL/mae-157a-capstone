%% initialize_sim
% initialize constants and initial state
clear
clc
close all

%% sim parameters
constants

%% initialize waypoints
% waypoint_map = import_waypoints(filename)
num_wp = 15;
waypoint_map = [0; 0; 0];
waypoint_map(:,2:num_wp) = -5 + (5+5)*rand(3,num_wp-1);

% waypoint_map(:,2:num_wp) = [0.7,   1,   -2.1, -6.0, -8.2,    3,  5;
%                             0,     1.1,  2.3, -3.4, -8.0, -8.2, -7.8;
%                             -0.2,  0.8,    3, -4.2, -6.3, -5.5, -2];
%% compute trajectory
% [R_T, V_T, A_T] = calculate_trajectory(waypoint_map);
R_T = [sin(2*t); cos(2*t); t];
V_T = [2*cos(2*t); -2*sin(2*t); ones(1, length(t))];
A_T = [-4*sin(2*t); -4*cos(2*t); zeros(1, length(t))];

%% attitude representation
% INERTIAL FRAME DIRECTION OF DRONE X

% BODY FRAME DIRECTION OF DRONE X


q = zeros(4,1);
q(:,1) = [0, 0.7071, -0.7071, 0];
q(:,1) = q(:,1) / norm(q(:,1));
w = zeros(3,1);
w(:,1) = [0, 0, 0];

r = zeros(DIMS, ARR_LEN);
v = zeros(DIMS, ARR_LEN);
r_d = zeros(DIMS, ARR_LEN);
v_d = zeros(DIMS, ARR_LEN);
u = zeros(DIMS, ARR_LEN);