M = 0.5;
m = 0.2;
b = 0.1;
l = 0.3;
I = 0.006;
g = 9.8;

p = I*(M+m)+M*m*l^2;

A = [0      1              0           0;
     0 -(I+m*l^2)*b/p  (m^2*g*l^2)/p   0;
     0      0              0           1;
     0 -(m*l*b)/p       m*g*l*(M+m)/p  0];
 
B = [     0;
     (I+m*l^2)/p;
          0;
        m*l/p];

C = [1 0 0 0;
     0 0 1 0];

D = [0;
     0]; 
 
 
 
states = {'x' 'x_dot' 'theta' 'theta_dot'};
inputs = {'u'};
outputs = {'x'; 'phi'};
%sys = ss(A,B,C,D);
 
 sys_ss = ss(A,B,C,D,'statename',states,'inputname',inputs,'outputname',outputs);

poles = eig(A);

co = ctrb(sys_ss);

controllability = rank(co);

%eigs = [  -5.5978 + 0.4070i, -5.5978 - 0.4070i, -0.8494 + 0.8323i, -0.8494 - 0.8323i];

Q = C'*C;
Q(1,1) = 1000;
Q(3,3) = 20;
R = 1;

%K = place(A,B,eigs);

K = lqr(A,B,Q,R);


%Cn = [1 0 0 0];
%sys_ss = ss(A,B,Cn,0);
%N = rscale(sys_ss,K);

Ac = [(A-B*K)];
Bc = [B];
Cc = [C];
Dc = [D];

states = {'x' 'x_dot' 'phi' 'phi_dot'};
inputs = {'r'};
outputs = {'x'; 'phi'};


%sys_cl = ss(Ac,Bc*N,Cc,Dc,'statename',states,'inputname',inputs,'outputname',outputs);
sys_cl = ss(Ac,Bc,Cc,Dc,'statename',states,'inputname',inputs,'outputname',outputs);


t = 0:0.01:3;
r = 0.4*ones(size(t));
[y,t,x]=lsim(sys_cl,r,t);
[AX,H1,H2] = plotyy(t,y(:,1),t,y(:,2),'plot');
set(get(AX(1),'Ylabel'),'String','cart position (m)')
set(get(AX(2),'Ylabel'),'String','pendulum displacement (rads)')
xlabel('Time (seconds)');
title('Step Response with Linear-Quadratic Regulator');
 
 
 
 