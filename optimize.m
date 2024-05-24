Kp = 10;
Kd = 10;
dK = 0.5;

for iter = 1:1000
    drone_sim
    if j < num_wp
        break;
    end
end