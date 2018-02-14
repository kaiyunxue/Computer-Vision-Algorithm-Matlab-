function [ Derivatives ] = ComputeDerivatives( Img , operator)
%UNTITLED5 Summary of this function goes here
%   OPERATOR HAS TO BE 3*3
[x,y] = size(Img);
Img = double(Img);
operator = double(operator);
for i = 2:x-1
    for j = 2:y-1 
        Derivatives(i,j) = operator(1,1)*Img(i-1,j-1)+operator(1,2)*Img(i-1,j)+operator(1,3)*Img(i-1,j+1)+...
                           operator(2,1)*Img(i,j-1)+operator(2,2)*Img(i,j)+operator(2,3)*Img(i,j+1)+...
                           operator(3,1)*Img(i+1,j-1)+operator(3,2)*Img(i+1,j)+operator(3,3)*Img(i+1,j+1);
    end
end
end

