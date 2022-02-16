classdef SoundProc_App_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        figure1            matlab.ui.Figure
        Menu_3             matlab.ui.container.Menu
        Menu_2             matlab.ui.container.Menu
        Toolbar            matlab.ui.container.Toolbar
        PushTool           matlab.ui.container.toolbar.PushTool
        TabGroup           matlab.ui.container.TabGroup
        Tab                matlab.ui.container.Tab
        Panel              matlab.ui.container.Panel
        Panel_2            matlab.ui.container.Panel
        btn_play           matlab.ui.control.Button
        btn_stop           matlab.ui.control.Button
        btn_open           matlab.ui.control.Button
        Panel_3            matlab.ui.container.Panel
        text2              matlab.ui.control.Label
        edit_ndb           matlab.ui.control.EditField
        btn_noice          matlab.ui.control.Button
        btn_denoice        matlab.ui.control.Button
        pop_w              matlab.ui.control.DropDown
        text4              matlab.ui.control.Label
        text5              matlab.ui.control.Label
        pop_n              matlab.ui.control.DropDown
        Button_11          matlab.ui.control.Button
        Panel_5            matlab.ui.container.Panel
        Button             matlab.ui.control.Button
        Panel_10           matlab.ui.container.Panel
        Lamp               matlab.ui.control.Lamp
        Button_9           matlab.ui.control.Button
        Button_10          matlab.ui.control.Button
        axes1              matlab.ui.control.UIAxes
        axes2              matlab.ui.control.UIAxes
        Tab_2              matlab.ui.container.Tab
        Panel_6            matlab.ui.container.Panel
        Panel_7            matlab.ui.container.Panel
        text2_2            matlab.ui.control.Label
        noise_param        matlab.ui.control.EditField
        btn_img_denoice    matlab.ui.control.Button
        pop_w_2            matlab.ui.control.DropDown
        pop_n_2            matlab.ui.control.DropDown
        Label              matlab.ui.control.Label
        NoiseMetod         matlab.ui.control.DropDown
        text5_2            matlab.ui.control.Label
        btn_open_img       matlab.ui.control.Button
        btn_img_noice      matlab.ui.control.Button
        text4_2            matlab.ui.control.Label
        WievOrig           matlab.ui.control.Button
        WievOrig_2         matlab.ui.control.Button
        WievOrig_3         matlab.ui.control.Button
        Button_2           matlab.ui.control.Button
        WievOrig_4         matlab.ui.control.Button
        WievOrig_5         matlab.ui.control.Button
        ImgIn              matlab.ui.control.UIAxes
        ImgNoise           matlab.ui.control.UIAxes
        ImgFilt            matlab.ui.control.UIAxes
        Tab_4              matlab.ui.container.Tab
        Panel_11           matlab.ui.container.Panel
        Panel_15           matlab.ui.container.Panel
        Panel_14           matlab.ui.container.Panel
        Panel_12           matlab.ui.container.Panel
        Panel_13           matlab.ui.container.Panel
        Label_2            matlab.ui.control.Label
        Panel_16           matlab.ui.container.Panel
        Panel_17           matlab.ui.container.Panel
        btn_open_img_2     matlab.ui.control.Button
        btn_img_noice_2    matlab.ui.control.Button
        text2_3            matlab.ui.control.Label
        noise_param_2      matlab.ui.control.EditField
        Label_3            matlab.ui.control.Label
        NoiseMetod_2       matlab.ui.control.DropDown
        btn_img_denoice_2  matlab.ui.control.Button
        pop_w_3            matlab.ui.control.DropDown
        text4_3            matlab.ui.control.Label
        Button_12          matlab.ui.control.Button
        Panel_18           matlab.ui.container.Panel
        dPSNRLabel         matlab.ui.control.Label
        SSIMLabel          matlab.ui.control.Label
        dSSIMLabel         matlab.ui.control.Label
        PSNRLabel          matlab.ui.control.Label
        Label_4            matlab.ui.control.Label
        Label_5            matlab.ui.control.Label
        Label_6            matlab.ui.control.Label
        Label_7            matlab.ui.control.Label
        WievOrig_6         matlab.ui.control.Button
        WievOrig_7         matlab.ui.control.Button
        WievOrig_8         matlab.ui.control.Button
        WievOrig_9         matlab.ui.control.Button
        WievOrig_10        matlab.ui.control.Button
        ImgIn_2            matlab.ui.control.UIAxes
        ImgNoise_2         matlab.ui.control.UIAxes
        ImgFilt_2          matlab.ui.control.UIAxes
        Tab_5              matlab.ui.container.Tab
        Panel_19           matlab.ui.container.Panel
        Button_14          matlab.ui.control.Button
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
        imgDn % исходное изображение для сетей
        imgDnN % изображение с шумом
        imgDnF % отфильтрованное изображение
        denoisedRGB
        fs1 = 8000;
        net1
    end
    
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function SoundProc_OpeningFcn(app)
            movegui(app.figure1,"center");
            clc % очищаем командное окно
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
            [fname,path] = uigetfile({'*.wav; *.mp3; *.wma','Audio files (*.wav; *.mp3; *.wma)'},'Выбирете файл...');
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
            [fname,path] = uigetfile({'*.bmp; *.jpg; *.png; *.gif','Image files (*.bmp; *.jpg; *.png; *.gif'},'Выбирете файл...');
            fullname = strcat(path,fname);
            app.img = imread(fullname);
            image(app.ImgIn, app.img);
            xlim(app.ImgIn,[1 size(app.img, 2)])
            ylim(app.ImgIn,[1 size(app.img, 1)])
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
            if isempty(app.img)
                msgbox('Изображение не загружено!')
                return
            end
            value = app.NoiseMetod.Value;
            switch value
                case 'salt & pepper'
                    d = str2double( app.noise_param.Value );
                    app.imgN = imnoise(app.img, value, d);
                case 'gaussian'
                    d = str2double(app.noise_param.Value );
                    app.imgN = imnoise(app.img, value, 0, d);
                case 'speckle'
                    d = str2double( app.noise_param.Value );
                    app.imgN = imnoise(app.img, value, d);
            end
            image(app.ImgNoise, app.imgN);
            xlim(app.ImgNoise,[1 size(app.imgN, 2)])
            ylim(app.ImgNoise,[1 size(app.imgN, 1)])
            close(h)
            app.WievOrig_4.Enable = 'On';
        end

        % Value changed function: noise_param
        function noise_paramValueChanged(app, event)
            btn_img_noiceButtonPushed(app, event)
        end

        % Clicked callback: PushTool
        function PushToolClicked(app, event)
              filter = {'*.pdf';'*.jpg';'*.png'};
              [filename, filepath] = uiputfile(filter);
                    if ischar(filename)
                       exportapp(app.figure1,[filepath filename]);
                    end
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
            app.WievOrig_5.Enable = 'On';
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
            cla(app.ImgIn)    % очищаем оси
            cla(app.ImgNoise) % очищаем оси
            cla(app.ImgFilt)  % очищаем оси
            app.WievOrig_5.Enable = 'Off';
            app.WievOrig_4.Enable = 'Off';
        end

        % Callback function
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
            app.Lamp.Color = 'red';

            Fs = 44100 ; 
            nBits = 16 ; 
            nChannels = 2 ; 
            ID = -1; % default audio input device 
            recObj = audiorecorder(Fs,nBits,nChannels,ID);
            recordblocking(recObj,5);
            app.Lamp.Color = 'green';
            w1 = getaudiodata(recObj);
            filename=['recorded-voice-'+string(datetime("today"))+'.wav'];
            audiowrite(filename, w1, Fs);
        end

        % Button pushed function: WievOrig_4
        function WievOrig_4ButtonPushed(app, event)
            figure
            montage({app.img, app.imgN});
            title("Входное изображение (слева) и зашумленное (справа)");
        end

        % Button pushed function: WievOrig_5
        function WievOrig_5ButtonPushed(app, event)
            figure
            montage({app.img, app.imgF});
            title("Входное изображение (слева) и очищенное (справа)");
        end

        % Button pushed function: btn_open_img_2
        function btn_open_img_2ButtonPushed(app, event)
            [fname,path] = uigetfile({'*.bmp; *.jpg; *.png; *.gif','Image files (*.bmp; *.jpg; *.png; *.gif'},'Выбирете файл...');
            fullname = strcat(path,fname);
            app.imgDn = imread(fullname);
            image(app.ImgIn_2, app.imgDn);
            xlim(app.ImgIn_2,[1 size(app.imgDn, 2)])
            ylim(app.ImgIn_2,[1 size(app.imgDn, 1)])
        end

        % Button pushed function: btn_img_noice_2
        function btn_img_noice_2ButtonPushed(app, event)
            h = msgbox('Идет обработка...');
            if isempty(app.imgDn)
                msgbox('Изображение не загружено!')
                return
            end
             value = 'gaussian';
                    d = str2double(app.noise_param_2.Value);
                    app.imgDnN = imnoise(app.imgDn, value, 0, d);
            image(app.ImgNoise_2, app.imgDnN);
            xlim(app.ImgNoise_2,[1 size(app.imgDnN, 2)])
            ylim(app.ImgNoise_2,[1 size(app.imgDnN, 1)])
            close(h)
        end

        % Button pushed function: btn_img_denoice_2
        function btn_img_denoice_2ButtonPushed(app, event)
           h = msgbox('Идет обработка...');
           [noisyR,noisyG,noisyB] = imsplit(app.imgDnN);
           net = denoisingNetwork('dncnn');
           denoisedR = denoiseImage(noisyR,net);
           denoisedG = denoiseImage(noisyG,net);
           denoisedB = denoiseImage(noisyB,net);
           app.denoisedRGB = cat(3,denoisedR,denoisedG,denoisedB);
           image(app.ImgFilt_2, app.denoisedRGB);
           xlim(app.ImgFilt_2,[1 size(app.denoisedRGB, 2)])
           ylim(app.ImgFilt_2,[1 size(app.denoisedRGB, 1)])
           
            
           noisyPSNR = psnr(app.imgDnN,app.imgDn);
           denoisedPSNR = psnr(app.denoisedRGB,app.imgDn);
           noisySSIM = ssim(app.imgDnN,app.imgDn);
           denoisedSSIM = ssim(app.denoisedRGB,app.imgDn);
           
           string_PSNR = num2str(noisyPSNR, '%0.4f');
           string_dPSNR = num2str(denoisedPSNR, '%0.4f');
           string_SSIM = num2str(noisySSIM, '%0.4f');
           string_dSSIM = num2str(denoisedSSIM, '%0.4f');
           
           str = 'Значение PSNR зашумленного изображения составляет ';
           str_1 = '\nЗначение PSNR шумоподавленного изображения равно ';
           str_2 = '\nЗначение SSIM зашумленного изображения равно ';
           str_3 = '\nЗначение SSIM шумоподавленного изображения равно ';
           close(h)
           
           app.Label_4.Visible = 'on';
           app.Label_4.Text = string_PSNR;
           app.Label_5.Visible = 'on';
           app.Label_5.Text = string_dPSNR;
           app.Label_6.Visible = 'on';
           app.Label_6.Text = string_SSIM;
           app.Label_7.Visible = 'on';
           app.Label_7.Text = string_dSSIM;
        end

        % Button pushed function: Button_12
        function Button_12Pushed(app, event)
            cla(app.ImgIn_2)    % очищаем оси
            cla(app.ImgNoise_2) % очищаем оси
            cla(app.ImgFilt_2)  % очищаем оси
            app.Label_4.Visible ='off';
            app.Label_5.Visible ='off';
            app.Label_6.Visible ='off';
            app.Label_7.Visible ='off';
        end

        % Button pushed function: WievOrig_6
        function WievOrig_6ButtonPushed(app, event)
            imshow(app.imgDn);
        end

        % Button pushed function: WievOrig_7
        function WievOrig_7ButtonPushed(app, event)
            imshow(app.imgDnN);
        end

        % Button pushed function: WievOrig_8
        function WievOrig_8ButtonPushed(app, event)
            imshow(app.denoisedRGB);
        end

        % Button pushed function: WievOrig_9
        function WievOrig_9ButtonPushed(app, event)
            figure
            montage({app.imgDn, app.imgDnN});
            title("Входное изображение (слева) и зашумленное (справа)");
        end

        % Button pushed function: WievOrig_10
        function WievOrig_10ButtonPushed(app, event)
            figure
            montage({app.imgDn, app.denoisedRGB});
            title("Входное изображение (слева) и очищенное (справа)");
        end

        % Button pushed function: Button_14
        function Button_14Pushed(app, event)
            hs = msgbox('Идет обработка...');
            app.net1=load("commandNet.mat");
            app.net1=app.net1.trainedNet;
            
            classificationRate = 20;
            adr = audioDeviceReader('SampleRate',app.fs1,'SamplesPerFrame',floor(app.fs1/classificationRate));
            
            audioBuffer = dsp.AsyncBuffer(app.fs1);
            
            labels = app.net1.Layers(end).Classes;
            YBuffer(1:classificationRate/2) = categorical("background");
            
            probBuffer = zeros([numel(labels),classificationRate/2]);
            
            countThreshold = ceil(classificationRate*0.2);
            probThreshold = 0.7;
            
            h = figure('Units','normalized','Position',[0.2 0.1 0.6 0.8]);
            close(hs)
            timeLimit = 120;
            
            tic
            while ishandle(h) && toc < timeLimit
                
                % Extract audio samples from the audio device and add the samples to
                % the buffer.
                x = adr();
                write(audioBuffer,x);
                y1 = read(audioBuffer,app.fs1,app.fs1-adr.SamplesPerFrame);
                
                spec = helperExtractAuditoryFeatures(y1,app.fs1);
                
                % Classify the current spectrogram, save the label to the label buffer,
                % and save the predicted probabilities to the probability buffer.
                [YPredicted,probs] = classify(app.net1,spec,'ExecutionEnvironment','cpu');
                YBuffer = [YBuffer(2:end),YPredicted];
                probBuffer = [probBuffer(:,2:end),probs(:)];
                % Plot the current waveform and spectrogram.
                subplot(2,1,1)
                
                plot(y1)
                axis tight
                ylim([-1,1])
                
                
                subplot(2,1,2)
                pcolor(spec')
                caxis([-4 2.6445])
                shading flat
                title('yes no up down left right on off stop go')
                
                % Now do the actual command detection by performing a very simple
                % thresholding operation. Declare a detection and display it in the
                % figure title if all of the following hold: 1) The most common label
                % is not background. 2) At least countThreshold of the latest frame
                % labels agree. 3) The maximum probability of the predicted label is at
                % least probThreshold. Otherwise, do not declare a detection.
                [YMode,count] = mode(YBuffer);
                
                maxProb = max(probBuffer(labels == YMode,:));
                subplot(2,1,1)
                if YMode == "background" || count < countThreshold || maxProb < probThreshold
                    title(" ")
                else
                    title(string(YMode),'FontSize',20)
                end
                
                drawnow
            end
        end

        % Button pushed function: Button_10
        function Button_10Pushed(app, event)
            
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
            app.figure1.Name = 'Shum';
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
            app.Panel_2.Position = [12 584 179 163];

            % Create btn_play
            app.btn_play = uibutton(app.Panel_2, 'push');
            app.btn_play.ButtonPushedFcn = createCallbackFcn(app, @btn_play_Callback, true);
            app.btn_play.Icon = 'Play_24.png';
            app.btn_play.FontWeight = 'bold';
            app.btn_play.Position = [14 54 152 37];
            app.btn_play.Text = 'Прослушать';

            % Create btn_stop
            app.btn_stop = uibutton(app.Panel_2, 'push');
            app.btn_stop.ButtonPushedFcn = createCallbackFcn(app, @btn_stopButtonPushed, true);
            app.btn_stop.Icon = 'Stop_24.png';
            app.btn_stop.FontWeight = 'bold';
            app.btn_stop.Position = [14 7 152 37];
            app.btn_stop.Text = 'Стоп';

            % Create btn_open
            app.btn_open = uibutton(app.Panel_2, 'push');
            app.btn_open.ButtonPushedFcn = createCallbackFcn(app, @btn_open_Callback, true);
            app.btn_open.Icon = 'Open_24.png';
            app.btn_open.Position = [13 100 152 37];
            app.btn_open.Text = 'Открыть файл...';

            % Create Panel_3
            app.Panel_3 = uipanel(app.Panel);
            app.Panel_3.AutoResizeChildren = 'off';
            app.Panel_3.Title = 'Выбор параметров';
            app.Panel_3.FontSize = 13;
            app.Panel_3.Position = [303 584 380 163];

            % Create text2
            app.text2 = uilabel(app.Panel_3);
            app.text2.HorizontalAlignment = 'center';
            app.text2.Position = [155 105 119 22];
            app.text2.Text = 'Мощность шума, дБ';

            % Create edit_ndb
            app.edit_ndb = uieditfield(app.Panel_3, 'text');
            app.edit_ndb.ValueChangedFcn = createCallbackFcn(app, @edit_ndb_Callback, true);
            app.edit_ndb.HorizontalAlignment = 'center';
            app.edit_ndb.Position = [162 74 101 33];
            app.edit_ndb.Value = '-10';

            % Create btn_noice
            app.btn_noice = uibutton(app.Panel_3, 'push');
            app.btn_noice.ButtonPushedFcn = createCallbackFcn(app, @btn_noice_Callback, true);
            app.btn_noice.Icon = 'Add_24.png';
            app.btn_noice.Position = [7 74 151 33];
            app.btn_noice.Text = 'Добавить шум';

            % Create btn_denoice
            app.btn_denoice = uibutton(app.Panel_3, 'push');
            app.btn_denoice.ButtonPushedFcn = createCallbackFcn(app, @btn_denoice_Callback, true);
            app.btn_denoice.Icon = 'Clear_24.png';
            app.btn_denoice.Position = [7 28 151 33];
            app.btn_denoice.Text = 'Убрать шум';

            % Create pop_w
            app.pop_w = uidropdown(app.Panel_3);
            app.pop_w.Items = {'sym4', 'sym1', 'sym2', 'sym3', 'haar', 'db1', 'db2', 'db3', 'coif4', 'fk4'};
            app.pop_w.BackgroundColor = [1 1 1];
            app.pop_w.Position = [270 76 101 28];
            app.pop_w.Value = 'sym4';

            % Create text4
            app.text4 = uilabel(app.Panel_3);
            app.text4.HorizontalAlignment = 'center';
            app.text4.Position = [269 105 101 22];
            app.text4.Text = 'Тип вейвлета';

            % Create text5
            app.text5 = uilabel(app.Panel_3);
            app.text5.HorizontalAlignment = 'center';
            app.text5.VerticalAlignment = 'top';
            app.text5.Position = [294 53 52 22];
            app.text5.Text = 'Уровень';

            % Create pop_n
            app.pop_n = uidropdown(app.Panel_3);
            app.pop_n.Items = {'1'};
            app.pop_n.BackgroundColor = [1 1 1];
            app.pop_n.Position = [294 30 51 29];
            app.pop_n.Value = '1';

            % Create Button_11
            app.Button_11 = uibutton(app.Panel_3, 'push');
            app.Button_11.Icon = 'Save_16.png';
            app.Button_11.Position = [177 33 75 22];
            app.Button_11.Text = '';

            % Create Panel_5
            app.Panel_5 = uipanel(app.Panel);
            app.Panel_5.AutoResizeChildren = 'off';
            app.Panel_5.Title = 'Графики';
            app.Panel_5.Position = [694 584 175 163];

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
            app.Panel_10.Position = [200 585 93 163];

            % Create Lamp
            app.Lamp = uilamp(app.Panel_10);
            app.Lamp.Position = [37 10 20 20];

            % Create Button_9
            app.Button_9 = uibutton(app.Panel_10, 'push');
            app.Button_9.ButtonPushedFcn = createCallbackFcn(app, @Button_9Pushed, true);
            app.Button_9.Icon = 'Run_24.png';
            app.Button_9.Position = [9 99 75 37];
            app.Button_9.Text = 'Запись';

            % Create Button_10
            app.Button_10 = uibutton(app.Panel_10, 'push');
            app.Button_10.ButtonPushedFcn = createCallbackFcn(app, @Button_10Pushed, true);
            app.Button_10.Icon = 'Save_16.png';
            app.Button_10.Position = [9 55 75 22];
            app.Button_10.Text = '';

            % Create axes1
            app.axes1 = uiaxes(app.Panel);
            title(app.axes1, 'Исходный сигнал')
            xlabel(app.axes1, 'Время(сек)')
            ylabel(app.axes1, 'Напряжение(В)')
            app.axes1.XGrid = 'on';
            app.axes1.YGrid = 'on';
            app.axes1.Position = [21 312 840 250];

            % Create axes2
            app.axes2 = uiaxes(app.Panel);
            xlabel(app.axes2, 'Время(сек)')
            ylabel(app.axes2, 'Напряжение(В)')
            app.axes2.XGrid = 'on';
            app.axes2.YGrid = 'on';
            app.axes2.Position = [21 26 840 250];

            % Create Tab_2
            app.Tab_2 = uitab(app.TabGroup);
            app.Tab_2.AutoResizeChildren = 'off';
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
            app.text2_2.Position = [220 112 123 22];
            app.text2_2.Text = 'Интенсивность шума';

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
            app.btn_img_denoice.Position = [390 46 101 33];
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
            app.text5_2 = uilabel(app.Panel_7);
            app.text5_2.HorizontalAlignment = 'center';
            app.text5_2.Position = [675 79 52 22];
            app.text5_2.Text = 'Уровень';

            % Create btn_open_img
            app.btn_open_img = uibutton(app.Panel_7, 'push');
            app.btn_open_img.ButtonPushedFcn = createCallbackFcn(app, @btn_open_imgButtonPushed, true);
            app.btn_open_img.Icon = 'Open_24.png';
            app.btn_open_img.Position = [29 78 136 37];
            app.btn_open_img.Text = 'Открыть файл...';

            % Create btn_img_noice
            app.btn_img_noice = uibutton(app.Panel_7, 'push');
            app.btn_img_noice.ButtonPushedFcn = createCallbackFcn(app, @btn_img_noiceButtonPushed, true);
            app.btn_img_noice.Icon = 'Add_16.png';
            app.btn_img_noice.Position = [38 16 117 37];
            app.btn_img_noice.Text = 'Добавить шум';

            % Create text4_2
            app.text4_2 = uilabel(app.Panel_7);
            app.text4_2.HorizontalAlignment = 'center';
            app.text4_2.Position = [546 79 102 22];
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

            % Create WievOrig_4
            app.WievOrig_4 = uibutton(app.Panel_6, 'push');
            app.WievOrig_4.ButtonPushedFcn = createCallbackFcn(app, @WievOrig_4ButtonPushed, true);
            app.WievOrig_4.Icon = 'Compare_24.png';
            app.WievOrig_4.Enable = 'off';
            app.WievOrig_4.Position = [459 360 41 32];
            app.WievOrig_4.Text = '';

            % Create WievOrig_5
            app.WievOrig_5 = uibutton(app.Panel_6, 'push');
            app.WievOrig_5.ButtonPushedFcn = createCallbackFcn(app, @WievOrig_5ButtonPushed, true);
            app.WievOrig_5.Icon = 'Compare_24.png';
            app.WievOrig_5.Enable = 'off';
            app.WievOrig_5.Position = [729 360 41 32];
            app.WievOrig_5.Text = '';

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
            app.Tab_4.Title = 'Глубокое обучение';

            % Create Panel_11
            app.Panel_11 = uipanel(app.Tab_4);
            app.Panel_11.Title = 'Очистка сигнала от шума с помощью сетей глубокого обучения';
            app.Panel_11.FontSize = 14;
            app.Panel_11.Position = [13 571 881 221];

            % Create Panel_15
            app.Panel_15 = uipanel(app.Panel_11);
            app.Panel_15.Enable = 'off';
            app.Panel_15.TitlePosition = 'centertop';
            app.Panel_15.Title = 'Тестирование';
            app.Panel_15.FontSize = 13;
            app.Panel_15.Position = [710 21 154 157];

            % Create Panel_14
            app.Panel_14 = uipanel(app.Panel_11);
            app.Panel_14.Enable = 'off';
            app.Panel_14.TitlePosition = 'centertop';
            app.Panel_14.Title = 'Конфигурация сети';
            app.Panel_14.FontSize = 13;
            app.Panel_14.Position = [509 21 188 157];

            % Create Panel_12
            app.Panel_12 = uipanel(app.Panel_11);
            app.Panel_12.Enable = 'off';
            app.Panel_12.TitlePosition = 'centertop';
            app.Panel_12.Title = 'Загрузка/Обработка сигнала';
            app.Panel_12.FontSize = 13;
            app.Panel_12.Position = [14 21 272 159];

            % Create Panel_13
            app.Panel_13 = uipanel(app.Panel_11);
            app.Panel_13.Enable = 'off';
            app.Panel_13.TitlePosition = 'centertop';
            app.Panel_13.Title = 'Исследовать набор данных';
            app.Panel_13.FontSize = 13;
            app.Panel_13.Position = [299 21 196 157];

            % Create Label_2
            app.Label_2 = uilabel(app.Panel_11);
            app.Label_2.FontSize = 100;
            app.Label_2.FontColor = [1 0 0];
            app.Label_2.Position = [191 21 540 170];
            app.Label_2.Text = 'Отключено';

            % Create Panel_16
            app.Panel_16 = uipanel(app.Tab_4);
            app.Panel_16.Title = 'Очистка изображения от шума с помощью глубокого обучения';
            app.Panel_16.FontSize = 14;
            app.Panel_16.Position = [13 21 881 542];

            % Create Panel_17
            app.Panel_17 = uipanel(app.Panel_16);
            app.Panel_17.Title = 'Настройка';
            app.Panel_17.FontSize = 13;
            app.Panel_17.Position = [15 332 849 168];

            % Create btn_open_img_2
            app.btn_open_img_2 = uibutton(app.Panel_17, 'push');
            app.btn_open_img_2.ButtonPushedFcn = createCallbackFcn(app, @btn_open_img_2ButtonPushed, true);
            app.btn_open_img_2.Icon = 'Open_24.png';
            app.btn_open_img_2.Position = [16 85 130 37];
            app.btn_open_img_2.Text = 'Открыть файл...';

            % Create btn_img_noice_2
            app.btn_img_noice_2 = uibutton(app.Panel_17, 'push');
            app.btn_img_noice_2.ButtonPushedFcn = createCallbackFcn(app, @btn_img_noice_2ButtonPushed, true);
            app.btn_img_noice_2.Icon = 'Add_16.png';
            app.btn_img_noice_2.Position = [16 23 130 37];
            app.btn_img_noice_2.Text = 'Добавить шум';

            % Create text2_3
            app.text2_3 = uilabel(app.Panel_17);
            app.text2_3.HorizontalAlignment = 'center';
            app.text2_3.Position = [156 121 123 22];
            app.text2_3.Text = 'Интенсивность шума';

            % Create noise_param_2
            app.noise_param_2 = uieditfield(app.Panel_17, 'text');
            app.noise_param_2.HorizontalAlignment = 'center';
            app.noise_param_2.Position = [166 87 101 33];
            app.noise_param_2.Value = '0.01';

            % Create Label_3
            app.Label_3 = uilabel(app.Panel_17);
            app.Label_3.HorizontalAlignment = 'center';
            app.Label_3.Position = [190 59 59 22];
            app.Label_3.Text = 'Тип шума';

            % Create NoiseMetod_2
            app.NoiseMetod_2 = uidropdown(app.Panel_17);
            app.NoiseMetod_2.Items = {'gaussian'};
            app.NoiseMetod_2.Position = [167 23 103 35];
            app.NoiseMetod_2.Value = 'gaussian';

            % Create btn_img_denoice_2
            app.btn_img_denoice_2 = uibutton(app.Panel_17, 'push');
            app.btn_img_denoice_2.ButtonPushedFcn = createCallbackFcn(app, @btn_img_denoice_2ButtonPushed, true);
            app.btn_img_denoice_2.Icon = 'Clear_24.png';
            app.btn_img_denoice_2.HorizontalAlignment = 'left';
            app.btn_img_denoice_2.Position = [294 87 101 33];
            app.btn_img_denoice_2.Text = 'Убрать шум';

            % Create pop_w_3
            app.pop_w_3 = uidropdown(app.Panel_17);
            app.pop_w_3.Items = {'DnCNN'};
            app.pop_w_3.BackgroundColor = [1 1 1];
            app.pop_w_3.Position = [291 27 107 28];
            app.pop_w_3.Value = 'DnCNN';

            % Create text4_3
            app.text4_3 = uilabel(app.Panel_17);
            app.text4_3.HorizontalAlignment = 'center';
            app.text4_3.Position = [294 59 102 22];
            app.text4_3.Text = 'Тип фильтра';

            % Create Button_12
            app.Button_12 = uibutton(app.Panel_17, 'push');
            app.Button_12.ButtonPushedFcn = createCallbackFcn(app, @Button_12Pushed, true);
            app.Button_12.Icon = 'RefreshPlot_24.png';
            app.Button_12.Position = [441 42 109 59];
            app.Button_12.Text = 'Очистить';

            % Create Panel_18
            app.Panel_18 = uipanel(app.Panel_17);
            app.Panel_18.AutoResizeChildren = 'off';
            app.Panel_18.Tooltip = {'Более высокий PSNR указывает на то, что шум имеет меньший относительный сигнал и связан с более высоким качеством изображения.'; ''; 'Индекс SSIM, близкий к 1, указывает на хорошее совпадение с эталонным изображением и более высокое качество изображения.'; ''};
            app.Panel_18.Title = 'Расчет';
            app.Panel_18.Position = [605 10 223 129];

            % Create dPSNRLabel
            app.dPSNRLabel = uilabel(app.Panel_18);
            app.dPSNRLabel.Position = [22 57 45 22];
            app.dPSNRLabel.Text = 'dPSNR';

            % Create SSIMLabel
            app.SSIMLabel = uilabel(app.Panel_18);
            app.SSIMLabel.Position = [27 32 39 22];
            app.SSIMLabel.Text = 'SSIM';

            % Create dSSIMLabel
            app.dSSIMLabel = uilabel(app.Panel_18);
            app.dSSIMLabel.Position = [26 7 39 22];
            app.dSSIMLabel.Text = 'dSSIM';

            % Create PSNRLabel
            app.PSNRLabel = uilabel(app.Panel_18);
            app.PSNRLabel.Position = [26 82 39 22];
            app.PSNRLabel.Text = 'PSNR';

            % Create Label_4
            app.Label_4 = uilabel(app.Panel_18);
            app.Label_4.HorizontalAlignment = 'center';
            app.Label_4.Visible = 'off';
            app.Label_4.Position = [133 82 62 22];

            % Create Label_5
            app.Label_5 = uilabel(app.Panel_18);
            app.Label_5.HorizontalAlignment = 'center';
            app.Label_5.Visible = 'off';
            app.Label_5.Position = [133 57 62 22];

            % Create Label_6
            app.Label_6 = uilabel(app.Panel_18);
            app.Label_6.HorizontalAlignment = 'center';
            app.Label_6.Visible = 'off';
            app.Label_6.Position = [133 32 62 22];

            % Create Label_7
            app.Label_7 = uilabel(app.Panel_18);
            app.Label_7.HorizontalAlignment = 'center';
            app.Label_7.Visible = 'off';
            app.Label_7.Position = [133 7 62 22];

            % Create WievOrig_6
            app.WievOrig_6 = uibutton(app.Panel_16, 'push');
            app.WievOrig_6.ButtonPushedFcn = createCallbackFcn(app, @WievOrig_6ButtonPushed, true);
            app.WievOrig_6.Icon = 'Zoom_In_24.png';
            app.WievOrig_6.Position = [129 290 41 32];
            app.WievOrig_6.Text = '';

            % Create WievOrig_7
            app.WievOrig_7 = uibutton(app.Panel_16, 'push');
            app.WievOrig_7.ButtonPushedFcn = createCallbackFcn(app, @WievOrig_7ButtonPushed, true);
            app.WievOrig_7.Icon = 'Zoom_In_24.png';
            app.WievOrig_7.Position = [421 290 41 32];
            app.WievOrig_7.Text = '';

            % Create WievOrig_8
            app.WievOrig_8 = uibutton(app.Panel_16, 'push');
            app.WievOrig_8.ButtonPushedFcn = createCallbackFcn(app, @WievOrig_8ButtonPushed, true);
            app.WievOrig_8.Icon = 'Zoom_In_24.png';
            app.WievOrig_8.Position = [708 290 41 32];
            app.WievOrig_8.Text = '';

            % Create WievOrig_9
            app.WievOrig_9 = uibutton(app.Panel_16, 'push');
            app.WievOrig_9.ButtonPushedFcn = createCallbackFcn(app, @WievOrig_9ButtonPushed, true);
            app.WievOrig_9.Icon = 'Compare_24.png';
            app.WievOrig_9.Position = [472 290 41 32];
            app.WievOrig_9.Text = '';

            % Create WievOrig_10
            app.WievOrig_10 = uibutton(app.Panel_16, 'push');
            app.WievOrig_10.ButtonPushedFcn = createCallbackFcn(app, @WievOrig_10ButtonPushed, true);
            app.WievOrig_10.Icon = 'Compare_24.png';
            app.WievOrig_10.Position = [760 290 41 32];
            app.WievOrig_10.Text = '';

            % Create ImgIn_2
            app.ImgIn_2 = uiaxes(app.Panel_16);
            title(app.ImgIn_2, 'Оригинал')
            app.ImgIn_2.XTick = [];
            app.ImgIn_2.YTick = [];
            app.ImgIn_2.Box = 'on';
            app.ImgIn_2.Position = [14 10 273 268];

            % Create ImgNoise_2
            app.ImgNoise_2 = uiaxes(app.Panel_16);
            title(app.ImgNoise_2, 'С шумом')
            app.ImgNoise_2.XTick = [];
            app.ImgNoise_2.YTick = [];
            app.ImgNoise_2.Box = 'on';
            app.ImgNoise_2.Position = [302 10 273 268];

            % Create ImgFilt_2
            app.ImgFilt_2 = uiaxes(app.Panel_16);
            title(app.ImgFilt_2, 'После фильтрации')
            app.ImgFilt_2.XTick = [];
            app.ImgFilt_2.YTick = [];
            app.ImgFilt_2.Box = 'on';
            app.ImgFilt_2.Position = [591 10 273 268];

            % Create Tab_5
            app.Tab_5 = uitab(app.TabGroup);
            app.Tab_5.Title = 'Распознавание';

            % Create Panel_19
            app.Panel_19 = uipanel(app.Tab_5);
            app.Panel_19.TitlePosition = 'centertop';
            app.Panel_19.Title = 'Распознавание речевых комманд';
            app.Panel_19.FontSize = 14;
            app.Panel_19.Position = [52 638 254 142];

            % Create Button_14
            app.Button_14 = uibutton(app.Panel_19, 'push');
            app.Button_14.ButtonPushedFcn = createCallbackFcn(app, @Button_14Pushed, true);
            app.Button_14.Icon = 'run_24.png';
            app.Button_14.Position = [67 31 123 52];
            app.Button_14.Text = 'Обработка';

            % Show the figure after all components are created
            app.figure1.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = SoundProc_App_exported

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