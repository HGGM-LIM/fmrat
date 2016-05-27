function varargout = fmri_gui(varargin)
% FMRI_GUI M-print for fmri_gui.fig
%      FMRI_GUI, by itself, creates a new FMRI_GUI or raises the existing
%      singleton*.
%
%      H = FMRI_GUI returns the handle to a new FMRI_GUI or the handle to
%      the existing singleton*.
%
%      FMRI_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FMRI_GUI.M with the given input arguments.
%
%      FMRI_GUI('Property','Value',...) creates a new FMRI_GUI or raises
%      the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fmri_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fmri_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help fmri_gui

% Last Modified by GUIDE v2.5 19-May-2016 20:50:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fmri_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @fmri_gui_OutputFcn, ...
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


% --- Executes just before fmri_gui is made visible.
function fmri_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fmri_gui (see VARARGIN)

% Choose default command line output for fmri_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
route=mfilename('fullpath');
drawing=[fileparts(route) filesep 'blocks.tif'];
im=imread(drawing,'tif');
axes(handles.axes2);
i=image(im);
set(handles.axes2,'XTick',[]);
set(handles.axes2,'YTick',[]);

% Load default values
axes(handles.axes1); 
cla
set(handles.edit1,'String','');
set(handles.edit2,'String','');
set(handles.edit31,'String','');
set(handles.edit4,'String','');
set(handles.edit31,'UserData',[0]);
set(handles.checkbox2,'Value',1);
set(handles.edit15,'String','1.2');
set(handles.checkbox3,'Value',0);  % No normalization by default
    set(handles.uipanel14,'Visible','off');
   set(handles.popupmenu6 ,'Visible','off');          
   set(handles.text16 ,'Visible','off'); 
       set(handles.text17 ,'Visible','off'); 
       set(handles.text21 ,'Visible','off');    
       set(handles.text22 ,'Visible','off');    
       set(handles.text23 ,'Visible','off');    
       set(handles.text24 ,'Visible','off');    
       set(handles.text25 ,'Visible','off'); 
       set(handles.edit12 ,'Visible','off');    
       set(handles.edit13 ,'Visible','off');    
       set(handles.edit14 ,'Visible','off');  
       set(handles.edit26 ,'String',''); 


set(handles.popupmenu6,'Value',1);
set(handles.edit12,'String','');
set(handles.edit13,'String','');
set(handles.edit14,'String','');

       set(handles.edit12 ,'Enable','off');    
       set(handles.edit13 ,'Enable','off');    
       set(handles.edit14 ,'Enable','off'); 
 

set(handles.checkbox8,'Value',1);
set(handles.checkbox9,'Value',1);
set(handles.checkbox10,'Value',1);
set(handles.checkbox13,'Value',1);
set(handles.checkbox12,'Value',1);


set(handles.edit29,'String','RARE');
set(handles.edit30,'String','EPI');
set(handles.text7,'BackgroundColor',[0.9,0.7,0.7]);  
install     =   mfilename('fullpath');
%set( handles.edit26,'String',[fileparts(install) filesep 'Atlas_SD']);
set( handles.edit26,'String','');

set(handles.radiobutton18,'Value',0);
set(handles.radiobutton19,'Value',1);
set(handles.edit24,'String','0.05');
set(handles.edit25,'String','4');

set(handles.radiobutton9,'Value',1);
set(handles.radiobutton10,'Value',0);
set(handles.popupmenu5,'Enable','on');
set(handles.togglebutton7,'Enable','off');
set(handles.edit11,'Enable','off');

set(handles.togglebutton2,'Value',0);
set(handles.togglebutton3,'Value',0);
set(handles.togglebutton4,'Value',0);
set(handles.togglebutton5,'Value',0);


set(handles.checkbox16,'Value',0);
set(handles.edit33,'String','0');
set(handles.edit36,'String','128');
set(handles.uipanel22,'UserData',[]);
% UIWAIT makes fmri_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);
 

% --- Outputs from this function are returned to the command line.
function varargout = fmri_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
 



% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
 


% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
 


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = get(hObject,'String');
set(handles.uipanel4,'BackgroundColor',[0.867, 0.918, 0.976]);
if isdir(contents) 
    set(hObject,'String',contents); 
else
    set(hObject,'String','Not valid');
    set(handles.uipanel4,'BackgroundColor',[0.847,0.161,0]);
end
% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
 

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
 

% --- Executes on button press in togglebutton2.
function togglebutton2_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
d   =   get(handles.edit14,'String');
if isempty(d)
    if isunix 
        %d='/opt/PV5.0/data/nmrsu/nmr/'; 
        d='/media/fMRI_Rata/'; 
    end
    if ispc 
        d='W:\Proyectos\fMRI\FMRI_RATA\'; 
    end
end
sel_dir = uigetdir(d,'Please select your fMRI directory:');
if sel_dir ~=0 
    [route folder e]=fileparts(sel_dir);
    if isdir(sel_dir) && ~isempty(folder) 
        set(hObject,'UserData',sel_dir);
        set(handles.edit1,'String',sel_dir);
        set(handles.edit1,'UserData',sel_dir);
        set(handles.uipanel4,'BackgroundColor',[0.867, 0.918, 0.976]);
    else
        set(handles.edit1,'String','Not valid');
        set(handles.uipanel4,'BackgroundColor',[0.847,0.161,0]);   
    end
end
set(hObject,'Value',0);
 
% Hint: get(hObject,'Value') returns toggle state of togglebutton2


%==========================================================================
% --- Executes on button press in togglebutton3.
function togglebutton3_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% START BUTTON
sel_dir =       get(handles.edit1,'String');
sm =            get(handles.checkbox2,'Value');
sx='';
if sm==1
    sx=str2double(get(handles.edit15,'String'));
end
coreg =         get(handles.checkbox3,'Value');
sp =            0;
custom_atlas =  0;
atlas_dir =     '';
rx =            0;
ry =            0;
rz =            0;
    if coreg==1
        custom_atlas= get(handles.radiobutton10,'Value');
        if custom_atlas==0 
            sp = get(handles.popupmenu5,'Value');
        else
            atlas_dir = get(handles.edit11,'String');
        end
    end
custom_resol =  mod(get(handles.popupmenu6,'Value')+1,2);
    if custom_resol==1
        rx   =  str2num(get(handles.edit12,'String'));
        ry   =  str2num(get(handles.edit13,'String'));
        rz   =  str2num(get(handles.edit14,'String'));        
    end
    
    
preprocess  =   get(handles.checkbox8,'Value');
realign     =   get(handles.checkbox9,'Value');
design      =   get(handles.checkbox10,'Value');
estimate    =   get(handles.checkbox13,'Value');
display     =   get(handles.checkbox12,'Value');
action      =   'all';
if(~preprocess && realign && design && estimate && display)
    action  =   'from_realign';
elseif(~preprocess && ~realign && design && estimate && display)
    action  =   'from_coreg';
elseif (~preprocess && ~realign && ~design && estimate && display)
    action  =   'from_estimate';
elseif (~preprocess && ~realign && ~design && ~estimate && display)
    action  =   'display';
end    
rois_dir    =   get(handles.edit26,'String');    
preserve    =   get(handles.checkbox15,'Value');    
block_ok =      get(handles.edit31,'UserData');
NR =            str2num(get(handles.edit31,'String'));
Nrest =         str2num(get(handles.edit2,'String'));
Nstim =         str2num(get(handles.edit4,'String'));
skip        =   str2num(get(handles.edit33,'String')); 
cutoff  =       str2num(get(handles.edit36,'String')); 
adv_dat     =   get(handles.uipanel22,'UserData');
adv_paradigm=   [];
adv_cov     =   [];
user_hrf    =   [];
t_max       =   [];
if ~isempty(adv_dat) && isfield(adv_dat,'paradigm')
    adv_paradigm=   adv_dat.paradigm;
end
if ~isempty(adv_dat) && isfield(adv_dat,'cov')
    adv_cov         =   adv_dat.cov;
end
if ~isempty(adv_dat) && isfield(adv_dat,'user_hrf')
    user_hrf        =   adv_dat.user_hrf;
    t_max           =   adv_dat.t_max;    
