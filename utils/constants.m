% Gains
Kp = 18.3;
Kd = 15;
g = [0; 0; -9.81]; % m/s^2, inertial
eps = [0.50; 0.50; 0.50];  % m

% Inertia Tensor
J = eye(3) + [0     0.1     0;
              0.1   0       0.2;
              0     0.2     0];
                  
% sim parameters
T_max = 300;
t_step = 0.01;
t = 0:t_step:T_max;
ARR_LEN = length(t);
DIMS = 3;
vmax = 1;   % m/s
pos_max = 5;

% max parameters/limits
V_MAX = 1;      % m/s
A_MAX = 4;      % m/s^2