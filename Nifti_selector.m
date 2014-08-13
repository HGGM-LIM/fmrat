function varargout = Nifti_selector(varargin)
% NIFTI_SELECTOR M-file for Nifti_selector.fig
%      NIFTI_SELECTOR, by itself, creates a new NIFTI_SELECTOR or raises the existing
%      singleton*.
%
%      H = NIFTI_SELECTOR returns the handle to a new NIFTI_SELECTOR or the handle to
%      the existing singleton*.
%
%      NIFTI_SELECTOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NIFTI_SELECTOR.M with the given input arguments.
%
%      NIFTI_SELECTOR('Property','Value',...) creates a new NIFTI_SELECTOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Nifti_selector_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Nifti_selector_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Nifti_selector

% Last Modified by GUIDE v2.5 03-Jul-2013 11:19:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Nifti_selector_OpeningFcn, ...
                   'gui_OutputFcn',  @Nifti_selector_OutputFcn, ...
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


% --- Executes just before Nifti_selector is made visible.
function Nifti_selector_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Nifti_selector (see VARARGIN)

if nargin == 3,
    initial_dir = pwd;
elseif nargin > 4
    if strcmpi(varargin{1},'dir')
        if exist(varargin{2},'dir')
            initial_dir = varargin{2};
        else
            errordlg('Input argument must be a valid directory','Input Argument Error!')
            return
        end
    else
        errordlg('Unrecognized input argument','Input Argument Error!');
        return;
    end
end

%Set initial unit
[str remain]=strtok(initial_dir,':');
str=[str(1) ':'];
unit_list = get(handles.popupmenu1,'String'); 
val=find(strncmpi(str,cellstr(unit_list),2));
set(handles.popupmenu1,'Value',val);

% Populate the im_listbox
handles=load_im_list(initial_dir,handles);
set(handles.listbox2,'String',handles.file_names,...
	'Value',1,'UserData',initial_dir);
set(handles.text7,'String',pwd);
% Set output data structure

% Choose default command line output for Nifti_selector
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Nifti_selector wait for user response (see UIRESUME)
uiwait(handles.figure1);


