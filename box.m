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

tic
% Define the circular (pillbox) filter
filterSize = 3;
[X, Y] = meshgrid(1:filterSize);
center = (filterSize + 1) / 2;
radius = filterSize / 2;
circle = (X - center).^2 + (Y - center).^2 <= radius.^2;
pillbox_filter = circle / sum(circle(:));

% Apply the circular filter using convolution to smooth the noisy image
smoothed_image = conv2(noisy_image, pillbox_filter, 'same');
time = toc;

% Convert smoothed_image back to the same data type as original_image
smoothed_image = cast(smoothed_image, class(original_image));

% Display the original, noisy, and smoothed images
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

% Display the kernel of the circulaar filter
disp('Filter size: ');
disp(filterSize);
disp("pillbox_filter_kernel: ");
disp(pillbox_filter);
disp('Time taken');
disp(time);

% Display PSNR and MSE
fprintf('PSNR: %.2f dB\n', psnr_value);
fprintf('MSE: %.2f\n', mse);
