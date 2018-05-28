%file created on 4 March 2018 by Shaheer Shukur
function results = InitializeStartupSettings(app)
%Function to carry out startup tasks    

    %hide unnecessary labels
    app.selectImageProcessing.Visible = 'off';
    app.gaborProcessing.Visible = 'off';
    app.zernikeProcessing.Visible = 'off';
    app.hogProcessing.Visible = 'off';
    app.nearestNeighbourProcessing.Visible = 'off';
    
    app.NameofmatchedpersonTextArea.Value = '';

    %set a default image for Axes components on startup
    SetImage(app.UIAxes, 'initialize\select_image.jpg');
    SetImage(app.UIAxes_2, 'initialize\gabor_filter.jpg');
    SetImage(app.UIAxes_3, 'initialize\zernike_moment.jpg');
    SetImage(app.UIAxes_4, 'initialize\hog_transform.jpg');
    SetImage(app.UIAxes_original, 'initialize\image_original.jpg');
    SetImage(app.UIAxes_matched, 'initialize\image_matched.jpg');
end