function results = SetImage(UIAxes, image_location )
%SETIMAGE Function used to set specified image to an axes component specified
%   Detailed explanation goes here

    % Remove title, axis labels, and tick labels from All UIAxes
    title(UIAxes, []);
    xlabel(UIAxes, []);
    ylabel(UIAxes, []);
    UIAxes.XAxis.TickLabels = {};
    UIAxes.YAxis.TickLabels = {};

    % Display image and stretch to fill axes
    I1 = imshow(image_location, 'Parent', UIAxes, ...
        'XData', [1 UIAxes.Position(3)], ...
        'YData', [1 UIAxes.Position(4)]);
    % Set limits of axes
    UIAxes.XLim = [0 I1.XData(2)];
    UIAxes.YLim = [0 I1.YData(2)];
end

