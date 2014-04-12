function [P1,P2,P3,P4,P5,P6,P7,P8,P9,P10] = GetStructureMatrix (AP,CP,PP,TP)

P1=AP*AP' ;
P2=AP*PP*AP';
P3=AP*PP'*AP';
P4=AP*CP'*CP*AP' ;
P5=AP*AP'*AP*AP' ;
P6=AP*TP'*TP*AP' ;
P7=AP*PP*PP*AP';
P8=AP*PP'*PP'*AP';
P9=AP*PP*PP'*AP' ;
P10=AP*PP'*PP*AP';

%you can use everything to do this
%[countRow,countCol] = size(APA) ;

%StructureMatrix = zeros(countRow,countCol) ;

%for i = 1:countRow
%	for j = 1:countCol
%		StructureMatrix(i,j) =  ( ((APTPA(i,j) + APTPA(j,i)) / (APTPA(i,i) + APTPA(j,j)))...
%							   +((APA(i,j) + APA(j,i)) / (APA(i,i) + APA(j,j)))...
%							   +((APCPA(i,j) + APCPA(j,i)) / (APCPA(i,i) + APCPA(j,j))))/3 ;
%	end
%end
