#!/usr/bin/python3
import subprocess
import argparse
import os
import sys

'''
    This utility only supports one external monitor
    Use standard utilities from Xorg
'''


def get_connected_monitors():
    command = 'xrandr --query | grep " connected" | cut -d" " -f1'
    connectedMonitorsList = subprocess.getoutput(command).split('\n')

    return connectedMonitorsList


def set_monitors(direction, list_of_monitors, background_image):
    active_internal_cmd = f'xrandr --output {list_of_monitors[0]} --primary --mode 1920x1080'
    # print(active_internal_cmd)
    active_external_cmd = f'xrandr --output {list_of_monitors[1]} --{direction}-of {list_of_monitors[0]} --mode 1920x1080'
    feh_cmd = f'feh --bg-scale {background_image}'
    subprocess.run(active_internal_cmd, shell=True)
    subprocess.run(active_external_cmd, shell=True)
    subprocess.run(feh_cmd, shell=True)


def init_set_monitors(args):
    list_of_monitors = get_connected_monitors()
    if len((list_of_monitors)) > 1:
        print("External Monitor Detected")
        print(f'External Monitor Name: {list_of_monitors[1]}')

        if args.left:
            set_monitors('left', list_of_monitors, args.background_image)
        if args.right:
            set_monitors('right', list_of_monitors, args.background_image)
    else:
        print("Only Internal Monitor Deteched")
        print("Exiting Now...")
        sys.exit(0)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--left", '-l', help="set monitor in left", action="store_true")
    parser.add_argument(
        "--right", '-r', help="set monitor in right", action="store_true")
    parser.add_argument(
        '--external', '-e', help='Only external activated', action='store_true'
    )
    parser.add_argument(
        '--internal', '-i', help='only ldaptop display activated', action='store_true'
    )
    parser.add_argument(
        '--background_image', '-bgi', help='abs path for wallpaper', required=True
    )

    args = parser.parse_args()

    if args.background_image:
        init_set_monitors(args)


if __name__ == "__main__":
    main()
