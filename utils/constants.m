% Gains
Kp = 10;
Kd = 10;
g = [-9.81]; % m/s^2, inertial

% Inertia Tensor
J = eye(3) + [0     0.1     0;
              0.1   0       0.2;
              0     0.2     0];
                  
% max runtime
T_max = 8;
t_step = 0.01;
t = 0:t_step:T_max;
ARR_LEN = length(t);
DIMS = 1;

% max parameters/limits
V_MAX = 1;      % m/s
A_MAX = 4;      % m/s^2