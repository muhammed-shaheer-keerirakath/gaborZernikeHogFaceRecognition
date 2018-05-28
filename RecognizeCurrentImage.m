function match = RecognizeCurrentImage(fname, label)
%RECOGNIZECURRENTIMAGE function to recognize the current image being
%processed

%   %part1: read the current image
    InImage = imread(fname);
    
    % Check if the input image is grayscale, convert if not
    if size(InImage,3) == 3
        InImage = rgb2gray(InImage);
    end
    disp('recognizing part : 1')
    
%   %part2: apply gabor filter
    %create a gabor array of scale 3 and orientation 3
    gaborArray = GaborFilterBank();
    
    %apply gabor filter bank to image and assign the output images to gaborResult
    gaborResult = GaborFeatures(InImage,gaborArray);
    disp('recognizing part : 2')
    
%   %part3: apply zernike moment
    %feature vector
    zernikeResult = cell(1,9);
    index = 1;
    
    % get result of zernike moment
    for i = 1:3
        for j = 1:3
            %each one of 9 gabor image is used for zerike
            [~, A, ~] = Zernikemoment(real(cell2mat(gaborResult(i,j))));
            zernikeResult{index} = A;
            index = index +1;
        end
    end
    disp('recognizing part : 3')
    
%   %part4: apply HOG
    %get number of pixels row and column wise
    [row, column, ~] = size(InImage);
    rows = floor(row/3);
    columns = floor(column/3);
    
    %desired cell size, block size and bins according to ref. paper
    cellsize = [rows columns];
    blocksize = [1 1];
    bin = 9;
    
    %extract HOG features and store in global variable
    [featureVector, ~] = extractHOGFeatures(InImage,'cellsize',cellsize,'BlockSize',blocksize,'NumBins',bin);
    
    %convert data type from single to double
    featureVector = double(featureVector);
    
    %local feature vector generated
    hogResult = num2cell(featureVector);
    disp('recognizing part : 4')
    
%   %part5: apply Nearest neighbour
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
    
    %Recognition part..
    %read data from existing db
    val = load('database\database.mat','db','dblabel');
    db = val.db;
    dblabel = val.dblabel;
    
    %run the nearest neighbour classification
    index = knnsearch(db,ggzFeature,'Distance','euclidean');
    
    %get the name of matched image
    str = dblabel(index);
    
    %returns 0 or 1, depending on recognition
    match =  strcmpi(str,label);   
    disp('recognizing part : 5')
    fclose('all');
end

