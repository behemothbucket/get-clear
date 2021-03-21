function varargout = SoundProc(varargin)
% Edit the above text to modify the response to help SoundProc
% Last Modified by GUIDE v2.5 17-Mar-2021 16:21:23
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name', mfilename, ...
'gui_Singleton', gui_Singleton, ...
'gui_OpeningFcn', @SoundProc_OpeningFcn, ...
'gui_OutputFcn', @SoundProc_OutputFcn, ...
'gui_LayoutFcn', [] , ...
'gui_Callback', []);
if nargin && ischar(varargin{1})
gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
[varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before SoundProc is made visible.
function SoundProc_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
clc % очищаем командное окно
handles.y = []; % инициализируем данные
handles.yn = []; % инициализируем данные
handles.obj = []; % инициализируем плеер
cla(handles.axes1) % очищаем оси
cla(handles.axes2) % очищаем оси
%axis(handles.axes1,'off') % убираем рамку
guidata(hObject, handles); % сохраняем данные

% UIWAIT makes SoundProc wait for user response (see UIRESUME)
% uiwait(handles.figure1);


function varargout = SoundProc_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;


function btn_open_Callback(hObject, eventdata, handles)
% выбираем файл:
[fname,path] = uigetfile({'*.wav; *.mp3; *.wma','Audio files (*.wav; *.mp3; *.wma)'},'Выбирете файл...');
% отображаем имя файла в текстовом поле:
handles.text_fn.String = fname;
% загружаем файл:
h = msgbox('Идет загрузка файла...');
[Y, Fs] = audioread(strcat(path,fname));
close(h)
% заполняем меню с уровнями
n2 = min(floor(log2(length(Y))), 15); % макс. уровень, но не больше 15
handles.pop_n.String = {}; % очищаем что было
handles.pop_n.String = {num2str((1:n2)')}; % заполняем пункты

t = (0:length(Y)-1)/Fs; % массив времени
cla(handles.axes2) % очищаем ось
plot(handles.axes1,t,Y(:,1)) % рисуем график
xlim(handles.axes1, [min(t), max(t)]) % выставляем пределы оси Х
obj = audioplayer(Y, Fs); % создаем объект-плеер
% задаем функции для изменения надписи кнопки
set( obj, 'StopFcn', {@StopPlayback_Callback, handles.btn_play} )
set( obj, 'StartFcn', {@StartPlayback_Callback, handles.btn_play} )
% сохраняем данные:
handles.t = t;
handles.y = Y;
handles.fs = Fs;
handles.obj = obj;
guidata(hObject, handles);


function btn_play_Callback(hObject, eventdata, handles)
if isempty(handles.obj) % если файл не загружен
msgbox('Файл не загружен!')
return % возвращаемся
end
obj = handles.obj;
if isplaying(obj) % если идет воспроизведение
stop(obj) % останавливаем
else % если не идет
play(obj) % проигрываем
end

function btn_noice_Callback(hObject, eventdata, handles)
% добавление шума
Ndb = -str2double(handles.edit_ndb.String); % считываем значение из поля
if isempty(handles.y) % если данных нет
msgbox('Файл не загружен!')
return % возвращаемся
end
y = handles.y; % загружаем данные
n = randn(size(y)); % случайные числа с нормальным законом распределения
Ey = sum(y.^2); % энергия сигнала
En = sum(n.^2); % энергия шума
% рассчитываем дисперсию шума:
sigma = (sqrt(Ey./En)*(1/(10^(Ndb/20))));
Yn = y + sigma.*n; % сигнал + шум
%Yn = awgn( handles.y, Ndb, 'measured' ); % можно и так
t = handles.t;
plot(handles.axes2, t, Yn(:,1)) % рисуем
xlim(handles.axes2, [min(t), max(t)])
handles.yn = Yn; % сохраняем зашумленный сигнал
obj = audioplayer(Yn, handles.fs); % создаем объект-плеер
% задаем функции для кнопки
set( obj , 'StopFcn' , {@StopPlayback_Callback, handles.btn_play} )
set( obj , 'StartFcn' , {@StartPlayback_Callback, handles.btn_play} )
handles.obj = obj; % сохраняем объект
guidata(hObject, handles);

function edit_ndb_Callback(hObject, eventdata, handles)
% если изменили значение в окне, добавляем шум
btn_noice_Callback(hObject, eventdata, handles);

function edit_ndb_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
set(hObject,'BackgroundColor','white');
end

function StopPlayback_Callback(hObject, eventdata, buttonHandle )
% если не воспроизводится
% надпись на кнопке:
set( buttonHandle , 'String', 'Прослушать' );

function StartPlayback_Callback(hObject, eventdata, buttonHandle )
% если воспроизводится
% надпись на кнопке:
set( buttonHandle , 'String', 'Стоп' );


% --- Executes on button press in btn_denoice.
function btn_denoice_Callback(hObject, eventdata, handles)
% очищаем сигнал от шумов
h = msgbox('Идет обработка...');
contents = cellstr(get(handles.pop_w,'String')); % список
w = contents{get(handles.pop_w,'Value')}; % выбранное значение
contents = cellstr(get(handles.pop_n,'String')); % список
n = contents{get(handles.pop_n,'Value')}; % выбранное значение
n = str2double(n); % переводим в число
yn = handles.yn; % загружаем зашумленный сигнал
if isempty(yn) % если данных нет
yn = handles.y; % берем исходный сигнал
end
yd = wdenoise(yn,n,'Wavelet',w);
close(h)

t = handles.t;
plot(handles.axes2, t, yd(:,1)) % рисуем
xlim(handles.axes2, [min(t), max(t)])
handles.yd = yd; % сохраняем зашумленный сигнал
obj = audioplayer(yd, handles.fs); % создаем объект-плеер
% задаем функции для кнопки
set( obj , 'StopFcn' , {@StopPlayback_Callback, handles.btn_play} )
set( obj , 'StartFcn' , {@StartPlayback_Callback, handles.btn_play} )
handles.obj = obj; % сохраняем объект
guidata(hObject, handles);


% --- Executes on selection change in pop_w.
function pop_w_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function pop_w_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in pop_n.
function pop_n_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns pop_n contents as cell array
% contents{get(hObject,'Value')} returns selected item from pop_n

% --- Executes during object creation, after setting all properties.
function pop_n_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
set(hObject,'BackgroundColor','white');
end
