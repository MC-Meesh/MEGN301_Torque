% MEGN 301 - Computational Analysis of Bulk Shredder Properties
% Michael Allen
% 2/17/2022

clc; clear;  close all;
format short 

%Variables to test
cutterLength = 2:1:8;                 %inches of cutting section 
bladeWidth = (1/16):(1/16):(.5);      %width of cutting edge
bladeHeight = .25:.05:1;              %length of cutting edge
cutterDiameter = ();                  %base diameter from which cutters are extended from

%Key metrics to verify
torqueRequired;     %N*m

%Constants
PLA_SHEAR_STRENGTH = 32.938;    %MPa
PLA_ULTIMATE_STRESS =  57.9;    %MPa
INCH_TO_M = 25.4*10^-3;
NEWTON_METERS_TO_FOOT_POUNDS = 0.7376;



%Testing each vairable


bladeArea = bladeWidth * bladeHeight;
force_on_blade = PLA_ULTIMATE_STRESS * bladeArea;
torqueRequired = force_on_blade * (cutterDiameter + cutterHeight/2);  %force applied at half of centroid of blade


