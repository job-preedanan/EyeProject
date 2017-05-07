function BlackEye = CheckBlackEye(CropRGB,imgid,idx,eye)
%% find orange region 
% Ocrop=rgb2gray(CropRGB);
% Ocrop(Ocrop < 150)=0;
% Ocrop(Ocrop > 200)=0;
% Ocrop(Ocrop > 0)=255;
% Ocrop=im2bw(Ocrop);
Ocrop = HueSegmentation(CropRGB,'orange');    %Hue segmentation

cn=bwconncomp(Ocrop);
Prop1  = regionprops(cn,'Area','PixelList');
OrangeArea=max([Prop1.Area]);
for i = 1:cn.NumObjects
    if Prop1(i).Area ~= OrangeArea   %not max region
        for a = 1:size(Prop1(i).PixelList,1)
            x = Prop1(i).PixelList(a,2);    %x
            y = Prop1(i).PixelList(a,1);    %y
            Ocrop(x,y) = 0;
        end
    end   
end

%% find white region 
Wcrop=rgb2gray(CropRGB);
level = graythresh(Wcrop);
Wcrop=im2bw(Wcrop,level);
Wcrop = Wcrop - Ocrop;      %subtract with orange image

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
cn1=bwconncomp(Wcrop);
propWhite  = regionprops(cn1,'Centroid','PixelList');
cn2=bwconncomp(Ocrop);
propOrange  = regionprops(cn2,'Centroid','PixelList');
% txt2 = sprintf('Centroid Wh : O = %d : %d',propWhite.Centroid(1,1),propOrange.Centroid(1,1));
% disp(txt2);
if eye == 0  %left eye : Orange -- White
    %check centroid in x-axis
    if propWhite.Centroid(1,1) < propOrange.Centroid(1,1)        %remove this sinario
        for a = 1:size(propOrange.PixelList,1)
            x = propOrange.PixelList(a,2);    %x
            y = propOrange.PixelList(a,1);    %y
            Ocrop(x,y) = 0;
        end
    end
  
elseif eye == 1           %Right eye : White -- Orange
    %check centroid in x-axis
    if propWhite.Centroid(1,1) > propOrange.Centroid(1,1)        %remove this sinario
        for a = 1:size(propOrange.PixelList,1)
            x = propOrange.PixelList(a,2);    %x
            y = propOrange.PixelList(a,1);    %y
            Ocrop(x,y) = 0;
        end
    end   
end



%% create Edge ROI image of orange region and white region
OWcropLine = CropRGB;
LineOrangeArea = edge(Ocrop,'Canny');
LineWhiteArea = edge(Wcrop,'Canny');
for i = 1:size(LineOrangeArea,1)
    for j = 1:size(LineOrangeArea,2)    
        %orange region - green line
        if LineOrangeArea(i,j) == 1
            OWcropLine(i,j,1) = 0;
            OWcropLine(i,j,2) = 255;
            OWcropLine(i,j,3) = 0;
        end
        %white region - red line
        if LineWhiteArea(i,j) == 1        
            OWcropLine(i,j,1) = 255;
            OWcropLine(i,j,2) = 0;
            OWcropLine(i,j,3) = 0;
        end
    end
end

%% calculate ratio
rationOnW = OrangeArea/WhiteArea;
txt = sprintf(' ID : %s | seq : %d | ratio of orange and write = %d \n',imgid,idx,rationOnW);
disp(txt);
figure(6),subplot(1,3,1),imshow(Ocrop),title(imgid);
figure(6),subplot(1,3,2),imshow(Wcrop),title(num2str(idx));
figure(6),subplot(1,3,3),imshow(OWcropLine),title(num2str(rationOnW));
filename = ['C:\Users\Lenovo\Documents\MATLAB\EyeProject\EyesData\' imgid '\OrangeWhiteRegion\' imgid '_OrangeWhiteRegion_' num2str(idx) '.jpg'];
saveas(figure(6),filename)

if rationOnW < 0.3
    BlackEye = 0;  %temp
    disp('Not in black eye');
else
    BlackEye = 1;
    disp('In black eye');
end

% HSV = rgb2hsv(CropRGB);
% H = HSV(:,:,1); %Hue
% S = HSV(:,:,2); %Saturation
% V = HSV(:,:,3);
% H(H > mean2(H) )=255;  
% S(S > mean2(S))=255; 
% V(V < mean2(V))=0; 
% HSV(:,:,3) = V;
% HSV(:,:,2) = S;
% HSV(:,:,1) = H;  
% C1 = hsv2rgb(HSV); 
% C1_RGB=CropRGB; 
% C1_Gray=rgb2gray(C1);
% GC1=zeros(size(C1_Gray)); 
% [r c]=size(C1_Gray);
% for i=1:r
%     for j=1:c
%         if(C1_Gray(i,j)>0)||(C1_Gray(i,j)<0)
%             C1(i,j,1)=0; C1(i,j,2)=0; C1(i,j,3)=0;
%         end
%     end
% end
% GC1(find(C1(:,:,1)~=0))=1;
% GC1=bwareaopen(GC1,150);

end