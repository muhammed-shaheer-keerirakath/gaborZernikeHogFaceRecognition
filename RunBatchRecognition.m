function results = RunBatchRecognition(app)
%RUNBATCHRECOGNITION function used for batch recognition

    app.recTot.Value = 0;
    app.recProc.Value = 0;
    app.recRate.Value = 0;
    app.currPercentage.Value = '0%';
    
    %get the user input sample numbers for training
    insample = str2num(app.testInput.Value);
    
    app.startTest.Enable = 'off';
    app.recTot.Value = numel(insample)*40;
    
    %carry out recognition for 40 ORL faces
    for i = 1:40
        path = strcat(strcat(pwd,'\faces\s'),strcat(num2str(i),'\'));
        
        %test the specified sample numbers from each folder
        for j = 1:numel(insample)
            fname = strcat(path,strcat(num2str(insample(j)),'.pgm'));
            label = strcat('person',num2str(i));
            match = RecognizeCurrentImage(fname,label);
            
            app.recProc.Value = app.recProc.Value + 1;
            app.recRate.Value = app.recRate.Value + match;
            app.currPercentage.Value = strcat(num2str(round(app.recRate.Value/app.recProc.Value*100,1)),'%');
        end
    end
    
    app.startTest.Enable = 'on';
    
    clear all;
end

