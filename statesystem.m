%% State System

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
bodeplot(sys({'ab','sd'},{'fs','r'}))