% ------------------------------------------------------------
% Read the current directory and sort the names
% ------------------------------------------------------------
function handles=load_im_list(dir_path,handles)
cd (dir_path)
dir_struct = dir;
[sorted_names,sorted_index] = sortrows({dir_struct.name}');
handles.file_names = sorted_names;
handles.is_dir = [dir_struct.isdir];
handles.sorted_index = sorted_index;
guidata(handles.figure1,handles);


% --- Outputs from this function are returned to the command line.
function varargout = Nifti_selector_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure


    data_struct     =   get(hObject,'UserData');
if ~isempty(data_struct)
    varargout{1} = data_struct;
else
    varargout{1} = {'error'};
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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in im_listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to im_listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
get(handles.figure1,'SelectionType');
if strcmp(get(handles.figure1,'SelectionType'),'open')
    index_selected = get(handles.listbox2,'Value');
    file_im_list = get(handles.listbox2,'String');
    filename = file_im_list{index_selected};
    if  isdir(filename)
        handles.is_dir=1;
        cd (filename)
        handles=load_im_list(pwd,handles);
        set(handles.listbox2,'String',handles.file_names,...
            'Value',1);
        set(handles.text7,'String',pwd);        
    end
end


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox3.
function listbox3_Callback(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox3


% --- Executes during object creation, after setting all properties.
function listbox3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% ADD FUNCTIONAL IMAGE SELECTED
idx=get(handles.listbox2,'Value');
file_im_list = get(handles.listbox2,'String');
main_path=get(handles.text7,'String');
mp=repmat(main_path,size(idx,2),1);
sp=repmat(filesep,size(idx,2),1);
filename = strcat(mp,sp,char(file_im_list{idx,:}));
for p=1:size(filename,1)
        if size(filename,1) == 1 
            [path nam ext]=fileparts(filename);
        else
            [path nam ext]=fileparts(filename(p,:));
        end 
    if strcmp(deblank(ext),'.nii')
        im_list=get(handles.listbox3,'String');
        if  size(filename,1) == 1 
        im_list=strvcat(im_list,filename);
        else
         im_list=strvcat(im_list,filename(p,:));
        end
    else
        errordlg('Selection is not a single-file Nifti formatted image');
    end
    set(handles.listbox3,'String',im_list,'Value',size(im_list,1),'HorizontalAlignment','right');
end
set(handles.text11,'String',num2str(size(im_list,1)));
guidata(hObject, handles); 

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
idx=get(handles.listbox2,'Value');
file_im_list = get(handles.listbox2,'String');
main_path=get(handles.text7,'String');
mp=repmat(main_path,size(idx,2),1);
sp=repmat(filesep,size(idx,2),1);
filename = strcat(mp,sp,char(file_im_list{idx,:}));
for p=1:size(filename,1)
        if size(filename,1) == 1 
            [path nam ext]=fileparts(filename);
        else
            [path nam ext]=fileparts(filename(p,:));
        end 
    if strcmp(deblank(ext),'.nii')
        im_list=get(handles.listbox4,'String');
        if  size(filename,1) == 1 
        im_list=strvcat(im_list,filename);
        else
         im_list=strvcat(im_list,filename(p,:));
        end
    else
        errordlg('Selection is not a single-file Nifti formatted image');
    end
        set(handles.listbox4,'String',im_list,'Value',size(im_list,1),'HorizontalAlignment','right');
end
set(handles.text12,'String',num2str(size(im_list,1)));
guidata(hObject, handles);    

% --- Executes on selection change in listbox4.
function listbox4_Callback(hObject, eventdata, handles)
% hObject    handle to listbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox4


% --- Executes during object creation, after setting all properties.
function listbox4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox5.
function listbox5_Callback(hObject, eventdata, handles)
% hObject    handle to listbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox5


% --- Executes during object creation, after setting all properties.
function listbox5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
idx=get(handles.listbox2,'Value');
file_im_list = get(handles.listbox2,'String');
main_path=get(handles.text7,'String');
mp=repmat(main_path,size(idx,2),1);
sp=repmat(filesep,size(idx,2),1);
filename = strcat(mp,sp,char(file_im_list{idx,:}));
for p=1:size(filename,1)
        if size(filename,1) == 1 
            [path nam ext]=fileparts(filename);
        else
            [path nam ext]=fileparts(filename(p,:));
        end 
    if strcmp(deblank(ext),'.nii')
        im_list=get(handles.listbox5,'String');
        if  size(filename,1) == 1 
        im_list=strvcat(im_list,filename);
        else
         im_list=strvcat(im_list,filename(p,:));
        end
    else
        errordlg('Selection is not a single-file Nifti formatted image');
    end
        set(handles.listbox5,'String',im_list,'Value',size(im_list,1),'HorizontalAlignment','right');
end
set(handles.text13,'String',num2str(size(im_list,1)));
guidata(hObject, handles);    

function [ok,handles] = check_im_lists(hObject, handles)
f_list=get(handles.listbox3,'String');
a_list=cellstr(get(handles.listbox4,'String'));
m_list=cellstr(get(handles.listbox5,'String'));

if size(f_list,1)==size(a_list,1) && size(a_list,1)==size(m_list,1)
    ok=true;

%     try
        
% BUILDS A STRUCTURE WITH STUDIES-ACQ-FILES (WITH REPEATED REF AND MASK IMAGES)        
%         files       =   struct();
%         studies     =   '';
%         last_study  =   '';
%         last_k      =   0;
%         last_acq     =   '';
%         for k=1:size(f_list,1)
%             [path study ext]    =   fileparts(fileparts(fileparts(f_list(k,:))));
%             [route acq ext]     =   fileparts(fileparts(f_list(k,:))); 
%             if strcmp(last_acq,acq) 
%                 eval(['files.study' study '.' acq '.p_func=horzcat(files.study' study '.' acq '.p_func, cellstr(f_list(k,:)))']);
%                 eval(['files.study' study '.' acq '.p_ref=horzcat(files.study' study '.' acq '.p_ref, a_list(k,:))']);                
%                 eval(['files.study' study '.' acq '.mask=horzcat(files.study' study '.' acq '.mask, m_list(k,:))']);                
%                 last_k  =   k;
%                 last_study  =   study;
%                 last_acq    =   acq;  
%             else
%                 eval(['files.study' deblank(study) '.' acq '=struct(''p_func'','''','...
%                     '''p_ref'','''',''mask'','''')']);
%                 eval(['files.study' deblank(study) '.' acq '.p_func=cellstr(f_list(last_k+1:k,:))''']);
%                 eval(['files.study' deblank(study) '.' acq '.p_ref=(a_list(last_k+1:k,:))''']);                
%                 eval(['files.study' deblank(study) '.' acq '.mask=(m_list(last_k+1:k,:))''']);                   
%                 studies     =   strvcat(studies,study);
%                 last_k  =   k;
%                 last_study  =   study;
%                 last_acq    =   acq; 
%             end
%             
%         end
% 
%     catch 
%         errordlg('Unable to build output data structure');
%     end



    try
        files       =   struct();
        studies     =   '';
        last_study  =   '';
        last_k      =   0;
        last_acq     =   '';
        for k=1:size(f_list,1)
            fname   =   regexprep(f_list(k,:),'[\. ]','_');
            [path study ext]    =   (fileparts(fileparts(fname)));
            [route acq ext]     =   (fileparts(f_list(k,:))); 
            if strcmp(last_study,study) 
                eval(['files.study' study '.p_func=vertcat(files.study' study '.p_func, cellstr(f_list(k,:)))']);
                eval(['files.study' study '.p_ref=vertcat(files.study' study '.p_ref, a_list(k,:))']);                
                eval(['files.study' study '.mask=vertcat(files.study' study '.mask, m_list(k,:))']);                
                last_k  =   k;
                last_study  =   study;
            else
                eval(['files.study' deblank(study) '=struct(''p_func'','''','...
                    '''p_ref'','''',''mask'','''')']);
                eval(['files.study' deblank(study) '.p_func=cellstr(f_list(last_k+1:k,:))''']);
                eval(['files.study' deblank(study) '.p_ref=(a_list(last_k+1:k,:))''']);                
                eval(['files.study' deblank(study) '.mask=(m_list(last_k+1:k,:))''']);                   
                studies     =   strvcat(studies,study);
                last_k  =   k;
                last_study  =   study;
            end
            
        end

    catch 
        errordlg('Unable to build output data structure');
    end

    user_struct      =  {studies,files};
    p   =   ancestor(hObject,'figure');
    set(p,'UserData',user_struct);
%     handles.studies=studies;
%     handles.data=files;
%     guidata(hObject, handles);        

else ok=false; end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
im_list=get(handles.listbox3,'String');
idx=get(handles.listbox3,'Value');
if idx==1 
    im_list2=im_list((idx+1):size(im_list,1),:);
elseif idx==size(im_list,1)
    im_list2=im_list(1:(idx-1),:);    
    set(handles.listbox3,'Value',idx-1);      
else
    im_list2=[im_list(1:(idx-1),:);im_list((idx+1):size(im_list,1),:)];
end    
    set(handles.listbox3,'String',im_list2);
    set(handles.text11,'String',num2str(size(im_list2,1)));    

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
im_list=get(handles.listbox4,'String');
idx=get(handles.listbox4,'Value');
if idx==1 
    im_list2=im_list((idx+1):size(im_list,1),:);
elseif idx==size(im_list,1)
    im_list2=im_list(1:(idx-1),:); 
    set(handles.listbox4,'Value',idx-1);    
else
    im_list2=[im_list(1:(idx-1),:);im_list((idx+1):size(im_list,1),:)];
end    
    set(handles.listbox4,'String',im_list2);
    set(handles.text12,'String',num2str(size(im_list2,1)));       

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
im_list=get(handles.listbox5,'String');
idx=get(handles.listbox5,'Value');
if idx==1 
    im_list2=im_list((idx+1):size(im_list,1),:);
elseif idx==size(im_list,1)
    im_list2=im_list(1:(idx-1),:);   
    set(handles.listbox5,'Value',idx-1);      
else
    im_list2=[im_list(1:(idx-1),:);im_list((idx+1):size(im_list,1),:)];
end    
    set(handles.listbox5,'String',im_list2);
    set(handles.text13,'String',num2str(size(im_list2,1)));       

% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.listbox3,'String','');
set(handles.text11,'String','0');   

% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.listbox4,'String','');
set(handles.text11,'String','0');   

% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.listbox5,'String','');
set(handles.text11,'String','0');   

% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[ok, handles] = check_im_lists(hObject, handles);
% guidata(hObject, handles);   
p           =       ancestor(hObject,'figure');
event_data  =       get(p,'UserData');

if ok
    figure1_CloseRequestFcn(p, eventdata, handles);
else
	errordlg('Functional, anatomical and masks listboxes do not contain the same number of elements. Please use "Repeat" buttons when needed');
end


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% LOAD STRUCT
localiz=mfilename('fullpath');
cd(fileparts(localiz));
direct=get(handles.listbox2,'UserData');
[file, path]=uigetfile({[direct filesep '*.mat']},'Select a struct file');

try
    load(fullfile(path,file));
    handles=load_im_list(sel_dir,handles);
    set(handles.listbox2,'String',handles.file_names,...
	'Value',1);
    set(handles.text7,'String',pwd);
    set(handles.listbox3,'String',char(f_list'));
    set(handles.listbox4,'String',char(a_list));
    set(handles.listbox5,'String',char(m_list)); 
    set(handles.listbox3,'Value',1);    
    set(handles.text11,'String',num2str(size(f_list,1)));      
    set(handles.listbox4,'Value',1);    
    set(handles.text12,'String',num2str(size(a_list,1)));      
    set(handles.listbox5,'Value',1);    
    set(handles.text13,'String',num2str(size(m_list,1)));      
    parent  =   ancestor(hObject,'figure');
    set(parent,'UserData',data_struct);
catch err
    errordlg('Error loading STRUCT file. Check variables inside.');
    set(hObject,'Value',0);
end    
    





% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% STORE STRUCT
ok              =   check_im_lists(hObject, handles);
parent          =   ancestor(hObject,'figure');  
data_struct     =   get(parent,'UserData');  

if ok

    [file,path] = uiputfile('struct.mat','Save struct file');
    if file ~=0 
        if isdir(path)  
            cd(path);
            try
                fullpath=[path file];
                f_list=cellstr(get(handles.listbox3,'String'));
                a_list=cellstr(get(handles.listbox4,'String'));
                m_list=cellstr(get(handles.listbox5,'String'));        
                sel_dir=get(handles.text7,'String');
                save(fullpath,'data_struct','f_list','a_list','m_list','sel_dir');
            catch
                errordlg('Cannot save struct file here. Check folder permissions');
            end
        end
    end    
else
	errordlg('Functional, anatomical and masks listboxes do not contain the same number of elements.Please use "Repeat" buttons when needed');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over listbox3.
function listbox3_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on listbox3 and none of its controls.
function listbox3_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rep_no=str2double(get(handles.edit2,'String'));
aux_list=get(handles.listbox4,'String');
candidate=aux_list(get(handles.listbox4,'Value'),:);
for r=1:rep_no-1
   aux_list=strvcat(aux_list,candidate);
end
set(handles.listbox4,'String',aux_list,'Value',size(aux_list,1)); 
set(handles.text12,'String',num2str(size(aux_list,1)));

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


% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rep_no=str2double(get(handles.edit3,'String'));
aux_list=get(handles.listbox5,'String');
candidate=aux_list(get(handles.listbox5,'Value'),:);
for r=1:rep_no-1
   aux_list=strvcat(aux_list,candidate);
end
set(handles.listbox5,'String',aux_list,'Value',size(aux_list,1)); 
set(handles.text13,'String',num2str(size(aux_list,1)));

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


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
units = get(handles.popupmenu1,'String');
sel_unit = units(get(handles.popupmenu1,'Value'),:);
        
if isdir(sel_unit)
        handles.is_dir=1;
        cd (sel_unit);
        handles=load_im_list(pwd,handles);
        set(handles.listbox2,'String',handles.file_names,...
            'Value',1);
        set(handles.text7,'String',pwd);  
else
    
end

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'String',char(getdrives'));

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


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
