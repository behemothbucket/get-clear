classdef SoundProc_App < matlab.apps.AppBase

% Properties that correspond to app components
properties (Access = public)
figure1 matlab.ui.Figure
Menu_3 matlab.ui.container.Menu
Menu_2 matlab.ui.container.Menu
Toolbar matlab.ui.container.Toolbar
PushTool matlab.ui.container.toolbar.PushTool
TabGroup matlab.ui.container.TabGroup
Tab matlab.ui.container.Tab
Panel matlab.ui.container.Panel
Panel_2 matlab.ui.container.Panel
btn_play matlab.ui.control.Button
btn_stop matlab.ui.control.Button
btn_open matlab.ui.control.Button
Panel_3 matlab.ui.container.Panel
text2 matlab.ui.control.Label
edit_ndb matlab.ui.control.EditField
btn_noice matlab.ui.control.Button
btn_denoice matlab.ui.control.Button
pop_w matlab.ui.control.DropDown
text4 matlab.ui.control.Label
text5 matlab.ui.control.Label
pop_n matlab.ui.control.DropDown
save matlab.ui.control.Button
Panel_5 matlab.ui.container.Panel
Button matlab.ui.control.Button
Panel_10 matlab.ui.container.Panel
Lamp matlab.ui.control.Lamp
Button_9 matlab.ui.control.Button
Label_2 matlab.ui.control.Label
Button_10 matlab.ui.control.Button
axes1 matlab.ui.control.UIAxes
axes2 matlab.ui.control.UIAxes
Tab_2 matlab.ui.container.Tab
Panel_6 matlab.ui.container.Panel
Panel_7 matlab.ui.container.Panel
text2_2 matlab.ui.control.Label
noise_param matlab.ui.control.EditField
btn_img_denoice matlab.ui.control.Button
pop_w_2 matlab.ui.control.DropDown
pop_n_2 matlab.ui.control.DropDown
Label matlab.ui.control.Label
NoiseMetod matlab.ui.control.DropDown
text5_2 matlab.ui.control.Label
btn_open_img matlab.ui.control.Button
btn_img_noice matlab.ui.control.Button
text4_2 matlab.ui.control.Label
WievOrig matlab.ui.control.Button
WievOrig_2 matlab.ui.control.Button
WievOrig_3 matlab.ui.control.Button
Button_2 matlab.ui.control.Button
ImgIn matlab.ui.control.UIAxes
ImgNoise matlab.ui.control.UIAxes
ImgFilt matlab.ui.control.UIAxes
Tab_4 matlab.ui.container.Tab
Panel_11 matlab.ui.container.Panel
Panel_12 matlab.ui.container.Panel
Button_11 matlab.ui.control.Button
Button_12 matlab.ui.control.Button
Button_13 matlab.ui.control.Button
Button_14 matlab.ui.control.Button
Button_15 matlab.ui.control.Button
Button_16 matlab.ui.control.Button
Button_17 matlab.ui.control.Button
Panel_13 matlab.ui.container.Panel
Button_18 matlab.ui.control.Button
Button_19 matlab.ui.control.Button
Button_20 matlab.ui.control.Button
Button_21 matlab.ui.control.Button
Panel_14 matlab.ui.container.Panel
Button_22 matlab.ui.control.Button
Tab_3 matlab.ui.container.Tab
Panel_8 matlab.ui.container.Panel
HTML matlab.ui.control.HTML
ButtonGroup matlab.ui.container.ButtonGroup
dbButton matlab.ui.control.ToggleButton
symButton matlab.ui.control.ToggleButton
haarButton matlab.ui.control.ToggleButton
coif4Button matlab.ui.control.ToggleButton
fk4Button matlab.ui.control.ToggleButton
Button_3 matlab.ui.control.ToggleButton
end


properties (Access = public)
% для звука
t = []; % время
y = []; % исходный сигнал
yn = []; % сигнал с шумом
yd % очищенный сигнал
obj = []; % объект-плеер
fs % частота дискретизации
% для изображения
img % исходное изображение
imgN % изображение с шумом
imgF % отфильтрованное изображение
cleanAudio % отчищенный сигнал (для нс)
noiseAudio % шум (для нс)
noisyAudio % зашумленный сигнал
fsd % частота дс (для нс)
clicked_1 = 0; % для кнопок
clicked_2 = 0; % для кнопок
clicked_3 = 0;
dataFolder % папка с набором данных
audio; % для датасета
adsTrainInfo;
adsTrain;
src;
var=load('nnFullyConnected.mat');
var1=load('nnFullyConvolutional.mat');
decimationFactor;
win;
overlap;
ffTLength;
numFeatures;
numSegments;
targets;
predictors;
cleanMean;
cleanStd;
noisyMean;
noisyStd;
end



% Callbacks that handle component events
methods (Access = private)

% Code that executes after component creation
function SoundProc_OpeningFcn(app)
movegui(app.figure1,"center");
clc % очищаем
404 Not Found
matlab.ui.container.Menu
 
командное окно
cla(app.axes1) % очищаем оси
cla(app.axes2) % очищаем оси
end

% Button pushed function: btn_denoice
function btn_denoice_Callback(app, event)
% очищаем сигнал от шумов
h = msgbox('Идет обработка...');
w = app.pop_w.Value; % выбранное значение
n = app.pop_n.Value; % выбранное значение
n = str2double(n); % переводим в число
if isempty(app.yn) % если данных нет
app.yn = app.y; % берем исходный сигнал
end
app.yd = wdenoise(app.yn,n,'Wavelet',w);
close(h)
plot(app.axes2, app.t, app.yd(:,1)) % рисуем
xlim(app.axes2, [min(app.t), max(app.t)])
app.obj = audioplayer(app.yd, app.fs); % создаем объект-плеер
title(app.axes2,'Очищенный сигнал')
app.save.Enable = 'on';
end

% Button pushed function: btn_noice
function btn_noice_Callback(app, event)
% добавление шума
Ndb = -str2double(app.edit_ndb.Value); % считываем значение из поля
if isempty(app.y) % если данных нет
msgbox('Файл не загружен!')
return % возвращаемся
end
n = randn(size(app.y)); % случайные числа с нормальным законом распределения
Ey = sum(app.y.^2); % энергия сигнала
En = sum(n.^2); % энергия шума
% рассчитываем дисперсию шума:
sigma = (sqrt(Ey./En)*(1/(10^(Ndb/20))));
app.yn = app.y + sigma.*n; % сигнал + шум
%Yn = awgn( app.y, Ndb, 'measured' ); % можно и так
plot(app.axes2, app.t, app.yn(:,1)) % рисуем
xlim(app.axes2, [min(app.t), max(app.t)])
app.obj = audioplayer(app.yn, app.fs); % создаем объект-плеер
title(app.axes2,'Зашумленный сигнал')
end

