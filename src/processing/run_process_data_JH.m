
addpath(genpath('C:\Users\hoellerj\Documents\GitHub\G4_Display_Tools'))

TDMS_file_path = 'O:\Burnett\Jinyong\DS_probe_protocol_1REP_RightHemi_20Hz_05-22-24_09-09-09\05_23_2024\SS00395XJFRC28_TmY3-12_40_02\';
sett_file_path = 'C:\Users\hoellerj\Documents\GitHub\DS_probe_protocol\results\processing_settings.mat';

process_data(TDMS_file_path, sett_file_path)