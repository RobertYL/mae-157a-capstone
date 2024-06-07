%% initialize_sim
% initialize constants and initial state

%% settings
% NOTE: RUNNING OPTIMIZE.M REQUIRES COMMENTING OUT CLEAR, CLC, CLOSEALL IN
% DRONE_SIM.M. CHANGING THE PLOT SETTINGS IN INITIALIZE.M IS ALSO ADVISED.
from_file = true;
random_map = false;
num_wp = 10;        % default value to use in random map generation
plot_results = true;
saveplot = false;

% file name
filename = 'waypoints_example.csv';

%% sim parameters
constants
% constants.m initializes other sim parameters to a default value, they can
% be changed within that file (e.g. step size, max runtime, distance
% threshold, etc.

% Gains
Kp_range = 23:0.1:25;   % range initialize is required for optimization
Kd_range = 15:0.1:18;

Kp = Kp_range(1);
Kd = Kd_range(1);
%% initialize waypoints
if from_file
    waypoint_map = import_waypoint(filename);
    num_wp = size(waypoint_map, 2);
elseif random_map
    waypoint_map = zeros(3, num_wp);
    waypoint_map(3,1) = 1;
    waypoint_map(1:2,2:num_wp) = -5 + (5+5)*rand(2,num_wp-1);
    waypoint_map(3, 2:num_wp) = 0.5 + 5*rand(1,num_wp-1);
else
    num_wp = 10     % prewritten config
    waypoint_map(:,2:num_wp) = [0.7,    1,   -2.1, -6.0, -8.2,    3,  5,    0.4,    -2.4;
                                0,      1.1,  2.3, -3.4, -8.0, -8.2, -7.8, -0.2,     5.4;
                               -0.2,    0.8,    3, -4.2, -6.3, -5.5, -2,   -3.8,     3.6];
end

% generate order to traverse and resort the waypoints
[order, ~] = tsp_dp(make_graph(waypoint_map),1);
waypoint_map = waypoint_map(:,order);

% initialize vectors to track
r = zeros(DIMS, ARR_LEN);
v = zeros(DIMS, ARR_LEN);
r_d = zeros(DIMS, ARR_LEN);
v_d = zeros(DIMS, ARR_LEN);
u = zeros(DIMS, ARR_LEN);