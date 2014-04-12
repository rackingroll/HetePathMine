function [PT1,PT2,PT3,PT4,PT5,PT6,PT7,PT8,PT9,PT10,guide] = TrainingMetaPath (P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,userGuide)

[a1,b1] = find(userGuide==1) ;
[a0,b0] = find(userGuide==0) ;
count1 = size(a1,1) ;
count0 = size(a0,1) ;

PT1 = ones(count1 + count0,1) ;
PT2 = ones(count1 + count0,1) ;
PT3 = ones(count1 + count0,1) ;
PT4 = ones(count1 + count0,1) ;
PT5 = ones(count1 + count0,1) ;
PT6 = ones(count1 + count0,1) ;
PT7 = ones(count1 + count0,1) ;
PT8 = ones(count1 + count0,1) ;
PT9 = ones(count1 + count0,1) ;
PT10 = ones(count1 + count0,1) ;
guide = ones(count1 + count0,1) ;

for i = 1:count1
	PT1(i,1) = P1(a1(i),b1(i)) ;
	PT2(i,1) = P2(a1(i),b1(i)) ;
	PT3(i,1) = P3(a1(i),b1(i)) ;
	PT4(i,1) = P4(a1(i),b1(i)) ;
	PT5(i,1) = P5(a1(i),b1(i)) ;
	PT6(i,1) = P6(a1(i),b1(i)) ;
	PT7(i,1) = P7(a1(i),b1(i)) ;
	PT8(i,1) = P8(a1(i),b1(i)) ;
	PT9(i,1) = P9(a1(i),b1(i)) ;
	PT10(i,1) = P10(a1(i),b1(i)) ;
	guide(i,1) = userGuide(a1(i),b1(i)) ;
end
for j = (count1+1):(count1 + count0)
	PT1(j,1) = P1(a0(j-count1),b0(j-count1)) ;
	PT2(j,1) = P2(a0(j-count1),b0(j-count1)) ;
	PT3(j,1) = P3(a0(j-count1),b0(j-count1)) ;
	PT4(j,1) = P4(a0(j-count1),b0(j-count1)) ;
	PT5(j,1) = P5(a0(j-count1),b0(j-count1)) ;
	PT6(j,1) = P6(a0(j-count1),b0(j-count1)) ;
	PT7(j,1) = P7(a0(j-count1),b0(j-count1)) ;
	PT8(j,1) = P8(a0(j-count1),b0(j-count1)) ;
	PT9(j,1) = P9(a0(j-count1),b0(j-count1)) ;
	PT10(j,1) = P10(a0(j-count1),b0(j-count1)) ;
	guide(j,1) = userGuide(a0(j-count1),b0(j-count1)) ;
end
