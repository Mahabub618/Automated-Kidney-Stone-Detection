function varargout = ImageLoader(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ImageLoader_OpeningFcn, ...
                   'gui_OutputFcn',  @ImageLoader_OutputFcn, ...
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

function ImageLoader_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;

guidata(hObject, handles);

function varargout = ImageLoader_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;

function pushbutton1_Callback(hObject, eventdata, handles)
[filename,pathname]=uigetfile('*.*','Pick a MATLAB code file');
filename=strcat(pathname,filename);
set(handles.edit1, 'String', filename);

im = imread(filename);
axis(handles.axes1);
imagesc(im);

a=imread(filename);
%imshow(a);


b=rgb2gray(a);
%figure;
%imshow(b);
impixelinfo;


c=b>20;
%figure;
%imshow(c);
d=imfill(c,'holes');
%figure;
%imshow(d);


e=bwareaopen(d,1000);
%figure;
%imshow(e);


PreprocessedImage=uint8(double(a).*repmat(e,[1 1 3]));
%figure;
%imshow(PreprocessedImage);


PreprocessedImage=imadjust(PreprocessedImage,[0.3 0.7],[])+50;
%figure;
%imshow(PreprocessedImage);


uo=rgb2gray(PreprocessedImage);
%figure;
%imshow(uo);


mo=medfilt2(uo,[5 5]);
%figure;
%imshow(mo);


po=mo>250;
%figure;
%imshow(po);


[r c m]=size(po);
x1=r/2;
y1=c/3;
row=[x1 x1+200 x1+200 x1];
col=[y1 y1 y1+40 y1+40];
BW=roipoly(po,row,col);
%figure;
%imshow(BW);


k=po.*double(BW);
%figure;
%imshow(k);
M=bwareaopen(k,4);


[ya number]=bwlabel(M);
figure;

if(number>=1)
    text(0.3, 0.5, 'Stone is Detected!', 'FontSize', 22, 'Color', 'red', 'FontWeight', 'bold'); %disp('Stone is Detected');
else
    text(0.15, 0.5, 'Stone is not Detected', 'FontSize', 22, 'Color', 'green', 'FontWeight', 'bold'); %disp('No Stone is detected');
end

figure('Name', 'Image Processing Results');
subplot(2, 4, 1), imshow(im), title('Original Image');
subplot(2, 4, 2), imshow(b), title('Grayscale Image');
subplot(2, 4, 3), imshow(d), title('Binary Image');
subplot(2, 4, 4), imshow(PreprocessedImage), title('Preprocessed Image');
subplot(2, 4, 5), imshow(mo), title('Median Filtered Image');
subplot(2, 4, 6), imshow(BW), title('ROI');
subplot(2, 4, 7), imshow(k), title('Final Image');


function edit1_Callback(hObject, eventdata, handles)

function edit1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


