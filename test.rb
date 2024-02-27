# Install the required gems
# sudo gem install rpi_gpio i2c

require 'rpi_gpio'
require 'i2c'

# Motor controller configuration
DIR_PIN = 7   # Direction pin
PWM_PIN = 1  # PWM pin (using physical pin number for :board)

# I/O Expander configuration
I2C_ADDRESS = 0x18  # Replace with the I2C address of your I/O expander

# Initialize GPIO with :board numbering
RPi::GPIO.set_numbering :board
RPi::GPIO.setup DIR_PIN, as: :output
RPi::GPIO.setup PWM_PIN, as: :output

# Initialize PWM for the PWM_PIN
pwm = RPi::GPIO::PWM.new(PWM_PIN, 1000)  # 1000 Hz PWM frequency

# Initialize I2C
i2c = I2C.create("/dev/i2c-1")  # Adjust the I2C bus number as needed

# Function to move the motor using GPIO and I2C
def move_motor(direction, pwm, i2c, pin_on_expander)
  # Set motor direction using GPIO
  RPi::GPIO.set_low DIR_PIN if direction == :forward
  RPi::GPIO.set_high DIR_PIN if direction == :backward

  # Start PWM with a duty cycle of 50% using GPIO
  pwm.start(50)

  # Set the state of a pin on the I/O expander
  i2c.write(I2C_ADDRESS, 0x01, (1 << pin_on_expander) | (1 << pin_on_expander))  # Replace register and bit mask based on your I/O expander
end

# Function to stop the motor using GPIO and I2C
def stop_motor(pwm, i2c, pin_on_expander)
  # Stop motor using GPIO
  pwm.stop
  RPi::GPIO.set_low DIR_PIN  # Ensure the direction pin is low

  # Set the state of a pin on the I/O expander
  i2c.write(I2C_ADDRESS, 0x01, (0 << pin_on_expander) | (1 << pin_on_expander))  # Replace register and bit mask based on your I/O expander
end

begin
  # Move motor forward using GPIO and I2C
  move_motor(:forward, pwm, i2c, 0)  # Replace 0 with the actual pin on the I/O expander

  puts "Direction: Forward"
  sleep(2)

  # Move motor backward using GPIO and I2C
  move_motor(:backward, pwm, i2c, 1)  # Replace 1 with the actual pin on the I/O expander

  puts "Direction: Backward"
  sleep(2)

  # Stop motor using GPIO and I2C
  stop_motor(pwm, i2c, 0)  # Replace 0 with the actual pin on the I/O expander

  puts "Direction: Stopped"

ensure
  # Cleanup GPIO and I2C
  RPi::GPIO.reset
  i2c.close
end
