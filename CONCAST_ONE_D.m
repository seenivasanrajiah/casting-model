clc
clear all
tic

%---------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
                                      %Information_about_strand
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------%

%operation parameter
T_pour = 273 + 1534 - 5 + 25;
Tin = T_pour;
Casting_speed_in_m_min = 1.2;                            % in m/min
Casting_speed = Casting_speed_in_m_min/60;               % in m/second
meniscus_level = 0.100;                                  %in m
%-----------------------------------------------------------------------------------------------------------------------------------------------------%
%Import machine details

Data =  xlsread('Machine_structure_with_zone_cooling.xlsx');
Distance_from_mould = Data(:,1)-meniscus_level;                          % in mm
water_flow_rate = Data(:,2);                              % flow rate of water in each nozzle (L/m^2 s)
Length_of_machine = Data(length(Data))-meniscus_level;    % last value of machine length


h_spray = 0;
h_rad   = 0;

start = 1;

%-------------------------------------------------------------------------------------------------------------------------------------------------------%

%Information about Mould

%Mould Dimensions
Length_of_mould = 0.900;       % in m
Thickness_of_mould = 0.047;    % in m

control_volume_dx = 0.001;
control_volume_dy = control_volume_dx;

No_of_nodes_x_direction = round(Thickness_of_mould / control_volume_dx)+1;        %nodes in thickness direction
No_of_nodes_y_direction = round(Length_of_mould / control_volume_dy)+1;           %nodes in length direction

%-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

%Material property
Conductivity_of_mould = 315;       %W/mK

%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

                                             %Meshing
Model_domain = 110e-3;                                      %Half thickness of the cast slab;
N_node = 100;
Dx = Model_domain/(N_node-1);                               % in m

%Transient parameter
Dt = 0.001;
Total_time_of_strand_in_mould = (Length_of_mould - meniscus_level)/Casting_speed;                        % in Second
No_of_time_step_in_mould = Total_time_of_strand_in_mould/Dt;

Total_time_of_strand_in_machine = (Length_of_machine - meniscus_level)/Casting_speed;
No_of_time_step_in_machine = Total_time_of_strand_in_machine/Dt;

%--------------------------------------------------------------------------------------------------------------------------------------------------------------------%
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------%

%Memory allocation

H_old = zeros(1,N_node);
H_new = zeros(1,N_node);
T_old = zeros(1,N_node);
T_new = zeros(1,N_node);

K_intf=zeros(1,N_node-1);                                    %Conductivity at the interface
F_liq=zeros(1,N_node);                                       % Fraction of liquid 
F_delta = zeros(1,N_node);                                   % Fraction of delta phase
F_aus = zeros(1,N_node);                                     % Fraction of austenite phase
F_alpha = zeros(1,N_node);                                   % Fraction of alpha phase

%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

%Steel_property
steel_density = 7600;

%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%
%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

% constants involved in strand discretization

constant_1 = (steel_density * Dx)/(2*Dt);
constant_2 = constant_1 * 2;

%-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%
%-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%
%Input grade details as a linear equation

Linear_eqn =[%T    H   =  C 
            824.71   -1	196839     %Linear equation for complete liquid from Temperature vs Enthalphy plot
            8516.91 -1	14073400 %Linear equation for liquid + delta phase
            733.68	-1	275173     %Linear equation for complete delta phase
            1274.19	-1	1214900    %Linear equation for delta phase + austenite phase
            648.3	-1	152789     %Linear equation for complete austenite phase
            970.5	-1	522160     %Linear equation for austenite phase + alpha phase
            687.02	-1	263989];   %Linear eqiuation for alpha phase

 Call_linear_equation               %calculation of Temperature and Enthalphy at liquidus and solidus temperatureSSS

%-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%
%-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%
%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%


%Boundary conditions
%Heat transfer coefficients

Heat_transfer_coefficient_for_mould_cooling_water

h_steam = 20;                         %W/m2K
h_air = 10;                           %W/m2K

%Boundary temperatures
T_mould_water  = 273+32;                 % in K
T_mould_top    = 273+30;                 % in K
T_mould_bottom = 273+30;                 % in K
T_shell        = 273+1530;               % in K
T_atm          = 273+40;                 % in K
T_spray        = 273+30;                 % in K
%-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

                                                              %Memory allocation
