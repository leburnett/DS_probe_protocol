% Run through functions for processing DS_probe_protocol data
% Created by Burnett - 21 May 2024

%% Process the data
% % Run through all experiment folders and process the data. 
date_folder = '05_21_2024';
% process_ds_probe_protocol_data(date_folder);


%% H bar - 2 pixels, OFF

st_idx = 1;
stop_idx = 4; 

pixel_width = '6';
stim_type = 'bar';
orient_str = 'H';
on_off = 'OFF';

process_bar(date_folder, st_idx, stop_idx, pixel_width, stim_type, orient_str, on_off)

%% H bar - 6 pixel, OFF
st_idx = 5;
stop_idx = 8; 

pixel_width = '6';
stim_type = 'bar';
orient_str = 'H';
on_off = 'OFF';

process_bar(date_folder, st_idx, stop_idx, pixel_width, stim_type, orient_str, on_off)

%% V bar - 2 pixels, OFF

st_idx = 9;
stop_idx = 12; 

pixel_width = '2';
stim_type = 'bar';
orient_str = 'V';
on_off = 'OFF';

process_bar(date_folder, st_idx, stop_idx, pixel_width, stim_type, orient_str, on_off)

%% V bar - 6 pixel, OFF
st_idx = 13;
stop_idx = 16; 

pixel_width = '6';
stim_type = 'bar';
orient_str = 'V';
on_off = 'OFF';

process_bar(date_folder, st_idx, stop_idx, pixel_width, stim_type, orient_str, on_off)


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

%% H bar - 2 pixels, ON

st_idx = 96;
stop_idx = 99; 

pixel_width = '6';
stim_type = 'bar';
orient_str = 'H';
on_off = 'ON';

process_bar(date_folder, st_idx, stop_idx, pixel_width, stim_type, orient_str, on_off)

%% H bar - 6 pixel, ON
st_idx = 100;
stop_idx = 103; 

pixel_width = '6';
stim_type = 'bar';
orient_str = 'H';
on_off = 'ON';

process_bar(date_folder, st_idx, stop_idx, pixel_width, stim_type, orient_str, on_off)

%% V bar - 2 pixels, ON

st_idx = 104;
stop_idx = 107; 

pixel_width = '2';
stim_type = 'bar';
orient_str = 'V';
on_off = 'ON';

process_bar(date_folder, st_idx, stop_idx, pixel_width, stim_type, orient_str, on_off)

%% V bar - 6 pixel, ON
st_idx = 108;
stop_idx = 111; 

pixel_width = '6';
stim_type = 'bar';
orient_str = 'V';
on_off = 'ON';

process_bar(date_folder, st_idx, stop_idx, pixel_width, stim_type, orient_str, on_off)

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 


%% D bar - 6 pixel, OFF
st_idx = 17;
stop_idx = 20; 

pixel_width = '6';
stim_type = 'bar';
orient_str = 'D';
on_off = 'OFF';

process_bar(date_folder, st_idx, stop_idx, pixel_width, stim_type, orient_str, on_off)

%% -D bar - 6 pixels, OFF

st_idx = 21;
stop_idx = 24; 

pixel_width = '6';
stim_type = 'bar';
orient_str = '-D';
on_off = 'OFF';

process_bar(date_folder, st_idx, stop_idx, pixel_width, stim_type, orient_str, on_off)

%% D bar - 6 pixel, ON
st_idx = 112;
stop_idx = 115; 

pixel_width = '6';
stim_type = 'bar';
orient_str = 'D';
on_off = 'ON';

process_bar(date_folder, st_idx, stop_idx, pixel_width, stim_type, orient_str, on_off)

%% -D bar - 6 pixels, ON

st_idx = 116;
stop_idx = 119; 

pixel_width = '6';
stim_type = 'bar';
orient_str = '-D';
on_off = 'ON';

process_bar(date_folder, st_idx, stop_idx, pixel_width, stim_type, orient_str, on_off)



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

%% V EDGE - ON

st_idx = 120;
stop_idx = 123; 

pixel_width = '6';
stim_type = 'edge';
orient_str = 'V';
on_off = 'ON';

process_bar(date_folder, st_idx, stop_idx, pixel_width, stim_type, orient_str, on_off)


%% H EDGE - ON

st_idx = 124;
stop_idx = 127; 

pixel_width = '6';
stim_type = 'edge';
orient_str = 'H';
on_off = 'ON';

process_bar(date_folder, st_idx, stop_idx, pixel_width, stim_type, orient_str, on_off)


%% V EDGE - OFF

st_idx = 25;
stop_idx = 28; 

pixel_width = '6';
stim_type = 'edge';
orient_str = 'V';
on_off = 'OFF';

process_bar(date_folder, st_idx, stop_idx, pixel_width, stim_type, orient_str, on_off)


%% H EDGE - OFF

st_idx = 29;
stop_idx = 32; 

pixel_width = '6';
stim_type = 'edge';
orient_str = 'H';
on_off = 'OFF';

process_bar(date_folder, st_idx, stop_idx, pixel_width, stim_type, orient_str, on_off)


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

% V GRATINGS 

st_idx = 33;
stop_idx = 46; 

pixel_width = '12';
stim_type = 'gratings';
orient_str = 'V';

process_gratings(date_folder, st_idx, stop_idx, pixel_width, stim_type, orient_str)

% H GRATINGS 

st_idx = 47;
stop_idx = 60; 

pixel_width = '12';
stim_type = 'gratings';
orient_str = 'H';

process_gratings(date_folder, st_idx, stop_idx, pixel_width, stim_type, orient_str)

% D GRATINGS 

st_idx = 61;
stop_idx = 74; 

pixel_width = '12';
stim_type = 'gratings';
orient_str = 'D';

process_gratings(date_folder, st_idx, stop_idx, pixel_width, stim_type, orient_str)

% -D GRATINGS 

st_idx = 75;
stop_idx = 88; 

pixel_width = '12';
stim_type = 'gratings';
orient_str = '-D';

process_gratings(date_folder, st_idx, stop_idx, pixel_width, stim_type, orient_str)



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 


% FLASHES

st_idx = 89;
stop_idx = 95; 

stim_type = 'flashes';
process_flashes(date_folder, st_idx, stop_idx, stim_type)
















