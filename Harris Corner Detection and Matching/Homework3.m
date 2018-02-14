close all;
clc;
clear;
im_l = imread('teddyL.pgm');
im_r = imread('teddyR.pgm');
im_d = imread('disp2.pgm');
[Rs_l,R_l,M_l,n_l] = HarrisCornerDetectior(im_l,0.06,3*10^14);
[Rs_r,R_r,M_r,n_r] = HarrisCornerDetectior(im_r,0.06,3*10^14);
[x,y] = size(Rs_l);
il = 1;ir = 1;
for i = 1 : x
    for j = 1 : y
        if Rs_l(i,j) > 0
            vl{il,1} = [i,j];
            il=il+1;
        end
        if Rs_r(i,j) > 0
            vr{ir,1} = [i,j];
            ir=ir+1;
        end
    end
end
for i = 1 : n_l
    for j = 1 : n_r
        V{i,j} = vr{j,1}-vl{i,1};
        l = vl{i,1};
        r = vr{j,1};
        D(i,j) = (l(1,1)-r(1,1))^2 + (l(1,2)-r(1,2))^2;
        SADs(i,j) = GetSAD(Rs_l,vl{i,1},Rs_r,vr{j,1});
    end
end
SADs_sorted = sort(SADs,2);
for i = 1 : 20
    [gp(i,1),bp(i,1)] = CornerMatch(SADs,SADs_sorted,D,vl,im_d,0.05*i);
    correctRate(i,1) = gp(i,1)/(gp(i,1)+bp(i,1));
end