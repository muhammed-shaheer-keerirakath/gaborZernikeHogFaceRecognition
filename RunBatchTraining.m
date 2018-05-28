function results = RunBatchTraining(app)
%RUNBATCHTRAINING function to train selecting multiple faces at once

    %delete existing old database
    DeleteAllDatabase();
    
    app.trainTot.Value = 0;
    app.trainProc.Value = 0;
    
    %get the user input samples for training
    insample = str2num(app.trainInput.Value);
    
    app.startTrain.Enable = 'off';
    app.trainTot.Value = numel(insample)*40;
    
    %carry out training for all 40 ORL faces
    for i = 1:40
        path = strcat(strcat(pwd,'\faces\s'),strcat(num2str(i),'\'));
        
        %train the specified sample numbers from each folder
        for j = 1:numel(insample)
            fname = strcat(path,strcat(num2str(insample(j)),'.pgm'));
            label = strcat('person',num2str(i));
            TrainCurrentImage(fname,label);
            
            app.trainProc.Value = app.trainProc.Value + 1;
        end
    end
    
    app.startTrain.Enable = 'on';
    
    clear all;
end

