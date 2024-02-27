# Assuming you are using the WiringPi library for Ruby
require 'wiringpi'

# Define GPIO pins
pwm_pin = 18  # Replace with your actual PWM pin number
dir_pin = 17  # Replace with your actual DIR pin number

# Set up WiringPi
gpio = WiringPi::GPIO.new

# Initialize PWM on the specified pin
gpio.mode(pwm_pin, PWM_OUTPUT)

# Function to control the motor
def control_motor(speed)
  speed = [speed.abs, 255].min  # Limit speed to a maximum of 255
  gpio.pwmWrite(pwm_pin, speed)  # Set PWM duty cycle (0 to 255) for speed

  if speed > 0
    gpio.digitalWrite(dir_pin, HIGH)  # Set direction (HIGH for forward)
  else
    gpio.digitalWrite(dir_pin, LOW)   # Set direction (LOW for backward)
  end
end

# Function to stop the motor
def stop_motor
  gpio.pwmWrite(pwm_pin, 0)  # Set duty cycle to 0 to stop the motor
end

# Run the motor forward for a brief period
forward_speed = 100  # Adjust speed as needed (0 to 255)

puts "Running the motor forward..."

control_motor(forward_speed)

# Run for 5 seconds (adjust as needed)
sleep(5)

# Run the motor backward for a brief period
backward_speed = -100  # Adjust speed as needed (-255 to 0)

puts "Running the motor backward..."

control_motor(backward_speed)

# Run for 5 seconds (adjust as needed)
sleep(5)

puts "Stopping the motor..."

stop_motor
