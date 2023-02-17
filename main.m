% MEGN 301 - Computational Analysis of Bulk Shredder Properties
% Michael Allen
% 2/17/2022

clc; clear;  close all;
format short 

%Variables to test
CUTTER_LENGTH = 2:1:8;                 %inches of cutting section 
BLADE_WIDTH = (1/16):(1/16):(.5);      %width of cutting edge
BLADE_HEIGHT = .25:.05:1;              %length of cutting edge
CUTTER_RADIUS = .75:.25:2;             %base radius from which cutters are extended from


%Key metrics to verify
%torqueRequired;     %N*m



%Constants
PLA_SHEAR_STRENGTH = 32.938 * 10^6;    %Pa
PLA_ULTIMATE_STRESS =  57.9 * 10^6;    %Pa
INCH_TO_M = 25.4*10^-3;
NEWTON_METERS_TO_FOOT_POUNDS = 0.7376;



%Testing each vairable

resultsMatrix = zeros(length(CUTTER_LENGTH), length(BLADE_WIDTH), length(BLADE_HEIGHT), length(CUTTER_RADIUS));

for cutterLength = 2:1:8
    for bladeWidth = (1/16):(1/16):(.5)

        numBlades = (cutterLength / bladeWidth);

        for bladeHeight = .25:.05:1
            for cutterRadius = 1:.25:2
                
                bladeArea = bladeWidth * bladeHeight * INCH_TO_M^2; %m^2
                force_on_blades = PLA_ULTIMATE_STRESS * bladeArea * numBlades/3;    %blades orientated such that only 1/3 of blades are in contact at given angle
                torqueRequired = force_on_blades * ((cutterRadius*INCH_TO_M) + (bladeHeight*INCH_TO_M)/2);  %force applied at half of centroid of blade
                
                resultsMatrix(find(CUTTER_LENGTH == cutterLength), find(BLADE_WIDTH==bladeWidth), find(BLADE_HEIGHT==bladeHeight), find(CUTTER_RADIUS==cutterRadius)) = torqueRequired;

            end
        end
    end
end

default_calcs = resultsMatrix(find(CUTTER_LENGTH == 4), find(BLADE_WIDTH == (1/8)), :, :);
disp(default_calcs);

