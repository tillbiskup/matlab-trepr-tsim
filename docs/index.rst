.. matlab-tsim documentation master file, created by
   sphinx-quickstart on Sat Sep  5 15:02:22 2020.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

.. include:: <isonum.txt>

Tsim documentation
==================

Welcome! This is the documentation of the Tsim toolbox for MATLAB\ |reg|. 


.. note::
   If using this program leads to a publication, please mention it in the methods section and cite the following reference:

   | Deborah L. Meyer, Florian Lombeck, Sven Huettner, Michael Sommer, Till Biskup
   | Direct S\ :sub:`0`\ →T Excitation of a Conjugated Polymer Repeat Unit: Unusual Spin-Forbidden Transitions Probed by Time-Resolved Electron Paramagnetic Resonance Spectroscopy
   | `J. Phys. Chem. Lett., 8:1677–1682, 2017 <http://dx.doi.org/10.1021/acs.jpclett.7b00644>`_.


Features
--------

  * Comfortable command-line interface (CLI) for fit and simulation
  * Modular design
  * Reproducibility: all routines operate on datasets
  * Support for different input file formats
  * Integrated help
  * Automatically generated reports: well-formatted presentation of results
  * Complete simulation and fit history


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
  * `EasySpin toolbox <https://easyspin.org/>`_
  * `trEPR toolbox <https://github.com/tillbiskup/matlab-trepr>`_


License
-------

The toolbox is distributed under the GNU Lesser General Public License (LGPL) as published by the Free Software Foundation.

This ensures both, free availability in source-code form and compatibility with the (closed-source and commercial) Matlab® environment.


.. toctree::
   :maxdepth: 2
   :caption: Contents:

   audience
   concepts
   usecases



Indices and tables
------------------

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
