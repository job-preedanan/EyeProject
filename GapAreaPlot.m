function GapAreaPlot(area,lengthdata,imgid)

for i = length(area):-1:length(area) - lengthdata
    if area(i) < 20
        startidx = i;
        lastidx = length(area);
        break;
    end

end

titlename = ['Gap area of ' imgid ' from ' num2str(startidx) ' to ' num2str(lastidx)];
plot(startidx:lastidx,area(startidx:lastidx)),title(titlename),xlabel('Image ID'),ylabel('Area (pixels)');