x1=cos(0.10*2*pi*(1:7));
x2=cos(0.11*2*pi*(1:7));

xCorrOutput=xcorr(x1,x2);
crossCorrelationOutput=crossCorrelation(x1,x2);
fourierCrossCorrelationOutput=fourierCrossCorrelation(x1,x2);
disp(xCorrOutput);
disp(crossCorrelationOutput);
disp(fourierCrossCorrelationOutput);
function out=crossCorrelation(x1,x2)
    len=length(x1)+length(x2)-1;
    if length(x1)>length(x2)
        x2=[x2,zeros(1,length(x1)-length(x2))];
    elseif length(x1)<length(x2)
        x1=[x1,zeros(1,length(x2)-length(x1))];
    end
    out=zeros(1,len);
    pivot=length(x2);
    lastPivot=length(x2);
    index=1;
    for i=1:len
        l=lastPivot-pivot;
        if length(x1)<(index+l)
            out(i)=dot(x1(index:length(x1)),x2(pivot:pivot+(length(x1)-index)));
        else
            out(i)=dot(x1(index:index+l),x2(pivot:pivot+l));
        end
        if pivot>1
            pivot=pivot-1;
        else
            index=index+1;
        end

    end
end
function out=fourierCrossCorrelation(x1,x2)
    l1=length(x1);
    l2=length(x2);
    l=l1+l2-1;
    x2Flip=fliplr(x2);
    x2Fft=fft(x2Flip,l);
    x1Fft=fft(x1,l);
    result=x1Fft.*x2Fft;
    out=ifft(result);
end