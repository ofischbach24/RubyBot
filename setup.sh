#!/bin/bash

# Install required Ruby gems
gem install evdev pi_piper i2c

# Make the main Ruby script executable
chmod +x app.rb

# Create the controller monitoring shell script
echo -e "#!/bin/bash\n\nwhile true; do\n  controller_event=\$(ls /dev/input/ | grep \"event.*\" | grep -o \"event[0-9]*\" | head -n 1)\n\n  if [ -n \"\$controller_event\" ]; then\n    echo \"PS4 controller detected on /dev/input/\$controller_event\"\n    ./app.rb \"/dev/input/\$controller_event\"\n    sleep 1  # Adjust sleep time as needed to avoid rapid re-checking\n  else\n    sleep 1\n  fi\ndone" > controller_monitor.sh

# Make the controller monitoring script executable
chmod +x controller_monitor.sh

echo "Setup completed successfully!"
