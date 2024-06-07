%% Kp/Kd Optimization Notes
% Monte Carlo simulation: randomly generated waypoints, ordered using
% tsp_dp.m. Run for 100 trials per "set". Optimized for total distance
% error across all waypoints in each set.
% 
% Kp_range = 1:1:25;
% Kd_range = 1:1:25;
% It seems that for some waypoint edge cases, gains of 18 or higher are
% needed for the run to actually succeed at reaching all waypoints. There
% were also a few edge cases where it no gain in these ranges led to 
% convergence. Notably, Kp seems to matter more than Kd for whether or not
% a run will actually converge. 
% The best results seemed to appear between Kp = 23:25. Kd doesn't
% seem to matter significantly, though the most commmon values were 
% clustered at low Kd values (4:6). However, for these Kd values, sometimes
% the simulation would not converge. The next cluster appeared at 
% Kd = 15:18, so we decided Next step: testing 
% Kp = 23:25 and Kd = 2:6 at increments of 0.1.
% 
% Median results for minimized total error:
% Kp = 24.9, Kd = 15.1

%% Monte Carlo

% NOTE: RUNNING OPTIMIZE.M REQUIRES COMMENTING OUT CLEAR, CLC, CLOSEALL IN
% DRONE_SIM.M. CHANGING THE PLOT SETTINGS IN INITIALIZE.M IS ALSO ADVISED.

clear
clc
close all

monte_carlo = 1;
run_min = zeros(monte_carlo, 3); % Kp: 1; Kd: 2; min err sum: 3

for run_num = 1:monte_carlo
    initialize_sim

    err_sum = zeros(length(Kp_range), length(Kd_range));
    Kp = Kp_range(1);
    Kd = Kd_range(1);
    
    for Kp_iter = 1:length(Kp_range)
        Kp = Kp_range(Kp_iter);
        for Kd_iter = 1:length(Kd_range)
            Kd = Kd_range(Kp_iter);
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