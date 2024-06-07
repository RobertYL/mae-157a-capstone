%% sim main body
% NOTE: RUNNING OPTIMIZE.M REQUIRES COMMENTING OUT CLEAR, CLC, CLOSEALL IN
% DRONE_SIM.M. CHANGING THE PLOT SETTINGS IN INITIALIZE.M IS ALSO ADVISED.
clear
clc
close all
initialize_sim

disp(strcat('Kp: ', num2str(Kp, 3), ' / Kd: ', num2str(Kd, 3)));

i = 1;
j = 1;
k = 1;
T = abs(waypoint_map(:,j+1) - waypoint_map(:,j))/vmax;
T = max(T);

wp_err = zeros(3, num_wp);
while(t(i) < T_max &  j < size(waypoint_map,2)) 
    % check if a waypoint has been "crossed"
    if(abs(r(:,i) - waypoint_map(:,j+1)) < eps &  j < size(waypoint_map,2))
        T = abs(waypoint_map(:,j+1) - waypoint_map(:,j))/vmax;
        T = max(T);
        
        wp_err(:,j) = abs(r(:,i) - waypoint_map(:,j+1));
        
        j = j+1;
        k = 1;
    end
    if j >= size(waypoint_map,2)
        break;
    end
%     % calculate desired velocity, position based on current state
%     dt = T-t_step*k;
%     if dt < t_step*5
%         dt = t_step*5;
%     end
%     v_d(:,i) = (waypoint_map(:,j+1) - r(:,i))/dt;
    
%     r_d(:,i) = r(:,i) + v_d(:,i)*t_step*k;

    v_d(:,i) = (waypoint_map(:,j+1) - waypoint_map(:,j))/T;
    r_d(:,i) = waypoint_map(:,j) + v_d(:,i)*t_step*k;

    % check if any of XYZ are already at the next waypoint's XYZ
    % if yes, stop moving/minimize additional movement in that coordinate
    for x = 1:3
        if abs(r(x,i) - waypoint_map(x,j+1)) < eps
            r_d(x,i) = waypoint_map(x,j+1);
            v_d(x,i) = 0;       
        end
    end
    
    % calculate error
    r_err = r(:,i) - r_d(:,i);
    v_err = v(:,i) - v_d(:,i);

    
    % calculate control input
    u(:,i) = -Kp*r_err - Kd*v_err - g;
    
    for x = 1:3
        if u(x,i) + g(x) > A_MAX       % check for max input cap
            u(x,i) = A_MAX - g(x);
        elseif u(x,i) + g(x) < -A_MAX
            u(x,i) = -A_MAX - g(x);
        end
    end
    
    % propagate
    r(:,i+1) = r(:,i) + t_step*v(:,i) + 0.5*(u(:,i)+g)*t_step^2;
    v(:,i+1) = v(:,i) + t_step*(u(:,i)+g);
    
    i = i+1;
    k = k+1;
end

%% plotting
if plot_results
    i = i-1;        % reset index for plotting

    figure(1)
    subplot(2,2,1);
    plot(t(:,1:i), r(:,1:i));
    hold on;
    plot(t(:,1:i), r_d(:,1:i),'--');
    grid on
    legend({'x_{drone}','y_{drone}','z_{drone}',...
            'x_{trajectory}','y_{trajectory}','z_{trajectory}'},...
            'NumColumns', 2, 'Location', 'southwest');
    axis([0 t(:,i) -pos_max pos_max]);
    xlabel('Time (s)')
    ylabel('Position (m)');
    title('Position');

    subplot(2,2,2);
    plot(t(:,1:i), v(:,1:i));
    hold on;
    plot(t(:,1:i), v_d(:,1:i),'--');
    grid on
    legend({'x_{drone}','y_{drone}','z_{drone}',...
            'x_{trajectory}','y_{trajectory}','z_{trajectory}'},...
            'NumColumns', 2, 'Location', 'southeast');
    axis([0 t(:,i) -5 5]);
    xlabel('Time (s)')
    ylabel('Velocity (m/s)');
    title('Velocity');

    subplot(2,2,[3,4]);
    plot(t(:,1:i), u(:,1:i));
    grid on
    legend({'x_{drone}','y_{drone}','z_{drone}'}, 'Location', 'southeast');
    title('Control Input');
    xlim([0 t(:,i)]);
    xlabel('Time (s)')
    ylabel('Control Input (m/s^2)');
    sgtitle(strcat('K_p: ', num2str(Kp,3), '; K_d: ', num2str(Kd,3)));
    set(gcf, 'Position', get(0, 'Screensize'));
    
    if saveplot
        saveas(gcf, strcat('Kp_', num2str(Kp,2), 'Kd_', num2str(Kd,2),'.jpg'));
    end
end
