clear;
%load 'Graph_250869629.txt'
%%ADD TWO node 
%Graph_250869629(26,1)=0.7115
%Graph_250869629(26,2)=0.2085
%Graph_250869629(27,1)=0.23
%Graph_250869629(27,2)=0.4405
node = [0.317 0.095;0.675 0.249;0.85 0.113;0.487 0.953;0.981 0.487;0.764 0.66;0.284 0.314;0.042 0.76;0.262 0.768;0.193 0.97;0.984 0.747;0.573 0.527]; 

numNodes = 12; 
CommR = 0.3;
SensR= 0.3; 
for i=1:numNodes 
%    node(i,1)=Graph_250869629(i,1)
%    x(i)= Graph_250869629(i,1)
    x(i)= node(i,1)
%    node(i,2)=Graph_250869629(i,2)
    y(i)=node(i,2)
end

figure()
hold on
    scatter(1,1,'x')
    scatter(1,0,'x')
    scatter(0,1,'x')
    scatter(0,0,'x')
    plot([1 0],[1 1],'k-x')
    plot([0 1],[0 0],'k-x')
    plot([1 1],[0 1],'k-x')
    plot([0 0],[1 0],'k-x')
for i=1:numNodes 
    scatter(node(i,1),node(i,2),'o')
end

 DT= delaunay(x,y)
 triplot(DT,x,y);

