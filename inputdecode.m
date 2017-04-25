function[data,Fs]=inputdecode(filename)
% This Function decodes mp3 and wave file and returns stereo data 
idx=find(filename=='.');
data=0;
if(~isempty(idx))
    extention=lower(filename(idx(end)+1:end));
else
    errordlg('Select File with extention (*.wav,*.mp3)', 'Check File formate');
    return;
end

%---Decodes input file----%
switch(extention)
    case 'mp3'
        [y,Fs]=mp3read(filename);%decodes the mp3 file 
   
    case 'wav'
        [y,Fs]=wavread(filename);%decodes the wave file
    
    otherwise
        errordlg('Unknown File Formate', 'Check File formate');
        return;
    
end
%---if not stereo converting to stereo
[length,chan]=size(y);
if(chan==2)
data=y;
elseif(chan==1)
    data=[y y];
end



