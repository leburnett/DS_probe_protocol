import os
import glob

def find_images(directory, file_type, str2find=None):
    """ Use glob to find all files in the directory. 

    Inputs
    ______
    directory : Path
        Directory to search. 

    file_type : str
        Type of image to find within the directory. E.g. 'pdf' or 'png'

    Returns
    _______
    files : list
        List of images within the directory.
    """
    files = glob.glob(os.path.join(directory, f"*.{file_type}"))

    if str2find is not None:
        files = [item for item in files if str2find in item]

    return files