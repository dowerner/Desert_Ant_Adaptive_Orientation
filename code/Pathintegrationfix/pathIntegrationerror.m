lengthArm1 = 10;
lengthArm2 = 5;
dt = 1;
printFlag = false;

N=18;
error=zeros(N+1);
angle= zeros(N+1);
for ii=0:N
alpha=ii*180/N;   
angle(ii+1)=alpha;
error(ii+1)=twoArmGlobalVectorAnimation(deg2rad(alpha),lengthArm1,lengthArm2,dt,printFlag);

end
figure
error=error.*360/(2*pi);
plot(angle,error);
xlabel('alpha');
ylabel('error');