function [En,fftval,freqaxis]=freq2musnote(x,Fs)
L=floor(length(x)/2);
fft_mag=abs(fft(x));
fftval=fft_mag(1:L);
freqdiv=[27.5 55 110 220 440 880 1760 3520];
freqaxis=([0:L-1]/(L-1))*(Fs/2);
for i=2:8
    inx=(freqaxis<freqdiv(i))&(freqaxis>=freqdiv(i-1));
    fftmagdiv=fft_mag(inx);
    Lf=length(fftmagdiv);
    Nn=floor(Lf/7);
    if Lf<7
       fftmagdiv=interp1(0:(Lf-1),fftmagdiv,([0:6]/6)*(Lf-1));
       Nn=1;
    end
    
    
    fdiv=vec2mat(fftmagdiv,Nn);
    if Nn>1
    E=sum(fdiv')/Nn;
    else
    E=fdiv;
    end
    En(i-1,:)=E(1:7)';
    
end

