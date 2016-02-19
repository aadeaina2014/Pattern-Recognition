%=========================================================================%
% Florida Insitute of Technology
% Coleege of Engineering
% Electrical and Computer Engineering Department
% ECE 5258   : Pattern Recognition
% Instructor : Dr. Georgios Anagnostopulous
% Semester   : Fall 2015
% Doc ref    : main application driver script for MP1 task3 (Task1.m)
%  (c) Ayokunle Ade-Aina 
%=========================================================================%

clc; clear; close all;
% Define  and draw circle
A = 0.5;
r = sqrt( (A/pi));

% Generate Vectors to plot a circle
resolution = 0.01;
theta = 0:resolution:2*pi; % Define circle vector resolution and vector
x = r* cos (theta); % generate x -coordinate for circle boundary
y = r* sin( theta); % generate y co-ordinates for circle boundary

% Shift Circle to centered postion
ww = x+0.5;
ss = y+0.5;

% define the ratio of flipping of data labels to opposite class
pflip = [0,0.1,0.2,0.3,0.4];


for i =1:  length(pflip)
 % Draw samples from ncis   
data = generateSamples(100, pflip(i));
data = data(1:100,:); % shave off any random added data beyond 100 samples

% Draw Circle BOundary
figure  
plot(ww,ss, 'green.');  
hold on;

% seperate the index of data for different classes
idx1 = find(data(:,3)==1); 
idx2 = find(data(:,3)==2);
% Generate plot for each class in oneshot
plot(data(idx1,1),data(idx1,2),'ro')
plot(data(idx2,1),data(idx2,2),'bo')
title(['FeatureSpace for plfip =  ' num2str(pflip(i)) ]);
xlabel('X1');
ylabel('X2');
hold off;
end

