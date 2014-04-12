function ac = Accuracy( A, B ) 
%NMI Normalized mutual information
% http://en.wikipedia.org/wiki/Mutual_information
% http://nlp.stanford.edu/IR-book/html/htmledition/evaluation-of-clustering-1.html

% Author: http://www.cnblogs.com/ziqiao/   [2011/12/13] 

if length( A ) ~= length( B)
    error('length( A ) must == length( B)');
end

acTemp = zeros(4,1) ;

[R1,R2,R3,R4] = ClusterResultOperator(A) ;

acTemp(1,1) = size(find(R1==B) ,1)/ size(B,1) ;
acTemp(2,1) = size(find(R2==B) ,1)/ size(B,1) ;
acTemp(3,1) = size(find(R3==B) ,1)/ size(B,1) ;
acTemp(4,1) = size(find(R4==B) ,1)/ size(B,1) ;

ac = max(acTemp(:,1)) ;

