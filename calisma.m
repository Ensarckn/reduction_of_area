clc; clear all; close all;

  % Video to Frame Convertion
filename= 'ekstansometre.mp4';
Vid = VideoReader(filename)
numFrames = Vid.NumFrames;
n=numFrames;
diameter =[];
k=1;
framenum= 50;

for i = 1:framenum:n
    
    frames = read(Vid,i);
    figure(1),im=image(frames);text(600,100,'RGB','FontSize',15,'FontWeight','bold')
    
    imgray= im2gray(frames);
%     imshow(imgray)
    imgraylocal= imgray(300:700,800:1175);
%     imshow(imgraylocal);
    imbinarizeloc= ~imbinarize(imgraylocal);
    figure(2),imshowpair(imbinarizeloc,imgraylocal,'montage')
    text(400,100,'GRAY','FontSize',15,'FontWeight','bold'),
    text(75,100,'BW','FontSize',15,'Color','w','FontWeight','bold')
    properties= regionprops(imbinarizeloc,'MinFeretProperties');

    
    diameter=[diameter properties.MinFeretDiameter];
    

    
    clc; 
    fprintf('FRAME: %.2f, DIAMETER: %.4f\n',i,diameter(k))
    k = k+1;  

    
end

% plot(diameter)




%-----------
% curvefitting(diameter)
% function [fitresult, gof] = curvefitting(diameter)

diameter(length(diameter))=diameter(length(diameter)-1)    
[xData, yData] = prepareCurveData( [], diameter );

% Set up fittype and options.

ft = fittype( 'smoothingspline' );
opts = fitoptions( 'Method', 'SmoothingSpline' );

% FRAME == 10
% opts.SmoothingParam = 1.01281554667696e-06;
% FRAME == 100
% opts.SmoothingParam = 0.00301007573986167;


% Coefficients:       
p1 =   3.343e-05
p2 =  -0.0003333
f = @(x) p1*x + p2
SmootingParam= (f(framenum))

opts.SmoothingParam = SmootingParam;

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.

figure( 'Name', 'Diameter' );
h = plot( fitresult, xData, yData );
legend( h, 'Diameter', 'Diameter', 'Location', 'Southwest', 'Interpreter', 'none' );

% Label axes

ylabel( 'Diameter', 'Interpreter', 'none' );
grid on   

% optionssmoothY= [1.01281554667696e-06,0.00301007573986167]
% optionssmoothX= [10,100];

% end






%-------------------



