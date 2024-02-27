# Install the required gem
# sudo gem install pi_piper

require 'pi_piper'

# Motor controller configuration
DIR_PIN = 17  # Direction pin
PWM_PIN = 18  # PWM pin

# Motor configuration
MAX_PWM = 100  # Maximum PWM duty cycle

# Initialize GPIO
PiPiper::Spi.begin
PiPiper::Spi.set_mode(0, 0b00)
PiPiper::Spi.set_speed(0, 1000000)

# Function to move the motor
def move_motor(direction, speed)
  PiPiper::Spi.write([0x80 | direction, speed])
end

# Function to stop the motor
def stop_motor
  move_motor(0, 0)
end

# Specify the I2C address of the PCA9685 on the PWM/Servo HAT
i2c_address = 0x40

# Initialize the PCA9685
pwm = Adafruit::Pca9685.new(i2c_address)

# Set the PWM frequency (Hz)
pwm.frequency = 1000

# Define the PWM channel (replace this with the actual channel you are using)
pwm_channel = 0

# Function to control the motor using PCA9685
def control_motor_pca9685(pwm, pwm_channel, speed)
  # Set PWM duty cycle (0 to 4095) for speed
  pwm[pwm_channel] = speed.abs
end

# Example usage
begin
  # Run the motor forward
  move_motor(1, MAX_PWM)

  # Run the motor using PCA9685
  control_motor_pca9685(pwm, pwm_channel, 1000)  # Adjust speed as needed

  sleep(5)  # Run for 5 seconds (adjust as needed)

  # Run the motor backward
  move_motor(0, MAX_PWM)

  # Run the motor using PCA9685
  control_motor_pca9685(pwm, pwm_channel, -1000)  # Adjust speed as needed

  sleep(5)  # Run for 5 seconds (adjust as needed)

  # Stop the motor
  stop_motor
end

ensure
  # Cleanup
  PiPiper::Spi.end
end
