function varargout = fMRat(varargin)
% FMRAT M-file for fMRat.fig
%      FMRAT, by itself, creates a new FMRAT or raises the existing
%      singleton*.
%
%      H = FMRAT returns the handle to a new FMRAT or the handle to
%      the existing singleton*.
%
%      FMRAT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FMRAT.M with the given input arguments.
%
%      FMRAT('Property','Value',...) creates a new FMRAT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fMRat_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fMRat_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help fMRat

% Last Modified by GUIDE v2.5 05-May-2011 18:01:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fMRat_OpeningFcn, ...
                   'gui_OutputFcn',  @fMRat_OutputFcn, ...
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


% --- Executes just before fMRat is made visible.
function fMRat_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fMRat (see VARARGIN)
spmpath     =   fileparts(which('spm.m')); 
 if isempty(spmpath) 
     errordlg('Add the Spm installation directory to your Matlab path'); 
     close(hObject);
 end
 return
% Choose default command line output for fMRat
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes fMRat wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function fMRat_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure



% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fmri_gui;
delete(handles.figure1);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fmri_nifti_gui;
delete(handles.figure1);

