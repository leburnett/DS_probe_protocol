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

def find_coords(w, h, rows, cols):
    """
    Find the coordinates to fit 6 images onto a page of width (w) and height (h). 
    Make it 
    """
    conversion = 72 / 25.4
    w = w * conversion
    h = h * conversion
    cell_w = w / cols
    cell_h = h / rows
    
    # Determine the size of the square images
    image_size = min(cell_w, cell_h)

    # Coordinates for each image (x0, y0, x1, y1)
    coords = [
        [0, 2 * image_size, image_size, 3 * image_size],      # Third image
        [image_size, 2 * image_size, 2 * image_size, 3 * image_size],  # Fourth image
        [2 * image_size, 2 * image_size, 3 * image_size, 3 * image_size],  # Fifth image
        [3 * image_size, 2 * image_size, 4 * image_size, 3 * image_size],   # Sixth image
        [0, 0, 2 * image_size, 2 * image_size],               # First image
        [2 * image_size, 0, 4 * image_size, 2 * image_size],  # Second image
    ]

    # cell_w = (w / cols)/2
    # cell_h = cell_w

    # coords = [
    #     [0, 2 * cell_h, cell_w, cell_h],           # Third image
    #     [cell_w, 2 * cell_h, cell_w, cell_h],      # Fourth image
    #     [2 * cell_w, 2 * cell_h, cell_w, cell_h],  # Fifth image
    #     [3 * cell_w, 2 * cell_h, cell_w, cell_h],   # Sixth image
    #     [0, 0, 2 * cell_w, 2 * cell_h],            # First image
    #     [2 * cell_w, 0, 2 * cell_w, 2 * cell_h],   # Second image
    #     ]
    
    return coords
