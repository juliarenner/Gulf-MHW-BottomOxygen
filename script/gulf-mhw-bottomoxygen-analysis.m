% Julia Renner 
% Climate Data & Analysis Project
% Spring, 2025

% Project Title: Exploring the Influence of Bottom Oxygen Gradients on 
% Marine Heatwave Severity in the Gulf of Mexico (1992–2023)

% FOCUS: Does the natural spatial gradient of baseline bottom oxygen concentrations 
% in the Gulf of Mexico correspond to patterns of marine heatwave severity?

clear
close all
clc

addpath('/Users/julia/CD&A-MHW-Project')  % Replace with respective path to your script directory including data files and detection algorithm

%% Gulf of Mexico SST data loading

sst_info = ncinfo('OISSTv2p1_Gulf.nc');

% info
% Variable names
% 'T'
% 'zlev'
% 'lat'
% 'lon'
% sst

% Load variables
sst = double(ncread('OISSTv2p1_Gulf.nc','sst')); % units = degrees celsius
lat = double(ncread('OISSTv2p1_Gulf.nc','lat')); % units = degrees north
lon = double(ncread('OISSTv2p1_Gulf.nc','lon')); % units = degrees east
time = double(ncread('OISSTv2p1_Gulf.nc','T')); % units = julian days

% Check sizes and confirm correct loading
% size(sst) -- lon x lat x zlev (depth) x time
% size(lat) -- 64
% size(lon) -- 80
% size(time) -- 15765

% Convert Julian Day to MATLAB datenum
timeMAT = floor(time - 1721058.5);
% floor to remove fraction days

% Convert MATLAB datenum to calendar date components
timeVEC = datevec(timeMAT);

% Sanity check — print first/last dates
% disp(datestr(timeMAT(1)))     % 01-Sep-1981 12:00:00
% disp(datestr(timeMAT(end)))   % 29-Oct-2024 12:00:00

sst = squeeze(sst);
sst = permute(sst, [2, 1, 3]); % now lat x lon x time

% Get rid of missing data
sst(sst < -10) = NaN;

% Creating latitude/longitude mesh grid
[LON,LAT] = meshgrid(lon,lat);

% Sanity check
% size(sst)

%% Hypoxia Data Loading

oxy_info = ncinfo('1_woa23_all_o00_01.nc');

% Variables
% o_an
% time
% depth
% lat
% lon
% crs

lat_oxy = double(ncread('1_woa23_all_o00_01.nc', 'lat'));
lon_oxy = double(ncread('1_woa23_all_o00_01.nc', 'lon'));
depth_oxy = double(ncread('1_woa23_all_o00_01.nc', 'depth'));
oxygen = double(ncread('1_woa23_all_o00_01.nc', 'o_an'));

% Check sizes and confirm correct loading
% size(lat_oxy) % 180 1
% size(lon_oxy) % 360 1
% size(depth_oxy) % 102 1
% size(oxygen) % 360 180 102 : lon x lat x depth

% Find and extract bottom oxygen levels ('oxygen') at depth layer ~50m
target_depth = 50;
[~, depth_idx] = min(abs(depth_oxy - target_depth));
oxygen_bottom = squeeze(oxygen(:,:,depth_idx)); % [lon x lat]

% Subset data to the Gulf of Mexico region
lat_bounds = [15 31];
lon_bounds = [-98 -80];

lat_inds = find(lat_oxy >= lat_bounds(1) & lat_oxy <= lat_bounds(2));
lon_inds = find(lon_oxy >= lon_bounds(1) & lon_oxy <= lon_bounds(2));

% Extract and reshape
oxygen_gulf = oxygen_bottom(lon_inds, lat_inds); % Correct order [lat x lon]
lat_oxy_gulf = lat_oxy(lat_inds);
lon_oxy_gulf = lon_oxy(lon_inds);

% Meshgrid for interpolation
[LON_OXY, LAT_OXY] = meshgrid(lon_oxy_gulf, lat_oxy_gulf);