% Button pushed function: btn_open
function btn_open_Callback(app, event)
% выбираем файл:
[fname,path] = uigetfile({'*.wav; *.mp3; *.wma','Audio files (*.wav; *.mp3; *.wma)'},'Выбирете файл...');
% отображаем имя файла в текстовом поле:
%app.text_fn.Text = fname;
% загружаем файл:
h = msgbox('Идет загрузка файла...');
[Y, Fs] = audioread(strcat(path,fname));
close(h)
% заполняем меню с уровнями
n2 = min(floor(log2(length(Y))), 15); % макс. уровень, но не больше 15
app.pop_n.Items = {}; % очищаем что было
for i = 1:n2
app.pop_n.Items{i} = num2str(i); % заполняем пункты
end
app.t = (0:length(Y)-1)/Fs; % массив времени
cla(app.axes1) % очищаем ось
plot(app.axes1,app.t,Y(:,1)) % рисуем график
% title(app.axes1,'Исходный сигнал'); % название графика
% xlabel(app.axes1,'t,c'); % подпись оси X
% ylabel(app.axes1,'V,В'); % подпись оси Y
% grid on;
xlim(app.axes1, [min(app.t), max(app.t)]) % выставляем пределы оси Х
app.obj = audioplayer(Y, Fs); % создаем объект-плеер
% сохраняем данные:
app.y = Y;
app.fs = Fs;
end

% Button pushed function: btn_play
function btn_play_Callback(app, event)
if isempty(app.obj) % если файл не загружен
msgbox('Файл не загружен!')
return % возвращаемся
end
play(app.obj)
end

% Value changed function: edit_ndb
function edit_ndb_Callback(app, event)
% если изменили значение в окне, добавляем шум
btn_noice_Callback(app, event);
end

% Button pushed function: btn_stop
function btn_stopButtonPushed(app, event)
if isempty(app.obj) % если файл не загружен
msgbox('Файл не загружен!')
return % возвращаемся
end
stop(app.obj)
end

% Button pushed function: btn_open_img
function btn_open_imgButtonPushed(app, event)
% выбираем файл:
[fname,path] = uigetfile({'*.bmp; *.jpg; *.png; *.gif','Image files (*.bmp; *.jpg; *.png; *.gif'},'Выбирете файл...');
% отображаем имя файла в текстовом поле:
%app.text_fn_2.Text = fname;
% загружаем файл
fullname = strcat(path,fname);
app.img = imread(fullname);
image(app.ImgIn, app.img);
xlim(app.ImgIn,[1 size(app.img, 2)])
ylim(app.ImgIn,[1 size(app.img, 1)])
% заполняем меню с уровнями
sz = [size(app.img,1), size(app.img,2)];
n = floor(log2( min(sz) )); % макс. уровень, но не больше 15
app.pop_n_2.Items = {}; % очищаем что было
for i = 1:n
app.pop_n_2.Items{i} = num2str(i); % заполняем пункты
end
end

% Button pushed function: btn_img_noice
function btn_img_noiceButtonPushed(app, event)
h = msgbox('Идет обработка...');
if
 
isempty(app.img)
msgbox('Изображение не загружено!')
return
end
value = app.NoiseMetod.Value;
switch value
case 'salt & pepper'
d = str2double( app.noise_param.Value );
app.imgN = imnoise(app.img, value, d);
case 'gaussian'
d = str2double( app.noise_param.Value );
app.imgN = imnoise(app.img, value, 0, d);
case 'speckle'
d = str2double( app.noise_param.Value );
app.imgN = imnoise(app.img, value, d);
end
image(app.ImgNoise, app.imgN);
xlim(app.ImgNoise,[1 size(app.imgN, 2)])
ylim(app.ImgNoise,[1 size(app.imgN, 1)])
close(h)
end

% Value changed function: noise_param
function noise_paramValueChanged(app, event)
btn_img_noiceButtonPushed(app, event)
end

% Clicked callback: PushTool
function PushToolClicked(app, event)
% filter = {'*.pdf';'*.jpg';'*.png'};
% [filename, filepath] = uiputfile(filter);
% if ischar(filename)
% exportapp(app.figure1,[filepath filename]);
% end
filename = sprintf('%s_%s.png',regexprep(app.figure1.Name,' +',''), datestr(now(),'yymmdd_HHMMSS'));
filepath = fileparts(which([mfilename,'.mlapp']));
exportapp(app.figure1, fullfile(filepath,filename))
end

% Menu selected function: Menu_2
function Menu_2Selected(app, event)
closereq;
end

% Button pushed function: Button
function ButtonPushed(app, event)
cla(app.axes1) % очищаем оси
cla(app.axes2) % очищаем оси
title(app.axes2,'')
app.save.Enable = 'off';
end

% Menu selected function: Menu_3
function Menu_3Selected(app, event)
myicon = imread('logo3.jpg');
chr = ['NoClear' newline newline 'Автор: Максим Рожков' newline newline 'Контакты: mahagon.here@gmail.com' newline newline 'СибГУТИ'];
msgbox(chr, 'О программе','custom',myicon);
end

% Value changed function: NoiseMetod
function NoiseMetodValueChanged(app, event)
value = app.NoiseMetod.Value;
switch value
case 'salt & pepper'
app.text2_2.Text = 'Интенсивность шума';
app.noise_param.Value = num2str(0.05);
case 'gaussian'
app.text2_2.Text = 'Дисперсия шума';
app.noise_param.Value = num2str(0.01);
case 'speckle'
app.text2_2.Text = 'Интенсивность шума';
app.noise_param.Value = num2str(0.05);
end
end

% Button pushed function: btn_img_denoice
function btn_img_denoiceButtonPushed(app, event)
h = msgbox('Идет обработка...');
value = app.pop_w_2.Value;
n = str2double( app.pop_n_2.Value );
switch value
case 'median'
if n < 3 % если парметр меньше 3
n = 3; % ставим его 3, т.к. меньше нельзя
end
app.imgF = app.imgN;
i = 1:size(app.imgN,3);
for i = 1:size(app.imgN,3) % фильтруем каждый цветовой слой
app.imgF(:,:,i) = medfilt2(app.imgN(:,:,i),[n,n]);
end
otherwise
tmp = wdenoise2(app.imgN,n,'Wavelet',value,'ColorSpace','Original');
app.imgF = cast(tmp, class(app.img) );
end
image(app.ImgFilt, app.imgF);
xlim(app.ImgFilt,[1 size(app.imgF, 2)])
ylim(app.ImgFilt,[1 size(app.imgF, 1)])
close(h)
end

% Button pushed function: WievOrig
function WievOrigButtonPushed(app, event)
imshow(app.img);
end

% Button pushed function: WievOrig_2
function WievOrig_2ButtonPushed(app, event)
imshow(app.imgN);
end

% Button pushed function: WievOrig_3
function WievOrig_3ButtonPushed(app, event)
imshow(app.imgF);
end

% Button pushed function: Button_2
function Button_2Pushed(app, event)
cla(app.ImgIn) % очищаем оси
cla(app.ImgNoise) % очищаем оси
cla(app.ImgFilt) % очищаем оси
end

% Selection changed function: ButtonGroup
function ButtonGroupSelectionChanged(app, event)
selectedButton = app.ButtonGroup.SelectedObject;
html = app.HTML;
value1 = app.ButtonGroup.SelectedObject;
switch value1
case app.haarButton
html.HTMLSource = 'haar.html';
case app.Button_3
html.HTMLSource = 'intro.html';
case app.dbButton
html.HTMLSource = 'd.html';
case app.symButton
html.HTMLSource = 'sy.html';
case app.coif4Button
html.HTMLSource = 'coif.html';
case app.fk4Button
html.HTMLSource = 'fk.html';
end
end

