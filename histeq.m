prefix="data/";

Im=imread(prefix+'ColorImage.tif');

figure,imshow(Im);
title('Original Image');
hsv=rgb2hsv(Im);
v=hsv(:,:,3);
pixelData=uint8(255 * v);


numberOfPixel=size(pixelData,1)*size(pixelData,2);

hist=histCalculator(pixelData);
pdf=pdfCalculator(hist,numberOfPixel);
cdf=cdfCalculator(pdf);
hIm=histEq(pixelData,numberOfPixel,255,256);
figure,imshow(hIm);

hIm=double(hIm)./255;
hsv(:,:,3)=hIm;
rgb=hsv2rgb(hsv);
figure,imshow(rgb);
title('hist eq him');
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