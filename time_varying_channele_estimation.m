clear all;close all;
%initial conditions
h_(:,1)=[0;0];%initial weights
M_=100*eye(2);%Mmse initial
R=0.1;%observation noise varience
A=[0.99 0;0 0.999];%State matrix constant with time
Q=0.0001*eye(2);%process noise covariance
n=1:1:100;%sampling time
v= 0.5*(1 + square(n));%input to the channel
p=2;%number of weights modelled by the channel
x=zeros(1,100);
y=zeros(1,100);
K=zeros(2,100);
h1=zeros(1,100);
h2=zeros(1,100);
h_1=zeros(1,100);
h_2=zeros(1,100);
K1=zeros(1,99);
K2=zeros(1,99);
%modelling channel coeffiecients to generate channel coeffiecients with
%time
for i=1:100
    h1(i)=-0.006*i+1+randn*(0.0001);
    h2(i)=0.9+randn*(0.0001);
end
h=[h1;h2];
M1=zeros(1,100);
M2=zeros(1,100);
for i= 2:100
    h_(:,i)=A*h_(:,i-1);%process state equation
    y(i)=[v(i) v(i-2+1)]*h(:,i);%actual output
    x(i)=[v(i) v(i-2+1)]*h(:,i)+ R*randn;%measuremnet equation
    %prediction
    h_(:,i)=A*h_(:,i-1);
    M_=A*M_*A'+Q;
    den=R+[v(i) v(i-2+1)]*M_*[v(i) v(i-2+1)]';
    K(:,i)=(M_*[v(i) v(i-2+1)]')/den;
    h_(:,i)=h_(:,i)+K(:,i)*(x(i)-[v(i) v(i-2+1)]*h_(:,i));
    M_=(eye(2)-K(:,i)*[v(i) v(i-2+1)])*M_;
    M1(i)=M_(1,1);
    M2(i)=M_(2,2);
    h_1(i)=h_(1,i);
    h_2(i)=h_(2,i);
    K1(i-1)=K(1,i);
    K2(i-1)=K(2,i);
end
plot(v)
ylim([-1 2])
ylabel('Channel input(v[n])')
xlabel('Sample number,n')
figure
plot(y)
ylim([-1 2])
ylabel('Noiseless Channel output(y[n]')
xlabel('Sample number,n')
figure
plot(x)
ylim([-1 2])
ylabel('Channel input(x[n]')
xlabel('Sample number,n')
figure
plot(h1,'--')
hold on
plot(h_1,'-')
ylabel(' True and estimated tap weight, h1')
xlabel('Sample number,n')
hold off
figure
plot(h2,'--')
hold on
plot(h_2,'-')
ylabel(' True and estimated tap weight, h2')
xlabel('Sample number,n')
hold off
figure
plot(K1)
ylabel('Kalman gain, K1[n]')
xlabel('Sample number,n')
figure
plot(K2)
ylabel('Kalman gain, K2[n]')
xlabel('Sample number,n')
figure
plot(M1)
ylim([0 0.20])
xlim([3 100])
ylabel('Minimum MSE, M11')
xlabel('Sample number,n')
figure
plot(M2)
ylim([0 0.20])
xlim([3 100])
ylabel('Minimum MSE, M22')
xlabel('Sample number,n')



    
    