% Button pushed function: Button_9
function Button_9Pushed(app, event)
global
 
w1
app.Lamp.Color = 'red';
app.Label_2.Visible='on';
Fs = 44100;
nBits = 16;
nChannels = 1;
ID = -1; % default audio input device
recObj = audiorecorder(Fs,nBits,nChannels,ID);
recordblocking(recObj,4);
app.Lamp.Color = 'green';
app.Label_2.Visible='off';
w1 = getaudiodata(recObj);
% filename = sprintf('recorded_voice_%s.wav', datestr(now, 'mmmm,dd yyyy'));
% audiowrite(filename, w1, Fs);
app.Button_10.Enable = 'on';
end

% Button pushed function: save
function saveButtonPushed(app, event)
[file,path] = uiputfile('*.wav', 'Сохранить отчищенный сигнал...');
if isnumeric(file)
return; %пользователь отменил
end
filename = fullfile(path, file);
audiowrite(filename, app.yd, 41000);
end

% Button pushed function: Button_10
function Button_10Pushed(app, event)
global w1
[file,path] = uiputfile('*.wav', 'Сохранить записанный сигнал...');
if isnumeric(file)
return; %пользователь отменил
end
filename = fullfile(path, file);
audiowrite(filename, w1, 41000);
app.Button_10.Enable = 'off';
end

% Button pushed function: Button_11
function Button_11Pushed(app, event)
[file_fromwavelet] = uigetfile({'*.wav'},'File Selector');
[app.cleanAudio,app.fsd] = audioread(file_fromwavelet);
app.clicked_1 = 1;
assignin('base','cleanAudio',app.cleanAudio);
end

% Button pushed function: Button_12
function Button_12Pushed(app, event)
sound(app.cleanAudio, app.fsd)
end

% Button pushed function: Button_13
function Button_13Pushed(app, event)
[file_noise] = uigetfile({'*.wav'},'File Selector');
[app.noiseAudio,app.fsd] = audioread(file_noise);
app.clicked_2=1;
assignin('base','noiseAudio',app.noiseAudio);
end

% Button pushed function: Button_14
function Button_14Pushed(app, event)
sound(app.noiseAudio,app.fsd)
end

% Button pushed function: Button_15
function Button_15Pushed(app, event)
if app.clicked_1 == 1 && app.clicked_2 == 1

ind = randi(numel(app.noiseAudio) - numel(app.cleanAudio) + 1, 1, 1);
assignin('base','ind',ind);

noiseSegment = app.noiseAudio(ind:ind + numel(app.cleanAudio) - 1);
assignin('base','noiseSegment',noiseSegment);

speechPower = sum(app.cleanAudio.^2);
assignin('base','speechPower',speechPower);
noisePower = sum(noiseSegment.^2);
assignin('base','noisePower',noisePower);
app.noisyAudio = app.cleanAudio + sqrt(speechPower/noisePower) * noiseSegment;
assignin('base','noisyAudio',app.noisyAudio);
sound(app.noisyAudio,app.fsd)

else
msgbox('Вы еще не загрузили файлы сигнала и шума!', 'Ошибка','error');
end
assignin('base','noisyAudio',app.noisyAudio);
end

% Button pushed function: Button_16
function Button_16Pushed(app, event)
if app.clicked_1 == 1 && app.clicked_2 == 1
gt = (1/app.fsd) * (0:numel(app.cleanAudio)-1);

subplot(2,1,1)
plot(gt,app.cleanAudio)
title("Чистый сигнал")
grid on

subplot(2,1,2)
plot(gt, app.noisyAudio)
title("Зашумленный сигнал")
xlabel("Время (с)")
grid on
else
msgbox('Вы еще не загрузили файлы сигнала и шума!', 'Ошибка','error');
end
end

% Button pushed function: Button_17
function Button_17Pushed(app, event)
app.clicked_1 = 0;
app.clicked_2 = 0;
end

% Button pushed function: Button_18
function Button_18Pushed(app, event)
app.dataFolder = fullfile(pwd,'commonvoice');
assignin('base','dataFolder',app.dataFolder);
app.adsTrain = audioDatastore(fullfile(app.dataFolder,'train'),'IncludeSubfolders',true);
assignin('base','adsTrain',app.adsTrain);
reduceDataset = true;

if reduceDataset
app.adsTrain = shuffle(app.adsTrain);
assignin('base','adsTrain',app.adsTrain);
app.adsTrain = subset(app.adsTrain, 1:300); % все из-за возможностей компьютера
assignin('base','adsTrain',app.adsTrain);
end
assignin('base','adsTrain',app.adsTrain);

[app.audio,app.adsTrainInfo] = read(app.adsTrain);
assignin('base','adsTrain',app.adsTrain);
assignin('base','audio',app.audio);
assignin('base','adsTrainInfo',app.adsTrainInfo);
sound(app.audio,app.adsTrainInfo.SampleRate)
 
app.clicked_3 = 1;
end

% Button pushed function: Button_19
function Button_19Pushed(app, event)
figure
tt = (1/app.adsTrainInfo.SampleRate) * (0:numel(app.audio)-1);
plot(tt,app.audio)
title("Пример речевого сигнала")
xlabel("Время (с)")
grid on
end

% Button pushed function: Button_20
function Button_20Pushed(app, event)
if app.clicked_2 == 1 && app.clicked_3 == 1

windowLength = 256;
assignin('base','windowLength',windowLength);
app.win = hamming(windowLength,"periodic");
assignin('base','win',app.win);
app.overlap = round(0.75 * windowLength);
assignin('base','overlap',app.overlap);
app.ffTLength = windowLength;
assignin('base','ffTLength',app.ffTLength);
inputFs = 48e3;
assignin('base','inputFs',inputFs);
fs_stft = 8e3;
assignin('base','fs',fs_stft);
app.numFeatures = app.ffTLength/2 + 1;
assignin('base','numFeatures',app.numFeatures);
app.numSegments = 8;
assignin('base','numSegments',app.numSegments);

app.src = dsp.SampleRateConverter("InputSampleRate",inputFs, ...
"OutputSampleRate",fs_stft, ...
"Bandwidth",7920);
assignin('base','src',app.src);

audio_stft = read(app.adsTrain);
assignin('base','audio',app.audio);

app.decimationFactor = inputFs/fs_stft;
assignin('base','decimationFactor',app.decimationFactor);
L = floor(numel(audio_stft)/app.decimationFactor);
assignin('base','L',L);
audio_stft = audio_stft(1:app.decimationFactor*L);
assignin('base','audio',app.audio);

audio_stft = app.src(audio_stft);
assignin('base','audio',app.audio);
reset(app.src)
assignin('base','audio',app.audio);

randind = randi(numel(app.noiseAudio) - numel(audio_stft),[1 1]);
assignin('base','randind',randind);
noiseSegment = app.noiseAudio(randind : randind + numel(audio_stft) - 1);
assignin('base','noiseSegment',noiseSegment);

