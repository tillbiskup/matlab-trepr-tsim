.. include:: <isonum.txt>

Target audience
===============

Who is the target audience of the Tsim toolbox for MATLAB\ |reg|? Is it interesting for me?

Tsim is developed for EPR spectroscopists working with time-resolved EPR spectroscopy and particularly recording data for light-induced spin-polarised triplet states. Such states are commonly encountered upon illuminating conjugated molecules with UV/Vis/NIR light.

For simulations as well as for basic fitting, the `EasySpin toolbox <https://easyspin.org/>`_ is well equipped, and Tsim relies on this toolbox and its phantastic capabilities for simulating the solid-state spectra of spin-polarised triplet states.

However, one crucial step in simulating spin-polarised triplet states is the populations that cannot easily be fitted using EasySpin's builtin capabilities. Furthermore, though quite advanced as well, the fitting algorithms provided by EasySpin's esfit tool are not necessarily as robust as those provided by the MATLAB\ |reg| Optimization Toolbox\ |trade|.

Thus, a separate toolbox has been developed dealing with these particular demands. At the same time, Tsim tightly integrates with the `trEPR toolbox <https://github.com/tillbiskup/matlab-trepr>`_, using its dataset structure for internally representing the recorded data together with the crucial parameters.

The user is guided through the entire process via a command-line interface (CLI) providing detailed advice of the different steps. Thus, even people with next to no prior knowledge of EPR spectroscopy or spectral simulations and fitting can get started very quickly and obtain usable results in a very reasonable time frame. (From own experience, an afternoon with a bachelor student can be enough to get them started.)

Furthermore, Tsim provides advanced reporting capabilities, creating reports from a fully adjustable LaTeX template. This results in well-formatted reports for each fit, representing the crucial parameters always in a uniform manner, thus facilitating comparison of different fits tremendously.

Taken together, Tsim allows for "high-throughput" simulating and fitting of trEPR data of light-induced spin-polarised triplet states, allowing the scientist to focus on the actual interpretation of the data obtained, no longer having to bother with the details of how to get the routines for fitting to run this time.
