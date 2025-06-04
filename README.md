# Gulf-MHW-BottomOxygen Analysis Project

## Overview
This project investigates the relationship between bottom oxygen gradients and marine heatwave (MHW) severity in the Gulf of Mexico from 1992 to 2023. The analysis uses NOAA OISSTv2.1 sea surface temperature data, WOA23 bottom oxygen data, and the m_mhw MATLAB toolbox to detect and analyze MHW days across the region.

The main goals are:
- Explore how bottom oxygen levels may influence the severity and distribution of marine heatwaves based on historical data.
- Conduct statistical tests and produce visualizations to support analysis.

---

## Repository Structure
```
Gulf-MHW-BottomOxygen/
├── plot-images/
│   ├── BottomOxygenCoastalvsOffshore.jpg
│   ├── InterpolatedBottomOxygen.jpg
│   ├── TotalMarineHeatwaveDays.jpg
│   ├── TotalMarineHeatwaveDaysCoastalvsOffshore.jpg
│   └── TotalMarineHeatwaveDaysvsBottomOxygenLevels.jpg
├── project-presentation
│   └── slideshow-captioned.pdf
├── script/
│   └── gulf-mhw-bottomoxygen-analysis.m
└── LICENSE
└── README.md
```

---

## Getting Started

### Prerequisites
- MATLAB (R2021a or later recommended)
- m_mhw toolbox: [GitHub](https://github.com/ZijieZhaoMMHW/m_mhw1.0?tab=readme-ov-file)

### Usage
1. Clone this repository:
   ```bash
   git clone https://github.com/juliarenner/Gulf-MHW-BottomOxygen.git
   ```
2. Download the required data files:
- Sea Surface Temperature (OISSTv2.1): https://www.ncei.noaa.gov/products/optimum-interpolation-sst
   - Save as OISSTv2p1_Gulf.nc to your script directory
- Bottom Oxygen Data (WOA23): https://www.ncei.noaa.gov/access/world-ocean-atlas-2023/
   - Save as 1_woa23_all_o00_01.nc to your script directory
3. Install the MATLAB m_mhw toolbox (for marine heatwave detection):
- Download from GitHub: https://github.com/ZijieZhaoMMHW/m_mhw1.0
- Save to your script directory
4. Open the 'detect.m' file inside the mhw_mhw1.0 download, and within the 'if' loop from lines 145-156, wrap each instance of 'ahead_date' in 'round()' calls
4. Open MATLAB and navigate to the `script/` directory.
5. Open `MHW_BottomOxygen_Analysis.m` and run the script to reproduce the analysis and generate plots.
  
---

## Outputs
The analysis produces:
- Interpolated bottom oxygen map
- Total marine heatwave days map
- Scatterplot showing relationship between bottom oxygen and MHW days
- Boxplots comparing coastal and offshore regions for both bottom oxygen and MHW days

These are present in the `plot-images/` directory.

---

## References
- [NOAA World Ocean Atlas 2023](https://www.ncei.noaa.gov/access/world-ocean-atlas-2023/)
- [NOAA OISSTv2.1](https://www.ncei.noaa.gov/products/optimum-interpolation-sst)
- [m_mhw Toolbox](https://github.com/ZijieZhaoMMHW/m_mhw1.0?tab=readme-ov-file)

---

## License
This project is licensed under the MIT License. See the LICENSE file for details.

---

## Author
Julia Renner
