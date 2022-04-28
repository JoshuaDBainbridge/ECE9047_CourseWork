clear;
load 'Graph_250869629.txt'
%%ADD TWO node 
numNodes = 25; 
CommR = 0.25;
SensR= 0.25; 
for i=1:numNodes 
    node(i,1)=Graph_250869629(i,1)
    node(i,2)=Graph_250869629(i,2)
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
            plot([node(i,1) node(y,1)],[node(i,2) node(y,2)],'k--o')
            k(i)=k(i)+1
        end
    end 
end 
