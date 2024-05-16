%% sim main body
initialize_sim
disp("Initialized");

i = 1;
while(t(i) < T_max) %& waypoint_pass < 0)
    r_err = r_d(:,i) - R_T(:,i);
    v_err = v_d(:,i) - V_T(:,i);
    
    u(:,i) = A_T(:,i) - Kp*r_err - Kd*v_err;
    if u(:,i) + g > 4       % check for max input cap
        u(:,i) = u(:,i) - ((u(:,i) + g)-4);
    elseif u(:,i) + g < -4
        u(:,i) = u(:,i) + ((u(:,i) + g)-4);
    end
    torque = control_law(u);
    r_d(:,i+1) = r_d(:,i) + t_step*v_d(:,i) + 0.5*(u(:,i)+g)*t_step^2;
    v_d(:,i+1) = v_d(:,i) + t_step*(u(:,i)+g);
    
    i = i+1;
end

figure(1)
plot(t, r_d, t, R_T);
grid on
legend({'Drone', 'Trajectory'});
title('Position');

figure(2)
plot(t, v_d, t, V_T);
grid on
legend({'Drone', 'Trajectory'});
title('Velocity');

figure(3)
plot(t, u);
grid on
legend({'Drone', 'Trajectory'});
title('Control Input');