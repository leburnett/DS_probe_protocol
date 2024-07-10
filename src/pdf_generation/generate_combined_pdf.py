"""
Functions to generate the combined pdfs from optic lobe group or gallery png files. 
"""
from pathlib import Path
import os
import glob
import warnings 

from dotenv import find_dotenv
from PIL import Image, ImageDraw

from utils.pdf_maker import PDFMaker

def generate_combined_pdf(
    pdf_specs: dict,
    page_idx: int,
    instances: list,
    nudge_dict : dict,
    rows_cols: tuple = None,
    offset: int = 45,
):
    """
    Function to generate PDF plot of premade gallery pngs.

    Parameters
    ----------
    pdf_specs : dict
        pdf_w : int
            pdf width in mm
        pdf_h : int
            pdf height in mm
        pdf_res : int
            pdf resolution in dpi
        pdf_margin : tuple
            paper margin in mm. [margin_x, margin_y]
    page_idx : int
        page number
    instances : list
        list of neuron type instances used to generate combined pdf
    main_groups : str
        main group the neurons plotted belong to.
    nudge_dict : dict
        dict with int values of how much to move the text in the y direction for the gallery
        images of the keys (neuron types). Positive values in the dict move the text up.
    rows_cols : tuple, default=None
        tuple of the number of rows and columns to use in the pdf i.e. [4, 6] - 4 rows, 6 columns
        If None, then rows_cols is set as [len(instances), 1].
    offset : int, default=45
        value to move all images by for centring. positive values shift all images to the right.
    """
    # paths to find and save the files
    PROJECT_ROOT = Path(find_dotenv()).parent
    output_path = PROJECT_ROOT / "results" / "fig_summary"
    json_path = PROJECT_ROOT / "results" / "gallery-descriptions"
    crop_path = PROJECT_ROOT / "cache" / "gallery" / "crop"
    crop_path.mkdir(parents=True, exist_ok=True)

    # generate the empty page
    doc = PDFMaker(
        width=pdf_specs["pdf_w"],
        height=pdf_specs["pdf_h"],
        resolution=pdf_specs["pdf_res"],
        margin=pdf_specs["pdf_margin"],
    )

    if rows_cols is None:
        rows_cols = [len(instances), 1]

    # get the position of each of the individual figs on the page
    coords, img_width, img_height = doc.get_page_layout_rows_cols(
        rows=rows_cols[0], cols=rows_cols[1], aspect_ratio=1
    )
    # save_name = f"Gallery_{main_group}_{rows_cols[0]}R_{rows_cols[1]}C_{pdf_specs['pdf_w']}mm_{pdf_specs['pdf_h']}mm_{pdf_specs['pdf_res']}dpi_{str(page_idx).zfill(2)}.pdf"
    save_name = f"Gallery_Group-{page_idx:02d}.pdf"
    idx = 0

    for idx, instance in enumerate(instances):
        # get text and position
        config = PlotConfig(config_filename=json_path / f"Optic-Lobe_Gallery_{instance}.json")
        x_top, y_top = coords[idx][0] + offset, coords[idx][1]

        png_path = PROJECT_ROOT / "results" / "gallery" / config.directory / f"{config.basename}.png"
        png_crop_path = crop_path/ f"{config.basename}_crop.png"

        # if cropped image doesn't exist then make it
        if not os.path.exists(png_crop_path):
            img_raw = Image.open(png_path)
            img_crop = img_raw.crop((350, 200, 2350, 2500))
            # add white rect with gradient to edge
            rect_w = int(img_crop.size[0] / 10)
            rect_h = img_crop.size[1]
            rectangle_size = (rect_w, rect_h)
            pos_rect_x = img_crop.size[0] - rect_w
            pos_rect_y = 0
            rectangle_position = (pos_rect_x, pos_rect_y)
            overlay = Image.new("RGBA", img_crop.size, (0, 0, 0, 0))
            draw = ImageDraw.Draw(overlay)
            for i in range(256):
                color = (255, 255, 255, i)
                new_rectangle_size = (
                    int(rectangle_size[0] * (1 - i / 255)),
                    rectangle_size[1],
                )
                new_rectangle_position = (
                    rectangle_position[0]
                    + int((rectangle_size[0] - new_rectangle_size[0])),
                    rectangle_position[1],
                )
                draw.rectangle(
                    [
                        new_rectangle_position,
                        (
                            new_rectangle_position[0] + new_rectangle_size[0],
                            new_rectangle_position[1] + new_rectangle_size[1],
                        ),
                    ],
                    fill=color,
                )
            result = Image.alpha_composite(img_crop.convert("RGBA"), overlay)
            result.save(png_crop_path)

        # add image to pdf
        img_coords = list(coords[idx])
        img_coords[0] += offset
        img_coords[2] += offset
        doc.add_image(png_crop_path, img_coords)

        text_dict = config.text_dict

        if f"{instance}" in nudge_dict.keys():
            nudge_str = f"{instance}"
            nudge_val = nudge_dict[nudge_str]
        else:
            nudge_val = 0

        # add text
        for key, t in text_dict.items():
            align = t["align"]
            plot_pos_x, plot_pos_y = t["pos"]
            paper_pos_x = (plot_pos_x * img_width) + x_top
            paper_pos_y = (((1 - plot_pos_y) * img_height) + y_top) - nudge_val

            doc.add_text(
                text=t["text"],
                position=[paper_pos_x, paper_pos_y],
                color=t["color"],
                align=align,
                font_size=pdf_specs["font_size"],
            )

    doc.save(filename=save_name, directory=output_path)


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