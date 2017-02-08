%% State System
clear all
clc
close all

mb=300; %kg
mw=60; %kg
bs=1000; %N/m/s
ks=16000; %N/m
kt=190000; %N/m

A = [0      1      0         0;
    -ks/mb -bs/mb  ks/mb     bs/mb;
     0      0      0         1;
     ks/mw  bs/mw -(ks+kt)/mw -bs/mw];

B = [ 0      0;
      0      1/mb;
      0      0;
      kt/mw -1/mw];

C = [1      0     0     0;
     1      0    -1     0;
    -ks/mb -bs/mb ks/mb bs/mb];

D = [0 0    ;
     0 0    ;
     0 1/mb];

sys = ss(A,B,C,D);
sys.InputName = {'r','fs'};
sys.OutputName = {'xb','sd','ab'};

z_sys1 = tzero( sys({'xb','ab'},'fs') );
z_sys2 = tzero( sys('sd','fs') );

tfsys = tf(sys);

figure;
bodeplot(sys({'ab','sd'},{'fs','r'}))

%% Hydrolique

act = tf(1,[1/60 1])
% actSys = tf2ss(act)

Wunc = makeweight(0.4,15,20)
unc = ultidyn('unc',[1 1])
actSys = act*(1+Wunc*unc)

actSys.InputName = {'u'}
actSys.OutputName = {'fs'}

figure;
bodeplot(actSys,act,'r-+')

sysTot = connect(sys,actSys,{'r','u'},{'xb','sd','ab'})

figure;
bodeplot(sysTot)

%% H infini 
Wroad = ss(0.07)
Wroad.u = 'd1'
Wroad.y = 'r'

Wact = tf([1 0],[1 1]) % filtre passe bas de 1/(1/500*p + 1)
Wact.u = 'u'
Wact.y = 'e1'

Wd2 = ss(0.01)
Wd2.u = 'd2'
Wd2.y = 'Wd2'

Wd3 = ss(0.5)
Wd3.u = 'd3'
Wd3.y = 'Wd3'

%% Question 8

HandlingTarget = 0.04 * tf([1/8 1],[1/80 1]);
ComfortTarget = 0.4 * tf([1/0.45 1],[1/150 1]);
Targets = [HandlingTarget; ComfortTarget];

%% Question 9

bodemag(sysTot({'sd','ab'},'r')*Wroad,'b',Targets,'r--',{1,1000})
grid, title('Response to road disturbance')
legend('Open-loop','Closed-loop target')
%

%% Question 10
