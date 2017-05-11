function BlackEye = CheckBlackEye2(CropRGB,idxname,eye,startidx,lastidx,BlackEye)
global baseName;
%% find black region using for subtracting orange region (reducing dark orange region)
Bcrop=rgb2gray(CropRGB);
level = 0.2;    %change here
Bcrop=im2bw(Bcrop,level);
Bcrop = imcomplement(Bcrop);
BlackContour=bwconncomp(Bcrop);
PropBlack  = regionprops(BlackContour,'Area','PixelList','Centroid');
if eye == 0  %left eye : Black --Orange -- White
    %find left black region
    BlackLeftCen = PropBlack(1).Centroid(1,1);
    for n = 1:BlackContour.NumObjects                         %find min centroid
        BlackLeftTemp = PropBlack(n).Centroid(1,1);
        if BlackLeftTemp < BlackLeftCen
            BlackLeftCen = BlackLeftTemp;
        end
    end    
    
    for i = 1:BlackContour.NumObjects
        if PropBlack(i).Centroid ~= BlackLeftCen   %not max region
            for a = 1:size(PropBlack(i).PixelList,1)
                x = PropBlack(i).PixelList(a,2);    %x
                y = PropBlack(i).PixelList(a,1);    %y
                Bcrop(x,y) = 0;
            end
        end   
    end
elseif eye == 1  %right eye : White --Orange -- Black
    %find right black region 
    BlackRightCen = PropBlack(1).Centroid(1,1);
    for n = 1:BlackContour.NumObjects                         %find max centroid
        BlackRightTemp = PropBlack(n).Centroid(1,1);
        if BlackRightTemp > BlackRightCen
            BlackRightCen = BlackRightTemp;
        end
    end 
    
    for i = 1:BlackContour.NumObjects
        if PropBlack(i).Centroid ~= BlackRightCen   %not max region
            for a = 1:size(PropBlack(i).PixelList,1)
                x = PropBlack(i).PixelList(a,2);    %x
                y = PropBlack(i).PixelList(a,1);    %y
                Bcrop(x,y) = 0;
            end
        end   
    end   
    
end

%% find orange region 

Ocrop1 = HueSegmentation(CropRGB,'orange');    %Hue segmentation
Ocrop = Ocrop1 - Bcrop;%add
Ocrop( Ocrop < 0) = 0;
Ocrop = bwareaopen(Ocrop,150);
% figure(2),subplot(1,4,1),imshow(Bcrop);
% figure(2),subplot(1,4,2),imshow(Ocrop1);
% figure(2),subplot(1,4,3),imshow(Ocrop);

OrangeContour=bwconncomp(Ocrop);
propOrange  = regionprops(OrangeContour,'Area','PixelList','Centroid');

if eye == 0  %left eye : Black --Orange -- White
    %find left orange region
    OrangeLeftCen = propOrange(1).Centroid(1,1);
    for n = 1:OrangeContour.NumObjects                         %find min centroid
        OrangeLeftTemp = propOrange(n).Centroid(1,1);
        if OrangeLeftTemp < OrangeLeftCen
            OrangeLeftCen = OrangeLeftTemp;
        end
    end    
    %remove region not centroid region
    for i = 1:OrangeContour.NumObjects
        if propOrange(i).Centroid ~= OrangeLeftCen  
            for a = 1:size(propOrange(i).PixelList,1)
                x = propOrange(i).PixelList(a,2);    %x
                y = propOrange(i).PixelList(a,1);    %y
                Ocrop(x,y) = 0;
            end
        end   
    end
elseif eye == 1  %right eye : White --Orange -- Black
    %find right orange region 
        
    OrangeRightCen = propOrange(1).Centroid(1,1);
    for n = 1:OrangeContour.NumObjects                         %find max centroid
        OrangeRightTemp = propOrange(n).Centroid(1,1);
        if OrangeRightTemp > OrangeRightCen
            OrangeRightCen = OrangeRightTemp;
        end
    end 
    %remove region not centroid region
    for i = 1:OrangeContour.NumObjects
        if propOrange(i).Centroid ~= OrangeRightCen   
            for a = 1:size(propOrange(i).PixelList,1)
                x = propOrange(i).PixelList(a,2);    %x
                y = propOrange(i).PixelList(a,1);    %y
                Ocrop(x,y) = 0;
            end
        end   
    end   
