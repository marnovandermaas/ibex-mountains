export F4PGA_INSTALL_DIR=~/tools/f4pga
export FPGA_FAM=xc7
export F4PGA_PACKAGES='install-xc7 xc7a50t_test xc7a100t_test xc7a200t_test xc7z010_test'
bash conda_installer.sh -u -b -p $F4PGA_INSTALL_DIR/$FPGA_FAM/conda
source "$F4PGA_INSTALL_DIR/$FPGA_FAM/conda/etc/profile.d/conda.sh"
conda env create -f $FPGA_FAM/environment.yml
#~/repos/f4pga/scripts/prepare_environment.sh
conda activate $FPGA_FAM
