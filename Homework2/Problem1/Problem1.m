clear;
im_l=imread('teddyL.pgm');
im_r=imread('teddyR.pgm');
[aa,bb] = size(im_l);
rankTranImagel=ones(aa,bb);
rankTranImager=ones(aa,bb);
for i=1:aa
    for j=1:bb
        wndw_l=zeros(5,5);
        wndw_r=zeros(5,5);
        for k=i-2:i+2
            for l=j-2:j+2
                if k>0 && k<=aa && l>0 && l<=bb
                    wndw_l(k-i+3,l-j+3)=im_l(k,l);
                    wndw_r(k-i+3,l-j+3)=im_r(k,l);
                end
            end
        end       
        rV_l=0;
        rV_r=0;
        for ii=1:5
            for jj =1:5
                if wndw_l(ii,jj)<wndw_l(3,3)
                    rV_l = rV_l + 1;
                end
                if wndw_r(ii,jj)<wndw_r(3,3)
                    rV_r = rV_r + 1;
                end
            end
        end
        rankTranImagel(i,j)=rV_l;
        rankTranImager(i,j)=rV_r;
    end
end

dispaMap3 = getDispaMap(rankTranImagel,rankTranImager,3);
dispaMap15 = getDispaMap(rankTranImagel,rankTranImager,15);
figure;
imshow(uint8(dispaMap3/64*256));
figure;
imshow(uint8(dispaMap15/64*256));

dispaMapGT=imread('disp2.pgm');
dispaMapGT=dispaMapGT/4;
dispaMapGT=double(dispaMapGT);
load dispaMap3.mat;
diffDispaMap3=abs(dispaMapGT-dispaMap3);
errorNum3=length(find(diffDispaMap3>1));
errorRates3=errorNum3/numel(dispaMap3)
load dispaMap15.mat;
diffDispaMap15=abs(dispaMapGT-dispaMap15);
errorNum15=length(find(diffDispaMap15>1));
errorRates15=errorNum15/numel(dispaMap15)