end
% figure(2),subplot(1,4,4),imshow(Ocrop);

%% find white region 
Wcrop=rgb2gray(CropRGB);
level = graythresh(Wcrop);
Wcrop=im2bw(Wcrop,level);
Wcrop = Wcrop - Ocrop;      %subtract with orange image
Wcrop(Wcrop < 0) = 0; 
 

% Wcrop = HueSegmentation(CropRGB,'white');

cn=bwconncomp(Wcrop);
Prop2  = regionprops(cn,'Area','PixelList');
WhiteArea=max([Prop2.Area]);
for i = 1:cn.NumObjects
    if Prop2(i).Area ~= WhiteArea   %not max region
        for a = 1:size(Prop2(i).PixelList,1)
            x = Prop2(i).PixelList(a,2);    %x
            y = Prop2(i).PixelList(a,1);    %y
            Wcrop(x,y) = 0;
        end
    end    
end
% WhiteArea = length(find(Wcrop == 1));

%% check position of orange region
% cn1=bwconncomp(Wcrop);
% propWhite  = regionprops(cn1,'Centroid','PixelList');
% cn2=bwconncomp(Ocrop);
% propOrange  = regionprops(cn2,'Centroid','PixelList');
% % txt2 = sprintf('Centroid Wh : O = %d : %d',propWhite.Centroid(1,1),propOrange.Centroid(1,1));
% % disp(txt2);
% if eye == 0  %left eye : Orange -- White
%     %check centroid in x-axis
%     if propWhite.Centroid(1,1) < propOrange.Centroid(1,1)        %remove this sinario
%         for a = 1:size(propOrange.PixelList,1)
%             x = propOrange.PixelList(a,2);    %x
%             y = propOrange.PixelList(a,1);    %y
%             Ocrop(x,y) = 0;
%         end
%     end
%   
% elseif eye == 1           %Right eye : White -- Orange
%     %check centroid in x-axis
%     if propWhite.Centroid(1,1) > propOrange.Centroid(1,1)        %remove this sinario
%         for a = 1:size(propOrange.PixelList,1)
%             x = propOrange.PixelList(a,2);    %x
%             y = propOrange.PixelList(a,1);    %y
%             Ocrop(x,y) = 0;
%         end
%     end   
% end



%% create Edge ROI image of orange region and white region
OWcropLine = CropRGB;
LineOrangeArea = edge(Ocrop,'Canny');
LineWhiteArea = edge(Wcrop,'Canny');
% figure(5),subplot(1,2,1),imshow(LineWhiteArea);
% figure(5),subplot(1,2,2),imshow(LineOrangeArea);
for i = 1:size(LineOrangeArea,1)
    for j = 1:size(LineOrangeArea,2)    
        %orange region - green line
        if LineOrangeArea(i,j) == 1
            OWcropLine(i,j,1) = 0;
            OWcropLine(i,j,2) = 255;
            OWcropLine(i,j,3) = 0;
        end
        %white region - red line
%         if LineWhiteArea(i,j) == 1        
%             OWcropLine(i,j,1) = 255;
%             OWcropLine(i,j,2) = 0;
%             OWcropLine(i,j,3) = 0;
%         end
    end
end

%% calculate ratio

OrangeArea = length(find(Ocrop == 1));
WhiteArea = length(find(Wcrop == 1));
TotalArea = size(Ocrop,1)*size(Ocrop,2);
normOrangeArea = OrangeArea/TotalArea;
% txt = sprintf(' ID : %s | seq : %d | ratio of orange and total = %d \n',imgid,idx,normOrangeArea);
% disp(txt);
figure(1),subplot(1,2,1),imshow(Ocrop),title(['Orange/Total Area = ' num2str(OrangeArea) '/' num2str(TotalArea)]);
figure(1),subplot(1,2,2),imshow(OWcropLine),title(['Ratio :' num2str(normOrangeArea)]);
filename = [baseName  '\BlackEyeRegion\' num2str(startidx) '-' num2str(lastidx) '\SegmentedBlackEye-' idxname '.jpg'];
saveas(figure(1),filename)

if BlackEye == 0    %still not in black eye
    if normOrangeArea < 0.07    %temp value
        BlackEye = 0;  
        disp('Not in black eye');
    else
        BlackEye = 1;
        disp('In black eye');
    end
end

end