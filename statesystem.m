%% State System

mb=300; %kg
mw=60; %kg
bs=1000;
ks=16000;
kt=190000;

% <<<<<<< Updated upstream
% dx(1) = x(2);
% dx(2) = -1/mb*(ks*(x(1)-x(3))+bs*(x2-x4)-fs);
% dx(3) = x(4);
% dx(4) = 1/mw *(ks*(x(1)-x(3))+bs*(x2-x4)-kt*(x(3)-r)-fs);
% =======
% 
% >>>>>>> Stashed changes


A = [0 1 0 0;
    -ks/mb -bs/mb ks/mb bs/mb;
    0 0 0 1;
    ks/mw bs/mw -(ks+kt)/mw -bs/mw];

B = [ 0 0;
      0 1/mb;
      0 0;
       kt/mw -1/mw];

C = [1 0 0 0;
    1 0 -1 0;
    -ks/mb -bs/mb ks/mb bs/mb];

D = [0 0;0 0;0 1/mb];

sys = ss(A,B,C,D,'StateName',{'dx1' 'dx2','dx3','dx4'},...
                    'InputName',{'r','fs'},...
                    'OutputName',{'xb','sd','ab'});

tfsys = tf(sys);

                
z1= tzero(sys({'xb','ab'},'fs'));
z2=tzero(sys('sd','fs'));

bodeplot(sys({'ab','sd'},{'fs','r'}));