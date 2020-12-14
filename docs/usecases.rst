.. include:: <isonum.txt>

Use cases
=========

This section provides a few ideas of how basic operation of the Tsim toolbox for MATLAB\ |reg| may look like.


Basic operation
---------------

As Tsim comes with a command-line interface (CLI), it should be fairly simple and straightforward to use.

To begin simulating or fitting TREPR spectra of triplet states, start MATLAB\ |reg| (if not already done), and at the MATLAB\ |reg| command prompt, highlighted with ``>>`` below, simply type the following:


.. code-block::

	>> Tsim


This will greet you first with a welcome message, similar to the following:


.. code-block:: text

	*****************************************************************
 
	Welcome to Tsim - a CLI for conveniently simulating and fitting
	                  spin-polarised EPR spectra of triplet states.
 
	*****************************************************************
	*                                                               *
	* It is mandatory to cite the following reference if any result *
	* from this program will be part of a thesis or publication:    *
	*                                                               *
	*  D. L. Meyer, F. Lombeck, S. Huettner, M. Sommer, T. Biskup   *
	*  J. Phys. Chem. Lett. 2017, 8, 1677-1682                      *
	*                                                               *
	*****************************************************************
 
	Furthermore, please acknowledge the author(s) of the simulation
	routines (and cite appropriately if necessary). This information 
	will be displayed depending on the simulation routine chosen.
 
	Thank you for your kind cooperation. Enjoy using Tsim.
 
	*****************************************************************
 
	Do you wish to load an existing (experimental) dataset
	 [y] Yes
	 [n] No
	 [q] Quit
	Your choice (default: [n]): 


Here, you see already the general type of dialogues you will encounter throughout Tsim. In this particular case, you will most probably type "y" and hit return again. This will now ask you for a filename to load (that needs to be in trEPR Toolbox format).


.. tip::
	The default answers for each dialogue are always given in square brackets. Therefore, you can quite conveniently hit "return" multiple times if the defaults are set accordingly.
	

Once you have made your way through all settings and have selected the fitting branch, Tsim will start with fitting simulations to your experimental data provided in the first step.

When finished, it will automatically save the results, but ask you as well for a filename to save them to. Additionally, by default, it will create a report of the results for you in LaTeX format that can easily be compiled to a PDF file.

