function varargout = fmri_nifti_gui(varargin)
% FMRI_NIFTI_GUI M-file for fmri_nifti_gui.fig
%      FMRI_NIFTI_GUI, by itself, creates a new FMRI_NIFTI_GUI or raises
%      the existing
%      singleton*.
%
%      H = FMRI_NIFTI_GUI returns the handle to a new FMRI_NIFTI_GUI or the handle to
%      the existing singleton*.
%
%      FMRI_NIFTI_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      edit31tion named CALLBACK in FMRI_NIFTI_GUI.M with the given input arguments.
%
%      FMRI_NIFTI_GUI('Property','Value',...) creates a new FMRI_NIFTI_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fmri_nifti_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fmri_nifti_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help fmri_nifti_gui

% Last Modified by GUIDE v2.5 04-Apr-2017 14:38:33

% Begin initialization code - DO NOT EDIT
global test
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fmri_nifti_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @fmri_nifti_gui_OutputFcn, ...
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


% --- Executes just before fmri_nifti_gui is made visible.
function fmri_nifti_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fmri_nifti_gui (see VARARGIN)

% Choose default command line output for fmri_nifti_gui

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
path=mfilename('fullpath');
drawing=[fileparts(path) filesep 'blocks.tif'];
im=imread(drawing,'tif');
axes(handles.axes5);
i=image(im);
set(handles.axes5,'XTick',[]);
set(handles.axes5,'YTick',[]);

% Load default values
axes(handles.axes3); 
cla
set(handles.edit14,'String','');

set(handles.edit15,'String','');
set(handles.edit16,'String','');
set(handles.edit17,'String','');

set(handles.edit17,'UserData',[0]);

set(handles.checkbox3,'Value',1);
set(handles.edit22,'String','1.2');

set(handles.checkbox4,'Value',0);
set(handles.popupmenu4,'Value',1);
set(handles.edit19,'String','');
set(handles.edit20,'String','');
set(handles.edit21,'String','');
   set(handles.edit19 ,'Enable','off');    
   set(handles.edit20 ,'Enable','off');    
   set(handles.edit21 ,'Enable','off'); 
set(handles.text41,'Visible','off');

set(handles.checkbox6,'Value',1);
set(handles.checkbox7,'Value',1);
set(handles.checkbox8,'Value',1);
set(handles.checkbox10,'Value',1);


set(handles.radiobutton7,'Value',0);
set(handles.radiobutton8,'Value',1);
set(handles.edit23,'String','0.05');
set(handles.edit24,'String','4');
set(handles.text26,'BackgroundColor',[0.9,0.7,0.7]);
install     =   mfilename('fullpath');
set( handles.edit27,'String','');%[fileparts(install) filesep 'Atlas_SD']);
set(handles.uipanel17,'Visible','off');

set(handles.radiobutton5,'Value',1);
set(handles.radiobutton6,'Value',0);
set(handles.popupmenu3,'Enable','on');
set(handles.togglebutton7,'Enable','off');
set(handles.edit18,'Enable','off');

set(handles.togglebutton6,'Value',0);
set(handles.togglebutton8,'Value',0);
set(handles.togglebutton9,'Value',0);
set(handles.togglebutton10,'Value',0);

set(handles.edit30,'String','0');
set(handles.edit31,'String','128');
set(handles.edit32,'String','0.3');
set(handles.uipanel20,'UserData',[]);
set(handles.popupmenu5,'Value',1);
% UIWAIT makes fmri_nifti_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function fmri_nifti_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);



% --- Executes on button press in togglebutton8.
function togglebutton8_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% "START" BUTTON

p               =   ancestor(hObject,'figure');
data            =   get(p,'UserData');
struct_ok       =   ~strcmp(data,'error');
if all(struct_ok)
    data_struct     =   data{1,2};
    studies         =   fieldnames(data_struct);  
end

sel_dir =       deblank(get(handles.edit14,'String'));
sm =            get(handles.checkbox3,'Value');
sx='';
if sm==1
    sx=str2double(get(handles.edit22,'String'));
end
coreg =         get(handles.checkbox4,'Value');
sp =            0;
custom_atlas =  0;
atlas_dir =     '';
rx =            0;
ry =            0;
rz =            0;

atlas_dir = deblank(get(handles.edit18,'String'));
if ~isempty(atlas_dir) custom_atlas=1; end

sp = get(handles.popupmenu3,'Value');        
custom_resol =  mod(get(handles.popupmenu4,'Value')+1,2);
    if custom_resol==1
        rx   =  str2num(get(handles.edit19,'String'));
        ry   =  str2num(get(handles.edit20,'String'));
        rz   =  str2num(get(handles.edit21,'String'));        
    end
    
preprocess  =   0;    
realign     =   get(handles.checkbox10,'Value');
design      =   get(handles.checkbox6,'Value');
estimate    =   get(handles.checkbox7,'Value');
display     =   get(handles.checkbox8,'Value');
preserve    =   get(handles.checkbox11,'Value');
action      =   'all';
if (~realign && design && estimate && display)
    action  =   'from_coreg';
elseif (~realign && ~design && estimate && display)
    action  =   'from_estimate';
elseif (~realign && ~design && ~estimate && display)
    action  =   'display';
end      
    
rois_dir    =   deblank(get(handles.edit27,'String'));
block_ok =      get(handles.edit17,'UserData');
NR =            str2num(get(handles.edit17,'String'));
Nrest =         str2num(get(handles.edit15,'String'));
Nstim =         str2num(get(handles.edit16,'String'));

skip        =   str2num(get(handles.edit30,'String')); 
cutoff  =       str2num(get(handles.edit31,'String')); 
adv_dat     =   get(handles.uipanel20,'UserData');
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
thr         =   str2num(get(handles.edit32,'String'));   
fwe=            get(handles.radiobutton8,'Value');
p=              str2num(get(handles.edit23,'String'));
k=              str2num(get(handles.edit24,'String'));
disp_or     =   get(handles.popupmenu5,'Value');
if disp_or==1
    disp_or     =   4;
end
disp_or     =   disp_or-1;



anat_seq=       '';
func_seq=       '';
mode_reg=2;
TR          =   str2num(get(handles.edit28,'String'));

if ~strcmp(action,'all') && ~preserve
   warndlg(['You are not following the typical workflow, and "Preserve previous processing steps" is NOT checked. ' ...
       'This might produce unexpected results. Please check that tickbox and make sure the required previous steps were done correctly.']); 
   return
end

ok= ['isdir(sel_dir) && all(struct_ok) && ((block_ok==1) || ~isempty(adv_paradigm)) && ' ...
    '((coreg && (sp~=0))|| (coreg && (~isempty(atlas_dir))) || (~coreg))' ...
    '&& ((custom_resol==0)||((~isempty(rx))&&(~isempty(ry))&&(~isempty(rz))))'...
    '&& ((sm==0)|| (~isnan(sx))) && ((p>0)&& (p<=1) && (~isnan(p)))&& ((k>0)&&(~isnan(k)))' ...
    '&& exist(''data_struct'',''var'') && ~isempty(TR) '...
    '&& ((skip>=0)&& (~isnan(skip))) && ((cutoff>=0) && (~isnan(skip))) ' ...
    '&& (~isnan(cutoff)) && (~isempty(thr) && thr>0 && thr<1)'];
