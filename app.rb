require 'evdev'
require 'pi_piper'

# Define GPIO pins
pwm_pin = PiPiper::Pin.new(pin: 18, direction: :out)  # Replace with your actual PWM pin number
dir_pin = PiPiper::Pin.new(pin: 17, direction: :out)  # Replace with your actual DIR pin number

# Function to control the motor
def control_motor(pwm_pin, dir_pin, speed)
  dir_pin.write(speed >= 0 ? 0 : 1)  # Set direction (0 for forward, 1 for backward)
  pwm_pin.pwm_write(speed.abs)       # Set PWM duty cycle (0 to 255) for speed
end

# Function to stop the motor
def stop_motor(pwm_pin)
  pwm_pin.off
end

# Initialize pins
pwm_pin.off
dir_pin.off

# Find the event device for the gamepad
event_device = Evdev::Device.new("/dev/input/eventX")  # Replace with the actual event device path

puts "Listening for gamepad events..."

# Main loop to read gamepad events
loop do
  event = event_device.read_one
  next unless event

  case event.type
  when :EV_ABS
    case event.code
    when :ABS_X
      speed = event.value / 128 - 128  # Map the X-axis value to motor speed (-128 to 127)
      control_motor(pwm_pin, dir_pin, speed)
    end
  when :EV_KEY
    case event.code
    when :BTN_START
      # Stop the motor when the Start button is pressed
      stop_motor(pwm_pin)
    end
  end
end
