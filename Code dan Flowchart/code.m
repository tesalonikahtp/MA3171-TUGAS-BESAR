clear all

% Parameters
sigma = 10;
beta = 8/3;
rho = 24.74;

% Initial condition - large cube of points
xvec = -20:2:20;
yvec = -20:2:20;
zvec = -20:2:20;
[x0, y0, z0] = meshgrid(xvec, yvec, zvec);
yIC(1,:,:,:) = x0;
yIC(2,:,:,:) = y0;
yIC(3,:,:,:) = z0;

% Plot
plot3(yIC(1,:), yIC(2,:), yIC(3,:), 'b.', 'LineWidth', 1, 'MarkerSize', 4)
axis([-40 40 -40 40 -40 40])
view(20,40);
drawnow
xlabel('X-axis');
ylabel('Y-axis');
zlabel('Z-axis');

% Compute trajectory
dt = 0.05;
duration = 3;
tspan = [0, duration];
L = duration/dt;
yparticles = yIC;

% Preallocate F
F = struct('cdata', cell(1, L), 'colormap', cell(1, L));

% Simulation loop
for step = 1:L
    time = step*dt;
    
    % Update particle positions
    for i = 1:length(xvec)
        for j = 1:length(yvec)
            for k = 1:length(zvec)
                yin = yparticles(:,i,j,k);
                yout = rk4singlestep(@(t,y)lorenz(t,y,sigma,beta,rho), dt, time, yin);
                yparticles(:,i,j,k) = yout;
            end
        end
    end
    
    % Visualize and store frame
    plot3(yparticles(1,:), yparticles(2,:), yparticles(3,:), 'b.', 'LineWidth', 1, 'MarkerSize', 2)
    xlabel('X-axis');
    ylabel('Y-axis');
    zlabel('Z-axis');
    title(['$\sigma$ = ', num2str(sigma), '; $\beta$ = ', num2str(beta), '; $\rho$ = ', num2str(rho), '; time = ', num2str(time)], 'Interpreter', 'latex')
    view(20,40);
    axis([-40 40 -40 40 -10 40])
    drawnow
    
    F(step) = getframe(gcf);
end

% Create video with dynamic filename
filename = sprintf('sigma=%.2f,beta=%.2f,rho=%.2f.avi', sigma, beta, rho);
video = VideoWriter(filename, 'Uncompressed AVI');
open(video)
writeVideo(video, F);
close(video)
