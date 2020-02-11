%creating coefficient values of each linear equations (aE, aW, aN, aS, aP, Source terms) 

    Area_at_east(1,1) = control_volume_dy/2;
    Area_at_west (1,1)= control_volume_dy/2;
    Area_at_north(1,1) = control_volume_dx/2;
    Area_at_south (1,1)  = control_volume_dx/2;
    
    coefficient_at_east(1,1) = (Conductivity_of_mould * Area_at_west(1,1))/control_volume_dx;
    coefficient_at_west (1,1)= 0;
    coefficient_at_north (1,1)= 0;
    coefficient_at_south (1,1)= (Conductivity_of_mould * Area_at_south(1,1))/control_volume_dy;
    source_from_west(1,1) = h_inter(1) * Area_at_west(1,1);
    source_from_north(1,1) = h_steam * Area_at_north(1,1);
    
    coefficient_at_point(1,1) =  coefficient_at_east(1,1) +  coefficient_at_south(1,1) + source_from_west(1,1) + source_from_north(1,1);
    Total_source (1,1) = (source_from_west(1,1) * T_strand_temp_input(1,1)) + (source_from_north(1,1) * T_mould_top);
 
for y_move =2:No_of_nodes_y_direction-1
         
%     if(y_move < meniscus_nodes)
%         h_input = h_air;
% %         T_input = T_atm;
%     else
%         h_input= 2000;
% %         T_input = T_shell;
%     end

    Area_at_east(2,1) = control_volume_dy;
    Area_at_west (2,1)= control_volume_dy;
    Area_at_north (2,1)= control_volume_dx/2;
    Area_at_south  (2,1)= control_volume_dx/2;
    
    coefficient_at_east(2,1) = (2 * Conductivity_of_mould * Area_at_east(2,1))/control_volume_dx;
    coefficient_at_west (2,1)= 0;
    coefficient_at_north (2,1)= (Conductivity_of_mould *Area_at_north(2,1))/control_volume_dy;
    coefficient_at_south (2,1)= (Conductivity_of_mould * Area_at_south(2,1))/control_volume_dy;
    source_from_west(y_move,1) = 2 * h_inter(y_move) * Area_at_west(2,1);
    
    coefficient_at_point(y_move, 1) =  coefficient_at_east(2,1) + coefficient_at_north(2,1) + coefficient_at_south(2,1) + source_from_west(y_move, 1);
    Total_source(y_move,1) = (source_from_west(y_move,1) * T_strand_temp_input(y_move,1));
