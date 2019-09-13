function testC_N
% clc;
% clear;
% close all;
%t1用来计时， 可以看一下1ABpoint 1Aline和1Bline的文件结构
t1=clock;
img1='.\imgs\1_A.jpg';
img2='.\imgs\1_B.jpg';
pmfile=strcat('.\pts&lines\1ABpoint.txt');
ltxt1='.\pts&lines\1Aline.txt';
ltxt2='.\pts&lines\1Bline.txt';

disp(' Reading files and preparing...');
% 得到两张图片的直线的信息，这里有直线的斜率截距，还有两个LSD检测出的端点，还有梯度
[lines1, pointlist1]=paras(img1,ltxt1);
[lines2, pointlist2]=paras(img2,ltxt2);
 P = load(pmfile);%P是特征点向量，每一行是一对特征点（x1,y1,x2,y2)
 line1=lines1;
 line2=lines2;
 endpoint=zeros(1,4);
% numlist=(1:9); %产生1-14数字，用于排列组合，14是特征点对数
% combination=combntns(numlist,4);%组合函数，产生所有C14-4的组合
%对第一幅图片的直线计算特征向量
 for i=1:length(line1)%遍历直线1列表
      k=0;

     for j=1:length(P)-4;%以10的步长遍历组合矩阵，用来产生特征数向量（这里取10为步长是因为14个点组合为1000，正好产生101个特征数）
         k=k+1;%变量k用来扩展特征向量长度
         %NEWCN函数，用4个点来得到直线的两个端点
        [endpoint(1,1),endpoint(1,2),endpoint(1,3),endpoint(1,4)]=NEWCN(P(j,1),P(j,2),P(j+1,1),P(j+1,2),P(j+3,1),P(j+3,2),line1(1,i));


        %charanums5求特征数函数，输入前4个分别是两个直线端点的x,y(x1,y1,x2,y2,x3,y3,x4,y4,x5,y5)
        %后面三个点以组合矩阵combination作为索引，改变点的组合
        CC=charanums5(endpoint(1,1),endpoint(1,2),endpoint(1,3),endpoint(1,4),P(j,1),P(j,2),P(j+2,1),P(j+2,2),P(j+3,1),P(j+3,2));
       line1(1,i).CN(1,k)=CC;%然后将line1的CN向量的k项置为算出来的特征数

     end
 end
% 对第二幅图片的直线执行同样的操作
  for i=1:length(line2)
      k=0;
     for j=1:length(P)-4;
         k=k+1;
        [endpoint(1,1),endpoint(1,2),endpoint(1,3),endpoint(1,4)]=NEWCN(P(j,3),P(j,4),P(j+1,3),P(j+1,4),P(j+2,3),P(j+2,4),line2(1,i));

       CC=charanums5(endpoint(1,1),endpoint(1,2),endpoint(1,3),endpoint(1,4),P(j+1,3),P(j+1,4),P(j+2,3),P(j+2,4),P(j+3,3),P(j+3,4));
       line2(1,i).CN(1,k)=CC;

     end
  end

% 新建一个匹配矩阵，前两个维度分别代表图片1图片2的直线序号，最后一个维度，1是这两条直线特征向量中有效特征数的票数
%具体算法是，两条直线对应位置的特征数做差绝对值小于1为赞成票，votes+1，然后只有这些票数参与计算两个向量的欧式距离
%以这两个向量的欧式距离作为两个向量的相似程度，然后最后一个维度的2，存放的是这两条直线用有效特征数计算出来的相似度
match=zeros(length(line1),length(line2),2);

%计算两张图片直线的相似度和特征向量得票数
 for i=1:length(line1)%遍历图片1直线列表
     for j=1:length(line2)%遍历图片2直线列表
         votes=0;%置票数为零
         sus=line1(i).CN-line2(j).CN;
         for k=1:length(line1(i).CN)%遍历特征向量
            if(abs(line1(i).CN(k)-line2(j).CN(k))<1)%如果差值绝对值小于1
                votes=votes+1;
                c(k)=(line1(i).CN(k)-line2(j).CN(k)).^2;
            else
                c(k)=1;
            end
            %计算对应位置两特征数差值的平方，存在向量c中

         end
         d=sqrt(sum(c(:)));
         s=1/(1+d);
         match(i,j,1)=votes;
         match(i,j,2)=s;

     end
 end
% voteseen=match(:,:,1);为了在工作区可视化票数

%图片1匹配向量和图片2匹配向量，都给每条直线留了10个潜在匹配，对应位置序号就是直线序号
  matched1=zeros(length(line1),10);
  matched2=zeros(length(line2),10);
  
 for i=1:length(line1)
 temp=find(match(i,:,1)>=max(match(i,:,1)*0.8));%temp是找到第一张图片的直线i跟第二张图片所有的特征向量相似度中，前20%票数的几个
  temp2=find(match(i,:,2)==max(match(i,temp,2)))%temp2是从前20%票数最大的中找到相似度最高的，视作成功匹配
  matched1(i,1:length(temp2)) = temp2;
 end
%对图片2进行相同操作
  for i=1:length(line2)
     temp=find(match(:,i,1)>=max(match(:,i,1)*0.8));
     temp2=find(match(:,i,2)==max(match(temp,i,2)))
     matched2(i,1:length(temp2)) = temp2;       
  end
 %初始化最终匹配矩阵，序号就是直线对序号，（n,1)是图片1直线序号，（n,2)是图片2直线序号
  final_matches=zeros(length(line1),2);
  k=1;%用来计算到底有几对匹配直线对
  for i=1:length(line1)
  for j=1:10
      %判断条件，如果图片1的直线i匹配直线j不为空，且图片2的直线j匹配直线中能找到直线i,则视为匹配直线对
      if(matched1(i,j)~=0&&isempty(find(matched2(matched1(i,j),:)==i,1))~=1)

          final_matches(k,1)=i;
          final_matches(k,2)=matched1(i,j);
          k=k+1;
      end
  end
  
  end
match1=match(:,:,1);
match2=match(:,:,2);
 draw(img1,line1,final_matches,1);
 draw(img2,line2,final_matches,2);
 

 function draw(img,lines,matchlist,num)
     %画线函数，参数是图片，直线列表，最终匹配列表，输出图片号
number=0;
I=imread(img);
len=length(matchlist);

    figure, imshow(I),hold on 

         
    
        for i = 1:len
            if matchlist(i,num)~=0
                number=number+1;
                xy = [lines(matchlist(i,num)).point1; lines(matchlist(i,num)).point2];
                plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','red');
                text((xy(1,1)+xy(2,1))/2,(xy(1,2)+xy(2,2))/2,num2str(i));
            end   
        end
        title(number);
    hold off;

 end

%  function draw2(img,lines,matchlist)
% number=0;
% I=imread(img);
% len=length(matchlist);
% 
%     figure, imshow(I),hold on 
% 
%          
%     
%         for i = 1:len
%             if matchlist(i)~=0
%                 number=number+1;
%                 xy = [lines(matchlist(i)).point1; lines(matchlist(i)).point2];
%                 plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','red');
%                 text((xy(1,1)+xy(2,1))/2,(xy(1,2)+xy(2,2))/2,num2str(i));
%             end   
%         end
%         title(number);
%     hold off;
% 
%  end

t2=clock;
disp(etime(t2,t1));
end