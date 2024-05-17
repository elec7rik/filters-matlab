% Measure time taken for processing
tic;

% Read the original image
original_image = imread('cameraman.jpg');

% Convert to grayscale if it's an RGB image
if size(original_image, 3) == 3
    original_image = rgb2gray(original_image);
end

% Generate Gaussian noise
sigma_noise = 25; % Standard deviation of Gaussian noise
gaussian_noise_double = sigma_noise * randn(size(original_image)); % Generating in double format

% Cast Gaussian noise to the same data type as the original image
gaussian_noise = cast(gaussian_noise_double, class(original_image));

% Add Gaussian noise to the original image
noisy_image = double(original_image) + double(gaussian_noise); % Casting to double for computation

% Define the size of the filter
filter_size = 3;
% radius = (filter_size - 1) / 2;

% Create the circular filter
pillbox_filter = ones(filter_size);
pillbox_filter(1, 1) = 0;
pillbox_filter(1, end) = 0;
pillbox_filter(end, 1) = 0;
pillbox_filter(end, end) = 0;
pillbox_filter = double(pillbox_filter);
pillbox_filter = pillbox_filter / sum(pillbox_filter(:)); % Normalize the filter

% Display the Circular filter
disp('Circular Filter Kernel:');
disp(pillbox_filter);

% Apply the circular filter using convolution to smooth the noisy image
smoothed_image = conv2(noisy_image, pillbox_filter, 'same');

% Convert smoothed_image back to the same data type as original_image
smoothed_image = cast(smoothed_image, class(original_image));

% Calculate PSNR and MSE for original and noisy images
max_intensity = double(max(original_image(:)));
mse = mean((double(original_image(:)) - double(smoothed_image(:))).^2);
psnr_value = 10 * log10(max_intensity^2 / mse);

% Display PSNR and MSE
fprintf('PSNR: %.2f dB\n', psnr_value);
fprintf('MSE: %.2f\n', mse);

% Display original, noisy, and filtered images
figure;
subplot(1, 3, 1);
imshow(uint8(original_image));
title('Original Image');

subplot(1, 3, 2);
imshow(uint8(noisy_image));
title('Noisy Image');

subplot(1, 3, 3);
imshow(uint8(smoothed_image));
title('Smoothed Image');

% Measure and display time taken
timetaken = toc;
fprintf('Time taken for processing: %.4f seconds\n', timetaken);
