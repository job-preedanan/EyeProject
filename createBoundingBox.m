function OutputImg = createBoundingBox(Img,topPoint,belowPoint,leftPoint,rightPoint,colour)

OutputImg = Img;
topPoint = round(topPoint);
belowPoint = round(belowPoint);
leftPoint = round(leftPoint);
rightPoint = round(rightPoint);


ch(1,1:3) = 0;
switch colour
    case 'red'
        ch(1,1) = 255;
    case 'green'
        ch(1,2) = 255;
    case 'blue'
        ch(1,3) = 255;
    case 'pink'
        ch(1,1) = 100;
        ch(1,2) = 25;
        ch(1,3) = 70;
end    

% top
OutputImg(topPoint,leftPoint:rightPoint,1) = ch(1,1);
OutputImg(topPoint,leftPoint:rightPoint,2) = ch(1,2);
OutputImg(topPoint,leftPoint:rightPoint,3) = ch(1,3);
% below
OutputImg(belowPoint,leftPoint:rightPoint,1) = ch(1,1);
OutputImg(belowPoint,leftPoint:rightPoint,2) = ch(1,2);
OutputImg(belowPoint,leftPoint:rightPoint,3) = ch(1,3); 
% left
OutputImg(topPoint:belowPoint,leftPoint,1) = ch(1,1);
OutputImg(topPoint:belowPoint,leftPoint,2) = ch(1,2);
OutputImg(topPoint:belowPoint,leftPoint,3) = ch(1,3);            
%right
OutputImg(topPoint:belowPoint,rightPoint,1) = ch(1,1);
OutputImg(topPoint:belowPoint,rightPoint,2) = ch(1,2);
OutputImg(topPoint:belowPoint,rightPoint,3) = ch(1,3);