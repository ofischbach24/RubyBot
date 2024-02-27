# Install the required gem
# sudo gem install rpi_gpio

require 'rpi_gpio'

# Motor controller configuration
DIR_PIN = 7   # Direction pin
PWM_PIN = 12  # PWM pin (using physical pin number for :board)

# Initialize GPIO with :board numbering
RPi::GPIO.set_numbering :board
RPi::GPIO.setup DIR_PIN, as: :output
RPi::GPIO.setup PWM_PIN, as: :output

# Initialize PWM for the PWM_PIN
pwm = RPi::GPIO::PWM.new(PWM_PIN, 1000)  # 1000 Hz PWM frequency

# Function to move the motor
def move_motor(direction, pwm)
  # Set motor direction
  RPi::GPIO.set_low DIR_PIN if direction == :forward
  RPi::GPIO.set_high DIR_PIN if direction == :backward

  # Start PWM with a duty cycle of 50% (adjust as needed)
  pwm.start(50)
end

# Function to stop the motor
def stop_motor(pwm)
  pwm.stop
  RPi::GPIO.set_low DIR_PIN  # Ensure the direction pin is low
end

begin
  # Move motor forward
  move_motor(:forward, pwm)
  puts "Direction: Forward"
  sleep(2)

  # Move motor backward
  move_motor(:backward, pwm)
  puts "Direction: Backward"
  sleep(2)

  # Stop motor
  stop_motor(pwm)
  puts "Direction: Stopped"

ensure
  # Cleanup GPIO
  RPi::GPIO.reset
end
