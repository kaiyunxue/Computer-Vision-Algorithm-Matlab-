clear;
clc;
figure;
Pic = imread('basketball-court.ppm');
subplot(2,1,1);
imshow(Pic);
PointStruct = load('positions.mat');
corrdinates = PointStruct.corrdinates;
    X_ = zeros(7,3);
    for i = 1 : 7
        X_(i,1:2) = corrdinates(8 - i).Position;
        X_(i,3) = 1;
    end
    X = [1,1,1;
        940,1,1;
        940,500,1;
        1,500,1;
        470,1,1;
        470,250,1;
        470,500,1];
    M = zeros(14,9);
    for i = 1 : 7
        M(2*i - 1 , 1 : 3) = 0;
        M(2*i - 1 , 4 : 6) = -X_(i,3) * X(i,:);
        M(2*i - 1 , 7 : 9) = X_(i,2) * X(i,:);
        M(2*i , 1 : 3) = X_(i,3) * X(i,:);
        M(2*i , 4 : 6) = 0;
        M(2*i , 7 : 9) = -X_(i,1) * X(i,:);
    end
    H = zeros(3,3);
    [U,S,V] = svd(M);
    M_ = V(:,9);
    for i = 1 : 3
        for j = 1 : 3
            H(i,j) = M_((i-1)*3+j,1);
        end
    end
%     % for testing
%             p = H*[940;500;1];
%             i_ = int16(p(1,1)/p(3,1))
%             j_ = int16(p(2,1)/p(3,1))
%     %end
    for i = 1 : 940
        for j = 1 : 500
            p = H*[i;j;1];
            i_ = p(1,1)/p(3,1);
            j_ = p(2,1)/p(3,1);
            if i_> 0 && j_ > 0
                i_int = fix(i_);
                j_int = fix(j_);
                dif_i = i_ - i_int;
                dif_j = j_ - j_int;
                pic(j,i,:) =(1-dif_i)*(1-dif_j)*Pic(j_int,i_int,:)...
                            + dif_i*dif_j*Pic(j_int+1,i_int+1,:)...
                            + dif_i*(1-dif_j)*Pic(j_int+1,i_int,:)...
                            + dif_j*(1-dif_i)*Pic(j_int,i_int+1,:);            
            end
        end
    end
subplot(2,1,2);
imshow(pic);
imwrite(pic,'basketball-court.png');
    
