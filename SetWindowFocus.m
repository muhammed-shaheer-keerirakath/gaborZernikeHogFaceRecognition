function results = SetWindowFocus(app)
%SETWINDOWFOCUS function to set the focus back to window if in case gone to
%background.
% Bring back the gui to foreground by turning it off, then turning it on
    app.GGZFaceRecognitionUIFigure.Visible = 'off';
    app.GGZFaceRecognitionUIFigure.Visible = 'on';
end