noisePower = sum(noiseSegment.^2);
assignin('base','noisePower',noisePower);
cleanPower = sum(audio_stft.^2);
assignin('base','cleanPower',cleanPower);
noiseSegment = noiseSegment .* sqrt(cleanPower/noisePower);
assignin('base','noiseSegment',noiseSegment);
app.noisyAudio = audio_stft + noiseSegment;
assignin('base','noisyAudio',app.noisyAudio);

cleanSTFT = stft(audio_stft,'Window',app.win,'OverlapLength',app.overlap,'FFTLength',app.ffTLength);
cleanSTFT = abs(cleanSTFT(app.numFeatures-1:end,:));
assignin('base','cleanSTFT',cleanSTFT);
noisySTFT = stft(app.noisyAudio,'Window',app.win,'OverlapLength',app.overlap,'FFTLength',app.ffTLength);
noisySTFT = abs(noisySTFT(app.numFeatures-1:end,:));
assignin('base','noisySTFT',noisySTFT);

noisySTFT = [noisySTFT(:,1:app.numSegments - 1), noisySTFT];
assignin('base','noisySTFT',noisySTFT);
stftSegments = zeros(app.numFeatures, app.numSegments , size(noisySTFT,2) - app.numSegments + 1);
assignin('base','stftSegments',stftSegments);
for index = 1:size(noisySTFT,2) - app.numSegments + 1
stftSegments(:,:,index) = (noisySTFT(:,index:index + app.numSegments - 1));
end
assignin('base','stftSegments',stftSegments);

app.targets = cleanSTFT;
assignin('base','targets',app.targets);
size(app.targets)
assignin('base','targets',app.targets);

app.predictors = stftSegments;
assignin('base','predictors',app.predictors);
size(app.predictors)
assignin('base','predictors',app.predictors);

mbb = msgbox('Инициализация прошла успешно');
set(mbb, 'position', [525 420 200 50]);
thh = findall(mbb, 'Type', 'Text');
thh.FontSize = 12;
else
mb = msgbox('Вы не загрузили шум или файл датасета','Внимательно','warn');
set(mb, 'position', [525 420 300 70]);
th = findall(mb, 'Type', 'Text');
th.FontSize = 12;
end
end

% Button pushed function: Button_21
function Button_21Pushed(app, event)
%reset(app.adsTrain)
T = tall(app.adsTrain);
assignin('base','T',T);
addAttachedFiles(gcp(), 'HelperGenerateSpeechDenoisingFeatures')

noise = audioread('2.wav');
inputFss = 48e3;
fss = 8e3;

src1 = dsp.SampleRateConverter("InputSampleRate",inputFss, ...
"OutputSampleRate",fss, ...
 
"Bandwidth",7920);


[app.targets,app.predictors] = cellfun(@(x)HelperGenerateSpeechDenoisingFeatures(x,noise,src1),T,"UniformOutput",false);
assignin('base','targets',app.targets);
assignin('base','predictors',app.predictors);
[app.targets,app.predictors] = gather(app.targets,app.predictors);

app.predictors = cat(3,app.predictors{:});
assignin('base','predictors',app.predictors);
app.noisyMean = mean(app.predictors(:));
assignin('base','noisyMean',app.noisyMean);
app.noisyStd = std(app.predictors(:));
assignin('base','noisyStd',app.noisyStd);
app.predictors(:) = (app.predictors(:) - app.noisyMean)/app.noisyStd;
assignin('base','predictors',app.predictors);

app.targets = cat(2,app.targets{:});
assignin('base','targets',app.targets);
app.cleanMean = mean(app.targets(:));
assignin('base','cleanMean',app.cleanMean);
app.cleanStd = std(app.targets(:));
assignin('base','cleanStd',app.cleanStd);
app.targets(:) = (app.targets(:) - app.cleanMean)/app.cleanStd;
assignin('base','targets',app.targets);

app.predictors = reshape(app.predictors,size(app.predictors,1),size(app.predictors,2),1,size(app.predictors,3));
assignin('base','predictors',app.predictors);
app.targets = reshape(app.targets,1,1,size(app.targets,1),size(app.targets,2));
assignin('base','targets',app.targets);

inds = randperm(size(app.predictors,4));
assignin('base','inds',inds);
L = round(0.99 * size(app.predictors,4));
assignin('base','L',L);

trainPredictors = app.predictors(:,:,:,inds(1:L));
assignin('base','trainPredictors',trainPredictors);
trainTargets = app.targets(:,:,:,inds(1:L));
assignin('base','trainTargets',trainTargets);

validatePredictors = app.predictors(:,:,:,inds(L+1:end));
assignin('base','validatePredictors',validatePredictors);
validateTargets = app.targets(:,:,:,inds(L+1:end));
assignin('base','validateTargets',validateTargets);

mbb = msgbox('Инициализация прошла успешно');
set(mbb, 'position', [525 420 200 50]);
thh = findall(mbb, 'Type', 'Text');
thh.FontSize = 12;







dfolder = fullfile('commonvoice');
adsTest = audioDatastore(fullfile(dfolder,'train'),'IncludeSubfolders',true);
[app.cleanAudio,adsTestInfo] = read(adsTest);
L = floor(numel(app.cleanAudio)/app.decimationFactor);
app.cleanAudio = app.cleanAudio(1:app.decimationFactor*L);
app.cleanAudio = app.src(app.cleanAudio);
reset(app.src)
noise = app.noiseAudio;
randind = randi(numel(noise) - numel(app.cleanAudio), [1 1]);
noiseSegment = noise(randind : randind + numel(app.cleanAudio) - 1);
noisePower = sum(noiseSegment.^2);
cleanPower = sum(app.cleanAudio.^2);
noiseSegment = noiseSegment .* sqrt(cleanPower/noisePower);
app.noisyAudio = app.cleanAudio + noiseSegment;
noisySTFT = stft(app.noisyAudio,'Window',app.win,'OverlapLength',app.overlap,'FFTLength',app.ffTLength);
noisyPhase = angle(noisySTFT(app.numFeatures-1:end,:));
noisySTFT = abs(noisySTFT(app.numFeatures-1:end,:));
noisySTFT = [noisySTFT(:,1:app.numSegments-1) noisySTFT];
app.predictors = zeros(app.numFeatures, app.numSegments , size(noisySTFT,2) - app.numSegments + 1);
for index = 1:(size(noisySTFT,2) - app.numSegments + 1)
app.predictors(:,:,index) = noisySTFT(:,index:index + app.numSegments - 1);
end
app.predictors(:) = (app.predictors(:) - noisyMean) / noisyStd;
app.predictors = reshape(app.predictors, [app.numFeatures,app.numSegments,1,size(app.predictors,3)]);
STFTFullyConnected = predict(denoiseNetFullyConnected, app.predictors);
STFTFullyConvolutional = predict(denoiseNetFullyConvolutional, app.predictors);
STFTFullyConnected(:) = cleanStd * STFTFullyConnected(:) + cleanMean;
STFTFullyConvolutional(:) = cleanStd * STFTFullyConvolutional(:) + cleanMean;
STFTFullyConnected = STFTFullyConnected.* exp(1j*noisyPhase);
STFTFullyConnected = [conj(STFTFullyConnected(end-1:-1:2,:)); STFTFullyConnected];
STFTFullyConvolutional = squeeze(STFTFullyConvolutional) .* exp(1j*noisyPhase);


