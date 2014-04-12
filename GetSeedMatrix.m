function [ userGuide,ground ] = GetSeedMatrix3(seedFraction)

seed = load ('seed.txt') ;
authornumber = size(seed,1) ;
ground = seed(:,1) ;

seednumber = floor(authornumber*seedFraction) ;
eachseednumber = floor(seednumber/4) ;

seed_1 = find(seed(:,1)==1) ;
seed_2 = find(seed(:,1)==2) ;
seed_3 = find(seed(:,1)==3) ;
seed_4 = find(seed(:,1)==4) ;

userGuideseed = zeros(authornumber,1) ;
if (size(seed_1,1)<eachseednumber)
	userGuideseed(seed_1) = 1 ;
else
	tempseed_1 = randperm(size(seed_1,1)) ;
	
	userGuideseed(tempseed_1(1:eachseednumber)) = 1 ;
end

if (size(seed_2,1)<eachseednumber)
	userGuideseed(seed_2()) = 2 ;
else
	tempseed_2 = randperm(size(seed_2,1)) ;
	userGuideseed(tempseed_2(1:eachseednumber)) = 2 ;
end
	
if (size(seed_3,1)<eachseednumber)
	userGuideseed(seed_3()) = 3 ;
else
	tempseed_3 = randperm(size(seed_3,1)) ;
	userGuideseed(tempseed_3(1:eachseednumber)) = 3 ;
end

if (size(seed_4,1)<eachseednumber)
	userGuideseed(seed_4()) = 4 ;
else
	tempseed_4 = randperm(size(seed_4,1)) ;
	userGuideseed(tempseed_4(1:eachseednumber)) = 4 ;
end


groundtruth = zeros(authornumber,max(ground)) ;
userGuide = zeros(authornumber,max(ground)) ;

for i=1:authornumber
	groundtruth(i,ground(i,1)) = 1 ;
	if userGuideseed(i,1) ~= 0
		userGuide(i,userGuideseed(i,1)) = 1 ;
	end
end

end