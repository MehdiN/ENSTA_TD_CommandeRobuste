%% State System

mb=300; %kg
mw=60; %kg
bs=1000;
ks=16000;
kt=190000;


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

figure(1)
bodeplot(sys({'ab','sd'},{'fs','r'}));

%% Incertain System
Wunc=makeweight(0.4,16,20);
unc = ultidyn('unc',[1,1]);
act = tf(1,[1/60 1]);


actSys = act*(1+Wunc*unc);

actSys.InputName ='u';
actSys.OutputName ='fs';
sysTot = connect(actSys,sys,{'r','u'},{'xb','sd','ab'});
figure(2)
bodeplot(sysTot({'ab','sd'},{'u','r'}));


%% H infinity 

Wroad = ss(0.07);
Wroad.InputName = 'd1';
Wroad.OutputName = 'r';

Wact= tf([1,0],[1,1]);
Wact.InputName = 'u';
Wact.OutputName = 'e1';

Wd2 = ss(0.01);
Wd2.InputName = 'd2';
Wd2.OutputName = 'Wd2';

Wd3 = ss(0.5);
Wd3.InputName = 'd3';
Wd3.OutputName = 'Wd3';
