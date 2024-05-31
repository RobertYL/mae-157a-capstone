% Kp_range = 12:1:22;
% Kd_range = 12:1:22;
% Simulation didn't converge until Kp=19, Kd didn't matter.
% Next step would be to test from 18, in 0.1 increments.

% Testing Kp_range = 23:1:50, Kd_range = 23:1:50 yielded higher error than
% Kp_range = 18:1:23, Kd_range = 18:1:23

% Assuming that error is generally monotonically increasing/decreasing 
% over the plot of Kp/Kd/error, this means the optimal values are probably
% somewhere in the range of Kp_range = 18:1:25, Kd_range = 10:1:25
% (expanded from the previous range just for coverage).

% Simulation does not consistently converge until Kp = 20 or so; any Kd in
% the given range seems to work, but the errors seem to be minimized
% between Kd_range = 18:1:22.

% Running a simulation 100 trials, for Kp_range = 20:0.1:22, 
% Kd_range = 18:0.1:22 yielded a minimized error in the range:
% Kp = [,]; Kd = [,]

clear
clc
close all

monte_carlo = 100;
run_min = zeros(monte_carlo, 3); % Kp: 1; Kd: 2; min err sum: 3

for run_num = 1:monte_carlo
    initialize_sim
    Kp_range = 20:0.1:22;
    Kd_range = 18:0.1:22;

    dK = 0.5;
    err_sum = zeros(length(Kp_range), length(Kd_range));
    Kp = Kp_range(1);
    Kd = Kd_range(1);
    
    for Kp_iter = 1:length(Kp_range)
        Kp = Kp_range(Kp_iter);
        for Kd_iter = 1:length(Kd_range)
            Kd = Kd_range(Kd_iter);
            drone_sim
            if j < num_wp
                err_sum(Kp_iter, Kd_iter) = 100000000;
                continue
            end
        
            for n = 1:num_wp
                err_sum(Kp_iter, Kd_iter) = err_sum(Kp_iter, Kd_iter) + norm(wp_err(:,n));
            end
        end
    end
    
    minval = min(err_sum,[],'all');
    [row, col] = find(err_sum == minval);
    if length(row) > 1 || length(col) > 1
        run_min(run_num, :) = [-1 -1 -1];
        continue;
    end
    run_min(run_num, 1) = Kp_range(row);
    run_min(run_num, 2) = Kd_range(col);
    run_min(run_num, 3) = minval;
end