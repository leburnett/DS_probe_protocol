"""
Functions to generate the combined results pdfs from the generated individual plots for individual stimuli. 
"""
from pathlib import Path
import os
import glob
import warnings
# from PIL import Image, ImageDraw

from dotenv import find_dotenv, load_dotenv

from utils.pdf_maker import PDFMaker
from utils.helper_functions import find_images

# Load variables from .env file
load_dotenv()

def generate_combined_pdf(
    plot_info: dict,
    pdf_specs: dict
):
    """
    Function to generate PDF plot of premade gallery pngs.

    Parameters
    ----------
    plot_info : dict
        stim_type : str
            stimulus type to plot for
        cell_type : str
            cell type for which to generate the pdf of.
        date_str : str
            string of the date for which a pdf should be generated.
        date_to_process : str
            string of the date / exp to process. If multiple experiments 
            were conducted on the same day then the data will be found within
            a subfolder '{date_str}_1' or '{date_str}_2' etc.     
    pdf_specs : dict
        pdf_w : int
            pdf width in mm
        pdf_h : int
            pdf height in mm
        pdf_res : int
            pdf resolution in dpi
        pdf_margin : tuple
            paper margin in mm. [margin_x, margin_y]
    """
    # Access the variables
    results_folder = os.getenv('RESULTS_FOLDER')
    stim_type = plot_info["stim_type"]
    cell_type = plot_info["cell_type"]
    date_str = plot_info["date_str"]
    date_to_process = plot_info["date_to_process"]

    if stim_type == 'gratings1' or stim_type == "gratings2":
        stim_type_path = 'gratings'
    else:
        stim_type_path = stim_type

    if len(date_to_process)>10:
        # paths to find the files
        path_to_pdfs = os.path.join(results_folder, stim_type_path, cell_type, date_str, date_to_process) # had it like this : stim_type[:-1] - for gratings? 
    else:
        path_to_pdfs = os.path.join(results_folder, stim_type_path, cell_type, date_str)

    # output folder to save the PDFs
    output_folder = Path(results_folder) / 'output_pdfs' / cell_type / stim_type
    output_folder.mkdir(parents=True, exist_ok=True)

    # generate the empty page
    doc = PDFMaker(
        width=pdf_specs["pdf_w"],
        height=pdf_specs["pdf_h"],
        resolution=pdf_specs["pdf_res"],
        margin=pdf_specs["pdf_margin"],
    )

    if stim_type in ("bar6", "bar2", "edge"): # update with more stimulus types when I have them
        rows_cols = [3, 4]
        aspect_ratio = 1
    elif stim_type == "gratings1":
        rows_cols = [2, 4]
        aspect_ratio = 1
    elif stim_type == "gratings2":
        aspect_ratio = 0.3
        rows_cols = [1, 8]

    # get the position of each of the individual figs on the page
    coords, _, _ = doc.get_page_layout_rows_cols(
        rows=rows_cols[0], cols=rows_cols[1], aspect_ratio=aspect_ratio, stim_type=stim_type,
    )

    save_name = f"{cell_type}_{date_to_process}_{stim_type}.pdf"

    # Get list of the images in the directory.
    file_type = 'png'

    if stim_type == "gratings1":
        str2find = 'per_speed'
    elif stim_type == "gratings2":
        str2find = 'per_orient'
    else:
        str2find = None

    pdf_files = find_images(path_to_pdfs, file_type, str2find)

    # Sort the list to ensure they're in the correct order.
    pdf_files.sort()

    idx = 0

    for idx, pdf_name in enumerate(pdf_files):
        # add image to pdf
        img_coords = list(coords[idx])
        doc.add_image(pdf_name, img_coords)

    title_position = [0.33, 0.97]
    title_str = f"{cell_type} - {date_to_process} - {stim_type}"
    doc.add_text(
            text=title_str,
            position=[title_position[0], title_position[1]],
            color= [0,0,0,1],
            font_size=pdf_specs["font_size"],
            )
    
    print(f"{stim_type} - {cell_type} - {date_to_process}")
    doc.save(filename=save_name, directory=output_folder)


def check_for_imgs(plot_type: str):
    """
    Check that png images needed for making the combined pdfs exist.

    Parameters
    ----------
    plot_type : str
        type of plot being generated. Only options are 'gallery' or 'group' plots. 
    """
    assert plot_type in ["group","gallery"]\
      , f" 'plot_type' has the unexpected value {plot_type} - only 'group' or 'gallery' are allowed."

    PROJECT_ROOT = Path(find_dotenv()).parent
    plot_dir = PROJECT_ROOT / "results" / "gallery"

    if plot_type == 'group':
        vcn_directory = plot_dir / "vcn_group_plots"
        vpn_directory = plot_dir / "vpn_group_plots"
        dirs_to_check = [vcn_directory, vpn_directory]

        for directory in dirs_to_check:
            image_files = glob.glob(os.path.join(directory, 'Full-Brain*.png'))
            if not image_files:
                warnings.warn(f"No images found in {directory}")

    elif plot_type == 'gallery':
        directory = plot_dir / 'ol_gallery_plots'

        image_files = glob.glob(os.path.join(directory, 'Optic-Lobe*.png'))
        if not image_files:
            warnings.warn(f"No images found in {directory}")