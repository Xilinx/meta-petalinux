###############################################################################
#
# Copyright (c) 2019, Xilinx
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
#
# * Neither the name of the copyright holder nor the names of its
#   contributors may be used to endorse or promote products derived from
#   this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# Author: Izhar Shaikh <izhar.ameer.shaikh@xilinx.com>
#
###############################################################################

from ipywidgets import widgets, Layout, Button, Box
from IPython.display import display
from subprocess import check_output
from pmutil import write_to_sysfs

buttons = []
output_widget = None
cpu_monitor = None
button_tags = []
button_args = {}

cpufreq_img_1 = open('pmutil/data/cpu-icon-freq-1.png', 'rb').read()
cpufreq_img_2 = open('pmutil/data/cpu-icon-freq-2.png', 'rb').read()
cpufreq_img_3 = open('pmutil/data/cpu-icon-freq-3.png', 'rb').read()
cpufreq_img_4 = open('pmutil/data/cpu-icon-freq-4.png', 'rb').read()
cpufreq_img_def = open('pmutil/data/cpu-icon-freq-def.png', 'rb').read()


def _setup_output_widget():
    return widgets.Output()


def _setup_cpu_monitor_widgets():
    monitor = widgets.VBox(
        [widgets.Image(
             value=cpufreq_img_def, format='png', width='35%', height='35%'),
         widgets.Output()])
    monitor.layout.align_items = 'center'
    monitor.layout.align_content = 'center'
    monitor.layout.justify_content = 'center'
    return monitor


def _setup_buttons_container(buttons_list):
    '''
        Returns an instance of "Box" which contains all "Button" widgets
    '''
    box_layout = Layout(display='flex',
                        flex_flow='row',
                        align_items='center',
                        justify_content='center',
                        border='solid',
                        width='100%')
    return Box(children=buttons_list,
               layout=box_layout)


def _mk_cpufreq_path(sysfs_attr):
    return '/sys/devices/system/cpu/cpufreq/policy0/{0}'.format(sysfs_attr)


def _write_to_sysfs(filepath, value):
    with output_widget:
        if write_to_sysfs(filepath, value) < 0:
            print("Error while writing to {0}".format(filepath))
        else:
            print('Written {0} -> {1}'.format(value, filepath))


def _handle_cpu_cntl(scal_freq):
    '''
        Handles setting up "scaling_setspeed" for CPUs
    '''
    _write_to_sysfs(_mk_cpufreq_path('scaling_setspeed'), scal_freq)

    # read and print part of dmesg
    with output_widget:
        cmd = 'cat {0}'.format(_mk_cpufreq_path('scaling_setspeed'))
        print("Readback: {0}".format(cmd))
        d_mesg = check_output(cmd, shell=True)
        for line in d_mesg.splitlines():
            print("Readback: {0}".format(line.decode()))

    # print freq to widget in cpu_monitor
    with cpu_monitor.children[1]:
        print(
            "CPUs Running at: {0}".format(
                '\x1b[1m' +
                str(int(scal_freq)/1000) +
                ' MHz' +
                '\x1b[0m'))


def _handle_cpu_imgs(cpu_img):
    cpu_monitor.children[0].value = cpu_img


def _on_button_press(btn_clicked):
    '''
        Handler for each button's click event
    '''
    output_widget.clear_output(wait=True)
    cpu_monitor.children[1].clear_output(wait=True)
    with output_widget:
        print('Button \'[{0}]\' clicked'.format(btn_clicked.description))

    # disable just pressed button
    btn_clicked.disabled = True

    # enable other buttons
    for b in buttons:
        if b.description != btn_clicked.description:
            b.disabled = False

    # handle given cpu action
    _handle_cpu_cntl(button_args[btn_clicked.description][0])
    _handle_cpu_imgs(button_args[btn_clicked.description][1])


def _setup_buttons():
    '''
        Returns a list of "Button" instances
    '''
    btn_list = [Button(value=False,
                       disabled=False,
                       description=word,
                       button_style='primary',
                       layout=Layout(width='150px', height='150px'))
                for word in button_tags]

    for btn in btn_list:
        btn.style.button_color = 'darkgreen'
        btn.on_click(_on_button_press)

    return btn_list


def _fetch_button_tags_and_args():
    args = {}
    img_seq = [cpufreq_img_1, cpufreq_img_2, cpufreq_img_3, cpufreq_img_4]
    with open(_mk_cpufreq_path('scaling_available_frequencies'), 'r') as sysfp:
        lines = [line for line in sysfp]
    tags = ['{0} MHz'.format(int(word)/1000) for word in lines[0].split()]
    for i, tag in enumerate(tags):
        args[tag] = [tag.split()[0].replace('.', ''), img_seq[i]]
    return tags, args


def run_demo():
    '''
        Demo entry point
    '''
    global button_tags, button_args, buttons, output_widget, cpu_monitor
    button_tags, button_args = _fetch_button_tags_and_args()
    buttons = _setup_buttons()
    output_widget = _setup_output_widget()
    cpu_monitor = _setup_cpu_monitor_widgets()
    buttons_vbox = _setup_buttons_container(buttons)
    display(buttons_vbox, output_widget, cpu_monitor)
