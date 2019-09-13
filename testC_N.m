function testC_N
% clc;
% clear;
% close all;
%t1������ʱ�� ���Կ�һ��1ABpoint 1Aline��1Bline���ļ��ṹ
t1=clock;
img1='.\imgs\1_A.jpg';
img2='.\imgs\1_B.jpg';
pmfile=strcat('.\pts&lines\1ABpoint.txt');
ltxt1='.\pts&lines\1Aline.txt';
ltxt2='.\pts&lines\1Bline.txt';

disp(' Reading files and preparing...');
% �õ�����ͼƬ��ֱ�ߵ���Ϣ��������ֱ�ߵ�б�ʽؾ࣬��������LSD�����Ķ˵㣬�����ݶ�
[lines1, pointlist1]=paras(img1,ltxt1);
[lines2, pointlist2]=paras(img2,ltxt2);
 P = load(pmfile);%P��������������ÿһ����һ�������㣨x1,y1,x2,y2)
 line1=lines1;
 line2=lines2;
 endpoint=zeros(1,4);
% numlist=(1:9); %����1-14���֣�����������ϣ�14�����������
% combination=combntns(numlist,4);%��Ϻ�������������C14-4�����
%�Ե�һ��ͼƬ��ֱ�߼�����������
 for i=1:length(line1)%����ֱ��1�б�
      k=0;

     for j=1:length(P)-4;%��10�Ĳ���������Ͼ���������������������������ȡ10Ϊ��������Ϊ14�������Ϊ1000�����ò���101����������
         k=k+1;%����k������չ������������
         %NEWCN��������4�������õ�ֱ�ߵ������˵�
        [endpoint(1,1),endpoint(1,2),endpoint(1,3),endpoint(1,4)]=NEWCN(P(j,1),P(j,2),P(j+1,1),P(j+1,2),P(j+3,1),P(j+3,2),line1(1,i));


        %charanums5������������������ǰ4���ֱ�������ֱ�߶˵��x,y(x1,y1,x2,y2,x3,y3,x4,y4,x5,y5)
        %��������������Ͼ���combination��Ϊ�������ı������
        CC=charanums5(endpoint(1,1),endpoint(1,2),endpoint(1,3),endpoint(1,4),P(j,1),P(j,2),P(j+2,1),P(j+2,2),P(j+3,1),P(j+3,2));
       line1(1,i).CN(1,k)=CC;%Ȼ��line1��CN������k����Ϊ�������������

     end
 end
% �Եڶ���ͼƬ��ֱ��ִ��ͬ���Ĳ���
  for i=1:length(line2)
      k=0;
     for j=1:length(P)-4;
         k=k+1;
        [endpoint(1,1),endpoint(1,2),endpoint(1,3),endpoint(1,4)]=NEWCN(P(j,3),P(j,4),P(j+1,3),P(j+1,4),P(j+2,3),P(j+2,4),line2(1,i));

       CC=charanums5(endpoint(1,1),endpoint(1,2),endpoint(1,3),endpoint(1,4),P(j+1,3),P(j+1,4),P(j+2,3),P(j+2,4),P(j+3,3),P(j+3,4));
       line2(1,i).CN(1,k)=CC;

     end
  end

% �½�һ��ƥ�����ǰ����ά�ȷֱ����ͼƬ1ͼƬ2��ֱ����ţ����һ��ά�ȣ�1��������ֱ��������������Ч��������Ʊ��
%�����㷨�ǣ�����ֱ�߶�Ӧλ�õ��������������ֵС��1Ϊ�޳�Ʊ��votes+1��Ȼ��ֻ����ЩƱ�������������������ŷʽ����
%��������������ŷʽ������Ϊ�������������Ƴ̶ȣ�Ȼ�����һ��ά�ȵ�2����ŵ���������ֱ������Ч������������������ƶ�
match=zeros(length(line1),length(line2),2);

%��������ͼƬֱ�ߵ����ƶȺ�����������Ʊ��
 for i=1:length(line1)%����ͼƬ1ֱ���б�
     for j=1:length(line2)%����ͼƬ2ֱ���б�
         votes=0;%��Ʊ��Ϊ��
         sus=line1(i).CN-line2(j).CN;
         for k=1:length(line1(i).CN)%������������
            if(abs(line1(i).CN(k)-line2(j).CN(k))<1)%�����ֵ����ֵС��1
                votes=votes+1;
                c(k)=(line1(i).CN(k)-line2(j).CN(k)).^2;
            else
                c(k)=1;
            end
            %�����Ӧλ������������ֵ��ƽ������������c��

         end
         d=sqrt(sum(c(:)));
         s=1/(1+d);
         match(i,j,1)=votes;
         match(i,j,2)=s;

     end
 end
% voteseen=match(:,:,1);Ϊ���ڹ��������ӻ�Ʊ��

%ͼƬ1ƥ��������ͼƬ2ƥ������������ÿ��ֱ������10��Ǳ��ƥ�䣬��Ӧλ����ž���ֱ�����
  matched1=zeros(length(line1),10);
  matched2=zeros(length(line2),10);
  
 for i=1:length(line1)
 temp=find(match(i,:,1)>=max(match(i,:,1)*0.8));%temp���ҵ���һ��ͼƬ��ֱ��i���ڶ���ͼƬ���е������������ƶ��У�ǰ20%Ʊ���ļ���
  temp2=find(match(i,:,2)==max(match(i,temp,2)))%temp2�Ǵ�ǰ20%Ʊ���������ҵ����ƶ���ߵģ������ɹ�ƥ��
  matched1(i,1:length(temp2)) = temp2;
 end
%��ͼƬ2������ͬ����
  for i=1:length(line2)
     temp=find(match(:,i,1)>=max(match(:,i,1)*0.8));
     temp2=find(match(:,i,2)==max(match(temp,i,2)))
     matched2(i,1:length(temp2)) = temp2;       
  end
 %��ʼ������ƥ�������ž���ֱ�߶���ţ���n,1)��ͼƬ1ֱ����ţ���n,2)��ͼƬ2ֱ�����
  final_matches=zeros(length(line1),2);
  k=1;%�������㵽���м���ƥ��ֱ�߶�
  for i=1:length(line1)
  for j=1:10
      %�ж����������ͼƬ1��ֱ��iƥ��ֱ��j��Ϊ�գ���ͼƬ2��ֱ��jƥ��ֱ�������ҵ�ֱ��i,����Ϊƥ��ֱ�߶�
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
     %���ߺ�����������ͼƬ��ֱ���б�����ƥ���б����ͼƬ��
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