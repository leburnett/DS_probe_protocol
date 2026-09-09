# DS Probe Protocol

Processes and analyses patch-electrophysiology recordings from the direction-selectivity
probe protocol, run on the G4 LED arena.

**Version** README v1 · **Status** maintained · **Last verified** not yet verified

## What this does

- Processes raw G4 recordings into per-cell response data for each stimulus type.
- Quantifies directional tuning from moving bars and gratings, and temporal responses from
  flickers and flashes.
- Reconstructs receptive fields from multi-direction bar responses.
- Assembles a combined per-cell results PDF.

**You will need:** MATLAB ·
[`G4_Display_Tools`](https://github.com/leburnett/G4_Display_Tools) on the path ·
a `processing_settings.mat` · the recordings themselves, which are **not in this repo**.

**Whose data:** these are the patch experiments conducted by **Jinyong Park** from May 2024
onwards. The repo holds the analysis code only; the recordings live outside it, and
`exp_recording_log.xlsx` is the index of which cell is which.

## Quick start

1. **Add the source tree to the MATLAB path**
   ```matlab
   addpath(genpath('src'))
   ```
2. **Point the processing script at your data** — edit the top of
   `src/run_core_processing.m`:
   ```matlab
   date_to_process = '10_08_2024';   % or '' to process every date
   cell_type       = 'T4T5';
   protocol_folder = '<path to>/DS_probe_protocol_1REP_RightHemi_20Hz_05-22-24_09-09-09/';
   ```
3. **Process one day**
   ```matlab
   run_core_processing
   ```
   Steps through every experiment folder for that date and writes processed response data
   alongside the recordings.

## Repository map

| Directory | Contents |
|---|---|
| `Protocol/` | The G4 protocol these recordings used (`DS_probe_protocol_1REP_RightHemi_20Hz_…`) |
| `src/processing/` | Preprocessing, per-cell processing, directional tuning, flicker FFT |
| `src/plotting/` | Polar and line plots of averaged bar responses |
| `src/rf_analysis/` | Receptive-field reconstruction (4- and 8-direction) and temporal RF |
| `src/pdf_generation/` | Builds the combined per-cell results PDF |
| `src/utils/`, `src/external_functions/` | Helpers and third-party functions |
| `src/old/` | Superseded scripts, kept for reference |
| `cache/` | Intermediate outputs |

## Workflow

1. **Present the protocol** — the `.g4p` protocol in `Protocol/` is run on the G4 arena
   during the patch recording.
2. **Create the processing settings** — run `create_processing_settings.m` from
   `G4_Display_Tools` once, to produce `processing_settings.mat`.
3. **Process** — `run_core_processing` (see Quick start), which calls
   `process_ds_probe_protocol_data` over each experiment folder for a date.
4. **Plot by stimulus type** — one script per stimulus, each with the date and paths set at
   the top:
   ```matlab
   run_core_plotting_bars        % moving bars, 6 directions
   run_core_plotting_thin_bars   % thin-bar variant
   run_core_plotting_gratings    % drifting gratings
   run_core_plotting_flickers    % full-field flicker, with FFT
   ```
5. **Receptive fields** — `reconstruct_rf_8dir`, `reconstruct_rf_4dir`, `est_tempRF_8dir`.
6. **Combined PDF** — `src/pdf_generation/generate_combined_pdf.py`.

## Key data types

| Item | Contents |
|---|---|
| `processing_settings.mat` | Channel and trial settings for `G4_Display_Tools` processing |
| `Protocol_details.mat` | `block_trials` — the trial structure, used by the RF analyses |
| `exp_recording_log.xlsx` | Master log of recordings: cell, date, hemisphere, quality |
| `Stimuli_idx_values.xlsx` | Stimulus index lookup for the protocol conditions |

## File naming conventions

- **Protocol folders:** `DS_probe_protocol_1REP_<hemisphere>_<rate>_<MM-DD-YY>_<HH-MM-SS>`
- **Experiment folders:** cell ID, beginning `42…`, inside a date folder
- **Date folders:** `MM_DD_YYYY`

## Conventions & gotchas

- **There is no single configuration point.** Each `run_core_*` script has its data paths
  and the date to process set in variables at the top, and several still contain another
  machine's absolute paths — edit before running.
- `src/old/` and `.asv` files are superseded; prefer the non-`old` versions.
- Date-folder listing assumes macOS (it skips three entries to allow for `.DS_Store`); on
  Windows or Linux that skip needs to be two.

## Contact

Laura Burnett, Reiser Lab, HHMI Janelia Research Campus.
Recordings by Jinyong Park.
