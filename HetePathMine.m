%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HetePathMine
% Author: Chen Luo from Jilin University
% Paper: HetPathMine: A Novel Transductive Classifcation Algorithm on Heterogeneous Information Networks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Data Extraction
[AP,CP,PP,TP] = DataExtraction () ;
[P1,P2,P3,P4,P5,P6,P7,P8,P9,P10] = GetStructureMatrix(AP,CP,PP,TP) ;

%Initialization
[userGuide,groundtruth] = GetSeedMatrix(0.1) ;
%RandWalk,SymRandWalk,Normalization,PathSim
PS1 = PathSim(P1) ; 
PS2 = PathSim(P2) ;
PS3 = PathSim(P3) ;
PS4 = PathSim(P4) ;
PS5 = PathSim(P5) ;
PS6 = PathSim(P6) ;
PS7 = PathSim(P7) ;
PS8 = PathSim(P8) ;
PS9 = PathSim(P9) ;
PS10 = PathSim(P10) ; 
[PT1,PT2,PT3,PT4,PT5,PT6,PT7,PT8,PT9,PT10,guide] = TrainingMetaPath(PS1,PS2,PS3,PS4,PS5,PS6,PS7,PS8,PS9,PS10,userGuide) ;
[PT1,PT2,PT3,PT4,PT5,PT6,PT7,PT8,PT9,PT10,guide] = RemoveNoise(PT1,PT2,PT3,PT4,PT5,PT6,PT7,PT8,PT9,PT10,guide) ;

% Path Selection Model, Using Linear result as the MLE Input
lanmda0 = Training(PT1,PT2,PT3,PT4,PT5,PT6,PT7,PT8,PT9,PT10,guide) ;
A = Mle(PT1,PT2,PT3,PT4,PT5,PT6,PT7,PT8,PT9,PT10,guide,lanmda0) ;

% Construction Similarity Matrix Used for Classification
resultMatrix = GetResultMatrixClass (A,PS1,PS2,PS3,PS4,PS5,PS6,PS7,PS8,PS9,PS10);
size_of_author = size(resultMatrix) ;
resultMatrix = resultMatrix + ones(size_of_author);
author_label = zeros(size(userGuide,1),1) ;
for j=1:size(userGuide,1)
	if find(userGuide(j,:)~=0) 
		author_label(j) = find(userGuide(j,:)~=0) ;
	end
end

% Using GNetMine as the Classification Method, we only use the Homogeneous Classification Method of it
% For more detail about this part, please contact Ming Ji from UIUC
label = cell([1 1]);
label{1} = author_label;
W = cell([1 1]);
W{1} = sparse(resultMatrix);
%parameters
WTypes = [1 1];
alpha = [1];
lamda = [2];
[result score] = GNetMine(W, WTypes, label, alpha, lamda);
clusterResult = result{1} ;

ac = Accuracy(clusterResult,groundtruth) 
