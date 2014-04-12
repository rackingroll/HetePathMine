function [TR1,TR2,TR3,TR4,TR5,TR6,TR7,TR8,TR9,TR10,guideT] = RemoveNoise (PT1,PT2,PT3,PT4,PT5,PT6,PT7,PT8,PT9,PT10,guide)

TempMatrix = [PT1,PT2,PT3,PT4,PT5,PT6,PT7,PT8,PT9,PT10] ;
TempMatrixAll = [PT1,PT2,PT3,PT4,PT5,PT6,PT7,PT8,PT9,PT10,guide];
result_number = 0 ;

for i=1:size(PT1,1)
	if sum(TempMatrix(i,:)) ~= 0
		result_number = result_number+1 ;
	end
end
result_number
ResultMetrix = zeros(result_number,11) ;
count = 1 ;
for i=1:size(PT1,1)
	if sum(TempMatrix(i,:)) ~= 0
		ResultMetrix(count,:) = TempMatrixAll(i,:) ;
		count = count+1 ;
	end
end

TR1 = ResultMetrix(:,1) ;
TR2 = ResultMetrix(:,2) ;
TR3 = ResultMetrix(:,3) ;
TR4 = ResultMetrix(:,4) ;
TR5 = ResultMetrix(:,5) ;
TR6 = ResultMetrix(:,6) ;
TR7 = ResultMetrix(:,7) ;
TR8 = ResultMetrix(:,8) ;
TR9 = ResultMetrix(:,9) ;
TR10 = ResultMetrix(:,10) ;
guideT = ResultMetrix(:,11) ;

end