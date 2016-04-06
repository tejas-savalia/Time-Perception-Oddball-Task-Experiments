close all;
clear all;
sca;

PsychDefaultSetup(2);
Observer = str2num(input('\n Subject number:  ','s')); 
Name = input('\n Subject Name:  ','s'); 
viewdist = str2num(input('\n Viewing distance (in cm):  ','s'));

Screen('Preference', 'ConserveVRAM', 64);
Screen('Preference', 'SkipSyncTests', 1);
KbName('UnifyKeyNames');
A1050 = [];
B1050 = [];

[window, windowRect] = PsychImaging('OpenWindow', 0, [0 0 0]);


testDurations1050 = [0.450 0.525 0.600 0.675 0.750 0.825 0.900 0.975 1.050];                         %durations for which the oddball would appear
testDurations1050 = [testDurations1050 testDurations1050 testDurations1050 testDurations1050 testDurations1050 testDurations1050];
randomTestDurations1050 = [testDurations1050(randperm(length(testDurations1050))) 1.050];                   %oddball durations randomized

seconds = [];
keyPressed = [];
inputForValue = [];
[Xcenter, Ycenter] = RectCenter(windowRect);


KbQueueCreate();
for k = 1:length(randomTestDurations1050)
    count = 0;
    KbQueueStart();

    Screen('FillRect', window, [1 1 1]);
    Screen('Flip', window);
    
    pause((1.150-0.950)*rand(1, 1) + 0.950);                                            %isi between 950 and 1050 msec

    
    baseRect = [0, 0, 150, 150];

    centeredRect = CenterRectOnPointd(baseRect, Xcenter, Ycenter);
    
    
    for j = 1:randi([2, 8])
        
        for i = 1:10                                                                       
            Screen('FillOval', window, [0 0 0], centeredRect); 
            Screen('Flip', window);
            centeredRect = CenterRectOnPointd(centeredRect * 1.05, Xcenter, Ycenter);
            pause(1.050/10);
        end
    
        centeredRect = CenterRectOnPointd(baseRect, Xcenter, Ycenter);
    
        Screen('FillRect', window, [1 1 1]);
        Screen('Flip', window);
        pause((1.150-0.950)*rand(1, 1) + 0.950);                                            %isi
    
    end
    
    Screen('FillOval', window, [0, 0, 0], centeredRect);                            %standard
    Screen('Flip', window);
   
    pause(randomTestDurations1050(k));                                                                   %standard for constant 1050 msec duration
   
    Screen('FillRect', window, [1 1 1])
    Screen('Flip', window);
    
    pause((1.150-0.950)*rand(1, 1) + 0.950);                                        %isi


    for j = 1:randi([2, 4])
        
        for i = 1:10                                                                       
            Screen('FillOval', window, [0 0 0], centeredRect); 
            Screen('Flip', window);
            centeredRect = CenterRectOnPointd(centeredRect * 1.05, Xcenter, Ycenter);
            pause(1.050/10);
        end
    
        centeredRect = CenterRectOnPointd(baseRect, Xcenter, Ycenter);
    
        Screen('FillRect', window, [1 1 1]);
        Screen('Flip', window);
        pause((1.150-0.950)*rand(1, 1) + 0.950);                                            %isi

    end
    
    Screen('FillRect', window, [0.5 0.5 0.5]);
    startTime = Screen('Flip', window);
    [endTime, keyCode, deltaSecs] = KbStrokeWait();
    responseTime = endTime - startTime;
    if or(isequal(KbName(keyCode),'l'), isequal(KbName(keyCode), 's'))
        seconds = [seconds responseTime];
        keyPressed = [keyPressed isequal(KbName(keyCode), 'l')];
        inputForValue = [inputForValue randomTestDurations1050(k)];
    end
end

Screen('FillRect', window, [1 1 1]);
Screen('Flip', window);

%save the input Test Duration, pressed response and response time in a file
%named by subject name
data = [inputForValue' keyPressed' seconds'];
save(Name, 'data');

experimentendtext = ['End of experiment'];
Screen(window,'TextSize',20);
Screen('FillRect',window,[1 1 1]);
[nx, ny, bbox] = DrawFormattedText(window, experimentendtext, 'center', 'center');   
vbl = Screen(window, 'Flip'); % IN

KbStrokeWait;
sca;

