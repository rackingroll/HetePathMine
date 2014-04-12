function [R1,R2,R3,R4] = ClusterResultOperator (clusterResult)
	
	authorCount = size(clusterResult(:,1),1) ;
	R1 = zeros(authorCount,1) ;
	R2 = zeros(authorCount,1) ;
	R3 = zeros(authorCount,1) ;
	R4 = zeros(authorCount,1) ;
	
	R1 = clusterResult ;
	for i=1:authorCount
		R2(i,1) = mod((clusterResult(i,1)+1),4) ;
		if (R2(i,1)==0) 
			R2(i,1)=4 ;
		end
		
		R3(i,1) = mod((clusterResult(i,1)+2),4) ;
		if (R3(i,1)==0) 
			R3(i,1)=4 ;
		end
		
		R4(i,1) = mod((clusterResult(i,1)+3),4) ;
		if (R4(i,1)==0) 
			R4(i,1)=4 ;
		end
	end
end