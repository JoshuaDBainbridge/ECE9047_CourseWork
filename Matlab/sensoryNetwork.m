clear;
numNodes = 12
node = [0.317 0.095;0.675 0.249;0.85 0.113;0.487 0.953;0.981 0.487;0.764 0.66;0.284 0.314;0.042 0.76;0.262 0.768;0.193 0.97;0.984 0.747;0.573 0.527]; 
CommR = 0.3;
SensR= 0.3; 
%{for i=1:numNodes 
%    node(i,1)=rand
%    node(i,2)=rand
%end
figure()
hold on
    scatter(1,1,'x')
    scatter(1,0,'x')
    scatter(0,1,'x')
    scatter(0,0,'x')
    plot([0 0],[0 1],'k-o')
    plot([0 0],[1 0],'k-o')
    plot([1 1],[0 1],'k-o')
    plot([1 1],[1 0],'k-o')
for i=1:numNodes 
    scatter(node(i,1),node(i,2),'x')
end
for y=1:numNodes
    for j=1:numNodes
        Distance(y,j)=sqrt((node(y,1)-node(j,1))^2+(node(y,2)-node(j,2))^2)
    end
end 
c=0
test = 0
k=zeros([numNodes 1])
for i=1:numNodes
    c=c+1
    for y=1:c
        if Distance(i,y)<=CommR
            plot([node(i,1) node(y,1)],[node(i,2) node(y,2)],'b--o')
            k(i)=k(i)+1
        end
    end 
end 
for i=1:numNodes
   th = 0:pi/50:2*pi;
    xunit = SensR * cos(th) + node(i,1);
    yunit = SensR * sin(th) + node(i,2);
    plot(xunit, yunit);
end 

