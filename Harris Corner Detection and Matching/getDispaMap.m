function [disMap] = getDispaMap(rankTranImagel,rankTranImager,n)
[aa,bb] = size(rankTranImagel);
disMap=ones(aa,bb);
for i=1:aa
    for j=1:bb
        winl=zeros(n,n);
        for k=i-(n-1)/2:i+(n-1)/2
            for l=j-(n-1)/2:j+(n-1)/2
                if k>0 && k<=aa && l>0 && l<=bb
                    winl(k-i+(n+1)/2,l-j+(n+1)/2)=rankTranImagel(k,l);
                end
            end
        end
        SAD=zeros(1,64);
        for d=0:63
            winr=ones(n,n);
            for k=1:n
                for l=1:n
                    if k+i-+(n+1)/2<=0 || k+i-+(n+1)/2>aa || l+j-+(n+1)/2<=0
                        winr(k,l)=0;
                    elseif l+j-+(n+1)/2-d>0 && l+j-+(n+1)/2-d<=bb
                        winr(k,l)=rankTranImager(k+i-+(n+1)/2,l+j-+(n+1)/2-d);
                    else
                        winr(k,l)=0;
                    end
                end
            end
            SAD(d+1)=sum(sum(abs(winl-winr)));
        end
        [sadmin,ind]=min(SAD);
        disMap(i,j)=ind-1;
    end
end
end

