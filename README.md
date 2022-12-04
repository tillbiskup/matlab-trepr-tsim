# Tsim Toolbox

Tsim is a module for the [trEPR Toolbox](https://github.com/tillbiskup/matlab-trepr) that lets you simulate and fit spin-polarised triplet spectra recorded with time-resolved electron paramagnetic resonance (TREPR) spectroscopy. For simulation capabilities, it relies on the well-proven [EasySpin toolbox](https://easyspin.org/), fitting is performed using the functionality provided by the MATLAB(r) Optimization Toolbox(tm).

For more information type "TsimInfo" at the Matlab(r) command line.

To start simulating/fitting, use the function "Tsim".


## Features

* Comfortable command-line interface (CLI) for fit and simulation
* Modular design
* Reproducibility: all routines operate on datasets
* Support for different input file formats
* Integrated help
* Automatically generated reports: well-formatted presentation of results
* Complete simulation and fit history


## Documentation

Documentation of the Tsim toolbox is available under [https://tsim.docs.till-biskup.de/](https://tsim.docs.till-biskup.de/).


## Installation

The Tsim toolbox for MATLAB(r) comes with a dedicated installer. Therefore, it is *highly recommended* to use this installer to get a properly working installation of the Tsim toolbox.

  * Download the source code (from [GitHub](https://github.com/tillbiskup/matlab-trepr-tsim>)).
  * Start MATLAB(r)
  * Change to the folder you've downloaded (and unpacked) the source code to
  * Change to the 'internal' subdirectory
  * Call the ``TsimInstall`` function

This will add all necessary (and only the necessary) folders to the MATLAB(r) path and place configuration and templates in their respective folders in your user's home directory.


## How to cite

The Tsim toolbox is free software. However, if using this program leads to a publication, please mention it in the methods section and cite the following reference:

 * Deborah L. Meyer, Florian Lombeck, Sven Huettner, Michael Sommer, Till Biskup. 
Direct S0→T Excitation of a Conjugated Polymer Repeat Unit: Unusual Spin-Forbidden Transitions Probed by Time-Resolved Electron Paramagnetic Resonance Spectroscopy. *J. Phys. Chem. Lett.*, **8**:1677–1682, 2017. doi:[10.1021/acs.jpclett.7b00644](https://dx.doi.org/10.1021/acs.jpclett.7b00644)


## License

The toolbox is distributed under the GNU Lesser General Public License (LGPL) as published by the Free Software Foundation.

This ensures both, free availability in source-code form and compatibility with the (closed-source and commercial) MATLAB(r) environment.


## Authors

* Deborah Meyer (2013-15)

    The principal author and main developer of the Tsim toolbox

* Till Biskup (2013-2022)

    Maintainer of the Tsim toolbox.


## Related projects

There is a number of related projects you may be interested in, both for MATLAB(r) as well as Python. Have a look at the section with related Python projects as well that are actively being developed.


### MATLAB(r) projects

* [trepr toolbox](https://github.com/tillbiskup/matlab-trepr)

    Toolbox for preprocessing, display, analysis, and postprocessing of transient (*i.e.*, time-resolved) electron spin resonance spectroscopy (in short: trEPR) data. Spiritual predecessor of the [trepr package](https://docs.trepr.de/) implemented in Python. Each processing and analysis step gets automatically logged with all parameters to ensure reproducibility. Focusses particularly on automating the pre-processing and representation of data.

* [cwepr toolbox](https://github.com/tillbiskup/matlab-cwepr)

    Toolbox for analysing cwEPR data (common Toolbox based). Spiritual predecessor of the [cwepr package](https://docs.cwepr.de/) implemented in Python. Each processing and analysis step gets automatically logged with all parameters to ensure reproducibility. Focusses particularly on automating the pre-processing and representation of data.


### Python projects

* [ASpecD framework](https://docs.aspecd.de/)

    A Python framework for the analysis of spectroscopic data focussing on reproducibility and good scientific practice, developed by T. Biskup.

* [trEPR package](https://docs.trepr.de/)

    Python package for processing and analysing time-resolved electron paramagnetic resonance (trEPR) data, developed by J. Popp, currently developed and maintained by M. Schröder and T. Biskup.

* [cwepr package](https://docs.cwepr.de/)

    Python package for processing and analysing continuous-wave electron paramagnetic resonance (cw-EPR) data, originally implemented by P. Kirchner, developed and maintained by M. Schröder and T. Biskup.

* [FitPy](https://docs.fitpy.de/)

    Python framework for the advanced fitting of models to spectroscopic data focussing on reproducibility, developed by T. Biskup.
