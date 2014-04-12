function [resultMatrix] = GetResultMatrixClass (A,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10)

count = size(P1,1) ;
resultMatrix = zeros(count,count);

for i=1:count 
	for j=1:count
		resultMatrix(i,j) = A(1)*P1(i,j)+A(2)*P2(i,j)+A(3)*P3(i,j)+A(4)*P4(i,j)+A(5)*P5(i,j)+A(6)*P6(i,j)+A(7)*P7(i,j)+A(8)*P8(i,j)+A(9)*P9(i,j)+A(10)*P10(i,j);
	end
end
