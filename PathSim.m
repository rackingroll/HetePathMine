function [PS] = PathSim (P)

count = size(P,1) ;
PS = zeros(count,count) ;
for i = 1:count
	for j = 1:count
		sumAdd = P(i,i) + P(j,j) ;
		if (sumAdd ~= 0 )
			PS(i,j) = ((P(i,j) + P(j,i)) / (P(i,i) + P(j,j))) ;
		end
	end
end
