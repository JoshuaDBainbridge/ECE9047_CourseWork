N= [0.302 0.308;0.753 0.327;0.407 0.643;0.673 0.645;0.159 0.847]
C= [0 0; 0 1; 1 0; 1 1]
hold on
for x=1:5
    scatter(N(x,1),N(x,2))
end 
    scatter(1,1,'x')
    scatter(1,0,'x')
    scatter(0,1,'x')
    scatter(0,0,'x')
plot([N(5,1) N(3,1)],[N(5,2) N(3,2)],'b-x')
plot([N(1,1) N(3,1)],[N(1,2) N(3,2)],'b-x')
plot([N(4,1) N(3,1)],[N(4,2) N(3,2)],'b-x')
plot([N(4,1) N(2,1)],[N(4,2) N(2,2)],'b-x')

for x=1:5
    for j=1:5
        D(x,j)=sqrt((N(x,1)-N(j,1))^2+(N(x,2)-N(j,2))^2)
    end
end 

for x=1:4
    for j=1:5
        K(x,j)=sqrt((C(x,1)-N(j,1))^2+(C(x,2)-N(j,2))^2)
    end
end 
