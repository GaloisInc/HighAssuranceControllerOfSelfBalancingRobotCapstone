% Dynamics of a WIP System
% Ethan Lew
% 1/24/19 
% Reference:    Z. Li et al, Advanced Control of Wheeled Inverted Pendulums
%               Springer-Verlag London 2013

function dynamics()
    %% Robot parameters 
    % M     Mass of the platform
    % Mw    Mass of the wheel
    % m     Mass of the pendulum
    % Iw    Moment of inertia of the wheel with respect to the y-axis
    % Ip    Moment of inertia of the platform and the pendulum with respect
    %       to the z-axis
    % r     Radius of the wheel
    % l     Distance from point O to COG
    % tl,tr Torques provided by the wheel actuators on the left and right
    %       wheels
    % dl,dr External forces acting on the left and the right wheel
    % d     Distance between the left and right wheels
    rbt = containers.Map({'M', 'Mw', 'm', 'Iw', 'Ip', 'IM', 'r', 'l', 'tl', 'tr', 'dl', 'dr', 'd'},...
                         [1.0, 0.25, 0.75, 0.02, 0.01, 0.02, 0.2, 1, 0.3, 0.3, 0.0, 0.0, 0.5]);
                     
    %% Generalized coordinates from Lagrangian analysis
    % q variables
    % x     Position that the robot can realize translation (forward / backward)
    % theta spin of the robot
    % alpha tilt of the robot
    % qp variables
    % v     Speed of the robot
    % omega angular velocity of the robot's spin
    % ap    angular velocity of the robot's tilt
    q = [0, 0, 0]';
    qp = [0, 0.1, 0.5]';
    
    %% Convert system to system of first order ODEs
    p = [q; qp];
    
    %% ODE solver with Runge-Kutta using Dormand Prince Weights
    tspan = [0, 10];
    [t, p] = ode45(@(t, y) ksys(t, y, rbt), tspan, p);
    
    %% Plot the results
    plot(t, p(:, 3), t, p(:, 2));
    title('TWIP Dynamics', 'Interpreter', 'latex')
    legend({'Tilt Angle', 'Yaw Angle'}, 'Interpreter', 'latex')
    xlabel('Time (s)', 'Interpreter', 'latex');
    ylabel('Angle (rad)', 'Interpreter', 'latex');
    grid on
end

function dpdt = ksys(t, y, rbt)
    % Input:    p = [q, qp]
    % Output:   pp = [qp, qpp];
    
    % unpack variables
    M =     rbt('M');
    Mw =    rbt('Mw');
    m =     rbt('m');
    Iw =    rbt('Iw');
    Ip =    rbt('Ip');
    Imm =    rbt('IM');
    r =     rbt('r');
    l =     rbt('l');
    tl =    rbt('tl');
    tr =    rbt('tr');
    dl =    rbt('dl');
    dr =    rbt('dr');
    d =     rbt('d');
    
    % Gravity value
    g = 9.81;
    
    
    dpdt = zeros(6, 1);
    % Second order constraint
    dpdt(1) = y(4);
    dpdt(2) = y(5);
    dpdt(3) = y(6);
    
    % Differential solutions
    dpdt(4) = -((m*l^2+Imm)*(-m*l*y(6)^2*sin(y(3))-tl/r-tr/r-dl-dr)+m^2*l^2*cos(y(3))*g*sin(y(3)))...
				/((m*l^2+Imm)*(M+2*Mw+m+2*Iw/r^2)-m^2*l^2*cos(y(3))^2);
    dpdt(5) = 2*d*(tl/r-tr/r+dl-dr)/(Ip+(2*(Mw+Iw/r^2))*d^2);
    dpdt(6) = (m*l*cos(y(3))*(-m*l*y(6)^2*sin(y(3))-tl/r-tr/r-dl-dr)+m*g*l*sin(y(3))*(M+2*Mw+m+2*Iw/r^2))...
				/((m*l^2+Imm)*(M+2*Mw+m+2*Iw/r^2)-m^2*l^2*cos(y(3))^2) ;
end