end
anat_seq =      get(handles.edit29,'String');
func_seq =      get(handles.edit30,'String');
RevZ =          get(handles.checkbox16,'Value');
fwe=            get(handles.radiobutton19,'Value');
p=              str2num(get(handles.edit24,'String'));
k=              str2num(get(handles.edit25,'String'));


if ~strcmp(action,'all') && ~preserve
   warndlg(['You are not following the typical workflow, and "Preserve previous processing steps" is NOT checked. ' ...
       'This might produce unexpected results. Please check that tickbox and make sure the required previous steps were done correctly.']); 
   return
end
    

ok= ['isdir(sel_dir) && ((block_ok==1) || ~isempty(adv_paradigm)) && ' ...
    '((coreg && (sp~=0))|| (coreg && (~isempty(atlas_dir))) || (~coreg))' ...
    '&& ((custom_resol==0)||((~isempty(rx))&&(~isempty(ry))&&(~isempty(rz))))'...
    '&& ((sm==0)||(~isnan(sx))) && ((p>0)&& (p<=1) && (~isnan(p)))&& ((k>0)&&(~isnan(k)))' ...
    '&& ~isempty(anat_seq) && ~isempty(func_seq)&& ((skip>=0)&& (~isnan(skip)))' ...
    '&& ((cutoff>=0) && (~isnan(cutoff)))'];
if eval(ok)        
    set(handles.uipanel4,'BackgroundColor',[0.867, 0.918, 0.976]);
    set(handles.uipanel8,'BackgroundColor',[0.906,0.906,0.906]);
    fmri(action,sel_dir,sp,atlas_dir,sm,coreg,2,anat_seq,func_seq,NR,Nrest,...
        Nstim,0,fwe,p,k,custom_atlas,custom_resol,rx,ry,rz,sx,preserve,preprocess,...
        realign, design,estimate, display, adv_paradigm,adv_cov,RevZ, skip,cutoff,user_hrf,t_max,0,[],[],rois_dir);
else
    if ~(isdir(sel_dir)) 
        set(handles.edit1,'String','Not valid');
        set(handles.uipanel4,'BackgroundColor',[0.847,0.161,0]);
        set(hObject,'Value',0);
        errordlg('Directory is not valid');
    elseif (block_ok==0) || isempty(adv_paradigm)
        set(handles.uipanel8,'BackgroundColor',[0.847,0.161,0]);
        set(hObject,'Value',0);  
        errordlg('Block design is not valid'); 
    elseif coreg && (sp==0) && (isempty(atlas_dir))
        set(handles.uipanel14,'BackgroundColor',[0.847,0.161,0]);
        set(hObject,'Value',0);  
        errordlg('Atlas specification is not valid');          
    elseif (coreg && (custom_resol==1) && ((isempty(rx))||(isempty(ry))||(isempty(rz)))) 
        set(handles.popupmenu6,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit12,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit13,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit14,'BackgroundColor',[0.847,0.161,0]);
        set(hObject,'Value',0);  
        errordlg('Final resolution is not valid');                  
    elseif (coreg && (custom_resol==1) && ((rx==0)||(ry==0)||(rz==0))) 
        set(handles.popupmenu6,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit12,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit13,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit14,'BackgroundColor',[0.847,0.161,0]);
        set(hObject,'Value',0);  
        errordlg('Final resolution is not valid');                          
    elseif (sm==1 && isnan(sx)) 
        set(handles.checkbox2,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit15,'BackgroundColor',[0.847,0.161,0]);
        set(hObject,'Value',0);  
        errordlg('Smoothing resolution is not valid');
    elseif (skip<0 || isnan(skip))
        set(handles.edit33,'BackgroundColor',[0.847,0.161,0]);
        errordlg('Skipped volumes are not a valid number');    
    elseif (cutoff<0 || isnan(cutoff))
        set(handles.edit36,'BackgroundColor',[0.847,0.161,0]);
        errordlg('Cutoff is not a valid number');            
    elseif isempty(anat_seq) || isempty(func_seq)
        set(handles.uipane21,'BackgroundColor',[0.847,0.161,0]);
        set(hObject,'Value',0);  
        errordlg('Please fill in the Bruker acquisition methods for the anatomic and functional acquisitions');
    elseif (p<=0)|| (p>=1) ||(isnan(p))
        set(handles.edit24,'BackgroundColor',[0.847,0.161,0]);
        set(hObject,'Value',0);  
        errordlg('Probability threshold p should be 0<p<1'); 
    elseif (k<1) || (isnan(k))
        set(handles.edit25,'BackgroundColor',[0.847,0.161,0]);
        set(hObject,'Value',0);  
        errordlg('Cluster size should be greater than 1');         
    end
end
 
%==========================================================================



% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val=get(hObject,'Value');
if val==1
   set(handles.edit15 ,'Visible','on'); 
   set(handles.text26 ,'Visible','on');    
   set(handles.text27 ,'Visible','on');        
      
elseif val==0
   set(handles.edit15 ,'Visible','off'); 
   set(handles.text26 ,'Visible','off');    
   set(handles.text27 ,'Visible','off');     


