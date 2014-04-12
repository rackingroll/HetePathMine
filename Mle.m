function [value] = Mle (x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,Y,lanmda0)

%data = [
%		0.1,0.5,0
%		0.5,0.1,1
%		0.5,0.1,1
%		0.3,0.1,0
%		0.2,0.1,1
%		0.1,0.1,0
%		0.6,0.1,1
%		];

data = [x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,Y] ;
%data = [x1(1:400),x2(1:400),x3(1:400),x4(1:400),x5(1:400),x6(1:400),x7(1:400),x8(1:400),x9(1:400),x10(1:400),Y(1:400)] ;

EPSI = 0.001 ;
epsi = 100 ;
beta = [0,0,0,0,0,0,0,0,0,0]';
theta = 0 ;
y = data(:,size(data,2));
loop = 0 ;
namda = 0.01 ;

while epsi>EPSI
	oldBeta = beta ;
	for i=1:size(beta,1)
		theta = 0 ;
		for  j=1:size(data,1)
			theta = theta + data(j,i)*y(j) - data(j,i)*exp(data(j,1:(size(data,2)-1)) * beta) ;
		end
%		theta = 0.9*theta - 0.1*abs(beta(i)-lanmda0(i));
		beta(i) = beta(i) + theta*namda ;
	end
	epsi = abs((oldBeta-beta)'*(oldBeta-beta));
	loop = loop +1 ;
%	fprintf('loop %d: epsi = %f\n',loop, epsi);
end
value = beta ;
end 

