# Install the required gem
# sudo gem install adafruit-pca9685

require 'adafruit/pca9685'

# Specify the I2C address of the PCA9685 on the PWM/Servo HAT
i2c_address = 0x40

# Initialize the PCA9685
pwm = Adafruit::Pca9685.new(i2c_address)

# Set the PWM frequency (Hz)
pwm.frequency = 1000

# Define the PWM and DIR channels (replace these with the actual channels you are using)
pwm_channel = 0
dir_channel = 1

# Function to control the motor
def control_motor(pwm, pwm_channel, dir_channel, speed)
  # Set direction (1 for forward, 0 for backward)
  pwm[pwm_channel] = speed > 0 ? 1 : 0

  # Set PWM duty cycle (0 to 4095) for speed
  pwm[dio_channel] = speed.abs
end

# Function to stop the motor
def stop_motor(pwm, pwm_channel, dir_channel)
  # Set both direction and PWM to stop the motor
  pwm[pwm_channel] = 0
  pwm[dir_channel] = 0
end

# Example usage
begin
  # Run the motor forward
  control_motor(pwm, pwm_channel, dir_channel, 1000)  # Adjust speed as needed

  sleep(5)  # Run for 5 seconds (adjust as needed)

  # Run the motor backward
  control_motor(pwm, pwm_channel, dir_channel, -1000)  # Adjust speed as needed

  sleep(5)  # Run for 5 seconds (adjust as needed)

  # Stop the motor
  stop_motor(pwm, pwm_channel, dir_channel)
end
