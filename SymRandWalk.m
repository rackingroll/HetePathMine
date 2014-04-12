function [PS] = SymRandWalk (P)

count = size(P,1) ;
Ptemp=P-diag(diag(P)-diag(0)) ;
PS = zeros(count,count) ;
for i = 1:count
	for j = 1:count
		sumi = sum(Ptemp(i,:)) ;
		sumj = sum(Ptemp(:,j)) ;
		if sumi ~=0 & sumj~=0
			PS(i,j) =( (Ptemp(i,j)) / (sumi) ) + ( (Ptemp(i,j)) / (sumj) );
		end
	end
end
