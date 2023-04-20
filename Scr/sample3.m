%-----------------------------------------------------------------------------------------------------%
% Project Name: Image Processing
%
% Team Num: 8
%
% Team Members: Ola Mohamed Ahmed - Ahmed Gamal Okka - AbdElrhman Atef -
% Ramzi Muhammed -Ahmed Tarek
%
%Tech: Eng/Moufeda Hussein
%---------------------------------------------------------------------------------------------------%
function varargout = sample3(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sample3_OpeningFcn, ...
                   'gui_OutputFcn',  @sample3_OutputFcn, ...
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
%------------------------------------------------------------------------------------------------------------------------%
% --- Executes just before sample3 is made visible.
function sample3_OpeningFcn(hObject, ~, handles, varargin)
% Choose default command line output for sample3
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes sample3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);
%------------------------------------------------------------------------------------------------------------------%

% --- Outputs from this function are returned to the command line.
function varargout = sample3_OutputFcn(~, ~, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;
%------------------------------------------------------------------------------------------------------------------%
% --- Executes on button press in Upload_Image.
function Upload_Image_Callback(~, ~, handles)
a=uigetfile({'*.*';'*.tif';'*.png';'*.jbg';'*.bmb';'*.gif';'*.svg';'*.psd';'*.raw'});
a=imread(a);
axes(handles.axes1);
imshow(a)
setappdata(0,'a',a)
%-------------------------------------------------------------------------------------------------------------------%
% --- Executes on button press in RGB_to_Gray.
function RGB_to_Gray_Callback(hObject, eventdata, handles)
a = getappdata(0,'a');    
    if (size(a,3)== 3)
        rgb_2_gray = rgb2gray(a);
        axes(handles.axes2);
        imshow(rgb_2_gray); 
        setappdata(0,'rgb_2_gray',rgb_2_gray);
    elseif strcmp(a,'')
        cla(handles.axes2,'reset');
        else
        msgbox('This image is in grey scale and cannot be converted to grey scale')
        pause(1)
    end

%------------------------------------------------------------------------------------------------------------------------%
% --- Executes on button press in Reset.
function Reset_Callback(hObject, eventdata, handles)
a= "";
setappdata(0,'a',a)
cla(handles.axes1,'reset');
cla(handles.axes2,'reset');
HerozitalEdge_KeyPressFcn(hObject, eventdata, handles);
VerticalEdge_KeyPressFcn(hObject, eventdata, handles);

%-------------------------------------------------------------------------------------------------------------------------%
% --- Executes on button press in Orginal_Image.
function Orginal_Image_Callback(hObject, eventdata, handles)
a = getappdata(0,'a'); 
if strcmp(a,'')
    cla(handles.axes2,'reset');
else
    axes(handles.axes2);
imshow(a);
end

%-------------------------------------------------------------------------------------------------------------------------%
% --- Executes on button press in VerticalEdge.
function VerticalEdge_Callback(hObject, eventdata, handles)
c=get(handles.VerticalEdge ,'value');
if c == 1
    a=getappdata(0,'a');
    hmask = fspecial('sobel');
    vmask=hmask';
    b_v = imfilter(a,vmask,'replicate');
    axes(handles.axes2);
    imshow(b_v)
else
    Orginal_Image_Callback(hObject, eventdata, handles);
end

%-------------------------------------------------------------------------------------------------------------------------%
% --- Executes on button press in HerozitalEdge.
function HerozitalEdge_Callback(hObject, eventdata, handles)
c=get(handles.HerozitalEdge ,'value');
if c == 1
    a=getappdata(0,'a');
    hmask = fspecial('sobel');
    b_h = imfilter(a,hmask,'replicate');
    axes(handles.axes2);
    imshow(b_h)
else
    Orginal_Image_Callback(hObject, eventdata, handles);
end

%-------------------------------------------------------------------------------------------------------------------------%
% --- Executes on button press in Close.
function Close_Callback(hObject, eventdata, handles)
msgbox('Thank you ...')
pause(1)
close();
close();
%-------------------------------------------------------------------------------------------------------------------------%
% --- Executes on selection change in Noise.
function Noise_Callback(hObject,eventdata, handles)
a=get(handles.Noise ,'value');
b = getappdata(0,'a');
if(a==1)
    msgbox('please Select Noise ...')
    pause(1)
elseif(a==2)
   noise=imnoise(b,'salt & pepper');
   axes(handles.axes2);
   imshow(noise)
   setappdata(0,'noise',noise)

elseif(a==3)
    noise=imnoise(b,'gaussian');
    axes(handles.axes2);
    imshow(noise)
   setappdata(0,'noise',noise)

elseif(a==4)
     noise=imnoise(b,'speckle');
     axes(handles.axes2);
     imshow(noise)
   setappdata(0,'noise',noise)


elseif(a==5)
     b=getappdata(0,'a');
     if (size(b,3)== 3)
          b=rgb2gray(b);
     end
     noise=imnoise(b,'salt & pepper',0.05);
     fun =@(x) max(x(:));
     m=nlfilter(noise,[3,3],fun);
     axes(handles.axes2);
     imshow(m)
   setappdata(0,'noise',noise)


elseif(a==6)
     b=getappdata(0,'a');
     if (size(b,3)== 3)
         b=rgb2gray(b);
     end
     noise=imnoise(b,'salt & pepper',0.05);
     fun =@(x) min(x(:));
     m=nlfilter(noise,[3,3],fun);
     axes(handles.axes2);
     imshow(m)
   setappdata(0,'noise',noise)

end

% --- Executes during object creation, after setting all properties.
function Noise_CreateFcn(hObject,eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%-------------------------------------------------------------------------------------------------------------------------%
% --- Executes on selection change in Filters.
function Filters_Callback(hObject, eventdata, handles)
index=get(handles.Filters ,'value');
n = get(handles.Noise,'value');
pic=getappdata(0,'noise');
o = getappdata(0,'a');
if(index==1)
    msgbox('please Select Filter ...')
    pause(1)
elseif(index==2)
    if(n==1)
        if (size(o,3)== 3)
            o=rgb2gray(o);
        end  
        c = ordfilt2(o,9,ones(3,3));
    else
        if (size(pic,3)== 3)
            pic=rgb2gray(pic);
        end  
        c = ordfilt2(pic,9,ones(3,3));
    end
    axes(handles.axes2);
    imshow(c)
elseif(index==3)
    if(n==1)
        if (size(o,3)== 3)
            o=rgb2gray(o);
        end  
        c = ordfilt2(o,1,ones(3,3));
    else
        if (size(pic,3)== 3)
            pic=rgb2gray(pic);
        end  
        c = ordfilt2(pic,1,ones(3,3));
    end
    axes(handles.axes2);
    imshow(c)
elseif(index==4) 
   if(n==1)
        if (size(o,3)== 3)
            o=rgb2gray(o);
        end  
        c = ordfilt2(o,5,ones(3,3));
    else
        if (size(pic,3)== 3)
            pic=rgb2gray(pic);
        end  
        c = ordfilt2(pic,5,ones(3,3));
    end
    axes(handles.axes2);
    imshow(c)
elseif(index==5)
     if(n==1)
        if (size(o,3)== 3)
            o=rgb2gray(o);
        end  
        midp =@(x) (min(x(:)) + max(x(:)))/2;
        m=nlfilter(o,[3,3],midp);
    else
        if (size(pic,3)== 3)
            pic=rgb2gray(pic);
        end  
        midp =@(x) (min(x(:)) + max(x(:)))/2;
        m=nlfilter(pic,[3,3],midp);
    end
    axes(handles.axes2);
    imshow(c)
    
    
    if (size(pic,3)== 3)
        pic=rgb2gray(pic);
    end
    axes(handles.axes2);
    imshow(m)
end
% --- Executes during object creation, after setting all properties.
function Filters_CreateFcn(hObject,eventdata, handles)
   
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%-------------------------------------------------------------------------------------------------------------------------%
% --- Executes on button press in Simple_Laplacian.
function Simple_Laplacian_Callback(hObject, eventdata, handles)
c = get(handles.Simple_Laplacian ,'value');
if c == 1
    a=getappdata(0,'a');
    l=[0 -1 0;-1 5 -1; 0 -1 0];
    im=imfilter(a,l,'replicate');
    axes(handles.axes2);
    imshow(im)
else
    Orginal_Image_Callback(hObject, eventdata, handles);
end
    

% --- Executes on key press with focus on Simple_Laplacian and none of its controls.
function Simple_Laplacian_KeyPressFcn(hObject, eventdata, handles)

%-------------------------------------------------------------------------------------------------------------------------%
% --- Executes on button press in Varient_Laplacian.
function Varient_Laplacian_Callback(hObject, eventdata, handles)
c = get(handles.Varient_Laplacian ,'value');
if c == 1
    a=getappdata(0,'a');
    l_2=[-1 -1 -1;-1 9 -1; -1 -1 -1];
    im_2=imfilter(a,l_2,'replicate');
    axes(handles.axes2);
    imshow(im_2)
else
    Orginal_Image_Callback(hObject, eventdata, handles);
end
% --- Executes on key press with focus on Varient_Laplacian and none of its controls.
function Varient_Laplacian_KeyPressFcn(hObject, eventdata, handles)

%-------------------------------------------------------------------------------------------------------------------------%
% --- Executes on button press in Smoothing.
function Smoothing_Callback(hObject, eventdata, handles)
a=getappdata(0,'a');
if (size(a,3)== 3)
        a=rgb2gray(a);
end
m=fspecial('average',[3 3]);
a_avg=imfilter(a,m);
axes(handles.axes2);
imshow(a_avg)

%-------------------------------------------------------------------------------------------------------------------------%
% --- Executes on button press in contraststretching.
function contraststretching_Callback(hObject, eventdata, handles)
a=getappdata(0,'a');
if (size(a,3)== 3)
        a=rgb2gray(a);
end
adj= imadjust(a,[0.3,.6],[0,1]);
axes(handles.axes2);
imshow(adj);

%-------------------------------------------------------------------------------------------------------------------------%
% --- Executes on button press in Histogram_Equalization.
function Histogram_Equalization_Callback(hObject, eventdata, handles)
a=getappdata(0,'a');
if (size(a,3)== 3)
        a=rgb2gray(a);
end
heq=histeq(a);
axes(handles.axes2);
imshow(heq);
%-------------------------------------------------------------------------------------------------------------------------%
% --- Executes on slider movement.
function Brightness_Callback(hObject, eventdata, handles)
data = get(handles.Brightness,'Value');
a = getappdata(0,'a');
pic = a + data;
axes(handles.axes2);
imshow(pic);

% --- Executes during object creation, after setting all properties.
function Brightness_CreateFcn(hObject, eventdata, handles)
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%-------------------------------------------------------------------------------------------------------------------------%
% --- Executes on button press in Arithmatic_mean.
function Arithmatic_mean_Callback(hObject, eventdata, handles)
 rest = getappdata(0,'noise');
 Restore=imrest(rest,'amean',3,3);
 axes(handles.axes2);
 imshow(Restore)

%-------------------------------------------------------------------------------------------------------------------------%
% --- Executes on button press in Geometric_mean.
function Geometric_mean_Callback(hObject, eventdata, handles)
 rest = getappdata(0,'noise');
 Restore=geomean(rest,3,3);
 axes(handles.axes2);
 imshow(Restore)
%-------------------------------------------------------------------------------------------------------------------------%
% --- Executes on button press in Harmonic_mean.
function Harmonic_mean_Callback(hObject, eventdata, handles)
rest = getappdata(0,'noise');
Restore = imrest(rest,'hmean',3,3);
axes(handles.axes2);
imshow(Restore)

%-------------------------------------------------------------------------------------------------------------------------%
% --- Executes on button press in Contraharmonicp_mean.
function Contraharmonicp_mean_Callback(hObject, eventdata, handles)
 rest = getappdata(0,'noise');
 Restore=imrest(rest,'chmean',3,3,2);
 axes(handles.axes2);
 imshow(Restore)
%-------------------------------------------------------------------------------------------------------------------------%
% --- Executes on button press in Contraharmonicn_mean.
function Contraharmonicn_mean_Callback(hObject, eventdata, handles)
 rest = getappdata(0,'noise');
 Restore=imrest(rest,'chmean',3,3,-2);
 axes(handles.axes2);
 imshow(Restore)
%-------------------------------------------------------------------------------------------------------------------------%
% --- Executes on button press in Alpha_trimmed.
function Alpha_trimmed_Callback(hObject, eventdata, handles)
 rest = getappdata(0,'noise');
 Restore=imrest(rest,'atrimmed',3,3,2);  %its default value is D = 2
 axes(handles.axes2);
 imshow(Restore)
%-------------------------------------------------------------------------------------------------------------------------%
% --- Executes on button press in Original_Image_hist.
function Original_Image_hist_Callback(hObject, eventdata, handles)
a=getappdata(0,'a');
axes(handles.axes2);
imhist(a);

%-------------------------------------------------------------------------------------------------------------------------%
% --- Executes on button press in Equalized_Image.
function Equalized_Image_Callback(hObject, eventdata, handles)
a=getappdata(0,'a');
heq=histeq(a);
axes(handles.axes2);
imhist(heq);
%-------------------------------------------------------------------------------------------------------------------------%
% --- Executes on button press in Contrast_Stretching.
function Contrast_Stretching_Callback(hObject, eventdata, handles)
a=getappdata(0,'a');
adj= imadjust(a,[0,1],[0,1]);
axes(handles.axes2);
imhist(adj);
%-------------------------------------------------------------------------------------------------------------------------%
% --- Executes on selection change in reincrease.
function reincrease_Callback(hObject, eventdata, handles)
index=get(handles.reincrease ,'value');
pic=getappdata(0,'a');
if(index==1)
    msgbox('please Select Value ...')
    pause(1)
elseif(index==2)
    resize = imresize(pic , 2 );
    axes(handles.axes2);
    imshow(resize);
elseif(index==3)
    resize = imresize(pic , 4 );
    axes(handles.axes2);
    imshow(resize);
elseif(index==4)
    resize = imresize(pic , 8 );
    axes(handles.axes2);
    imshow(resize);
end

% --- Executes during object creation, after setting all properties.
function reincrease_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%-------------------------------------------------------------------------------------------------------------------------%
% --- Executes on selection change in redecrease.
function redecrease_Callback(hObject, eventdata, handles)
index=get(handles.redecrease ,'value');
pic=getappdata(0,'a');
if(index==1)
    msgbox('please Select Value ...')
    pause(1)
elseif(index==2)
    resize = imresize(pic , 0.5 );
    axes(handles.axes2);
    imshow(resize);
elseif(index==3)
    resize = imresize(pic , 0.25 );
    axes(handles.axes2);
    imshow(resize);
elseif(index==4)
    resize = imresize(pic , 0.125 );
    axes(handles.axes2);
    imshow(resize);

end

% --- Executes during object creation, after setting all properties.
function redecrease_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%-------------------------------------------------------------------------------------------------------------------------%
% --- Executes on key press with focus on VerticalEdge and none of its controls.
function VerticalEdge_KeyPressFcn(hObject, eventdata, handles)

% --- Executes on key press with focus on HerozitalEdge and none of its controls.
function HerozitalEdge_KeyPressFcn(hObject, eventdata, handles)
%-----------------------------------------------End of Code --------------------------------------------------------------------------%