%total number of equation for 2-D is nine. therefore (3*3) matrix is
%sufficinet for the storage of Area od control volume. similarly it is
%applicable to coefficient at each faces.
Area_at_east = zeros(3,3);     
Area_at_west = zeros(3,3);
Area_at_north = zeros(3,3);
Area_at_south =zeros(3,3);

coefficient_at_east = zeros(3,3);
coefficient_at_west = zeros(3,3);
coefficient_at_north = zeros(3,3);
coefficient_at_south = zeros(3,3);

%source from north and south is haveing only three numerical values
%corresponding to the usuage of 3 discritised equations (south and north)
source_from_north = zeros(1,3);
source_from_south = zeros(1,3);

%source from east and west is correcponding to the heat flux from liquid
%steel and mould cooling water respectively. it is necessary to allocate
%memory for whole rows in y_direcrion(length_direction)to capture the
%change in mould temperature from the steel shell temperature.
source_from_east = zeros(No_of_nodes_y_direction,1);
source_from_west = zeros(No_of_nodes_y_direction,1);

%allocating memory for all coefficient at P (aP) and respective source term
coefficient_at_point = zeros(No_of_nodes_y_direction, No_of_nodes_x_direction);
Total_source = zeros(No_of_nodes_y_direction, No_of_nodes_x_direction);

T_mould_old= T_mould_water * ones(No_of_nodes_y_direction, No_of_nodes_x_direction);
T_mould = T_mould_water * ones(No_of_nodes_y_direction, No_of_nodes_x_direction);

T_strand_temp_input = zeros(No_of_nodes_y_direction,1);

h_inter = zeros(No_of_nodes_y_direction,1);

heat_flux_old = zeros(No_of_nodes_y_direction,1);
heat_flux_new = zeros(No_of_nodes_y_direction,1);


meniscus_nodes = round(meniscus_level /control_volume_dy) + 1;
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%


Heat_transfer_coefficient_compute

Initial_boundary_conditions_for_mould_compute

Create_coefficients_for_2D_mould                          %Creating coefficient matrix for 2D mould - (aE, aW, aN, aS, aP, Source terms)

%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

count = 0;


print_counter = 0;


for run=1:100
    

mould_temp_nodes_count = round(meniscus_level/control_volume_dy)+1;    

Mould_simulation

for Node=1:N_node 
    T_old(Node)=Tin;
    H_old(Node)=Hin;                                       %Enthalphy of liquid at each node is same in initial stage
end 
    
fid1=fopen('TemperatureProfile.txt','w');
fid2=fopen('Fraction_of_solid.txt','w');
fid3=fopen('Z_position.txt','w');

%------------------------------------------------------------------------------------------------------%
%------------------------------------------------------------------------------------------------------%
    fprintf(fid3,'%6.6f\t', 0);
    for i=1:N_node;
      fprintf(fid1, '%6.6f\t', T_old(i));
      fprintf(fid2, '%6.6f\t',1);
    end;
    fprintf(fid1,'\r\n');
    fprintf(fid2,'\r\n');
    fprintf(fid3,'\r\n');
%------------------------------------------------------------------------------------------------------%
%------------------------------------------------------------------------------------------------------%

for counting_time=1:No_of_time_step_in_mould


print_counter = print_counter + 1;    
    
    
Z_position = (Casting_speed * (counting_time*Dt));

T_mould_temp_input = T_mould_old(mould_temp_nodes_count, 1);

h_interface = h_inter(mould_temp_nodes_count,1);

Thermal_conductivity_at_interface_Compute;

Enthalpy_compute;

%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%Writing Temperature values

if(print_counter ==100);
    fprintf(fid3,'%6.6f\t', Z_position);
    for i=1:N_node
      fprintf(fid1, '%6.6f\t', T_old(i));
      fprintf(fid2, '%6.6f\t',F_liq(i));
    end;
    fprintf(fid1,'\r\n');
    fprintf(fid2,'\r\n');
    fprintf(fid3,'\r\n');
    print_counter = 0;
end;
    
%-------------------------------------------------------------------------%
%--------------------------------------------------------------------------%

