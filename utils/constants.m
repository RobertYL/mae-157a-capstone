% simulation constants
g = [0; 0; -9.81]; % m/s^2, inertial
eps = [0.50; 0.50; 0.50];  % m
                  
% sim parameters
T_max = 300;
t_step = 0.01;
t = 0:t_step:T_max;
ARR_LEN = length(t);
DIMS = 3;
vmax = 1;   % m/s
pos_max = 10;

% max parameters/limits
V_MAX = 1;      % m/s
A_MAX = 4;      % m/s^2