function EyesCrop(imgid,startidx,lastidx,eyeside)
% imgid = image ID
% startidx = start index
% lastidx = last index
% eyeside - 0 : left    - 1 : right
% result = croped RGB img save in 'cropImg' folder in that ID folder

imgid = num2str(imgid);
baseName = ['C:\Users\Lenovo\Documents\MATLAB\EyeProject\EyesData\' imgid ];     %change path name

if eyeside == 0 %lefteye
    eye = '-LeftEye-';
elseif eyeside == 1 %righteye
    eye = '-RightEye-';
end

% foldername1 = 'cropImgRGB';
% foldername2 ='cropImgBW';
% foldername3 ='cropImgROI';
% mkdir(baseName,foldername1);
% mkdir(baseName,foldername2);
% mkdir(baseName,foldername3);
foldername = 'OrangeWhiteRegion';
mkdir(baseName,foldername);

%loop img
numseq =0;
for idx = startidx:lastidx
    if idx <= 9
        idxname =  ['\full-image-' imgid eye '0000' num2str(idx)];
    elseif idx > 9 && idx <= 99 
        idxname =  ['\full-image-' imgid eye '000' num2str(idx)];
    elseif idx > 99 && idx <= 999
        idxname =  ['\full-image-' imgid eye '00' num2str(idx)];
    elseif idx > 999
        idxname =  ['\full-image-' imgid eye '0' num2str(idx)];
    end
    
    % collect center(x,y) and r from first img
    if idx == startidx
            
        FileName = [baseName idxname '.jpg'];
        firstimg = imread(FileName);
        pts = readPoints(firstimg, 2);
        centerROI_X = pts(1,2);
        centerROI_Y = pts(2,2);
        rDist = sqrt((pts(1,1) - pts(1,2))^2 + (pts(2,1) - pts(2,2))^2); 
        H_crop = 2*rDist/3;
        close all;
        
    else 
    
        FileName = [baseName idxname '.jpg'];
        img = imread(FileName);

        %shifting crop center 
        numseq = numseq +1;
        if eyeside == 0
            centerROI_X = round(pts(1,2) + numseq*2);
        elseif eyeside == 1
            centerROI_X = round(pts(1,2) - numseq*2);
        end
        %crop
        RGBcropimg = img(centerROI_Y-round(H_crop/2):centerROI_Y+round(H_crop/2),centerROI_X-60:centerROI_X+60,:);      % manually change boundary size here
        
        %check is RGBcropimg processed in black eye ?
        BlackEye = CheckBlackEye(RGBcropimg,imgid,idx,eyeside);
        
        BlackEye = 0;                    %temp || remove if you want to process below
        
        if (BlackEye)
            % bw img
            gcropimg = rgb2gray(RGBcropimg);
            level = graythresh(gcropimg);
            bwcropimg = im2bw(gcropimg,level);    

            [RGBcropimg,bwcropimg] = PreClearBorderEye(bwcropimg,RGBcropimg,idx,imgid);   %%
    %         imshow(bwcropimg);
            bwcropimg(1,:) = 255;
            bwcropimg(size(bwcropimg,1),:) = 255;

            bwcropimg2 = imcomplement(bwcropimg);
            bwcropimg2 = imclearborder(bwcropimg2);
            bwcropimg2 = bwareaopen(bwcropimg2,200);
            linecropimg = edge(bwcropimg2,'Canny');
            bwcropimg2 = imcomplement(bwcropimg2);

            area(idx) = length(find(bwcropimg2 == 0));     % count black pixel

            % merge ROI to RGB cropimg
            ROIcropImg = RGBcropimg;
            for i = 1:size(linecropimg,1)
                for j = 1:size(linecropimg,2)
                    if linecropimg(i,j) == 1
                        ROIcropImg(i,j,1) = 255;
                        ROIcropImg(i,j,2) = 0;
                        ROIcropImg(i,j,3) = 0;
                    end
                end
            end

    %         filename = ['C:\Users\Lenovo\Documents\MATLAB\EyeProject\EyesData\' imgid '\cropImgBW\figure_' num2str(idx) '.jpg'];
    %         figure(1),subplot(2,2,1),imshow(RGBcropimg),title('RGB crop');
    %         figure(1),subplot(2,2,2),imshow(bwcropimg),title('BW crop');
    %         figure(1),subplot(2,2,3),imshow(bwcropimg2),title('Gap crop');
    %         figure(1),subplot(2,2,4),imshow(ROIcropImg),title('ROI crop');
    %         saveas(figure(1),filename)

    %         savenameRGB = [baseName '\cropImgRGB\' imgid eye num2str(idx) '.jpg'];
    %         savenameBW = [baseName '\cropImgBW\' imgid eye num2str(idx) '.jpg'];
    %         savenameROI = [baseName '\cropImgROI\' imgid eye num2str(idx) '.jpg'];
    %         imwrite(RGBcropimg,savenameRGB);
    %         imwrite(bwcropimg2,savenameBW);
    %         imwrite(ROIcropImg,savenameROI);
            
%         else
%             disp('Not in black eye');
        end
    end
end

% lengthdata = lastidx - startidx + 1;
% GapAreaPlot(area,lengthdata,imgid);
% titlename = ['Gap area of ' imgid ' from ' num2str(startidx) ' to ' num2str(lastidx)];
% plot(startidx:lastidx,area(startidx:lastidx)),title(titlename),xlabel('Image ID'),ylabel('Area (pixels)');


