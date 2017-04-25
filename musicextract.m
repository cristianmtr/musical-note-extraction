function varargout = musicextract(varargin)
% MUSICEXTRACT M-file for musicextract.fig
%      MUSICEXTRACT, by itself, creates a new MUSICEXTRACT or raises the existing
%      singleton*.
%
%      H = MUSICEXTRACT returns the handle to a new MUSICEXTRACT or the handle to
%      the existing singleton*.
%
%      MUSICEXTRACT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MUSICEXTRACT.M with the given input arguments.
%
%      MUSICEXTRACT('Property','Value',...) creates a new MUSICEXTRACT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before musicextract_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to musicextract_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help musicextract

% Last Modified by GUIDE v2.5 24-Nov-2010 18:44:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @musicextract_OpeningFcn, ...
                   'gui_OutputFcn',  @musicextract_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before musicextract is made visible.
function musicextract_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to musicextract (see VARARGIN)

% Choose default command line output for musicextract
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes musicextract wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = musicextract_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




% --- Executes on button press in pbtplay.
function pbtplay_Callback(hObject, eventdata, handles)
% hObject    handle to pbtplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
save handles.mat handles
clear all
load handles.mat
global EigthNoteTime;
global Fs;
[Filename,Path]=uigetfile({'*.wav';'*.mp3'},'Select a File');
FullFilename=[Path,Filename];
[y,Fs]=inputdecode(FullFilename);
fid=fopen('Notes.txt','wt');
data=y;
set(handles.tgbtStop,'Value',0);
ao = analogoutput('winsound');
addchannel(ao, [1 2]);
set(ao, 'SampleRate', Fs);
putdata(ao, data);
startindex = 1;
EigthNoteTime=.1;
Note={'A1','B1','C1','D1','E1','F1','G1'
      'A2','B2','C2','D2','E2','F2','G2'
      'A3','B3','C3','D3','E3','F3','G3'
      'A4','B4','C4','D4','E4','F4','G4'
      'A5','B5','C5','D5','E5','F5','G5'
      'A6','B6','C6','D6','E6','F6','G6'
      'A7','B7','C7','D7','E7','F7','G7'};
increment = round(Fs*EigthNoteTime);
freq=[1:increment]*Fs/increment;
Hlen=floor(length(freq)/2);
Hfreq=freq(1:Hlen);
L=length(data);
c=0;
set(handles.sldMax,'value',c);
start(ao);
while isrunning(ao)  % do the plot
    while (ao.SamplesOutput < startindex + increment -1), end
         
        x = ao.SamplesOutput;
        buff=y(x:x+increment-1);
        mm=max(buff(:));
        set(handles.sldMax,'value',mm);
        
        if mm>c
            c=mm;
            set(handles.sldMax,'value',c);
            drawnow;
            
        end
        set(handles.txtThresh,'String',{['MaxAmp:',num2str(c)]; ['CurrAmp:',num2str(mm)]});
        
        [En fr axi]=freq2musnote(buff,Fs);
        axes(handles.axesSpec);
        bar(En);
        Eg=(En.^2);
        T_En=sum(Eg(:));
        
        Div_En=sum(Eg')/T_En;
        
        
        set(handles.axesSpec,'YLim',[0 40],'XGrid','on','YGrid','on','XTickLabel'...
            ,{'27.5-55 Hz';'55-110';'110 -220Hz';'220-440';'440-880Hz';'880-1760';'1760-3520Hz'});
        drawnow;%   
        
        axes(handles.axesNote);
        Not=validfreq(En,Div_En);
              
        bar3(Not);
        set(handles.axesNote,'ZLim',[0 2],'XGrid','on','YGrid','on','XTickLabel',['A';'B';'C';'D';'E';'F';'G']);
        drawnow;%
        
        [inxNote]=find(Not>0);
        if(not(isequal(inxNote,[])))
        strNote={Note(inxNote)};
        str=char(strNote{1,1});
        fprintf(fid,'%s\n', str');
        end
        
        axes(handles.axesFreq);
        plot(axi,fr,'Color',[1 1 1]);
      
        set(handles.axesFreq,'XMinorGrid','on','YMinorGrid','on','Color','b','Ylim',[0 100],'Xlim',[1 3520]);
        ylabel('Amplitude  Mag');
        xlabel('Frequency   Hz');
        drawnow;
        startindex =  startindex+increment;
        if (get(handles.tgbtStop,'Value')==1)
            break;         
        end
        if (startindex+increment-1>=L)
            break;
        end       
    
 
end
stop(ao);
fclose(fid);
delete(ao);


% --- Executes on button press in tgbtStop.
function tgbtStop_Callback(hObject, eventdata, handles)
% hObject    handle to tgbtStop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tgbtStop


% --- Executes on slider movement.


% --- Executes on button press in pbtShow.
function pbtShow_Callback(hObject, eventdata, handles)
% hObject    handle to pbtShow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[Filename,Path]=uigetfile({'*.txt'},'Select a File');
FullFilename=[Path,Filename];
open(FullFilename);


% --- Executes on slider movement.
function sldMax_Callback(hObject, eventdata, handles)
% hObject    handle to sldMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider




% --- Executes during object creation, after setting all properties.
function sldMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sldMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


