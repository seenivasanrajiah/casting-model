No_eqns=length(Linear_eqn);
            for equation=1:No_eqns-1
            T_and_H_values(equation,:)=[Linear_eqn(equation,1) Linear_eqn(equation,2);Linear_eqn(equation+1,1) Linear_eqn(equation+1,2)]\[Linear_eqn(equation,3);Linear_eqn(equation+1,3)];
            end
            
            T_liquidus_liquid_F_1 = T_and_H_values(1,1); %Liquidus Temperature (fraction of liquid phase is 1)
            H_liquidus_F_liquid_1 = T_and_H_values(1,2);  %Enthalphy at liquidus temperature
            T_solidus_delta_F_1 = T_and_H_values(2,1);   %Solidus temperature (fraction of delta phase is 1)
            H_solidus_delta_F_1 = T_and_H_values(2,2);   %Enthalphy at solidus temperature
            T_aus_start = T_and_H_values(3,1);           %Austenite phase starting temperature
            H_aus_start = T_and_H_values(3,2);           %Enthalphy at austenite starting temperature
            T_aus_F_1 = T_and_H_values(4,1);             %Temperature at austenite fraction is 1
            H_aus_F_1 = T_and_H_values(4,2);             %Enthalphy at austenite fraction is 1
            T_alpha_start = T_and_H_values(5,1);         %Alpha phase starting temperature 
            H_alpha_start = T_and_H_values(5,2);         %Enthalphy at alpha starting temperature 
            T_alpha_F_1 = T_and_H_values(6,1);           %Temperature at alpha alpha fraction is 1
            H_alpha_F_1 = T_and_H_values(6,2);           %Enthalphy at alpha fraction is 1
           
            
            % Calculation of initial enthalphy form inlet temperature of metal
            if (Tin >= T_liquidus_liquid_F_1)
              Hin = Linear_eqn(1,1)*Tin - Linear_eqn(1,3);
            elseif (T_liquidus_liquid_F_1 > Tin && Tin >= T_solidus_delta_F_1)
              Hin = Linear_eqn(2,1)*Tin - Linear_eqn(2,3);
            elseif (T_solidus_delta_F_1 > Tin && Tin >= T_aus_start)
              Hin = Linear_eqn(3,1)*Tin - Linear_eqn(3,2);
            elseif (T_aus_start > Tin && Tin >= T_aus_F_1)
              Hin = Linear_eqn(4,1)*Tin - Linear_eqn(4,3);
            elseif(T_aus_F_1 > Tin && Tin >= T_alpha_start)
              Hin = Linear_eqn(5,1)*Tin - Linear_eqn(5,3);
            elseif (T_alpha_start > Tin && Tin >= T_alpha_F_1)
              Hin = Linear_eqn(6,1)*Tin - Linear_eqn(6,3);
            else
              Hin = Linear_eqn(7,1)*Tin - Linear_eqn(7,3);
            end