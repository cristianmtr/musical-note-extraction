function [No]=validfreq(En,Endiv)
No=zeros(7,7);
Envalinx=find(Endiv>.2);
L=length(Envalinx);
for i=1:L
    inx=Envalinx(i);
    En_inx=En(inx,:); 
    max_Eninx=max(En_inx);
    iny=find(En_inx>(max_Eninx*.75));
    inx1=ones(length(iny))*inx;
    No(inx1',iny')=Endiv(inx);
end




