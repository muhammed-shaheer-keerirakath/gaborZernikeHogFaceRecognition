function results = RunSingleRecognition(app)
%RUNSINGLERECOGNITION function to run recognition of single face image
    
%   %part 1 : select input image
    %Select an input image using explorer
    [Fname, Path] = uigetfile({'*.pgm';'*.jpg';'*.png'},'Select Input Image');
    
    %return back if user pressed cancel button in the explorer 
    if isequal(Fname,0)
        SetWindowFocus(app);
        return;
    end
    
    SetWindowFocus(app);
    
    app.selectImageProcessing.Visible = 'on';
    
    %initialize the window again for new image
    InitializeStartupSettings(app);

    Fname = strcat(Path,Fname);
    InImage = imread(Fname);
    
    %save the input image to results folder
    imwrite(InImage, 'results\inputImage.jpg');
    
    %display selected image in UIAxes
    SetImage(app.UIAxes,'results\inputImage.jpg');
    
    % Check if the input image is grayscale, convert if not
    if size(InImage,3) == 3
        InImage = rgb2gray(InImage);

        %save the gray input image to results folder
        imwrite(InImage,'results\inputImageGray.jpg');
    end
    
    app.selectImageProcessing.Visible = 'off';
    
%   %part 2 : apply gabor filter

    app.gaborProcessing.Visible = 'on';

    %create a gabor array of scale 3 and orientation 3
    gaborArray = GaborFilterBank();
    
    % save real parts of Gabor filters:
    realFigure = figure('visible','off','NumberTitle','Off','Name','Real parts of Gabor filters');
    for i = 1:3
        for j = 1:3        
            subplot(3,3,(i-1)*3+j);        
            imshow(real(gaborArray{i,j}),[]);
        end
    end
    saveas(realFigure, 'results\realGaborFilterBank.jpg');

    % save magnitudes of Gabor filters:
    magnitudeFigure = figure('visible','off','NumberTitle','Off','Name','Magnitudes of Gabor filters');
    for i = 1:3
        for j = 1:3        
            subplot(3,3,(i-1)*3+j);        
            imshow(abs(gaborArray{i,j}),[]);
        end
    end
    saveas(magnitudeFigure, 'results\magnitudeGaborFilterBank.jpg');

    %apply gabor filter bank to image and assign the output images to gaborResult
    gaborResult = GaborFeatures(InImage,gaborArray);
    [u,v] = size(gaborArray);
    
    % save real parts of Gabor-filtered images
    realFigure = figure('visible','off','NumberTitle','Off','Name','Real parts of Gabor filters');
    for i = 1:u
        for j = 1:v        
            subplot(u,v,(i-1)*v+j)    
            imshow(real(gaborResult{i,j}),[]);
        end
    end
    saveas(realFigure, 'results\realGaborImage.jpg');

    % save magnitudes of Gabor-filtered images
    magnitudeFigure = figure('visible','off','NumberTitle','Off','Name','Magnitudes of Gabor filters');
    for i = 1:u
        for j = 1:v        
            subplot(u,v,(i-1)*v+j)    
            imshow(abs(gaborResult{i,j}),[]);
        end
    end
    saveas(magnitudeFigure, 'results\magnitudeGaborImage.jpg');
    
    %display magnitude of gabor image in UIAxes as a result
    SetImage(app.UIAxes_2,'results\magnitudeGaborImage.jpg');
    
    app.gaborProcessing.Visible = 'off';
    
%   %part 3 : apply zernike moment

    app.zernikeProcessing.Visible = 'on';
    
    %feature vector
    zernikeResult = cell(1,9);
    index = 1;
    
    % save result of zernike moment images
    zernikeFigure = figure('visible','off','NumberTitle','Off','Name','Zernike Moment on Gabor Output');
    for i = 1:3
        for j = 1:3
            subplot(3,3,(i-1)*3+j)      
            img = mat2gray(real(cell2mat(gaborResult(i,j))));
            imshow(img);
            [Z, A, ~] = Zernikemoment(real(cell2mat(gaborResult(i,j))));
            title({num2str(real(Z)); [num2str(imag(Z)) 'i']});
            zernikeResult{index} = A;
            %zernikeResult{index} = extractLBPFeatures(real(cell2mat(gaborResult(i,j))),'NumNeighbors',3);
            index = index +1;
        end
    end
        
    saveas(zernikeFigure, 'results\zernikeImage.jpg');
    SetImage(app.UIAxes_3,'results\zernikeImage.jpg');
    
    app.zernikeProcessing.Visible = 'off';
    
%   %part 4 : apply HOG

    app.hogProcessing.Visible = 'on';

    %get number of pixels row and column wise
    [row, column, ~] = size(InImage);
    rows = floor(row/3);
    columns = floor(column/3);
    
    %desired cell size block size and bins
    cellsize = [rows columns];
    blocksize = [1 1];
    bin = 9;
    
    %extract HOG features and store in global variable
    [featureVector, hogVisual] = extractHOGFeatures(InImage,'cellsize',cellsize,'BlockSize',blocksize,'NumBins',bin);
    
    %convert data type from single to double
    featureVector = double(featureVector);
    
    %local feature vector generated
    hogResult = num2cell(featureVector);
    
    %save the hog result as image file to results folder
    hogFigure = figure('visible','off','NumberTitle','Off','Name','HOG filters on input image');
    imshow(InImage);
    hold on;
    plot(hogVisual);
    saveas(hogFigure, 'results\HOGImage.jpg');

    %display hog image in UIAxes as a result
    SetImage(app.UIAxes_4,'results\HOGImage.jpg');
    
    app.hogProcessing.Visible = 'off';
    
%   %part 5 : apply Nearest neighbour

    app.nearestNeighbourProcessing.Visible = 'on';

    %generate ggz feature    
    ggzFeature = cell(1,90);
    
    for i = 1:9
        ggzFeature{i} = zernikeResult{i};
    end
    
    for j = 10:90
        ggzFeature{j} = hogResult{j-9};
    end
    
    
    %convert cell to matrix type
    ggzFeature = cell2mat(ggzFeature);
    %check whether db exists
    if exist('database\database.mat', 'file')
        %read data from existing db
        val = load('database\database.mat','db','dblabel');
        db = val.db;
        dblabel = val.dblabel;
        
        %run the nearest neighbour classification
        index = knnsearch(db,ggzFeature);
        
        %set the name label in edit field as output
        str = dblabel(index);
        app.NameofmatchedpersonTextArea.Value = str;
        
        %set original and matched image to UIAxes
        SetImage(app.UIAxes_original,'results\inputImage.jpg');
        matched = strcat('database\images\',strcat(num2str(index),'.jpg'));
        SetImage(app.UIAxes_matched,matched);
    else
        app.NameofmatchedpersonTextArea.Value = ' ! Database Empty';
        app.nearestNeighbourProcessing.Visible = 'off';
        disp('database does not exist!');
        return;
    end
    
    app.nearestNeighbourProcessing.Visible = 'off';
    
    fclose('all');
    
    clear all;
end