if(((Z_position + meniscus_level)/control_volume_dy) >= mould_temp_nodes_count)
   
    mould_temp_nodes_count = mould_temp_nodes_count + 1;
    
    count= count+1;
    
    T_strand_temp_input(mould_temp_nodes_count,1) = T_old(1);
           
end

end

fclose(fid1);
fclose(fid2);
fclose(fid3);

Heat_flux_at_interface_compute;

Heat_flux_difference=mean2(heat_flux_old-heat_flux_new)


if (abs(Heat_flux_difference) < 10);
    
    display('mould_calculation_over');
    
    break;
    
end;

heat_flux_old = heat_flux_new;

Update_coefficients_for_2D_mould

Heat_transfer_coefficient_compute

end

%Solid_liquid_slag_layer_thickness_compute


% print_counter = 0;
% 
% fid1=fopen('TemperatureProfile.txt','a+');
% fid2=fopen('Fraction_of_solid.txt','a+');
% fid3=fopen('Z_position.txt','a+');


% for counting_time = (No_of_time_step_in_mould+1): No_of_time_step_in_machine 
% 
% 
% print_counter = print_counter + 1;        
%     
%     
% T_surf = T_old(1);    
%     
% Z_position = (Casting_speed * (counting_time*Dt));
% 
% H_transfer_coefficient_in_machine_compute;
% 
% h_interface = h;
% 
% Thermal_conductivity_at_interface_for_machine_Compute;
% 
% Enthalpy_compute;
% 
% %-------------------------------------------------------------------------%
% %-------------------------------------------------------------------------%
% %Writing Temperature values
% 
% if(print_counter == 100);
%     fprintf(fid3,'%6.6f\t', Z_position);
%     for i=1:N_node
%         fprintf(fid1, '%6.6f\t', T_old(i));
%         fprintf(fid2, '%6.6f\t',F_liq(i));
%     end;
%     fprintf(fid1,'\r\n');
%     fprintf(fid2,'\r\n');
%     fprintf(fid3,'\r\n');
%     print_counter = 0;
% end;
% %-------------------------------------------------------------------------%
% %--------------------------------------------------------------------------%
% end
% 
% display('machine_calculation_over');
% 
% fclose(fid1);
% fclose(fid2);
% fclose(fid3);

toc

%---------------------------------------------------------------------------------------------------%
%---------------------------------------------------------------------------------------------------%
%---------------------------------------------------------------------------------------------------%
%------Plotting Results---------%

Location_of_strand = load('Z_position.txt');

%Strand_temperature_plot
Strand = load('TemperatureProfile.txt');
figure(1)
plot(Location_of_strand(:,1), Strand(:,1)-273);

% %Shell_thickness_plot
% Shell_formation = zeros(length(Location_of_strand), 1);
% Shell_thickness = load('Fraction_of_solid.txt');
% 
% for row = 1:length(Location_of_strand(:,1));
%     
%     shell = 0;
%     
%     for Node = 2 : N_node;  
%         
%     if (Shell_thickness(row,Node) <= 0.1);
%         
%       shell = shell + Dx;
%       
%     end;
%     
%     Shell_formation(row) = shell;
%     
%     end;
% end;
% 
% figure(2)
% plot(Location_of_strand(:,1), Shell_formation(:,1));


% %Mould_temperature_calculation
% for i= 1:length(T_mould_old(:,1))
%     figure(3)
%     plot(i, T_mould_old(i,1)-273, '*')
%     hold on
% end

%---------------------------------------------------------------------------------------------------------%
%---------------------------------------------------------------------------------------------------------%
%---------------------------------------------------------------------------------------------------------%



% print_counter = print_counter + 1;

% if(print_counter ==1000)
%      %fprintf(fid1,'%6.6f\t', counting_time*Dt)
% %      for i=1:N_node
%          
%          figure(1)
% %          contourf(T_old)
%          plot( Z_position, T_old(1), '*')
%          hold on
%          
% %      fprintf(fid1, '%6.6f\t', T_old(i))
% %      end
% %      fprintf(fid1,'\r\n');
%      print_counter = 0;
%  end


% print_counter = 0;

% fclose(fid1);




% fid1=fopen('TemperatureProfile.txt','w');


% fprintf(fid,'%6.6f %6.6f\n\t', Z_position*1000, T_old(1));




   

