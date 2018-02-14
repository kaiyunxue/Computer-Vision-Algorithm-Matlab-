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

dispaMap3=ones(size(rankTranImagel,1),size(rankTranImagel,2));
conPKRN=ones(size(rankTranImagel,1),size(rankTranImagel,2));
for i=1:size(rankTranImagel,1)
    for j=1:size(rankTranImagel,2)
        winl=ones(3,3);
        for k=i-1:i+1
            for l=j-1:j+1
                if k<=0 || k>size(rankTranImagel,1) || l<=0 || l>size(rankTranImagel,2)
                    winl(k-i+2,l-j+2)=0;
                    continue;
                end
                winl(k-i+2,l-j+2)=rankTranImagel(k,l);
            end
        end
        sad=zeros(1,64);
        for d=0:63
            winr=ones(3,3);
            for k=1:3
                for l=1:3
                    if k+i-2<=0 || k+i-2>size(rankTranImagel,1) || l+j-2<=0
                        winr(k,l)=0;
                    elseif l+j-2-d>0 && l+j-2-d<=size(rankTranImager,2)
                        winr(k,l)=rankTranImager(k+i-2,l+j-2-d);
                    else
                        winr(k,l)=0;
                    end
                end
            end
            sad(d+1)=sum(sum(abs(winl-winr)));
        end
        [sadmin,ind]=min(sad);
        [sad_s,ind_s]=sort(sad);
        dispaMap3(i,j)=ind-1;
        conPKRN(i,j)=sad(ind_s(2))/sad(ind);
    end
end
[con_s,ind_c]=sort(conPKRN(:),'descend');
num=size(dispaMap3,1)*size(dispaMap3,2);
for i=1:num
    if find(ind_c==i)>0.5*num
        dispaMap3(i)=0;
    end
end
imshow(dispaMap3int);
dispaMap3int=uint8(dispaMap3);
dispaMap3int=dispaMap3int*4;

dispaMapGT=imread('disp2.pgm');
dispaMapGT=dispaMapGT/4;
dispaMapGT=double(dispaMapGT);
error_num=0;
for i=1:0.5*num
    if abs(dispaMapGT(ind_c(i))-dispaMap3(ind_c(i)))>1
        error_num=error_num+1;
    end
end
errorRates3=error_num/(0.5*num)