import subprocess
import sys

'''
    This script is developed for intel brightness
    ownership of actual_brightness is change to current USER 
'''

max_brightness_location = '/sys/class/backlight/intel_backlight/max_brightness'
current_brightness_location = '/sys/class/backlight/intel_backlight/actual_brightness'

def read_files(filepath):
    with open(filepath, 'r') as file:
        value = int(file.readline().replace('\n', ''))
    
    return value


def read_max_brightness():
    
    return read_files(max_brightness_location)


def read_current_brightness():
    
    return read_files(current_brightness_location)


def modify_current_brightness(current_brightness):
    with open(current_brightness_location, 'w') as cb:
        cb.write(current_brightness)


def main():

    max_brightness = read_max_brightness()
    current_brightness = read_current_brightness()

    if max_brightness > current_brightness:
        current_brightness += current_brightness+1000
        if current_brightness > max_brightness:
            current_brightness = max_brightness
        
        modify_current_brightness(current_brightness)
    


if __name__ == '__main__':
    main()
