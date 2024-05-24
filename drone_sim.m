%% sim main body
initialize_sim
disp("Initialized");

i = 1;
j = 1;
k = 1;
T = abs(waypoint_map(:,j+1) - waypoint_map(:,j))/vmax;
T = max(T);
while(t(i) < T_max &  j < size(waypoint_map,2)) 
    % check if a waypoint has been "crossed"
    if(abs(r(:,i) - waypoint_map(:,j+1)) < eps &  j < size(waypoint_map,2))
        T = abs(waypoint_map(:,j+1) - waypoint_map(:,j))/vmax;
        T = max(T);
        
        j = j+1;
        k = 1;
    end
    if j >= size(waypoint_map,2)
        break;
    end
    % calculate desired velocity, position
    dt = T-t_step*k;
    if dt < t_step*5
        dt = t_step*5;
    end
    % v_d(:,i) = (waypoint_map(:,j+1) - r(:,i))/dt;
    v_d(:,i) = (waypoint_map(:,j+1) - waypoint_map(:,j))/T;
    % r_d(:,i) = r(:,i) + v_d(:,i)*t_step*k;
    r_d(:,i) = waypoint_map(:,j) + v_d(:,i)*t_step*k;
    
    % calculate error
    r_err = r(:,i) - r_d(:,i);
    v_err = v(:,i) - v_d(:,i);
    
    % calculate control input
    u(:,i) = -Kp*r_err - Kd*v_err;
    
    for x = 1:3
        if u(x,i) + g > 4       % check for max input cap
            u(x,i) = u(x,i) - ((u(x,i) + g(x))-4);
        elseif u(x,i) + g < -4
            u(x,i) = u(x,i) - ((u(x,i) - g(x))+4);
        end
    end
    
    % propagate
    r(:,i+1) = r(:,i) + t_step*v(:,i) + 0.5*(u(:,i)+g)*t_step^2;
    v(:,i+1) = v(:,i) + t_step*(u(:,i)+g);
    
    i = i+1;
    k = k+1;
end
i = i-1;        % reset index for plotting

figure(1)
plot(t(:,1:i), r(:,1:i));
hold on;
plot(t(:,1:i), r_d(:,1:i),'--');
grid on
legend({'x_{drone}','y_{drone}','z_{drone}','x_{trajectory}','y_{trajectory}','z_{trajectory}'});
axis([0 t(:,i) -pos_max pos_max]);
title('Position');

figure(2)
plot(t(:,1:i), v(:,1:i));
hold on;
plot(t(:,1:i), v_d(:,1:i),'--');
grid on
legend({'x_{drone}','y_{drone}','z_{drone}','x_{trajectory}','y_{trajectory}','z_{trajectory}'});
axis([0 t(:,i) -5 5]);
title('Velocity');

figure(3)
plot(t(:,1:i), u(:,1:i));
grid on
legend({'x_{drone}','y_{drone}','z_{drone}','x_{trajectory}','y_{trajectory}','z_{trajectory}'});
title('Control Input');