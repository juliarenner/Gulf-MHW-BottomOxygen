# Gulf-MHW-BottomOxygen

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
│   └── MHW_BottomOxygen_Analysis.m
└── LICENSE
└── README.md
```

---

## Getting Started

### Prerequisites
- MATLAB (R2021a or later recommended)
- m_mhw toolbox: [GitHub](https://github.com/ZijieZhaoMMHW/m_mhw1.0?tab=readme-ov-file)

### Usage
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/Gulf-MHW-BottomOxygen.git
   ```
2. Open MATLAB and navigate to the `script/` directory.
3. Open `MHW_BottomOxygen_Analysis.m` and run the script to reproduce the analysis and generate plots.

---

## Outputs
The analysis produces:
- Interpolated bottom oxygen map
- Total marine heatwave days map
- Scatterplot showing relationship between bottom oxygen and MHW days
- Boxplots comparing coastal and offshore regions for both bottom oxygen and MHW days

These are present in the `images/` directory.

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
