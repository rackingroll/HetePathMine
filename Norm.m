function [PS] = Norm (P)

count = size(P,1) ;
Ptemp=P-diag(diag(P)-diag(0)) ;
PS = zeros(count,count) ;
for i = 1:count
	for j = i+1:count
		sumi = sum(Ptemp(i,:)) ;
		if sumi ~=0
			PS(i,j) = (Ptemp(i,j) / (sumi) );
			PS(j,i) = PS(i,j) ;
		end
	end
end
