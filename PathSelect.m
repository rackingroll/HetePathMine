%%%%%%%%%%%%%%%%%%% input %%%%%%%%%%%%%%%%%%
%Scell: dimS different link matrix; from target to different sources: e.g.,
%AC, AT, A->A, AA
%SeedsMat: n*K
%groundTruth: n*K, the ground truth of the clustering results

%%%%%%%%%%%%%%%%%%% output %%%%%%%%%%%%%%%%%
%thetaMat: n*K
%betaMat: K*n*dimS
%piVec: dimS*1

%%%%%%%%%%%%%revisions on Oct. 31, 2011 %%%%%%%%%%%%%%%%%%%%%%%
%1. change user guidance to involve lambda as Dirichlet distribution
%2. change formula for updating alpha, from approximation to using digamma

%%%%%%%%%%%%%%%%%%%%%%%%11/6/2011%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%1. efficiency issue, sparse
%function
function [thetaMat, betaCell, piVec, accuracy, nmi] = PathSelect(Scell, SeedsMat, lambda, groundTruth)
%initialization
K = size(SeedsMat,2);
n = size(Scell{1,1},1)
dimS = length(Scell);
labelVec = sum(SeedsMat,2);
labelIdx = find(labelVec);

tVec = zeros(dimS,1);

for p=1:dimS
    tVec(p,1) = sum(sum(Scell{p,1}));
    Scell{p,1} = Scell{p,1}./tVec(p,1); %normalize to 1
end

% for p=1:dimS
%     Scell{p,1} = Scell{p,1}./repmat(sum(Scell{p,1},2),1,size(Scell{p,1},2));
% end

thetaMat = rand(n,K);
thetaMat = thetaMat./repmat(sum(thetaMat,2),1,K); % normalize by row
thetaMat(labelIdx,:) = SeedsMat(labelIdx,:); %keep the labeled objects
betaCell = cell(dimS,1);
for p=1:dimS
    m = size(Scell{p,1},2);
    betaMat = rand(K,m);
    betaMat = betaMat./repmat(sum(betaMat,2),1,m);
    betaCell{p,1} = betaMat;
end;

piVec = ones(dimS,1);

%piVec = [1;1000];
%piVec = [2720.10568977291;29806.2094665275;21400.3106386500;564867.810572926;95804.3752637820;281598.855398837;];
%piVec = [1000,10000,10000,100000,10000,100000]';

EPSI = 0.001;
epsi = realmax;
Iter = 0;
while(epsi>EPSI)
    Iter = Iter + 1;
    %step1: fix piVec, derive thetaMat and betaMat
    inner_epsi = realmax;
    inner_EPSI = 0.0001;
    %inner initialize; restart partition instead of using the old one
    if(Iter < 3)
        thetaMat = rand(n,K);
        thetaMat = thetaMat./repmat(sum(thetaMat,2),1,K); % normalize by row
        thetaMat(labelIdx,:) = SeedsMat(labelIdx,:); %keep the labeled objects
        betaCell = cell(dimS,1);
        for p=1:dimS
            m = size(Scell{p,1},2);
            betaMat = rand(K,m);
            betaMat = betaMat./repmat(sum(betaMat,2),1,m);
            betaCell{p,1} = betaMat;
        end;
    end
    cell_p_kij = cell(dimS, 1);
    Inner_Iter = 0;
    while(inner_epsi > inner_EPSI)
        Inner_Iter = Inner_Iter + 1;
        %E-step: p_m(k|i,j) for each link in each meta path
        for p = 1:dimS
            m = size(Scell{p,1},2);
            [row,col,v] = find(Scell{p,1});
            len = length(v);
            p_kij = cell(K,1);

            t1 = zeros(len,K);
            for k=1:K
                t1 (:,k)= thetaMat(row,k).*betaCell{p,1}(k,col)'; %has not considered efficiency at this stage, this is full, but we only need sparse
            end
            t1 = t1./repmat(sum(t1,2),1,K);
            for k=1:K
                p_kij{k,1} = sparse(row,col,t1(:,k),n,m);
            end%normalize
            cell_p_kij{p,1} = p_kij;
        end
        %M-step: calculate p(k|i) and p_m(j|k)
        %p(k|i);
        thetaMat_new = zeros(n, K);
        for p=1:dimS
            %dimF = size(Scell{p,1},2);
            dimF = 1;
            for k=1:K
                thetaMat_new(:,k) = thetaMat_new(:,k) + sum(Scell{p,1}*piVec(p)/dimF.* cell_p_kij{p,1}{k,1},2);
            end;
            thetaMat_new(labelIdx,:) = thetaMat_new(labelIdx,:) + lambda*SeedsMat(labelIdx,:);
        end
        thetaMat_new = thetaMat_new./repmat(sum(thetaMat_new,2),1,K); %normalize
        %thetaMat_new(labelIdx,:) = (1-c)*thetaMat_new(labelIdx,:) + c*SeedsMat(labelIdx,:); %keep the labeled objects
        
        %p_m(j|k);
        for p = 1:dimS
            m = size(Scell{p,1},2);
            betaMat = zeros(K,m);
            for k=1:K
                betaMat(k,:) = sum(Scell{p,1}.* cell_p_kij{p,1}{k,1},1); %piVec(p) is not necessary here, will be normalized
            end;
            betaMat = betaMat./repmat(sum(betaMat,2),1,m);
            betaCell{p,1} = betaMat;
        end
        