end 
% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on key press with focus on edit1 and no controls selected.
function edit1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dir=get(hObject,'String');
set(hObject,'UserData',dir);
set(hObject,'TooltipString',dir);
 


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% NREST BUTTON
try
    NR = str2num(get(handles.edit31,'String'));
    Nrest=str2num(get(handles.edit2,'String'));
    Nstim=str2num(get(handles.edit4,'String'));
    set(handles.edit31,'UserData',[0]);
    if ~isempty(NR) && ~isempty(Nrest) && ~isempty(Nstim) && ...
       NR>(Nrest+Nstim) && (mod(NR,(Nrest+Nstim)) == Nrest)
            cycles=(NR-Nrest)/(Nrest+Nstim);
            set(handles.axes1,'Visible','on');
            axes(handles.axes1); 
            xlabel=text(0,0,'Images','Visible','off');
            set(handles.axes1,'XLabel',xlabel);
            y=[];lb=[1];
            for k=1:cycles 
                y=[y zeros(1,Nrest*1000) ones(1,Nstim*1000)]; 
                lb=[lb Nrest+(k-1)*(Nrest+Nstim) (Nrest+Nstim)*k];
            end
            y=[y zeros(1,Nrest*1000)]; lb=[lb NR];base=[1:(NR*1000)];
            plot(handles.axes1,base,y,' .b');
            set(gca,'XTick',lb*1000);
            lb=strread(num2str(lb),'%s');
            set(gca,'XTickLabel',lb');
            xlim(handles.axes1,[1 NR*1000]);
            ylim(handles.axes1,[0 1.25]); 
            set(handles.edit31,'UserData',[1]);
            set(handles.uipanel8,'BackgroundColor',[0.867, 0.918, 0.976]);
            set(handles.text7,'BackgroundColor',[0.9,0.7,0.7]);              
    else
        axes(handles.axes1); 
        cla;
        set(handles.edit31,'UserData',[0]);    
        set(handles.uipanel8,'BackgroundColor',[0.847,0.161,0]);
        set(handles.text7,'BackgroundColor',[0.847,0.161,0]);          
    end
catch
        axes(handles.axes1); 
        cla;
        set(handles.edit31,'UserData',[0]);    
        set(handles.uipanel8,'BackgroundColor',[0.847,0.161,0]);
end
    % Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
 

function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% NSTIM BUTTON
try
    NR = str2num(get(handles.edit31,'String'));
    Nrest=str2num(get(handles.edit2,'String'));
    Nstim=str2num(get(handles.edit4,'String'));
    set(handles.edit31,'UserData',[0]);
    if ~isempty(NR) && ~isempty(Nrest) && ~isempty(Nstim) && ...
       NR>(Nrest+Nstim) && (mod(NR,(Nrest+Nstim)) == Nrest)
            cycles=(NR-Nrest)/(Nrest+Nstim);
            set(handles.axes1,'Visible','on');
            axes(handles.axes1); 
            xlabel=text(0,0,'Images','Visible','off');
            set(handles.axes1,'XLabel',xlabel);
            y=[];lb=[1];
            for k=1:cycles 
                y=[y zeros(1,Nrest*1000) ones(1,Nstim*1000)]; 
                lb=[lb Nrest+(k-1)*(Nrest+Nstim) (Nrest+Nstim)*k];
            end
            y=[y zeros(1,Nrest*1000)]; lb=[lb NR];base=[1:(NR*1000)];
            plot(handles.axes1,base,y,' .b');
            set(gca,'XTick',lb*1000);
            lb=strread(num2str(lb),'%s');
            set(gca,'XTickLabel',lb');
            xlim(handles.axes1,[1 NR*1000]);
            ylim(handles.axes1,[0 1.25]); 
            set(handles.edit31,'UserData',[1]);
            set(handles.uipanel8,'BackgroundColor',[0.867, 0.918, 0.976]);
            set(handles.text7,'BackgroundColor',[0.9,0.7,0.7]);                
    else
        axes(handles.axes1); 
        cla;
        set(handles.edit31,'UserData',[0]);    
        set(handles.uipanel8,'BackgroundColor',[0.847,0.161,0]);
        set(handles.text7,'BackgroundColor',[0.847,0.161,0]);            
    end
catch
        axes(handles.axes1); 
        cla;
        set(handles.edit31,'UserData',[0]);    
        set(handles.uipanel8,'BackgroundColor',[0.847,0.161,0]);            
end
 
% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit31_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
 


function edit31_Callback(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit31 as text
%        str2double(get(hObject,'String')) returns contents of edit31 as a double

% NR_TOTAL BUTTON
try
    NR = str2num(get(handles.edit31,'String'));
    Nrest=str2num(get(handles.edit2,'String'));
    Nstim=str2num(get(handles.edit4,'String'));
    set(handles.edit31,'UserData',[0]);
    if ~isempty(NR) && ~isempty(Nrest) && ~isempty(Nstim) && ...
       NR>(Nrest+Nstim) && (mod(NR,(Nrest+Nstim)) == Nrest)
            cycles=(NR-Nrest)/(Nrest+Nstim);
            set(handles.axes1,'Visible','on');
            axes(handles.axes1); 
            xlabel=text(0,0,'Images','Visible','off');
            set(handles.axes1,'XLabel',xlabel);
            y=[];lb=[1];
            for k=1:cycles 
                y=[y zeros(1,Nrest*1000) ones(1,Nstim*1000)]; 
                lb=[lb Nrest+(k-1)*(Nrest+Nstim) (Nrest+Nstim)*k];
            end
            y=[y zeros(1,Nrest*1000)]; lb=[lb NR];base=[1:(NR*1000)];
            plot(handles.axes1,base,y,' .b');
            set(gca,'XTick',lb*1000);
            lb=strread(num2str(lb),'%s');
            set(gca,'XTickLabel',lb');
            xlim(handles.axes1,[1 NR*1000]);
            ylim(handles.axes1,[0 1.25]); 
            set(handles.edit31,'UserData',[1]);
            set(handles.uipanel8,'BackgroundColor',[0.867, 0.918, 0.976]);
            set(handles.text7,'BackgroundColor',[0.9,0.7,0.7]);
    else
        axes(handles.axes1); 
        cla;
        set(handles.edit31,'UserData',[0]);    
        set(handles.uipanel8,'BackgroundColor',[0.847,0.161,0]);
        set(handles.text7,'BackgroundColor',[0.847,0.161,0]);
    end
catch
        axes(handles.axes1); 
        cla;
        set(handles.edit31,'UserData',[0]);    
        set(handles.uipanel8,'BackgroundColor',[0.847,0.161,0]);    
end

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'UserData',[0]);
 



% --- Executes on button press in togglebutton4.
function togglebutton4_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% SAVE CONFIG PRINT
sel_dir     =   get(handles.edit1,'String');
preserve    =   get(handles.checkbox15,'Value');
sm =            get(handles.checkbox2,'Value');
sx='';
if sm==1
    sx=str2double(get(handles.edit15,'String'));
end
coreg =         get(handles.checkbox3,'Value');
sp =            0;
custom_atlas =  0;
atlas_dir =     '';
rx =            0;
ry =            0;
rz =            0;
    if coreg==1
        custom_atlas= get(handles.radiobutton10,'Value');
        if custom_atlas==0 
            sp = get(handles.popupmenu5,'Value');
        else
            atlas_dir = get(handles.edit11,'String');
        end
    end
custom_resol =  mod(get(handles.popupmenu6,'Value')+1,2);
    if custom_resol==1
        rx   =  str2num(get(handles.edit12,'String'));
        ry   =  str2num(get(handles.edit13,'String'));
        rz   =  str2num(get(handles.edit14,'String'));        
    end

prep        =   get(handles.checkbox8,'Value');
rea         =   get(handles.checkbox9,'Value');
des         =   get(handles.checkbox10,'Value');
tim         =   get(handles.checkbox13,'Value');
dis         =   get(handles.checkbox12,'Value');  
block_ok =      get(handles.edit31,'UserData');
NR =            str2num(get(handles.edit31,'String'));
Nrest =         str2num(get(handles.edit2,'String'));
Nstim =         str2num(get(handles.edit4,'String'));
RevZ =          get(handles.checkbox16,'Value');
skip        =   str2num(get(handles.edit33,'String'));
cutoff      =   str2num(get(handles.edit36,'String'));
adv_dat     =   get(handles.uipanel22,'UserData');
adv_paradigm    =   [];
adv_cov         =   [];
user_hrf        =   [];
t_max           =   [];
if ~isempty(adv_dat) && isfield(adv_dat,'paradigm')
    adv_paradigm=   adv_dat.paradigm;
end
if ~isempty(adv_dat) && isfield(adv_dat,'cov')
    adv_cov         =   adv_dat.cov;
end
if ~isempty(adv_dat) && isfield(adv_dat,'user_hrf')
    user_hrf        =   adv_dat.user_hrf;
    t_max           =   adv_dat.t_max;
end
anat_seq =      get(handles.edit29,'String');
func_seq =      get(handles.edit30,'String');
fwe=            get(handles.radiobutton19,'Value');
p =             str2num(get(handles.edit24,'String'));
k =             str2num(get(handles.edit25,'String'));
rois_dir    =   get(handles.edit26,'String');


ok= ['isdir(sel_dir) && ((block_ok==1) || ~isempty(adv_paradigm)) && ' ...
    '((coreg && (sp~=0))|| (coreg && (~isempty(atlas_dir))) || (~coreg))' ...
    '&& ((custom_resol==0)||((~isempty(rx))&&(~isempty(ry))&&(~isempty(rz))))'...
    '&& ((sm==0)||(~isnan(sx))) && ((p>0)&& (p<=1) && (~isnan(p)))&& ((k>0)&&(~isnan(k)))' ...
    '&& ~isempty(anat_seq) && ~isempty(func_seq)&& ((skip>=0)&& (~isnan(skip)))' ...
    '&& ((cutoff>=0) && (~isnan(cutoff)))'];

if eval(ok)        
    set(handles.uipanel4,'BackgroundColor',[0.867,0.918,0.976]);
    set(handles.uipanel8,'BackgroundColor',[0.906,0.906,0.906]);
    cd(sel_dir);
    [file,route] = uiputfile('config.mat','Save config file');
    if file ~=0 
        if isdir(route)  
        cd(route);
        try
            fullpath=[route file];
            save(fullpath,'sel_dir','block_ok','NR','Nrest','Nstim',    ...
                'anat_seq','func_seq','coreg','custom_atlas','sp',      ...
                'atlas_dir','custom_resol','rx','ry','rz','sm','fwe',   ...
                'p','k','sx','prep','rea','des','tim','dis','preserve', ...
                'rois_dir','adv_paradigm','adv_cov','RevZ','skip','cutoff','user_hrf','t_max');
            fclose all;
        catch
            errordlg('Cannot save config file here. Check folder permissions');
        end
        end
    end
     
else
    if ~(isdir(sel_dir)) 
        set(handles.edit1,'String','Not valid');
        set(handles.uipanel4,'BackgroundColor',[0.847,0.161,0]);
        set(hObject,'Value',0);
        errordlg('Directory is not valid');
    elseif (block_ok==0) || isempty(adv_paradigm)
        set(handles.uipanel8,'BackgroundColor',[0.847,0.161,0]);
        set(hObject,'Value',0);  
        errordlg('Block design is not valid'); 
    elseif coreg && (sp==0) && (isempty(atlas_dir))
        set(handles.uipanel14,'BackgroundColor',[0.847,0.161,0]);
        set(hObject,'Value',0);  
        errordlg('Atlas specification is not valid');          
    elseif (coreg && (custom_resol==1) && ((isempty(rx))||(isempty(ry))||(isempty(rz)))) 
        set(handles.popupmenu6,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit12,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit13,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit14,'BackgroundColor',[0.847,0.161,0]);
        set(hObject,'Value',0);  
        errordlg('Final resolution is not valid');                  
    elseif (coreg && (custom_resol==1) && ((rx==0)||(ry==0)||(rz==0))) 
        set(handles.popupmenu6,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit12,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit13,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit14,'BackgroundColor',[0.847,0.161,0]);
        set(hObject,'Value',0);  
        errordlg('Final resolution is not valid');                          
    elseif (sm==1 && isnan(sx)) 
        set(handles.checkbox2,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit15,'BackgroundColor',[0.847,0.161,0]);
        set(hObject,'Value',0);  
        errordlg('Smoothing resolution is not valid');
    elseif (skip<0 || isnan(skip))
        set(handles.edit33,'BackgroundColor',[0.847,0.161,0]);
        errordlg('Skipped volumes are not a valid number');    
    elseif (cutoff<0 || isnan(cutoff))
        set(handles.edit36,'BackgroundColor',[0.847,0.161,0]);
        errordlg('Cutoff is not a valid number');            
    elseif isempty(anat_seq) || isempty(func_seq)
        set(handles.uipane21,'BackgroundColor',[0.847,0.161,0]);
        set(hObject,'Value',0);  
        errordlg('Please fill in the Bruker acquisition methods for the anatomic and functional acquisitions');
    elseif (p<=0)|| (p>=1) ||(isnan(p))
        set(handles.edit24,'BackgroundColor',[0.847,0.161,0]);
        set(hObject,'Value',0);  
        errordlg('Probability threshold p should be 0<p<1'); 
    elseif (k<1) || (isnan(k))
        set(handles.edit25,'BackgroundColor',[0.847,0.161,0]);
        set(hObject,'Value',0);  
        errordlg('Cluster size should be greater than 1');         
    end        
end




set(hObject,'Value',0);
fclose all

% Hint: get(hObject,'Value') returns toggle state of togglebutton4


% --- Executes on button press in togglebutton5.
function togglebutton5_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% LOAD CONFIG PRINT
% First clear everything out
route=mfilename('fullpath');
drawing=[fileparts(route) filesep 'blocks.tif'];
im=imread(drawing,'tif');
axes(handles.axes2);
i=image(im);
set(handles.axes2,'XTick',[]);
set(handles.axes2,'YTick',[]);

% Load default values
axes(handles.axes1); 
cla
set(handles.edit1,'String','');
set(handles.edit2,'String','');
set(handles.edit31,'String','');
set(handles.edit4,'String','');
set(handles.edit31,'UserData',[0]);
set(handles.checkbox2,'Value',1);
set(handles.edit15,'String','1.2');
set(handles.checkbox3,'Value',0);  % No normalization by default
    set(handles.uipanel14,'Visible','off');
   set(handles.popupmenu6 ,'Visible','off');          
   set(handles.text16 ,'Visible','off'); 
       set(handles.text17 ,'Visible','off'); 
       set(handles.text21 ,'Visible','off');    
       set(handles.text22 ,'Visible','off');    
       set(handles.text23 ,'Visible','off');    
       set(handles.text24 ,'Visible','off');    
       set(handles.text25 ,'Visible','off'); 
       set(handles.edit12 ,'Visible','off');    
       set(handles.edit13 ,'Visible','off');    
       set(handles.edit14 ,'Visible','off');  
       set(handles.edit26 ,'String',''); 


set(handles.popupmenu6,'Value',1);
set(handles.edit12,'String','');
set(handles.edit13,'String','');
set(handles.edit14,'String','');

       set(handles.edit12 ,'Enable','off');    
       set(handles.edit13 ,'Enable','off');    
       set(handles.edit14 ,'Enable','off'); 
 

set(handles.checkbox8,'Value',1);
set(handles.checkbox9,'Value',1);
set(handles.checkbox10,'Value',1);
set(handles.checkbox13,'Value',1);
set(handles.checkbox12,'Value',1);


set(handles.edit29,'String','RARE');
set(handles.edit30,'String','EPI');
set(handles.text7,'BackgroundColor',[0.9,0.7,0.7]);  
install     =   mfilename('fullpath');
%set( handles.edit26,'String',[fileparts(install) filesep 'Atlas_SD']);
set( handles.edit26,'String','');

set(handles.radiobutton18,'Value',0);
set(handles.radiobutton19,'Value',1);
set(handles.edit24,'String','0.05');
set(handles.edit25,'String','4');

set(handles.radiobutton9,'Value',1);
set(handles.radiobutton10,'Value',0);
set(handles.popupmenu5,'Enable','on');
set(handles.togglebutton7,'Enable','off');
set(handles.edit11,'Enable','off');

set(handles.togglebutton2,'Value',0);
set(handles.togglebutton3,'Value',0);
set(handles.togglebutton4,'Value',0);
set(handles.togglebutton5,'Value',0);

set(handles.uipanel22,'UserData',[]);
set(handles.checkbox16,'Value',0);
set(handles.edit33,'String','0');
set(handles.edit36,'String','128');


% Get config file
sel_dir =       get(handles.edit1,'String');
if ~isempty(sel_dir) cd(sel_dir); end
[file, route]=uigetfile({'*.mat'},'Select a config file');

try
    load(fullfile(route,file));
    set(handles.edit1,'String',sel_dir);    
    set(handles.edit2,'String',num2str(Nrest));
    set(handles.edit4,'String',num2str(Nstim)); 
    set(handles.edit31,'String',num2str(NR));
    set(handles.edit33,'String',num2str(skip));    
    set(handles.edit36,'String',num2str(cutoff));       
    adv_dat      =  [];
    if exist('adv_paradigm','var') && ~isempty(adv_paradigm) 
        adv_dat.paradigm    =   adv_paradigm;
    end
    if exist('adv_cov','var') && ~isempty(adv_cov)    
        adv_dat.cov    =   adv_cov;        
    end    
    if exist('user_hrf','var') && ~isempty(user_hrf)    
        adv_dat.user_hrf    =   user_hrf;        
        adv_dat.t_max       =   t_max;         
    end      
    set(handles.uipanel22,'UserData',adv_dat);
    set(handles.edit31,'UserData',cast(cast(block_ok,'uint8'),'logical'));
    set(handles.edit29,'String',num2str(anat_seq));
    set(handles.edit30,'String',num2str(func_seq));     
    set(handles.checkbox16,'Value',cast(cast(RevZ,'uint8'),'logical'));
    set(handles.edit26,'String',deblank(rois_dir));      
    set(handles.checkbox3,'Value',cast(cast(coreg,'uint8'),'logical'));
    set(handles.checkbox15,'Value',cast(cast(preserve,'uint8'),'logical'));
    if coreg    
        set(handles.radiobutton10,'Value',custom_atlas);    
        if ~custom_atlas
        sp=num2str(sp);
            switch sp
                case '1'
                    val=uint8(1);
                    set(handles.popupmenu5,'Value',val);
                case '2' 
                    val=uint8(2);
                    set(handles.popupmenu5,'Value',val);
                otherwise
                    val=uint8(1);
                    set(handles.popupmenu5,'Value',val);
                    errordlg('Species loaded is not valid');
            end
        else
            set(handles.edit11,'String',atlas_dir);
        end
        rr=uint8(custom_resol);
        set(handles.popupmenu6,'Value',rr+1);
        set(handles.text16,'Visible','on');
        set(handles.uipanel14,'Visible','on');
        
            set(handles.text17 ,'Visible','on'); 
           set(handles.text21 ,'Visible','on');    
           set(handles.text22 ,'Visible','on');    
           set(handles.text23 ,'Visible','on');    
           set(handles.text24 ,'Visible','on');    
           set(handles.text25 ,'Visible','on'); 
           set(handles.edit12 ,'Visible','on');    
           set(handles.edit13 ,'Visible','on');    
           set(handles.edit14 ,'Visible','on');         
           set(handles.edit12 ,'Enable','on');    
           set(handles.edit13 ,'Enable','on');    
           set(handles.edit14 ,'Enable','on');              
        if custom_resol
            set(handles.edit12,'String',num2str(rx));
            set(handles.edit13,'String',num2str(ry));
            set(handles.edit14,'String',num2str(rz));
        else
           set(handles.edit12 ,'Enable','off');    
           set(handles.edit13 ,'Enable','off');    
           set(handles.edit14 ,'Enable','off'); 
        end
            
    else
        set(handles.uipanel14,'Visible','off'); 
        set(handles.popupmenu6 ,'Visible','off'); 
        set(handles.text16,'Visible','off');        
           set(handles.text17 ,'Visible','off'); 
           set(handles.text21 ,'Visible','off');    
           set(handles.text22 ,'Visible','off');    
           set(handles.text23 ,'Visible','off');    
           set(handles.text24 ,'Visible','off');    
           set(handles.text25 ,'Visible','off'); 
           set(handles.edit12 ,'Visible','off');    
           set(handles.edit13 ,'Visible','off');    
           set(handles.edit14 ,'Visible','off');  
              
    end
    if sm
        set(handles.edit15,'String',num2str(sx)); 
        set(handles.text26 ,'Visible','on');         
        set(handles.text27 ,'Visible','on');          
        set(handles.edit15 ,'Visible','on');
    else
        set(handles.text26 ,'Visible','off');         
        set(handles.text27 ,'Visible','off');          
        set(handles.edit15 ,'Visible','off');        
    end
    set(handles.checkbox2,'Value',cast(cast(sm,'uint8'),'logical'));
    set(handles.radiobutton19,'Value',fwe);
    set(handles.radiobutton18,'Value',~fwe);    
    set(handles.edit24,'String',num2str(p));    
    set(handles.edit25,'String',num2str(k)); 
    set(handles.checkbox8,'Value',cast(cast(prep,'uint8'),'logical'));
    set(handles.checkbox9,'Value',cast(cast(rea,'uint8'),'logical'));
    set(handles.checkbox10,'Value',cast(cast(des,'uint8'),'logical'));
    set(handles.checkbox13,'Value',cast(cast(tim,'uint8'),'logical'));
    set(handles.checkbox12,'Value',cast(cast(dis,'uint8'),'logical'));   
    
    % DRAW blocks..............................
    if ~isempty(NR) && ~isempty(Nrest) && ~isempty(Nstim) && ...
       NR>(Nrest+Nstim) && (mod(NR,(Nrest+Nstim)) == Nrest)
            cycles=(NR-Nrest)./(Nrest+Nstim);
            set(handles.axes1,'Visible','on');
            axes(handles.axes1); 
            xlabel=text(0,0,'Images','Visible','off');
            set(handles.axes1,'XLabel',xlabel);
            y=[];lb=[1];
            for k=1:cycles 
                y=[y zeros(1,Nrest*1000) ones(1,Nstim*1000)]; 
                lb=[lb Nrest+(k-1)*(Nrest+Nstim) (Nrest+Nstim)*k];
            end
            y=[y zeros(1,Nrest*1000)]; lb=[lb NR];base=[1:(NR*1000)];
            plot(handles.axes1,base,y,' .b');
            set(gca,'XTick',lb*1000);
            lb=strread(num2str(lb),'%s');
            set(gca,'XTickLabel',lb');
            xlim(handles.axes1,[1 NR*1000]);
            ylim(handles.axes1,[0 1.25]); 
            set(handles.edit31,'UserData',[1]);
            set(handles.uipanel8,'BackgroundColor',[0.867, 0.918, 0.976]);
            set(handles.text7,'BackgroundColor',[0.9,0.7,0.7]);            
    elseif isstruct(adv_paradigm)
            set(handles.axes1,'Visible','on');
            axes(handles.axes1); 
            xlabel  =   text(0,0,'Images','Visible','off');
            set(handles.axes1,'XLabel',xlabel);
            
            if size(adv_paradigm.duration,1)==1
               duration     =   repmat(adv_paradigm.duration,1,size(adv_paradigm.onsets,2)); 
            end
            y       =   zeros(1,adv_paradigm.NR*1000); 
            for i=1:size(adv_paradigm.onsets,2)
                y(adv_paradigm.onsets(i)*1000:((adv_paradigm.onsets(i)-1+duration(i))*1000))=1;
            end
            base    =   [1:adv_paradigm.NR*1000];
            plot(handles.axes1,base,y,' .b');
            set(gca,'XTick',adv_paradigm.onsets*1000);
            lb=strread(num2str(adv_paradigm.onsets),'%s');
            set(gca,'XTickLabel',lb');
            
            xlim(handles.axes1,[1 adv_paradigm.NR*1000]);
            ylim(handles.axes1,[0 1.25]); 
            set(handles.edit31,'UserData',[1]);
            set(handles.uipanel8,'BackgroundColor',[0.867, 0.918, 0.976]);
            set(handles.text7,'BackgroundColor',[0.9,0.7,0.7]);
    else
        axes(handles.axes1); 
        cla;
        set(handles.edit31,'UserData',[0]);    
        set(handles.uipanel8,'BackgroundColor',[0.847,0.161,0]);
            set(handles.text7,'BackgroundColor',[0.847,0.161,0]);  
    end
    set(hObject,'Value',0);
catch err
    fprintf(err.getReport);
    errordlg('Error loading file. Check variables inside.');
    set(hObject,'Value',0);
end
 
% Hint: get(hObject,'Value') returns toggle state of togglebutton5


% --- Executes during object creation, after setting all properties.
function axes6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
route=mfilename('fullpath');
drawing=[fileparts(route) filesep 'blocks.tif'];
im=imread(drawing,'tif');
axes(hObject);
i=image(im);
set(hObject,'XTick',[]);
set(hObject,'YTick',[]);
 
% Hint: place code in OpeningFcn to populate axes6


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val     =   get(hObject,'Value');
custom  =   get(handles.popupmenu6,'Value');

if val==0
    set(handles.uipanel14,'Visible','off');
   set(handles.popupmenu6 ,'Visible','off');          
   set(handles.text16 ,'Visible','off'); 
       set(handles.text17 ,'Visible','off'); 
       set(handles.text21 ,'Visible','off');    
       set(handles.text22 ,'Visible','off');    
       set(handles.text23 ,'Visible','off');    
       set(handles.text24 ,'Visible','off');    
       set(handles.text25 ,'Visible','off'); 
       set(handles.edit12 ,'Visible','off');    
       set(handles.edit13 ,'Visible','off');    
       set(handles.edit14 ,'Visible','off');  
       set(handles.edit26 ,'String','');         
        
elseif val==1
    set(handles.uipanel14,'Visible','on');
    set(handles.popupmenu6 ,'Visible','on');   
    set(handles.text16 ,'Visible','on'); 
    
       set(handles.text17 ,'Visible','on'); 
       set(handles.text21 ,'Visible','on');    
       set(handles.text22 ,'Visible','on');    
       set(handles.text23 ,'Visible','on');    
       set(handles.text24 ,'Visible','on');    
       set(handles.text25 ,'Visible','on'); 
       set(handles.edit12 ,'Visible','on');    
       set(handles.edit13 ,'Visible','on');    
       set(handles.edit14 ,'Visible','on');  
       if custom==1
           set(handles.edit12 ,'Enable','off');    
           set(handles.edit13 ,'Enable','off');    
           set(handles.edit14 ,'Enable','off'); 
       end
       install     =   mfilename('fullpath');
       handed   =   get(handles.radiobutton9,'Value');
       sp       =   get(handles.popupmenu5,'Value');
       if handed && (sp==1)
           set( handles.edit26,'String',[fileparts(install) filesep 'Atlas_SD']);
       elseif handed && (sp==2)
           set( handles.edit26,'String',[fileparts(install) filesep 'Atlas_Wistar']); 
       else
           atlas_dir    =   get(handles.edit11,'String');
           set( handles.edit26,'String',atlas_dir); 
       end       
       
end
 
% Hint: get(hObject,'Value') returns toggle state of checkbox3



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = get(hObject,'String');
set(handles.uipanel5,'BackgroundColor',[0.906,0.906,0.906]);
if isdir(contents) 
    set(hObject,'String',contents); 
else
    set(hObject,'String','');
end
 
% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'String','');
set(hObject,'UserData','');
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
 


% --- Executes on button press in togglebutton6.
function togglebutton6_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isunix 
    %d='/opt/PV5.0/data/nmrsu/nmr/'; 
    d='/media/fMRI_Rata/'; 
end
if ispc 
    d='W:\Proyectos\fMRI\FMRI_RATA\'; 
end
sel_dir = uigetdir(d,'Please select your atlas directory:');
if sel_dir ~=0 
    [route folder e]=fileparts(sel_dir);
    if isdir(sel_dir) && ~isempty(folder) 
        set(hObject,'UserData',sel_dir);
        set(handles.edit8,'String',sel_dir);
        set(handles.edit8,'UserData',sel_dir);
        set(handles.uipanel5,'BackgroundColor',[0.867, 0.918, 0.976]);
    else
        set(handles.edit8,'String','Not valid');
        set(handles.uipanel5,'BackgroundColor',[0.847,0.161,0]);   
    end
end
set(hObject,'Value',0);
 
% Hint: get(hObject,'Value') returns toggle state of togglebutton6



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
p=str2num(get(handles.edit9,'String'));
if p <= 1 && p >= 0
        set(handles.uipanel8,'BackgroundColor',[0.906,0.906,0.906]);
else
        set(handles.edit8,'String','Not valid');
        set(handles.uipanel5,'BackgroundColor',[0.847,0.161,0]);   
end
 
% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
 


function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
k=str2num(get(handles.edit10,'String'));
if k >= 0
        set(handles.uipanel8,'BackgroundColor',[0.906,0.906,0.906]);
else
        set(handles.edit8,'String','Not valid');
        set(handles.uipanel5,'BackgroundColor',[0.847,0.161,0]);   
end
 
% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
 


function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = get(hObject,'String');
set(handles.uipanel4,'BackgroundColor',[0.867, 0.918, 0.976]);
if isdir(contents) 
    set(hObject,'String',contents); 
    set( handles.edit26,'String',contents);
else
    set(hObject,'String','');
    set( handles.edit26,'String','');
end
 
% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'String','');
set(hObject,'UserData','');
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
 
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.



% --- Executes on button press in togglebutton7.
function togglebutton7_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isunix 
    %d='/opt/PV5.0/data/nmrsu/nmr/'; 
    d='/media/fMRI_Rata/'; 
end
if ispc 
    d='W:\Proyectos\fMRI\FMRI_RATA\'; 
end
sel_dir = uigetdir(d,'Please select your atlas directory:');
if sel_dir ~=0 
    [route folder e]=fileparts(sel_dir);
    if isdir(sel_dir) && ~isempty(folder) 
        set(hObject,'UserData',sel_dir);
        set(handles.edit11,'String',sel_dir);
        set(handles.edit26,'String',sel_dir);        
        set(handles.edit11,'UserData',sel_dir);
        set(handles.uipanel14,'BackgroundColor',[222/256, 235/256, 250/256]);
    else
        set(handles.edit11,'String','Not valid');
        set(handles.uipanel14,'BackgroundColor',[0.847,0.161,0]);   
    end
end
set(handles.radiobutton10,'Value',1);
 
% Hint: get(hObject,'Value') returns toggle state of togglebutton7


% --- Executes when selected object is changed in uipanel14.
function uipanel14_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel14 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
c=struct2cell(handles);
sel='';
for i=1:size(c,1) 
    if isnumeric(c{i}) && (c{i}==hObject)
        u=fieldnames(handles);
        sel=u{i};
    end
end
if strcmp(sel,'radiobutton9')
    set(handles.popupmenu5,'Enable','on');
    set(handles.togglebutton7,'Enable','off');
    set(handles.edit11,'Enable','off');
    set(handles.radiobutton9,'Value',1);
    set(handles.radiobutton10,'Value',0);
    install     =   mfilename('fullpath');
    if (get(handles.popupmenu5,'Value')==1)
       set( handles.edit26,'String',[fileparts(install) filesep 'Atlas_SD']);
    elseif (get(handles.popupmenu5,'Value')==2)
       set( handles.edit26,'String',[fileparts(install) filesep 'Atlas_Wistar']); 
    end    
    
elseif strcmp(sel,'radiobutton10')
    set(handles.popupmenu5,'Enable','off');
    set(handles.togglebutton7,'Enable','on');
    set(handles.edit11,'Enable','on'); 
    set(handles.radiobutton10,'Value',1);
    set(handles.radiobutton9,'Value',0);    
    if ~isempty(get(handles.edit11,'String'))
       set( handles.edit26,'String',get(handles.edit11,'String'));
    else
       set( handles.edit26,'String',''); 
    end       
 
elseif strcmp(sel,'togglebutton7')
        % Browse button
        d=get(handles.edit11,'String');
        sel_dir = uigetdir(d,'Please select your atlas directory:');
        if sel_dir ~=0 
            [route folder e]=fileparts(sel_dir);
            if isdir(sel_dir) && ~isempty(folder) 
                set(hObject,'UserData',sel_dir);
                set(handles.edit11,'String',sel_dir);
                set(handles.edit26,'String',sel_dir);                
                set(handles.edit11,'UserData',sel_dir);
                set(handles.radiobutton10,'Value',1);                
                set(handles.uipanel14,'BackgroundColor',[0.867, 0.918, 0.976]);
            else
                set(handles.radiobutton10,'Value',1);                 
                set(handles.edit11,'String','Not valid');
                set(handles.uipanel14,'BackgroundColor',[0.847,0.161,0]);   
            end
        end
        set(hObject,'Value',0);
    
end
 



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
custom_resol =  mod(get(handles.popupmenu6,'Value')+1,2);
coreg =         get(handles.checkbox3,'Value');
rxs =           get(handles.edit12,'String'); 
rys =           get(handles.edit13,'String');
rzs =           get(handles.edit14,'String'); 
if ~isempty(rxs) && ~isempty(rys) && ~isempty(rzs)
        rx   =  str2num(rxs);
        ry   =  str2num(rys);
        rz   =  str2num(rzs); 
    if (coreg && (custom_resol==1) && (isempty(rx)||isempty(ry)||isempty(rz))) 
        set(handles.popupmenu6,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit12,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit13,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit14,'BackgroundColor',[0.847,0.161,0]);
            set(hObject,'Value',0);  
            errordlg('Final resolution is not valid');         
    elseif (coreg && (custom_resol==1) && ((rx<=0)||(ry<=0)||(rz<=0))) 
        set(handles.popupmenu6,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit12,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit13,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit14,'BackgroundColor',[0.847,0.161,0]);
            set(hObject,'Value',0);  
            errordlg('Final resolution should be higher than zero'); 
    else
        set(handles.popupmenu6,'BackgroundColor',[0.906,0.906,0.906]);
        set(handles.edit12,'BackgroundColor',[0.906,0.906,0.906]);
        set(handles.edit13,'BackgroundColor',[0.906,0.906,0.906]);
        set(handles.edit14,'BackgroundColor',[0.906,0.906,0.906]);
    end
end
 
% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
 


function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
custom_resol =  mod(get(handles.popupmenu6,'Value')+1,2);
coreg =         get(handles.checkbox3,'Value');
rxs =           get(handles.edit12,'String'); 
rys =           get(handles.edit13,'String');
rzs =           get(handles.edit14,'String'); 
if ~isempty(rxs) && ~isempty(rys) && ~isempty(rzs)
        rx   =  str2num(rxs);
        ry   =  str2num(rys);
        rz   =  str2num(rzs); 
    if (coreg && (custom_resol==1) && (isempty(rx)||isempty(ry)||isempty(rz))) 
        set(handles.popupmenu6,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit12,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit13,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit14,'BackgroundColor',[0.847,0.161,0]);
            set(hObject,'Value',0);  
            errordlg('Final resolution is not valid');         
    elseif (coreg && (custom_resol==1) && ((rx<=0)||(ry<=0)||(rz<=0))) 
        set(handles.popupmenu6,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit12,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit13,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit14,'BackgroundColor',[0.847,0.161,0]);
            set(hObject,'Value',0);  
            errordlg('Final resolution should be higher than zero'); 
    else
        set(handles.popupmenu6,'BackgroundColor',[0.906,0.906,0.906]);
        set(handles.edit12,'BackgroundColor',[0.906,0.906,0.906]);
        set(handles.edit13,'BackgroundColor',[0.906,0.906,0.906]);
        set(handles.edit14,'BackgroundColor',[0.906,0.906,0.906]);
    end
end

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
 


function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
custom_resol =  mod(get(handles.popupmenu6,'Value')+1,2);
coreg =         get(handles.checkbox3,'Value');
rxs =           get(handles.edit12,'String'); 
rys =           get(handles.edit13,'String');
rzs =           get(handles.edit14,'String'); 
if ~isempty(rxs) && ~isempty(rys) && ~isempty(rzs)
        rx   =  str2num(rxs);
        ry   =  str2num(rys);
        rz   =  str2num(rzs); 
    if (coreg && (custom_resol==1) && (isempty(rx)||isempty(ry)||isempty(rz))) 
        set(handles.popupmenu6,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit12,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit13,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit14,'BackgroundColor',[0.847,0.161,0]);
            set(hObject,'Value',0);  
            errordlg('Final resolution is not valid');         
    elseif (coreg && (custom_resol==1) && ((rx<=0)||(ry<=0)||(rz<=0))) 
        set(handles.popupmenu6,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit12,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit13,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit14,'BackgroundColor',[0.847,0.161,0]);
            set(hObject,'Value',0);  
            errordlg('Final resolution should be higher than zero'); 
    else
        set(handles.popupmenu6,'BackgroundColor',[0.906,0.906,0.906]);
        set(handles.edit12,'BackgroundColor',[0.906,0.906,0.906]);
        set(handles.edit13,'BackgroundColor',[0.906,0.906,0.906]);
        set(handles.edit14,'BackgroundColor',[0.906,0.906,0.906]);
    end
end

 
% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
 

% --- Executes on selection change in popupmenu6.
function popupmenu6_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val=get(hObject,'Value');
if val==2
   set(handles.edit12 ,'Visible','on');    
   set(handles.edit13 ,'Visible','on');    
   set(handles.edit14 ,'Visible','on');  
   set(handles.text17 ,'Enable','on'); 
   set(handles.text21 ,'Enable','on');    
   set(handles.text22 ,'Enable','on');    
   set(handles.text23 ,'Enable','on');    
   set(handles.text24 ,'Enable','on');    
   set(handles.text25 ,'Enable','on'); 
   set(handles.edit12 ,'Enable','on');    
   set(handles.edit13 ,'Enable','on');    
   set(handles.edit14 ,'Enable','on');  
   
else
   set(handles.text17 ,'Enable','off'); 
   set(handles.text21 ,'Enable','off');    
   set(handles.text22 ,'Enable','off');    
   set(handles.text23 ,'Enable','off');    
   set(handles.text24 ,'Enable','off');    
   set(handles.text25 ,'Enable','off'); 
   set(handles.edit12 ,'Enable','off');    
   set(handles.edit13 ,'Enable','off');    
   set(handles.edit14 ,'Enable','off');  

end
 set(handles.popupmenu6,'BackgroundColor',[1,1,1]);
% Hints: contents = get(hObject,'String') returns popupmenu6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu6



% --- Executes during object creation, after setting all properties.
function popupmenu6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
 



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
smooth =         get(handles.checkbox2,'Value');
smx =           get(handles.edit15,'String'); 

if ~isempty(smx) 
        sx   =  str2num(smx);
 
    if smooth && (isnan(sx)) 
            set(handles.checkbox2,'BackgroundColor',[0.847,0.161,0]);
            set(handles.edit15,'BackgroundColor',[0.847,0.161,0]);            
            set(hObject,'Value',0);  
            errordlg('Smoothing resolution is not valid');         
    elseif smooth && (sx<=0) 
            set(handles.checkbox2,'BackgroundColor',[0.847,0.161,0]);
            set(handles.edit15,'BackgroundColor',[0.847,0.161,0]);  
            set(hObject,'Value',0);  
            errordlg('Smoothing resolution should be higher than zero'); 
    else
            set(handles.checkbox2,'BackgroundColor',[0.906,0.906,0.906]);
            set(handles.edit15,'BackgroundColor',[0.906,0.906,0.906]);        
    end
end
% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes during object creation, after setting all properties.
function uipanel14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function uipanel5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when selected object is changed in uipanel18.
function uipanel19_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel18 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
c=struct2cell(handles);
sel=0;
for i=1:size(c,1) 
    if c{i}==hObject
        u=fieldnames(handles);
        sel=u{i};
    end
end
if strcmp(sel,'radiobutton18')
    set(handles.radiobutton19,'Enable','off');
    

elseif strcmp(sel,'radiobutton19')
    set(handles.radiobutton18,'Enable','off');

end
 




% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function edit24_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes during object creation, after setting all properties.
function edit25_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit24_Callback(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit24 as text
%        str2double(get(hObject,'String')) returns contents of edit24 as a double
try
    p =             str2num(get(handles.edit24,'String'));
       set(handles.edit24,'BackgroundColor',[0.906,0.906,0.906]);        
catch
            set(handles.edit24,'BackgroundColor',[0.847,0.161,0]);
            errordlg('Probability threshold p should be 0<p<1'); 
end



function edit25_Callback(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit25 as text
%        str2double(get(hObject,'String')) returns contents of edit25 as a double
try
    k =             str2num(get(handles.edit25,'String'));
       set(handles.edit25,'BackgroundColor',[0.906,0.906,0.906]);        
catch
            set(handles.edit25,'BackgroundColor',[0.847,0.161,0]);
            errordlg('Cluster size should be greater than 1'); 
end


% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    install     =   mfilename('fullpath');
    roi_dir     =   get(handles.edit26,'String');
    if (get(handles.popupmenu5,'Value')==1)
       set( handles.edit26,'String',[fileparts(install) filesep 'Atlas_SD']);
    elseif (get(handles.popupmenu5,'Value')==2)
       set( handles.edit26,'String',[fileparts(install) filesep 'Atlas_Wistar']); 
    end
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu5


% --- Executes when uipanel7 is resized.
function uipanel7_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to uipanel7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in checkbox9.
function checkbox9_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox9


% --- Executes on button press in checkbox8.
function checkbox8_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox8


% --- Executes on button press in checkbox10.
function checkbox10_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox10


% --- Executes on button press in checkbox11.
function checkbox11_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox11


% --- Executes on button press in checkbox12.
function checkbox12_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val     =   get(hObject,'Value');
if val
    set(handles.edit26,'Enable','On');
    set(handles.pushbutton3,'Enable','On');    
    set(handles.edit25,'Enable','On');
    set(handles.edit24,'Enable','On');    
    set(handles.radiobutton18,'Enable','On');    
    set(handles.radiobutton19,'Enable','On');        
else 
    set(handles.edit26,'Enable','Off');    
    set(handles.pushbutton3,'Enable','Off');  
    set(handles.edit25,'Enable','Off');
    set(handles.edit24,'Enable','Off');    
    set(handles.radiobutton18,'Enable','Off');    
    set(handles.radiobutton19,'Enable','Off');          
end
% Hint: get(hObject,'Value') returns toggle state of checkbox12


% --- Executes on key press with focus on edit2 and none of its controls.
function edit2_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on edit31 and none of its controls.
function edit31_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on edit4 and none of its controls.
function edit4_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --------------------------------------------------------------------
function uipanel14_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to uipanel14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox13.
function checkbox13_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox13


% --- Executes on button press in checkbox15.
function checkbox15_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox15



function edit26_Callback(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
        % ROIs dir
        in_data = get(hObject,'String');
        if isdir(in_data) 
            set(hObject,'String',in_data); 
        else
            set(hObject,'String','');
        end
% Hints: get(hObject,'String') returns contents of edit26 as text
%        str2double(get(hObject,'String')) returns contents of edit26 as a double


% --- Executes during object creation, after setting all properties.
function edit26_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
        % Browse button
        d=get(handles.edit1,'String');
        sel_dir = uigetdir(d,'Please select your ROIs directory:');
        if sel_dir ~=0 
            [route folder e]=fileparts(sel_dir);
            if isdir(sel_dir) && ~isempty(folder) 
                set(handles.edit26,'String',sel_dir);
                set(handles.edit26,'UserData',sel_dir);
            else
                set(handles.edit26,'String','Not valid');
            end
        end


% --- Executes when uipanel20 is resized.
function uipanel20_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to uipanel20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit27_Callback(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit27 as text
%        str2double(get(hObject,'String')) returns contents of edit27 as a double


% --- Executes during object creation, after setting all properties.
function edit27_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit28_Callback(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit28 as text
%        str2double(get(hObject,'String')) returns contents of edit28 as a double


% --- Executes during object creation, after setting all properties.
function edit28_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function uipanel20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function edit29_Callback(hObject, eventdata, handles)
% hObject    handle to edit29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(get(hObject,'String'))
    set(handles.edit29,'BackgroundColor',[1,1,1]); 
    set(handles.uipanel21,'BackgroundColor',[0.867, 0.918, 0.976]);     
else
    set(handles.edit29,'BackgroundColor',[0.847,0.161,0]); 
    set(handles.uipanel21,'BackgroundColor',[0.847,0.161,0]);    
end
% Hints: get(hObject,'String') returns contents of edit29 as text
%        str2double(get(hObject,'String')) returns contents of edit29 as a double


% --- Executes during object creation, after setting all properties.
function edit29_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit30_Callback(hObject, eventdata, handles)
% hObject    handle to edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(get(hObject,'String'))
    set(handles.edit30,'BackgroundColor',[1,1,1]); 
    set(handles.uipanel21,'BackgroundColor',[0.867, 0.918, 0.976]);     
else
    set(handles.edit30,'BackgroundColor',[0.847,0.161,0]); 
    set(handles.uipanel21,'BackgroundColor',[0.847,0.161,0]);    
end
% Hints: get(hObject,'String') returns contents of edit30 as text
%        str2double(get(hObject,'String')) returns contents of edit30 as a double


% --- Executes during object creation, after setting all properties.
function edit30_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on togglebutton4 and none of its controls.
function togglebutton4_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to togglebutton4 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)




% --------------------------------------------------------------------
function Print_Callback(hObject, eventdata, handles)
% hObject    handle to Print (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printpreview
printdlg


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prev        =   get(handles.uipanel22,'UserData');
if (isfield(prev,'paradigm')) && isstruct(prev.paradigm)
    pdgm    =   prev.paradigm;
    pdgm    =   Paradigm(pdgm.NR,pdgm.onsets, pdgm.duration);
else
    pdgm    =   Paradigm;
end
%             set(handles.edit2,'String','');
%             set(handles.edit4,'String',''); 
%             set(handles.edit31,'String',''); 

if isstruct(pdgm)
    
            %pass the data
            prev.paradigm    =  pdgm;
            set(handles.uipanel22,'UserData',prev);
            set(handles.edit31,'String',pdgm.NR);
            set(handles.edit31,'UserData',1); %block_ok=1    
    
            % DRAW    
            set(handles.axes1,'Visible','on');
            axes(handles.axes1); 
            xlabel  =   text(0,0,'Images','Visible','off');
            set(handles.axes1,'XLabel',xlabel);
            
            if size(pdgm.duration,1)==1
               duration     =   repmat(pdgm.duration,1,size(pdgm.onsets,2)); 
            end
            y       =   zeros(1,pdgm.NR*1000); 
            for i=1:size(pdgm.onsets,2)
                y(pdgm.onsets(i)*1000:((pdgm.onsets(i)+duration(i)-1)*1000))=1;
            end
            base    =   [1:pdgm.NR*1000];
            plot(handles.axes1,base,y,' .b');
            set(gca,'XTick',pdgm.onsets*1000);
            lb=strread(num2str(pdgm.onsets),'%s');
            set(gca,'XTickLabel',lb');
            
            xlim(handles.axes1,[1 pdgm.NR*1000]);
            ylim(handles.axes1,[0 1.25]); 
            set(handles.edit31,'UserData',[1]);
            set(handles.uipanel8,'BackgroundColor',[0.867, 0.918, 0.976]);
            set(handles.text7,'BackgroundColor',[0.9,0.7,0.7]);
            set(handles.edit2,'String','');
            set(handles.edit4,'String','');            
elseif isstruct(prev) && isfield(prev,'paradigm')
            prev            =   rmfield(prev,'paradigm');    
            set(handles.axes1,'Visible','on');
            set(handles.edit31,'UserData',[0]);
end
set(handles.uipanel22,'UserData',prev);             

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton4.
function pushbutton4_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% REGRESSORS
prev        =   get(handles.uipanel22,'UserData');
NR          =   str2num(get(handles.edit31,'String'));
if ~isempty(NR)
    if (isfield(prev,'cov')) && ~isempty(prev.cov)
        covariates    =   prev.cov;
        covariates    =   Regressors_ui(covariates, NR);
    else
        covariates    =   Regressors_ui([],NR);
    end
    if size(covariates,1)~=1
        prev.cov    =  covariates;
    elseif isstruct(prev) && isfield(prev,'cov')
            prev            =   rmfield(prev,'cov');    
    end
    set(handles.uipanel22,'UserData',prev);      
  
else
    errordlg(['You cannot enter the covariates before defining NR. '...
        'Please enter NR in the corresponding edit box or enter an advanced paradigm through "Advanced" button']);
end




% --- Executes on button press in checkbox16.
function checkbox16_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox16



function edit33_Callback(hObject, eventdata, handles)
% hObject    handle to edit33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
skip        =   get(handles.edit33,'String'); 
rep         =   get(handles.edit31,'String'); 

if ~isempty(skip) && ~isempty(str2num(skip)) && ~isempty(str2num(rep))
        sk   =  str2num(skip);
        NR   =  str2num(rep);
    if ~isscalar(sk)
            set(handles.edit33,'BackgroundColor',[0.847,0.161,0]);
            set(hObject,'Value',0);  
            errordlg('Skipped volumes are not a valid number');         
    elseif (sk<0) || (sk> (NR-3))
            set(handles.edit33,'BackgroundColor',[0.847,0.161,0]);
            set(hObject,'Value',0);  
            errordlg('Skipped volumes must be >=0 and <=(NR-3)');
    else
            set(handles.edit33,'BackgroundColor',[1,1,1]);
    end
else
    set(handles.edit33,'BackgroundColor',[0.847,0.161,0]);    
    set(handles.edit33,'String','0'); 
    errordlg('Skipped volumes must be a number >=0 and <=(NR-3). Fill this field after you have defined NR.');
end
% Hints: get(hObject,'String') returns contents of edit33 as text
%        str2double(get(hObject,'String')) returns contents of edit33 as a double


% --- Executes during object creation, after setting all properties.
function edit33_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function edit36_Callback(hObject, eventdata, handles)
% hObject    handle to edit36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cutoff        =   get(handles.edit36,'String'); 


if ~isempty(cutoff) 
        cutoff   =  str2num(cutoff);
    if ~isscalar(cutoff)
            set(handles.edit36,'BackgroundColor',[0.847,0.161,0]);
            set(hObject,'Value',0);  
            errordlg('Cutoff is not a valid number');         
    elseif (cutoff<0) 
            set(handles.edit36,'BackgroundColor',[0.847,0.161,0]);
            set(hObject,'Value',0);  
            errordlg('Cutoff must be >=0');
    else
            set(handles.edit36,'BackgroundColor',[1,1,1]);
    end
else
    set(handles.edit36,'BackgroundColor',[0.847,0.161,0]);
    errordlg(['Cutoff must be a number >=0. It is the cutoff period in seconds' ...
    'for the high pass filter. All signals with a period higher than this will be filtered out.']);
end
% Hints: get(hObject,'String') returns contents of edit36 as text
%        str2double(get(hObject,'String')) returns contents of edit36 as a double


% --- Executes during object creation, after setting all properties.
function edit36_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prev                =   get(handles.uipanel22,'UserData');
if (isfield(prev,'user_hrf')) 
    user_hrf        =   prev.user_hrf;
    t_max           =   prev.t_max;
    info            =   User_hrf(user_hrf,t_max);
else
    info            =   User_hrf;
end
if isstruct(info)

    %pass the data
    prev.user_hrf   =  info.user_hrf;
    prev.t_max      =  info.t_max;     
elseif isstruct(prev) && isfield(prev,'user_hrf')
    prev            =   rmfield(prev,'user_hrf');
    prev            =   rmfield(prev,'t_max');
end
set(handles.uipanel22,'UserData',prev); 