% Interpolate onto finer SST grid
oxygen_interp = interp2(LON_OXY, LAT_OXY, oxygen_gulf', LON, LAT, 'linear');

% Plot for Interpolated Bottom Oxygen Levels
figure
pcolor(LON, LAT, oxygen_interp);
shading interp
colormap('turbo')
caxis([190 215])
colorbar
xlabel('Longitude')
ylabel('Latitude')
title('Interpolated Bottom Oxygen (\mu mol/kg)', 'FontSize', 14)
geoshow('landareas.shp', 'FaceColor', [1 1 1], 'EdgeColor', 'k')
xlim([-98 -80])
ylim([15 31])
grid on
hold on
[~,hContour] = contour(LON, LAT, oxygen_interp, 190:2:215, 'LineColor', 'k');
hold off


% Extra sanity check to ensure interpolation rearranged oxygen dimensions
% size(sst(:,:,1))   % should be [64 x 80] [lat x lon]
% size(oxygen_interp) % should be [64 x 80] [lat x lon]


%% Calculate Climatology and Anomalies

clim = NaN(length(lat), length(lon), 12);
for m = 1:12
    clim(:,:,m) = mean(sst(:,:,timeVEC(:,2)==m), 3, 'omitnan');
end

sst_anom = NaN(size(sst));
for t = 1:length(timeMAT)
    this_month = timeVEC(t,2);
    sst_anom(:,:,t) = sst(:,:,t) - clim(:,:,this_month);
end

%% Marine Heatwave Detection

% MATLAB marine heatwave detection toolbox from Github (based on Hobday et al. 2016)
addpath('/Users/julia/CD&A-MHW-Project/m_mhw1.0-master/');

% Define analysis window (1992-2023)
cli_start = datenum(1992,1,1);
cli_end = datenum(2023,12,31);
mhw_start = datenum(1992,1,1);
mhw_end = datenum(2023,12,31);

% Subsetting data for the period
inds_keep = find(timeMAT >= cli_start & timeMAT <= cli_end);
sst = sst(:,:,inds_keep);
timeMAT = timeMAT(inds_keep);

% Detect marine heatwave events at each grid cell
[MHW, mclim, m90, mhw_ts] = detect(sst, timeMAT, cli_start, cli_end, mhw_start, mhw_end);

%% Total MHW days Plot

% Sum total marine heatwave days at each grid point
total_mhw_days = squeeze(nansum(mhw_ts, 3)); % [lat x lon]

% Plot total marine heatwave days spatially
figure
pcolor(LON, LAT, total_mhw_days)
shading interp
colormap('turbo')
caxis([0 2700]) % adjust to the approximate range seen
colorbar
xlabel('Longitude')
ylabel('Latitude')
title('Total Marine Heatwave Days (1992–2023)', 'FontSize', 14)
geoshow('landareas.shp', 'FaceColor', [1 1 1], 'EdgeColor', 'k')
xlim([-98 -80])
ylim([15 31])
grid on
hold on
[~,hContour] = contour(LON, LAT, total_mhw_days, 0:200:2700, 'LineColor', 'k');
hold off

%% Coastal vs Offshore Comparison

% Define Coastal region as latitude > 26°N and longitude between -95° and -86°
coastal_mask = (LAT > 26) & (LON > -95) & (LON < -86);

% Offshore region is everything else within the Gulf bounding box
offshore_mask = ~coastal_mask;

% Flatten data for analysis (
total_mhw_vec = total_mhw_days(:);
oxygen_vec = oxygen_interp(:);
coastal_vec = coastal_mask(:);

% Valid points (remove NaNs)
valid_inds = ~isnan(total_mhw_vec) & ~isnan(oxygen_vec);

% Apply valid indices first
total_mhw_vec = total_mhw_vec(valid_inds);
oxygen_vec = oxygen_vec(valid_inds);
coastal_vec = coastal_vec(valid_inds);

% Separate coastal vs offshore
mhw_coastal = total_mhw_vec(coastal_vec == 1);
mhw_offshore = total_mhw_vec(coastal_vec == 0);

oxy_coastal = oxygen_vec(coastal_vec == 1);
oxy_offshore = oxygen_vec(coastal_vec == 0);

% Boxplot for MHW days Coastal vs Offshore
figure
boxplot([mhw_coastal; mhw_offshore], ...
    [ones(size(mhw_coastal)); 2*ones(size(mhw_offshore))], ...
    'Labels', {'Coastal', 'Offshore'})
ylabel('Total MHW Days (1992–2023)')
title('Comparison of Total MHW Days: Coastal vs Offshore Regions', 'FontSize', 14)
grid on

% Mean comparison and t-test
mean_mhw_coastal = mean(mhw_coastal, 'omitnan');
mean_mhw_offshore = mean(mhw_offshore, 'omitnan');

disp(['Mean Total MHW Days (Coastal) = ', num2str(mean_mhw_coastal)]);
disp(['Mean Total MHW Days (Offshore) = ', num2str(mean_mhw_offshore)]);

% Boxplot: Bottom Oxygen Coastal vs Offshore

figure
boxplot([oxy_coastal; oxy_offshore], ...
    [ones(size(oxy_coastal)); 2*ones(size(oxy_offshore))], ...
    'Labels', {'Coastal', 'Offshore'})
ylabel('Bottom Oxygen (\mu mol/kg)')
title('Comparison of Bottom Oxygen: Coastal vs Offshore Regions', 'FontSize', 14)
grid on

% Mean comparison and t-test
mean_oxy_coastal = mean(oxy_coastal, 'omitnan');
mean_oxy_offshore = mean(oxy_offshore, 'omitnan');

disp(['Mean Bottom Oxygen (Coastal) = ', num2str(mean_oxy_coastal)]);
disp(['Mean Bottom Oxygen (Offshore) = ', num2str(mean_oxy_offshore)]);

% Test is differences are statistically significant

if ~isempty(mhw_coastal) && ~isempty(mhw_offshore)
    [~, p_mhw] = ttest2(mhw_coastal, mhw_offshore);
    disp(['Two-sample t-test p-value for MHW Days (Coastal vs Offshore) = ', num2str(p_mhw)]);
end

if ~isempty(oxy_coastal) && ~isempty(oxy_offshore)
    [~, p_oxy] = ttest2(oxy_coastal, oxy_offshore);
    disp(['Two-sample t-test p-value for Bottom Oxygen (Coastal vs Offshore) = ', num2str(p_oxy)]);
end


%% Scatter plot: Total MHW Days vs Bottom Oxygen 
% (data points colored by oxygen level)
figure
scatter(oxygen_vec, total_mhw_vec, 20, oxygen_vec, 'filled')
colormap(turbo)
cb = colorbar;
cb.Label.String = 'Bottom Oxygen (\mu mol/kg)';
cb.Label.FontSize = 11;
xlabel('Bottom Oxygen (\mu mol/kg)')
ylabel('Total MHW Days (1992–2023)')
title('Total Marine Heatwave Days vs Bottom Oxygen Levels', 'FontSize', 14)
grid on
box on
xlim([190 215])
ylim([400 1800])

% Linear regression with confidence interval
hold on
lm = fitlm(oxygen_vec, total_mhw_vec);
x_fit = linspace(min(oxygen_vec), max(oxygen_vec), 100);
[y_fit, y_ci] = predict(lm, x_fit');

% Plot regression line and confidence bounds
plot(x_fit, y_fit, 'r-', 'LineWidth', 2)
fill([x_fit fliplr(x_fit)], [y_ci(:,1)' fliplr(y_ci(:,2)')], ...
     'r', 'FaceAlpha', 0.2, 'EdgeColor', 'none')
legend('Data points', sprintf('Linear fit (r=%.2f)', corr(oxygen_vec, total_mhw_vec)), ...
    '95% Confidence Interval', 'Location', 'northwest', 'Box', 'off')
hold off

% Correlation calculation & p-values
[r,p] = corrcoef(oxygen_vec, total_mhw_vec);
disp(['Correlation coefficient r = ', num2str(r(1,2))]);
disp(['p-value = ', num2str(p(1,2))]);

