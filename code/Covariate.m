function varargout = Covariate(varargin)
% COVARIATE M-file for Covariate.fig
%      COVARIATE, by itself, creates a new COVARIATE or raises the existing
%      singleton*.
%
%      H = COVARIATE returns the handle to a new COVARIATE or the handle to
%      the existing singleton*.
%
%      COVARIATE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COVARIATE.M with the given input arguments.
%
%      COVARIATE('Property','Value',...) creates a new COVARIATE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Covariate_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Covariate_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Covariate

% Last Modified by GUIDE v2.5 15-Jan-2015 18:16:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Covariate_OpeningFcn, ...
                   'gui_OutputFcn',  @Covariate_OutputFcn, ...
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


% --- Executes just before Covariate is made visible.
function Covariate_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Covariate (see VARARGIN)

% Choose default command line output for Covariate
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

if ~isempty(varargin)
    if ~isempty(varargin{1})
        covariates  =   varargin{1};
        p        =   ancestor(hObject,'figure');
        set(p,'UserData', covariates); 
        set(handles.text1,'String',num2str(covariates));
        set(handles.text1,'UserData',covariates);        
    end
    if ~isempty(varargin{2})
        NR  =   varargin{2};
        set(handles.edit1,'UserData',NR);
    end

end



% UIWAIT makes Covariate wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function dout = Covariate_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
covariates     =   get(hObject,'UserData');
if ~isempty(covariates)
    dout = covariates;
else
    covariates = {'error'};
end
fclose all
delete(hObject);



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
input    =   str2num(get(handles.edit1,'String'));

if isempty(input) % file enter
    file        =   get(handles.edit1,'String');
    fid         =   fopen(file,'r');
    if fid>0
        set(handles.edit1,'String',file);
        dat     =  importdata(file);
        set(handles.text1,'String',num2str(dat));   
        set(handles.text1,'UserData',dat);          
    else
        errordlg('Unable to open that file, check permissions');
    end
elseif isscalar(input)  %numerical enter
        errordlg('A matrix is expected, not scalar values');    
else
        dat      =  input;
        set(handles.text1,'String',num2str(dat));   
        set(handles.text1,'UserData',dat);          
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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
d               =   get(handles.edit1,'String');
if isempty(d)
    if isunix 
        %d='/opt/PV5.0/data/nmrsu/nmr/'; 
        d       =   '/media/fMRI_Rata/'; 
    end
    if ispc 
        d       =   'W:\Proyectos\fMRI\FMRI_RATA\'; 
    end
end
cd(fileparts(d));
[fname route]   =   uigetfile('*.txt','Please select your text file with the covariables:');
file            =   fullfile(route,fname);
if fname ~=0 
    fid         =   fopen(file,'r');
    if fid>0
        set(handles.edit1,'String',file);
        dat     =  importdata(file);
        set(handles.text1,'String',num2str(dat));   
        set(handles.text1,'UserData',dat);          
    else
        errordlg('Unable to open that file, check permissions');
    end
end
set(hObject,'Value',0);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
        set(handles.text1,'String','');
        set(handles.text1,'UserData',[]);        
        set(handles.edit1,'String','');
        p           =       ancestor(hObject,'figure');
        set(p,'UserData', 0);    
        figure1_CloseRequestFcn(p, eventdata, handles);        
        
        
% --- Executes when user attempts to close figure1.
function varargout=figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end

% --- Executes when user attempts to close figure1.
function varargout=figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end        


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    ok=1;
    NR      =   get(handles.edit1,'UserData');
    covariates      =   get(handles.text1,'UserData');
    if isempty(covariates)
        errordlg('empty matrix');
        ok=0;
    elseif ~any(size(covariates)==NR)
        errordlg('none of the matrix dimensions equals NR (total temporal length)');
        ok=0;    

    elseif size(covariates,1)~=NR
            covariates   =   covariates'; 
    else
        p           =       ancestor(hObject,'figure');
        set(p,'UserData', covariates);    
        figure1_CloseRequestFcn(p, eventdata, handles);
    end
