prefix="data/";
datas=["GrayImage.jpeg","ColorImage.tif"];

for i=1:2
    hold on;
    Im=imread(prefix+datas(i));
    figure,imshow(Im);
    title("Original Image "+int2str(i));
    hsv=rgb2hsv(Im);
    v=hsv(:,:,3);
    pixelData=uint8(255 * v); % 0-1 arasındaki değerleri 0-255 arasına çekiyoruz.
    numberOfPixel=size(pixelData,1)*size(pixelData,2);%toplam pixellerin sayısı
    hist=histCalculator(pixelData);
    pdf=pdfCalculator(hist,numberOfPixel);
    cdf=cdfCalculator(pdf);
    figure,bar(hist);
    title("old histogram "+int2str(i));
    figure,stairs(cdf);
    title("old cdf " +int2str(i));
    hIm=histEq(pixelData,numberOfPixel,255,256);
    hist=histCalculator(hIm);
    figure,bar(hist);
    title("new histogram "+int2str(i));
    pdf=pdfCalculator(hist,numberOfPixel);
    cdf=cdfCalculator(pdf);
    figure,stairs(cdf);
    title("new cdf "+int2str(i));
    hIm=double(hIm)./255;
    hsv(:,:,3)=hIm;
    rgb=hsv2rgb(hsv);
    figure,imshow(rgb);
    title("Histogram equalized version "+int2str(i));
    hold off;
end

%Histogram Hesaplama
function hist=histCalculator(pixelData)
   hist=zeros(256,1);
   for i=1:size(pixelData,1)
        for j=1:size(pixelData,2)
            value=pixelData(i,j);
            hist(value+1)=hist(value+1)+1;
        end
    end
end

%PDF Hesaplama
function pdf=pdfCalculator(hist,numberOfPixel)
  pdf=hist/numberOfPixel;
end

%CDF Hesaplama
function cdf=cdfCalculator(pdf)
    cdf=cumsum(pdf);
end

%CDF'i Lineer hale getirme değer aralıklarını değiştirme
function cdfEq=cdfEqCalculator(cdf,maxPixelValue,n)
    cdfEq=zeros(256,1);
    for i=1:n
       cdfEq(i)=round(cdf(i)*maxPixelValue);
    end
end

%Histogram Eşitleme yöntemi
function output=histEq(Im,numberOfPixel,maxPixelValue,n)
    hist=histCalculator(Im);
    pdf=pdfCalculator(hist,numberOfPixel);
    cdf=cdfCalculator(pdf);
    cdfEq=cdfEqCalculator(cdf,maxPixelValue,n);
    output=uint8(zeros(size(Im,1),size(Im,2)));
    for i=1:size(Im,1)
        for j=1:size(Im,2)
             output(i,j)=cdfEq(Im(i,j)+1);
        end
    end
end