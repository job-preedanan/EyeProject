function EyesCrop(imgid,startidx,lastidx,eyeside)
% imgid = image ID
% startidx = start index
% lastidx = last index
% eyeside - 0 : left    - 1 : right
% result = croped RGB img save in 'cropImg' folder in that ID folder
close;
clc;
manualTh = 0.2;    % 0 - Otsu threshold ,otherwise use manual threshold (0-1) in case of very dark image
imgid = num2str(imgid);
global baseName
baseName = ['C:\Users\Lenovo\Documents\MATLAB\EyeProject\EyesData\' imgid ];     %change path name

if eyeside == 0 %lefteye
    eye = '-LeftEye-';
elseif eyeside == 1 %righteye
    eye = '-RightEye-';
end

%create folder..
foldername1 = ['CropRGB\' num2str(startidx) '-' num2str(lastidx)];
foldername2 = ['CropBW\' num2str(startidx) '-' num2str(lastidx)];
foldername3 = ['FullROI\' num2str(startidx) '-' num2str(lastidx)];
foldername4 = ['BlackEyeRegion\' num2str(startidx) '-' num2str(lastidx)];
mkdir(baseName,foldername1);
mkdir(baseName,foldername2);
mkdir(baseName,foldername3);
mkdir(baseName,foldername4);

%loop img
numseq =0;
areaSeq = 0;
BlackEye = 0;
for idx = startidx:lastidx
    if idx <= 9
        idxname = [imgid eye '0000' num2str(idx)];
        fullImgname =  ['\full-image-' idxname];
    elseif idx > 9 && idx <= 99 
        idxname = [imgid eye '000' num2str(idx)];
        fullImgname =  ['\full-image-' idxname];
    elseif idx > 99 && idx <= 999
        idxname = [imgid eye '00' num2str(idx)];
        fullImgname =  ['\full-image-' idxname];
    elseif idx > 999
        idxname = [imgid eye '0' num2str(idx)];
        fullImgname =  ['\full-image-' idxname];
    end
    disp(idxname);
    
    % collect center(x,y) and r from first img
    if idx == startidx
            
        FileName = [baseName fullImgname '.jpg'];
        firstimg = imread(FileName);
        pts = readPoints(firstimg, 2);
        centerROI_X = pts(1,2);
        centerROI_Y = pts(2,2);
        rDist = sqrt((pts(1,1) - pts(1,2))^2 + (pts(2,1) - pts(2,2))^2); 
        H_crop = 2*rDist/3;
        close all;
        
    else 
    
        FileName = [baseName fullImgname '.jpg'];
        img = imread(FileName);

        %shifting crop center 
        numseq = numseq +1;
        if eyeside == 0
            centerROI_X = round(pts(1,2) + numseq*1.5);
        elseif eyeside == 1
            centerROI_X = round(pts(1,2) - numseq*1.5);
        end
        
        %crop
        RGBcropimg = img(centerROI_Y-round(H_crop/2):centerROI_Y+round(H_crop/2),centerROI_X-70:centerROI_X+70,:);      % manually change boundary size here
        
        %check is RGBcropimg processed in black eye ?
        BlackEye = CheckBlackEye2(RGBcropimg,idxname,eyeside,startidx,lastidx,BlackEye);
        
        %BlackEye = 1;                    %temp || remove if you want to process below
        
        if (BlackEye)
            areaSeq = areaSeq + 1;
            
            %first sequence
            if areaSeq == 1
                disp('Detect black eye --> start calculate gap area');
                StartAreaIdx = idx;
            end
            
            % bw img
            gcropimg = rgb2gray(RGBcropimg);                   
            if manualTh == 0        %Otsu
                level = graythresh(gcropimg);
            else
                level = manualTh;
            end
            bwcropimg = im2bw(gcropimg,level);    
            
            % Pre-clearborder Fcn
            [RGBcropimg,bwcropimg] = PreClearBorderEye(bwcropimg,RGBcropimg,idx,imgid);   

            bwcropimg(1,:) = 255;
            bwcropimg(size(bwcropimg,1),:) = 255;

            bwcropimg2 = imcomplement(bwcropimg);
            bwcropimg2 = imclearborder(bwcropimg2);
            bwcropimg2 = bwareaopen(bwcropimg2,200);
            linecropimg = edge(bwcropimg2,'Canny');
            %bwcropimg2 = imcomplement(bwcropimg2);

            area(areaSeq) = length(find(bwcropimg2 == 1));     % count white pixel

            % merge ROI to full RGB img
            FullROI = img;
            % create red bounding box of crop image
            FullROI = createBoundingBox(FullROI,centerROI_Y-round(H_crop/2),centerROI_Y+round(H_crop/2),centerROI_X-70,centerROI_X+70,'green');
                      
            for i = 1:size(linecropimg,1)
                for j = 1:size(linecropimg,2)
                    if linecropimg(i,j) == 1
                        FullROI(round(centerROI_Y-(H_crop/2)+i),round(centerROI_X-70+j),1) = 0;
                        FullROI(round(centerROI_Y-(H_crop/2)+i),round(centerROI_X-70+j),2) = 255;
                        FullROI(round(centerROI_Y-(H_crop/2)+i),round(centerROI_X-70+j),3) = 0;
                    end
                end
            end

            savenameRGB = [baseName '\CropRGB\' num2str(startidx) '-' num2str(lastidx) '\cropRGBimage-' idxname '.jpg'];           
            savenameBW = [baseName '\CropBW\' num2str(startidx) '-' num2str(lastidx) '\cropBW-image-' idxname '.jpg'];
            savenameROI = [baseName '\FullROI\' num2str(startidx) '-' num2str(lastidx) '\fullROI-image-' idxname '.jpg'];
            imwrite(RGBcropimg,savenameRGB);
            imwrite(bwcropimg2,savenameBW);
            imwrite(FullROI,savenameROI);
            

        end
    end
end

if isempty(area) == 0
    GapAreaPlot(area,imgid,StartAreaIdx,startidx,lastidx);
end



