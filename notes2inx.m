function[inx]=notes2inx(Nt)
[k,L]=size(Nt);
T=['A','B','C','D','E','F','G'];
inx=[];
for i=2:2:L
    m=find(T==Nt(i-1));
    n=str2num(Nt(i));
    inx(i/2,:)=[m,n];    
end