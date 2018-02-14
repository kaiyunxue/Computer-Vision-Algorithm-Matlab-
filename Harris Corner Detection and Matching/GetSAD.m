function [ sad ] = GetSAD( l,pl,r,pr )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
sad = 0;
for i = 1 : 3
    for j = 1 : 3
        sad = sad + abs(l(pl(1,1)-2+i,pl(1,2)-2+j) - r(pr(1,1)-2+i,pr(1,2)-2+j));
    end
end
end

