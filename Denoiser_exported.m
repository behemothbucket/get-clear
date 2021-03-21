classdef Denoiser_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        figure1      matlab.ui.Figure
        Menu         matlab.ui.container.Menu
        Menu_3       matlab.ui.container.Menu
        Menu_5       matlab.ui.container.Menu
        Menu_4       matlab.ui.container.Menu
        Toolbar      matlab.ui.container.Toolbar
        PushTool     matlab.ui.container.toolbar.PushTool
        Panel        matlab.ui.container.Panel
        text5        matlab.ui.control.Label
        text4        matlab.ui.control.Label
        pop_n        matlab.ui.control.DropDown
        pop_w        matlab.ui.control.DropDown
        btn_denoice  matlab.ui.control.Button
        text_fn      matlab.ui.control.Label
        text2        matlab.ui.control.Label
        edit_ndb     matlab.ui.control.EditField
        btn_noice    matlab.ui.control.Button
        btn_play     matlab.ui.control.Button
        btn_open     matlab.ui.control.Button
        axes2        matlab.ui.control.UIAxes
        axes1        matlab.ui.control.UIAxes
        Panel_2      matlab.ui.container.Panel
        Tree         matlab.ui.container.Tree
        Node         matlab.ui.container.TreeNode
        sym4Node     matlab.ui.container.TreeNode
        sym1Node     matlab.ui.container.TreeNode
        sym2Node     matlab.ui.container.TreeNode
        sym3Node     matlab.ui.container.TreeNode
        haarNode     matlab.ui.container.TreeNode
        db1Node      matlab.ui.container.TreeNode
        db2Node      matlab.ui.container.TreeNode
        db3Node      matlab.ui.container.TreeNode
        coif4Node    matlab.ui.container.TreeNode
        fk4Node      matlab.ui.container.TreeNode
    end

    
    methods (Access = private)
        function StartPlayback_Callback(~, ~, ~, buttonHandle)
            % если воспроизводится
            % надпись на кнопке:
            set( buttonHandle , 'String', 'Стоп' );
        end
        
        function StopPlayback_Callback(~, ~, ~, buttonHandle)
            % если не воспроизводится
            % надпись на кнопке:
            set( buttonHandle , 'String', 'Прослушать' );
        end
        
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function SoundProc_OpeningFcn(app, varargin)
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app); %#ok<ASGLU>
            
            handles.output = hObject;
            clc % очищаем командное окно
            handles.y = []; % инициализируем данные
            handles.yn = []; % инициализируем данные
            handles.obj = []; % инициализируем плеер
            cla(handles.axes1) % очищаем оси
            cla(handles.axes2) % очищаем оси
            %axis(handles.axes1,'off') % убираем рамку
            guidata(hObject, handles);
        end

        % Button pushed function: btn_denoice
        function btn_denoice_Callback(app, event)
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
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
            set( obj , 'StopFcn' , {@app.StopPlayback_Callback, handles.btn_play} )
            set( obj , 'StartFcn' , {@app.StartPlayback_Callback, handles.btn_play} )
            handles.obj = obj; % сохраняем объект
            guidata(hObject, handles);
        end

        % Button pushed function: btn_noice
        function btn_noice_Callback(app, event)
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
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
            set( obj , 'StopFcn' , {@app.StopPlayback_Callback, handles.btn_play} )
            set( obj , 'StartFcn' , {@app.StartPlayback_Callback, handles.btn_play} )
            handles.obj = obj; % сохраняем объект
            guidata(hObject, handles);
        end

        % Button pushed function: btn_open
        function btn_open_Callback(app, event)
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
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
            set( obj, 'StopFcn', {@app.StopPlayback_Callback, handles.btn_play} )
            set( obj, 'StartFcn', {@app.StartPlayback_Callback, handles.btn_play} )
            % сохраняем данные:
            handles.t = t;
            handles.y = Y;
            handles.fs = Fs;
            handles.obj = obj;
            guidata(hObject, handles);
        end

        % Button pushed function: btn_play
        function btn_play_Callback(app, event)
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
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
        end

        % Value changed function: edit_ndb
        function edit_ndb_Callback(app, event)
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); 
            
            % если изменили значение в окне, добавляем шум
            btn_noice_Callback(app, hObject, eventdata, handles);
        end

        % Clicked callback: PushTool
        function PushToolClicked(app, event)
              app = SoundProc_App;
              filter = {'*.pdf';'*.jpg';'*.png'};
              [filename, filepath] = uiputfile(filter);
                    if ischar(filename)
                       exportapp(app.figure1,[filepath filename]);
                    end
        end

        % Menu selected function: Menu_5
        function Menu_5Selected(app, event)
            closereq;
        end

        % Menu selected function: Menu_4
        function Menu_4Selected(app, event)
           msgbox('Denoiser', 'Info','help');
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create figure1 and hide until all components are created
            app.figure1 = uifigure('Visible', 'off');
            app.figure1.Position = [816 818 1000 705];
            app.figure1.Name = 'Denoiser';
            app.figure1.Tag = 'figure1';

            % Create Menu
            app.Menu = uimenu(app.figure1);
            app.Menu.Tooltip = {'Открыть меню'};
            app.Menu.Text = 'Меню';

            % Create Menu_3
            app.Menu_3 = uimenu(app.Menu);
            app.Menu_3.Text = 'Теория';

            % Create Menu_5
            app.Menu_5 = uimenu(app.Menu);
            app.Menu_5.MenuSelectedFcn = createCallbackFcn(app, @Menu_5Selected, true);
            app.Menu_5.Tooltip = {'Всего доброго)'};
            app.Menu_5.Text = 'Выход';

            % Create Menu_4
            app.Menu_4 = uimenu(app.figure1);
            app.Menu_4.MenuSelectedFcn = createCallbackFcn(app, @Menu_4Selected, true);
            app.Menu_4.Text = 'О программе';

            % Create Toolbar
            app.Toolbar = uitoolbar(app.figure1);

            % Create PushTool
            app.PushTool = uipushtool(app.Toolbar);
            app.PushTool.Tooltip = {'Скриншот окна'};
            app.PushTool.ClickedCallback = createCallbackFcn(app, @PushToolClicked, true);
            app.PushTool.Icon = 'scr_icon.png';

            % Create Panel
            app.Panel = uipanel(app.figure1);
            app.Panel.Title = 'Очистка звукового сигнала от шума с помощью вейвлет преобразования';
            app.Panel.Position = [9 22 983 471];

            % Create text5
            app.text5 = uilabel(app.Panel);
            app.text5.Tag = 'text5';
            app.text5.HorizontalAlignment = 'center';
            app.text5.VerticalAlignment = 'top';
            app.text5.WordWrap = 'on';
            app.text5.FontSize = 10;
            app.text5.Position = [790 203 62 15];
            app.text5.Text = 'Уровень';

            % Create text4
            app.text4 = uilabel(app.Panel);
            app.text4.Tag = 'text4';
            app.text4.HorizontalAlignment = 'center';
            app.text4.VerticalAlignment = 'top';
            app.text4.WordWrap = 'on';
            app.text4.FontSize = 10;
            app.text4.Position = [645 201 121 17];
            app.text4.Text = 'Тип вейвлета';

            % Create pop_n
            app.pop_n = uidropdown(app.Panel);
            app.pop_n.Items = {'1'};
            app.pop_n.Tag = 'pop_n';
            app.pop_n.FontSize = 13;
            app.pop_n.BackgroundColor = [1 1 1];
            app.pop_n.Position = [790 166 61 31];
            app.pop_n.Value = '1';

            % Create pop_w
            app.pop_w = uidropdown(app.Panel);
            app.pop_w.Items = {'sym4', 'sym1', 'sym2', 'sym3', 'haar', 'db1', 'db2', 'db3', 'coif4', 'fk4'};
            app.pop_w.Tag = 'pop_w';
            app.pop_w.FontSize = 13;
            app.pop_w.BackgroundColor = [1 1 1];
            app.pop_w.Position = [646 167 121 30];
            app.pop_w.Value = 'sym4';

            % Create btn_denoice
            app.btn_denoice = uibutton(app.Panel, 'push');
            app.btn_denoice.ButtonPushedFcn = createCallbackFcn(app, @btn_denoice_Callback, true);
            app.btn_denoice.Tag = 'btn_denoice';
            app.btn_denoice.FontSize = 10;
            app.btn_denoice.Position = [437 164 181 36];
            app.btn_denoice.Text = 'Убрать шум';

            % Create text_fn
            app.text_fn = uilabel(app.Panel);
            app.text_fn.Tag = 'text_fn';
            app.text_fn.VerticalAlignment = 'top';
            app.text_fn.WordWrap = 'on';
            app.text_fn.FontSize = 13;
            app.text_fn.FontAngle = 'italic';
            app.text_fn.Position = [292 350 361 24];
            app.text_fn.Text = '';

            % Create text2
            app.text2 = uilabel(app.Panel);
            app.text2.Tag = 'text2';
            app.text2.HorizontalAlignment = 'center';
            app.text2.VerticalAlignment = 'top';
            app.text2.WordWrap = 'on';
            app.text2.FontSize = 10;
            app.text2.Position = [198 207 136 15];
            app.text2.Text = 'Мощность шума, дБ';

            % Create edit_ndb
            app.edit_ndb = uieditfield(app.Panel, 'text');
            app.edit_ndb.ValueChangedFcn = createCallbackFcn(app, @edit_ndb_Callback, true);
            app.edit_ndb.Tag = 'edit_ndb';
            app.edit_ndb.HorizontalAlignment = 'center';
            app.edit_ndb.FontSize = 10;
            app.edit_ndb.Position = [202 167 121 36];
            app.edit_ndb.Value = '-10';

            % Create btn_noice
            app.btn_noice = uibutton(app.Panel, 'push');
            app.btn_noice.ButtonPushedFcn = createCallbackFcn(app, @btn_noice_Callback, true);
            app.btn_noice.Tag = 'btn_noice';
            app.btn_noice.FontSize = 10;
            app.btn_noice.Position = [70 165 121 40];
            app.btn_noice.Text = 'Добавить шум';

            % Create btn_play
            app.btn_play = uibutton(app.Panel, 'push');
            app.btn_play.ButtonPushedFcn = createCallbackFcn(app, @btn_play_Callback, true);
            app.btn_play.Tag = 'btn_play';
            app.btn_play.FontSize = 13;
            app.btn_play.FontWeight = 'bold';
            app.btn_play.Position = [718 347 180 37];
            app.btn_play.Text = 'Прослушать';

            % Create btn_open
            app.btn_open = uibutton(app.Panel, 'push');
            app.btn_open.ButtonPushedFcn = createCallbackFcn(app, @btn_open_Callback, true);
            app.btn_open.Tag = 'btn_open';
            app.btn_open.FontSize = 10;
            app.btn_open.Position = [70 348 157 30];
            app.btn_open.Text = 'Выбрать файл...';

            % Create axes2
            app.axes2 = uiaxes(app.Panel);
            app.axes2.FontSize = 10;
            app.axes2.NextPlot = 'replace';
            app.axes2.Tag = 'axes2';
            app.axes2.Position = [34 46 905 114];

            % Create axes1
            app.axes1 = uiaxes(app.Panel);
            app.axes1.FontSize = 10;
            app.axes1.NextPlot = 'replace';
            app.axes1.Tag = 'axes1';
            app.axes1.Position = [34 224 905 114];

            % Create Panel_2
            app.Panel_2 = uipanel(app.figure1);
            app.Panel_2.Title = 'Теория';
            app.Panel_2.Position = [9 520 983 158];

            % Create Tree
            app.Tree = uitree(app.Panel_2);
            app.Tree.Position = [12 8 150 121];

            % Create Node
            app.Node = uitreenode(app.Tree);
            app.Node.Text = 'Тип';

            % Create sym4Node
            app.sym4Node = uitreenode(app.Node);
            app.sym4Node.NodeData = 2;
            app.sym4Node.Text = 'sym4';

            % Create sym1Node
            app.sym1Node = uitreenode(app.Node);
            app.sym1Node.Text = 'sym1';

            % Create sym2Node
            app.sym2Node = uitreenode(app.Node);
            app.sym2Node.Text = 'sym2';

            % Create sym3Node
            app.sym3Node = uitreenode(app.Node);
            app.sym3Node.Text = 'sym3';

            % Create haarNode
            app.haarNode = uitreenode(app.Node);
            app.haarNode.Text = 'haar';

            % Create db1Node
            app.db1Node = uitreenode(app.Node);
            app.db1Node.Text = 'db1';

            % Create db2Node
            app.db2Node = uitreenode(app.Node);
            app.db2Node.Text = 'db2';

            % Create db3Node
            app.db3Node = uitreenode(app.Node);
            app.db3Node.Text = 'db3';

            % Create coif4Node
            app.coif4Node = uitreenode(app.Node);
            app.coif4Node.Text = 'coif4';

            % Create fk4Node
            app.fk4Node = uitreenode(app.Node);
            app.fk4Node.Text = 'fk4';

            % Show the figure after all components are created
            app.figure1.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Denoiser_exported(varargin)

            runningApp = getRunningApp(app);

            % Check for running singleton app
            if isempty(runningApp)

                % Create UIFigure and components
                createComponents(app)

                % Register the app with App Designer
                registerApp(app, app.figure1)

                % Execute the startup function
                runStartupFcn(app, @(app)SoundProc_OpeningFcn(app, varargin{:}))
            else

                % Focus the running singleton app
                figure(runningApp.figure1)

                app = runningApp;
            end

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