function results = DeleteAllDatabase()
%DELETEALLDATABASE function used to delete the entire trained dataset

    %delete database\database.mat file containing trained data
    delete 'database\*.mat';
    
    %delete the entire trained images from databse\images
    delete 'database\images\*.jpg';
    
    disp('All dataset deleted!');
end

