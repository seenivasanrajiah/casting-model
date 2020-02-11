
        
for iterating = 1:100

T_dummy = T_old;    
    
H_new(1) = H_old(1) + ((K_intf(1)/Dx) * (T_dummy(2) - T_dummy(1)) - (h_interface * (T_dummy(1)-T_mould_temp_input)))/constant_1;

for Node = 2:N_node-1
    
    H_new(Node) = H_old(Node) + (((K_intf(Node)/Dx) * (T_dummy(Node+1) - T_dummy(Node))) - ((K_intf(Node-1) / Dx) * (T_dummy(Node) - T_dummy(Node-1))))/constant_2;

end

H_new(N_node) = H_old(N_node) - ((K_intf(N_node-1) / Dx) * (T_dummy(N_node) - T_dummy(N_node-1)))/constant_1;


for Node=1:N_node
        if (H_new(Node) >= H_liquidus_F_liquid_1)
         T_new(Node)=((-Linear_eqn(1,2)*H_new(Node))+ Linear_eqn(1,3))/Linear_eqn(1,1);   
        elseif (H_liquidus_F_liquid_1 > H_new(Node) && H_new(Node) >= H_solidus_delta_F_1)
         T_new(Node)=((-Linear_eqn(2,2)*H_new(Node))+Linear_eqn(2,3))/Linear_eqn(2,1);
        elseif (H_solidus_delta_F_1 > H_new(Node)&& H_new(Node) >= H_aus_start)
         T_new(Node)=((-Linear_eqn(3,2)*H_new(Node))+Linear_eqn(3,3))/Linear_eqn(3,1);
        elseif (H_aus_start > H_new(Node) && H_new(Node) >= H_aus_F_1 )
         T_new(Node)=((-Linear_eqn(4,2)*H_new(Node))+Linear_eqn(4,3))/Linear_eqn(4,1);
        elseif (H_aus_F_1 > H_new(Node)&& H_new(Node) >= H_alpha_start )
         T_new(Node)=((-Linear_eqn(5,2)*H_new(Node))+Linear_eqn(5,3))/Linear_eqn(5,1);
        elseif (H_alpha_start > H_new(Node)&& H_new(Node) >= H_alpha_F_1 )
         T_new(Node)=((-Linear_eqn(6,2)*H_new(Node))+Linear_eqn(6,3))/Linear_eqn(6,1);
        else
        T_new(Node)=((-Linear_eqn(7,2)*H_new(Node))+Linear_eqn(7,3))/Linear_eqn(7,1);
        end
end

absolute = abs(T_new(:,1)-T_dummy(:,1));

% Difference_in_Temp = abs(T_new(1)-T_dummy(1));

T_old = T_new;

if ( mean2(absolute) > 10e-5)
    break
end

end
 
H_old = H_new;


    