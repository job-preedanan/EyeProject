function area = GapAreaPlot(area,imgid,StartAreaIdx,startidx,lastidx)
global baseName

% interpolation
for i = 1:lastidx - StartAreaIdx +1
    if (i > 3) && (i < lastidx - StartAreaIdx +1) && (area(i) < area(i-1) + 300)
        area(i) = (area(i+1) + area(i-1)) /2;
    elseif (i == lastidx - StartAreaIdx +1) && (area(i) < area(i-1) + 300)
        area(i) = area(i-1);
    end

end

% remove false gap region
for i = lastidx - StartAreaIdx +1:-1:1
    if (i == lastidx - StartAreaIdx +1)
        if (area(i) < 150) 
            area(1:i) = 0;
            break;
        end    
    else
        if (area(i) < 150) || (area(i) + 1000 < area(i+1))
            area(1:i) = 0;
            break;
        end
    end
end

titlename = ['Gap area of ' imgid ' from ' num2str(StartAreaIdx) ' to ' num2str(lastidx)];
figure(2),plot(area),title(titlename),xlabel('Image ID'),ylabel('Area (pixels)');
filename = [baseName  '\FullROI\' num2str(startidx) '-' num2str(lastidx) '\GapArea-' imgid '=' num2str(StartAreaIdx) '-' num2str(lastidx)  '.jpg'];
saveas(figure(2),filename)