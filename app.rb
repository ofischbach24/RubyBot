require 'evdev'
require 'pi_piper'

# Define GPIO pins
pwm_pin = PiPiper::Pin.new(pin: 18, direction: :out)  # Replace with your actual PWM pin number
dir_pin = PiPiper::Pin.new(pin: 17, direction: :out)  # Replace with your actual DIR pin number

# Deadzone threshold
deadzone_threshold = 10

# Function to control the motor
def control_motor(pwm_pin, dir_pin, speed)
  dir_pin.write(speed >= 0 ? 0 : 1)  # Set direction (0 for forward, 1 for backward)
  pwm_pin.pwm_write(speed.abs)       # Set PWM duty cycle (0 to 255) for speed
end

# Function to stop the motor
def stop_motor(pwm_pin)
  pwm_pin.off
end

# Find the most recently modified event device in /dev/input/
default_event_device = Dir["/dev/input/event*"].grep(/event\d+/).max_by { |e| File.mtime(e) }

# Get the event device path from command-line arguments or use the default
event_device_path = ARGV[0] || default_event_device
event_device = Evdev::Device.new(event_device_path)

puts "Listening for controller events on #{event_device_path}..."

# Main loop to read controller events
loop do
  begin
    event = event_device.read_one
    next unless event

    case event.type
    when :EV_ABS
      case event.code
      when :ABS_X
        x_axis_value = event.value
        speed = 0

        # Apply deadzone
        if x_axis_value.abs > deadzone_threshold
          speed = x_axis_value / 128 - 128  # Map the X-axis value to motor speed (-128 to 127)
        end

        control_motor(pwm_pin, dir_pin, speed)
      end
    when :EV_KEY
      case event.code
      when :BTN_START
        # Stop the motor when the Start button is pressed
        stop_motor(pwm_pin)
      end
    end
  rescue StandardError => e
    puts "Error reading event: #{e.message}"
  end
end
