function [R_s, R ,M,N] = GetHArrisMatrix( Sxx,Syy,Sxy,k,threshold)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
[x,y] = size(Sxx);
R = zeros(x,y);
R_s = zeros(x,y);
for i = 2 : x - 1
    for j = 2 : y - 1
        xx = 0; yy = 0; xy = 0;
        for wi = 1 : 3
            for wj = 1 : 3
                xx = double(xx) + double(Sxx(i-(2-wi),j-(2-wj)));
                xy = double(xy) + double(Sxy(i-(2-wi),j-(2-wj)));
                yy = double(yy) + double(Syy(i-(2-wi),j-(2-wj)));
            end
        end
        W(1,1) = xx; W(1,2) = xy; W(2,1) = xy; W(2,2) = yy;
        M{i,j} = W;
        R(i,j) = det(double(W))-(k*trace(double(W)))^2;
    end
end
for i = 2 : x - 1
    for j = 2 : y - 1
        for wi = 1 : 3
            for wj = 1 : 3
                Win(wi,wj) = R(i-2+wi,j-2+wj);
            end
        end
        if Win(2,2)~=max(max(Win))
             R_s(i,j)=0;
        else
             R_s(i,j) = R(i,j);
        end
    end
end
N = x*y;
for i = 1 : x
    for j = 1 : y
        if R_s(i,j) < threshold
            R_s(i,j) = 0;
            N = N-1;
        end
    end
end
end

