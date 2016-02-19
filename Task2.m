%=========================================================================%
% Florida Institute of Technology
% College of Engineering
% Electrical and Computer Engineering Department
% ECE 5258   : Pattern Recognition
% Instructor : Dr. Georgios Anagnostopulous
% Semester   : Fall 2015 (September 2015)
% Doc Ref    : main appplication driver for  MP I task2 script (main.m)
%  (c) Ayokunle Ade-Aina 
%=========================================================================%

clc; clear; close all;
% Define the surface Area of the circle
A = 0.5 ;
r = sqrt( (A/pi)); % Extract the radius of the circle

% Generate Vectors to plot a circle
theta = 0:0.01:2*pi;
x = r* cos (theta); % generate x -coordinate for circle boundary
y = r* sin( theta); % generate y co-ordinates for circle boundary

% Shift Circle to centered postion
ww = x+0.5;
ss = y+0.5;


sample = generateSamples(100, 0.1);
% load task2dataset.mat;

T = [10,30,50,75,100];

for i = 1: length(T)
    % ensure that generated data does not exceed 100 samples to avoid
    % runtime errors
    sample = sample(1:100,:);
    
    % randomly permute in order to index into 
    pp = randperm(100, T(i));
    
    % get subset of labeled samples
    data =   sample(pp,:);  % Select desired subset of data
    
    
    %Generate a Meshgrid over the feature space this get all possible pair
    %of co-ordinates in the features space for the specified resolution
    x = linspace(0,1,100);
    [XX,YY] = meshgrid(x,x);
    [a,b] = size(XX);
    
    % Reshape  Meshgrid Data into dectors in order to classify each pair of
    % grid co-ordinates
    XX = reshape(XX,a*b,1);
    YY = reshape(YY,a*b,1);
    
    Z = [XX,YY]; % Create Test Pattern for KNN
    k = 5; % set number of nearest neighbors
    p = 2; % set distance metric(Lp norm)
    
    % Classifiy Test Patterns Z (the whole feature space)
    [Ypred,PCP]= knn_classify(Z,data(:,1:2),k,p, 3, data(:,3));
    Ypred = Ypred';
    
    % Reshape Data in order to obtain decision boundary
    XX = reshape(XX,100,100);
    YY = reshape(YY,100,100);
    ZZ = reshape(Ypred,100,100);
    
    
    
    
    figure
    
   %Decision Boundary generated by the classifier
   contourf(XX,YY,ZZ,2); hold on;
    
   plot(ww,ss, 'green.');  % Draw Circle BOundary
    
   idx1 = find(data(:,3)==1);
   idx2 = find(data(:,3)==2);
   
   %Plot Training Samples used for KNN Classification   
   plot(data(idx1,1),data(idx1,2),'ro');
   plot(data(idx2,1),data(idx2,2),'go');
   
    hold off;
    title([num2str(k) 'Nearest classification result using ' num2str(T(i)) ' training samples'])
    

    
end
