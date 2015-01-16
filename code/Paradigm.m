function varargout = Paradigm(varargin)
% PARADIGM M-file for Paradigm.fig
%      PARADIGM, by itself, creates a new PARADIGM or raises the existing
%      singleton*.
%
%      H = PARADIGM returns the handle to a new PARADIGM or the handle to
%      the existing singleton*.
%
%      PARADIGM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PARADIGM.M with the given input arguments.
%
%      PARADIGM('Property','Value',...) creates a new PARADIGM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Paradigm_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Paradigm_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Paradigm

% Last Modified by GUIDE v2.5 15-Jan-2015 12:07:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Paradigm_OpeningFcn, ...
                   'gui_OutputFcn',  @Paradigm_OutputFcn, ...
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


% --- Executes just before Paradigm is made visible.
function Paradigm_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Paradigm (see VARARGIN)

% Choose default command line output for Paradigm
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

if ~isempty(varargin)
    if ~isempty(varargin{1})
        NR  =   varargin{1};
    end
    if ~isempty(varargin{2})
        onsets  =   varargin{2};
    end
    if ~isempty(varargin{3})
        duration  =   varargin{3};
    end
    paradigm    =   struct('NR', NR, 'onsets',onsets,'duration',duration);
    p           =   ancestor(hObject,'figure');
    set(p,'UserData', paradigm); 
    set(handles.edit1,'String', num2str(onsets)); 
    set(handles.edit2,'String', num2str(duration)); 
    set(handles.edit3,'String', num2str(NR)); 
end
    
% UIWAIT makes Paradigm wait for user response (see UIRESUME)
uiwait(handles.figure1);


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

% --- Outputs from this function are returned to the command line.
function dout = Paradigm_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
paradigm     =   get(hObject,'UserData');
if ~isempty(paradigm)
    dout = paradigm;
else
    dout = {'error'};
end
delete(hObject);



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    ok=1;
    NR  =   str2num(get(handles.edit3,'String'));
    onsets  =   str2num(get(handles.edit1,'String'));
    duration  =   str2num(get(handles.edit2,'String'));    
    if isempty(NR)
        errordlg('NR not convertible to numbers');
        ok=0;
    elseif isempty(onsets) || max(onsets)>NR
        errordlg('onsets not convertible to numbers or bigger than NR');
        ok=0;
    elseif isempty(duration) || (max(onsets)+duration(end))>NR
        errordlg('durations not convertible to numbers or last exceeds NR');
        ok=0;
    end
    
    paradigm    =   struct('NR',NR,'onsets', onsets, 'duration',duration);

    if ok
        p           =       ancestor(hObject,'figure');
        set(p,'UserData', paradigm);    
        figure1_CloseRequestFcn(p, eventdata, handles);
    end
    
    
    
    



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
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
        p           =       ancestor(hObject,'figure');
        set(p,'UserData', 0);    
        figure1_CloseRequestFcn(p, eventdata, handles);
