classdef twip_sys < matlab.System
    % twip_sys two-wheeled inverted pendulum dynamical system

    properties
        M=0.5;
        Mw=0.8;
        mm=0.5;
        Iw=0.02;
        Ip=0.06;
        Imm=0.08;
        r=0.2;
        l=0.15;
        d=0.6;
    end

    properties (DiscreteState)
    end

    properties (Access = private)
        % Pre-computed constants.
    end

    methods (Access = protected)
        function setupImpl(obj,tl, tr, dl, dr, y1, y2, y3, y4, y5, y6)
            % Implement tasks that need to be performed only once, 
            % such as pre-computed constants.
        end

        function [x, y, xp, v,  alpha, theta, yd1, yd2, yd3, yd4, yd5, yd6] = stepImpl(obj,tl, tr, dl, dr, y1, y2, y3, y4, y5, y6)            
            % unpack variables
            M =     obj.M;
            Mw =    obj.Mw;
            m =     obj.mm;
            Iw =    obj.Iw;
            Ip =    obj.Ip;
            Imm =    obj.Imm;
            r =     obj.r;
            l =     obj.l;
            d =     obj.d;

            % Gravity value
            g = 9.81;
   
            alpha = y1;
            theta = y2;
            v = y6;
            xp = y3;
            x = cos(theta)*v;
            y = sin(theta)*v;            
            
            dpdt = zeros(6, 1);
            yy = [y1, y2, y3, y4, y5, y6];
            % Second order constraint
            dpdt(1) = yy(4);
            dpdt(2) = yy(5);
            dpdt(3) = yy(6);
            
            

            % Differential solutions
            dpdt(4) = -((m*l^2+Imm)*(-m*l*yy(6)^2*sin(yy(3))-tl/r-tr/r-dl-dr)+m^2*l^2*cos(yy(3))*g*sin(yy(3)))...
                        /((m*l^2+Imm)*(M+2*Mw+m+2*Iw/r^2)-m^2*l^2*cos(yy(3))^2);
            dpdt(5) = 2*d*(tl/r-tr/r+dl-dr)/(Ip+(2*(Mw+Iw/r^2))*d^2);
            dpdt(6) = (m*l*cos(yy(3))*(-m*l*yy(6)^2*sin(yy(3))-tl/r-tr/r-dl-dr)+m*g*l*sin(yy(3))*(M+2*Mw+m+2*Iw/r^2))...
                        /((m*l^2+Imm)*(M+2*Mw+m+2*Iw/r^2)-m^2*l^2*cos(yy(3))^2);
                    
            yd1 = dpdt(1);
            yd2 = dpdt(2);
            yd3 = dpdt(3);
            yd4 = dpdt(4);
            yd5 = dpdt(5);
            yd6 = dpdt(6);
        end
        
        function [s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12] = getOutputSizeImpl(~)
            s1 = 1;
            s2 = 1;
            s3 = 1;
            s4 = 1;
            s5 = 1;
            s6 = 1;
            s7 = 1;
            s8 = 1;
            s9 = 1;
            s10 = 1;
            s11 = 1;
            s12 = 1;
        end
        
        function num = getNumInputsImpl(~)
            num = 10;
        end
        
        function num = getNumOutputsImpl(~)
            num = 12;
        end

        function resetImpl(obj)
            % Initialize discrete-state properties.
        end
    end
end
