# Configuration file for the Sphinx documentation builder.
#
# This file only contains a selection of the most common options. For a full
# list see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Path setup --------------------------------------------------------------

# If extensions (or modules to document with autodoc) are in another directory,
# add these directories to sys.path here. If the directory is relative to the
# documentation root, use os.path.abspath to make it absolute, like shown here.
#
import os
import sys
sys.path.insert(0, os.path.abspath('.'))


# -- Project information -----------------------------------------------------

with open(os.path.join(os.path.dirname(__file__), '..', 'Contents.m')) as \
        version_file:
    contents = version_file.readlines()
    release_ = contents[1].split(' ')[2].strip()

project = 'matlab-tsim'
copyright = '2013-2015, Deborah L. Meyer, 2013-2022 Till Biskup'
author = 'Deborah L. Meyer, Till Biskup'

# The full version, including alpha/beta/rc tags
release = release_
version = release


# -- General configuration ---------------------------------------------------

# Add any Sphinx extension module names here, as strings. They can be
# extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
# ones.
extensions = [
    'sphinx.ext.autodoc',
    'sphinx.ext.napoleon',
    'sphinxcontrib.matlab',
    'sphinx.ext.todo',
    'sphinx.ext.intersphinx',
    'sphinx.ext.viewcode',
    #'sphinxcontrib.bibtex',
]

# Add any paths that contain templates here, relative to this directory.
templates_path = ['_templates']

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
# This pattern also affects html_static_path and html_extra_path.
exclude_patterns = ['_build', 'Thumbs.db', '.DS_Store']


# -- Options for HTML output -------------------------------------------------

# The theme to use for HTML and HTML Help pages.  See the documentation for
# a list of builtin themes.
#
# html_theme = 'alabaster'
html_theme = 'sphinx_rtd_theme'

# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
#html_static_path = ['_static']

# The name of an image file (relative to this directory) to place at the top
# of the sidebar.
html_logo = './trepr-tsim-logo.png'

# The name of an image file (relative to this directory) to use as a favicon
# of the docs.  This file should be a Windows icon file (.ico) being 16x16 or
# 32x32 pixels large.
html_favicon = 'favicon.ico'
