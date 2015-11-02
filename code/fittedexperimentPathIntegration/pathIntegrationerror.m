lengthArm1 = 10;
lengthArm2 = 5;
dt = 1;
printFlag = false;
%k=4*10^(-3);

N=18;
error=zeros(N+1,5);
angle= zeros(N+1);
figure
hold on
k=zeros(5);
for j=1:5
    k(j)=( 2*rand(1,1))*4*10^(-3);
for ii=0:N
alpha=ii*180/N;   
angle(ii+1,j)=alpha;
error(ii+1,j)=twoArmGlobalVectorAnimation(deg2rad(alpha),lengthArm1,lengthArm2,dt,printFlag,k(j));
%3k would fit to good, so we choose 2k
end
error(:,j)=error(:,j).*360/(2*pi);
plot(angle(:,j),error(:,j));

end 
error=error.*360/(2*pi);
%plot(angle,error);
xlabel('alpha');
ylabel('error');
