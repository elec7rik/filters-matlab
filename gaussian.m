% Read the original image
original_image = imread('cameraman.jpg');

% Convert to grayscale if it's an RGB image
if size(original_image, 3) == 3
    original_image = rgb2gray(original_image);
end

% Generate Gaussian noise
sigma = 25; % Standard deviation of Gaussian noise
gaussian_noise_double = sigma * randn(size(original_image)); % Generating in double format

% Cast Gaussian noise to the same data type as the original image
gaussian_noise = cast(gaussian_noise_double, class(original_image));

% Add Gaussian noise to the original image
noisy_image = double(original_image) + double(gaussian_noise); % Casting to double for computation


%Design the Gaussian Kernel

%Standard Deviation of Filter
sigma_filter = 1.5;

%Window size
sz = 2;
disp('Kernel size: ');
disp(2 * sz + 1);
[x,y]=meshgrid(-sz:sz,-sz:sz);
M = size(x,1)-1;
N = size(y,1)-1;
Exp_comp = -(x.^2+y.^2)/(2*sigma_filter*sigma_filter);
Kernel= exp(Exp_comp)/(2*pi*sigma_filter*sigma_filter);

% Display Kernel
disp('Kernel: ')
disp(Kernel);

%Initialize
smoothed_image=zeros(size(noisy_image));

tic

%Pad the vector with zeros
noisy_image = padarray(noisy_image,[sz sz]);

%Convolution
for i = 1:size(noisy_image,1)-M
    for j =1:size(noisy_image,2)-N
        Temp = noisy_image(i:i+M,j:j+M).*Kernel;
        smoothed_image(i,j)=sum(Temp(:));
    end
end

time = toc;
disp("Time: ")
disp(time);

% Images
figure;
subplot(1,3,1);
imshow(uint8(original_image));
title('Original Image');

subplot(1,3,2);
imshow(uint8(noisy_image));
title('Noisy Image');

subplot(1,3,3);
imshow(uint8(smoothed_image));
title('Smoothed Image');


% Calculate PSNR
max_intensity = double(max(original_image(:)));
mse = mean((double(original_image(:)) - double(smoothed_image(:))).^2);
psnr_value = 10 * log10(max_intensity^2 / mse);

% Display PSNR and MSE
fprintf('PSNR: %.2f dB\n', psnr_value);
fprintf('MSE: %.2f\n', mse);
fprintf('Time taken: %.2f\n', time);
