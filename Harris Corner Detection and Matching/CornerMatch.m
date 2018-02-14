function [ g,b ] = CornerMatch( SADs,SADs_sorted,dstns,listL,GT, choosenRate)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
g = 0;
b = 0;
[n_l,n_r] = size(SADs);
dsp = SADs_sorted(:,1:choosenRate*n_r);
[aa,bb] = size(dsp);
for i = 1 : aa
    for j = 1 : bb
        v = dsp(i,j);
        L = SADs(i,:);
        p = find(L == v);
        dis = sqrt(dstns(i,p));
        position = listL{i,1};
        disTruth = GT(position(1,1),position(1,2));
        if abs(dis - disTruth/4) < 1
            g = g + 1;
        else
            b = b + 1;
        end
    end
end
end