STFTFullyConvolutional = [conj(STFTFullyConvolutional(end-1:-1:2,:)) ; STFTFullyConvolutional];

 app.var;
 app.var1;

 denoisedAudioFullyConnected = istft(STFTFullyConnected, ...
 'Window',app.win,'OverlapLength',app.overlap, ...
 'FFTLength',app.ffTLength,'ConjugateSymmetric',true);

 denoisedAudioFullyConvolutional = istft(STFTFullyConvolutional, ...
 'Window',app.win,'OverlapLength',app.overlap, ...
 'FFTLength',app.ffTLength,'ConjugateSymmetric',true);

 tt = (1/app.fsd) * (0:numel(denoisedAudioFullyConnected)-1);

 figure

 subplot(4,1,1)
 plot(tt,app.cleanAudio(1:numel(denoisedAudioFullyConnected)))
 title("Чистый сигнал")
 grid on

 subplot(4,1,2)
 plot(tt,app.noisyAudio(1:numel(denoisedAudioFullyConnected)))
 title("Зашумленный сигнал")
 grid on

 subplot(4,1,3)
 plot(tt,denoisedAudioFullyConnected)
 title("Очищеный сигнал (Полностью подключенные слои)")
 grid on

 subplot(4,1,4)
 plot(tt,denoisedAudioFullyConvolutional)
 title("Очищенный сигнал (Сверточные слои)")
 grid on
 xlabel("Время (с)")
nd
 Button pushed function: Button_22
