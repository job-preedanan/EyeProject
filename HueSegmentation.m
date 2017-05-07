function SegmentImg = HueSegmentation(RGBImage,colour)
HSVImage = rgb2hsv(RGBImage);
Hue = HSVImage(:,:,1);
Val = HSVImage(:,:,3);
SegmentImg = zeros(size(Hue));

if strcmp(colour,'orange') == 1
    LowerLimit = 0/360;
    UpperLimit = 60/360;
    ValTh = 0.5;
    for j = 1:size(Hue,2)
        for i = 1:size(Hue,1)
            if (Hue(i,j) > LowerLimit) && (Hue(i,j) < UpperLimit) && (Val(i,j) > ValTh)
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