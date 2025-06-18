# PCB Thermal Defect Detection System

This MATLAB project simulates and analyzes thermal images of printed circuit boards (PCBs) to detect faulty solder joints using image processing. It generates synthetic thermal images, identifies hotspots (defective areas), and compiles the results into a multi-page PDF report that includes annotated images and tabular data.

## Features

- Synthetic PCB thermal image generator
- Automatic hotspot detection using image processing
- Annotated result visualization (green markers on hotspots)
- Tabular output with centroid coordinates and defect area
- Side-by-side comparison of raw and processed images
- Auto-generated multi-page PDF report (1 page per PCB)
- Automatic cleanup of intermediate files

## Folder Structure

- `runPCBAnalysis.m` – Main function (entry point)
- `generateMultiplePCBs.m` – Generates multiple thermal test images
- `generateSyntheticPCB.m` – Simulates one synthetic PCB image
- `reports/` – (Optional) Contains generated PDF reports
- `.gitignore` – Excludes temp and output files from Git

## How to Run

1. Clone the repo: git clone https://github.com/joeyjhkim/pcb-defect-detector.git

2. Open the project in MATLAB

3. In the command window, run:
runPCBAnalysis(10)
or any value [1, 10]. These are the number of faulty PCBs that are generated and analyzed.


## Example Output
The output of this project is a formatted, timestamped PDF report named like: PCB_Hotspot_Report_20250617_154512.pdf
