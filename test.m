% MEGN 301 - Computational Analysis of Bulk Shredder Properties
% Michael Allen
% 2/17/2022

clc; clear;  close all;
format short 

%Variables to test
CUTTER_LENGTH = 4;                 %inches of cutting section 
BLADE_WIDTH = 1/8;      %width of cutting edge
BLADE_HEIGHT = .25:.05:1;              %length of cutting edge
CUTTER_RADIUS = .75:(1/8):2 + (5/8);             %base radius from which cutters are extended from
numBlades = floor(CUTTER_LENGTH / BLADE_WIDTH);

%Key metrics to verify
%torqueRequired;     %N*m



%Constants
PLA_SHEAR_STRENGTH = 32.938 * 10^6;    %Pa
PLA_ULTIMATE_STRESS =  57.9 * 10^6;    %Pa
INCH_TO_M = 25.4*10^-3;
NEWTON_METERS_TO_FOOT_POUNDS = 0.7376;



%Testing each vairable
bladeArea = BLADE_WIDTH * BLADE_HEIGHT * INCH_TO_M^2; %m^2
force_on_blades = PLA_ULTIMATE_STRESS * bladeArea * numBlades/3;    %blades orientated such that only 1/3 of blades are in contact at given angle
torqueRequired = force_on_blades .* ((CUTTER_RADIUS.*INCH_TO_M) + (BLADE_HEIGHT.*INCH_TO_M)/2);  %force applied at half of centroid of blade

disp(torqueRequired);
