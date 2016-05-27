function varargout = User_hrf(varargin)
% USER_HRF MATLAB code for User_hrf.fig
%      USER_HRF, by itself, creates a new USER_HRF or raises the existing
%      singleton*.
%
%      H = USER_HRF returns the handle to a new USER_HRF or the handle to
%      the existing singleton*.
%
%      USER_HRF('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in USER_HRF.M with the given input arguments.
%
%      USER_HRF('Property','Value',...) creates a new USER_HRF or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before User_hrf_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to User_hrf_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help User_hrf

% Last Modified by GUIDE v2.5 23-May-2016 14:45:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @User_hrf_OpeningFcn, ...
                   'gui_OutputFcn',  @User_hrf_OutputFcn, ...
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


% --- Executes just before User_hrf is made visible.
function User_hrf_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to User_hrf (see VARARGIN)

% Choose default command line output for User_hrf
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
if ~isempty(get(hObject,'Userdata')) || (~isempty(varargin) && ~isempty(varargin{1}) && ~isempty(varargin{2}))
    if ~isempty(varargin{1}) && ~isempty(varargin{2})
        uhrf        =   varargin{1};
        t_max       =   varargin{2};
    elseif ~isempty(get(hObject,'Userdata'))
        info        =   get(hObject,'Userdata');
        uhrf        =   info.uhrf;
        t_max       =   info.t_max;
    end
        p           =   ancestor(hObject,'figure');
        set(p,'UserData', struct('user_hrf',uhrf,'t_max',t_max)); 
        set(handles.edit1,'String', num2str(uhrf));
        set(handles.edit2,'String', num2str(t_max));
        
            % DRAW    
            set(handles.axes1,'Visible','on');
            axes(handles.axes1); 
%             xlabel  =   text(0,0,'Images','Visible','off');
%             set(handles.axes1,'XLabel',xlabel);
            x       =   linspace(0,t_max,length(uhrf));
            y       =   uhrf; 
            plot(handles.axes1,x,y,' -b');
            ylim(handles.axes1,[0 max(uhrf(:))*1.2]);
else
        set(handles.edit1,'String','');
        set(handles.edit2,'String','5')
        axes(handles.axes1); 
        cla;    
        p           =   ancestor(hObject,'figure');
        set(p,'UserData', struct('user_hrf',[],'t_max',[]));         

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
function dout = User_hrf_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
info     =   get(hObject,'UserData');
if ~isempty(info)
    dout = info;
else
    dout = {'error'};
end
delete(hObject);



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    uhrf    =   str2num(get(handles.edit1,'String'));
    t_max       =   str2num(get(handles.edit2,'String'));
if ~isempty(uhrf) && isnumeric(uhrf) && ~isempty(t_max) && isnumeric(t_max) && isscalar(t_max) && t_max>0
            % DRAW    
            set(handles.axes1,'Visible','on');
            axes(handles.axes1); 
%             xlabel  =   text(0,0,'Images','Visible','off');
%             set(handles.axes1,'XLabel',xlabel);
%             x       =   [1:length(uhrf)];
            x       =   linspace(0,t_max,length(uhrf));
            y       =   uhrf; 
            plot(handles.axes1,x,y,' -b');
            ylim(handles.axes1,[0 max(uhrf(:))*1.2]);     
else 
        set(handles.edit1,'String','');
        set(handles.edit2,'String','5')
        axes(handles.axes1); 
        cla;    
        p           =   ancestor(hObject,'figure');
        set(p,'UserData', struct('user_hrf',[],'t_max',[]));      
        errordlg('user_hrf not convertible to numbers or wrong maximum time definition');
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
    ok=1;
    uhrf    =   str2num(get(handles.edit1,'String'));
    t_max       =   str2num(get(handles.edit2,'String'));  
    if isempty(uhrf) || ~isnumeric(uhrf) || isempty(t_max) || ~isnumeric(t_max) || ~isscalar(t_max) || t_max<=0
        set(handles.edit1,'String','');
        set(handles.edit2,'String','5')
        axes(handles.axes1); 
        cla;    
        p           =   ancestor(hObject,'figure');
        set(p,'UserData', struct('user_hrf',[],'t_max',[]));          
        errordlg('user_hrf not convertible to numbers or wrong maximum time definition');
        ok=0;
    end
    if ok
        p           =       ancestor(hObject,'figure');
        set(p,'UserData', struct('user_hrf',uhrf,'t_max',t_max));    
        figure1_CloseRequestFcn(p, eventdata, handles);
    end
    
    

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
        set(handles.edit1,'String','');
        set(handles.edit2,'String','5')
        axes(handles.axes1); 
        cla;
        p           =       ancestor(hObject,'figure');
        set(p,'UserData', 0);    
        figure1_CloseRequestFcn(p, eventdata, handles);



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    uhrf        =   str2num(get(handles.edit1,'String'));
    t_max       =   str2num(get(handles.edit2,'String'));
if ~isempty(uhrf) && isnumeric(uhrf) && ~isempty(t_max) && isnumeric(t_max) && isscalar(t_max) && t_max>0
            % DRAW    
            set(handles.axes1,'Visible','on');
            axes(handles.axes1); 
%             xlabel  =   text(0,0,'Images','Visible','off');
%             set(handles.axes1,'XLabel',xlabel);
%             x       =   [1:length(uhrf)];
            x       =   linspace(0,t_max,length(uhrf));
            y       =   uhrf; 
            plot(handles.axes1,x,y,' -b');
            ylim(handles.axes1,[0 max(uhrf(:))*1.2]);     
else 
        set(handles.edit1,'String','');
        set(handles.edit2,'String','5')
        axes(handles.axes1); 
        cla;    
        p           =   ancestor(hObject,'figure');
        set(p,'UserData', struct('user_hrf',[],'t_max',[]));      
        errordlg('user_hrf not convertible to numbers or wrong maximum time definition');
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
