format shortG

% Step 1: Setup the system to determine A, B, C and D
% Here is an example for a reversed pendulum
M = 0.5;
m = 0.2;
b = 0.1;
I = 0.006;
g = 9.8;
l = 0.3;

p = I*(M+m)+M*m*l^2; %denominator for the A and B matrices

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

% Step 2.1: Create a steady state system for our system
states = {'x' 'x_dot' 'phi' 'phi_dot'};
inputs = {'u'};
outputs = {'x'; 'phi'};

sys_ss = ss(A,B,C,D,'statename',states,'inputname',inputs,'outputname',outputs);

Ts = 1/100;

% Step 2.2: c2d, continuous to discrete produces discrete steady state
sys_d = c2d(sys_ss,Ts,'zoh');

% Step 2.3: Generating controllability and obervability matrix
co = ctrb(sys_d);
ob = obsv(sys_d);

% Step 2.4: Getting rank of controllability and observability
% Ensure rank(co) == rank(ob) == # of system states
controllability = rank(co);
observability = rank(ob);

display(observability)
display(controllability)
% Since observability == controllability == # of system sates == 4, hence,
% this we can use lqr!

% Step 3: Computing K (Optimal Gain Matrix) and G (Luenberger Observer)
A = sys_d.a; 
B = sys_d.b;
C = sys_d.c;
D = sys_d.d;
Q = C'*C;
Q(1,1) = 5000;
Q(3,3) = 100;
R = 1;
[K] = dlqr(A,B,Q,R); % Computing discrete lqr (since our steady state is now discrete)

Ac = [(A-B*K)];
Bc = [B];
Cc = [C];
Dc = [D];

Nbar = -61.55;

poles = eig(A-B*K);
P = [-0.2 -0.21 -0.22 -0.23];
G = place(A',C',P)'; % Computing luenberger observer

% Step 4: Computing our generated T matrix using our data after observer
T1 = -1*K*G;
T2 = K*G*C+(-1*K);
T3 = (A-B*K)*G;
T4 = (A-B*K)-(A-B*K)*G*C;

T12 = cat(2,T1,T2);
T34 = cat(2,T3,T4);
T = cat(1,T12,T34);
% This will be the T matrix used as an input to the accelerator alongside
% the current state and output of the robot.    