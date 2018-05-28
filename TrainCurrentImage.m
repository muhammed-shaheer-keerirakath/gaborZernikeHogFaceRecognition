function results = TrainCurrentImage(fname, label)
%TRAINDATASET function used to train dataset

    InImage = imread(fname);
    
    % Check if the input image is grayscale, convert if not
    if size(InImage,3) == 3
        InImage = rgb2gray(InImage);
    end
    
    %perform all the required functions to genrate ggz feature
%	%part 1 : select input image (done!)
    disp('training part : 1')
    
%   %part 2 : apply gabor filter
    %create a gabor array of scale 3 and orientation 3
    gaborArray = GaborFilterBank();
    
    %apply gabor filter bank to image and assign the output images to gaborResult
    gaborResult = GaborFeatures(InImage,gaborArray);
    disp('training part : 2')
    
%   %part 3 : apply zernike moment    
    %feature vector
    zernikeResult = cell(1,9);
    index = 1;
    
    %find zernike moment for images
    for i = 1:3
        for j = 1:3
            [~, A, ~] = Zernikemoment(real(cell2mat(gaborResult(i,j))));
            zernikeResult{index} = A;
            index = index +1;
        end
    end
    disp('training part : 3')
    
%   %part 4 : apply HOG
    %get number of pixels row and column wise
    [row, column, ~] = size(InImage);
    rows = floor(row/3);
    columns = floor(column/3);
    
    %desired cell size block size and bins
    cellsize = [rows columns];
    blocksize = [1 1];
    bin = 9;
    
    %extract HOG features and store in global variable
    [featureVector, ~] = extractHOGFeatures(InImage,'cellsize',cellsize,'BlockSize',blocksize,'NumBins',bin);
    
    %convert data type from single to double
    featureVector = double(featureVector);
    
    %local feature vector generated
    hogResult = num2cell(featureVector);
    disp('training part : 4')
    
%   %part 5 : Generate and store new feature vector
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
    
    %get the user entered name label
    nameLabel = label;
    
    %check whether db exists
    if exist('database\database.mat', 'file')
        %append data to existing db
        val = load('database\database.mat','db','dblabel');
        db = val.db;
        db = [db;ggzFeature];
        
        dblabel = val.dblabel;
        dblabel{end+1} = nameLabel;        
        save('database\database.mat','db','dblabel');
        
        %write input dataset image to database folder
        fname = strcat('database\images\',strcat(num2str(numel(dblabel)),'.jpg'));
        imwrite(InImage,fname);        
    else
        %create and store to fresh db
        db = ggzFeature;
        dblabel = {nameLabel};        
        save('database\database.mat','db','dblabel');
        
        %write input dataset image to database folder
        imwrite(InImage,'database\images\1.jpg');                
    end
    disp('training part : 5')
    fclose('all');
end