end
    Area_at_east(3,1) = control_volume_dy/2;
    Area_at_west (3,1)= control_volume_dy/2;
    Area_at_north(3,1) = control_volume_dx/2;
    Area_at_south (3,1)  = control_volume_dx/2;
    
    coefficient_at_west(3,1) = 0;
    coefficient_at_east (3,1)= (Conductivity_of_mould * Area_at_east(3,1))/control_volume_dx;
    coefficient_at_north (3,1)= (Conductivity_of_mould * Area_at_north(3,1))/control_volume_dy;
    coefficient_at_south (3,1)= 0;
    source_from_west(No_of_nodes_y_direction,1) = h_inter(No_of_nodes_y_direction) * Area_at_west(3,1);
    source_from_south(1,1) = h_steam * Area_at_south(3,1);
    
    coefficient_at_point(No_of_nodes_y_direction,1) =  coefficient_at_east(3,1) + coefficient_at_north(3,1) + source_from_west(No_of_nodes_y_direction,1) + source_from_south(1,1);
    Total_source (No_of_nodes_y_direction,1) = (source_from_west(No_of_nodes_y_direction,1) * T_strand_temp_input(No_of_nodes_y_direction,1)) + (source_from_south(1,1) * T_mould_bottom);
    
    for x_move = 2:No_of_nodes_x_direction-1
        
        Area_at_east(1,2) = control_volume_dy/2;
        Area_at_west (1,2)= control_volume_dy/2;
        Area_at_north(1,2) = control_volume_dx;
        Area_at_south (1,2)  = control_volume_dx;
        
        coefficient_at_east(1,2) = (Conductivity_of_mould * Area_at_east(1,2))/control_volume_dx;
        coefficient_at_west (1,2)= (Conductivity_of_mould * Area_at_west(1,2))/control_volume_dx;
        coefficient_at_north (1,2)= 0;
        coefficient_at_south(1,2)= (2 * Conductivity_of_mould * Area_at_south(1,2))/control_volume_dy;
        source_from_north(1,2) = 2* h_steam * Area_at_north(1,2);

        coefficient_at_point(1,x_move) =  coefficient_at_east(1,2) + coefficient_at_west(1,2) + coefficient_at_south(1,2) + source_from_north(1,2);
        Total_source (1,x_move) = (source_from_north(1,2) * T_mould_top);
        
        for y_move=2:No_of_nodes_y_direction-1
            
            Area_at_east(2,2) = control_volume_dy;
            Area_at_west (2,2)= control_volume_dy;
            Area_at_north(2,2) = control_volume_dx;
            Area_at_south (2,2)  = control_volume_dx;
            
            coefficient_at_east(2,2) = (Conductivity_of_mould * Area_at_east(2,2))/control_volume_dx;
            coefficient_at_west (2,2)= (Conductivity_of_mould * Area_at_west(2,2))/control_volume_dx;
            coefficient_at_north(2,2) = (Conductivity_of_mould * Area_at_north(2,2))/control_volume_dy;
            coefficient_at_south(2,2) = (Conductivity_of_mould * Area_at_south(2,2))/control_volume_dy;
            
            coefficient_at_point(y_move,x_move) =  coefficient_at_east(2,2) + coefficient_at_west(2,2) +coefficient_at_north(2,2) + coefficient_at_south(2,2);
        end
        
        Area_at_east(3,2) = control_volume_dy/2;
        Area_at_west (3,2)= control_volume_dy/2;
        Area_at_north(3,2) = control_volume_dx;
        Area_at_south (3,2)  = control_volume_dx;
        
        coefficient_at_east(3,2) = (Conductivity_of_mould * Area_at_east(3,2))/control_volume_dx;
        coefficient_at_west (3,2) = (Conductivity_of_mould * Area_at_west(3,2))/control_volume_dx;
        coefficient_at_north(3,2) = (2 * Conductivity_of_mould * Area_at_north(3,2))/control_volume_dy;
        coefficient_at_south(3,2) = 0;
        source_from_south(1,2) = 2 * h_steam * Area_at_south(3,2);
        
        coefficient_at_point(No_of_nodes_y_direction, x_move) =  coefficient_at_east(3,2) + coefficient_at_west(3,2) +coefficient_at_north(3,2) + source_from_south(1,2);
        Total_source (No_of_nodes_y_direction, x_move) = source_from_south(1,2) * T_mould_bottom;
                
    end
      
    Area_at_east(1,3) = control_volume_dy/2;
    Area_at_west (1,3)= control_volume_dy/2;
    Area_at_north(1,3) = control_volume_dx/2;
    Area_at_south (1,3)  = control_volume_dx/2;
    
    coefficient_at_east(1,3) = 0;
    coefficient_at_west (1,3)= (Conductivity_of_mould * Area_at_west(1,3))/control_volume_dx;
    coefficient_at_north (1,3)= 0;
    coefficient_at_south (1,3)= (Conductivity_of_mould * Area_at_south(1,3))/control_volume_dy;
    source_from_east(1,1) = h_water_mould * Area_at_east(1,3);
    source_from_north(1,3) = h_steam * Area_at_north(1,3);
    
    coefficient_at_point(1,No_of_nodes_x_direction) =  coefficient_at_west(1,3) + coefficient_at_south(1,3) + source_from_east(1,1) + source_from_north(1,3);
    Total_source (1,No_of_nodes_x_direction) = (source_from_east(1,1) * T_mould_water) + (source_from_north(1,3) * T_mould_top);
 
for y_move =2:No_of_nodes_y_direction-1
    
    Area_at_east(2,3) = control_volume_dy;
    Area_at_west (2,3)= control_volume_dy;
    Area_at_north (2,3)= control_volume_dx/2;
    Area_at_south  (2,3)= control_volume_dx/2;
    
    coefficient_at_east(2,3) =0;
    coefficient_at_west (2,3)= (2 * Conductivity_of_mould * Area_at_west(2,3))/control_volume_dx;
    coefficient_at_north (2,3)= (Conductivity_of_mould *Area_at_north(2,3))/control_volume_dy;
    coefficient_at_south (2,3)= (Conductivity_of_mould * Area_at_south(2,3))/control_volume_dy;
    source_from_east(y_move,1) = 2 * h_water_mould * Area_at_east(2,3);
    
    coefficient_at_point(y_move, No_of_nodes_x_direction) =  coefficient_at_west(2,3) + coefficient_at_north(2,3) + coefficient_at_south(2,3) + source_from_east(y_move,1);
    Total_source(y_move,No_of_nodes_x_direction) = (source_from_east(y_move,1) * T_mould_water);
end
    Area_at_east(3,3) = control_volume_dy/2;
    Area_at_west (3,3)= control_volume_dy/2;
    Area_at_north(3,3) = control_volume_dx/2;
    Area_at_south (3,3)  = control_volume_dx/2;
    
    coefficient_at_east(3,3) = 0;
    coefficient_at_west (3,3)= (Conductivity_of_mould * Area_at_west(3,3))/control_volume_dx;
    coefficient_at_north (3,3)= (Conductivity_of_mould * Area_at_north(3,3))/control_volume_dy;
    coefficient_at_south (3,3)= 0;
    source_from_east(No_of_nodes_y_direction,1) = h_water_mould * Area_at_east(3,3);
    source_from_south(1,3) = h_steam * Area_at_south(3,3);
    
    coefficient_at_point(No_of_nodes_y_direction,No_of_nodes_x_direction) =   coefficient_at_west(3,3) + coefficient_at_north(3,3) + source_from_east(No_of_nodes_y_direction,1) + source_from_south(1,3);
    Total_source (No_of_nodes_y_direction,No_of_nodes_x_direction) = (source_from_east(No_of_nodes_y_direction,1) * T_mould_water) + (source_from_south(1,3) * T_mould_bottom);