function dx = statesystem(x)

mb = 300 %kg
mw = 60 %kg
bs = 1000

dx(1) = x(2);
dx(2) = -1/mb*(ks*(x(1)-x(3))+bs*(x2-x4)-fs);
dx(3) = x(4);
dx(4) = 1/mw *(ks*(x(1)-x(3))+bs*(x2-x4)-kt*(x(3)-r)-fs);


end