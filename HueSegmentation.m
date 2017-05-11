function SegmentImg = HueSegmentation(RGBImage,colour)

HSVImage = rgb2hsv(RGBImage);
gImage = rgb2gray(RGBImage);
Hue = HSVImage(:,:,1);
Val = HSVImage(:,:,3);
SegmentImg = zeros(size(Hue));

if strcmp(colour,'orange') == 1
    LowerLimit = 0/360;
    UpperLimit = 80/360;
    ValTh1 = 0.2;
    for j = 1:size(Hue,2)
        for i = 1:size(Hue,1)
            if (Hue(i,j) > LowerLimit) && (Hue(i,j) < UpperLimit) && (gImage(i,j) > 20) && (gImage(i,j) < 240) %&& (Val(i,j) < ValTh2) 
                SegmentImg(i,j) = 1;
            else
                SegmentImg(i,j) = 0;
            end
        end
    end
    
elseif strcmp(colour,'white') == 1
%     LowerLimit = 200/360;
%     UpperLimit = 230/360;
        ValTh = 0.7;
    for j = 1:size(Hue,2)
        for i = 1:size(Hue,1)
%             if (Hue(i,j) > LowerLimit) && (Hue(i,j) < UpperLimit)
            if  Val(i,j) > ValTh
                SegmentImg(i,j) = 1;
            else
                SegmentImg(i,j) = 0;
            end
        end
    end  
end