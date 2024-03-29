
function [llines, pointlist]=paras(img,endpotxt)

I=imread(img);
imsize=size(I);
% 显示像素数（数组元素个数）
    if numel(imsize)>2 
% 转成灰度
        I = rgb2gray(I);  
    end

    points=load(endpotxt);
    for i=1:length(points)
        llines(i).point1=[points(i,1),points(i,2)]; 
        llines(i).point2=[points(i,3),points(i,4)];
        
        if (llines(i).point2(1)~=llines(i).point1(1))
%             k斜率·b截距
            llines(i).k=(llines(i).point2(2)-llines(i).point1(2))/(llines(i).point2(1)-llines(i).point1(1));
            llines(i).b=llines(i).point1(2)-llines(i).k*llines(i).point1(1);
        else
            llines(i).k=Inf;
            llines(i).b=Inf;
        end
        
    end
pointlist=intspoints(llines,imsize);
 llines=linegradient(I,llines);

end


