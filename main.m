function[]=main()
%this is the main function does the batch processing
 [FileName,PathName] = uigetfile({'*.wav';'*.mp3'},'Select the Wav-file');
 [y,Fs]=inputdecode([PathName FileName]);
 data=y;
 %data=[y y];
if (~isempty(daqfind))
    stop(daqfind)
end
ao = analogoutput('winsound');
addchannel(ao, [1 2]);
set(ao, 'SampleRate', Fs);
putdata(ao, data);
startindex = 1;
EigthNoteTime=.1;
%EigthNoteTime=.1744;
increment = round(Fs*EigthNoteTime);
freq=[1:increment]*Fs/increment;
L=length(data);
start(ao);
while isrunning(ao)  % do the plot
    while (ao.SamplesOutput < startindex + increment -1), end
    try
        x = ao.SamplesOutput;
        buff=y(x:x+increment-1);
        H=abs(fft(buff));
        plot(freq,H);
        %set(gca, 'YLim', [-0.8 0.8], 'XLim',[1 increment])
        set(gca, 'YLim', [0 500], 'XLim',[1 1000])
        drawnow;
        startindex =  startindex+increment;
    end
end

stop(ao);