.. matlab-tsim documentation master file, created by
   sphinx-quickstart on Sat Sep  5 15:02:22 2020.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

.. include:: <isonum.txt>

Tsim documentation
==================

Welcome! This is the documentation of the Tsim toolbox for MATLAB\ |reg|. 

Tsim lets you simulate and fit spin-polarised triplet spectra recorded with time-resolved electron paramagnetic resonance (trEPR) spectroscopy. For simulation capabilities, it relies on the well-proven `EasySpin toolbox <https://easyspin.org/>`_, fitting is performed using the functionality provided by the MATLAB\ |reg| Optimization Toolbox\ |trade|.

Key to Tsim is a fully reproducible and documented workflow resulting in well-formatted reports as well as a command-line interface (CLI) guiding the user through the process of simulating and fitting the data. Thus, even Bachelor students with next to no prior knowledge of EPR spectroscopy and spectral simulations can get sensible results within reasonable time frame and presented in a form that makes life easier for both, them and their supervisors.

.. important::
   If using this program leads to a publication, please mention it in the methods section and cite the reference given in the section :ref:`How to cite <sec-how_to_cite>`.


Features
--------

  * Comfortable command-line interface (CLI) for fit and simulation
  * Modular design
  * Reproducibility: all routines operate on datasets
  * Support for different input file formats
  * Integrated help
  * Automatically generated reports: well-formatted presentation of results
  * Complete simulation and fit history


.. _sec-how_to_cite:

How to cite
-----------

Tsim is free software. However, if you use Tsim for your own research, please cite the following article:

  * Deborah L. Meyer, Florian Lombeck, Sven Huettner, Michael Sommer, Till Biskup.  Direct S\ :sub:`0`\ →T Excitation of a Conjugated Polymer Repeat Unit: Unusual Spin-Forbidden Transitions Probed by Time-Resolved Electron Paramagnetic Resonance Spectroscopy. `J. Phys. Chem. Lett., 8:1677–1682, 2017 <http://dx.doi.org/10.1021/acs.jpclett.7b00644>`_.


Where to start?
---------------

After installing the toolbox, the best bet is to start MATLAB\ |reg| and fire up Tsim by simply typing ``Tsim`` into the command line and hit "enter". The Tsim CLI should guide you through all the necessary steps.


Installation
------------

The Tsim toolbox for MATLAB\ |reg| comes with a dedicated installer. Therefore, it is *highly recommended* to use this installer to get a properly working installation of the Tsim toolbox.

  * Download the source code (from `GitHub <https://github.com/tillbiskup/matlab-trepr-tsim>`_).
  * Start MATLAB\ |reg|
  * Change to the folder you've downloaded (and unpacked) the source code to
  * Change to the 'internal' subdirectory
  * Call the ``TsimInstall`` function

This will add all necessary (and only the necessary) folders to the MATLAB\ |reg| path and place configuration and templates in their respective folders in your user's home directory.

.. warning::
   If you don't use the installer provided with the Tsim toolbox, but simply add the Tsim directory and all subdirectories to the MATLAB\ |reg| path, you will most certainly run into trouble, as the ``.git`` directory contains all sorts of files that you *don't* want to be added to the MATLAB\ |reg| path.


Prerequisites
-------------

  * MATLAB\ |reg|
  * MATLAB\ |reg| Optimization Toolbox\ |trade|
  * `EasySpin toolbox <https://easyspin.org/>`_
  * `trEPR toolbox <https://github.com/tillbiskup/matlab-trepr>`_


License
-------

The toolbox is distributed under the GNU Lesser General Public License (LGPL) as published by the Free Software Foundation.

This ensures both, free availability in source-code form and compatibility with the (closed-source and commercial) Matlab® environment.


Authors
-------

* Deborah Meyer (2013-15)

  The principal author and main developer of the Tsim toolbox

* Till Biskup (2013-2022)

  Maintainer of the Tsim toolbox.


Related projects
----------------

There is a number of related projects you may be interested in, both for MATLAB\ |reg| as well as Python. Have a look at the section with related Python projects as well that are actively being developed.


MATLAB\ |reg| projects
~~~~~~~~~~~~~~~~~~~~~~

* `trEPR toolbox <https://github.com/tillbiskup/matlab-trepr>`_

    Toolbox for preprocessing, display, analysis, and postprocessing of transient (*i.e.*, time-resolved) electron spin resonance spectroscopy (in short: trEPR) data. Spiritual predecessor of the `trepr package <https://docs.trepr.de/>`_ implemented in Python. Each processing and analysis step gets automatically logged with all parameters to ensure reproducibility. Focusses particularly on automating the pre-processing and representation of data.

* `cwepr toolbox <https://github.com/tillbiskup/matlab-cwepr>`_

    Toolbox for analysing cwEPR data (common Toolbox based). Spiritual predecessor of the `cwepr package <https://docs.cwepr.de/>`_ implemented in Python. Each processing and analysis step gets automatically logged with all parameters to ensure reproducibility. Focusses particularly on automating the pre-processing and representation of data.


Python projects
~~~~~~~~~~~~~~~

* `ASpecD framework <https://docs.aspecd.de/>`_

    A Python framework for the analysis of spectroscopic data focussing on reproducibility and good scientific practice, developed by T. Biskup.

* `trepr package <https://docs.trepr.de/>`_

    Python package for processing and analysing time-resolved electron paramagnetic resonance (trEPR) data, developed by J. Popp, currently developed and maintained by M. Schröder and T. Biskup.

* `cwepr package <https://docs.cwepr.de/>`_

    Python package for processing and analysing continuous-wave electron paramagnetic resonance (cw-EPR) data, originally implemented by P. Kirchner, developed and maintained by M. Schröder and T. Biskup.

* `FitPy framework <https://docs.fitpy.de/>`_

    Python framework for the advanced fitting of models to spectroscopic data focussing on reproducibility, developed by T. Biskup.


.. toctree::
   :maxdepth: 2
   :caption: Contents:
   :hidden:

   audience
   concepts
   usecases

