function [RGBcropimg,imgcrop2] = PreClearBorderEye(imgcrop,RGBcropimg,idx,imgid)
% SE = strel('square', 5);
% imgcrop2 = imdilate(imgcrop,SE);
imgcrop2 = bwareaopen(imgcrop,250);

%------------------------------TOP------------------------------------------
%histogram of top image column
bpixelcol_top = zeros(1,size(imgcrop2,2));
for j = 1:size(imgcrop2,2)
    bpixelcol_top(1,j) = length(find(imgcrop2(1:round(size(imgcrop2,1)/2),j) == 0));   %number of black pixel in that column
end
% plot(bpixelcol);

%left line : loop column left -> right
for k = 1:length(bpixelcol_top)
    if bpixelcol_top(1,k) < min(bpixelcol_top) + 40
       imgcrop2(1:round(size(imgcrop2,1)/2),k) = 1;
       break;      
    end
end

%right line : loop column right -> left  
for k = length(bpixelcol_top):-1:1
    if bpixelcol_top(1,k) < min(bpixelcol_top) + 40
       imgcrop2(1:round(size(imgcrop2,1)/2),k) = 1;
       break;      
    end
end

%------------------------------BOTTOM------------------------------------------
%histogram of bottom image column
bpixelcol_bottom = zeros(1,size(imgcrop2,2));
for j = 1:size(imgcrop2,2)
    bpixelcol_bottom(1,j) = length(find(imgcrop2(round(size(imgcrop2,1)/2)+1:size(imgcrop2,1),j) == 0));   %number of black pixel in that column
end
% plot(bpixelcol);

%left line : loop column left -> right
for k = 1:length(bpixelcol_bottom)
    if bpixelcol_bottom(1,k) < min(bpixelcol_bottom) + 40
       imgcrop2(round(size(imgcrop2,1)/2) +1 : size(imgcrop2,1),k) = 1;
       break;      
    end
end

%right line : loop column right -> left  
for k = length(bpixelcol_bottom):-1:1
    if bpixelcol_bottom(1,k) < min(bpixelcol_bottom) + 40
       imgcrop2(round(size(imgcrop2,1)/2) +1 : size(imgcrop2,1),k) = 1;
       break;      
    end
end

% filename = ['C:\Users\Lenovo\Documents\MATLAB\EyeProject\EyesData\' imgid '\cropImgBW\figure_' num2str(idx) '.jpg'];
% figure(1),subplot(2,2,1),imshow(RGBcropimg);
% figure(1),subplot(2,2,2),imshow(imgcrop2);
% figure(1),subplot(2,2,3),plot(bpixelcol_top);
% figure(1),subplot(2,2,4),plot(bpixelcol_bottom);
% saveas(figure(1),filename)




