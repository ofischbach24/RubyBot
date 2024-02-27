require 'pi_piper'
require 'i2c'

# Specify the I2C address of your GPIO extender
i2c_address = 0x20

# Initialize I2C communication
i2c = I2C.create('/dev/i2c-1')

# Define GPIO pins
pwm_pin = PiPiper::Pin.new(pin: 18, direction: :out)  # Replace with your actual PWM pin number
dir_pin = PiPiper::Pin.new(pin: 17, direction: :out)  # Replace with your actual DIR pin number

# Function to control the motor
def control_motor(pwm_pin, dir_pin, speed)
  dir_pin.write(speed >= 0 ? 0 : 1)  # Set direction (0 for forward, 1 for backward)
  pwm_pin.pwm(speed.abs)       # Set PWM duty cycle (0 to 255) for speed
end

# Function to stop the motor
def stop_motor(pwm_pin)
  pwm_pin.off
end

# Run the motor forward for a brief period
forward_speed = 100  # Adjust speed as needed (0 to 255)

puts "Running the motor forward..."

control_motor(pwm_pin, dir_pin, forward_speed)

# Run for 5 seconds (adjust as needed)
sleep(5)

# Run the motor backward for a brief period
backward_speed = -100  # Adjust speed as needed (-255 to 0)

puts "Running the motor backward..."

control_motor(pwm_pin, dir_pin, backward_speed)

# Run for 5 seconds (adjust as needed)
sleep(5)

puts "Stopping the motor..."

stop_motor(pwm_pin)
