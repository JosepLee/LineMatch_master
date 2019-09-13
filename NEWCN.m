
function [xtract1,ytract1,xtract2,ytract2]=NEWCN(x1,y1,x2,y2,x3,y3,line)

% x1=437;
% y1=153;
% x2=528;
% y2=193;
% x3=490;
% y3=215;
% 
% xline1=377;
% yline1=271;
% xline2=354;
% yline2=103;



k12=(y1-y2)/(x1-x2);
k32=(y3-y2)/(x3-x2);
if(k12==line.k||k32==line.k)
    xtract1=Inf;ytract1=Inf;xtract2=Inf;ytract2=Inf;

else
     if(line.k==Inf)
                b12=y2-k12*x2;
                b32=y2-k32*x2;
                xtract1=line.point1(1);
                ytract1=k12*xtract1+b12;
                xtract2=line.point1(1);
                ytract2=k32*xtract2+b32;
     else
                if(abs(k12)~=Inf)&&(abs(k32)~=Inf)
                b12=y2-k12*x2;
                b32=y2-k32*x2;


                xtract1=(line.b-b12)/(k12-line.k);
                ytract1=line.k*xtract1+line.b;

                xtract2=(line.b-b32)/(k32-line.k);
                ytract2=line.k*xtract2+line.b;
                end
                if(abs(k12)==Inf)&&(abs(k32)~=Inf)
                xtract1=x1;
                ytract1=line.k*xtract1+line.b;
                b32=y2-k32*x2;
                xtract2=(line.b-b32)/(k32-line.k);
                ytract2=line.k*xtract2+line.b;
                end
                if(abs(k12)~=Inf)&&(abs(k32)==Inf)
                b12=y2-k12*x2;
                xtract1=(line.b-b12)/(k12-line.k);
                ytract1=line.k*xtract1+line.b;

                xtract2=x3;
                ytract2=line.k*xtract2+line.b;
                end
     end
end



end