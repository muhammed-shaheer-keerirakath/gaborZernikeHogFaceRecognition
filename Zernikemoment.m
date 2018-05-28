function [Z, A, Phi] = Zernikemoment(p)
% -------------------------------------------------------------------------
% Copyright C 2014 Amir Tahmasbi
% Texas A&M University
% amir.tahmasbi@tamu.edu
% http://people.tamu.edu/~amir.tahmasbi/index.html
%
% License Agreement: To acknowledge the use of the code please cite the 
%                    following papers:
%
% [1] A. Tahmasbi, F. Saki, S. B. Shokouhi, 
%     Classification of Benign and Malignant Masses Based on Zernike Moments, 
%     Comput. Biol. Med., vol. 41, no. 8, pp. 726-735, 2011.
%
% [2] F. Saki, A. Tahmasbi, H. Soltanian-Zadeh, S. B. Shokouhi,
%     Fast opposite weight learning rules with application in breast cancer 
%     diagnosis, Comput. Biol. Med., vol. 43, no. 1, pp. 32-41, 2013.
%
% -------------------------------------------------------------------------
% Function to find the Zernike moments for an N x N binary ROI
%
% [Z, A, Phi] = Zernikmoment(p,n,m)
% where
%   p = input image N x N matrix (N should be an even number)
%   n = The order of Zernike moment (scalar)
%   m = The repetition number of Zernike moment (scalar)
% and
%   Z = Complex Zernike moment 
%   A = Amplitude of the moment
%   Phi = phase (angle) of the mement (in degrees)
%
% Example: 
%   1- calculate the Zernike moment (n,m) for an oval shape,
%   2- rotate the oval shape around its centeroid,
%   3- calculate the Zernike moment (n,m) again,
%   4- the amplitude of the moment (A) should be the same for both images
%   5- the phase (Phi) should be equal to the angle of rotation

%order of zernike moment
n = 4;
%repetation number of zernike moment
m = 0;


p = imresize(p,[100 100],'lanczos3');

N = size(p,1);
x = 1:N; y = x;
[X,Y] = meshgrid(x,y);
R = sqrt((2.*X-N-1).^2+(2.*Y-N-1).^2)/N;
Theta = atan2((N-1-2.*Y+2),(2.*X-N+1-2));
R = (R<=1).*R;
Rad = Radialpoly(R,n,m);    % get the radial polynomial

Product = p(x,y).*Rad.*exp(-1i*m*Theta);
Z = sum(Product(:));        % calculate the moments

cnt = nnz(R)+1;             % count the number of pixels inside the unit circle
Z = (n+1)*Z/cnt;            % normalize the amplitude of moments
A = abs(Z);                 % calculate the amplitude of the moment
Phi = angle(Z)*180/pi;      % calculate the phase of the mement (in degrees