%         piVec_new = piVec;
%         for p=1:dimS
%             piVec_new(p) = getNewWeight_1(piVec(p), thetaMat, betaCell{p,1}, Scell{p,1});
%         end;
    
        %compare, output inner_epsi
        [t, pos] = max(thetaMat, [], 2);
%        accuracy = sum(pos(groundTruth(:,1)) == groundTruth(:,2))/length(groundTruth(:,1));
%        nmi = NMI_V(pos(groundTruth(:,1)), groundTruth(:,2));
		nmi = UserguideNMI(pos',groundTruth');
		accuracy = Accuracy(pos,groundTruth) ;
        inner_epsi = sum(sum(abs(thetaMat-thetaMat_new)))/n;
%       fprintf('Inner_Iter %d: inner_epsi = %f, Accuracy = %f, NMI = %f\n', Inner_Iter, inner_epsi, accuracy, nmi);
        thetaMat = thetaMat_new;
    end
    %step2: fix thetaMat and betaMat (p_m(j|i)), derive the best alpha
    %(different methods to derive alpha)
    piVec_new = piVec;
    for p=1:dimS
        piVec_new(p) = getNewWeight_1(piVec(p), thetaMat, betaCell{p,1}, Scell{p,1});
    end;
    
    %output  
    epsi = sum(abs(piVec-piVec_new))/sum(piVec);
    fprintf('Iter %d: epsi = %f\n',Iter, epsi);
    piVec = piVec_new ;
    piVec./tVec;
end

function w = getNewWeight_1(w_old, thetaMat, betaMat, S)
[N,M] = size(S);
p_ij = thetaMat*betaMat; %normalization automatically
stats = sum(sum(S.*log(p_ij+eps)));
nVec = sum(S,2);
[i,j,v] = find(S);
l = length(v);
%D = -(sum(v.*(v*w_old).*(log(v*w_old + eps)-ones(l,1))) - %sum(nVec.*(nVec*w_old+M-1).*(log(nVec*w_old+M- 1 + eps)-ones(N,1)))); %approximate calculation
D = sum(psi(w_old*nVec+M*ones(N,1)).*nVec)-sum(v.*psi(w_old * v + 1));
w = D/(-stats) * w_old;
epsi = realmax;
EPSI = 0.0005;
while (epsi > EPSI)
    w_old = w;
    %D = -(sum(v.*(v*w_old).*(log(v*w_old + eps)-1)) - sum(nVec.*(nVec*w_old+M-1).*(log(nVec*w_old+M- 1 + eps)-1))); %approximate calculation
    D = sum(psi(w_old*nVec+M*ones(N,1)).*nVec)-sum(v.*psi(w_old * v + 1));
    w = D/(-stats) * w_old;
    epsi = sum(abs(w-w_old))/sum(w_old);
end