unction Button_22Pushed(app, event)
ayers = [
mageInputLayer([app.numFeatures,app.numSegments])
ullyConnectedLayer(1024)
atchNormalizationLayer
eluLayer
ullyConnectedLayer(1024)
atchNormalizationLayer
eluLayer
ullyConnectedLayer(app.numFeatures)
egressionLayer
;
iniBatchSize = 128;
ptions = trainingOptions("adam", ...
MaxEpochs,3, ...
InitialLearnRate",1e-5,...
MiniBatchSize",miniBatchSize, ...
Shuffle","every-epoch", ...
Plots","training-progress", ...
Verbose",false, ...
ValidationFrequency",floor(size(trainPredictors,4)/miniBatchSize), ...
LearnRateSchedule","piecewise", ...
LearnRateDropFactor",0.9, ...
LearnRateDropPeriod",1, ...
ValidationData",{validatePredictors,validateTargets});
 doTraining = false;

 if doTraining
 denoiseNetFullyConnected = trainNetwork(trainPredictors,trainTargets,layers,options);
 else
url = 'http://ssd.mathworks.com/supportfiles/audio/SpeechDenoising...';
downloadNetFolder = 'd:\GetClear-stableTWO\nn';
netFolder = fullfile(downloadNetFolder,'SpeechDenoising');
if ~exist(netFolder,'dir')
disp('Downloading pretrained network (1 file - 8 MB) ...')
unzip(url,downloadNetFolder)
end
s = load(fullfile(netFolder,"denoisenet.mat"));
denoiseNetFullyConnected = s.denoiseNetFullyConnected;
app.cleanMean = s.cleanMean;
app.cleanStd = s.cleanStd;
app.noisyMean = s.noisyMean;
app.noisyStd = s.noisyStd;
end

numWeights = 0;

for index = 1:numel(denoiseNetFullyConnected.Layers)
if isa(denoiseNetFullyConnected.Layers(index),"nnet.cnn.layer.FullyConnectedLayer")
numWeights = numWeights + numel(denoiseNetFullyConnected.Layers(index).Weights);
end
end
fprintf("The number of weights is %d.\n",numWeights);
end
end

% Component initialization
methods (Access = private)

% Create UIFigure and components
function createComponents(app)

% Create figure1 and hide until all components are created
app.figure1 = uifigure('Visible', 'off');
app.figure1.AutoResizeChildren = 'off';
app.figure1.Position = [100 100 906 838];
app.figure1.Name = 'NoClear';
app.figure1.Icon = 'Action_MATLAB_24.png';
app.figure1.Resize = 'off';

% Create Menu_3
app.Menu_3 = uimenu(app.figure1);
app.Menu_3.MenuSelectedFcn = createCallbackFcn(app, @Menu_3Selected, true);
app.Menu_3.Text = 'О программе';

% Create Menu_2
app.Menu_2 = uimenu(app.figure1);
app.Menu_2.MenuSelectedFcn = createCallbackFcn(app, @Menu_2Selected, true);
app.Menu_2.Text = 'Выход';

% Create Toolbar
app.Toolbar = uitoolbar(app.figure1);

% Create PushTool
app.PushTool = uipushtool(app.Toolbar);
app.PushTool.Tooltip = {'Скриншот'};
app.PushTool.ClickedCallback = createCallbackFcn(app, @PushToolClicked, true);
app.PushTool.Icon = 'Snapshot_16.png';

% Create TabGroup
app.TabGroup = uitabgroup(app.figure1);
app.TabGroup.AutoResizeChildren = 'off';
 
app.TabGroup.Position = [1 -1 907 840];

% Create Tab
app.Tab = uitab(app.TabGroup);
app.Tab.AutoResizeChildren = 'off';
app.Tab.Tooltip = {'Удаление шума из сигнала с помощью вейвлетов'};
app.Tab.Title = 'Звук';

% Create Panel
app.Panel = uipanel(app.Tab);
app.Panel.AutoResizeChildren = 'off';
app.Panel.Title = 'Очистка звукового сигнала';
app.Panel.FontSize = 14;
app.Panel.Position = [13 21 881 785];

% Create Panel_2
app.Panel_2 = uipanel(app.Panel);
app.Panel_2.AutoResizeChildren = 'off';
app.Panel_2.Title = 'Воспроизведение';
app.Panel_2.FontSize = 13;
app.Panel_2.Position = [12 572 179 175];

% Create btn_play
app.btn_play = uibutton(app.Panel_2, 'push');
app.btn_play.ButtonPushedFcn = createCallbackFcn(app, @btn_play_Callback, true);
app.btn_play.Icon = 'Play_24.png';
app.btn_play.FontWeight = 'bold';
app.btn_play.Position = [14 60 152 37];
app.btn_play.Text = 'Прослушать';

% Create btn_stop
app.btn_stop = uibutton(app.Panel_2, 'push');
app.btn_stop.ButtonPushedFcn = createCallbackFcn(app, @btn_stopButtonPushed, true);
app.btn_stop.Icon = 'Stop_24.png';
app.btn_stop.FontWeight = 'bold';
app.btn_stop.Position = [14 13 152 37];
app.btn_stop.Text = 'Стоп';

% Create btn_open
app.btn_open = uibutton(app.Panel_2, 'push');
app.btn_open.ButtonPushedFcn = createCallbackFcn(app, @btn_open_Callback, true);
app.btn_open.Icon = 'Open_24.png';
app.btn_open.FontAngle = 'italic';
app.btn_open.Position = [13 106 152 37];
app.btn_open.Text = 'Открыть файл...';

% Create Panel_3
app.Panel_3 = uipanel(app.Panel);
app.Panel_3.AutoResizeChildren = 'off';
app.Panel_3.Title = 'Выбор параметров';
app.Panel_3.FontSize = 13;
app.Panel_3.Position = [303 572 380 175];

% Create text2
app.text2 = uilabel(app.Panel_3);
app.text2.HorizontalAlignment = 'center';
app.text2.Position = [155 112 119 22];
app.text2.Text = 'Мощность шума, дБ';

% Create edit_ndb
app.edit_ndb = uieditfield(app.Panel_3, 'text');
app.edit_ndb.ValueChangedFcn = createCallbackFcn(app, @edit_ndb_Callback, true);
app.edit_ndb.HorizontalAlignment = 'center';
app.edit_ndb.Position = [162 81 101 33];
app.edit_ndb.Value = '-10';

% Create btn_noice
app.btn_noice = uibutton(app.Panel_3, 'push');
app.btn_noice.ButtonPushedFcn = createCallbackFcn(app, @btn_noice_Callback, true);
app.btn_noice.Icon = 'Add_24.png';
app.btn_noice.Position = [7 81 151 33];
app.btn_noice.Text = 'Добавить шум';

% Create btn_denoice
app.btn_denoice = uibutton(app.Panel_3, 'push');
app.btn_denoice.ButtonPushedFcn = createCallbackFcn(app, @btn_denoice_Callback, true);
app.btn_denoice.Icon = 'Clear_24.png';
app.btn_denoice.Position = [7 35 151 33];
app.btn_denoice.Text = 'Убрать шум';

% Create pop_w
app.pop_w = uidropdown(app.Panel_3);
app.pop_w.Items = {'sym4', 'sym1', 'sym2', 'sym3', 'haar', 'db1', 'db2', 'db3', 'coif4', 'fk4'};
app.pop_w.BackgroundColor = [1 1 1];
app.pop_w.Position = [270 83 101 28];
app.pop_w.Value = 'sym4';

% Create text4
app.text4 = uilabel(app.Panel_3);
app.text4.HorizontalAlignment = 'center';
app.text4.Position = [269 112 101 22];
app.text4.Text = 'Тип вейвлета';

% Create text5
app.text5 = uilabel(app.Panel_3);
app.text5.HorizontalAlignment = 'center';
app.text5.VerticalAlignment = 'top';
app.text5.Position = [294 60 52 22];
app.text5.Text = 'Уровень';

% Create pop_n
app.pop_n = uidropdown(app.Panel_3);
app.pop_n.Items = {'1'};
app.pop_n.BackgroundColor = [1 1 1];
app.pop_n.Position = [294 37 51 29];
app.pop_n.Value = '1';

% Create save
app.save = uibutton(app.Panel_3, 'push');
app.save.ButtonPushedFcn = createCallbackFcn(app, @saveButtonPushed, true);
app.save.Icon = 'Save_16.png';
app.save.Enable = 'off';
app.save.Position = [173 40 101 22];
app.save.Text = 'Сохранить';

% Create Panel_5
app.Panel_5 = uipanel(app.Panel);
app.Panel_5.AutoResizeChildren = 'off';
app.Panel_5.Title = 'Графики';
app.Panel_5.Position = [694 572 175 175];

% Create Button
 
app.Button = uibutton(app.Panel_5, 'push');
app.Button.ButtonPushedFcn = createCallbackFcn(app, @ButtonPushed, true);
app.Button.Icon = 'RefreshPlot_24.png';
app.Button.Position = [14 59 148 35];
app.Button.Text = 'Очистить';

% Create Panel_10
app.Panel_10 = uipanel(app.Panel);
app.Panel_10.AutoResizeChildren = 'off';
app.Panel_10.Title = 'Запись';
app.Panel_10.Position = [200 572 93 176];

% Create Lamp
app.Lamp = uilamp(app.Panel_10);
app.Lamp.Position = [37 10 20 20];

% Create Button_9
app.Button_9 = uibutton(app.Panel_10, 'push');
app.Button_9.ButtonPushedFcn = createCallbackFcn(app, @Button_9Pushed, true);
app.Button_9.Icon = 'Run_24.png';
app.Button_9.Position = [9 112 75 37];
app.Button_9.Text = 'Запись';

% Create Label_2
app.Label_2 = uilabel(app.Panel_10);
app.Label_2.HorizontalAlignment = 'center';
app.Label_2.Visible = 'off';
app.Label_2.Position = [4 37 84 31];
app.Label_2.Text = 'Идет запись...';

% Create Button_10
app.Button_10 = uibutton(app.Panel_10, 'push');
app.Button_10.ButtonPushedFcn = createCallbackFcn(app, @Button_10Pushed, true);
app.Button_10.Icon = 'Save_16.png';
app.Button_10.Enable = 'off';
app.Button_10.Position = [7 77 80 22];
app.Button_10.Text = '';

% Create axes1
app.axes1 = uiaxes(app.Panel);
title(app.axes1, 'Исходный сигнал')
xlabel(app.axes1, 'Время(сек)')
app.axes1.XGrid = 'on';
app.axes1.YGrid = 'on';
app.axes1.Position = [21 312 840 250];

% Create axes2
app.axes2 = uiaxes(app.Panel);
xlabel(app.axes2, 'Время(сек)')
app.axes2.XGrid = 'on';
app.axes2.YGrid = 'on';
app.axes2.Position = [21 26 840 250];

% Create Tab_2
app.Tab_2 = uitab(app.TabGroup);
app.Tab_2.AutoResizeChildren = 'off';
app.Tab_2.Tooltip = {'Удаление шума изображения с помощью вейвлетов'};
app.Tab_2.Title = 'Изображение';

% Create Panel_6
app.Panel_6 = uipanel(app.Tab_2);
app.Panel_6.AutoResizeChildren = 'off';
app.Panel_6.Title = 'Очистка изображения';
app.Panel_6.FontSize = 14;
app.Panel_6.Position = [26 144 858 614];

% Create Panel_7
app.Panel_7 = uipanel(app.Panel_6);
app.Panel_7.AutoResizeChildren = 'off';
app.Panel_7.Title = 'Настройка';
app.Panel_7.FontSize = 13;
app.Panel_7.Position = [39 402 776 157];

% Create text2_2
app.text2_2 = uilabel(app.Panel_7);
app.text2_2.HorizontalAlignment = 'center';
app.text2_2.Position = [211 112 141 22];
app.text2_2.Text = 'Интенсивность шума, %';

% Create noise_param
app.noise_param = uieditfield(app.Panel_7, 'text');
app.noise_param.ValueChangedFcn = createCallbackFcn(app, @noise_paramValueChanged, true);
app.noise_param.HorizontalAlignment = 'center';
app.noise_param.Position = [230 80 101 33];
app.noise_param.Value = '0.05';

% Create btn_img_denoice
app.btn_img_denoice = uibutton(app.Panel_7, 'push');
app.btn_img_denoice.ButtonPushedFcn = createCallbackFcn(app, @btn_img_denoiceButtonPushed, true);
app.btn_img_denoice.Icon = 'Clear_24.png';
app.btn_img_denoice.Position = [410 47 101 33];
app.btn_img_denoice.Text = 'Убрать шум';

% Create pop_w_2
app.pop_w_2 = uidropdown(app.Panel_7);
app.pop_w_2.Items = {'bior4.4', 'db2', 'db4', 'haar', 'fk4', 'median'};
app.pop_w_2.BackgroundColor = [1 1 1];
app.pop_w_2.Position = [543 49 107 28];
app.pop_w_2.Value = 'bior4.4';

% Create pop_n_2
app.pop_n_2 = uidropdown(app.Panel_7);
app.pop_n_2.Items = {'1'};
app.pop_n_2.BackgroundColor = [1 1 1];
app.pop_n_2.Position = [676 48 51 29];
app.pop_n_2.Value = '1';

% Create Label
app.Label = uilabel(app.Panel_7);
app.Label.HorizontalAlignment = 'center';
app.Label.Position = [250 50 59 22];
app.Label.Text = 'Тип шума';

% Create NoiseMetod
app.NoiseMetod = uidropdown(app.Panel_7);
app.NoiseMetod.Items = {'salt & pepper', 'gaussian', 'speckle'};
app.NoiseMetod.ValueChangedFcn = createCallbackFcn(app, @NoiseMetodValueChanged, true);
app.NoiseMetod.Position = [230 17 103 35];
app.NoiseMetod.Value = 'salt & pepper';

% Create text5_2
app.text5_2 =
 
uilabel(app.Panel_7);
app.text5_2.HorizontalAlignment = 'center';
app.text5_2.Position = [675 79 52 22];
app.text5_2.Text = 'Уровень';

% Create btn_open_img
app.btn_open_img = uibutton(app.Panel_7, 'push');
app.btn_open_img.ButtonPushedFcn = createCallbackFcn(app, @btn_open_imgButtonPushed, true);
app.btn_open_img.Icon = 'Open_24.png';
app.btn_open_img.Position = [29 78 136 37];
app.btn_open_img.Text = 'Выбрать файл...';

% Create btn_img_noice
app.btn_img_noice = uibutton(app.Panel_7, 'push');
app.btn_img_noice.ButtonPushedFcn = createCallbackFcn(app, @btn_img_noiceButtonPushed, true);
app.btn_img_noice.Icon = 'Add_16.png';
app.btn_img_noice.Position = [38 16 117 37];
app.btn_img_noice.Text = 'Добавить шум';

% Create text4_2
app.text4_2 = uilabel(app.Panel_7);
app.text4_2.HorizontalAlignment = 'center';
app.text4_2.Position = [541 79 102 22];
app.text4_2.Text = 'Тип фильтра';

% Create WievOrig
app.WievOrig = uibutton(app.Panel_6, 'push');
app.WievOrig.ButtonPushedFcn = createCallbackFcn(app, @WievOrigButtonPushed, true);
app.WievOrig.Icon = 'Zoom_In_24.png';
app.WievOrig.Position = [134 360 41 32];
app.WievOrig.Text = '';

% Create WievOrig_2
app.WievOrig_2 = uibutton(app.Panel_6, 'push');
app.WievOrig_2.ButtonPushedFcn = createCallbackFcn(app, @WievOrig_2ButtonPushed, true);
app.WievOrig_2.Icon = 'Zoom_In_24.png';
app.WievOrig_2.Position = [408 360 41 32];
app.WievOrig_2.Text = '';

% Create WievOrig_3
app.WievOrig_3 = uibutton(app.Panel_6, 'push');
app.WievOrig_3.ButtonPushedFcn = createCallbackFcn(app, @WievOrig_3ButtonPushed, true);
app.WievOrig_3.Icon = 'Zoom_In_24.png';
app.WievOrig_3.Position = [677 360 41 32];
app.WievOrig_3.Text = '';

% Create Button_2
app.Button_2 = uibutton(app.Panel_6, 'push');
app.Button_2.ButtonPushedFcn = createCallbackFcn(app, @Button_2Pushed, true);
app.Button_2.Icon = 'RefreshPlot_24.png';
app.Button_2.Position = [351 20 148 35];
app.Button_2.Text = 'Очистить';

% Create ImgIn
app.ImgIn = uiaxes(app.Panel_6);
title(app.ImgIn, 'Оригинал')
app.ImgIn.XTick = [];
app.ImgIn.YTick = [];
app.ImgIn.Box = 'on';
app.ImgIn.Position = [18 91 273 268];

% Create ImgNoise
app.ImgNoise = uiaxes(app.Panel_6);
title(app.ImgNoise, 'С шумом')
app.ImgNoise.XTick = [];
app.ImgNoise.YTick = [];
app.ImgNoise.Box = 'on';
app.ImgNoise.Position = [289 91 273 268];

% Create ImgFilt
app.ImgFilt = uiaxes(app.Panel_6);
title(app.ImgFilt, 'После фильтрации')
app.ImgFilt.XTick = [];
app.ImgFilt.YTick = [];
app.ImgFilt.Box = 'on';
app.ImgFilt.Position = [561 91 273 268];

% Create Tab_4
app.Tab_4 = uitab(app.TabGroup);
app.Tab_4.Tooltip = {'Устранение шумов с использованием сетей глубокого обучения'};
app.Tab_4.Title = 'Глубокое обучение';

% Create Panel_11
app.Panel_11 = uipanel(app.Tab_4);
app.Panel_11.Tooltip = {'Загрузить датасет и '; 'прослушать случайную запись'};
app.Panel_11.Title = 'Очистка сигнала от шума с помощью сетей глубокого обучения';
app.Panel_11.FontSize = 14;
app.Panel_11.Position = [13 15 881 777];

% Create Panel_12
app.Panel_12 = uipanel(app.Panel_11);
app.Panel_12.Tooltip = {'Здесь можно загрузить аудифофалы в формтае .wav. Вы можете добавить шум к своему сигналу (SNR = 0дБ).'};
app.Panel_12.Title = 'Загрузка/Обработка сигнала';
app.Panel_12.FontSize = 13;
app.Panel_12.Position = [13 504 251 237];

% Create Button_11
app.Button_11 = uibutton(app.Panel_12, 'push');
app.Button_11.ButtonPushedFcn = createCallbackFcn(app, @Button_11Pushed, true);
app.Button_11.Icon = 'Import_24.png';
app.Button_11.Position = [24 161 100 33];
app.Button_11.Text = 'Загрузить';

% Create Button_12
app.Button_12 = uibutton(app.Panel_12, 'push');
app.Button_12.ButtonPushedFcn = createCallbackFcn(app, @Button_12Pushed, true);
app.Button_12.Icon = 'Play_24.png';
app.Button_12.Tooltip = {'Прослушать'};
app.Button_12.Position = [136 160 42 36];
app.Button_12.Text = '';

% Create Button_13
app.Button_13 =
 
uibutton(app.Panel_12, 'push');
app.Button_13.ButtonPushedFcn = createCallbackFcn(app, @Button_13Pushed, true);
app.Button_13.Icon = 'New_24.png';
app.Button_13.Position = [24 117 100 33];
app.Button_13.Text = 'Шум';

% Create Button_14
app.Button_14 = uibutton(app.Panel_12, 'push');
app.Button_14.ButtonPushedFcn = createCallbackFcn(app, @Button_14Pushed, true);
app.Button_14.Icon = 'Play_24.png';
app.Button_14.Tooltip = {'Прослушать'};
app.Button_14.Position = [136 115 42 36];
app.Button_14.Text = '';

% Create Button_15
app.Button_15 = uibutton(app.Panel_12, 'push');
app.Button_15.ButtonPushedFcn = createCallbackFcn(app, @Button_15Pushed, true);
app.Button_15.Icon = 'Tools_24.png';
app.Button_15.Position = [24 65 154 35];
app.Button_15.Text = 'Сигнал + шум';

% Create Button_16
app.Button_16 = uibutton(app.Panel_12, 'push');
app.Button_16.ButtonPushedFcn = createCallbackFcn(app, @Button_16Pushed, true);
app.Button_16.Icon = 'Plot_24.png';
app.Button_16.Tooltip = {'Визуализировать исходные и зашумленные сигналы'};
app.Button_16.Position = [196 65 42 131];
app.Button_16.Text = '';

% Create Button_17
app.Button_17 = uibutton(app.Panel_12, 'push');
app.Button_17.ButtonPushedFcn = createCallbackFcn(app, @Button_17Pushed, true);
app.Button_17.Icon = 'Refresh_24.png';
app.Button_17.Tooltip = {'Сбросить'};
app.Button_17.Position = [100 18 52 34];
app.Button_17.Text = '';

% Create Panel_13
app.Panel_13 = uipanel(app.Panel_11);
app.Panel_13.Tooltip = {'В этом примере используется подмножество набора данных Mozilla Common Voice для обучения и тестирования сетей глубокого обучения. Набор данных содержит записи 48 кГц испытуемых, произносящих короткие предложения'};
app.Panel_13.Title = 'Исследовать набор данных';
app.Panel_13.FontSize = 13;
app.Panel_13.Position = [283 621 176 120];

% Create Button_18
app.Button_18 = uibutton(app.Panel_13, 'push');
app.Button_18.ButtonPushedFcn = createCallbackFcn(app, @Button_18Pushed, true);
app.Button_18.Icon = 'Down_24.png';
app.Button_18.Tooltip = {'Загрузить датасет и '; 'прослушать случайную запись'};
app.Button_18.Position = [14 57 31 33];
app.Button_18.Text = '';

% Create Button_19
app.Button_19 = uibutton(app.Panel_13, 'push');
app.Button_19.ButtonPushedFcn = createCallbackFcn(app, @Button_19Pushed, true);
app.Button_19.Icon = 'AddPlot_24.png';
app.Button_19.Tooltip = {'Построить график речевого сигнала'};
app.Button_19.Position = [67 55 41 35];
app.Button_19.Text = '';

% Create Button_20
app.Button_20 = uibutton(app.Panel_13, 'push');
app.Button_20.ButtonPushedFcn = createCallbackFcn(app, @Button_20Pushed, true);
app.Button_20.Icon = 'Confirm_24.png';
app.Button_20.Tooltip = {'Генерировать целевой и прогнозирующий сигналы из одного обучающего файла'};
app.Button_20.Position = [125 56 41 35];
app.Button_20.Text = '';

% Create Button_21
app.Button_21 = uibutton(app.Panel_13, 'push');
app.Button_21.ButtonPushedFcn = createCallbackFcn(app, @Button_21Pushed, true);
app.Button_21.Icon = 'Parallel_24.png';
app.Button_21.Tooltip = {'Загрузить датасет и '; 'прослушать случайную запись'};
app.Button_21.Position = [72 8 31 33];
app.Button_21.Text = '';

% Create Panel_14
app.Panel_14 = uipanel(app.Panel_11);
app.Panel_14.Title = 'Полностью подключенные слои';
app.Panel_14.Position = [476 504 186 237];

% Create Button_22
app.Button_22 = uibutton(app.Panel_14, 'push');
app.Button_22.ButtonPushedFcn = createCallbackFcn(app, @Button_22Pushed, true);
app.Button_22.Icon = 'Append_16.png';
app.Button_22.Position = [43 163 100 36];
app.Button_22.Text = '';

% Create Tab_3
app.Tab_3 = uitab(app.TabGroup);
app.Tab_3.AutoResizeChildren = 'off';
app.Tab_3.Title = 'Теория';

% Create Panel_8
app.Panel_8 = uipanel(app.Tab_3);
app.Panel_8.AutoResizeChildren = 'off';
app.Panel_8.Title = 'Теория';
app.Panel_8.FontSize = 14;
app.Panel_8.Position = [13 15 881 786];

% Create HTML
app.HTML = uihtml(app.Panel_8);
 
app.HTML.HTMLSource = 'intro.html';
app.HTML.Position = [11 8 861 575];

% Create ButtonGroup
app.ButtonGroup = uibuttongroup(app.Panel_8);
app.ButtonGroup.AutoResizeChildren = 'off';
app.ButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @ButtonGroupSelectionChanged, true);
app.ButtonGroup.FontSize = 13;
app.ButtonGroup.Position = [11 587 170 169];

% Create dbButton
app.dbButton = uitogglebutton(app.ButtonGroup);
app.dbButton.Icon = 'C:\Users\Gaming\Downloads\GetClear-stable\GetClear-stable\icons\res\book_link.gif';
app.dbButton.Text = 'db';
app.dbButton.Position = [13 113 143 22];

% Create symButton
app.symButton = uitogglebutton(app.ButtonGroup);
app.symButton.Icon = 'C:\Users\Gaming\Downloads\GetClear-stable\GetClear-stable\icons\res\book_mat.gif';
app.symButton.Text = 'sym';
app.symButton.Position = [13 86 143 22];

% Create haarButton
app.haarButton = uitogglebutton(app.ButtonGroup);
app.haarButton.Icon = 'C:\Users\Gaming\Downloads\GetClear-stable\GetClear-stable\icons\res\book_sim.gif';
app.haarButton.Text = 'haar';
app.haarButton.Position = [13 59 143 22];

% Create coif4Button
app.coif4Button = uitogglebutton(app.ButtonGroup);
app.coif4Button.Icon = 'C:\Users\Gaming\Downloads\GetClear-stable\GetClear-stable\icons\res\bookicon.gif';
app.coif4Button.Text = 'coif4';
app.coif4Button.Position = [13 33 143 22];

% Create fk4Button
app.fk4Button = uitogglebutton(app.ButtonGroup);
app.fk4Button.Icon = 'notesicon.gif';
app.fk4Button.Text = 'fk4';
app.fk4Button.Position = [13 7 143 22];

% Create Button_3
app.Button_3 = uitogglebutton(app.ButtonGroup);
app.Button_3.Icon = 'Help_24.png';
app.Button_3.Text = '';
app.Button_3.Position = [13 140 144 22];
app.Button_3.Value = true;

% Show the figure after all components are created
app.figure1.Visible = 'on';
end
end

% App creation and deletion
methods (Access = public)

% Construct app
function app = SoundProc_App

% Create UIFigure and components
createComponents(app)

% Register the app with App Designer
registerApp(app, app.figure1)

% Execute the startup function
runStartupFcn(app, @SoundProc_OpeningFcn)

if nargout == 0
clear app
end
end

% Code that executes before app deletion
function delete(app)

% Delete UIFigure when app is deleted
delete(app.figure1)
end
end
end
