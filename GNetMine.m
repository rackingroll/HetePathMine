function [result score] = GNetMine(W, WTypes, label, alpha, lamda)
% Function to do transductive classification on heterogeneous information
% networks of M types of objects and R types of links (which can be between 
% any two types of objects). Each object type i has N_i objects.
%
%
%   W: R x 1 cell. Each W{r} is a N_i x N_j weight matrx of the 
%   subgraph corresponding to the link type between object types i and j, r = 1, ..., R.
%
%   WTypes: R x 2 matrix denoting the object type indices corresponding to the weight matrices 
%   stored in W. For any r in {1, ..., R}, W{r} corresponds to the subgraph
%   between object types WTypes(r, 1) and WTypes(r, 2).
%
%   label: M x 1 cell. Each label{i} is a N_i x 1 vector corresponding to
%   object type i, in which unlabeled data are marked with 0, 
%   and labeled data are marked with the class label index (e.g.
%   from 1 to the number of classes).
%
%   alpha: M x 1 parameter vector for the object types, each alpha(i) corresponds to the alpha_i
%   in the paper.
%
%   lamda: R x 1 parameter vector for the link types, each lamda(r) controls the relative importance of
%   link type r.
%
%
%   result: M x 1 cell. Each result{i} is a N_i x 1 vector denoting the class
%   predictions of each object of type i.
%
%   score: M x 1 cell. Each score{i} is a N_i x number_of_classes matrix
%   storing the confidence score of each object of type i belonging to
%   each class.
%
%
%
%   Reference: 
%   Ming Ji, Yizhou Sun, Marina Danilevsky, Jiawei Han, "Graph Regularized Transductive Classification on Heterogeneous
%   Information Networks", ECMLPKDD'10, Barcelona, Spain, Sept. 2010. 
%
%   Written by Ming Ji (mingji1 AT illinois.edu), June/2010, October/2010.
%                                             

nType =length(label);
if (~exist('alpha','var'))
    alpha = ones([nType 1]);
end
if (~exist('lamda','var'))
    lamda = (mean(alpha)*2)*ones([length(W), 1]);
end

nSmp = zeros([nType 1]);
base = zeros([nType+1 1]);
for i = 2:nType+1
    nSmp(i-1) = length(label{i-1});
    base(i) = base(i-1)+nSmp(i-1);
end
for i = 1:length(W)
    D1 = sum(W{i}, 2);
    D1 = D1.^-0.5;
    D1 = diag(D1);
    D2 = sum(W{i}, 1);
    D2 = D2.^-0.5;
    D2 = diag(D2);
    W{i} = -D1 * W{i} * D2;
end

W_all = sparse(base(end), base(end));
for i = 1:length(W)
    typeI = WTypes(i, 1);
    typeJ = WTypes(i, 2);
	
    W_all(base(typeI)+1:base(typeI+1), base(typeJ)+1:base(typeJ+1)) = ...
        W_all(base(typeI)+1:base(typeI+1), base(typeJ)+1:base(typeJ+1)) + lamda(i)*W{i};
	
    W_all(base(typeJ)+1:base(typeJ+1), base(typeI)+1:base(typeI+1)) = ...
        W_all(base(typeJ)+1:base(typeJ+1), base(typeI)+1:base(typeI+1)) + (lamda(i)*W{i})';

	
    for j = base(typeI)+1:base(typeI+1)
        W_all(j, j) = W_all(j, j)+lamda(i);
    end
    for j = base(typeJ)+1:base(typeJ+1)
        W_all(j, j) = W_all(j, j)+lamda(i);
    end
end

for i = 1:nType
    for j = base(i)+1:base(i+1)
        W_all(j, j) = W_all(j, j)+alpha(i);
    end
end

label_orig = label;
label = zeros([size(W_all, 1) 1]);
for i = 1:nType
    label(base(i)+1:base(i+1)) = label_orig{i};
end
class = unique(label);
class(find(class == 0)) = [];
nClass = length(class);

y = zeros([size(W_all, 1) nClass]);
for i = 1:nClass    
    y(find(label == class(i)), i)=1;
end
score_total = W_all\y;
[junk, result_total]=max(score_total, [], 2);
result_total = class(result_total);

score = cell(0);
result = cell(0);
for i = 1:nType
    score{i} = score_total(base(i)+1:base(i+1), :);
    result{i} = result_total(base(i)+1:base(i+1));
end