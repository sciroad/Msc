prefix="train";
trainList=[];
pmfs=[];
cdfs=[];
totals=[];
for i=1:5
    loc=append("code\resources\images\",prefix,int2str(i),".jpg");
    img=imread(loc);
    [y,y_total]=rgbValueCount(img);
    [pmf,cdf]=pmfCdfCalculator(y);
    trainList=[trainList;y];
    totals=[totals,y_total];
    pmfs=[pmfs;pmf];
    cdfs=[cdfs;cdf];
end
t = tiledlayout(5,3);
x=0:(256*3)-1;
probabilities=[];
for index=1:5
    nexttile
    bar(x,trainList(index,:));
    nexttile
    bar(x,pmfs(index,:));
    nexttile
    stairs(x,cdfs(index,:));
    probabilities=[probabilities,totals(index)/sum(totals)];
end
disp(probabilities);

img=imread("code\resources\images\test14.jpg");
[pixelData,~]=rgbValueCount(img);
c=classify(pixelData,pmfs,probabilities);
disp(c);
%pmf calculator
function [pmf,cdf]=pmfCdfCalculator(y)
    y_total=sum(y);
    pmf=y./y_total;
    cdf=cumsum(pmf);
end
%RGB value Counter
function [y,y_total]=rgbValueCount(img)
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
    y_total=sum(y);
end


%her bir pixel ve her bir sınıf için olasılık hesabı
function ps=calculateProbability(pixelData,pmfs,probabilities)
   ps=[];
   for i=1:5
       p=1;
       for j=1:length(pixelData)
           if pixelData(j)~=0 && pmfs(i,j)~=0
               p=p+log(pmfs(i,j))*pixelData(j);
           end
       end
       p=p+log(probabilities(i));
       ps=[ps,p];
   end
   
end

% maximum olanı aralardan çekip alma
function c=classify(pixelData,pmfs,probabilities)
   ps=calculateProbability(pixelData,pmfs,probabilities);
   [~,c]=max(ps);
end
% test


