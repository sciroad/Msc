prefix="train";
trainList=[];
pmfs=[];
cdfs=[];
for i=1:5
    loc=append("code\resources\images\",prefix,int2str(i),".jpg");
    img=imread(loc);
    r=img(:,:,1);
    g=img(:,:,2);
    b=img(:,:,3);
    rCount=[];
    gCount=[];
    bCount=[];
    for j=0:255
       rCount=[rCount,sum(r(:)==j)];
       gCount=[gCount,sum(g(:)==j)];
       bCount=[bCount,sum(b(:)==j)];
    end
    y=[rCount,gCount,bCount];
    trainList=[trainList;y];
    pmf=y./sum(y);
    pmfs=[pmfs;pmf];
    cdf=cumsum(pmf);
    cdfs=[cdfs;cdf];
    
end
t = tiledlayout(5,3);
x=0:(256*3)-1;
for index=1:5
    nexttile
    bar(x,trainList(index,:));
    nexttile
    bar(x,pmfs(index,:));
    nexttile
    stairs(x,cdfs(index,:));
end
