%% initialize_sim
% initialize constants and initial state
clear
clc
close all

%% sim parameters
t = 0;      % current time
constants

%% initialize waypoints
% waypoint_map = import_waypoints(filename)

%% compute trajectory
% [R_T, V_T, A_T] = calculate_trajectory(waypoint_map);
R_T = sin(2*t);
V_T = 2*cos(2*t);
A_T = -4*sin(2*t);

%% attitude representation
% INERTIAL FRAME DIRECTION OF DRONE X

% BODY FRAME DIRECTION OF DRONE X


q = zeros(4,1);
q(:,1) = [0, 0.7071, -0.7071, 0];
q(:,1) = q(:,1) / norm(q(:,1));
w = zeros(3,1);
w(:,1) = [0, 0, 0];

r_d = zeros(DIMS, ARR_LEN);
v_d = zeros(DIMS, ARR_LEN);
u = zeros(DIMS, ARR_LEN);