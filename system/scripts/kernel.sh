# This is a script to update Linux Kernel
# This will also update system and corresponding packages

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 
    exit 1
fi

# Update package lists
apt update

# Upgrade the system
apt upgrade -y

# Install new kernel (example for Ubuntu)
apt install linux-generic linux-headers-generic -y

# Optional: Clean up old kernels (keep the latest two)
apt autoremove --purge -y

# Ask user if they want to reboot
read -p "Do you want to reboot the system now? (y/n): " reboot_answer
if [[ "$reboot_answer" =~ ^[Yy]$ ]]; then
    reboot
else
    echo "Kernel update completed. Remember to reboot your system later for changes to take effect."
fi

