.. include:: <isonum.txt>

Concepts
========

Tsim relies on three basic concepts that have proven very useful in all the years of its existence: the dataset as fundamental unit containing data and accompanying metadata, as developed for the `trEPR toolbox <https://github.com/tillbiskup/matlab-trepr>`_, a command-line interface guiding the user through the process of fitting (or simulating) triplet spectra, and well-formatted reports using a template engine and LaTeX presenting the results of the fitting in a unified and easily accessible manner.


Dataset
-------

The dataset is a fundamental concept of the `trEPR toolbox <https://github.com/tillbiskup/matlab-trepr>`_. It contains both, data and metadata, and the complete history of what has happened to the data. The Tsim toolbox operates on these datasets, adding fields to its structure. Thus, as long as you save the datasets resulting from a simulation or fit using Tsim, you can at any time with a simple one-liner recreate the report of the results, besides having full access to the data, the fitted simulation, and the parameters used.

The dataset as an essential concept has been further developed and is a core element of the `ASpecD framework <https://www.aspecd.de/>`_ developed in Python for the Analysis of Spectral Data.


Command-line interface
----------------------

Fitting triplet spectra requires quite a number of parameters to be set by the user. To relieve the user from having to know all these parameters in advance, and to add some interactive element, Tsim provides a command-line interface (CLI) guiding the user through the entire process from loading data to the final report generation.

Although the CLI consists of several nested loops, it provides usually a rather linear workflow, ensuring that all necessary parameters are present. Sensible setting of default parameters and answers allows users to hit Enter multiple times to get up and running as soon as possible.


Well-formatted reports
----------------------

Fitting data is only the first step towards interpreting the results. Furthermore, often several fits are performed for one and the same dataset with different starting parameters and different parameters fitted and kept fixed, respectively. Therefore, it is essential to have the results presented in a uniform manner. Only then an easy a--b comparison is possible.

To achieve this, the Tsim toolbox ships with LaTeX templates and a template engine and automatically creates those reports for you as soon as you have finished a run. Having all the parameters well-formatted and always in the same place tremendously speeds up the analysis and interpretation of the results.
