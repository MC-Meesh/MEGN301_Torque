% MEGN 301 - Computational Analysis of Bulk Shredder Properties
% Michael Allen
% 2/17/2022

clc; clear;  close all;
format short 

%Variables to test
CUTTER_LENGTH = 3;                   %inches of cutting section 
BLADE_WIDTH = .25;                       %width of cutting edge, plate steel to be used
BLADE_HEIGHT = .25;                %length of cutting edge
CUTTER_RADIUS = .75:(1/8):2;             %base radius from which cutters are extended from
MATERIAL_THICKNESS = .0125:.025:.25;

%Key metrics to verify
%torqueRequired; %[N*m]

%Constants
PLA_SHEAR_STRENGTH = 32.938 * 10^6;    %Pa
%PLA_ULTIMATE_STRESS =  57.9 * 10^6;    %Pa
INCH_TO_M = 25.4*10^-3;
NEWTON_METERS_TO_FOOT_POUNDS = 0.7376;
MOTOR_POWER = 120 * 3.2;
MOTOR_SPEED = 1725; 
MOTOR_TORQUE = 9.5488 * MOTOR_POWER / MOTOR_SPEED;
POSSIBLE_REDUCTION = 80;

%Testing cutter radius and blade height vairables
resultsMatrix = zeros(length(MATERIAL_THICKNESS), length(CUTTER_RADIUS), length(CUTTER_LENGTH));

for length_i = CUTTER_LENGTH
    numBlades = floor(length_i / (2*BLADE_WIDTH));

    resultsMatrix_i = zeros(length(MATERIAL_THICKNESS), length(CUTTER_RADIUS));
    
    for radius_i = CUTTER_RADIUS
        cuttingArea = (BLADE_WIDTH + 2 * BLADE_HEIGHT) * INCH_TO_M^2 .* MATERIAL_THICKNESS; %m^2
        force_on_blades = PLA_SHEAR_STRENGTH * cuttingArea * numBlades/3;    %blades orientated such that only 1/3 of blades are in contact at given angle
        torqueRequired = force_on_blades .* ((radius_i*INCH_TO_M) + (BLADE_HEIGHT.*INCH_TO_M)/2);  %force applied at half of centroid of blade
        resultsMatrix_i(:,find(CUTTER_RADIUS==radius_i)) = torqueRequired;
    end
    resultsMatrix(:,:, find(CUTTER_LENGTH == length_i)) = resultsMatrix_i;
end

%disp(resultsMatrix);
torqueRequired = resultsMatrix;
reductionRequired =  resultsMatrix ./ MOTOR_TORQUE;

for cutter_length = 1:length(CUTTER_LENGTH)

    curr_len = CUTTER_LENGTH(cutter_length);

    %Plot Torque needed
    figure('Name', 'Cutter Radius + Material Thickness to Torque')  %initalize first figure
    hold on
    title(sprintf('Cutter Radius + Material Thickness to Torque for %.1f" of length', curr_len));
    xlabel('Cutter Radius [in]');
    xlim([.5 2.5]);
    ylabel('Torque [N*m]');
    plot(CUTTER_RADIUS,resultsMatrix(:,:,cutter_length));
    LEGEND = cell(length(MATERIAL_THICKNESS), 1);
    for num = 1:length(MATERIAL_THICKNESS)
        LEGEND{num} = strcat(num2str(MATERIAL_THICKNESS(num)), '"') ;
    end
    leg = legend(LEGEND);
    title(leg, 'Material Thickness')
    hold off
    
    %Plot gear reduction needed
    figure('Name', 'Reduction required for given Torque')  %initalize second figure
    hold on
    title(sprintf('Reduction Required for %.1f" section', curr_len));
    xlabel('Cutter Radius [in]');
    xlim([.5 2.5]);
    ylabel('Gear reduction from motor [x:1]');
    plot(CUTTER_RADIUS, reductionRequired(:,:,cutter_length));

    plot(CUTTER_RADIUS, (CUTTER_RADIUS ./ CUTTER_RADIUS) * POSSIBLE_REDUCTION, 'r')
    

    LEGEND = cell(length(MATERIAL_THICKNESS)+1, 1);
    for num = 1:length(MATERIAL_THICKNESS)
        LEGEND{num} = strcat(num2str(MATERIAL_THICKNESS(num)), '"') ;
    end

    LEGEND{end} = strcat(num2str(POSSIBLE_REDUCTION), ':1');
    leg = legend(LEGEND);
    title(leg, 'Material Thickness')

    hold off


end