if eval(ok)        
    set(handles.uipanel12,'BackgroundColor',[0.867, 0.918, 0.976]);
    set(handles.uipanel19,'BackgroundColor',[0.906,0.906,0.906]); 
    cputime,
    eval(['fmri(action,sel_dir,sp,atlas_dir,sm,coreg,mode_reg,anat_seq,func_seq,'...
        'NR,Nrest,Nstim,'''',fwe,p,k,custom_atlas,custom_resol,rx,ry,rz,sx,preserve,preprocess,' ...
        'realign, design,estimate, display,adv_paradigm, adv_cov, skip,cutoff,user_hrf,t_max,' ...
        'disp_or,thr,1,studies,data_struct,rois_dir, TR)']);

elseif ~(isdir(sel_dir)) 
        set(handles.edit14,'String','Not valid');
        set(handles.uipanel12,'BackgroundColor',[0.847,0.161,0]);
        set(hObject,'Value',0);
        errordlg('Directory is not valid');
elseif ~all(struct_ok)
       set(handles.text41,'Visible','on');            
       set(handles.text41,'String','WRONG','BackgroundColor', [0.847,0.161,0]);        
        errordlg(['Data structure retrieved from "Nifti selector" window is not valid. Press "Browse" '...
            'button again for fMRI folder selection and set functional-structural correspondences.']);        
elseif block_ok==0 && isempty(adv_paradigm)
        set(handles.uipanel19,'BackgroundColor',[0.847,0.161,0]);
        set(hObject,'Value',0);  
        errordlg('Block design is not valid');    
elseif coreg && (sp==0) && (isempty(atlas_dir))
        set(handles.uipanel17,'BackgroundColor',[0.847,0.161,0]);
        set(hObject,'Value',0);  
        errordlg('Atlas specification is not valid');          
elseif (coreg && (custom_resol==1) && ((isempty(rx))||(isempty(ry))||(isempty(rz)))) 
        set(handles.popupmenu4,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit19,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit20,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit21,'BackgroundColor',[0.847,0.161,0]);        
        set(hObject,'Value',0);  
        errordlg('Final resolution is not valid');                  
elseif (coreg && (custom_resol==1) && ((rx==0)||(ry==0)||(rz==0))) 
        set(handles.popupmenu4,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit19,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit20,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit21,'BackgroundColor',[0.847,0.161,0]);           
        set(hObject,'Value',0);  
        errordlg('Final resolution is not valid');  
    elseif (sm==1 && isnan(sx)) 
        set(handles.checkbox3,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit22,'BackgroundColor',[0.847,0.161,0]);
        set(hObject,'Value',0);  
        errordlg('Smoothing resolution is not valid');
    elseif (skip<0 || isnan(skip))
        set(handles.edit30,'BackgroundColor',[0.847,0.161,0]);
        errordlg('Skipped volumes are not a valid number');    
    elseif (cutoff<0 || isnan(cutoff))
        set(handles.edit31,'BackgroundColor',[0.847,0.161,0]);
        errordlg('Cutoff is not a valid number');
    elseif (isempty(thr) || thr<=0 || thr>=1)
         set(handles.edit32,'BackgroundColor',[0.847,0.161,0]);
        errordlg('Threshold is not a valid number. Insert a value between 0 and 1.');            
    elseif (p<=0)|| (p>=1) ||(isnan(p))
        set(handles.edit23,'BackgroundColor',[0.847,0.161,0]);
        set(hObject,'Value',0);  
        errordlg('Probability threshold p should be 0<p<1'); 
    elseif (k<1) || (isnan(k))
        set(handles.edit24,'BackgroundColor',[0.847,0.161,0]);
        set(hObject,'Value',0);  
        errordlg('Cluster size should be greater than 1');     
    elseif isempty(TR) 
        set(handles.edit28,'BackgroundColor',[0.847,0.161,0]);
        set(hObject,'Value',0);  
        errordlg('Please fill in a valid number for TR in miliseconds');           
     
end



% Hint: get(hObject,'Value') returns toggle state of togglebutton8


% --- Executes on button press in togglebutton9.
function togglebutton9_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%SAVE CONFIG
p           =   ancestor(hObject,'figure');
data        =   get(p,'UserData');   
struct_ok   =   ~strcmp(data,'error');

sel_dir     =   deblank(get(handles.edit14,'String'));    
cd(sel_dir);
sm          =   get(handles.checkbox3,'Value');
sx          =   '';
if sm==1
    sx=str2double(get(handles.edit22,'String'));
end
coreg =         get(handles.checkbox4,'Value');
sp =            0;
custom_atlas =  get(handles.radiobutton6,'Value');
atlas_dir =     deblank(get(handles.edit18,'String'));
rx =            0;
ry =            0;
rz =            0;
sp = get(handles.popupmenu3,'Value');
custom_resol =  mod(get(handles.popupmenu4,'Value')+1,2);
    if custom_resol==1
        rx   =  str2num(get(handles.edit19,'String'));
        ry   =  str2num(get(handles.edit20,'String'));
        rz   =  str2num(get(handles.edit21,'String'));        
    end
rois_dir    =   deblank(get(handles.edit27,'String'));  
preserve    =   get(handles.checkbox11,'Value');
rea         =   get(handles.checkbox10,'Value');
des         =   get(handles.checkbox6,'Value');
tim         =   get(handles.checkbox7,'Value');
dis         =   get(handles.checkbox8,'Value');      
block_ok    =   get(handles.edit17,'UserData');
NR =            str2num(get(handles.edit17,'String'));
Nrest =         str2num(get(handles.edit15,'String'));
Nstim =         str2num(get(handles.edit16,'String'));
skip        =   str2num(get(handles.edit30,'String'));
cutoff      =   str2num(get(handles.edit31,'String'));
adv_dat     =   get(handles.uipanel20,'UserData');
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
thr      =      str2num(get(handles.edit32,'String'));
fwe=            get(handles.radiobutton8,'Value');
p =             str2num(get(handles.edit23,'String'));
k =             str2num(get(handles.edit24,'String'));
disp_or     =   get(handles.popupmenu5,'Value');
% if disp_or==1
%     disp_or     =   4;
% else
%     disp_or     =   disp_or-1;
% end
TR          =   str2num(get(handles.edit28,'String'));


ok= ['~isempty(data) && all(struct_ok) && isdir(sel_dir) && (block_ok==1) && ' ...
    '((coreg && (sp~=0))|| (coreg && (~isempty(atlas_dir))) || (~coreg))' ...
    '&& ((custom_resol==0)||((~isempty(rx))&&(~isempty(ry))&&(~isempty(rz))))' ...
    '&& ((sm==0)||(~isnan(sx))) && ((p>0)|| (p>=1) ||(~isnan(p)))&& ((k>1)||(~isnan(k)))'...
    '&& ((skip>=0)&& (~isnan(skip))) && ((cutoff>=0) && (~isnan(cutoff)))'...    
    '&& ~isempty(TR) && (~isempty(thr) && thr>0 && thr<1)'];

if eval(ok)        
    set(handles.uipanel12,'BackgroundColor',[0.867,0.918,0.976]);
    set(handles.uipanel19,'BackgroundColor',[0.906,0.906,0.906]);
    [file,route] = uiputfile('config.mat','Save config file');
    if file ~=0 
        if isdir(route)  

        cd(route);
        try
            fullpath=[route file];
            save(fullpath,'sel_dir','data','struct_ok','block_ok','NR','Nrest','Nstim',...
                'coreg','custom_atlas','sp','atlas_dir','custom_resol','rx','ry','rz',...
                'rea','des','tim','dis','sm','fwe','p','k','sx','preserve','rois_dir',...
                'TR','adv_paradigm','adv_cov','skip','cutoff','thr','user_hrf','t_max','disp_or');
            fclose all;            
        catch
            errordlg('Cannot save config file here. Check folder permissions');
        end
        end
    end
elseif ~(isdir(sel_dir)) 
        set(handles.edit14,'String','Not valid');
        set(handles.uipanel12,'BackgroundColor',[0.847,0.161,0]);
        set(hObject,'Value',0);
        errordlg('Directory is not valid');
elseif ~all(struct_ok)
       set(handles.text41,'Visible','on');            
       set(handles.text41,'String','WRONG','BackgroundColor', [0.847,0.161,0]);        
        errordlg(['Data structure retrieved from "Nifti selector" window is not valid. Press "Browse" '...
            'button again for fMRI folder selection and set functional-structural correspondences.']);        
elseif block_ok==0 && isempty(adv_paradigm)
        set(handles.uipanel19,'BackgroundColor',[0.847,0.161,0]);
        set(hObject,'Value',0);  
        errordlg('Block design is not valid');    
elseif coreg && (sp==0) && (isempty(atlas_dir))
        set(handles.uipanel17,'BackgroundColor',[0.847,0.161,0]);
        set(hObject,'Value',0);  
        errordlg('Atlas specification is not valid');          
elseif (coreg && (custom_resol==1) && ((isempty(rx))||(isempty(ry))||(isempty(rz)))) 
        set(handles.popupmenu4,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit19,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit20,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit21,'BackgroundColor',[0.847,0.161,0]);        
        set(hObject,'Value',0);  
        errordlg('Final resolution is not valid');                  
elseif (coreg && (custom_resol==1) && ((rx==0)||(ry==0)||(rz==0))) 
        set(handles.popupmenu4,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit19,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit20,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit21,'BackgroundColor',[0.847,0.161,0]);           
        set(hObject,'Value',0);  
        errordlg('Final resolution is not valid');  
    elseif (sm==1 && isnan(sx)) 
        set(handles.checkbox3,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit22,'BackgroundColor',[0.847,0.161,0]);
        set(hObject,'Value',0);  
        errordlg('Smoothing resolution is not valid');
    elseif (skip<0 || isnan(skip))
        set(handles.edit30,'BackgroundColor',[0.847,0.161,0]);
        errordlg('Skipped volumes are not a valid number');    
    elseif (cutoff<0 || isnan(cutoff))
        set(handles.edit31,'BackgroundColor',[0.847,0.161,0]);
        errordlg('Cutoff is not a valid number');     
    elseif (thr<0 || thr>1 || isnan(thr))
        set(handles.edit32,'BackgroundColor',[0.847,0.161,0]);
        errordlg('Threshold is not a valid number. Insert a value between 0 and 1.');          
    elseif (p<=0)|| (p>=1) ||(isnan(p))
        set(handles.edit23,'BackgroundColor',[0.847,0.161,0]);
        set(hObject,'Value',0);  
        errordlg('Probability threshold p should be 0<p<1'); 
    elseif (k<1) || (isnan(k))
        set(handles.edit24,'BackgroundColor',[0.847,0.161,0]);
        set(hObject,'Value',0);  
        errordlg('Cluster size should be greater than 1');     
    elseif isempty(TR) 
        set(handles.edit28,'BackgroundColor',[0.847,0.161,0]);
        set(hObject,'Value',0);  
        errordlg('Please fill in a valid number for TR in miliseconds');           
     
end

set(hObject,'Value',0);
fclose all
% Hint: get(hObject,'Value') returns toggle state of togglebutton9


% --- Executes on button press in togglebutton10.
function togglebutton10_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% LOAD CONFIG
% First clear everything out
route=mfilename('fullpath');
drawing=[fileparts(route) filesep 'blocks.tif'];
im=imread(drawing,'tif');
axes(handles.axes5);
i=image(im);
set(handles.axes5,'XTick',[]);
set(handles.axes5,'YTick',[]);

% Load default values
axes(handles.axes3); 
cla
set(handles.edit14,'String','');

set(handles.edit15,'String','');
set(handles.edit16,'String','');
set(handles.edit17,'String','');

set(handles.edit17,'UserData',[0]);

set(handles.checkbox3,'Value',1);
set(handles.edit22,'String','1.2');

set(handles.checkbox4,'Value',0);
set(handles.popupmenu4,'Value',1);
set(handles.edit19,'String','');
set(handles.edit20,'String','');
set(handles.edit21,'String','');
   set(handles.edit19 ,'Enable','off');    
   set(handles.edit20 ,'Enable','off');    
   set(handles.edit21 ,'Enable','off'); 
set(handles.text41,'Visible','off');

set(handles.checkbox6,'Value',1);
set(handles.checkbox7,'Value',1);
set(handles.checkbox8,'Value',1);
set(handles.checkbox10,'Value',1);


set(handles.radiobutton7,'Value',0);
set(handles.radiobutton8,'Value',1);
set(handles.edit23,'String','0.05');
set(handles.edit24,'String','4');
set(handles.edit31,'String','128');
set(handles.edit32,'String','0.3');
set(handles.text26,'BackgroundColor',[0.9,0.7,0.7]);
install     =   mfilename('fullpath');
set( handles.edit27,'String','');%[fileparts(install) filesep 'Atlas_SD']);
set(handles.uipanel17,'Visible','off');

set(handles.radiobutton5,'Value',1);
set(handles.radiobutton6,'Value',0);
set(handles.popupmenu3,'Enable','on');
set(handles.togglebutton7,'Enable','off');
set(handles.edit18,'Enable','off');

set(handles.togglebutton6,'Value',0);
set(handles.togglebutton8,'Value',0);
set(handles.togglebutton9,'Value',0);
set(handles.togglebutton10,'Value',0);
set(handles.uipanel20,'UserData',[]);
set(handles.popupmenu5,'Value',1);

% Get config file
sel_dir=deblank(get(handles.edit14,'String'));    
if isdir(sel_dir) cd(sel_dir); end
[file, route]=uigetfile({'*.mat'},'Select a config file');

try
    load(fullfile(route,file));
    parent   =   ancestor(hObject,'figure');
    if all(~isempty(data))
        set(parent,'UserData',data);
        set(handles.text41,'Visible','on');            
        set(handles.text41,'String','OK','BackgroundColor', [0.161,0.847,0]);        
    else
        set(handles.text41,'Visible','on');            
        set(handles.text41,'String','WRONG','BackgroundColor', [0.847,0.161,0]);        
        errordlg(['Data structure retrieved from "Nifti selector" window is not valid. Press "Browse" '...
            'button again for fMRI folder selection and set functional-structural correspondences.']);        
    end
    set(handles.edit14,'String',sel_dir);    
    set(handles.edit15,'String',num2str(Nrest));
    set(handles.edit16,'String',num2str(Nstim)); 
    set(handles.edit17,'String',num2str(NR));
    set(handles.edit30,'String',num2str(skip));    
    set(handles.edit31,'String',num2str(cutoff)); 
    set(handles.edit32,'String',num2str(thr));        
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
    set(handles.uipanel20,'UserData',adv_dat);      
    set(handles.edit28,'String',num2str(TR));        
    set(handles.edit17,'UserData',cast(cast(block_ok,'uint8'),'logical'));
    set(handles.checkbox4,'Value',cast(cast(coreg,'uint8'),'logical'));
    set(handles.edit18,'String',atlas_dir);
    set(handles.radiobutton7,'Value',fwe);    
    set(handles.radiobutton6,'Value',custom_atlas);    
    set(handles.checkbox4,'Value',coreg);      
    set(handles.checkbox11,'Value',preserve);  
    set(handles.edit27,'String',rois_dir);      
    sp=num2str(sp);
    if coreg
            switch sp
                case '1'
                    val=uint8(1);
                    set(handles.popupmenu3,'Value',val);
                case '2' 
                    val=uint8(2);
                    set(handles.popupmenu3,'Value',val);
                otherwise
                    val=uint8(1);
                    set(handles.popupmenu3,'Value',val);
                    errordlg('Species loaded is not valid');
            end
        rr=uint8(custom_resol);
        set(handles.popupmenu4,'Value',rr+1);
        set(handles.text28 ,'Visible','on'); 
        set(handles.uipanel17 ,'Visible','on');   
 
       
       set(handles.text29 ,'Visible','on'); 
       set(handles.text30 ,'Visible','on');    
       set(handles.text31 ,'Visible','on'); 
       set(handles.text32 ,'Visible','on'); 
       set(handles.text33 ,'Visible','on'); 
       set(handles.text34 ,'Visible','on');  
       set(handles.edit19 ,'Visible','on');    
       set(handles.edit20 ,'Visible','on');    
       set(handles.edit21 ,'Visible','on');
       set(handles.edit19 ,'Enable','off');    
       set(handles.edit20 ,'Enable','off');    
       set(handles.edit21 ,'Enable','off');          
        if custom_resol
            set(handles.edit19,'String',num2str(rx));
            set(handles.edit20,'String',num2str(ry));
            set(handles.edit21,'String',num2str(rz));
           set(handles.text29 ,'Enable','on'); 
           set(handles.text30 ,'Enable','on');    
           set(handles.text31 ,'Enable','on');    
           set(handles.text32 ,'Enable','on');           
           set(handles.text33 ,'Enable','on');    
           set(handles.text34 ,'Enable','on');    


        else
           set(handles.text29 ,'Enable','off'); 
           set(handles.text30 ,'Enable','off');    
           set(handles.text31 ,'Enable','off');    
           set(handles.text32 ,'Enable','off');           
           set(handles.text33 ,'Enable','off');    
           set(handles.text34 ,'Enable','off');    
         

        end
             
    else
   set(handles.popupmenu4 ,'Visible','off');          
   set(handles.text28 ,'Visible','off'); 
   set(handles.uipanel17 ,'Visible','off');  
       set(handles.text29 ,'Visible','off'); 
       set(handles.text30 ,'Visible','off');    
       set(handles.text31 ,'Visible','off'); 
       set(handles.text32 ,'Visible','off'); 
       set(handles.text33 ,'Visible','off'); 
       set(handles.text34 ,'Visible','off');  
       set(handles.edit19 ,'Visible','off');    
       set(handles.edit20 ,'Visible','off');    
       set(handles.edit21 ,'Visible','off');                  
    end
    if sm
        set(handles.edit22,'String',num2str(sx)); 
        set(handles.text35 ,'Visible','on');         
        set(handles.text36 ,'Visible','on');          
        set(handles.edit22 ,'Visible','on');
    else
        set(handles.text35 ,'Visible','off');         
        set(handles.text36 ,'Visible','off');          
        set(handles.edit22 ,'Visible','off');        
    end
    set(handles.checkbox3,'Value',cast(cast(sm,'uint8'),'logical'));
    set(handles.radiobutton8,'Value',fwe);
    set(handles.radiobutton7,'Value',~fwe);    
    set(handles.edit23,'String',num2str(p));    
    set(handles.edit24,'String',num2str(k));
    set(handles.popupmenu5,'Value',disp_or);    
    set(handles.checkbox10,'Value',cast(cast(rea,'uint8'),'logical'));
    set(handles.checkbox6,'Value',cast(cast(des,'uint8'),'logical'));
    set(handles.checkbox7,'Value',cast(cast(tim,'uint8'),'logical'));
    set(handles.checkbox8,'Value',cast(cast(dis,'uint8'),'logical'));       

    
    % DRAW blocks..............................
    if ~isempty(NR) && ~isempty(Nrest) && ~isempty(Nstim) && ...
       NR>(Nrest+Nstim) && (mod(NR,(Nrest+Nstim)) == Nrest)
            cycles=(NR-Nrest)/(Nrest+Nstim);
            set(handles.axes3,'Visible','on');
            axes(handles.axes3); 
            xlabel=text(0,0,'Images','Visible','off');
            set(handles.axes3,'XLabel',xlabel);
            y=[];lb=[1];
            for k=1:cycles 
                y=[y zeros(1,Nrest*1000) ones(1,Nstim*1000)]; 
                lb=[lb Nrest+(k-1)*(Nrest+Nstim) (Nrest+Nstim)*k];
            end
            y=[y zeros(1,Nrest*1000)]; lb=[lb NR];base=[1:(NR*1000)];
            plot(handles.axes3,base,y,' .b');
            set(gca,'XTick',lb*1000);
            lb=strread(num2str(lb),'%s');
            set(gca,'XTickLabel',lb');
            xlim(handles.axes3,[1 NR*1000]);
            ylim(handles.axes3,[0 1.25]); 
            set(handles.edit17,'UserData',[1]);
            set(handles.uipanel11,'BackgroundColor',[0.867,0.918,0.976]);
            set(handles.text26,'BackgroundColor',[0.9,0.7,0.7]);
    elseif isstruct(adv_paradigm)
            set(handles.axes3,'Visible','on');
            axes(handles.axes3); 
            xlabel  =   text(0,0,'Images','Visible','off');
            set(handles.axes3,'XLabel',xlabel);
            
            if size(adv_paradigm.duration,1)==1
               duration     =   repmat(adv_paradigm.duration,1,size(adv_paradigm.onsets,2)); 
            end
            y       =   zeros(1,adv_paradigm.NR*1000); 
            for i=1:size(adv_paradigm.onsets,2)
                if (adv_paradigm.onsets(i)+duration(i))*1000 <= (adv_paradigm.NR*1000)
                    y(adv_paradigm.onsets(i)*1000:((adv_paradigm.onsets(i)+duration(i))*1000))=1;
                else
                    y(adv_paradigm.onsets(i)*1000:adv_paradigm.NR*1000)=1;
                end
            end
            base    =   [1:adv_paradigm.NR*1000];
            plot(handles.axes3,base,y,' .b');
            set(gca,'XTick',adv_paradigm.onsets*1000);
            lb=strread(num2str(adv_paradigm.onsets),'%s');
            set(gca,'XTickLabel',lb');
            
            xlim(handles.axes3,[1 adv_paradigm.NR*1000]);
            ylim(handles.axes3,[0 1.25]); 
            set(handles.edit17,'UserData',[1]);
            set(handles.uipanel19,'BackgroundColor',[0.867, 0.918, 0.976]);
            set(handles.text26,'BackgroundColor',[0.9,0.7,0.7]);        
    else
        axes(handles.axes3); 
        cla;
        set(handles.edit17,'UserData',[0]);    
        set(handles.uipanel11,'BackgroundColor',[0.847,0.161,0]);
        set(handles.text26,'BackgroundColor',[0.847,0.161,0]);
    end
    set(hObject,'Value',0);
catch err
    errordlg('Error loading file. Check variables inside.');
    set(hObject,'Value',0);
end

% Hint: get(hObject,'Value') returns toggle state of togglebutton10


% --- Executes on button press in togglebutton6.
function togglebutton6_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

p    =  ancestor(hObject,'figure');
% SELECT DIR button
d   =   deblank(get(handles.edit14,'String'));
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
        set(handles.edit14,'String',sel_dir);
        set(handles.edit14,'UserData',sel_dir);
        set(handles.uipanel12,'BackgroundColor',[0.906,0.906,0.906]);
        [data_struct]=Nifti_selector('dir',sel_dir);
        p   =   ancestor(hObject,'figure');
        set(p,'UserData',data_struct);
        
        if ~any(strcmp(data_struct,'error'))
           set(handles.text41,'Visible','on');            
           set(handles.text41,'String','OK','BackgroundColor', [0.161,0.847,0]);
        else
           set(handles.text41,'Visible','on');            
           set(handles.text41,'String','WRONG','BackgroundColor', [0.847,0.161,0]);
        end       
    else
        set(handles.edit14,'String','Not valid');
        set(handles.uipanel12,'BackgroundColor',[0.847,0.161,0]);   
    end
end
set(hObject,'Value',0);

% guidata(hObject,handles); 


% Hint: get(hObject,'Value') returns toggle state of togglebutton6




function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Directory edit box
in_data = deblank(get(hObject,'String'));
set(handles.uipanel12,'BackgroundColor',[0.867, 0.918, 0.976]);
if isdir(in_data) 
    [path folder e]=fileparts(in_data);
    if isdir(in_data) && ~isempty(folder) 
        set(hObject,'UserData',in_data);
        set(handles.edit14,'String',in_data);
        set(handles.edit14,'UserData',in_data);
        set(handles.uipanel12,'BackgroundColor',[0.906,0.906,0.906]);
        [data_struct]=Nifti_selector('dir',in_data);
        p   =   ancestor(hObject,'figure');
        set(p,'UserData',data_struct);
        
        if ~any(strcmp(data_struct,'error'))
           set(handles.text41,'Visible','on');            
           set(handles.text41,'String','OK','BackgroundColor', [0.161,0.847,0]);
        else
           set(handles.text41,'Visible','on');            
           set(handles.text41,'String','WRONG','BackgroundColor', [0.847,0.161,0]);
        end       
    else
        set(handles.edit14,'String','Not valid');
        set(handles.uipanel12,'BackgroundColor',[0.847,0.161,0]);   
    end 
else
    set(hObject,'String','Not valid');
    set(handles.uipanel12,'BackgroundColor',[0.847,0.161,0]);
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



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Nrest EDIT
NR = str2num(get(handles.edit17,'String'));
Nrest=str2num(get(handles.edit15,'String'));
Nstim=str2num(get(handles.edit16,'String'));
set(handles.edit17,'UserData',[0]);
if ~isempty(NR) && ~isempty(Nrest) && ~isempty(Nstim) && ...
   NR>(Nrest+Nstim) && (mod(NR,(Nrest+Nstim)) == Nrest)
        % draw blocks
        cycles=(NR-Nrest)/(Nrest+Nstim);
        set(handles.axes3,'Visible','on');
        axes(handles.axes3); 
        xlabel=text(0,0,'Images','Visible','off');
        set(handles.axes3,'XLabel',xlabel);
        y=[];lb=[1];
        for k=1:cycles 
            y=[y zeros(1,Nrest*1000) ones(1,Nstim*1000)]; 
            lb=[lb Nrest+(k-1)*(Nrest+Nstim) (Nrest+Nstim)*k];
        end
        y=[y zeros(1,Nrest*1000)]; lb=[lb NR];base=[1:(NR*1000)];
        plot(handles.axes3,base,y,' .b');
        set(gca,'XTick',lb*1000);
        lb=strread(num2str(lb),'%s');
        set(gca,'XTickLabel',lb');
        xlim(handles.axes3,[1 NR*1000]);
        ylim(handles.axes3,[0 1.25]); 
        
        set(handles.edit17,'UserData',[1]);
        set(handles.uipanel19,'BackgroundColor',[0.906,0.906,0.906]);
        set(handles.text26,'BackgroundColor',[0.9,0.7,0.7]);        
else
    axes(handles.axes3); 
    cla;
    set(handles.edit17,'UserData',[0]);    
    set(handles.uipanel19,'BackgroundColor',[0.847,0.161,0]);
    set(handles.text26,'BackgroundColor',[0.847,0.161,0]);    
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



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Nstim EDIT
NR = str2num(get(handles.edit17,'String'));
Nrest=str2num(get(handles.edit15,'String'));
Nstim=str2num(get(handles.edit16,'String'));
set(handles.edit17,'UserData',[0]);
if ~isempty(NR) && ~isempty(Nrest) && ~isempty(Nstim) && ...
   NR>(Nrest+Nstim) && (mod(NR,(Nrest+Nstim)) == Nrest)
        cycles=(NR-Nrest)/(Nrest+Nstim);
        set(handles.axes3,'Visible','on');
        axes(handles.axes3); 
        xlabel=text(0,0,'Images','Visible','off');
        set(handles.axes3,'XLabel',xlabel);
        y=[];lb=[1];
        for k=1:cycles 
            y=[y zeros(1,Nrest*1000) ones(1,Nstim*1000)]; 
            lb=[lb Nrest+(k-1)*(Nrest+Nstim) (Nrest+Nstim)*k];
        end
        y=[y zeros(1,Nrest*1000)]; lb=[lb NR];base=[1:(NR*1000)];
        plot(handles.axes3,base,y,' .b');
        set(gca,'XTick',lb*1000);
        lb=strread(num2str(lb),'%s');
        set(gca,'XTickLabel',lb');
        xlim(handles.axes3,[1 NR*1000]);
        ylim(handles.axes3,[0 1.25]); 
        set(handles.edit17,'UserData',[1]);
        set(handles.uipanel19,'BackgroundColor',[0.906,0.906,0.906]);
        set(handles.text26,'BackgroundColor',[0.9,0.7,0.7]);          
else
    axes(handles.axes3); 
    cla;
    set(handles.edit17,'UserData',[0]);    
    set(handles.uipanel19,'BackgroundColor',[0.847,0.161,0]);
    set(handles.text26,'BackgroundColor',[0.847,0.161,0]);      
end

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% NR EDIT
NR = str2num(get(handles.edit17,'String'));
Nrest=str2num(get(handles.edit15,'String'));
Nstim=str2num(get(handles.edit16,'String'));
set(handles.edit17,'UserData',[0]);
if ~isempty(NR) && ~isempty(Nrest) && ~isempty(Nstim) && ...
   NR>(Nrest+Nstim) && (mod(NR,(Nrest+Nstim)) == Nrest)
        cycles=(NR-Nrest)/(Nrest+Nstim);
        set(handles.axes3,'Visible','on');
        axes(handles.axes3); 
        xlabel=text(0,0,'Images','Visible','off');
        set(handles.axes3,'XLabel',xlabel);
        y=[];lb=[1];
        for k=1:cycles 
            y=[y zeros(1,Nrest*1000) ones(1,Nstim*1000)]; 
            lb=[lb Nrest+(k-1)*(Nrest+Nstim) (Nrest+Nstim)*k];
        end
        y=[y zeros(1,Nrest*1000)]; lb=[lb NR];base=[1:(NR*1000)];
        plot(handles.axes3,base,y,' .b');
        set(gca,'XTick',lb*1000);
        lb=strread(num2str(lb),'%s');
        set(gca,'XTickLabel',lb');
        xlim(handles.axes3,[1 NR*1000]);
        ylim(handles.axes3,[0 1.25]); 
        set(handles.edit17,'UserData',[1]);
        set(handles.uipanel19,'BackgroundColor',[0.906,0.906,0.906]);
        set(handles.text26,'BackgroundColor',[0.9,0.7,0.7]);         
else
    axes(handles.axes3); 
    cla;
    set(handles.edit17,'UserData',[0]);    
    set(handles.uipanel19,'BackgroundColor',[0.847,0.161,0]);
    set(handles.text26,'BackgroundColor',[0.847,0.161,0]);     
end

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'String','');
set(hObject,'UserData','');
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    install     =   mfilename('fullpath');
    if (get(handles.popupmenu3,'Value')==1)
       set( handles.edit27,'String',[fileparts(install) filesep 'Atlas_SD']);
    elseif (get(handles.popupmenu3,'Value')==2)
       set( handles.edit27,'String',[fileparts(install) filesep 'Atlas_Wistar']); 
    end
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

        % Atlas dir
        contents = get(hObject,'String');
        set(handles.uipanel17,'BackgroundColor',[0.867, 0.918, 0.976]);
        if isdir(contents) 
            set(hObject,'String',contents); 
            set( handles.edit27,'String',contents);
        else
            set(hObject,'String','');
            set( handles.edit27,'String','');
            set(handles.uipanel17,'BackgroundColor',[0.847,0.161,0]);
        end
        
        % Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double


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


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% SMOOTH CHECKBOX
val=get(hObject,'Value');
if val==1
   set(handles.edit22 ,'Visible','on'); 
   set(handles.text35 ,'Visible','on');    
   set(handles.text36 ,'Visible','on');        
      
elseif val==0
   set(handles.edit22 ,'Visible','off'); 
   set(handles.text35 ,'Visible','off');    
   set(handles.text36 ,'Visible','off');     


end 


% Hint: get(hObject,'Value') returns toggle state of checkbox3


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% COREG CHECKBOX
val=get(hObject,'Value');
custom  =   get(handles.popupmenu4,'Value');
if val==0
   set(handles.popupmenu4 ,'Visible','off');          
   set(handles.text28 ,'Visible','off'); 
   set(handles.uipanel17 ,'Visible','off');  
       set(handles.text29 ,'Visible','off'); 
       set(handles.text30 ,'Visible','off');    
       set(handles.text31 ,'Visible','off'); 
       set(handles.text32 ,'Visible','off'); 
       set(handles.text33 ,'Visible','off'); 
       set(handles.text34 ,'Visible','off');  
       set(handles.edit19 ,'Visible','off');    
       set(handles.edit20 ,'Visible','off');    
       set(handles.edit21 ,'Visible','off'); 
       set(handles.edit27 ,'String','');        

elseif val==1
    set(handles.popupmenu4 ,'Visible','on');   
    set(handles.text28 ,'Visible','on'); 
   set(handles.uipanel17 ,'Visible','on');      
   
   set(handles.popupmenu4 ,'Value',1);   
      
       set(handles.text29 ,'Visible','on'); 
       set(handles.text30 ,'Visible','on');    
       set(handles.text31 ,'Visible','on'); 
       set(handles.text32 ,'Visible','on'); 
       set(handles.text33 ,'Visible','on'); 
       set(handles.text34 ,'Visible','on');  
       set(handles.edit19 ,'Visible','on');    
       set(handles.edit20 ,'Visible','on');    
       set(handles.edit21 ,'Visible','on');

       if custom==1
           set(handles.edit19 ,'Enable','off');    
           set(handles.edit20 ,'Enable','off');    
           set(handles.edit21 ,'Enable','off'); 
       end
       install     =   mfilename('fullpath');
       handed   =   get(handles.radiobutton5,'Value');
       sp       =   get(handles.popupmenu3,'Value');
       if handed && (sp==1)
           set( handles.edit27,'String',[fileparts(install) filesep 'Atlas_SD']);
       elseif handed && (sp==2)
           set( handles.edit27,'String',[fileparts(install) filesep 'Atlas_Wistar']); 
       else
           atlas_dir    =   deblank(get(handles.edit18,'String'));
           set( handles.edit27,'String',atlas_dir); 
       end         
    

end

% Hint: get(hObject,'Value') returns toggle state of checkbox4



function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% custom resol X
custom_resol =  mod(get(handles.popupmenu4,'Value')+1,2);
coreg =         get(handles.checkbox4,'Value');
rxs =           get(handles.edit19,'String'); 
rys =           get(handles.edit20,'String');
rzs =           get(handles.edit21,'String'); 
if ~isempty(rxs) && ~isempty(rys) && ~isempty(rzs)
        rx   =  str2num(rxs);
        ry   =  str2num(rys);
        rz   =  str2num(rzs); 
    if (coreg && (custom_resol==1) && (isempty(rx)||isempty(ry)||isempty(rz))) 
        set(handles.popupmenu4,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit19,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit20,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit21,'BackgroundColor',[0.847,0.161,0]);
 
            set(hObject,'Value',0);  
            errordlg('Final resolution is not valid');         
    elseif (coreg && (custom_resol==1) && ((rx<=0)||(ry<=0)||(rz<=0))) 
        set(handles.popupmenu4,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit19,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit20,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit21,'BackgroundColor',[0.847,0.161,0]);
            set(hObject,'Value',0);  
            errordlg('Final resolution should be higher than zero'); 
    else
        set(handles.popupmenu4,'BackgroundColor',[0.906,0.906,0.906]);
        set(handles.edit19,'BackgroundColor',[0.906,0.906,0.906]);
        set(handles.edit20,'BackgroundColor',[0.906,0.906,0.906]);
        set(handles.edit21,'BackgroundColor',[0.906,0.906,0.906]);
    end
end
% Hints: get(hObject,'String') returns contents of edit19 as text
%        str2double(get(hObject,'String')) returns contents of edit19 as a double


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



function edit20_Callback(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% custom resol Y
custom_resol =  mod(get(handles.popupmenu4,'Value')+1,2);
coreg =         get(handles.checkbox4,'Value');
rxs =           get(handles.edit19,'String'); 
rys =           get(handles.edit20,'String');
rzs =           get(handles.edit21,'String'); 
if ~isempty(rxs) && ~isempty(rys) && ~isempty(rzs)
        rx   =  str2num(rxs);
        ry   =  str2num(rys);
        rz   =  str2num(rzs); 
    if (coreg && (custom_resol==1) && (isempty(rx)||isempty(ry)||isempty(rz))) 
        set(handles.popupmenu4,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit19,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit20,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit21,'BackgroundColor',[0.847,0.161,0]);
 
            set(hObject,'Value',0);  
            errordlg('Final resolution is not valid');         
    elseif (coreg && (custom_resol==1) && ((rx<=0)||(ry<=0)||(rz<=0))) 
        set(handles.popupmenu4,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit19,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit20,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit21,'BackgroundColor',[0.847,0.161,0]);
            set(hObject,'Value',0);  
            errordlg('Final resolution should be higher than zero'); 
    else
        set(handles.popupmenu4,'BackgroundColor',[0.906,0.906,0.906]);
        set(handles.edit19,'BackgroundColor',[0.906,0.906,0.906]);
        set(handles.edit20,'BackgroundColor',[0.906,0.906,0.906]);
        set(handles.edit21,'BackgroundColor',[0.906,0.906,0.906]);
    end
end

% Hints: get(hObject,'String') returns contents of edit20 as text
%        str2double(get(hObject,'String')) returns contents of edit20 as a double


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



function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% custom resol Z
custom_resol =  mod(get(handles.popupmenu4,'Value')+1,2);
coreg =         get(handles.checkbox4,'Value');
rxs =           get(handles.edit19,'String'); 
rys =           get(handles.edit20,'String');
rzs =           get(handles.edit21,'String'); 
if ~isempty(rxs) && ~isempty(rys) && ~isempty(rzs)
        rx   =  str2num(rxs);
        ry   =  str2num(rys);
        rz   =  str2num(rzs); 
    if (coreg && (custom_resol==1) && (isempty(rx)||isempty(ry)||isempty(rz))) 
        set(handles.popupmenu4,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit19,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit20,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit21,'BackgroundColor',[0.847,0.161,0]);
 
            set(hObject,'Value',0);  
            errordlg('Final resolution is not valid');         
    elseif (coreg && (custom_resol==1) && ((rx<=0)||(ry<=0)||(rz<=0))) 
        set(handles.popupmenu4,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit19,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit20,'BackgroundColor',[0.847,0.161,0]);
        set(handles.edit21,'BackgroundColor',[0.847,0.161,0]);
            set(hObject,'Value',0);  
            errordlg('Final resolution should be higher than zero'); 
    else
        set(handles.popupmenu4,'BackgroundColor',[0.906,0.906,0.906]);
        set(handles.edit19,'BackgroundColor',[0.906,0.906,0.906]);
        set(handles.edit20,'BackgroundColor',[0.906,0.906,0.906]);
        set(handles.edit21,'BackgroundColor',[0.906,0.906,0.906]);
    end
end


% Hints: get(hObject,'String') returns contents of edit21 as text
%        str2double(get(hObject,'String')) returns contents of edit21 as a double


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


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

v = get(hObject,'Value');
if v == 2
   set(handles.edit19,'Visible','on'); 
   set(handles.edit20,'Visible','on');
   set(handles.edit21,'Visible','on');  
   set(handles.edit19,'Enable','on'); 
   set(handles.edit20,'Enable','on');
   set(handles.edit21,'Enable','on');     
   set(handles.text29,'Enable','on');   
   set(handles.text30,'Enable','on');  
   set(handles.text31,'Enable','on');  
   set(handles.text32,'Enable','on');  
   set(handles.text33,'Enable','on');  
   set(handles.text34,'Enable','on');     
else
   set(handles.edit19,'Enable','off'); 
   set(handles.edit20,'Enable','off');
   set(handles.edit21,'Enable','off');     
   set(handles.text29,'Enable','off');   
   set(handles.text30,'Enable','off');  
   set(handles.text31,'Enable','off');  
   set(handles.text32,'Enable','off');  
   set(handles.text33,'Enable','off');  
   set(handles.text34,'Enable','off');         
end
 set(handles.popupmenu4,'BackgroundColor',[1,1,1]);
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4


% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit22_Callback(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
smooth =         get(handles.checkbox3,'Value');
smx =           get(handles.edit22,'String'); 

if ~isempty(smx) 
        sx   =  str2num(smx);
 
    if smooth && (isnan(sx)) 
            set(handles.checkbox3,'BackgroundColor',[0.847,0.161,0]);
            set(handles.edit22,'BackgroundColor',[0.847,0.161,0]);            
            set(hObject,'Value',0);  
            errordlg('Smoothing resolution is not valid');         
    elseif smooth && (sx<=0) 
            set(handles.checkbox3,'BackgroundColor',[0.847,0.161,0]);
            set(handles.edit22,'BackgroundColor',[0.847,0.161,0]);  
            set(hObject,'Value',0);  
            errordlg('Smoothing resolution should be higher than zero'); 
    else



            set(handles.checkbox3,'BackgroundColor',[0.906,0.906,0.906]);

            set(handles.edit22,'BackgroundColor',[0.906,0.906,0.906]);        
    end
end
% Hints: get(hObject,'String') returns contents of edit22 as text
%        str2double(get(hObject,'String')) returns contents of edit22 as a double


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



function edit23_Callback(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
        p =             str2num(get(handles.edit23,'String'));
        if (p<0 || p>1)
            set(handles.edit23,'BackgroundColor',[0.847,0.161,0]);        
        else
            set(handles.edit23,'BackgroundColor',[1,1,1]);
        end
catch
            set(handles.edit23,'BackgroundColor',[0.847,0.161,0]);
            errordlg('Probability threshold p should be 0<p<1'); 
end

% Hints: get(hObject,'String') returns contents of edit23 as text
%        str2double(get(hObject,'String')) returns contents of edit23 as a double


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



function edit24_Callback(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    k =             str2num(get(handles.edit24,'String'));
    if ( k<1 || ((k/fix(k))~=1) )
       set(handles.edit24,'BackgroundColor',[0.847,0.161,0]);   
    else
       set(handles.edit24,'BackgroundColor',[1,1,1]);    
    end
catch
            set(handles.edit24,'BackgroundColor',[0.847,0.161,0]);
            errordlg('Cluster size should be greater than 1'); 
end
% Hints: get(hObject,'String') returns contents of edit24 as text
%        str2double(get(hObject,'String')) returns contents of edit24 as a double


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



function edit25_Callback(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit25 as text
%        str2double(get(hObject,'String')) returns contents of edit25 as a double


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



function edit26_Callback(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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


% --- Executes on key press with focus on edit14 and none of its controls.
function edit14_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

% for manual directory writing
dir=deblank(get(hObject,'String'));
set(hObject,'UserData',dir);
set(hObject,'TooltipString',dir);


% --- Executes during object creation, after setting all properties.
function axes5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
route        =   mfilename('fullpath');
drawing     =   [fileparts(route) filesep 'blocks.tif'];
im          =   imread(drawing,'tif');
axes(hObject);
i           =   image(im);
set(hObject,'XTick',[]);
set(hObject,'YTick',[]);
% Hint: place code in OpeningFcn to populate axes5


% --------------------------------------------------------------------
function uipanel17_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to uipanel17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes when selected object is changed in uipanel17.
function uipanel17_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel17 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
c=struct2cell(handles);
sel='';
for i=1:size(c,1) 
    if isnumeric(c{i}) && (c{i}==hObject)
        u=fieldnames(handles);
        sel=u{i};
    end
end
if strcmp(sel,'radiobutton5')
    set(handles.popupmenu3,'Enable','on');
    set(handles.togglebutton7,'Enable','off');
    set(handles.edit18,'Enable','off');
    set(handles.radiobutton5,'Value',1);
    set(handles.radiobutton6,'Value',0);
    install     =   mfilename('fullpath');
    if (get(handles.popupmenu3,'Value')==1)
       set( handles.edit27,'String',[fileparts(install) filesep 'Atlas_SD']);
    elseif (get(handles.popupmenu3,'Value')==2)
       set( handles.edit27,'String',[fileparts(install) filesep 'Atlas_Wistar']); 
    end     
elseif strcmp(sel,'radiobutton6')
    set(handles.popupmenu3,'Enable','off');
    set(handles.togglebutton7,'Enable','on');
    set(handles.edit18,'Enable','on'); 
    set(handles.radiobutton6,'Value',1);
    set(handles.radiobutton5,'Value',0);   
    if ~isempty(get(handles.edit18,'String'))
       set( handles.edit27,'String',get(handles.edit18,'String'));
    else
       set( handles.edit27,'String',''); 
    end        
 
elseif strcmp(sel,'togglebutton7')
        % Browse button
        d=deblank(get(handles.edit14,'String'));
        sel_dir = uigetdir(d,'Please select your atlas directory:');
        if sel_dir ~=0 
            [path folder e]=fileparts(sel_dir);
            if isdir(sel_dir) && ~isempty(folder) 
                set(hObject,'UserData',sel_dir);
                set(handles.edit18,'String',sel_dir);
                set(handles.edit18,'UserData',sel_dir);
                set(handles.edit27,'String',sel_dir);                  
                set(handles.radiobutton6,'Value',1);                
                set(handles.uipanel17,'BackgroundColor',[0.867, 0.918, 0.976]);
            else
                set(handles.radiobutton6,'Value',1);                 
                set(handles.edit18,'String','Not valid');
                set(handles.uipanel17,'BackgroundColor',[0.847,0.161,0]);   
            end
        end
        set(hObject,'Value',0);
    
end

    


% --- Executes when selected object is changed in uipanel18.
function uipanel18_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel18 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

c=struct2cell(handles);
sel='';
for i=1:size(c,1) 
    if isnumeric(c{i}) && (c{i}==hObject)
        u=fieldnames(handles);
        sel=u{i};
    end
end
if strcmp(sel,'radiobutton7')
    set(handles.radiobutton7,'Value',1);
    set(handles.radiobutton8,'Value',0);
    

elseif strcmp(sel,'radiobutton8')
    set(handles.radiobutton8,'Value',1);
    set(handles.radiobutton7,'Value',0);

end


% --- Executes during object creation, after setting all properties.
function uipanel18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox6


% --- Executes on button press in checkbox7.
function checkbox7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox7


% --- Executes on button press in checkbox8.
function checkbox8_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val     =   get(hObject,'Value');
if val
    set(handles.edit27,'Enable','On');
    set(handles.pushbutton2,'Enable','On');    
    set(handles.edit23,'Enable','On');
    set(handles.edit24,'Enable','On');    
    set(handles.radiobutton7,'Enable','On');    
    set(handles.radiobutton8,'Enable','On');        
else 
    set(handles.edit27,'Enable','Off');    
    set(handles.pushbutton2,'Enable','Off');  
    set(handles.edit23,'Enable','Off');
    set(handles.edit24,'Enable','Off');    
    set(handles.radiobutton7,'Enable','Off');    
    set(handles.radiobutton8,'Enable','Off');          
end
% Hint: get(hObject,'Value') returns toggle state of checkbox8


% --- Executes on button press in checkbox9.
function checkbox9_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox9


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



function edit27_Callback(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
        % ROIs dir
        in_data = get(hObject,'String');
        if isdir(in_data) 
            set(hObject,'String',in_data); 
        else
            set(hObject,'String','');
        end
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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
        % Browse button
        d=deblank(get(handles.edit14,'String'));
        sel_dir = uigetdir(d,'Please select your ROIs directory:');
        if sel_dir ~=0 
           [route folder e]=fileparts(sel_dir);
            if isdir(sel_dir) && ~isempty(folder) 
                set(handles.edit27,'String',sel_dir);
                set(handles.edit27,'UserData',sel_dir);
            else
                set(handles.edit27,'String','Not valid');
            end
        end



function edit28_Callback(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(str2num(get(hObject,'String')))
    set(handles.edit28,'BackgroundColor',[1,1,1]); 
else
    set(handles.edit28,'BackgroundColor',[0.847,0.161,0]); 
    set(handles.edit28,'String','');   
end
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


% --------------------------------------------------------------------
function Print_Callback(hObject, eventdata, handles)
% hObject    handle to Print (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printpreview
printdlg


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prev        =   get(handles.uipanel20,'UserData');
if (isfield(prev,'paradigm')) && isstruct(prev.paradigm)
    pdgm    =   prev.paradigm;
    pdgm    =   Paradigm(pdgm.NR,pdgm.onsets, pdgm.duration);
else
    pdgm    =   Paradigm;
end

if isstruct(pdgm)
             %pass the data
            prev.paradigm    =  pdgm;
            set(handles.uipanel20,'UserData',prev);
            set(handles.edit17,'String',pdgm.NR);            
            set(handles.edit17,'UserData',1); %block_ok=1
    
            % DRAW
            set(handles.axes3,'Visible','on');
            axes(handles.axes3); 
            xlabel  =   text(0,0,'Images','Visible','off');
            set(handles.axes3,'XLabel',xlabel);
            
            if size(pdgm.duration,1)==1
               duration     =   repmat(pdgm.duration,1,size(pdgm.onsets,2)); 
            end
            y       =   zeros(1,pdgm.NR*1000); 
            for i=1:size(pdgm.onsets,2)
                if (pdgm.onsets(i)+duration(i))*1000 <= (pdgm.NR*1000)
                    y(pdgm.onsets(i)*1000:((pdgm.onsets(i)+duration(i))*1000))=1;
                else
                    y(pdgm.onsets(i)*1000:pdgm.NR*1000)=1;
                end
            end
            base    =   [1:pdgm.NR*1000];
            plot(handles.axes3,base,y,' .b');
            set(gca,'XTick',pdgm.onsets*1000);
            lb=strread(num2str(pdgm.onsets),'%s');
            set(gca,'XTickLabel',lb');
            
            xlim(handles.axes3,[1 pdgm.NR*1000]);
            ylim(handles.axes3,[0 1.25]); 
            set(handles.edit17,'UserData',[1]);
            set(handles.uipanel19,'BackgroundColor',[0.867, 0.918, 0.976]);
            set(handles.text26,'BackgroundColor',[0.9,0.7,0.7]);
            set(handles.edit15,'String','');
            set(handles.edit16,'String','');               
elseif isstruct(prev) && isfield(prev,'paradigm')
            prev            =   rmfield(prev,'paradigm');    
            set(handles.edit17,'UserData',[0]);
            set(handles.axes3,'Visible','on');

end
set(handles.uipanel20,'UserData',prev);

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prev        =   get(handles.uipanel20,'UserData');
NR          =   str2num(get(handles.edit17,'String'));
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
    set(handles.uipanel20,'UserData',prev);      
  
else
    errordlg(['You cannot enter the covariates before defining NR. '...
        'Please enter NR in the corresponding edit box or enter an advanced paradigm through "Advanced" button']);
end



function edit29_Callback(hObject, eventdata, handles)
% hObject    handle to edit29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prev                =   get(handles.uipanel20,'UserData');
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
set(handles.uipanel20,'UserData',prev); 



function edit31_Callback(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cutoff        =   get(handles.edit31,'String'); 
if ~isempty(cutoff) 
        cutoff   =  str2num(cutoff);
    if ~isscalar(cutoff)
            set(handles.edit31,'BackgroundColor',[0.847,0.161,0]);
            set(hObject,'Value',0);  
            errordlg('Cutoff is not a valid number');         
    elseif (cutoff<0) 
            set(handles.edit31,'BackgroundColor',[0.847,0.161,0]);
            set(hObject,'Value',0);  
            errordlg('Cutoff must be >=0');
    else
            set(handles.edit31,'BackgroundColor',[1,1,1]);
    end
else
    set(handles.edit31,'BackgroundColor',[0.847,0.161,0]);
    errordlg(['Cutoff must be a number >=0. It is the cutoff period in seconds' ...
    'for the high pass filter. All signals with a period higher than this will be filtered out.']);
end
% Hints: get(hObject,'String') returns contents of edit31 as text
%        str2double(get(hObject,'String')) returns contents of edit31 as a double


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



function edit30_Callback(hObject, eventdata, handles)
% hObject    handle to edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
skip        =   get(handles.edit30,'String'); 
rep         =   get(handles.edit17,'String'); 

if ~isempty(skip) && ~isempty(str2num(skip)) && ~isempty(str2num(rep))
        sk   =  str2num(skip);
        NR   =  str2num(rep);
    if ~isscalar(sk)
            set(handles.edit30,'BackgroundColor',[0.847,0.161,0]);
            set(hObject,'Value',0);  
            errordlg('Skipped volumes are not a valid number');         
    elseif (sk<0) || (sk> (NR-3))
            set(handles.edit30,'BackgroundColor',[0.847,0.161,0]);
            set(hObject,'Value',0);  
            errordlg('Skipped volumes must be >=0 and <=(NR-3)');
    else
            set(handles.edit30,'BackgroundColor',[1,1,1]);
    end
else
    set(handles.edit30,'BackgroundColor',[0.847,0.161,0]);    
    set(handles.edit30,'String','0'); 
    errordlg('Skipped volumes must be a number >=0 and <=(NR-3). Fill this field after you have defined NR.');
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


% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu5


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



function edit32_Callback(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
thr        =   get(handles.edit32,'String'); 


if ~isempty(thr) 
        thr   =  str2num(thr);
    if ~isscalar(thr)
            set(handles.edit32,'BackgroundColor',[0.847,0.161,0]);
            set(hObject,'Value',0);  
            errordlg('Threshold is not a valid number');         
    elseif (thr<0) 
            set(handles.edit32,'BackgroundColor',[0.847,0.161,0]);
            set(hObject,'Value',0);  
            errordlg('Threshold must be between 0 and 1.');
    else
            set(handles.edit32,'BackgroundColor',[1,1,1]);
    end
else
    set(handles.edit32,'BackgroundColor',[0.847,0.161,0]);
    errordlg(['Threshold must be between 0 and 1. It''s the GLM implicit intensity threshold. Only voxels with' ...
        ' intensity onver threshold will be included in the GLM fitting. Check mask.nii output.']);
end
% Hints: get(hObject,'String') returns contents of edit32 as text
%        str2double(get(hObject,'String')) returns contents of edit32 as a double


% --- Executes during object creation, after setting all properties.
function edit32_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


