import os
import glob

def find_pdfs(directory):
    """ Use glob to find all pdf files in the directory. 

    Inputs
    ______
    directory : Path
        Directory to search. 

    Returns
    _______
    pdf_files : list
        List of PDFs within the directory.
    """
    pdf_files = glob.glob(os.path.join(directory, "*.pdf"))
    return pdf_files

